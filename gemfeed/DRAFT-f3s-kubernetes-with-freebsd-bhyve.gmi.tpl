# f3s: Kubernetes with FreeBSD - Rocky Linux Bhyve VMs - Part 3

This is the third blog post about my f3s series for my self-hosting demands in my home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution we will use on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-frhyveeebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, we are going to install the Bhyve hypervisor.

The FreeBSD Bhyve hypervisor is a lightweight, modern hypervisor that enables virtualization on FreeBSD systems. Bhyve's strengths include its minimal overhead, which allows it to achieve near-native performance for virtual machines. It is designed to be efficient and lightweight, leveraging the capabilities of the FreeBSD operating system for performance and network management. 

Bhyve supports running a variety of guest operating systems, including FreeBSD, Linux, and Windows, on hardware platforms that support hardware virtualization extensions (such as Intel VT-x or AMD-V). In our case, we are going to virtualize Rocky Linux, which later on in this series will be used to run k3s.

## Basic Bhyve setup

For the management of the Bhyve VMs, we are using `vm-bhyve`, a tool not part of the FreeBSD operating system but available as a ready-to-use package. It eases VM management and reduces a lot of the overhead. We also install the required package to make Bhyve work with the UEFI firmware.

=> https://github.com/churchers/vm-bhyve

The following commands are executed on all three hosts `f0`, `f1`, and `f2`, where `re0` is the name of the Ethernet interface (which may need to be adjusted if your hardware is different):

```sh
paul@f2:~ % doas pkg install vm-bhyve bhyve-firmware
paul@f2:~ % doas sysrc vm_enable=YES
vm_enable:  -> YES
paul@f2:~ % doas sysrc vm_dir=zfs:zroot/bhyve
vm_dir:  -> zfs:zroot/bhyve
paul@f2:~ % doas zfs create zroot/bhyve
paul@f2:~ % doas vm init
paul@f2:~ % doas vm create public
paul@f2:~ % doas vm switch add public re0
```

Bhyve stores all it's data in the `/bhyve` of the `zroot` ZFS pool:

```sh
paul@f2:~ % zfs list | grep bhyve
zroot/bhyve                                   1.74M   453G  1.74M  /zroot/bhyve
```

For convenience, we also create this symlink:

```sh
paul@f2:~ % doas ln -s /zroot/bhyve/ /bhyve

```

Now, Bhyve is ready to rumble, but no VMs are there yet:

```sh
paul@f2:~ % doas vm list
NAME  DATASTORE  LOADER  CPU  MEMORY  VNC  AUTO  STATE
```

## Rocky Linux VMs

### ISO download

We're going to install the Rocky Linux from the latest minimal iso:

```sh
paul@f2:~ % doas vm iso \
 https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.5-x86_64-minimal.iso
/zroot/bhyve/.iso/Rocky-9.5-x86_64-minimal.iso        1808 MB 4780 kBps 06m28s
paul@f2:/bhyve % doas vm create rocky
```
### VM configuration

The default configuration looks like this now:

```sh
paul@f2:/bhyve/rocky % cat rocky.conf
loader="bhyveload"
cpu=1
memory=256M
network0_type="virtio-net"
network0_switch="public"
disk0_type="virtio-blk"
disk0_name="disk0.img"
uuid="1c4655ac-c828-11ef-a920-e8ff1ed71ca0"
network0_mac="58:9c:fc:0d:13:3f"
```

but in order to make Rocky Linux boot, it...

### VM installation

```sh
paul@f2:~ % doas vm install rocky Rocky-9.5-x86_64-minimal.iso
Starting rocky
  * found guest in /zroot/bhyve/rocky
  * booting...

paul@f0:/bhyve/rocky % doas vm list
NAME   DATASTORE  LOADER  CPU  MEMORY  VNC           AUTO  STATE
rocky  default    uefi    4    14G     0.0.0.0:5900  No    Locked (f0.lan.buetow.org)

paul@f0:/bhyve/rocky % doas sockstat -4 | grep 5900
root     bhyve       6079 8   tcp4   *:5900                *:*
```

Port 5900 is now also open for VNC connections, so we connect to it with a VNC client and run through the installation dialogs. I'm sure this could be done unattended or more automated, but we have only 3 VMs to install, and the automation doesn't seem worth it as we are doing it only once.



Other *BSD-related posts:

<< template::inline::index bsd

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
