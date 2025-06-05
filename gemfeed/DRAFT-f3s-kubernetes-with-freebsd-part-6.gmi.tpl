# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-04-04T23:21:01+03:00

This is the sixth blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, we are going to extend the Beelinks with some additional storage.

Some photos here, describe why there are 2 different models of SSD drives (replication etc)

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

## UFS Setup

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

## ZFS Setup

```sh
paul@f0:/dev % doas zpool create -m /data zdata /dev/ada1
paul@f0:/dev % zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zdata   928G   432K   928G        -         -     0%     0%  1.00x    ONLINE  -
zroot   472G  19.8G   452G        -         -     0%     4%  1.00x    ONLINE  -

```

### Encryption

USB key for key location

```sh
paul@f0:/keys % doas vm stop rocky
Sending ACPI shutdown to rocky

paul@f0:/keys % doas vm list
NAME     DATASTORE  LOADER     CPU  MEMORY  VNC  AUTO     STATE
rocky    default    uefi       4    14G     -    Yes [1]  Stopped


paul@f0:/keys % doas zfs rename zroot/bhyve zroot/bhyve_old
paul@f0:/keys % doas zfs set mountpoint=/mnt zroot/bhyve_old
paul@f0:/keys % doas zfs snapshot zroot/bhyve_old/rocky@hamburger


paul@f0:/keys % doas openssl rand -out /keys/`hostname`:bhyve.key 32
paul@f0:/keys % doas openssl rand -out /keys/`hostname`:zdata.key 32
paul@f0:/keys % ls -ltr
total 8
-rw-r--r--  1 root wheel 16 May 25 11:54 f0.lan.buetow.org:bhyve.key
-rw-r--r--  1 root wheel 16 May 25 11:54 f0.lan.buetow.org:zdata.key

paul@f0:/keys % doas zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///keys/`hostname`:bhyve.key zroot/bhyve
paul@f0:/keys % doas zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///keys/`hostname`:zdata.key zdata/enc
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve zroot/bhyve
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve/rocky zroot/bhyve/rocky

paul@f0:/keys % doas zfs send zroot/bhyve_old/rocky@hamburger | doas zfs recv zroot/bhyve/rocky
paul@f0:/keys % doas cp -Rp /mnt/.config /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.img /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.templates /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.iso /zroot/bhyve/

paul@f0:/keys % doas sysrc zfskeys_enable=YES
zfskeys_enable:  -> YES
```

Copied over all the keys from the partner node to each node, so they backup each other:

```sh
paul@f0:/keys % doas chown root *
paul@f0:/keys % doas chmod 400 *
paul@f0:/keys % ls -ltr
total 24
-r--------  1 root paul 16 May 25 11:56 f0.lan.buetow.org:zdata.key
-r--------  1 root paul 16 May 25 11:56 f0.lan.buetow.org:bhyve.key
-r--------  1 root paul 16 May 25 11:56 f1.lan.buetow.org:zdata.key
-r--------  1 root paul 16 May 25 11:56 f1.lan.buetow.org:bhyve.key
-r--------  1 root paul 16 May 25 11:57 f2.lan.buetow.org:zdata.key
-r--------  1 root paul 16 May 25 11:57 f2.lan.buetow.org:bhyve.key
```

```sh
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

paul@f0:~ % zfs get all zdata/enc | grep -E '(encryption|key)'
zdata/enc  encryption            aes-256-gcm                               -
zdata/enc  keylocation           file:///keys/f0.lan.buetow.org:zdata.key  local
zdata/enc  keyformat             raw                                       -
zdata/enc  encryptionroot        zdata/enc                                 -
zdata/enc  keystatus             available                                 -
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

```
	paul@f0:~ % zpool status
  pool: zdata
 state: ONLINE
config:

        NAME        STATE     READ WRITE CKSUM
        zdata       ONLINE       0     0     0
          ada1      ONLINE       0     0     0

errors: No known data errors

  pool: zroot
 state: ONLINE
config:

        NAME        STATE     READ WRITE CKSUM
        zroot       ONLINE       0     0     0
          ada0p4    ONLINE       0     0     0

errors: No known data errors
```
## HAST

```
doas zpool export zdata

paul@f0:/etc/rc.d % cat /etc/hast.conf
resource storage {
        on f0 {
                local /dev/ada1
                remote 192.168.1.130
        }
        on f1 {
                local /dev/ada1
                remote 192.168.1.131
        }
}

paul@f0:/etc/rc.d % doas hastctl create storage
paul@f0:/etc/rc.d % doas hastctl role primary storage
paul@f0:/etc/rc.d % doas service hastd onestart
Starting hastd.

paul@f1:/etc/rc.d % doas hastctl create storage
paul@f1:/etc/rc.d % doas hastctl role secondary storage
paul@f1:/etc/rc.d % doas service hastd onestart
Starting hastd.


paul@f0:/var/log % doas hastctl status
Name    Status   Role           Components
storage complete primary        /dev/ada1       192.168.1.131

paul@f1:/var/log % doas hastctl status
Name    Status   Role           Components
storage complete secondary      /dev/ada1       192.168.1.130



paul@f0:/dev/hast % ls -l /dev/hast/storage
crw-r-----  1 root operator 0x83 Jun  6 00:08 /dev/hast/storage

paul@f0:/dev/hast % doas zpool create -m /zhast zhast /dev/hast/storage
paul@f0:/dev/hast % doas zpool status zhast
  pool: zhast
 state: ONLINE
config:

        NAME            STATE     READ WRITE CKSUM
        zhast           ONLINE       0     0     0
          hast/storage  ONLINE       0     0     0

errors: No known data errors
paul@f0:/dev/hast % doas zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zhast   928G   420K   928G        -         -     0%     0%  1.00x    ONLINE  -
zroot   472G  21.0G   451G        -         -     0%     4%  1.00x    ONLINE  -```


paul@f0:/dev/hast % doas openssl rand -out /keys/zhast.key 32
paul@f0:/dev/hast % doas zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///keys/zhast.key zhast/enc
paul@f0:/data/enc % zfs list | grep hast
zhast                                          764K   899G    96K  /zhast
zhast/enc                                      200K   899G   200K  /zhast/enc

... copying the key to f1


paul@f1:/var/log % doas hastctl list
storage:
  role: secondary
  provname: storage
  localpath: /dev/ada1
  extentsize: 2097152 (2.0MB)
  keepdirty: 0
  remoteaddr: 192.168.1.130
  replication: memsync
  status: complete
  workerpid: 2546
  dirty: 0 (0B)
  statistics:
    reads: 0
    writes: 26
    deletes: 0
    flushes: 0
    activemap updates: 0
    local errors: read: 0, write: 0, delete: 0, flush: 0
    queues: local: 0, send: 0, recv: 0, done: 0, idle: 255





paul@f1:/var/log % zfs get all zhast/enc | grep -E '(encryption|key)'
zhast/enc  encryption            aes-256-gcm             -
zhast/enc  keylocation           file:///keys/zhast.key  local
zhast/enc  keyformat             raw                     -
zhast/enc  encryptionroot        zhast/enc               -
zhast/enc  keystatus             unavailable             -

root@f0:/zhast/enc # sysrc hastd_enable=YES
hastd_enable: NO -> YES


ZFS auto scrubbing....~?

Backup of the keys on the key locations (all keys on all 3 USB keys)

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site

https://forums.freebsd.org/threads/hast-and-zfs-with-carp-failover.29639/
