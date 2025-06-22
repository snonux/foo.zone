# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-04-04T23:21:01+03:00

This is the sixth blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

[2024-11-17 f3s: Kubernetes with FreeBSD - Part 1: Setting the stage](./2024-11-17-f3s-kubernetes-with-freebsd-part-1.md)  
[2024-12-03 f3s: Kubernetes with FreeBSD - Part 2: Hardware and base installation](./2024-12-03-f3s-kubernetes-with-freebsd-part-2.md)  
[2025-02-01 f3s: Kubernetes with FreeBSD - Part 3: Protecting from power cuts](./2025-02-01-f3s-kubernetes-with-freebsd-part-3.md)  
[2025-04-05 f3s: Kubernetes with FreeBSD - Part 4: Rocky Linux Bhyve VMs](./2025-04-05-f3s-kubernetes-with-freebsd-part-4.md)  
[2025-05-11 f3s: Kubernetes with FreeBSD - Part 5: WireGuard mesh network](./2025-05-11-f3s-kubernetes-with-freebsd-part-5.md)  

[![f3s logo](./f3s-kubernetes-with-freebsd-part-1/f3slogo.png "f3s logo")](./f3s-kubernetes-with-freebsd-part-1/f3slogo.png)  

## Table of Contents

* [⇢ f3s: Kubernetes with FreeBSD - Part 6: Storage](#f3s-kubernetes-with-freebsd---part-6-storage)
* [⇢ ⇢ Introduction](#introduction)
* [⇢ ⇢ ZFS encryption keys](#zfs-encryption-keys)
* [⇢ ⇢ ⇢ UFS on USB keys](#ufs-on-usb-keys)
* [⇢ ⇢ ⇢ Generating encryption keys](#generating-encryption-keys)
* [⇢ ⇢ ⇢ Configuring `zdata` ZFS pool and encryption](#configuring-zdata-zfs-pool-and-encryption)
* [⇢ ⇢ ⇢ Migrating Bhyve VMs to encrypted `bhyve` ZFS volume](#migrating-bhyve-vms-to-encrypted-bhyve-zfs-volume)
* [⇢ ⇢ CARP](#carp)

## Introduction

In this blog post, we are going to extend the Beelinks with some additional storage.

Some photos here, describe why there are 2 different models of SSD drives (replication etc)

## ZFS encryption keys

### UFS on USB keys

```
paul@f0:/ % doas camcontrol devlist
<512GB SSD D910R170>               at scbus0 target 0 lun 0 (pass0,ada0)
<Samsung SSD 870 EVO 1TB SVT03B6Q>  at scbus1 target 0 lun 0 (pass1,ada1)
<Generic Flash Disk 8.07>          at scbus2 target 0 lun 0 (da0,pass2)
paul@f0:/ %
```

```
paul@f1:/ % doas camcontrol devlist
<512GB SSD D910R170>               at scbus0 target 0 lun 0 (pass0,ada0)
<CT1000BX500SSD1 M6CR072>          at scbus1 target 0 lun 0 (pass1,ada1)
<Generic Flash Disk 8.07>          at scbus2 target 0 lun 0 (da0,pass2)
paul@f1:/ %
```

```sh
paul@f0:/ % doas newfs /dev/da0
/dev/da0: 15000.0MB (30720000 sectors) block size 32768, fragment size 4096
        using 24 cylinder groups of 625.22MB, 20007 blks, 80128 inodes.
        with soft updates
super-block backups (for fsck_ffs -b #) at:
 192, 1280640, 2561088, 3841536, 5121984, 6402432, 7682880, 8963328, 10243776,
11524224, 12804672, 14085120, 15365568, 16646016, 17926464, 19206912,k 20487360,
...

paul@f0:/ % echo '/dev/da0 /keys ufs rw 0 2' | doas tee -a /etc/fstab
/dev/da0 /keys ufs rw 0 2
paul@f0:/ % doas mkdir /keys
paul@f0:/ % doas mount /keys
paul@f0:/ % df | grep keys
/dev/da0             14877596       8  13687384     0%    /keys
```

### Generating encryption keys

paul@f0:/keys % doas openssl rand -out /keys/f0.lan.buetow.org:bhyve.key 32
paul@f0:/keys % doas openssl rand -out /keys/f1.lan.buetow.org:bhyve.key 32
paul@f0:/keys % doas openssl rand -out /keys/f2.lan.buetow.org:bhyve.key 32
paul@f0:/keys % doas openssl rand -out /keys/f0.lan.buetow.org:zdata.key 32
paul@f0:/keys % doas openssl rand -out /keys/f1.lan.buetow.org:zdata.key 32
paul@f0:/keys % doas openssl rand -out /keys/f2.lan.buetow.org:zdata.key 32
paul@f0:/keys % doas chown root *
paul@f0:/keys % doas chmod 400 *

paul@f0:/keys % ls -l
total 20
-r--------  1 root wheel 32 May 25 13:07 f0.lan.buetow.org:bhyve.key
-r--------  1 root wheel 32 May 25 13:07 f1.lan.buetow.org:bhyve.key
-r--------  1 root wheel 32 May 25 13:07 f2.lan.buetow.org:bhyve.key
-r--------  1 root wheel 32 May 25 13:07 f0.lan.buetow.org:zdata.key
-r--------  1 root wheel 32 May 25 13:07 f1.lan.buetow.org:zdata.key
-r--------  1 root wheel 32 May 25 13:07 f2.lan.buetow.org:zdata.key

Copy those to all 3 nodes to /keys

### Configuring `zdata` ZFS pool and encryption

```sh
paul@f0:/keys % doas zpool create -m /data zdata /dev/ada1
paul@f0:/keys % doas zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///keys/`hostname`:zdata.key zdata/enc
paul@f0:/ % zfs list | grep zdata
zdata                                          836K   899G    96K  /data
zdata/enc                                      200K   899G   200K  /data/enc
paul@f0:/keys % zfs get all zdata/enc | grep -E -i '(encryption|key)'
zdata/enc  encryption            aes-256-gcm                               -
zdata/enc  keylocation           file:///keys/f0.lan.buetow.org:zdata.key  local
zdata/enc  keyformat             raw                                       -
zdata/enc  encryptionroot        zdata/enc                                 -
zdata/enc  keystatus             available                                 -
````

### Migrating Bhyve VMs to encrypted `bhyve` ZFS volume

Run on all 3 nodes

```sh
paul@f0:/keys % doas vm stop rocky
Sending ACPI shutdown to rocky

paul@f0:/keys % doas vm list
NAME     DATASTORE  LOADER     CPU  MEMORY  VNC  AUTO     STATE
rocky    default    uefi       4    14G     -    Yes [1]  Stopped


paul@f0:/keys % doas zfs rename zroot/bhyve zroot/bhyve_old
paul@f0:/keys % doas zfs set mountpoint=/mnt zroot/bhyve_old
paul@f0:/keys % doas zfs snapshot zroot/bhyve_old/rocky@hamburger


paul@f0:/keys % doas zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///keys/`hostname`:bhyve.key zroot/bhyve
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve zroot/bhyve
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve/rocky zroot/bhyve/rocky

paul@f0:/keys % doas zfs send zroot/bhyve_old/rocky@hamburger | doas zfs recv zroot/bhyve/rocky
paul@f0:/keys % doas cp -Rp /mnt/.config /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.img /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.templates /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.iso /zroot/bhyve/

paul@f0:/keys % doas sysrc zfskeys_enable=YES
zfskeys_enable:  -> YES
paul@f0:/keys % doas vm init
paul@f0:/keys % doas reboot
.
.
.
paul@f0:~ % doas vm list
paul@f0:~ % doas vm list
NAME     DATASTORE  LOADER     CPU  MEMORY  VNC           AUTO     STATE
rocky    default    uefi       4    14G     0.0.0.0:5900  Yes [1]  Running (2265)
```

```sh
paul@f0:~ % doas zfs destroy -R zroot/bhyve_old

paul@f0:~ % zfs get all zroot/bhyve | grep -E '(encryption|key)'
zroot/bhyve  encryption            aes-256-gcm                               -
zroot/bhyve  keylocation           file:///keys/f0.lan.buetow.org:bhyve.key  local
zroot/bhyve  keyformat             raw                                       -
zroot/bhyve  encryptionroot        zroot/bhyve                               -
zroot/bhyve  keystatus             available                                 -
paul@f0:~ % zfs get all zroot/bhyve/rocky | grep -E '(encryption|key)'
zroot/bhyve/rocky  encryption            aes-256-gcm            -
zroot/bhyve/rocky  keylocation           none                   default
zroot/bhyve/rocky  keyformat             raw                    -
zroot/bhyve/rocky  encryptionroot        zroot/bhyve            -
zroot/bhyve/rocky  keystatus             available              -
```

## CARP

adding to /etc/rc.conf on f0 and f1:
ifconfig_re0_alias0="inet vhid 1 pass testpass alias 192.168.1.138/32"

adding to /etc/hosts:

192.168.1.138 f3s-storage-ha f3s-storage-ha.lan f3s-storage-ha.lan.buetow.org

Adding on f0 and f1:

paul@f0:~ % cat <<END | doas tee -a /etc/devd.conf
notify 0 {
        match "system"          "CARP";
        match "subsystem"       "[0-9]+@[0-9a-z.]+";
        match "type"            "(MASTER|BACKUP)";
        action "/usr/local/bin/carpcontrol.sh $subsystem $type";
};
END

next, copied that script /usr/local/bin/carpcontrol.sh and adjusted the disk to storage

/boot/loader.conf add carp_load="YES"
reboot or run doas kldload carp0 


ZFS auto scrubbing....~?

Backup of the keys on the key locations (all keys on all 3 USB keys)

Other *BSD-related posts:

[2025-05-11 f3s: Kubernetes with FreeBSD - Part 5: WireGuard mesh network](./2025-05-11-f3s-kubernetes-with-freebsd-part-5.md)  
[2025-04-05 f3s: Kubernetes with FreeBSD - Part 4: Rocky Linux Bhyve VMs](./2025-04-05-f3s-kubernetes-with-freebsd-part-4.md)  
[2025-02-01 f3s: Kubernetes with FreeBSD - Part 3: Protecting from power cuts](./2025-02-01-f3s-kubernetes-with-freebsd-part-3.md)  
[2024-12-03 f3s: Kubernetes with FreeBSD - Part 2: Hardware and base installation](./2024-12-03-f3s-kubernetes-with-freebsd-part-2.md)  
[2024-11-17 f3s: Kubernetes with FreeBSD - Part 1: Setting the stage](./2024-11-17-f3s-kubernetes-with-freebsd-part-1.md)  
[2024-04-01 KISS high-availability with OpenBSD](./2024-04-01-KISS-high-availability-with-OpenBSD.md)  
[2024-01-13 One reason why I love OpenBSD](./2024-01-13-one-reason-why-i-love-openbsd.md)  
[2022-10-30 Installing DTail on OpenBSD](./2022-10-30-installing-dtail-on-openbsd.md)  
[2022-07-30 Let's Encrypt with OpenBSD and Rex](./2022-07-30-lets-encrypt-with-openbsd-and-rex.md)  
[2016-04-09 Jails and ZFS with Puppet on FreeBSD](./2016-04-09-jails-and-zfs-on-freebsd-with-puppet.md)  

E-Mail your comments to `paul@nospam.buetow.org`

[Back to the main site](../)  

https://forums.freebsd.org/threads/hast-and-zfs-with-carp-failover.29639/


E-Mail your comments to `paul@nospam.buetow.org`

[Back to the main site](../)  
