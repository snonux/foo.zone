# Deploying an IPv6 Test Service on Kubernetes

## Introduction

This post covers deploying a simple IPv6/IPv4 connectivity test application to the f3s Kubernetes cluster. The application displays visitors' IP addresses and determines whether they're connecting via IPv6 or IPv4—useful for testing dual-stack connectivity.

The interesting technical challenge was preserving the original client IP address through multiple reverse proxies: from the OpenBSD relayd frontends, through Traefik ingress, to the Apache CGI backend.

=> ./2024-11-17-f3s-kubernetes-with-freebsd-part-1.gmi f3s series

## Architecture Overview

The request flow looks like this:

```
Client → relayd (OpenBSD) → Traefik (k3s) → Apache + CGI (Pod)
```

Each hop needs to preserve the client's real IP address via the `X-Forwarded-For` header.

## The Application

The application is a simple Perl CGI script that:

1. Detects whether the client is using IPv4 or IPv6
2. Performs DNS lookups on client and server addresses
3. Displays diagnostic information

```perl
#!/usr/bin/perl
use strict;
use warnings;

print "Content-type: text/html\n\n";

my $is_ipv4 = ($ENV{REMOTE_ADDR} =~ /(?:\d+\.){3}\d/);
print "You are using: " . ($is_ipv4 ? "IPv4" : "IPv6") . "\n";
print "Client address: $ENV{REMOTE_ADDR}\n";
```

## Docker Image

The Docker image uses Apache httpd with CGI and `mod_remoteip` enabled:

```dockerfile
FROM httpd:2.4-alpine

RUN apk add --no-cache perl bind-tools

# Enable CGI and remoteip modules
RUN sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/' \
      /usr/local/apache2/conf/httpd.conf && \
    sed -i 's/#LoadModule remoteip_module/LoadModule remoteip_module/' \
      /usr/local/apache2/conf/httpd.conf && \
    echo 'RemoteIPHeader X-Forwarded-For' >> /usr/local/apache2/conf/httpd.conf && \
    echo 'RemoteIPInternalProxy 10.0.0.0/8' >> /usr/local/apache2/conf/httpd.conf && \
    echo 'RemoteIPInternalProxy 192.168.0.0/16' >> /usr/local/apache2/conf/httpd.conf

COPY index.pl /usr/local/apache2/cgi-bin/index.pl
```

The key is `mod_remoteip`: it reads the `X-Forwarded-For` header and sets `REMOTE_ADDR` to the original client IP. The `RemoteIPInternalProxy` directives tell Apache which upstream proxies to trust.

## Kubernetes Deployment

The Helm chart is straightforward:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ipv6test
  namespace: services
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ipv6test
  template:
    spec:
      containers:
      - name: ipv6test
        image: registry.lan.buetow.org:30001/ipv6test:1.1.0
        ports:
        - containerPort: 80
```

## Configuring Traefik to Trust Forwarded Headers

By default, Traefik overwrites `X-Forwarded-For` with its own view of the client IP (which is the upstream proxy, not the real client). To preserve the original header, Traefik needs to trust the upstream proxies.

In k3s, this is configured via a HelmChartConfig:

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    additionalArguments:
      - "--entryPoints.web.forwardedHeaders.trustedIPs=192.168.0.0/16,10.0.0.0/8"
      - "--entryPoints.websecure.forwardedHeaders.trustedIPs=192.168.0.0/16,10.0.0.0/8"
```

This tells Traefik to trust `X-Forwarded-For` headers from the WireGuard tunnel IPs (where relayd connects from) and internal pod networks.

## Relayd Configuration

The OpenBSD relayd proxy already sets the `X-Forwarded-For` header:

```
http protocol "https" {
    match request header set "X-Forwarded-For" value "$REMOTE_ADDR"
    match request header set "X-Forwarded-Proto" value "https"
}
```

## IPv4-Only and IPv6-Only Subdomains

To properly test IPv4 and IPv6 connectivity separately, three hostnames are configured:

* ipv6test.f3s.buetow.org - Dual stack (A + AAAA records)
* ipv4.ipv6test.f3s.buetow.org - IPv4 only (A record only)
* ipv6.ipv6test.f3s.buetow.org - IPv6 only (AAAA record only)

The NSD zone template dynamically generates the correct record types:

```perl
<% for my $host (@$f3s_hosts) {
     my $is_ipv6_only = $host =~ /^ipv6\./;
     my $is_ipv4_only = $host =~ /^ipv4\./;
-%>
<% unless ($is_ipv6_only) { -%>
<%= $host %>.         300 IN A <%= $ips->{current_master}{ipv4} %>
<% } -%>
<% unless ($is_ipv4_only) { -%>
<%= $host %>.         300 IN AAAA <%= $ips->{current_master}{ipv6} %>
<% } -%>
<% } -%>
```

