# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-04-04T23:21:01+03:00

This is the sixth blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In the previous posts, we set up a FreeBSD-based Kubernetes cluster using k3s. While the base system works well, Kubernetes workloads often require persistent storage for databases, configuration files, and application data. Local storage on each node has significant limitations:

* No data sharing: Pods on different nodes can't access the same data
* Pod mobility: If a pod moves to another node, it loses access to its data
* No redundancy: Hardware failure means data loss

This post implements a robust storage solution using:

* CARP: For high availability with automatic IP failover
* NFS over stunnel: For secure, encrypted network storage
* ZFS: For data integrity, encryption, and efficient snapshots
* zrepl: For continuous ZFS replication between nodes

The end result is a highly available, encrypted storage system that survives node failures while providing shared storage to all Kubernetes pods.

## Additional storage capacity

We add to each of the nodes (`f0`, `f1`, `f2`) additional 1TB storage in form of an SSD drive. The Beelink mini PCs have enough space in the chassis for the additional space.

=> ./f3s-kubernetes-with-freebsd-part-6/drives.jpg

Upgrading the storage was as easy as unscrewing, plugging the drive in, and then screwing it together again. So the procedure was pretty uneventful! We're using two different SSD models (Samsung 870 EVO and Crucial BX500) to avoid simultaneous failures from the same manufacturing batch.

We then create the `zdata` ZFS pool on all three nodes:

```sh
paul@f0:~ % doas zpool create -m /data zdata /dev/ada1
paul@f0:~ % zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
zdata   928G  12.1M   928G        -         -     0%     0%  1.00x    ONLINE  -
zroot   472G  29.0G   443G        -         -     0%     6%  1.00x    ONLINE  -

paul@f0:/ % doas camcontrol devlist
<512GB SSD D910R170>               at scbus0 target 0 lun 0 (pass0,ada0)
<Samsung SSD 870 EVO 1TB SVT03B6Q>  at scbus1 target 0 lun 0 (pass1,ada1)
paul@f0:/ %
```

To verify that we have a different SSD on the second node (the third node has the same drive as the first):

```sh
paul@f1:/ % doas camcontrol devlist
<512GB SSD D910R170>               at scbus0 target 0 lun 0 (pass0,ada0)
<CT1000BX500SSD1 M6CR072>          at scbus1 target 0 lun 0 (pass1,ada1)
```

## ZFS encryption keys

ZFS native encryption requires encryption keys to unlock datasets. We need a secure method to store these keys that balances security with operational needs:

* Security: Keys must not be stored on the same disks they encrypt
* Availability: Keys must be available at boot for automatic mounting
* Portability: Keys should be easily moved between systems for recovery

Using USB flash drives as hardware key storage provides an elegant solution. The encrypted data is unreadable without physical access to the USB key, protecting against disk theft or improper disposal. In production environments, you might use enterprise key management systems, but for a home lab, USB keys offer good security with minimal complexity.

### UFS on USB keys

We'll format the USB drives with UFS (Unix File System) rather than ZFS for simplicity. There is no need to use ZFS.

Let's see the USB keys:

=> ./f3s-kubernetes-with-freebsd-part-6/usbkeys1.jpg USB keys

To verify, that the USB key (flash disk) is there:

```
paul@f0:/ % doas camcontrol devlist
<512GB SSD D910R170>               at scbus0 target 0 lun 0 (pass0,ada0)
<Samsung SSD 870 EVO 1TB SVT03B6Q>  at scbus1 target 0 lun 0 (pass1,ada1)
<Generic Flash Disk 8.07>          at scbus2 target 0 lun 0 (da0,pass2)
paul@f0:/ %
```

Let's create the UFS file system and mount it (done on all 3 nodes `f0`, `f1` and `f2`):

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

=> ./f3s-kubernetes-with-freebsd-part-6/usbkeys2.jpg USB keys sticked in

### Generating encryption keys

The following keys will later be used to encrypt the ZFS file systems. They will be stored on all three nodes, serving as a backup in case one of the keys is lost. When we later replicate encrypted ZFS volumes from one node to another, the keys must also be available on the destination node.

```
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
*r--------  1 root wheel 32 May 25 13:07 f0.lan.buetow.org:bhyve.key
*r--------  1 root wheel 32 May 25 13:07 f1.lan.buetow.org:bhyve.key
*r--------  1 root wheel 32 May 25 13:07 f2.lan.buetow.org:bhyve.key
*r--------  1 root wheel 32 May 25 13:07 f0.lan.buetow.org:zdata.key
*r--------  1 root wheel 32 May 25 13:07 f1.lan.buetow.org:zdata.key
*r--------  1 root wheel 32 May 25 13:07 f2.lan.buetow.org:zdata.key
````

After creation, these are copied to the other two nodes, `f1` and `f2`, into the `/keys` partition (I won't provide the commands here; just create a tarball, copy it over, and extract it on the destination nodes).

### Configuring `zdata` ZFS pool encryption

Let's encrypt our `zdata` ZFS pool. Actually, we are not encrypting the whole pool, but everythig within the `zdata/enc` data set:

```sh
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

All future data sets within `zdata/enc` will inherit the same encription key.

### Migrating Bhyve VMs to encrypted `bhyve` ZFS volume

We set up Bhyve VMs in one of the previous blog posts. Their ZFS data sets rely on `zroot`, which is the default ZFS pool on the internal 512GB NVME drive. They aren't encrypted yet, so we encrypt the VM data sets as well now. To do so, we first shut down the VMs on all 3 nodes:

```sh
paul@f0:/keys % doas vm stop rocky
Sending ACPI shutdown to rocky

paul@f0:/keys % doas vm list
NAME     DATASTORE  LOADER     CPU  MEMORY  VNC  AUTO     STATE
rocky    default    uefi       4    14G     -    Yes [1]  Stopped
```

After this, we rename the unencrypted data set to `_old` and create a new encrypted data set and we also snapshot it as `@hamburger`!
  
```sh
paul@f0:/keys % doas zfs rename zroot/bhyve zroot/bhyve_old
paul@f0:/keys % doas zfs set mountpoint=/mnt zroot/bhyve_old
paul@f0:/keys % doas zfs snapshot zroot/bhyve_old/rocky@hamburger

paul@f0:/keys % doas zfs create -o encryption=on -o keyformat=raw -o \
  keylocation=file:///keys/`hostname`:bhyve.key zroot/bhyve
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve zroot/bhyve
paul@f0:/keys % doas zfs set mountpoint=/zroot/bhyve/rocky zroot/bhyve/rocky
```

Once done, we import the snapshot into the encrypted dataset and also copy some other metadata files from `vm-bhyve` back over.

```
paul@f0:/keys % doas zfs send zroot/bhyve_old/rocky@hamburger | \
  doas zfs recv zroot/bhyve/rocky
paul@f0:/keys % doas cp -Rp /mnt/.config /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.img /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.templates /zroot/bhyve/
paul@f0:/keys % doas cp -Rp /mnt/.iso /zroot/bhyve/
```

We also have to make encrypted ZFS data sets mount automatically on boot:

```sh
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

As you can see, the VM is running. This means the encrypted `zroot/bhyve` was mounted successfully after the reboot! Now we can destroy the old, unencrypted, and now unused bhyve dataset:

```sh
paul@f0:~ % doas zfs destroy -R zroot/bhyve_old
```

To verify once again that `zroot/bhyve` and `zroot/bhyve/rocky` are now both encrypted, we run:
  
```sh
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

## ZFS Replication with zrepl

Data replication is the cornerstone of high availability. While CARP handles IP failover (see later in this post), we need continuous data replication to ensure the backup server has current data when it becomes active. Without replication, failover would result in data loss or require shared storage (like iSCSI), which introduces a single point of failure.

### Understanding Replication Requirements

Our storage system has different replication needs:

* NFS data (`/data/nfs/k3svolumes`): Contains active Kubernetes persistent volumes. Needs frequent replication (every minute) to minimize data loss during failover.
* VM data (`/zroot/bhyve/fedora`): Contains VM images that change less frequently. Can tolerate longer replication intervals (every 10 minutes).

The replication frequency determines your Recovery Point Objective (RPO) - the maximum acceptable data loss. With 1-minute replication, you lose at most 1 minute of changes during an unplanned failover.

### Why `zrepl` instead of HAST?

While HAST (Highly Available Storage) is FreeBSD's native solution for high-availability storage, I've chosen `zrepl` for several important reasons:

* HAST can cause ZFS corruption: HAST operates at the block level and doesn't understand ZFS's transactional semantics. During failover, in-flight transactions can lead to corrupted zpools. I've experienced this firsthand (I am sure I might have configured something wrong) - the automatic failover would trigger while ZFS was still writing, resulting in an unmountable pool.
* ZFS-aware replication: `zrepl` understands ZFS datasets and snapshots. It replicates at the dataset level, ensuring each snapshot is a consistent point-in-time copy. This is fundamentally safer than block-level replication.
* Snapshot history: With zrepl, you get multiple recovery points (every minute for NFS data in our setup). If corruption occurs, you can roll back to any previous snapshot. HAST only gives you the current state.
* Easier recovery: When something goes wrong with zrepl, you still have intact snapshots on both sides. With HAST, a corrupted primary often means a corrupted secondary too.

The 1-minute replication window is perfectly acceptable for my personal use cases. This isn't a high-frequency trading system or a real-time database—it's storage for personal projects, development work, and home lab experiments. Losing at most 1 minute of work in a disaster scenario is a reasonable trade-off for the reliability and simplicity of snapshot-based replication. Also, in the case of "1 minute of data loss," I would very likely still have the data available on the client side.

### Installing zrepl

First, install `zrepl` on both hosts involved (we will replicate data from `f0` to `f1`):

```sh
paul@f0:~ % doas pkg install -y zrepl
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

### Configuring `zrepl` with WireGuard tunnel

Since we have a WireGuard tunnel between f0 and f1, we'll use TCP transport over the secure tunnel instead of SSH. First, check the WireGuard IP addresses:

```sh
# Check WireGuard interface IPs
paul@f0:~ % ifconfig wg0 | grep inet
	inet 192.168.2.130 netmask 0xffffff00

paul@f1:~ % ifconfig wg0 | grep inet
	inet 192.168.2.131 netmask 0xffffff00
```

### Configuring `zrepl` on f0 (source)

First, create a dedicated dataset for NFS data that will be replicated:

```sh
# Create the nfsdata dataset that will hold all data exposed via NFS
paul@f0:~ % doas zfs create zdata/enc/nfsdata
```

Afterwards, we create the `zrepl` configuration on f0:

```sh
paul@f0:~ % doas tee /usr/local/etc/zrepl/zrepl.yml <<'EOF'
global:
  logging:
    - type: stdout
      level: info
      format: human

