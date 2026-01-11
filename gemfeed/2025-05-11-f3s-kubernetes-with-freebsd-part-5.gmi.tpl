# f3s: Kubernetes with FreeBSD - Part 5: WireGuard mesh network

> Published at 2025-05-11T11:35:57+03:00, last updated Sun 11 Jan 21:33:40 EET 2026

This is the fifth blog post about my f3s series for my self-hosting demands in my home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution I will use on FreeBSD-based physical machines.

I will post a new entry every month or so (there are too many other side projects for more frequent updates — I bet you can understand).

These are all the posts so far:

<< template::inline::index f3s

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

> ChatGPT generated logo.

Let's begin...

<< template::inline::toc

## Update: Roaming Client Support Added (January 2026)

**Note:** After publishing this blog post, two roaming clients were added to the WireGuard mesh: `earth` (Fedora laptop, 192.168.2.200) and `pixel7pro` (Android phone, 192.168.2.201). These clients connect exclusively to the two internet-facing OpenBSD gateways (`blowfish` and `fishfinger`) rather than participating in the full mesh.

Key changes implemented:

* **Client-only architecture**: Roaming clients initiate connections to gateways but are not reachable by LAN hosts (f0-f2, r0-r2)
* **All-traffic routing**: Both clients route all traffic (0.0.0.0/0) through the VPN for internet access
* **NAT masquerading**: OpenBSD gateways configured with PF NAT rules to allow roaming clients to access the internet
* **DNS configuration**: Roaming clients use Cloudflare (1.1.1.1) and Google (8.8.8.8) DNS servers
* **No automatic failover**: WireGuard does not support automatic failover by design. If one gateway fails, manual reconnection is required to switch to the backup gateway

The `earth` laptop is configured for manual VPN activation only (service disabled from auto-start), while the Android phone uses the official WireGuard Android client from the Google Play Store.

Infrastructure as Code updates:

* Added `/home/paul/git/conf/frontends/etc/pf.conf.tpl` with WireGuard NAT rules
* Added Rex deployment task for automated PF firewall configuration
* Modified `wireguardmeshgenerator.rb` to detect and handle roaming clients with proper PersistentKeepalive and AllowedIPs settings

For details on the implementation, see the planning document at `/home/paul/git/conf/f3s/wireguardroaming-plan.md` in the repository.

## Introduction

By default, traffic within my home LAN, including traffic inside a k3s cluster, is not encrypted. While it resides in the "secure" home LAN, adopting a zero-trust policy means encryption is still preferable to ensure confidentiality and security. So we decide to secure all the traffic of all f3s participating hosts by building a mesh network of all participating hosts:

=> ./f3s-kubernetes-with-freebsd-part-5/wireguard-full-mesh.svg Full mesh network

Whereas `f0`, `f1`, and `f2` are the FreeBSD base hosts, `r0`, `r1`, and `r2` are the Rocky Linux Bhyve VMs, and `blowfish` and `fishfinger` are two OpenBSD systems running on the internet (as mentioned in the first blog of this series—these systems are already built; in fact, this very blog is served by those OpenBSD systems).

**Update (January 2026):** Two roaming clients have been added to the setup: `earth` (Fedora laptop) and `pixel7pro` (Android phone). Unlike the full-mesh participants, these clients connect only to the two internet-facing gateways (`blowfish` and `fishfinger`) for internet access and are not reachable by the LAN hosts. See the update section above for details.

=> ./f3s-kubernetes-with-freebsd-part-5/wireguard-full-mesh-with-roaming.svg Updated mesh network with roaming clients

As we can see from the graphs, the original eight hosts form a true full-mesh network, where every host has a VPN tunnel to every other host. The benefit is that we do not need to route traffic through intermediate hosts (significantly simplifying the routing configuration). However, the downside is that there is some overhead in configuring and managing all the tunnels.

For simplicity, we also establish VPN tunnels between `f0 <-> r0`, `f1 <-> r1`, and `f2 <-> r2`. Technically, this wouldn't be strictly required since the VMs `rN` are running on the hosts `fN`, and no network traffic is leaving the box. However, it simplifies the configuration as we don't have to account for exceptions, and we are going to automate the mesh network configuration anyway (read on).

### Expected traffic flow

The traffic is expected to flow between the host groups through the mesh network as follows: 

* `fN <-> rN`: The traffic between the FreeBSD hosts and the Rocky Linux VMs will be routed through the VPN tunnels for persistent storage. In a later post in this series, we will set up an NFS server on the `fN` hosts. 
* `fN <-> blowfish,fishfinger`: The traffic between the FreeBSD hosts and the OpenBSD host `blowfish,fishfinger` will be routed through the VPN tunnels for management. We may want to log in via the internet to set it up remotely. The VPN tunnel will also be used for monitoring purposes.
* `rN <-> blowfish,fishfinger`: The traffic between the Rocky Linux VMs and the OpenBSD host `blowfish,fishfinger` will be routed through the VPN tunnels for usage traffic. Since k3s will be running on the `rN` hosts, the OpenBSD servers will route the traffic through `relayd` to the services running in Kubernetes.
* `fN <-> fM`: The traffic between the FreeBSD hosts may be later used for data replication for the NFS storage.
* `rN <-> rM`: The traffic between the Rocky Linux VMs will later be used by the k3s cluster itself, as every `rN` will be a Kubernetes worker node.
* `blowfish <-> fishfinger`: The traffic between the OpenBSD hosts isn't strictly required for this setup, but I set it up anyway for future use cases.

We won't cover all the details in this blog post, as we only focus on setting up the Mesh network in this blog post. Subsequent posts in this series will cover the other details.

## Deciding on WireGuard

I have decided to use WireGuard as the VPN technology for this purpose.