This ensures:
* Hosts starting with `ipv6.` get only AAAA records
* Hosts starting with `ipv4.` get only A records
* All other hosts get both A and AAAA records

The Kubernetes ingress handles all three hostnames, routing to the same backend service.

## TLS Certificates with Subject Alternative Names

Since Let's Encrypt validates domains via HTTP, the IPv6-only subdomain (`ipv6.ipv6test.f3s.buetow.org`) cannot be validated directly—Let's Encrypt's validation servers use IPv4. The solution is to include all subdomains as Subject Alternative Names (SANs) in the parent certificate.

The ACME client configuration template dynamically builds the SAN list:

```perl
<% for my $host (@$acme_hosts) {
     # Skip ipv4/ipv6 subdomains - they're included as SANs in parent cert
     next if $host =~ /^(ipv4|ipv6)\./;
-%>
<%   my @alt_names = ("www.$host");
     for my $sub_host (@$acme_hosts) {
         if ($sub_host =~ /^(ipv4|ipv6)\.\Q$host\E$/) {
             push @alt_names, $sub_host;
         }
     }
-%>
domain <%= $host %> {
    alternative names { <%= join(' ', @alt_names) %> }
    ...
}
<% } -%>
```

This generates a single certificate for `ipv6test.f3s.buetow.org` that includes:
* www.ipv6test.f3s.buetow.org
* ipv4.ipv6test.f3s.buetow.org
* ipv6.ipv6test.f3s.buetow.org

## DNS and TLS Deployment

The DNS records and ACME certificates are managed via Rex automation:

```perl
our @f3s_hosts = qw/
    ...
    ipv6test.f3s.buetow.org
    ipv4.ipv6test.f3s.buetow.org
    ipv6.ipv6test.f3s.buetow.org
/;

our @acme_hosts = qw/
    ...
    ipv6test.f3s.buetow.org
    ipv4.ipv6test.f3s.buetow.org
    ipv6.ipv6test.f3s.buetow.org
/;
```

Running `rex nsd httpd acme acme_invoke relayd` deploys the DNS zone, configures httpd for ACME challenges, obtains the certificates, and reloads relayd.

## Testing

Verify DNS records are correct:

```sh
$ dig ipv4.ipv6test.f3s.buetow.org A +short
46.23.94.99

$ dig ipv4.ipv6test.f3s.buetow.org AAAA +short
(no output - IPv4 only)

$ dig ipv6.ipv6test.f3s.buetow.org AAAA +short
2a03:6000:6f67:624::99

$ dig ipv6.ipv6test.f3s.buetow.org A +short
(no output - IPv6 only)
```

Verify the application shows the correct test type:

```sh
$ curl -s https://ipv4.ipv6test.f3s.buetow.org/cgi-bin/index.pl | grep "Test Results"
<h3>IPv4 Only Test Results:</h3>
```

The displayed IP should be the real client IP, not an internal cluster address.

## W3C Compliant HTML

The CGI script generates valid HTML5 that passes W3C validation. Key considerations:

* Proper DOCTYPE, charset, and lang attributes
* HTML-escaping command outputs (dig output contains `<<>>` characters)

```perl
sub html_escape {
    my $str = shift;
    $str =~ s/&/&amp;/g;
    $str =~ s/</&lt;/g;
    $str =~ s/>/&gt;/g;
    return $str;
}

my $digremote = html_escape(`dig -x $ENV{REMOTE_ADDR}`);
```

You can verify the output passes validation:

=> https://validator.w3.org/nu/?doc=https%3A%2F%2Fipv6test.f3s.buetow.org%2Fcgi-bin%2Findex.pl W3C Validator

## Summary

Preserving client IP addresses through multiple reverse proxies requires configuration at each layer:

1. **relayd**: Sets `X-Forwarded-For` header
2. **Traefik**: Trusts headers from known proxy IPs via `forwardedHeaders.trustedIPs`
3. **Apache**: Uses `mod_remoteip` to set `REMOTE_ADDR` from the header

Additional challenges solved:

* **TLS for IPv6-only hosts**: Use SANs to include all subdomains in a single certificate validated via the dual-stack parent domain
* **W3C compliance**: HTML-escape all command outputs to handle special characters

The configuration is managed via GitOps with ArgoCD, including the Traefik HelmChartConfig.

=> https://codeberg.org/snonux/ipv6test Source code
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/ipv6test Kubernetes manifests
=> https://codeberg.org/snonux/conf/src/branch/master/f3s/traefik-config Traefik configuration

E-Mail your comments to paul@paulbias.net :-)

=> ./index.gmi ← Back to the index