jobs:
  - name: f0_to_f1_nfsdata
    type: push
    connect:
      type: tcp
      address: "192.168.2.131:8888"
    filesystems:
      "zdata/enc/nfsdata": true
    send:
      encrypted: true
    snapshotting:
      type: periodic
      prefix: zrepl_
      interval: 1m
    pruning:
      keep_sender:
        - type: last_n
          count: 10
      keep_receiver:
        - type: last_n
          count: 10

  - name: f0_to_f1_fedora
    type: push
    connect:
      type: tcp
      address: "192.168.2.131:8888"
    filesystems:
      "zroot/bhyve/fedora": true
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

 We're using two separate replication jobs with different intervals:

* `f0_to_f1_nfsdata`: Replicates NFS data every minute for faster failover recovery
* `f0_to_f1_fedora`: Replicates Fedora VM every ten minutes (less critical)

The Fedora VM is only used for development purposes, so it doesn't require as frequent replication as the NFS data. It's off-topic to this blog series, but it showcases, hows zrepl's flexibility in handling different datasets with varying replication needs.

Furthermore:

* We're specifically replicating `zdata/enc/nfsdata` instead of the entire `zdata/enc` dataset. This dedicated dataset will contain all the data we later want to expose via NFS, keeping a clear separation between replicated NFS data and other local encrypted data.
* The `send: encrypted: false` option disables ZFS native encryption for the replication stream. Since we're using a WireGuard tunnel between `f0` and `f1`, the data is already encrypted in transit. Disabling ZFS stream encryption reduces CPU overhead and improves replication performance.

### Configuring `zrepl` on `f1` (sink)

On `f1` we configure `zrepl` to receive the data as follows:

```sh
# First create a dedicated sink dataset
paul@f1:~ % doas zfs create zdata/sink

paul@f1:~ % doas tee /usr/local/etc/zrepl/zrepl.yml <<'EOF'
global:
  logging:
    - type: stdout
      level: info
      format: human

jobs:
  - name: sink
    type: sink
    serve:
      type: tcp
      listen: "192.168.2.131:8888"
      clients:
        "192.168.2.130": "f0"
    recv:
      placeholder:
        encryption: inherit
    root_fs: "zdata/sink"
EOF
```

### Enabling and starting `zrepl` services

Enable and start `zrepl` on both hosts:

```sh
# On f0
paul@f0:~ % doas sysrc zrepl_enable=YES
zrepl_enable:  -> YES
paul@f0:~ % doas service `zrepl` start
Starting zrepl.

# On f1
paul@f1:~ % doas sysrc zrepl_enable=YES
zrepl_enable:  -> YES
paul@f1:~ % doas service `zrepl` start
Starting zrepl.
```

### Verifying replication

To check the replication status, we run:

```sh
# On f0, check `zrepl` status (use raw mode for non-tty)
paul@f0:~ % doas pkg install jq
paul@f0:~ % doas zrepl status --mode raw | grep -A2 "Replication" | jq .
"Replication":{"StartAt":"2025-07-01T22:31:48.712143123+03:00"...

# Check if services are running
paul@f0:~ % doas service zrepl status
zrepl is running as pid 2649.

paul@f1:~ % doas service zrepl status
zrepl is running as pid 2574.

# Check for `zrepl` snapshots on source
paul@f0:~ % doas zfs list -t snapshot -r zdata/enc | grep zrepl
zdata/enc@zrepl_20250701_193148_000    0B      -   176K  -

# On f1, verify the replicated datasets  
paul@f1:~ % doas zfs list -r zdata | grep f0
zdata/f0             576K   899G   200K  none
zdata/f0/zdata       376K   899G   200K  none
zdata/f0/zdata/enc   176K   899G   176K  none

# Check replicated snapshots on f1
paul@f1:~ % doas zfs list -t snapshot -r zdata | grep zrepl
zdata/f0/zdata/enc@zrepl_20250701_193148_000     0B      -   176K  -
zdata/f0/zdata/enc@zrepl_20250701_194148_000     0B      -   176K  -
.
.
.
```

### Monitoring replication

You can monitor the replication progress with:

```sh
paul@f0:~ % doas zrepl status
```

TODO: Add screenshot of the above..

With this setup, both `zdata/enc/nfsdata` and `zroot/bhyve/fedora` on f0 will be automatically replicated to f1 every 1 (or 10 in case of the Fedora VM) minutes, with encrypted snapshots preserved on both sides. The pruning policy ensures that we keep the last 10 snapshots while managing disk space efficiently.

The replicated data appears on f1 under `zdata/sink/` with the source host and dataset hierarchy preserved:

* `zdata/enc/nfsdata` → `zdata/sink/f0/zdata/enc/nfsdata`
* `zroot/bhyve/fedora` → `zdata/sink/f0/zroot/bhyve/fedora`

This is by design - `zrepl` preserves the complete path from the source to ensure there are no conflicts when replicating from multiple sources. The replication uses the WireGuard tunnel for secure, encrypted transport between nodes.

### Verifying replication after reboot

The `zrepl` service is configured to start automatically at boot. After rebooting both hosts:

```sh
paul@f0:~ % uptime
11:17PM  up 1 min, 0 users, load averages: 0.16, 0.06, 0.02

paul@f0:~ % doas service `zrepl` status
zrepl is running as pid 2366.

paul@f1:~ % doas service `zrepl` status
zrepl is running as pid 2309.

# Check that new snapshots are being created and replicated
paul@f0:~ % doas zfs list -t snapshot | grep `zrepl` | tail -2
zdata/enc/nfsdata@zrepl_20250701_202530_000                0B      -   200K  -
zroot/bhyve/fedora@zrepl_20250701_202530_000               0B      -  2.97G  -
.
.
.

paul@f1:~ % doas zfs list -t snapshot -r zdata/sink | grep 202530
zdata/sink/f0/zdata/enc/nfsdata@zrepl_20250701_202530_000      0B      -   176K  -
zdata/sink/f0/zroot/bhyve/fedora@zrepl_20250701_202530_000     0B      -  2.97G  -
.
.
.
```

The timestamps confirm that replication resumed automatically after the reboot, ensuring continuous data protection.

### Understanding Failover Limitations and Design Decisions

#### Automatic failover only to a read-only

This storage system intentionally failovers to a read-only copy of the replica in case the primary goes down. This is due to the nature that zrepl only replicates the data in one direction and if we mounted the data set on the sink node read-write, it would make the ZFS data-set diverge from the original and the replication would break. It can still be mounted read-write on the sink node in case of a real issue on the primary node, but that step is left intentional manualy. So we don't need to manually fix the replication later on.

So in summary:

* Split-brain prevention: Automatic failover can cause both nodes to become active simultaneously if network communication fails. This leads to data divergence that's extremely difficult to resolve.
* False positive protection: Temporary network issues or high load can trigger unwanted failovers. Manual intervention ensures failovers only occur when truly necessary.
* Data integrity over availability: For storage systems, data consistency is paramount. A few minutes of downtime is preferable to data corruption or loss.
* Simplified recovery: With manual failover, you always know which dataset is authoritative, making recovery straightforward.


### Mounting the NFS datasets

To make the nfsdata accessible on both nodes, we need to mount them. On f0, this is straightforward:

```sh
# On f0 - set mountpoint for the primary nfsdata
paul@f0:~ % doas zfs set mountpoint=/data/nfs zdata/enc/nfsdata
paul@f0:~ % doas mkdir -p /data/nfs

# Verify it's mounted
paul@f0:~ % df -h /data/nfs
Filesystem           Size    Used   Avail Capacity  Mounted on
zdata/enc/nfsdata    899G    204K    899G     0%    /data/nfs
```

On f1, we need to handle the encryption key and mount the standby copy:

```sh
# On f1 - first check encryption status
paul@f1:~ % doas zfs get keystatus zdata/sink/f0/zdata/enc/nfsdata
NAME                             PROPERTY   VALUE        SOURCE
zdata/sink/f0/zdata/enc/nfsdata  keystatus  unavailable  -

# Load the encryption key (using f0's key stored on the USB)
paul@f1:~ % doas zfs load-key -L file:///keys/f0.lan.buetow.org:zdata.key \
    zdata/sink/f0/zdata/enc/nfsdata

# Set mountpoint and mount (same path as f0 for easier failover)
paul@f1:~ % doas mkdir -p /data/nfs
paul@f1:~ % doas zfs set mountpoint=/data/nfs zdata/sink/f0/zdata/enc/nfsdata
paul@f1:~ % doas zfs mount zdata/sink/f0/zdata/enc/nfsdata

# Make it read-only to prevent accidental writes that would break replication
paul@f1:~ % doas zfs set readonly=on zdata/sink/f0/zdata/enc/nfsdata

# Verify
paul@f1:~ % df -h /data/nfs
Filesystem                         Size    Used   Avail Capacity  Mounted on
zdata/sink/f0/zdata/enc/nfsdata    896G    204K    896G     0%    /data/nfs
```

Note: The dataset is mounted at the same path (`/data/nfs`) on both hosts to simplify failover procedures. The dataset on f1 is set to `readonly=on` to prevent accidental modifications that would break replication.

CRITICAL WARNING: Do NOT write to `/data/nfs/` on f1! Any modifications will break the replication. That's why it is mounted as read-only there (I have the feeloing I mentioned this in this blog post already!)! If you accidentally write to it, you'll see this error:

```
cannot receive incremental stream: destination zdata/sink/f0/zdata/enc/nfsdata has been modified
since most recent snapshot
```

To fix a broken replication after accidental writes:
```sh
# Option 1: Rollback to the last common snapshot (loses local changes)
paul@f1:~ % doas zfs rollback zdata/sink/f0/zdata/enc/nfsdata@zrepl_20250701_204054_000

# Option 2: Make it read-only to prevent accidents
paul@f1:~ % doas zfs set readonly=on zdata/sink/f0/zdata/enc/nfsdata
```

### Troubleshooting: Files not appearing in replication

If you write files to `/data/nfs/` on f0 but they don't appear on f1, check:

Is the dataset actually mounted on f0?

```sh
paul@f0:~ % doas zfs list -o name,mountpoint,mounted | grep nfsdata
zdata/enc/nfsdata                             /data/nfs             yes
```

If it shows `no`, the dataset isn't mounted! This means files are being written to the root filesystem, not ZFS.

Check if encryption key is loaded:

```sh
paul@f0:~ % doas zfs get keystatus zdata/enc/nfsdata
NAME               PROPERTY   VALUE        SOURCE
zdata/enc/nfsdata  keystatus  available    -
# If "unavailable", load the key:
paul@f0:~ % doas zfs load-key -L file:///keys/f0.lan.buetow.org:zdata.key zdata/enc/nfsdata
paul@f0:~ % doas zfs mount zdata/enc/nfsdata
```

Verify files are in the snapshot (not just the directory):

```sh
paul@f0:~ % ls -la /data/nfs/.zfs/snapshot/zrepl_*/
```

This issue commonly occurs after reboot if the encryption keys aren't configured to load automatically.

### Configuring automatic key loading on boot