WireGuard is a lightweight, modern, and secure VPN protocol designed for simplicity, speed, and strong cryptography. It is an excellent choice due to its minimal codebase, ease of configuration, high performance, and robust security, utilizing state-of-the-art encryption standards. WireGuard is supported on various operating systems, and its implementations are compatible with each other. Therefore, establishing WireGuard VPN tunnels between FreeBSD, Linux, and OpenBSD is seamless. This cross-platform availability makes it suitable for setups like the one described in this blog series.

We could have used Tailscale for an easy to set up and manage the WireGuard network, but the benefits of creating our own mesh network are:

* Learning about WireGuard configuration details
* Have full control over the setup
* Don't rely on an external provider like Tailscale (even if some of the components are open-source)
* Have even more fun along the way
* WireGuard is easy to configure on my target operating systems and, therefore, easier to maintain in the long run.
* There are no official Tailscale packages available for OpenBSD and FreeBSD. However, getting Tailscale running on these systems is still possible, though some tinkering would be required. Instead, we use that tinkering time to set up WireGuard tunnels ourselves.

=> https://en.wikipedia.org/wiki/WireGuard
=> https://www.wireguard.com/
=> https://tailscale.com/

=> ./f3s-kubernetes-with-freebsd-part-5/wireguard.svg WireGuard Logo

## Base configuration

In the following, we prepare the base configuration for the WireGuard mesh network. We will use a similar configuration on all participating hosts, with the exception of the host IP addresses and the private keys.

### FreeBSD

On the FreeBSD hosts `f0`, `f1` and `f2`, similar as last time, first, we bring the system up to date:

```sh
paul@f0:~ % doas freebsd-update fetch
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas shutdown -r now
..
..
paul@f0:~ % doas pkg update
paul@f0:~ % doas pkg upgrade
paul@f0:~ % reboot
```

Next, we install `wireguard-tools` and configure the WireGuard service:

```sh
paul@f0:~ % doas pkg install wireguard-tools
paul@f0:~ % doas sysrc wireguard_interfaces=wg0
wireguard_interfaces:  -> wg0
paul@f0:~ % doas sysrc wireguard_enable=YES
wireguard_enable:  -> YES
paul@f0:~ % doas mkdir -p /usr/local/etc/wireguard
paul@f0:~ % doas touch /usr/local/etc/wireguard/wg0.conf
paul@f0:~ % doas service wireguard start
paul@f0:~ % doas wg show
interface: wg0
  public key: L+V9o0fNYkMVKNqsX7spBzD/9oSvxM/C7ZCZX1jLO3Q=
  private key: (hidden)
  listening port: 20246
``` 

We now have the WireGuard up and running, but it is not yet in any functional configuration. We will come back to that later.

Next, we add all the participating WireGuard IPs to the `hosts` file. This is only convenience, so we don't have to manage an external DNS server for this:

```sh
paul@f0:~ % cat <<END | doas tee -a /etc/hosts

192.168.1.120 r0 r0.lan r0.lan.buetow.org
192.168.1.121 r1 r1.lan r1.lan.buetow.org
192.168.1.122 r2 r2.lan r2.lan.buetow.org

192.168.2.130 f0.wg0 f0.wg0.wan.buetow.org
192.168.2.131 f1.wg0 f1.wg0.wan.buetow.org
192.168.2.132 f2.wg0 f2.wg0.wan.buetow.org

192.168.2.120 r0.wg0 r0.wg0.wan.buetow.org
192.168.2.121 r1.wg0 r1.wg0.wan.buetow.org
192.168.2.122 r2.wg0 r2.wg0.wan.buetow.org

192.168.2.110 blowfish.wg0 blowfish.wg0.wan.buetow.org
192.168.2.111 fishfinger.wg0 fishfinger.wg0.wan.buetow.org
END
```

As you can see, `192.168.1.0/24` is the network used in my LAN (with the `fN` and `rN` hosts) and `192.168.2.0/24` is the network used for the WireGuard mesh network. The `wg0` interface will be used for all WireGuard traffic.

### Rocky Linux

We bring the Rocky Linux VMs up to date as well with the following:

```sh
[root@r0 ~] dnf update -y
[root@r0 ~] reboot
```

Next, we prepare WireGuard on them. Same as on the FreeBSD hosts, we will only prepare WireGuard without any useful configuration yet:
	
```sh
[root@r0 ~] dnf install -y wireguard-tools
[root@r0 ~] mkdir -p /etc/wireguard
[root@r0 ~] touch /etc/wireguard/wg0.conf
[root@r0 ~] systemctl enable wg-quick@wg0.service
[root@r0 ~] systemctl start wg-quick@wg0.service
[root@r0 ~] systemctl disable firewalld
```

We also update the `hosts` file accordingly:

```sh
[root@r0 ~] cat <<END >>/etc/hosts

192.168.1.130 f0 f0.lan f0.lan.buetow.org
192.168.1.131 f1 f1.lan f1.lan.buetow.org
192.168.1.132 f2 f2.lan f2.lan.buetow.org

192.168.2.130 f0.wg0 f0.wg0.wan.buetow.org
192.168.2.131 f1.wg0 f1.wg0.wan.buetow.org
192.168.2.132 f2.wg0 f2.wg0.wan.buetow.org

192.168.2.120 r0.wg0 r0.wg0.wan.buetow.org
192.168.2.121 r1.wg0 r1.wg0.wan.buetow.org
192.168.2.122 r2.wg0 r2.wg0.wan.buetow.org

192.168.2.110 blowfish.wg0 blowfish.wg0.wan.buetow.org
192.168.2.111 fishfinger.wg0 fishfinger.wg0.wan.buetow.org
END
```

Unfortunately, the SELinux policy on Rocky Linux blocks WireGuard's operation. By making the `wireguard_t` domain permissive using `semanage permissive -a wireguard_t`, SELinux will no longer enforce restrictions for WireGuard, allowing it to work as intended:

```sh
[root@r0 ~] dnf install -y policycoreutils-python-utils
[root@r0 ~] semanage permissive -a wireguard_t
[root@r0 ~] reboot
```

=> https://github.com/angristan/wireguard-install/discussions/499

### OpenBSD

Other than the FreeBSD and Rocky Linux hosts involved, my OpenBSD hosts (`blowfish` and `fishfinger`, which are running at OpenBSD Amsterdam and Hetzner on the internet) have been running already for longer, so I can't provide you with the "from scratch" installation details here. In the following, we will only focus on the additional configuration needed to set up WireGuard:

```sh
blowfish$ doas pkg_add wireguard-tools
blowfish$ doas mkdir /etc/wireguard
blowfish$ doas touch /etc/wireguard/wg0.conf
blowsish$ cat <<END | doas tee /etc/hostname.wg0
inet 192.168.2.110 255.255.255.0 NONE
up
!/usr/local/bin/wg setconf wg0 /etc/wireguard/wg0.conf
END
```

Note that on `blowfish`, we configure `192.168.2.110` here in the `hostname.wg`, and on `fishfinger`, we configure `192.168.2.111`. Those are the IP addresses of the WireGuard interfaces on those hosts.

And here, we also update the `hosts` file accordingly:

```sh
blowfish$ cat <<END | doas tee -a /etc/hosts

192.168.2.130 f0.wg0 f0.wg0.wan.buetow.org
192.168.2.131 f1.wg0 f1.wg0.wan.buetow.org
192.168.2.132 f2.wg0 f2.wg0.wan.buetow.org

192.168.2.120 r0.wg0 r0.wg0.wan.buetow.org
192.168.2.121 r1.wg0 r1.wg0.wan.buetow.org
192.168.2.122 r2.wg0 r2.wg0.wan.buetow.org

192.168.2.110 blowfish.wg0 blowfish.wg0.wan.buetow.org
192.168.2.111 fishfinger.wg0 fishfinger.wg0.wan.buetow.org
END
```

## WireGuard configuration

So far, we have only started WireGuard on all participating hosts without any useful configuration. This means that no VPN tunnel has been established yet between any of the hosts.

### Example `wg0.conf`

Generally speaking, a `wg0.conf` looks like this (example from `f0` host):

```
[Interface]
# f0.wg0.wan.buetow.org
Address = 192.168.2.130
PrivateKey = **************************
ListenPort = 56709

[Peer]
# f1.lan.buetow.org as f1.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.131/32
Endpoint = 192.168.1.131:56709
# No KeepAlive configured

[Peer]
# f2.lan.buetow.org as f2.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.132/32
Endpoint = 192.168.1.132:56709
# No KeepAlive configured

[Peer]
# r0.lan.buetow.org as r0.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.120/32
Endpoint = 192.168.1.120:56709
# No KeepAlive configured

[Peer]
# r1.lan.buetow.org as r1.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.121/32
Endpoint = 192.168.1.121:56709
# No KeepAlive configured

[Peer]
# r2.lan.buetow.org as r2.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.122/32
Endpoint = 192.168.1.122:56709
# No KeepAlive configured

[Peer]
# blowfish.buetow.org as blowfish.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.110/32
Endpoint = 23.88.35.144:56709
PersistentKeepalive = 25

[Peer]
# fishfinger.buetow.org as fishfinger.wg0.wan.buetow.org
PublicKey = **************************
PresharedKey = **************************
AllowedIPs = 192.168.2.111/32
Endpoint = 46.23.94.99:56709
PersistentKeepalive = 25
```

Whereas there are two main sections. One is `[Interface]`, which configures the current host (here: `f0`):

* `Address`: Local virtual IP address on the WireGuard interface.
* `PrivateKey`: Private key for this node.
* `ListenPort`: Port on which this WireGuard interface listens for incoming connections.

And in the following, there is one `[Peer]` section for every peer node on the mesh network:

* `PublicKey`: The public key of the remote peer is used to authenticate their identity.
* `PresharedKey`: An optional symmetric key is used to enhance security (used in addition to PublicKey).
* `AllowedIPs`: IPs or subnets routed through this peer (traffic is allowed to/from these IPs).
* `Endpoint`: The public IP:port combination of the remote peer for connection.
* `PersistentKeepalive`: Keeps the tunnel alive by sending periodic packets; used for NAT traversal.

### NAT traversal and keepalive

As all participating hosts, except for `blowfish` and `fishfinger` (which are on the internet), are behind a NAT gateway (my home router), we need to use `PersistentKeepalive` to establish and maintain the VPN tunnel from the LAN to the internet because:

> By default, WireGuard tries to be as silent as possible when not being used; it is not a chatty protocol. For the most part, it only transmits data when a peer wishes to send packets. When it's not being asked to send packets, it stops sending packets until it is asked again. In the majority of configurations, this works well. However, when a peer is behind NAT or a firewall, it might wish to be able to receive incoming packets even when it is not sending any packets. Because NAT and stateful firewalls keep track of "connections", if a peer behind NAT or a firewall wishes to receive incoming packets, he must keep the NAT/firewall mapping valid, by periodically sending keepalive packets. This is called persistent keepalives. When this option is enabled, a keepalive packet is sent to the server endpoint once every interval seconds. A sensible interval that works with a wide variety of firewalls is 25 seconds. Setting it to 0 turns the feature off, which is the default, since most users will not need this, and it makes WireGuard slightly more chatty. This feature may be specified by adding the PersistentKeepalive = field to a peer in the configuration file, or setting persistent-keepalive at the command line. If you don't need this feature, don't enable it. But if you're behind NAT or a firewall and you want to receive incoming connections long after network traffic has gone silent, this option will keep the "connection" open in the eyes of NAT.

