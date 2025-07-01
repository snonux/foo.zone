# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-04-04T23:21:01+03:00

This is the sixth blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

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


## ZFS Replication with zrepl

In this section, we'll set up automatic ZFS replication from f0 to f1 using zrepl. This ensures our data is replicated across nodes for redundancy.

### Installing zrepl

First, install zrepl on both hosts:

```sh
# On f0
paul@f0:~ % doas pkg install -y zrepl

# On f1
paul@f1:~ % doas pkg install -y zrepl
```

### Checking ZFS pools

Verify the pools and datasets on both hosts:

```sh
# On f0
paul@f0:~ % doas zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zdata   928G  1.03M   928G        -         -     0%     0%  1.00x    ONLINE  -
zroot   472G  26.7G   445G        -         -     0%     5%  1.00x    ONLINE  -

paul@f0:~ % doas zfs list -r zdata/enc
NAME        USED  AVAIL  REFER  MOUNTPOINT
zdata/enc   200K   899G   200K  /data/enc

# On f1
paul@f1:~ % doas zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zdata   928G   956K   928G        -         -     0%     0%  1.00x    ONLINE  -
zroot   472G  11.7G   460G        -         -     0%     2%  1.00x    ONLINE  -

paul@f1:~ % doas zfs list -r zdata/enc
NAME        USED  AVAIL  REFER  MOUNTPOINT
zdata/enc   200K   899G   200K  /data/enc
```

### Configuring zrepl with WireGuard tunnel

Since we have a WireGuard tunnel between f0 and f1, we'll use TCP transport over the secure tunnel instead of SSH. First, check the WireGuard IP addresses:

```sh
# Check WireGuard interface IPs
paul@f0:~ % ifconfig wg0 | grep inet
	inet 192.168.2.130 netmask 0xffffff00

paul@f1:~ % ifconfig wg0 | grep inet
	inet 192.168.2.131 netmask 0xffffff00
```

### Configuring zrepl on f0 (source)

Create the zrepl configuration on f0:

```sh
paul@f0:~ % doas tee /usr/local/etc/zrepl/zrepl.yml <<'EOF'
global:
  logging:
    - type: stdout
      level: info
      format: human

jobs:
  - name: f0_to_f1
    type: push
    connect:
      type: tcp
      address: "192.168.2.131:8888"
    filesystems:
      "zdata/enc": true
    send:
      encrypted: true
    snapshotting:
      type: periodic
      prefix: zrepl_
      interval: 10m
    pruning:
      keep_sender:
        - type: last_n
          count: 10
      keep_receiver:
        - type: last_n
          count: 10
EOF
```

### Configuring zrepl on f1 (sink)

Create the zrepl configuration on f1:

```sh
paul@f1:~ % doas tee /usr/local/etc/zrepl/zrepl.yml <<'EOF'
global:
  logging:
    - type: stdout
      level: info
      format: human

jobs:
  - name: "sink"
    type: sink
    serve:
      type: tcp
      listen: "192.168.2.131:8888"
      clients:
        "192.168.2.130": "f0"
    recv:
      placeholder:
        encryption: inherit
    root_fs: "zdata/enc"
EOF
```

### Enabling and starting zrepl services

Enable and start zrepl on both hosts:

```sh
# On f0
paul@f0:~ % doas sysrc zrepl_enable=YES
zrepl_enable:  -> YES
paul@f0:~ % doas service zrepl start
Starting zrepl.

# On f1
paul@f1:~ % doas sysrc zrepl_enable=YES
zrepl_enable:  -> YES
paul@f1:~ % doas service zrepl start
Starting zrepl.
```

### Verifying replication

Check the replication status:

```sh
# On f0, check zrepl status (use raw mode for non-tty)
paul@f0:~ % doas zrepl status --mode raw | grep -A2 "Replication"
"Replication":{"StartAt":"2025-07-01T22:31:48.712143123+03:00"...

# Check if services are running
paul@f0:~ % doas service zrepl status
zrepl is running as pid 2649.

paul@f1:~ % doas service zrepl status
zrepl is running as pid 2574.

# Check for zrepl snapshots on source
paul@f0:~ % doas zfs list -t snapshot -r zdata/enc | grep zrepl
zdata/enc@zrepl_20250701_193148_000    0B      -   176K  -

# On f1, verify the replicated datasets
paul@f1:~ % doas zfs list -r zdata/enc
NAME                     USED  AVAIL  REFER  MOUNTPOINT
zdata/enc                776K   899G   200K  /data/enc
zdata/enc/f0             576K   899G   200K  none
zdata/enc/f0/zdata       376K   899G   200K  none
zdata/enc/f0/zdata/enc   176K   899G   176K  none

# Check replicated snapshots on f1
paul@f1:~ % doas zfs list -t snapshot -r zdata/enc
NAME                                               USED  AVAIL  REFER  MOUNTPOINT
zdata/enc/f0/zdata/enc@zrepl_20250701_193148_000     0B      -   176K  -
```

### Monitoring replication

You can monitor the replication progress with:

```sh
# Real-time status
paul@f0:~ % doas zrepl status --mode interactive

# Check specific job details
paul@f0:~ % doas zrepl status --job f0_to_f1
```

With this setup, zdata/enc on f0 will be automatically replicated to f1 every 10 minutes, with encrypted snapshots preserved on both sides. The pruning policy ensures that we keep the last 10 snapshots while managing disk space efficiently.

The replicated data appears on f1 under `zdata/enc/f0/zdata/enc` to maintain the source dataset hierarchy. The replication uses the WireGuard tunnel for secure, encrypted transport between nodes.

### Quick status check commands

Here are the essential commands to monitor replication status:

```sh
# On the source node (f0) - check if replication is active
paul@f0:~ % doas zrepl status --job f0_to_f1 | grep -E '(State|Last)'
State: done
LastError: 

# List all zrepl snapshots on source
paul@f0:~ % doas zfs list -t snapshot -r zdata/enc | grep zrepl
zdata/enc@zrepl_20250701_193148_000    0B      -   176K  -
zdata/enc@zrepl_20250701_194148_000    0B      -   176K  -

# On the sink node (f1) - verify received datasets
paul@f1:~ % doas zfs list -r zdata/enc/f0
NAME                     USED  AVAIL  REFER  MOUNTPOINT
zdata/enc/f0             576K   899G   200K  none
zdata/enc/f0/zdata       376K   899G   200K  none
zdata/enc/f0/zdata/enc   176K   899G   176K  none

# Check received snapshots on sink
paul@f1:~ % doas zfs list -t snapshot -r zdata/enc | wc -l
       2

# Monitor replication progress in real-time (on source)
paul@f0:~ % doas zrepl status --mode interactive

# Check last replication time (on source)
paul@f0:~ % doas zrepl status --job f0_to_f1 | grep -A1 "Replication"
Replication:
  Status: Idle (last run: 2025-07-01T22:41:48)

# View zrepl logs for troubleshooting
paul@f0:~ % doas tail -20 /var/log/zrepl.log | grep -E '(error|warn|replication)'
```

These commands provide a quick way to verify that:
- Replication jobs are running without errors
- Snapshots are being created on the source
- Data is being received on the sink
- The replication schedule is being followed

ZFS auto scrubbing....~?

Backup of the keys on the key locations (all keys on all 3 USB keys)

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site

https://forums.freebsd.org/threads/hast-and-zfs-with-carp-failover.29639/


E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