To ensure all additional encrypted datasets are mounted automatically after reboot as well, we do:

```sh
# On f0 - configure all encrypted datasets
paul@f0:~ % doas sysrc zfskeys_enable=YES
zfskeys_enable: YES -> YES
paul@f0:~ % doas sysrc zfskeys_datasets="zdata/enc zdata/enc/nfsdata zroot/bhyve"
zfskeys_datasets:  -> zdata/enc zdata/enc/nfsdata zroot/bhyve

# Set correct key locations for all datasets
paul@f0:~ % doas zfs set keylocation=file:///keys/f0.lan.buetow.org:zdata.key zdata/enc/nfsdata

# On f1 - include the replicated dataset
paul@f1:~ % doas sysrc zfskeys_enable=YES
zfskeys_enable: YES -> YES
paul@f1:~ % doas sysrc zfskeys_datasets="zdata/enc zroot/bhyve zdata/sink/f0/zdata/enc/nfsdata"
zfskeys_datasets:  -> zdata/enc zroot/bhyve zdata/sink/f0/zdata/enc/nfsdata

# Set key location for replicated dataset
paul@f1:~ % doas zfs set keylocation=file:///keys/f0.lan.buetow.org:zdata.key zdata/sink/f0/zdata/enc/nfsdata
```

Important notes:

* Each encryption root needs its own key load entry - child datasets don't inherit key loading
* The replicated dataset on f1 uses the same encryption key as the source on f0
* Always verify datasets are mounted after reboot with `zfs list -o name,mounted`
* Critical: Always ensure the replicated dataset on f1 remains read-only with `doas zfs set readonly=on zdata/sink/f0/zdata/enc/nfsdata`

### Troubleshooting: Replication broken due to modified destination

If you see the error "cannot receive incremental stream: destination has been modified since most recent snapshot", it means the read-only flag was accidentally removed on f1. To fix without a full resync:

```sh
# Stop `zrepl` on both servers
paul@f0:~ % doas service `zrepl` stop
paul@f1:~ % doas service `zrepl` stop

# Find the last common snapshot
paul@f0:~ % doas zfs list -t snapshot -o name,creation zdata/enc/nfsdata
paul@f1:~ % doas zfs list -t snapshot -o name,creation zdata/sink/f0/zdata/enc/nfsdata

# Rollback f1 to the last common snapshot (example: @zrepl_20250705_000007_000)
paul@f1:~ % doas zfs rollback -r zdata/sink/f0/zdata/enc/nfsdata@zrepl_20250705_000007_000

# Ensure the dataset is read-only
paul@f1:~ % doas zfs set readonly=on zdata/sink/f0/zdata/enc/nfsdata

# Restart zrepl
paul@f0:~ % doas service `zrepl` start
paul@f1:~ % doas service `zrepl` start
```

## CARP (Common Address Redundancy Protocol)

High availability is crucial for storage systems. If the storage server goes down, all pods lose access to their persistent data. CARP provides a solution by creating a virtual IP address that automatically moves between servers during failures.

### How CARP Works

CARP allows two hosts to share a virtual IP address (VIP). The hosts communicate using multicast to elect a MASTER, while the other remain as BACKUP. When the MASTER fails, a BACKUP automatically promotes itself, and the VIP moves to the new MASTER. This happens within seconds.

Key benefits for our storage system:

* Automatic failover: No manual intervention is required for basic failures, although there are a few limitations. The backup will only have read-only access to the available data, as we will learn later. However, we could manually promote it to read-write if needed.
* Transparent to clients: Pods continue using the same IP address
* Works with stunnel: Behind the VIP there will be a `stunnel` process running, which ensures encrypted connections follow the active server
* Simple configuration

### Configuring CARP

First, add the CARP configuration to `/etc/rc.conf` on both f0 and f1:

```sh
# The virtual IP 192.168.1.138 will float between f0 and f1
ifconfig_re0_alias0="inet vhid 1 pass testpass alias 192.168.1.138/32"
```

Whereas:

* `vhid 1`: Virtual Host ID - must match on all CARP members
* `pass testpass`: Password for CARP authentication (if you follow this, use a different password!)
* `alias 192.168.1.138/32`: The virtual IP address with a /32 netmask

Next, update `/etc/hosts` on all nodes (n0, n1, n2, r0, r1, r2) to resolve the VIP hostname:

```
192.168.1.138 f3s-storage-ha f3s-storage-ha.lan f3s-storage-ha.lan.buetow.org
```

This allows clients to connect to `f3s-storage-ha` regardless of which physical server is currently the MASTER.

### CARP State Change Notifications

To properly manage services during failover, we need to detect CARP state changes. FreeBSD's devd system can notify us when CARP transitions between MASTER and BACKUP states.

Add this to `/etc/devd.conf` on both f0 and f1:

paul@f0:~ % cat <<END | doas tee -a /etc/devd.conf
notify 0 {
        match "system"          "CARP";
        match "subsystem"       "[0-9]+@[0-9a-z.]+";
        match "type"            "(MASTER|BACKUP)";
        action "/usr/local/bin/carpcontrol.sh $subsystem $type";
};
END

Next, create the CARP control script that will restart stunnel when CARP state changes:

```sh
paul@f0:~ % doas tee /usr/local/bin/carpcontrol.sh <<'EOF'
#!/bin/sh
# CARP state change control script

case "$1" in
    MASTER)
        logger "CARP state changed to MASTER, starting services"
        service rpcbind start >/dev/null 2>&1
        service mountd start >/dev/null 2>&1
        service nfsd start >/dev/null 2>&1
        service nfsuserd start >/dev/null 2>&1
        service stunnel restart >/dev/null 2>&1
        logger "CARP MASTER: NFS and stunnel services started"
        ;;
    BACKUP)
        logger "CARP state changed to BACKUP, stopping services"
        service stunnel stop >/dev/null 2>&1
        service nfsd stop >/dev/null 2>&1
        service mountd stop >/dev/null 2>&1
        service nfsuserd stop >/dev/null 2>&1
        logger "CARP BACKUP: NFS and stunnel services stopped"
        ;;
    *)
        logger "CARP state changed to $1 (unhandled)"
        ;;
esac
EOF

paul@f0:~ % doas chmod +x /usr/local/bin/carpcontrol.sh

# Copy the same script to f1
paul@f0:~ % scp /usr/local/bin/carpcontrol.sh f1:/tmp/
paul@f1:~ % doas mv /tmp/carpcontrol.sh /usr/local/bin/
paul@f1:~ % doas chmod +x /usr/local/bin/carpcontrol.sh
```

Note that we perform several tasks in the `carpcontrol.sh` script, which starts and/or stops all the services required for an NFS server running over an encrypted tunnel (via `stunnel`). We will set up all those services later in this blog post!

To enable CARP in /boot/loader.conf, run:

```sh
paul@f0:~ % echo 'carp_load="YES"' | doas tee -a /boot/loader.conf
carp_load="YES"
paul@f1:~ % echo 'carp_load="YES"' | doas tee -a /boot/loader.conf  
carp_load="YES"
```

Then reboot both hosts or run `doas kldload carp` to load the module immediately. 

## Future Storage Explorations

While `zrepl` provides excellent snapshot-based replication for disaster recovery, there are other storage technologies worth exploring for the f3s project:

### MinIO for S3-Compatible Object Storage

MinIO is a high-performance, S3-compatible object storage system that could complement our ZFS-based storage. Some potential use cases:

* S3 API compatibility: Many modern applications expect S3-style object storage APIs. MinIO could provide this interface while using our ZFS storage as the backend.
* Multi-site replication: MinIO supports active-active replication across multiple sites, which could work well with our f0/f1/f2 node setup.
* Kubernetes native: MinIO has excellent Kubernetes integration with operators and CSI drivers, making it ideal for the f3s k3s environment.

### MooseFS for Distributed High Availability

MooseFS is a fault-tolerant, distributed file system that could provide true high-availability storage:

* True HA: Unlike our current setup which requires manual failover, MooseFS provides automatic failover with no single point of failure.
* POSIX compliance: Applications can use MooseFS like any regular filesystem, no code changes needed.
* Flexible redundancy: Configure different replication levels per directory or file, optimizing storage efficiency.
* FreeBSD support: MooseFS has native FreeBSD support, making it a natural fit for the f3s project.

Both technologies could potentially run on top of our encrypted ZFS volumes, combining ZFS's data integrity and encryption features with distributed storage capabilities. This would be particularly interesting for workloads that need either S3-compatible APIs (MinIO) or transparent distributed POSIX storage (MooseFS).

## NFS Server Configuration

With ZFS replication in place, we can now set up NFS servers on both f0 and f1 to export the replicated data. Since native NFS over TLS (RFC 9289) has compatibility issues between Linux and FreeBSD, we'll use stunnel to provide encryption.

### Setting up NFS on f0 (Primary)

First, enable the NFS services in rc.conf:

```sh
paul@f0:~ % doas sysrc nfs_server_enable=YES
nfs_server_enable: YES -> YES
paul@f0:~ % doas sysrc nfsv4_server_enable=YES
nfsv4_server_enable: YES -> YES
paul@f0:~ % doas sysrc nfsuserd_enable=YES
nfsuserd_enable: YES -> YES
paul@f0:~ % doas sysrc mountd_enable=YES
mountd_enable: NO -> YES
paul@f0:~ % doas sysrc rpcbind_enable=YES
rpcbind_enable: NO -> YES
```

Create a dedicated directory for Kubernetes volumes:

```sh
# First ensure the dataset is mounted
paul@f0:~ % doas zfs get mounted zdata/enc/nfsdata
NAME               PROPERTY  VALUE    SOURCE
zdata/enc/nfsdata  mounted   yes      -

# Create the k3svolumes directory
paul@f0:~ % doas mkdir -p /data/nfs/k3svolumes
paul@f0:~ % doas chmod 755 /data/nfs/k3svolumes

# This directory will be replicated to f1 automatically
```

Create the /etc/exports file. Since we're using stunnel for encryption, ALL clients must connect through stunnel, which appears as localhost (127.0.0.1) to the NFS server:

```sh
paul@f0:~ % doas tee /etc/exports <<'EOF'
V4: /data/nfs -sec=sys
/data/nfs -alldirs -maproot=root -network 127.0.0.1 -mask 255.255.255.255
EOF
```

The exports configuration:

* `V4: /data/nfs -sec=sys`: Sets the NFSv4 root directory to /data/nfs
* `/data/nfs -alldirs`: Allows mounting any subdirectory under /data/nfs
* `-maproot=root`: Maps root user from client to root on server (needed for Kubernetes and ownership changes)
* `-network 127.0.0.1`: Only accepts connections from localhost (stunnel)

Note: 
* ALL clients (r0, r1, r2, laptop) must connect through stunnel for encryption
* Stunnel proxies connections through localhost, so only 127.0.0.1 needs access
* With NFSv4, clients mount using relative paths (e.g., `/k3svolumes` instead of `/data/nfs/k3svolumes`)