That's why you see `PersistentKeepAlive = 25` in the `blowfish` and `fishfinger` peer configurations. This means that every 25 seconds, a keep-alive signal is sent over the tunnel to maintain its connection. If the tunnel is not yet established, it will be created within 25 seconds latest.

Without this, we might never have a VPN tunnel open, as the systems in the LAN may not actively attempt to contact `blowfish` and `fishfinger` on their own. In fact, the opposite would likely occur, with the traffic flowing inward instead of outward (this is beyond the scope of this blog post but will be covered in a later post in this series!).

### Preshared key

In a WireGuard configuration, the PSK (preshared key) is an optional additional layer of symmetric encryption used alongside the standard public key cryptography. It is a shared secret known to both peers that enhances security by requiring an attacker to compromise both the private keys and the PSK to decrypt communication. While optional, using a PSK is better as it strengthens the cryptographic security, mitigating risks of potential vulnerabilities in the key exchange process.

So, because it's better, we are using it.

## Mesh network generator

Manually generating `wg0.conf` files for every peer in a mesh network setup is cumbersome because each peer requires its own unique public/private key pair and a preshared key for each VPN tunnel (resulting in 29 preshared keys for 8 hosts). This complexity scales almost exponentially with the number of peers as the relationships between all peers must be explicitly defined, including their unique configurations such as `AllowedIPs` and `Endpoint` and optional settings like `PersistentKeepalive`. Automating the process ensures consistency, reduces human error, saves considerable time, and allows for centralized management of configuration files.

Instead, a script can handle key generation, coordinate relationships, and generate all necessary configuration files simultaneously, making it scalable and far less error-prone.

I have written a Ruby script `wireguardmeshgenerator.rb` to do this for our purposes:

=> https://codeberg.org/snonux/wireguardmeshgenerator

I use Fedora Linux as my main driver on my personal Laptop, so the script was developed and tested only on Fedora Linux. However, it should also work on other Linux and Unix-like systems.

To set up the mesh generator on Fedora Linux, we run the following:

```sh
> git clone https://codeberg.org/snonux/wireguardmeshgenerator
> cd ./wireguardmeshgenerator
> bundle install
> sudo dnf install -y wireguard-tools
```

This assumes that Ruby and the `bundler` gem are already installed. If not, refer to the docs of your distribution.

### `wireguardmeshgenerator.yaml`

The file `wireguardmeshgenerator.yaml` configures the mesh generator script.

```
---
hosts:
  f0:
    os: FreeBSD
    ssh:
      user: paul
      conf_dir: /usr/local/etc/wireguard
      sudo_cmd: doas
      reload_cmd: service wireguard reload
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.130'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.130'
  f1:
    os: FreeBSD
    ssh:
      user: paul
      conf_dir: /usr/local/etc/wireguard
      sudo_cmd: doas
      reload_cmd: service wireguard reload
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.131'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.131'
  f2:
    os: FreeBSD
    ssh:
      user: paul
      conf_dir: /usr/local/etc/wireguard
      sudo_cmd: doas
      reload_cmd: service wireguard reload
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.132'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.132'
  r0:
    os: Linux
    ssh:
      user: root
      conf_dir: /etc/wireguard
      sudo_cmd:
      reload_cmd: systemctl reload wg-quick@wg0.service
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.120'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.120'
  r1:
    os: Linux
    ssh:
      user: root
      conf_dir: /etc/wireguard
      sudo_cmd:
      reload_cmd: systemctl reload wg-quick@wg0.service
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.121'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.121'
  r2:
    os: Linux
    ssh:
      user: root
      conf_dir: /etc/wireguard
      sudo_cmd:
      reload_cmd: systemctl reload wg-quick@wg0.service
    lan:
      domain: 'lan.buetow.org'
      ip: '192.168.1.122'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.122'
  blowfish:
    os: OpenBSD
    ssh:
      user: rex
      conf_dir: /etc/wireguard
      sudo_cmd: doas
      reload_cmd: sh /etc/netstart wg0
    internet:
      domain: 'buetow.org'
      ip: '23.88.35.144'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.110'
  fishfinger:
    os: OpenBSD
    ssh:
      user: rex
      conf_dir: /etc/wireguard
      sudo_cmd: doas
      reload_cmd: sh /etc/netstart wg0
    internet:
      domain: 'buetow.org'
      ip: '46.23.94.99'
    wg0:
      domain: 'wg0.wan.buetow.org'
      ip: '192.168.2.111'
```

The file specifies details such as SSH user settings, configuration directories, sudo or reload commands, and IP/domain assignments for both internal LAN-facing interfaces and WireGuard (`wg0`) interfaces. Each host is assigned specific roles, including internal participants and publicly accessible nodes with internet-facing IPs, enabling the creation of a fully connected mesh VPN.

### `wireguardmeshgenerator.rb` overview

The `wireguardmeshgenerator.rb` script consists of the following base classes:

* `KeyTool`: Manages WireGuard key generation and retrieval. It ensures the presence of public/private key pairs and preshared keys (PSKs). If keys are missing, it generates them using the `wg` tool. It provides methods to read the public/private keys and retrieve or generate a PSK for communication with a peer. The keys are stored in a temp directory on the system from where the generator is run.
* `PeerSnippet`: A `Struct` representing the configuration for a single WireGuard peer in the mesh. Based on the provided attributes and configuration, it generates the peer's WireGuard configuration, including public key, PSK, allowed IPs, endpoint, and keepalive settings.
* `WireguardConfig`: This function generates WireGuard configuration files for the specified host in the mesh network. It includes the `[Interface]` section for the host itself and the `[Peer]` sections for all other peers. It can also clean up generated files and directories and create the required directory structure for storing configuration files locally on the system from which the script is run.
* `InstallConfig`: Handles uploading, installing, and restarting the WireGuard service on remote hosts using SSH and SCP. It ensures the configuration file is uploaded to the remote machine, the necessary directories are present and correctly configured, and the WireGuard service reloads with the new configuration.

