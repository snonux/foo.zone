# One reason why I love OpenBSD

> Published at 2024-01-13T22:55:33+02:00

```
           FISHKISSFISHKIS               
       SFISHKISSFISHKISSFISH            F
    ISHK   ISSFISHKISSFISHKISS         FI
  SHKISS   FISHKISSFISHKISSFISS       FIS
HKISSFISHKISSFISHKISSFISHKISSFISH    KISS
  FISHKISSFISHKISSFISHKISSFISHKISS  FISHK
      SSFISHKISSFISHKISSFISHKISSFISHKISSF
  ISHKISSFISHKISSFISHKISSFISHKISSF  ISHKI
SSFISHKISSFISHKISSFISHKISSFISHKIS    SFIS
  HKISSFISHKISSFISHKISSFISHKISS       FIS
    HKISSFISHKISSFISHKISSFISHK         IS
       SFISHKISSFISHKISSFISH            K
         ISSFISHKISSFISHK               
```

I just upgraded my OpenBSD's from `7.3` to `7.4` by following the unattended upgrade guide:

[https://www.openbsd.org/faq/upgrade74.html](https://www.openbsd.org/faq/upgrade74.html)  

```shell
$ doas installboot sd0 # Update the bootloader (not for every upgrade required)
$ doas sysupgrade # Update all binaries (including Kernel)
``` 

`sysupgrade` downloaded and upgraded to the next release and rebooted the system. After the reboot, I run:

```shell
$ doas sysmerge # Update system configuration files
$ doas pkg_add -u # Update all packages
$ doas reboot # Just in case, reboot one more time
```

That's it! Took me around 5 minutes in total! No issues, only these few comands, only 5 minutes! It just works! No problems, no conflicts, no tons (actually none) config file merge conflicts.

I followed the same procedure the previous times and never encountered any difficulties with any OpenBSD upgrades.

I have seen upgrades of other Operating Systems either take a long time or break the system (which takes manual steps to repair). That's just one of many reasons why I love OpenBSD! There appear never to be any problems. It just gets its job done!

[The OpenBSD Project](https://www.openbsd.org)  

BTW: are you looking for an opinionated OpenBSD VM hoster? OpenBSD Amsterdam may be for you. They rock (I am having a VM there, too)!

[https://openbsd.amsterdam](https://openbsd.amsterdam)  

E-Mail your comments to `paul@nospam.buetow.org` :-)

Other *BSD related posts are:

[2025-07-14 f3s: Kubernetes with FreeBSD - Part 6: Storage](./2025-07-14-f3s-kubernetes-with-freebsd-part-6.md)  
[2025-05-11 f3s: Kubernetes with FreeBSD - Part 5: WireGuard mesh network](./2025-05-11-f3s-kubernetes-with-freebsd-part-5.md)  
[2025-04-05 f3s: Kubernetes with FreeBSD - Part 4: Rocky Linux Bhyve VMs](./2025-04-05-f3s-kubernetes-with-freebsd-part-4.md)  
[2025-02-01 f3s: Kubernetes with FreeBSD - Part 3: Protecting from power cuts](./2025-02-01-f3s-kubernetes-with-freebsd-part-3.md)  
[2024-12-03 f3s: Kubernetes with FreeBSD - Part 2: Hardware and base installation](./2024-12-03-f3s-kubernetes-with-freebsd-part-2.md)  
[2024-11-17 f3s: Kubernetes with FreeBSD - Part 1: Setting the stage](./2024-11-17-f3s-kubernetes-with-freebsd-part-1.md)  
[2024-04-01 KISS high-availability with OpenBSD](./2024-04-01-KISS-high-availability-with-OpenBSD.md)  
[2024-01-13 One reason why I love OpenBSD (You are currently reading this)](./2024-01-13-one-reason-why-i-love-openbsd.md)  
[2022-10-30 Installing DTail on OpenBSD](./2022-10-30-installing-dtail-on-openbsd.md)  
[2022-07-30 Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  
[2016-04-09 Jails and ZFS with Puppet on FreeBSD](./2016-04-09-jails-and-zfs-on-freebsd-with-puppet.md)  

[Back to the main site](../)  