Start the NFS services:

```sh
paul@f0:~ % doas service rpcbind start
Starting rpcbind.
paul@f0:~ % doas service mountd start
Starting mountd.
paul@f0:~ % doas service nfsd start
Starting nfsd.
paul@f0:~ % doas service nfsuserd start
Starting nfsuserd.
```

### Configuring Stunnel for NFS Encryption with CARP Failover

#### Why Not Native NFS over TLS?

FreeBSD 13+ supports native NFS over TLS (RFC 9289), which would be the ideal solution. However, there are significant compatibility challenges:

* Linux client support is incomplete: Most Linux distributions don't fully support NFS over TLS yet
* Certificate management differs: FreeBSD and Linux handle TLS certificates differently for NFS
* Kernel module requirements: Requires specific kernel modules that may not be available

Stunnel provides a more compatible solution that works reliably across all operating systems while offering equivalent security.

#### Stunnel Architecture with CARP

Stunnel integrates seamlessly with our CARP setup:

```
                    CARP VIP (192.168.1.138)
                           |
    f0 (MASTER) ←---------→|←---------→ f1 (BACKUP)
    stunnel:2323           |           stunnel:stopped
    nfsd:2049              |           nfsd:stopped
                           |
                    Clients connect here
```

The key insight is that stunnel binds to the CARP VIP. When CARP fails over, the VIP moves to the new MASTER, and stunnel starts there automatically. Clients maintain their connection to the same IP throughout.

#### Creating a Certificate Authority for Client Authentication

First, create a CA to sign both server and client certificates:

```sh
# On f0 - Create CA
paul@f0:~ % doas mkdir -p /usr/local/etc/stunnel/ca
paul@f0:~ % cd /usr/local/etc/stunnel/ca
paul@f0:~ % doas openssl genrsa -out ca-key.pem 4096
paul@f0:~ % doas openssl req -new -x509 -days 3650 -key ca-key.pem -out ca-cert.pem \
  -subj '/C=US/ST=State/L=City/O=F3S Storage/CN=F3S Stunnel CA'

# Create server certificate
paul@f0:~ % cd /usr/local/etc/stunnel
paul@f0:~ % doas openssl genrsa -out server-key.pem 4096
paul@f0:~ % doas openssl req -new -key server-key.pem -out server.csr \
  -subj '/C=US/ST=State/L=City/O=F3S Storage/CN=f3s-storage-ha.lan'
paul@f0:~ % doas openssl x509 -req -days 3650 -in server.csr -CA ca/ca-cert.pem \
  -CAkey ca/ca-key.pem -CAcreateserial -out server-cert.pem

# Create client certificates for authorized clients
paul@f0:~ % cd /usr/local/etc/stunnel/ca
paul@f0:~ % doas sh -c 'for client in r0 r1 r2 earth; do 
  openssl genrsa -out ${client}-key.pem 4096
  openssl req -new -key ${client}-key.pem -out ${client}.csr \
    -subj "/C=US/ST=State/L=City/O=F3S Storage/CN=${client}.lan.buetow.org"
  openssl x509 -req -days 3650 -in ${client}.csr -CA ca-cert.pem \
    -CAkey ca-key.pem -CAcreateserial -out ${client}-cert.pem
done'
```

#### Install and Configure Stunnel on f0

```sh
# Install stunnel
paul@f0:~ % doas pkg install -y stunnel

# Configure stunnel server with client certificate authentication
paul@f0:~ % doas tee /usr/local/etc/stunnel/stunnel.conf <<'EOF'
cert = /usr/local/etc/stunnel/server-cert.pem
key = /usr/local/etc/stunnel/server-key.pem

setuid = stunnel
setgid = stunnel

[nfs-tls]
accept = 192.168.1.138:2323
connect = 127.0.0.1:2049
CAfile = /usr/local/etc/stunnel/ca/ca-cert.pem
verify = 2
requireCert = yes
EOF

# Enable and start stunnel
paul@f0:~ % doas sysrc stunnel_enable=YES
stunnel_enable:  -> YES
paul@f0:~ % doas service stunnel start
Starting stunnel.

# Restart stunnel to apply the CARP VIP binding
paul@f0:~ % doas service stunnel restart
Stopping stunnel.
Starting stunnel.
```

The configuration includes:
* `verify = 2`: Verify client certificate and fail if not provided
* `requireCert = yes`: Client must present a valid certificate
* `CAfile`: Path to the CA certificate that signed the client certificates

### Setting up NFS on f1 (Standby)

Repeat the same configuration on f1:

```sh
paul@f1:~ % doas sysrc nfs_server_enable=YES
nfs_server_enable: NO -> YES
paul@f1:~ % doas sysrc nfsv4_server_enable=YES
nfsv4_server_enable: NO -> YES
paul@f1:~ % doas sysrc nfsuserd_enable=YES
nfsuserd_enable: NO -> YES
paul@f1:~ % doas sysrc mountd_enable=YES
mountd_enable: NO -> YES
paul@f1:~ % doas sysrc rpcbind_enable=YES
rpcbind_enable: NO -> YES

paul@f1:~ % doas tee /etc/exports <<'EOF'
V4: /data/nfs -sec=sys
/data/nfs -alldirs -maproot=root -network 127.0.0.1 -mask 255.255.255.255
EOF

paul@f1:~ % doas service rpcbind start
Starting rpcbind.
paul@f1:~ % doas service mountd start
Starting mountd.
paul@f1:~ % doas service nfsd start
Starting nfsd.
paul@f1:~ % doas service nfsuserd start
Starting nfsuserd.
```

Configure stunnel on f1:

```sh
# Install stunnel
paul@f1:~ % doas pkg install -y stunnel

# Copy certificates from f0
paul@f0:~ % doas tar -cf /tmp/stunnel-certs.tar -C /usr/local/etc/stunnel server-cert.pem server-key.pem ca
paul@f0:~ % scp /tmp/stunnel-certs.tar f1:/tmp/
paul@f1:~ % cd /usr/local/etc/stunnel && doas tar -xf /tmp/stunnel-certs.tar

# Configure stunnel server on f1 with client certificate authentication
paul@f1:~ % doas tee /usr/local/etc/stunnel/stunnel.conf <<'EOF'
cert = /usr/local/etc/stunnel/server-cert.pem
key = /usr/local/etc/stunnel/server-key.pem

setuid = stunnel
setgid = stunnel

[nfs-tls]
accept = 192.168.1.138:2323
connect = 127.0.0.1:2049
CAfile = /usr/local/etc/stunnel/ca/ca-cert.pem
verify = 2
requireCert = yes
EOF

# Enable and start stunnel
paul@f1:~ % doas sysrc stunnel_enable=YES
stunnel_enable:  -> YES
paul@f1:~ % doas service stunnel start
Starting stunnel.

# Restart stunnel to apply the CARP VIP binding
paul@f1:~ % doas service stunnel restart
Stopping stunnel.
Starting stunnel.
```

### How Stunnel Works with CARP

With stunnel configured to bind to the CARP VIP (192.168.1.138), only the server that is currently the CARP MASTER will accept stunnel connections. This provides automatic failover for encrypted NFS:

* When f0 is CARP MASTER: stunnel on f0 accepts connections on 192.168.1.138:2323
* When f1 becomes CARP MASTER: stunnel on f1 starts accepting connections on 192.168.1.138:2323
* The backup server's stunnel process will fail to bind to the VIP and won't accept connections

This ensures that clients always connect to the active NFS server through the CARP VIP.

### CARP Control Script for Clean Failover

To ensure clean failover behavior and prevent stale file handles, we'll create a control script that:
* Stops NFS services on BACKUP nodes (preventing split-brain scenarios)
* Starts NFS services only on the MASTER node
* Manages stunnel binding to the CARP VIP

This approach ensures clients can only connect to the active server, eliminating stale handles from the inactive server:

```sh
# Create CARP control script on both f0 and f1
paul@f0:~ % doas tee /usr/local/bin/carpcontrol.sh <<'EOF'
#!/bin/sh
# CARP state change control script

case "$1" in
    MASTER)
        logger "CARP state changed to MASTER, starting services"
        service rpcbind start >/dev/null 2>&1
        service mountd start >/dev/null 2>&1
        service nfsd start >/dev/null 2>&1
        service nfsuserd start >/dev/null 2>&1
        service stunnel restart >/dev/null 2>&1
        logger "CARP MASTER: NFS and stunnel services started"
        ;;
    BACKUP)
        logger "CARP state changed to BACKUP, stopping services"
        service stunnel stop >/dev/null 2>&1
        service nfsd stop >/dev/null 2>&1
        service mountd stop >/dev/null 2>&1
        service nfsuserd stop >/dev/null 2>&1
        logger "CARP BACKUP: NFS and stunnel services stopped"
        ;;
    *)
        logger "CARP state changed to $1 (unhandled)"
        ;;
esac
EOF

paul@f0:~ % doas chmod +x /usr/local/bin/carpcontrol.sh

# Add to devd configuration
paul@f0:~ % doas tee -a /etc/devd.conf <<'EOF'

# CARP state change notifications
notify 0 {
    match "system" "CARP";
    match "subsystem" "[0-9]+@[a-z]+[0-9]+";
    match "type" "(MASTER|BACKUP)";
    action "/usr/local/bin/carpcontrol.sh $type";
};
EOF

# Restart devd to apply changes
paul@f0:~ % doas service devd restart
```

This enhanced script ensures that:
* Only the MASTER node runs NFS and stunnel services
* BACKUP nodes have all services stopped, preventing any client connections
* Failovers are clean with no possibility of accessing the wrong server
* Stale file handles are minimized because the old server immediately stops responding

### CARP Management Script

To simplify CARP state management and failover testing, create this helper script on both f0 and f1:

