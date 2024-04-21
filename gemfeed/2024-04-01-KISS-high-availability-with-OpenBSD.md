# KISS high-availability with OpenBSD

> Published at 2024-03-30T22:12:56+02:00

```
Art by Michael J. Penick (mod. by Paul B.)
                                               ACME-sky
        __________
       / nsd tower\                                             (
      /____________\                                           (\) awk-ward
       |:_:_:_:_:_|                                             ))   plant
       |_:_,--.:_:|                       dig-bubble         (\//   )
       |:_:|__|_:_|  relayd-castle          _               ) ))   ((
    _  |_   _  :_:|   _   _   _            (_)             ((((   /)\`
   | |_| |_| |   _|  | |_| |_| |             o              \\)) (( (
    \_:_:_:_:/|_|_|_|\:_:_:_:_/             .                ((   ))))
     |_,-._:_:_:_:_:_:_:_.-,_|                                )) ((//
     |:|_|:_:_:,---,:_:_:|_|:|                               ,-.  )/
     |_:_:_:_,'puffy `,_:_:_:_|           _  o               ,;'))((
     |:_:_:_/  _ | _  \_:_:_:|          (_O                   ((  ))
_____|_:_:_|  (o)-(o)  |_:_:_|--'`-.     ,--. ksh under-water (((\'/
 ', ;|:_:_:| -( .-. )- |:_:_:| ', ; `--._\  /,---.~  goat     \`))
.  ` |_:_:_|   \`-'/   |_:_:_|.  ` .  `  /()\.__( ) .,-----'`-\(( sed-root
 ', ;|:_:_:|    `-'    |:_:_:| ', ; ', ; `--'|   \ ', ; ', ; ',')).,--
.  ` MJP ` .  ` .  ` .  ` . httpd-soil ` .    .  ` .  ` .  ` .  ` .  `
 ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ; ', ;

```

```
Table of contents:
    KISS high-availability with OpenBSD
        My auto-failover requirements
        My HA solution
            Only OpenBSD base installation required
   !/bin/ksh
    Race condition (e.g. script execution aborted in the middle of the previous run)
            Fairly cheap and geo-redundant
            Failover time and split-brain
            Failover support for multiple protocols
            Let's encrypt TLS certificates
    Weekly auto-failover for Let's Encrypt automation
            Monitoring
            Rex automation
        More HA
```

I have always wanted a highly available setup for my personal websites. I could have used off-the-shelf hosting solutions or hosted my sites in an AWS S3 bucket. I have used technologies like (in unsorted and slightly unrelated order) BGP, LVS/IPVS, ldirectord, Pacemaker, STONITH, scripted VIP failover via ARP, heartbeat, heartbeat2, Corosync, keepalived, DRBD, and commercial F5 Load Balancers for high availability at work. 

But still, my personal sites were never highly available. All those technologies are great for professional use, but I was looking for something much more straightforward for my personal space - something as KISS (keep it simple and stupid) as possible.

It would be fine if my personal website wasn't highly available, but the geek in me wants it anyway.

> PS: ASCII-art reflects an OpenBSD under-water world with all the tools available in the base system.

## My auto-failover requirements

* Be OpenBSD-based (I prefer OpenBSD because of the cleanliness and good documentation) and rely on as few external packages as possible. 
* Don't rely on the hottest and newest tech (don't want to migrate everything to a new and fancier technology next month already!).
* It should be reasonably cheap. I want to avoid paying a premium for floating IPs or fancy Elastic Load Balancers.
* It should be geo-redundant. 
* It's fine if my sites aren't reachable for five or ten minutes every other month. Due to their static nature, I don't care if there's a split-brain scenario where some requests reach one server and other requests reach another server.
* Failover should work for both HTTP/HTTPS and Gemini protocols. My self-hosted MTAs and DNS servers should also be highly available.
* Let's Encrypt TLS certificates should always work (before and after a failover).
* Have good monitoring in place so I know when a failover was performed and when something went wrong with the failover.
* Don't configure everything manually. The configuration should be automated and reproducible.

## My HA solution

### Only OpenBSD base installation required

My HA solution for Web and Gemini is based on DNS (OpenBSD's `nsd`) and a simple shell script (OpenBSD's `ksh` and some little `sed` and `awk` and `grep`). All software used here is part of the OpenBSD base system and no external package needs to be installed - OpenBSD is a complete operating system.

[https://man.OpenBSD.org/nsd.8](https://man.OpenBSD.org/nsd.8)  
[https://man.OpenBSD.org/ksh](https://man.OpenBSD.org/ksh)  
[https://man.OpenBSD.org/awk](https://man.OpenBSD.org/awk)  
[https://man.OpenBSD.org/sed](https://man.OpenBSD.org/sed)  
[https://man.OpenBSD.org/dig](https://man.OpenBSD.org/dig)  
[https://man.OpenBSD.org/ftp](https://man.OpenBSD.org/ftp)  
[https://man.OpenBSD.org/cron](https://man.OpenBSD.org/cron)  

I also used the `dig` (for DNS checks) and `ftp` (for HTTP/HTTPS checks) programs. 

The DNS failover is performed automatically between the two OpenBSD VMs involved (my setup doesn't require any quorum for a failover, so there isn't a need for a 3rd VM). The `ksh` script, executed once per minute via CRON (on both VMs), performs a health check to determine whether the current master node is available. If the current master isn't available (no HTTP response as expected), a failover is performed to the standby VM: 

```sh
#!/bin/ksh

ZONES_DIR=/var/nsd/zones/master/
DEFAULT_MASTER=fishfinger.buetow.org
DEFAULT_STANDBY=blowfish.buetow.org

determine_master_and_standby () {
    local master=$DEFAULT_MASTER
    local standby=$DEFAULT_STANDBY

    .
    .
    .
    
    local -i health_ok=1
    if ! ftp -4 -o - https://$master/index.txt | grep -q "Welcome to $master"; then
        echo "https://$master/index.txt IPv4 health check failed"
        health_ok=0
    elif ! ftp -6 -o - https://$master/index.txt | grep -q "Welcome to $master"; then
        echo "https://$master/index.txt IPv6 health check failed"
        health_ok=0
    fi
    if [ $health_ok -eq 0 ]; then
        local tmp=$master
        master=$standby
        standby=$tmp
    fi

    .
    .
    .
}
```

The failover scripts looks for the ` ; Enable failover` string in the DNS zone files and swaps the `A` and `AAAA` records of the DNS entries accordingly:

```sh
fishfinger$ grep failover /var/nsd/zones/master/foo.zone.zone
        300 IN A 46.23.94.99 ; Enable failover
        300 IN AAAA 2a03:6000:6f67:624::99 ; Enable failover
www     300 IN A 46.23.94.99 ; Enable failover
www     300 IN AAAA 2a03:6000:6f67:624::99 ; Enable failover
standby  300 IN A 23.88.35.144 ; Enable failover
standby  300 IN AAAA 2a01:4f8:c17:20f1::42 ; Enable failover
```

```sh
transform () {
  sed -E '
	/IN A .*; Enable failover/ {
	    /^standby/! {
	        s/^(.*) 300 IN A (.*) ; (.*)/\1 300 IN A '$(cat /var/nsd/run/master_a)' ; \3/;
	    }
	    /^standby/ {
	        s/^(.*) 300 IN A (.*) ; (.*)/\1 300 IN A '$(cat /var/nsd/run/standby_a)' ; \3/;
	    }
	}
	/IN AAAA .*; Enable failover/ {
	    /^standby/! {
	        s/^(.*) 300 IN AAAA (.*) ; (.*)/\1 300 IN AAAA '$(cat /var/nsd/run/master_aaaa)' ; \3/;
	    }
	    /^standby/ {
	        s/^(.*) 300 IN AAAA (.*) ; (.*)/\1 300 IN AAAA '$(cat /var/nsd/run/standby_aaaa)' ; \3/;
	    }
	}
	/ ; serial/ {
	    s/^( +) ([0-9]+) .*; (.*)/\1 '$(date +%s)' ; \3/;
	}
  '
}
```

After the failover, the script reloads `nsd` and performs a sanity check to see if DNS still works. If not, a rollback will be performed:

```sh
# Race condition (e.g. script execution aborted in the middle of the previous run)
if [ -f $zone_file.bak ]; then
    mv $zone_file.bak $zone_file
fi

cat $zone_file | transform > $zone_file.new.tmp 

grep -v ' ; serial' $zone_file.new.tmp > $zone_file.new.noserial.tmp
grep -v ' ; serial' $zone_file > $zone_file.old.noserial.tmp

echo "Has zone $zone_file changed?"
if diff -u $zone_file.old.noserial.tmp $zone_file.new.noserial.tmp; then
    echo "The zone $zone_file hasn't changed"
    rm $zone_file.*.tmp
    return 0
fi

cp $zone_file $zone_file.bak
mv $zone_file.new.tmp $zone_file
rm $zone_file.*.tmp
echo "Reloading nsd"
nsd-control reload

if ! zone_is_ok $zone; then
    echo "Rolling back $zone_file changes"
    cp $zone_file $zone_file.invalid
    mv $zone_file.bak $zone_file
    echo "Reloading nsd"
    nsd-control reload
    zone_is_ok $zone
    return 3
fi

for cleanup in invalid bak; do
    if [ -f $zone_file.$cleanup ]; then
        rm $zone_file.$cleanup
    fi
done

echo "Failover of zone $zone to $MASTER completed"
return 1
```

A non-zero return code (here, 3 when a rollback and 1 when a DNS failover was performed) will cause CRON to send an E-Mail with the whole script output.

The authorative nameserver for my domains runs on both VMs, and both are configured to be a "master" DNS server so that they have their own individual zone files, which can be changed independently. Otherwise, my setup wouldn't work. The side effect is that under a split-brain scenario (both VMs cannot see each other), both would promote themselves to master via their local DNS entries. More about that later, but that's fine in my use case.

Check out the whole script here:

[dns-failover.ksh](https://codeberg.org/snonux/rexfiles/src/branch/master/frontends/scripts/dns-failover.ksh)  

### Fairly cheap and geo-redundant

I am renting two small OpenBSD VMs: One at OpenBSD Amsterdam and the other at Hetzner Cloud. So, both VMs are hosted at another provider, in different IP subnets, and in different countries (the Netherlands and Germany).

[https://OpenBSD.Amsterdam](https://OpenBSD.Amsterdam)  
[https://www.Hetzner.cloud](https://www.Hetzner.cloud)  

I only have a little traffic on my sites. I could always upload the static content to AWS S3 if I suddenly had to. But this will never be required.

A DNS-based failover is cheap, as there isn't any BGP or fancy load balancer to pay for. Small VMs also cost less than millions.

### Failover time and split-brain

A DNS failover doesn't happen immediately. I've configured a DNS TTL of `300` seconds, and the failover script checks once per minute whether to perform a failover or not. So, in total, a failover can take six minutes (not including other DNS caching servers somewhere in the interweb, but that's fine - eventually, all requests will resolve to the new master after a failover).

A split-brain scenario between the old master and the new master might happen. That's OK, as my sites are static, and there's no database to synchronise other than HTML, CSS, and images when the site is updated.

### Failover support for multiple protocols

With the DNS failover, HTTP, HTTPS, and Gemini protocols are failovered. This works because all domain virtual hosts are configured on either VM's `httpd` (OpenBSD's HTTP server) and `relayd` (it's also part of OpenBSD and I use it to TLS offload the Gemini protocol). So, both VMs accept requests for all the hosts. It's just a matter of the DNS entries, which VM receives the requests.

[https://man.OpenBSD.org/httpd.8](https://man.OpenBSD.org/httpd.8)  
[https://man.OpenBSD.org/relayd.8](https://man.OpenBSD.org/relayd.8)  

For example, the master is responsible for the `https://www.foo.zone` and `https://foo.zone` hosts, whereas the standby can be reached via `https://standby.foo.zone` (port 80 for plain HTTP works as well). The same principle is followed with all the other hosts, e.g. `irregular.ninja`, `paul.buetow.org` and so on. The same applies to my Gemini capsules for `gemini://foo.zone`, `gemini://standby.foo.zone`, `gemini://paul.buetow.org` and `gemini://standby.paul.buetow.org`.

On DNS failover, master and standby swap roles without config changes other than the DNS entries. That's KISS (keep it simple and stupid)!

### Let's encrypt TLS certificates

All my hosts use TLS certificates from Let's Encrypt. The ACME automation for requesting and keeping the certificates valid (up to date) requires that the host requesting a certificate from Let's Encrypt is also the host using that certificate.

If the master always serves `foo.zone` and the standby always `standby.foo.zone`, then there would be a problem after the failover, as the new master wouldn't have a valid certificate for `foo.zone` and the new standby wouldn't have a valid certificate for `standby.foo.zone` which would lead to TLS errors on the clients.

As a solution, the CRON job responsible for the DNS failover also checks for the current week number of the year so that:

* In an odd week number, the first server is the default master
* In an even week number, the second server is the default master.

Which translates to:

```sh
# Weekly auto-failover for Let's Encrypt automation
local -i -r week_of_the_year=$(date +%U)
if [ $(( week_of_the_year % 2 )) -eq 0 ]; then
    local tmp=$master
    master=$standby
    standby=$tmp
fi
```

This way, a DNS failover is performed weekly so that the ACME automation can update the Let's Encrypt certificates (for master and standby) before they expire on each VM.

The ACME automation is yet another daily CRON script `/usr/local/bin/acme.sh`. It iterates over all of my Let's Encrypt hosts, checks whether they resolve to the same IP address as the current VM, and only then invokes the ACME client to request or renew the TLS certificates. So, there are always correct requests made to Let's Encrypt. 

Let's encrypt certificates usually expire after 3 months, so a weekly failover of my VMs is plenty.

[`acme.sh.tpl` - Rex template for the `acme.sh` script of mine.](https://codeberg.org/snonux/rexfiles/src/branch/master/frontends/scripts/acme.sh.tpl)  
[https://man.OpenBSD.org/acme-client.1](https://man.OpenBSD.org/acme-client.1)  
[Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  

### Monitoring

CRON is sending me an E-Mail whenever a failover is performed (or whenever a failover failed). Furthermore, I am monitoring my DNS servers and hosts through Gogios, the monitoring system I have developed. 

[https://codeberg.org/snonux/gogios](https://codeberg.org/snonux/gogios)  
[KISS server monitoring with Gogios](./2023-06-01-kiss-server-monitoring-with-gogios.md)  

Gogios, as I developed it by myself, isn't part of the OpenBSD base system. 

### Rex automation

I use Rexify, a friendly configuration management system that allows automatic deployment and configuration.

[https://www.rexify.org](https://www.rexify.org)  
[codeberg.org/snonux/rexfiles/frontends](https://codeberg.org/snonux/rexfiles/src/branch/master/frontends)  

Rex isn't part of the OpenBSD base system, but I didn't need to install any external software on OpenBSD either as Rex is invoked from my Laptop!

## More HA

Other high-available services running on my OpenBSD VMs are my MTAs for mail forwarding (OpenSMTPD - also part of the OpenBSD base system) and the authoritative DNS servers (`nsd`) for all my domains. No particular HA setup is required, though, as the protocols (SMTP and DNS) already take care of the failover to the next available host! 

[https://www.OpenSMTPD.org/](https://www.OpenSMTPD.org/)  

As a password manager, I use `geheim`, a command-line tool I wrote in Ruby with encrypted files in a git repository (I even have it installed in Termux on my Phone). For HA reasons, I simply updated the client code so that it always synchronises the database with both servers when I run the `sync` command there. 

[https://codeberg.org/snonux/geheim](https://codeberg.org/snonux/geheim)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other *BSD and KISS related posts are:

[2016-04-09 Jails and ZFS with Puppet on FreeBSD](./2016-04-09-jails-and-zfs-on-freebsd-with-puppet.md)  
[2022-07-30 Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  
[2022-10-30 Installing DTail on OpenBSD](./2022-10-30-installing-dtail-on-openbsd.md)  
[2023-06-01 KISS server monitoring with Gogios](./2023-06-01-kiss-server-monitoring-with-gogios.md)  
[2023-10-29 KISS static web photo albums with `photoalbum.sh`](./2023-10-29-kiss-static-web-photo-albums-with-photoalbum.sh.md)  
[2024-01-13 One reason why I love OpenBSD](./2024-01-13-one-reason-why-i-love-openbsd.md)  
[2024-04-01 KISS high-availability with OpenBSD (You are currently reading this)](./2024-04-01-KISS-high-availability-with-OpenBSD.md)  

[Back to the main site](../)  
