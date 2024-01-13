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

=> https://www.openbsd.org/faq/upgrade74.html

```shell
doas installboot sd0 # Update the bootloader (not for every upgrade required)
doas sysupgrade # Update all binaries (including Kernel)
``` 

`sysupgrade` downloaded and upgraded to the next release and rebooted the system. After the reboot, I run:

```shell
doas sysmerge # Update system configuration files
doas pkg_add -u # Update all packages
doas reboot # Just in case, reboot one more time
```

That's it! Took me around 5 minutes in total! No issues, only these few comands, only 5 minutes! It just works! No problems, no conflicts, no tons (actually none) config file merge conflicts.

I followed the same procedure the previous times and never encountered any difficulties with any OpenBSD upgrades.

I have seen upgrades of other Operating Systems either take a long time or break the system (which takes manual steps to repair). That's just one of many reasons why I love OpenBSD! There appear never to be any problems. It just gets its job done!

=> https://www.openbsd.org  The OpenBSD Project

BTW: are you looking for an opinionated OpenBSD VM hoster? OpenBSD Amsterdam may be for you. They rock (I am having a VM there, too)!

=> https://openbsd.amsterdam

Other *BSD related posts are:

<< template::inline::index bsd

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