```sh
# Create the CARP management script
paul@f0:~ % doas tee /usr/local/bin/carp <<'EOF'
#!/bin/sh
# CARP state management script
# Usage: carp [master|backup|auto-failback enable|auto-failback disable]
# Without arguments: shows current state

# Find the interface with CARP configured
CARP_IF=$(ifconfig -l | xargs -n1 | while read if; do
    ifconfig "$if" 2>/dev/null | grep -q "carp:" && echo "$if" && break
done)

if [ -z "$CARP_IF" ]; then
    echo "Error: No CARP interface found"
    exit 1
fi

# Get CARP VHID
VHID=$(ifconfig "$CARP_IF" | grep "carp:" | sed -n 's/.*vhid \([0-9]*\).*/\1/p')

if [ -z "$VHID" ]; then
    echo "Error: Could not determine CARP VHID"
    exit 1
fi

# Function to get current state
get_state() {
    ifconfig "$CARP_IF" | grep "carp:" | awk '{print $2}'
}

# Check for auto-failback block file
BLOCK_FILE="/data/nfs/nfs.NO_AUTO_FAILBACK"
check_auto_failback() {
    if [ -f "$BLOCK_FILE" ]; then
        echo "WARNING: Auto-failback is DISABLED (file exists: $BLOCK_FILE)"
    fi
}

# Main logic
case "$1" in
    "")
        # No argument - show current state
        STATE=$(get_state)
        echo "CARP state on $CARP_IF (vhid $VHID): $STATE"
        check_auto_failback
        ;;
    master)
        # Force to MASTER state
        echo "Setting CARP to MASTER state..."
        ifconfig "$CARP_IF" vhid "$VHID" state master
        sleep 1
        STATE=$(get_state)
        echo "CARP state on $CARP_IF (vhid $VHID): $STATE"
        check_auto_failback
        ;;
    backup)
        # Force to BACKUP state
        echo "Setting CARP to BACKUP state..."
        ifconfig "$CARP_IF" vhid "$VHID" state backup
        sleep 1
        STATE=$(get_state)
        echo "CARP state on $CARP_IF (vhid $VHID): $STATE"
        check_auto_failback
        ;;
    auto-failback)
        case "$2" in
            enable)
                if [ -f "$BLOCK_FILE" ]; then
                    rm "$BLOCK_FILE"
                    echo "Auto-failback ENABLED (removed $BLOCK_FILE)"
                else
                    echo "Auto-failback was already enabled"
                fi
                ;;
            disable)
                if [ ! -f "$BLOCK_FILE" ]; then
                    touch "$BLOCK_FILE"
                    echo "Auto-failback DISABLED (created $BLOCK_FILE)"
                else
                    echo "Auto-failback was already disabled"
                fi
                ;;
            *)
                echo "Usage: $0 auto-failback [enable|disable]"
                echo "  enable:  Remove block file to allow automatic failback"
                echo "  disable: Create block file to prevent automatic failback"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Usage: $0 [master|backup|auto-failback enable|auto-failback disable]"
        echo "  Without arguments: show current CARP state"
        echo "  master: force this node to become CARP MASTER"
        echo "  backup: force this node to become CARP BACKUP"
        echo "  auto-failback enable:  allow automatic failback to f0"
        echo "  auto-failback disable: prevent automatic failback to f0"
        exit 1
        ;;
esac
EOF

paul@f0:~ % doas chmod +x /usr/local/bin/carp

# Copy to f1 as well
paul@f0:~ % scp /usr/local/bin/carp f1:/tmp/
paul@f1:~ % doas cp /tmp/carp /usr/local/bin/carp && doas chmod +x /usr/local/bin/carp
```

Now you can easily manage CARP states and auto-failback:

```sh
# Check current CARP state
paul@f0:~ % doas carp
CARP state on re0 (vhid 1): MASTER

# If auto-failback is disabled, you'll see a warning
paul@f0:~ % doas carp
CARP state on re0 (vhid 1): MASTER
WARNING: Auto-failback is DISABLED (file exists: /data/nfs/nfs.NO_AUTO_FAILBACK)

# Force f0 to become BACKUP (triggers failover to f1)
paul@f0:~ % doas carp backup
Setting CARP to BACKUP state...
CARP state on re0 (vhid 1): BACKUP

# Disable auto-failback (useful for maintenance)
paul@f0:~ % doas carp auto-failback disable
Auto-failback DISABLED (created /data/nfs/nfs.NO_AUTO_FAILBACK)

# Enable auto-failback
paul@f0:~ % doas carp auto-failback enable
Auto-failback ENABLED (removed /data/nfs/nfs.NO_AUTO_FAILBACK)
```

This enhanced script:
- Shows warnings when auto-failback is disabled
- Provides easy control over the auto-failback feature
- Makes failover testing and maintenance simpler

### Automatic Failback After Reboot

When f0 reboots (planned or unplanned), f1 takes over as CARP MASTER. To ensure f0 automatically reclaims its primary role once it's fully operational, we'll implement an automatic failback mechanism.

#### Why Automatic Failback?

- **Primary node preference**: f0 has the primary storage; it should be MASTER when available
- **Post-reboot automation**: Eliminates manual intervention after every f0 reboot
- **Maintenance flexibility**: Can be disabled when you want f1 to remain MASTER

#### The Auto-Failback Script

Create this script on f0 only (not on f1):

```sh
paul@f0:~ % doas tee /usr/local/bin/carp-auto-failback.sh <<'EOF'
#!/bin/sh
# CARP automatic failback script for f0
# Ensures f0 reclaims MASTER role after reboot when storage is ready

LOGFILE="/var/log/carp-auto-failback.log"
MARKER_FILE="/data/nfs/nfs.DO_NOT_REMOVE"
BLOCK_FILE="/data/nfs/nfs.NO_AUTO_FAILBACK"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

# Check if we're already MASTER
CURRENT_STATE=$(/usr/local/bin/carp | awk '{print $NF}')
if [ "$CURRENT_STATE" = "MASTER" ]; then
    exit 0
fi

# Check if /data/nfs is mounted
if ! mount | grep -q "on /data/nfs "; then
    log_message "SKIP: /data/nfs not mounted"
    exit 0
fi

# Check if marker file exists (identifies this as primary storage)
if [ ! -f "$MARKER_FILE" ]; then
    log_message "SKIP: Marker file $MARKER_FILE not found"
    exit 0
fi

# Check if failback is blocked (for maintenance)
if [ -f "$BLOCK_FILE" ]; then
    log_message "SKIP: Failback blocked by $BLOCK_FILE"
    exit 0
fi

# Check if NFS services are running (ensure we're fully ready)
if ! service nfsd status >/dev/null 2>&1; then
    log_message "SKIP: NFS services not yet running"
    exit 0
fi

# All conditions met - promote to MASTER
log_message "CONDITIONS MET: Promoting to MASTER (was $CURRENT_STATE)"
/usr/local/bin/carp master

# Log result
sleep 2
NEW_STATE=$(/usr/local/bin/carp | awk '{print $NF}')
log_message "Failback complete: State is now $NEW_STATE"

# If successful, log to system log too
if [ "$NEW_STATE" = "MASTER" ]; then
    logger "CARP: f0 automatically reclaimed MASTER role"
fi
EOF

paul@f0:~ % doas chmod +x /usr/local/bin/carp-auto-failback.sh
```

#### Setting Up the Marker File

The marker file identifies f0's primary storage. Create it once:

```sh
paul@f0:~ % doas touch /data/nfs/nfs.DO_NOT_REMOVE
```

This file will be replicated to f1, but since f1 mounts the dataset at a different path, it won't trigger failback there.

#### Configuring Cron

Add a cron job to check every minute:

```sh
paul@f0:~ % echo "* * * * * /usr/local/bin/carp-auto-failback.sh" | doas crontab -
```

#### Managing Automatic Failback

The enhanced CARP script provides integrated control over auto-failback:

**To temporarily disable automatic failback** (e.g., for f0 maintenance):
```sh
paul@f0:~ % doas carp auto-failback disable
Auto-failback DISABLED (created /data/nfs/nfs.NO_AUTO_FAILBACK)
```

**To re-enable automatic failback**:
```sh
paul@f0:~ % doas carp auto-failback enable
Auto-failback ENABLED (removed /data/nfs/nfs.NO_AUTO_FAILBACK)
```

**To check if auto-failback is enabled**:
```sh
paul@f0:~ % doas carp
CARP state on re0 (vhid 1): MASTER
# If disabled, you'll see: WARNING: Auto-failback is DISABLED
```

**To monitor failback attempts**:
```sh
paul@f0:~ % tail -f /var/log/carp-auto-failback.log
```

#### How It Works