At the end (if you want to see the code for the stuff listed above, go to the Git repo and have a look), we glue it all together in this block:

```ruby
begin
  options = { hosts: [] }
  OptionParser.new do |opts|
    opts.banner = 'Usage: wireguardmeshgenerator.rb [options]'
    opts.on('--generate', 'Generate Wireguard configs') do
      options[:generate] = true
    end
    opts.on('--install', 'Install Wireguard configs') do
      options[:install] = true
    end
    opts.on('--clean', 'Clean Wireguard configs') do
      options[:clean] = true
    end
    opts.on('--hosts=HOSTS', 'Comma separated hosts to configure') do |hosts|
      options[:hosts] = hosts.split(',')
    end
  end.parse!

  conf = YAML.load_file('wireguardmeshgenerator.yaml').freeze
  conf['hosts'].keys.select { options[:hosts].empty? || options[:hosts].include?(_1) }
               .each do |host|
    # Generate Wireguard configuration for the host reload!
    WireguardConfig.new(host, conf['hosts']).generate! if options[:generate]
    # Install Wireguard configuration for the host.
    InstallConfig.new(host, conf['hosts']).upload!.install!.reload! if options[:install]
    # Clean Wireguard configuration for the host.
    WireguardConfig.new(host, conf['hosts']).clean! if options[:clean]
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  puts e.backtrace.join("\n")
  exit 2
end
```

And we also have a `Rakefile`:

```ruby
task :generate do
  ruby 'wireguardmeshgenerator.rb', '--generate'
end

task :clean do
  ruby 'wireguardmeshgenerator.rb', '--clean'
end

task :install do
  ruby 'wireguardmeshgenerator.rb', '--install'
end

task default: :generate
```


## Invoking the mesh network generator

### Generating the `wg0.conf` files and keys

To generate everything (the `wg0.conf` of all participating hosts, including all keys involved), we run the following:

```sh
> rake generate
/usr/bin/ruby wireguardmeshgenerator.rb --generate
Generating dist/f0/etc/wireguard/wg0.conf
Generating dist/f1/etc/wireguard/wg0.conf
Generating dist/f2/etc/wireguard/wg0.conf
Generating dist/r0/etc/wireguard/wg0.conf
Generating dist/r1/etc/wireguard/wg0.conf
Generating dist/r2/etc/wireguard/wg0.conf
Generating dist/blowfish/etc/wireguard/wg0.conf
Generating dist/fishfinger/etc/wireguard/wg0.conf
```

It generated all the `wg0.conf` files listed in the output, plus those keys:

```sh
> find keys/ -type f
keys/f0/priv.key
keys/f0/pub.key
keys/psk/f0_f1.key
keys/psk/f0_f2.key
keys/psk/f0_r0.key
keys/psk/f0_r1.key
keys/psk/f0_r2.key
keys/psk/blowfish_f0.key
keys/psk/f0_fishfinger.key
keys/psk/f1_f2.key
keys/psk/f1_r0.key
keys/psk/f1_r1.key
keys/psk/f1_r2.key
keys/psk/blowfish_f1.key
keys/psk/f1_fishfinger.key
keys/psk/f2_r0.key
keys/psk/f2_r1.key
keys/psk/f2_r2.key
keys/psk/blowfish_f2.key
keys/psk/f2_fishfinger.key
keys/psk/r0_r1.key
keys/psk/r0_r2.key
keys/psk/blowfish_r0.key
keys/psk/fishfinger_r0.key
keys/psk/r1_r2.key
keys/psk/blowfish_r1.key
keys/psk/fishfinger_r1.key
keys/psk/blowfish_r2.key
keys/psk/fishfinger_r2.key
keys/psk/blowfish_fishfinger.key
keys/f1/priv.key
keys/f1/pub.key
keys/f2/priv.key
keys/f2/pub.key
keys/r0/priv.key
keys/r0/pub.key
keys/r1/priv.key
keys/r1/pub.key
keys/r2/priv.key
keys/r2/pub.key
keys/blowfish/priv.key
keys/blowfish/pub.key
keys/fishfinger/priv.key
keys/fishfinger/pub.key
```

Those keys are embedded in the resulting `wg0.conf`, so later, we only need to install the `wg0.conf` files and not all the keys individually.

### Installing the `wg0.conf` files

Uploading the `wg0.conf` files to the participating hosts and reloading WireGuard on them is then just a matter of executing (this expects, that all participating hosts are up and running):