1. **After f0 reboots**: f1 is MASTER, f0 boots as BACKUP
2. **Cron runs every minute**: Checks if conditions are met
3. **Safety checks**:
   - Is f0 currently BACKUP? (don't run if already MASTER)
   - Is /data/nfs mounted? (ZFS datasets are ready)
   - Does marker file exist? (confirms this is primary storage)
   - Is failback blocked? (admin can prevent failback)
   - Are NFS services running? (system is fully ready)
4. **Failback occurs**: Typically 2-3 minutes after boot completes
5. **Logging**: All attempts logged for troubleshooting

This ensures f0 automatically resumes its role as primary storage server after any reboot, while providing administrative control when needed.

### Verifying Stunnel and CARP Status

First, check which host is currently CARP MASTER:

```sh
# On f0 - check CARP status
paul@f0:~ % ifconfig re0 | grep carp
	inet 192.168.1.130 netmask 0xffffff00 broadcast 192.168.1.255
	inet 192.168.1.138 netmask 0xffffffff broadcast 192.168.1.138 vhid 1

# If f0 is MASTER, verify stunnel is listening on the VIP
paul@f0:~ % doas sockstat -l | grep 2323
stunnel  stunnel    1234  3  tcp4   192.168.1.138:2323    *:*

# On f1 - check CARP status  
paul@f1:~ % ifconfig re0 | grep carp
	inet 192.168.1.131 netmask 0xffffff00 broadcast 192.168.1.255

# If f1 is BACKUP, stunnel won't be able to bind to the VIP
paul@f1:~ % doas tail /var/log/messages | grep stunnel
Jul  4 12:34:56 f1 stunnel: [!] bind: 192.168.1.138:2323: Can't assign requested address (49)
```

### Verifying NFS Exports

Check that the exports are active on both servers:

```sh
# On f0
paul@f0:~ % doas showmount -e localhost
Exports list on localhost:
/data/nfs                          127.0.0.1

# On f1
paul@f1:~ % doas showmount -e localhost
Exports list on localhost:
/data/nfs                          127.0.0.1
```

### Client Configuration for Stunnel

To mount NFS shares with stunnel encryption, clients need to install and configure stunnel with their client certificates.

#### Preparing Client Certificates

On f0, prepare the client certificate packages:

```sh
# Create combined certificate/key files for each client
paul@f0:~ % cd /usr/local/etc/stunnel/ca
paul@f0:~ % doas sh -c 'for client in r0 r1 r2 earth; do
  cat ${client}-cert.pem ${client}-key.pem > /tmp/${client}-stunnel.pem
done'
```

#### Configuring Rocky Linux Clients (r0, r1, r2)

```sh
# Install stunnel on client (example for r0)
[root@r0 ~]# dnf install -y stunnel

# Copy client certificate and CA certificate from f0
[root@r0 ~]# scp f0:/tmp/r0-stunnel.pem /etc/stunnel/
[root@r0 ~]# scp f0:/usr/local/etc/stunnel/ca/ca-cert.pem /etc/stunnel/

# Configure stunnel client with certificate authentication
[root@r0 ~]# tee /etc/stunnel/stunnel.conf <<'EOF'
cert = /etc/stunnel/r0-stunnel.pem
CAfile = /etc/stunnel/ca-cert.pem
client = yes
verify = 2

[nfs-ha]
accept = 127.0.0.1:2323
connect = 192.168.1.138:2323
EOF

# Enable and start stunnel
[root@r0 ~]# systemctl enable --now stunnel

# Repeat for r1 and r2 with their respective certificates
```

Note: Each client must use its own certificate file (r0-stunnel.pem, r1-stunnel.pem, r2-stunnel.pem, or earth-stunnel.pem).

### Testing NFS Mount with Stunnel

Mount NFS through the stunnel encrypted tunnel:

```sh
# Create mount point
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes

# Mount through stunnel (using localhost and NFSv4)
[root@r0 ~]# mount -t nfs4 -o port=2323 127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes

# Verify mount
[root@r0 ~]# mount | grep k3svolumes
127.0.0.1:/data/nfs/k3svolumes on /data/nfs/k3svolumes type nfs4 (rw,relatime,vers=4.2,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,port=2323,timeo=600,retrans=2,sec=sys,clientaddr=127.0.0.1,local_lock=none,addr=127.0.0.1)

# For persistent mount, add to /etc/fstab:
127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes nfs4 port=2323,_netdev 0 0
```

Note: The mount uses localhost (127.0.0.1) because stunnel is listening locally and forwarding the encrypted traffic to the remote server.

Verify the file was written and replicated:

```sh
# Check on f0
paul@f0:~ % cat /data/nfs/test-r0.txt
Test from r0

# After replication interval (5 minutes), check on f1
paul@f1:~ % cat /data/nfs/test-r0.txt
Test from r0
```

### Important: Encryption Keys for Replicated Datasets

When using encrypted ZFS datasets with raw sends (send -w), the replicated datasets on f1 need the encryption keys loaded to access the data:

```sh
# Check encryption status on f1
paul@f1:~ % doas zfs get keystatus zdata/sink/f0/zdata/enc/nfsdata
NAME                             PROPERTY   VALUE        SOURCE
zdata/sink/f0/zdata/enc/nfsdata  keystatus  unavailable  -

# Load the encryption key (uses the same key as f0)
paul@f1:~ % doas zfs load-key -L file:///keys/f0.lan.buetow.org:zdata.key zdata/sink/f0/zdata/enc/nfsdata

# Mount the dataset
paul@f1:~ % doas zfs mount zdata/sink/f0/zdata/enc/nfsdata

# Configure automatic key loading on boot
paul@f1:~ % doas sysrc zfskeys_datasets="zdata/enc zroot/bhyve zdata/sink/f0/zdata/enc/nfsdata"
zfskeys_datasets:  -> zdata/enc zroot/bhyve zdata/sink/f0/zdata/enc/nfsdata
```

This ensures that after a reboot, f1 will automatically load the encryption keys and mount all encrypted datasets, including the replicated ones.

### NFS Failover with CARP and Stunnel

With NFS servers running on both f0 and f1 and stunnel bound to the CARP VIP:

* Automatic failover: When f0 fails, CARP automatically promotes f1 to MASTER
* Stunnel failover: The carpcontrol.sh script automatically starts stunnel on the new MASTER
* Client transparency: Clients always connect to 192.168.1.138:2323, which routes to the active server
* No connection disruption: Existing NFS mounts continue working through the same VIP
* Data consistency: ZFS replication ensures f1 has recent data (within 5-minute window)
* Read-only replica: The replicated dataset on f1 is always mounted read-only to prevent breaking replication
* Manual intervention required for full RW failover: When f1 becomes MASTER, you must:
  1. Stop `zrepl` to prevent conflicts: `doas service `zrepl` stop`
  2. Make the replicated dataset writable: `doas zfs set readonly=off zdata/sink/f0/zdata/enc/nfsdata`
  3. Ensure encryption keys are loaded (should be automatic with zfskeys_enable)
  4. NFS will automatically start serving read/write requests through the VIP

Important: The `/data/nfs` mount on f1 remains read-only during normal operation to ensure replication integrity. In case of a failover, clients can still read data immediately, but write operations require the manual steps above to promote f1 to full read-write mode.

### Testing CARP Failover

To test the failover process:

```sh
# On f0 (current MASTER) - trigger failover
paul@f0:~ % doas ifconfig re0 vhid 1 state backup

# On f1 - verify it becomes MASTER
paul@f1:~ % ifconfig re0 | grep carp
    inet 192.168.1.138 netmask 0xffffffff broadcast 192.168.1.138 vhid 1

# Check stunnel is now listening on f1
paul@f1:~ % doas sockstat -l | grep 2323
stunnel  stunnel    4567  3  tcp4   192.168.1.138:2323    *:*

# On client - verify NFS mount still works
[root@r0 ~]# ls /data/nfs/k3svolumes/
[root@r0 ~]# echo "Test after failover" > /data/nfs/k3svolumes/failover-test.txt
```

### Handling Stale File Handles After Failover

After a CARP failover, NFS clients may experience "Stale file handle" errors because they cached file handles from the previous server. To resolve this:

Manual recovery (immediate fix):
```sh
# Force unmount and remount
[root@r0 ~]# umount -f /data/nfs/k3svolumes
[root@r0 ~]# mount /data/nfs/k3svolumes
```

Automatic recovery options:

1. Use soft mounts with shorter timeouts in `/etc/fstab`:
```
127.0.0.1:/k3svolumes /data/nfs/k3svolumes nfs4 port=2323,_netdev,soft,timeo=10,retrans=2,intr 0 0
```

2. Create an automatic recovery system using systemd timers (checks every 10 seconds):

First, create the monitoring script:
```sh
[root@r0 ~]# cat > /usr/local/bin/check-nfs-mount.sh << 'EOF'
#!/bin/bash
# Fast NFS mount health monitor - runs every 10 seconds via systemd timer

MOUNT_POINT="/data/nfs/k3svolumes"
LOCK_FILE="/var/run/nfs-mount-check.lock"
STATE_FILE="/var/run/nfs-mount.state"

# Use a lock file to prevent concurrent runs
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi
touch "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Quick check - try to stat a directory with very short timeout
if timeout 2s stat "$MOUNT_POINT" >/dev/null 2>&1; then
    # Mount appears healthy
    if [ -f "$STATE_FILE" ]; then
        # Was previously unhealthy, log recovery
        echo "NFS mount recovered at $(date)" | systemd-cat -t nfs-monitor -p info
        rm -f "$STATE_FILE"
    fi
    exit 0
fi

# Mount is unhealthy
if [ ! -f "$STATE_FILE" ]; then
    # First detection of unhealthy state
    echo "NFS mount unhealthy detected at $(date)" | systemd-cat -t nfs-monitor -p warning
    touch "$STATE_FILE"
fi

# Try to fix
echo "Attempting to fix stale NFS mount at $(date)" | systemd-cat -t nfs-monitor -p notice
umount -f "$MOUNT_POINT" 2>/dev/null
sleep 1

if mount "$MOUNT_POINT"; then
    echo "NFS mount fixed at $(date)" | systemd-cat -t nfs-monitor -p info
    rm -f "$STATE_FILE"
else
    echo "Failed to fix NFS mount at $(date)" | systemd-cat -t nfs-monitor -p err
fi
EOF
[root@r0 ~]# chmod +x /usr/local/bin/check-nfs-mount.sh
```

Create the systemd service:
```sh
[root@r0 ~]# cat > /etc/systemd/system/nfs-mount-monitor.service << 'EOF'
[Unit]
Description=NFS Mount Health Monitor
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/check-nfs-mount.sh
StandardOutput=journal
StandardError=journal
EOF
```

Create the systemd timer (runs every 10 seconds):
```sh
[root@r0 ~]# cat > /etc/systemd/system/nfs-mount-monitor.timer << 'EOF'
[Unit]
Description=Run NFS Mount Health Monitor every 10 seconds
Requires=nfs-mount-monitor.service

[Timer]
OnBootSec=30s
OnUnitActiveSec=10s
AccuracySec=1s

[Install]
WantedBy=timers.target
EOF
```

Enable and start the timer:
```sh
[root@r0 ~]# systemctl daemon-reload
[root@r0 ~]# systemctl enable nfs-mount-monitor.timer
[root@r0 ~]# systemctl start nfs-mount-monitor.timer

# Check status
[root@r0 ~]# systemctl status nfs-mount-monitor.timer
● nfs-mount-monitor.timer - Run NFS Mount Health Monitor every 10 seconds
     Loaded: loaded (/etc/systemd/system/nfs-mount-monitor.timer; enabled)
     Active: active (waiting) since Sat 2025-07-06 10:00:00 EEST
    Trigger: Sat 2025-07-06 10:00:10 EEST; 8s left

# Monitor logs
[root@r0 ~]# journalctl -u nfs-mount-monitor -f
```

3. For Kubernetes, use liveness probes that restart pods when NFS becomes stale

Note: Stale file handles are inherent to NFS failover because file handles are server-specific. The best approach depends on your application's tolerance for brief disruptions.

### Complete Failover Test

Here's a comprehensive test of the failover behavior with all optimizations in place:

```sh
# 1. Check initial state
paul@f0:~ % ifconfig re0 | grep carp
    carp: MASTER vhid 1 advbase 1 advskew 0
paul@f1:~ % ifconfig re0 | grep carp
    carp: BACKUP vhid 1 advbase 1 advskew 0

# 2. Create a test file from a client
[root@r0 ~]# echo "test before failover" > /data/nfs/k3svolumes/test-before.txt

# 3. Trigger failover (f0 → f1)
paul@f0:~ % doas ifconfig re0 vhid 1 state backup

# 4. Monitor client behavior
[root@r0 ~]# ls /data/nfs/k3svolumes/
ls: cannot access '/data/nfs/k3svolumes/': Stale file handle

# 5. Check automatic recovery (within 10 seconds)
[root@r0 ~]# journalctl -u nfs-mount-monitor -f
Jul 06 10:15:32 r0 nfs-monitor[1234]: NFS mount unhealthy detected at Sun Jul 6 10:15:32 EEST 2025
Jul 06 10:15:32 r0 nfs-monitor[1234]: Attempting to fix stale NFS mount at Sun Jul 6 10:15:32 EEST 2025
Jul 06 10:15:33 r0 nfs-monitor[1234]: NFS mount fixed at Sun Jul 6 10:15:33 EEST 2025
```

Failover Timeline:
* 0 seconds: CARP failover triggered
* 0-2 seconds: Clients get "Stale file handle" errors (not hanging)
* 3-10 seconds: Soft mounts ensure quick failure of operations
* Within 10 seconds: Automatic recovery via systemd timer

Benefits of the Optimized Setup:
1. No hanging processes - Soft mounts fail quickly
2. Clean failover - Old server stops serving immediately
3. Fast automatic recovery - No manual intervention needed
4. Predictable timing - Recovery within 10 seconds with systemd timer
5. Better visibility - systemd journal provides detailed logs

Important Considerations:
* Recent writes (within 5 minutes) may not be visible after failover due to replication lag
* Applications should handle brief NFS errors gracefully
* For zero-downtime requirements, consider synchronous replication or distributed storage

### Verifying Replication Status

To check if replication is working correctly:

```sh
# Check replication status
paul@f0:~ % doas `zrepl` status

# Check recent snapshots on source
paul@f0:~ % doas zfs list -t snapshot -o name,creation zdata/enc/nfsdata | tail -5

# Check recent snapshots on destination
paul@f1:~ % doas zfs list -t snapshot -o name,creation zdata/sink/f0/zdata/enc/nfsdata | tail -5

# Verify data appears on f1 (should be read-only)
paul@f1:~ % ls -la /data/nfs/k3svolumes/
```

Important: If you see "connection refused" errors in `zrepl` logs, ensure:
* Both servers have `zrepl` running (`doas service `zrepl` status`)
* No firewall or hosts.allow rules are blocking port 8888
* WireGuard is up if using WireGuard IPs for replication

### Post-Reboot Verification

After rebooting the FreeBSD servers, verify the complete stack:

```sh
# Check CARP status on all servers
paul@f0:~ % ifconfig re0 | grep carp
paul@f1:~ % ifconfig re0 | grep carp

# Verify stunnel is running on the MASTER
paul@f0:~ % doas sockstat -l | grep 2323

# Check NFS is exported
paul@f0:~ % doas showmount -e localhost

# Verify all r servers have NFS mounted
[root@r0 ~]# mount | grep nfs
[root@r1 ~]# mount | grep nfs
[root@r2 ~]# mount | grep nfs

# Test write access
[root@r0 ~]# echo "Test after reboot $(date)" > /data/nfs/k3svolumes/test-reboot.txt

# Verify `zrepl` is running and replicating
paul@f0:~ % doas service `zrepl` status
paul@f1:~ % doas service `zrepl` status
```

### Integration with Kubernetes

In your Kubernetes manifests, you can now create PersistentVolumes using the NFS servers:

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity:
    storage: 100Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 192.168.1.138  # f3s-storage-ha.lan (CARP virtual IP)
    path: /data/nfs/k3svolumes
  mountOptions:
    - nfsvers=4
    - tcp
    - hard
    - intr
```

Using the CARP virtual IP (192.168.1.138) instead of direct server IPs ensures that Kubernetes workloads continue to access storage even if the primary NFS server fails. For encryption, configure stunnel on the Kubernetes nodes.

### Security Benefits of Stunnel with Client Certificates

Using stunnel with client certificate authentication for NFS encryption provides several advantages:

* Compatibility: Works with any NFS version and between different operating systems
* Strong encryption: Uses TLS/SSL with configurable cipher suites
* Transparent: Applications don't need modification, encryption happens at transport layer
* Performance: Minimal overhead (~2% in benchmarks)
* Flexibility: Can encrypt any TCP-based protocol, not just NFS
* Strong Authentication: Client certificates provide cryptographic proof of identity
* Access Control: Only clients with valid certificates signed by your CA can connect
* Certificate Revocation: You can revoke access by removing certificates from the CA

### Laptop/Workstation Access

For development workstations like "earth" (laptop), the same stunnel configuration works, but there's an important caveat with NFSv4:

```sh
# Install stunnel
sudo dnf install stunnel

# Configure stunnel (/etc/stunnel/stunnel.conf)
cert = /etc/stunnel/earth-stunnel.pem
CAfile = /etc/stunnel/ca-cert.pem
client = yes
verify = 2

[nfs-ha]
accept = 127.0.0.1:2323
connect = 192.168.1.138:2323

# Enable and start stunnel
sudo systemctl enable --now stunnel

# Mount NFS through stunnel
sudo mount -t nfs4 -o port=2323 127.0.0.1:/ /data/nfs

# Make persistent in /etc/fstab
127.0.0.1:/ /data/nfs nfs4 port=2323,hard,intr,_netdev 0 0
```

#### Important: NFSv4 and Stunnel on Newer Linux Clients

On newer Linux distributions (like Fedora 42+), NFSv4 only uses the specified port for initial mount negotiation, but then establishes data connections directly to port 2049, bypassing stunnel. This doesn't occur on Rocky Linux 9 VMs, which properly route all traffic through the specified port. 

To ensure all NFS traffic goes through the encrypted tunnel on affected systems, you need to use iptables:

```sh
# Redirect all NFS traffic to the CARP VIP through stunnel
sudo iptables -t nat -A OUTPUT -d 192.168.1.138 -p tcp --dport 2049 -j DNAT --to-destination 127.0.0.1:2323

# Make it persistent (example for Fedora)
sudo dnf install iptables-services
sudo service iptables save
sudo systemctl enable iptables

# Or create a startup script
cat > ~/setup-nfs-stunnel.sh << 'EOF'
#!/bin/bash
# Ensure NFSv4 data connections go through stunnel
sudo iptables -t nat -D OUTPUT -d 192.168.1.138 -p tcp --dport 2049 -j DNAT --to-destination 127.0.0.1:2323 2>/dev/null
sudo iptables -t nat -A OUTPUT -d 192.168.1.138 -p tcp --dport 2049 -j DNAT --to-destination 127.0.0.1:2323
EOF
chmod +x ~/setup-nfs-stunnel.sh
```

To verify all traffic is encrypted:
```sh
# Check active connections
sudo ss -tnp | grep -E ":2049|:2323"
# You should see connections to localhost:2323 (stunnel), not direct to the CARP VIP

# Monitor stunnel logs
journalctl -u stunnel -f
# You should see connection logs for all NFS operations
```

Note: The laptop has full access to `/data/nfs` with the `-alldirs` export option, while Kubernetes nodes are restricted to `/data/nfs/k3svolumes`.

The client certificate requirement ensures that:
* Only authorized clients (r0, r1, r2, and earth) can establish stunnel connections
* Each client has a unique identity that can be individually managed
* Stolen IP addresses alone cannot grant access without the corresponding certificate
* Access can be revoked without changing the server configuration

The combination of ZFS encryption at rest and stunnel in transit ensures data is protected throughout its lifecycle.

This configuration provides a solid foundation for shared storage in the f3s Kubernetes cluster, with automatic replication and encrypted transport.

## Mounting NFS on Rocky Linux 9

### Installing and Configuring NFS Clients on r0, r1, and r2

First, install the necessary packages on all three Rocky Linux nodes:

```sh
# On r0, r1, and r2
dnf install -y nfs-utils stunnel
```

### Configuring Stunnel Client on All Nodes

Copy the certificate and configure stunnel on each Rocky Linux node:

```sh
# On r0
scp f0:/usr/local/etc/stunnel/stunnel.pem /etc/stunnel/
tee /etc/stunnel/stunnel.conf <<'EOF'
cert = /etc/stunnel/stunnel.pem
client = yes

[nfs-ha]
accept = 127.0.0.1:2323
connect = 192.168.1.138:2323
EOF

systemctl enable --now stunnel

# Repeat the same configuration on r1 and r2
```

### Setting Up NFS Mounts

Create mount points and configure persistent mounts on all nodes:

```sh
# On r0, r1, and r2
mkdir -p /data/nfs/k3svolumes

# Add to /etc/fstab for persistent mount (note the NFSv4 relative path)
echo '127.0.0.1:/k3svolumes /data/nfs/k3svolumes nfs4 port=2323,hard,intr,_netdev 0 0' >> /etc/fstab

# Mount the share
mount /data/nfs/k3svolumes
```

### Comprehensive NFS Mount Testing

Here's a detailed test plan to verify NFS mounts are working correctly on all nodes:

#### Test 1: Verify Mount Status on All Nodes

```sh
# On r0
[root@r0 ~]# mount | grep k3svolumes
# Expected output:
# 127.0.0.1:/data/nfs/k3svolumes on /data/nfs/k3svolumes type nfs4 (rw,relatime,vers=4.2,rsize=131072,wsize=131072,namlen=255,hard,proto=tcp,port=2323,timeo=600,retrans=2,sec=sys,clientaddr=127.0.0.1,local_lock=none,addr=127.0.0.1)

# On r1
[root@r1 ~]# mount | grep k3svolumes
# Should show similar output

# On r2
[root@r2 ~]# mount | grep k3svolumes
# Should show similar output
```

#### Test 2: Verify Stunnel Connectivity

```sh
# On r0
[root@r0 ~]# systemctl status stunnel
# Should show: Active: active (running)

[root@r0 ~]# ss -tnl | grep 2323
# Should show: LISTEN 0 128 127.0.0.1:2323 0.0.0.0:*

# Test connection to CARP VIP
[root@r0 ~]# nc -zv 192.168.1.138 2323
# Should show: Connection to 192.168.1.138 2323 port [tcp/*] succeeded!

# Repeat on r1 and r2
```

#### Test 3: File Creation and Visibility Test

```sh
# On r0 - Create test file
[root@r0 ~]# echo "Test from r0 - $(date)" > /data/nfs/k3svolumes/test-r0.txt
[root@r0 ~]# ls -la /data/nfs/k3svolumes/test-r0.txt
# Should show the file with timestamp

# On r1 - Create test file and check r0's file
[root@r1 ~]# echo "Test from r1 - $(date)" > /data/nfs/k3svolumes/test-r1.txt
[root@r1 ~]# ls -la /data/nfs/k3svolumes/
# Should show both test-r0.txt and test-r1.txt

# On r2 - Create test file and check all files
[root@r2 ~]# echo "Test from r2 - $(date)" > /data/nfs/k3svolumes/test-r2.txt
[root@r2 ~]# ls -la /data/nfs/k3svolumes/
# Should show all three files: test-r0.txt, test-r1.txt, test-r2.txt
```

#### Test 4: Verify Files on Storage Servers

```sh
# On f0 (primary storage)
paul@f0:~ % ls -la /data/nfs/k3svolumes/
# Should show all three test files

# Wait 5 minutes for replication, then check on f1
paul@f1:~ % ls -la /data/nfs/k3svolumes/
# Should show all three test files (after replication)
```

#### Test 5: Performance and Concurrent Access Test

```sh
# On r0 - Write large file
[root@r0 ~]# dd if=/dev/zero of=/data/nfs/k3svolumes/test-large-r0.dat bs=1M count=100
# Should complete without errors

# On r1 - Read the file while r2 writes
[root@r1 ~]# dd if=/data/nfs/k3svolumes/test-large-r0.dat of=/dev/null bs=1M &
# Simultaneously on r2
[root@r2 ~]# dd if=/dev/zero of=/data/nfs/k3svolumes/test-large-r2.dat bs=1M count=100

# Check for any errors or performance issues
```

#### Test 6: Directory Operations Test

```sh
# On r0 - Create directory structure
[root@r0 ~]# mkdir -p /data/nfs/k3svolumes/test-dir/subdir1/subdir2
[root@r0 ~]# echo "Deep file" > /data/nfs/k3svolumes/test-dir/subdir1/subdir2/deep.txt

# On r1 - Verify and add files
[root@r1 ~]# ls -la /data/nfs/k3svolumes/test-dir/subdir1/subdir2/
[root@r1 ~]# echo "Another file from r1" > /data/nfs/k3svolumes/test-dir/subdir1/file-r1.txt

# On r2 - Verify complete structure
[root@r2 ~]# find /data/nfs/k3svolumes/test-dir -type f
# Should show both files
```

#### Test 7: Permission and Ownership Test

```sh
# On r0 - Create files with different permissions
[root@r0 ~]# touch /data/nfs/k3svolumes/test-perms-644.txt
[root@r0 ~]# chmod 644 /data/nfs/k3svolumes/test-perms-644.txt
[root@r0 ~]# touch /data/nfs/k3svolumes/test-perms-755.txt
[root@r0 ~]# chmod 755 /data/nfs/k3svolumes/test-perms-755.txt

# On r1 and r2 - Verify permissions are preserved
[root@r1 ~]# ls -l /data/nfs/k3svolumes/test-perms-*.txt
[root@r2 ~]# ls -l /data/nfs/k3svolumes/test-perms-*.txt
# Permissions should match what was set on r0
```

#### Test 8: Failover Test (Optional but Recommended)

```sh
# On f0 - Trigger CARP failover
paul@f0:~ % doas ifconfig re0 vhid 1 state backup

# On all Rocky nodes - Verify mounts still work
[root@r0 ~]# echo "Test during failover from r0 - $(date)" > /data/nfs/k3svolumes/failover-test-r0.txt
[root@r1 ~]# echo "Test during failover from r1 - $(date)" > /data/nfs/k3svolumes/failover-test-r1.txt
[root@r2 ~]# echo "Test during failover from r2 - $(date)" > /data/nfs/k3svolumes/failover-test-r2.txt

# Verify all files are accessible
[root@r0 ~]# ls -la /data/nfs/k3svolumes/failover-test-*.txt

# On f1 - Verify it's now MASTER
paul@f1:~ % ifconfig re0 | grep carp
# Should show the VIP 192.168.1.138

# Restore f0 as MASTER
paul@f0:~ % doas ifconfig re0 vhid 1 state master
```

### Troubleshooting Common Issues

#### Mount Hangs or Times Out

```sh
# Check stunnel connectivity
systemctl status stunnel
ss -tnl | grep 2323
telnet 127.0.0.1 2323

# Check if you can reach the CARP VIP
ping 192.168.1.138
nc -zv 192.168.1.138 2323

# Check for firewall issues
iptables -L -n | grep 2323
```

#### Permission Denied Errors

```sh
# Verify the export allows your IP
# On f0 or f1
doas showmount -e localhost

# Check if SELinux is blocking (on Rocky Linux)
getenforce
# If enforcing, try:
setenforce 0  # Temporary for testing
# Or add proper SELinux context:
setsebool -P use_nfs_home_dirs 1
```

#### Files Not Visible Across Nodes

```sh
# Force NFS cache refresh
# On the affected node
umount /data/nfs/k3svolumes
mount /data/nfs/k3svolumes

# Check NFS version
nfsstat -m
# Should show NFSv4
```

#### I/O Errors When Accessing NFS Mount

I/O errors can have several causes:

1. Missing localhost in exports (most common with stunnel):
   - Since stunnel proxies connections, the NFS server sees requests from 127.0.0.1
   - Ensure your exports include localhost access:
   ```
   /data/nfs/k3svolumes -maproot=root -network 127.0.0.1 -mask 255.255.255.255
   ```

2. Stunnel connection issues or CARP failover:

```sh
# On the affected node (e.g., r0)
# Check stunnel is running
systemctl status stunnel

# Restart stunnel to re-establish connection
systemctl restart stunnel

# Force remount
umount -f -l /data/nfs/k3svolumes
mount -t nfs4 -o port=2323,hard,intr 127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes

# Check which FreeBSD host is CARP MASTER
# On f0
ssh f0 "ifconfig re0 | grep carp"
# On f1
ssh f1 "ifconfig re0 | grep carp"

# Verify stunnel on MASTER is bound to VIP
# On the MASTER host
ssh <master-host> "sockstat -l | grep 2323"

# Debug stunnel connection
openssl s_client -connect 192.168.1.138:2323 </dev/null

# If persistent I/O errors, check logs
journalctl -u stunnel -n 50
dmesg | tail -20 | grep -i nfs
```

### Comprehensive Production Test Results

After implementing all the improvements (enhanced CARP control script, soft mounts, and automatic recovery), here's a complete test of the setup including reboots and failovers:

#### Test Scenario: Full System Reboot and Failover

```
1. Initial state: Rebooted all servers (f0, f1, f2)
   - Result: f1 became CARP MASTER after reboot (not always f0)
   - NFS accessible and writable from all clients
   
2. Created test file from laptop:
   paul@earth:~ % echo "Post-reboot test at $(date)" > /data/nfs/k3svolumes/reboot-test.txt
   
3. Verified 1-minute replication to f1:
   - File appeared on f1 within 70 seconds
   - Content identical on both servers
   
4. Performed failover from f0 to f1:
   paul@f0:~ % doas ifconfig re0 vhid 1 state backup
   - f1 immediately became MASTER
   - Clients experienced "Stale file handle" errors
   - With soft mounts: No hanging, immediate error response
   
5. Recovery time:
   - Manual recovery: Immediate with umount/mount
   - Automatic recovery: Within 10 seconds via systemd timer
   - No data loss during failover
   
6. Failback to f0:
   paul@f1:~ % doas ifconfig re0 vhid 1 state backup
   - f0 reclaimed MASTER status
   - Similar stale handle behavior
   - Recovery within 10 seconds
```

#### Key Findings

1. CARP Master Selection: After reboot, either f0 or f1 can become MASTER. This is normal CARP behavior and doesn't affect functionality.

2. Stale File Handles: Despite all optimizations, NFS clients still experience stale file handles during failover. This is inherent to NFS protocol design. However:
   - Soft mounts prevent hanging
   - Automatic recovery works reliably
   - No data loss occurs

3. Replication Timing: The 1-minute replication interval for NFS data ensures minimal data loss window during unplanned failovers. The Fedora VM replication runs every 10 minutes, which is sufficient for less critical VM data.

4. Service Management: The enhanced carpcontrol.sh script successfully stops services on BACKUP nodes, preventing split-brain scenarios.

## Performance Considerations

### Encryption Overhead

Stunnel adds CPU overhead for TLS encryption/decryption. On modern hardware, the impact is minimal:

* Beelink Mini PCs: With hardware AES acceleration, expect 5-10% CPU overhead
* Network throughput: Gigabit Ethernet is usually the bottleneck, not TLS
* Latency: Adds <1ms in LAN environments

For reference, with AES-256-GCM on a typical mini PC:
* Sequential reads: ~110 MB/s (near line-speed for gigabit)
* Sequential writes: ~105 MB/s
* Random 4K IOPS: ~15% reduction compared to unencrypted

### Replication Bandwidth

ZFS replication with `zrepl` is efficient, only sending changed blocks:

* Initial sync: Full dataset size (can be large)
* Incremental: Typically <1% of dataset size per snapshot
* Network usage: With 1-minute intervals and moderate changes, expect 10-50 MB/minute

To monitor replication bandwidth:
```sh
# On f0, check network usage on WireGuard interface
doas systat -ifstat 1
# Look for wg0 traffic during replication
```

### NFS Tuning

For optimal performance with Kubernetes workloads:

```sh
# On NFS server (f0/f1) - /etc/sysctl.conf
vfs.nfsd.async=1                    # Enable async writes (careful with data integrity)
vfs.nfsd.cachetcp=1                 # Cache TCP connections
vfs.nfsd.tcphighwater=64            # Increase TCP connection limit

# On NFS clients - mount options
rsize=131072,wsize=131072           # Larger read/write buffers
hard,intr                           # Hard mount with interruption
vers=4.2                            # Use latest NFSv4.2 for best performance
```

### ZFS Tuning

Key ZFS settings for NFS storage:

```sh
# Set on the NFS dataset
zfs set compression=lz4 zdata/enc/nfsdata              # Fast compression
zfs set atime=off zdata/enc/nfsdata                    # Disable access time updates
zfs set redundant_metadata=most zdata/enc/nfsdata      # Protect metadata
```

### Monitoring

Monitor system performance to identify bottlenecks:

```sh
# CPU and memory
doas top -P

# Disk I/O
doas gstat -p

# Network traffic
doas netstat -w 1 -h

# ZFS statistics
doas zpool iostat -v 1

# NFS statistics
doas nfsstat -s -w 1
```

### Cleanup After Testing

```sh
# Remove test files (run on any node)
rm -f /data/nfs/k3svolumes/test-*.txt
rm -f /data/nfs/k3svolumes/test-large-*.dat
rm -f /data/nfs/k3svolumes/failover-test-*.txt
rm -f /data/nfs/k3svolumes/test-perms-*.txt
rm -rf /data/nfs/k3svolumes/test-dir
```

This comprehensive testing ensures that:
* All nodes can mount the NFS share
* Files created on one node are visible on all others
* The encrypted stunnel connection is working
* Permissions and ownership are preserved
* The setup can handle concurrent access
* Failover works correctly (if tested)

## Conclusion

We've built a robust, encrypted storage system for our FreeBSD-based Kubernetes cluster that provides:

### What We Achieved

* High Availability: CARP ensures the storage VIP moves automatically during failures
* Data Protection: ZFS encryption protects data at rest, stunnel protects data in transit
* Continuous Replication: 1-minute RPO for critical data, automated via zrepl
* Secure Access: Client certificate authentication prevents unauthorized access
* Kubernetes Integration: Shared storage accessible from all cluster nodes

### Architecture Benefits

This design prioritizes data integrity over pure availability:
* Manual failover prevents split-brain scenarios
* Certificate-based authentication provides strong security
* Encrypted replication protects data even over untrusted networks
* ZFS snapshots enable point-in-time recovery

### Lessons Learned

1. Stunnel vs Native NFS/TLS: While native encryption would be ideal, stunnel provides better cross-platform compatibility
2. Manual vs Automatic Failover: For storage systems, controlled failover often prevents more problems than it causes
3. Replication Frequency: Balance between data protection (RPO) and system load
4. Client Compatibility: Different NFS implementations behave differently - test thoroughly

### Next Steps

With reliable storage in place, we can now:
* Deploy stateful applications on Kubernetes
* Set up databases with persistent volumes
* Create shared configuration stores
* Implement backup strategies using ZFS snapshots

The storage layer is the foundation for any serious Kubernetes deployment. By building it on FreeBSD with ZFS, CARP, and stunnel, we get enterprise-grade features on commodity hardware.

### References

* FreeBSD CARP documentation: https://docs.freebsd.org/en/books/handbook/advanced-networking/#carp
* ZFS encryption guide: https://docs.freebsd.org/en/books/handbook/zfs/#zfs-encryption
* Stunnel documentation: https://www.stunnel.org/docs.html
* `zrepl` documentation: https://zrepl.github.io/

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