```sh
> rake install
/usr/bin/ruby wireguardmeshgenerator.rb --install
Uploading dist/f0/etc/wireguard/wg0.conf to f0.lan.buetow.org:.
Installing Wireguard config on f0
Uploading cmd.sh to f0.lan.buetow.org:.
+ [ ! -d /usr/local/etc/wireguard ]
+ doas chmod 700 /usr/local/etc/wireguard
+ doas mv -v wg0.conf /usr/local/etc/wireguard
wg0.conf -> /usr/local/etc/wireguard/wg0.conf
+ doas chmod 644 /usr/local/etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on f0
Uploading cmd.sh to f0.lan.buetow.org:.
+ doas service wireguard reload
+ rm cmd.sh
Uploading dist/f1/etc/wireguard/wg0.conf to f1.lan.buetow.org:.
Installing Wireguard config on f1
Uploading cmd.sh to f1.lan.buetow.org:.
+ [ ! -d /usr/local/etc/wireguard ]
+ doas chmod 700 /usr/local/etc/wireguard
+ doas mv -v wg0.conf /usr/local/etc/wireguard
wg0.conf -> /usr/local/etc/wireguard/wg0.conf
+ doas chmod 644 /usr/local/etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on f1
Uploading cmd.sh to f1.lan.buetow.org:.
+ doas service wireguard reload
+ rm cmd.sh
Uploading dist/f2/etc/wireguard/wg0.conf to f2.lan.buetow.org:.
Installing Wireguard config on f2
Uploading cmd.sh to f2.lan.buetow.org:.
+ [ ! -d /usr/local/etc/wireguard ]
+ doas chmod 700 /usr/local/etc/wireguard
+ doas mv -v wg0.conf /usr/local/etc/wireguard
wg0.conf -> /usr/local/etc/wireguard/wg0.conf
+ doas chmod 644 /usr/local/etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on f2
Uploading cmd.sh to f2.lan.buetow.org:.
+ doas service wireguard reload
+ rm cmd.sh
Uploading dist/r0/etc/wireguard/wg0.conf to r0.lan.buetow.org:.
Installing Wireguard config on r0
Uploading cmd.sh to r0.lan.buetow.org:.
+ '[' '!' -d /etc/wireguard ']'
+ chmod 700 /etc/wireguard
+ mv -v wg0.conf /etc/wireguard
renamed 'wg0.conf' -> '/etc/wireguard/wg0.conf'
+ chmod 644 /etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on r0
Uploading cmd.sh to r0.lan.buetow.org:.
+ systemctl reload wg-quick@wg0.service
+ rm cmd.sh
Uploading dist/r1/etc/wireguard/wg0.conf to r1.lan.buetow.org:.
Installing Wireguard config on r1
Uploading cmd.sh to r1.lan.buetow.org:.
+ '[' '!' -d /etc/wireguard ']'
+ chmod 700 /etc/wireguard
+ mv -v wg0.conf /etc/wireguard
renamed 'wg0.conf' -> '/etc/wireguard/wg0.conf'
+ chmod 644 /etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on r1
Uploading cmd.sh to r1.lan.buetow.org:.
+ systemctl reload wg-quick@wg0.service
+ rm cmd.sh
Uploading dist/r2/etc/wireguard/wg0.conf to r2.lan.buetow.org:.
Installing Wireguard config on r2
Uploading cmd.sh to r2.lan.buetow.org:.
+ '[' '!' -d /etc/wireguard ']'
+ chmod 700 /etc/wireguard
+ mv -v wg0.conf /etc/wireguard
renamed 'wg0.conf' -> '/etc/wireguard/wg0.conf'
+ chmod 644 /etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on r2
Uploading cmd.sh to r2.lan.buetow.org:.
+ systemctl reload wg-quick@wg0.service
+ rm cmd.sh
Uploading dist/blowfish/etc/wireguard/wg0.conf to blowfish.buetow.org:.
Installing Wireguard config on blowfish
Uploading cmd.sh to blowfish.buetow.org:.
+ [ ! -d /etc/wireguard ]
+ doas chmod 700 /etc/wireguard
+ doas mv -v wg0.conf /etc/wireguard
wg0.conf -> /etc/wireguard/wg0.conf
+ doas chmod 644 /etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on blowfish
Uploading cmd.sh to blowfish.buetow.org:.
+ doas sh /etc/netstart wg0
+ rm cmd.sh
Uploading dist/fishfinger/etc/wireguard/wg0.conf to fishfinger.buetow.org:.
Installing Wireguard config on fishfinger
Uploading cmd.sh to fishfinger.buetow.org:.
+ [ ! -d /etc/wireguard ]
+ doas chmod 700 /etc/wireguard
+ doas mv -v wg0.conf /etc/wireguard
wg0.conf -> /etc/wireguard/wg0.conf
+ doas chmod 644 /etc/wireguard/wg0.conf
+ rm cmd.sh
Reloading Wireguard on fishfinger
Uploading cmd.sh to fishfinger.buetow.org:.
+ doas sh /etc/netstart wg0
+ rm cmd.sh
```

### Re-generating mesh and installing the `wg0.conf` files again

The mesh network can be re-generated and re-installed as follows:

```sh
> rake clean
> rake generate
> rake install
```

That would also delete and re-generate all the keys involved.

## Happy WireGuard-ing

All is set up now. E.g. on `f0`:

```sh
paul@f0:~ % doas wg show
interface: wg0
  public key: Jm6YItMt94++dIeOyVi1I9AhNt2qQcryxCZezoX7X2Y=
  private key: (hidden)
  listening port: 56709

peer: 8PvGZH1NohHpZPVJyjhctBX9xblsNvYBhpg68FsFcns=
  preshared key: (hidden)
  endpoint: 46.23.94.99:56709
  allowed ips: 192.168.2.111/32
  latest handshake: 1 minute, 46 seconds ago
  transfer: 124 B received, 1.75 KiB sent
  persistent keepalive: every 25 seconds

peer: Xow+d3qVXgUMk4pcRSQ6Fe+vhYBa3VDyHX/4jrGoKns=
  preshared key: (hidden)
  endpoint: 23.88.35.144:56709
  allowed ips: 192.168.2.110/32
  latest handshake: 1 minute, 52 seconds ago
  transfer: 124 B received, 1.60 KiB sent
  persistent keepalive: every 25 seconds

peer: s3e93XoY7dPUQgLiVO4d8x/SRCFgEew+/wP7+zwgehI=
  preshared key: (hidden)
  endpoint: 192.168.1.120:56709
  allowed ips: 192.168.2.120/32

peer: 2htXdNcxzpI2FdPDJy4T4VGtm1wpMEQu1AkQHjNY6F8=
  preshared key: (hidden)
  endpoint: 192.168.1.131:56709
  allowed ips: 192.168.2.131/32

peer: 0Y/H20W8YIbF7DA1sMwMacLI8WS9yG+1/QO7m2oyllg=
  preshared key: (hidden)
  endpoint: 192.168.1.122:56709
  allowed ips: 192.168.2.122/32

peer: Hhy9kMPOOjChXV2RA5WeCGs+J0FE3rcNPDw/TLSn7i8=
  preshared key: (hidden)
  endpoint: 192.168.1.121:56709
  allowed ips: 192.168.2.121/32

peer: SlGVsACE1wiaRoGvCR3f7AuHfRS+1jjhS+YwEJ2HvF0=
  preshared key: (hidden)
  endpoint: 192.168.1.132:56709
  allowed ips: 192.168.2.132/32
```

All the hosts are pingable as well, e.g.:

```sh
paul@f0:~ % foreach peer ( f1 f2 r0 r1 r2 blowfish fishfinger )
foreach? ping -c2 $peer.wg0
foreach? echo
foreach? end
PING f1.wg0 (192.168.2.131): 56 data bytes
64 bytes from 192.168.2.131: icmp_seq=0 ttl=64 time=0.334 ms
64 bytes from 192.168.2.131: icmp_seq=1 ttl=64 time=0.260 ms

--- f1.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.260/0.297/0.334/0.037 ms

PING f2.wg0 (192.168.2.132): 56 data bytes
64 bytes from 192.168.2.132: icmp_seq=0 ttl=64 time=0.323 ms
64 bytes from 192.168.2.132: icmp_seq=1 ttl=64 time=0.303 ms

--- f2.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.303/0.313/0.323/0.010 ms

PING r0.wg0 (192.168.2.120): 56 data bytes
64 bytes from 192.168.2.120: icmp_seq=0 ttl=64 time=0.716 ms
64 bytes from 192.168.2.120: icmp_seq=1 ttl=64 time=0.406 ms

--- r0.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.406/0.561/0.716/0.155 ms

PING r1.wg0 (192.168.2.121): 56 data bytes
64 bytes from 192.168.2.121: icmp_seq=0 ttl=64 time=0.639 ms
64 bytes from 192.168.2.121: icmp_seq=1 ttl=64 time=0.629 ms

--- r1.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.629/0.634/0.639/0.005 ms

PING r2.wg0 (192.168.2.122): 56 data bytes
64 bytes from 192.168.2.122: icmp_seq=0 ttl=64 time=0.569 ms
64 bytes from 192.168.2.122: icmp_seq=1 ttl=64 time=0.479 ms

--- r2.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.479/0.524/0.569/0.045 ms

PING blowfish.wg0 (192.168.2.110): 56 data bytes
64 bytes from 192.168.2.110: icmp_seq=0 ttl=255 time=35.745 ms
64 bytes from 192.168.2.110: icmp_seq=1 ttl=255 time=35.481 ms

--- blowfish.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 35.481/35.613/35.745/0.132 ms

PING fishfinger.wg0 (192.168.2.111): 56 data bytes
64 bytes from 192.168.2.111: icmp_seq=0 ttl=255 time=33.992 ms
64 bytes from 192.168.2.111: icmp_seq=1 ttl=255 time=33.751 ms

--- fishfinger.wg0 ping statistics ---
2 packets transmitted, 2 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 33.751/33.872/33.992/0.120 ms
```

Note that the loop above is a `tcsh` loop, the default shell used in FreeBSD. Of course, all other peers can ping their peers as well!

After the first ping, VPN tunnels now also show handshakes and the amount of data transferred through them:

```sh
paul@f0:~ % doas wg show
interface: wg0
  public key: Jm6YItMt94++dIeOyVi1I9AhNt2qQcryxCZezoX7X2Y=
  private key: (hidden)
  listening port: 56709

peer: 0Y/H20W8YIbF7DA1sMwMacLI8WS9yG+1/QO7m2oyllg=
  preshared key: (hidden)
  endpoint: 192.168.1.122:56709
  allowed ips: 192.168.2.122/32
  latest handshake: 10 seconds ago
  transfer: 440 B received, 532 B sent

peer: Hhy9kMPOOjChXV2RA5WeCGs+J0FE3rcNPDw/TLSn7i8=
  preshared key: (hidden)
  endpoint: 192.168.1.121:56709
  allowed ips: 192.168.2.121/32
  latest handshake: 12 seconds ago
  transfer: 440 B received, 564 B sent

peer: s3e93XoY7dPUQgLiVO4d8x/SRCFgEew+/wP7+zwgehI=
  preshared key: (hidden)
  endpoint: 192.168.1.120:56709
  allowed ips: 192.168.2.120/32
  latest handshake: 14 seconds ago
  transfer: 440 B received, 564 B sent

peer: SlGVsACE1wiaRoGvCR3f7AuHfRS+1jjhS+YwEJ2HvF0=
  preshared key: (hidden)
  endpoint: 192.168.1.132:56709
  allowed ips: 192.168.2.132/32
  latest handshake: 17 seconds ago
  transfer: 472 B received, 564 B sent

peer: Xow+d3qVXgUMk4pcRSQ6Fe+vhYBa3VDyHX/4jrGoKns=
  preshared key: (hidden)
  endpoint: 23.88.35.144:56709
  allowed ips: 192.168.2.110/32
  latest handshake: 55 seconds ago
  transfer: 472 B received, 596 B sent
  persistent keepalive: every 25 seconds

peer: 8PvGZH1NohHpZPVJyjhctBX9xblsNvYBhpg68FsFcns=
  preshared key: (hidden)
  endpoint: 46.23.94.99:56709
  allowed ips: 192.168.2.111/32
  latest handshake: 55 seconds ago
  transfer: 472 B received, 596 B sent
  persistent keepalive: every 25 seconds

peer: 2htXdNcxzpI2FdPDJy4T4VGtm1wpMEQu1AkQHjNY6F8=
  preshared key: (hidden)
  endpoint: 192.168.1.131:56709
  allowed ips: 192.168.2.131/32
```

## Adding Roaming Clients (Update: January 2026)

After setting up the full-mesh network for the infrastructure hosts, two roaming clients were added to enable remote VPN access: a Fedora laptop (`earth`) and an Android phone (`pixel7pro`).

### Design Decisions

Unlike the full-mesh participants, roaming clients:

* **Connect only to internet gateways**: Both clients peer exclusively with `blowfish` and `fishfinger`, not with LAN hosts
* **Route all traffic through VPN**: AllowedIPs set to `0.0.0.0/0, ::/0` for complete internet access through the VPN
* **Cannot be reached by LAN hosts**: Using `exclude_peers` configuration to prevent LAN hosts from initiating connections to roaming clients
* **Maintain persistent keepalive**: PersistentKeepalive set to 25 seconds on all peer connections to maintain NAT traversal

### WireGuard Mesh Generator Modifications

The Ruby-based mesh generator (`wireguardmeshgenerator.rb`) was enhanced to detect and handle roaming clients:

```ruby
# Detect roaming clients (hosts without 'lan' or 'internet' sections)
is_roaming = !hosts[myself].key?('lan') && !hosts[myself].key?('internet')

# Enable keepalive for roaming clients
keepalive = is_roaming || (in_lan && !peer_in_lan)

# Route all traffic for roaming clients
allowed_ips = is_roaming ? '0.0.0.0/0, ::/0' : data['wg0']['ip']

# Configure DNS for roaming clients
dns = is_roaming ? 'DNS = 1.1.1.1, 8.8.8.8' : '# No DNS configured'
```

The YAML configuration for `pixel7pro` looks like this:

```yaml
pixel7pro:
  os: Android
  wg0:
    domain: 'wg0.wan.buetow.org'
    ip: '192.168.2.201'
  exclude_peers:
    - f0
    - f1
    - f2
    - r0
    - r1
    - r2
    - earth
```

Note the absence of `lan` and `internet` sections, which identifies it as a roaming client.

### OpenBSD Gateway Configuration

To enable internet access for roaming clients, NAT rules were added to the PF firewall on both OpenBSD gateways:

```
# NAT for WireGuard clients to access internet
match out on vio0 from 192.168.2.0/24 to any nat-to (vio0)

# Allow inbound traffic on WireGuard interface
pass in on wg0

# Allow all UDP traffic on WireGuard port
pass in inet proto udp from any to any port 56709
```

These rules are deployed via Infrastructure as Code using Rex (a Perl-based deployment tool):

```sh
$ cd /home/paul/git/conf/frontends
$ rex pf  # Deploys /etc/pf.conf to both blowfish and fishfinger
```

### Client Setup

**Android (`pixel7pro`):**

The official WireGuard Android app from the Google Play Store was used. The configuration was transferred by generating a QR code:

```sh
$ cd /home/paul/git/wireguardmeshgenerator
$ qrencode -t ansiutf8 < dist/pixel7pro/etc/wireguard/wg0.conf
```

The generated config contains both gateways with all-traffic routing:

```
[Interface]
Address = 192.168.2.201
PrivateKey = [hidden]
ListenPort = 56709
DNS = 1.1.1.1, 8.8.8.8

[Peer]  # blowfish
PublicKey = Xow+d3qVXgUMk4pcRSQ6Fe+vhYBa3VDyHX/4jrGoKns=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = 23.88.35.144:56709
PersistentKeepalive = 25

[Peer]  # fishfinger
PublicKey = 8PvGZH1NohHpZPVJyjhctBX9xblsNvYBhpg68FsFcns=
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = 46.23.94.99:56709
PersistentKeepalive = 25
```

**Fedora laptop (`earth`):**

WireGuard was installed and configured for manual activation only:

```sh
$ sudo dnf install wireguard-tools
$ sudo cp dist/earth/etc/wireguard/wg0.conf /etc/wireguard/
$ sudo chmod 600 /etc/wireguard/wg0.conf
$ sudo systemctl disable wg-quick@wg0.service  # Prevent auto-start
$ sudo systemctl start wg-quick@wg0.service    # Manual start when needed
```

### Failover Limitation

**Important:** WireGuard does not support automatic failover between peers. When both gateways are configured with `AllowedIPs = 0.0.0.0/0`, the client establishes a connection to one peer and remains "sticky" to that peer.

Testing showed that when the active gateway (`fishfinger`) was stopped, the phone did not automatically switch to the backup gateway (`blowfish`). This is by design—WireGuard prioritizes simplicity over complex failover logic.

For automatic failover, manual reconnection or external monitoring scripts would be required. For interactive use (phones, laptops), manual reconnection when connectivity issues arise is acceptable.

### Verification

On the phone, connectivity was verified by:

* Checking the WireGuard app shows active tunnel with recent handshakes
* Accessing `https://ifconfig.me` shows the gateway's public IP address
* DNS resolution working correctly

On the gateways, roaming clients can be monitored:

```sh
$ doas wg show | grep -A 6 pixel7pro_public_key
peer: Asuktmb7fuqaiEucOstuC1g6rQaleubXk9pdTfjtbUs=
  preshared key: (hidden)
  endpoint: 90.154.200.247:49511
  allowed ips: 192.168.2.201/32
  latest handshake: 2 minutes, 15 seconds ago
  transfer: 45.12 KiB received, 52.33 KiB sent
  persistent keepalive: every 25 seconds
```

## Conclusion

Having a mesh network on our hosts is great for securing all the traffic between them for our future k3s setup. A self-managed WireGuard mesh network is better than Tailscale as it eliminates reliance on a third party and provides full control over the configuration. It reduces unnecessary abstraction and "magic," enabling easier debugging and ensuring full ownership of our network.

Read the next post of this series:

=> ./2025-07-14-f3s-kubernetes-with-freebsd-part-6.gmi f3s: Kubernetes with FreeBSD - Part 6: Storage

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
