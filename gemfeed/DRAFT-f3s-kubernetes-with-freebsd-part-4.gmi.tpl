# f3s: Kubernetes with FreeBSD - Rocky Linux Bhyve VMs - Part 4

This is the fourth blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-frhyveeebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, we are going to install the Bhyve hypervisor.

The FreeBSD Bhyve hypervisor is a lightweight, modern hypervisor that enables virtualization on FreeBSD systems. Bhyve's strengths include its minimal overhead, which allows it to achieve near-native performance for virtual machines. It's efficient and lightweight, leveraging the capabilities of the FreeBSD operating system for performance and network management.

Bhyve supports running various guest operating systems, including FreeBSD, Linux, and Windows, on hardware platforms that support hardware virtualization extensions (such as Intel VT-x or AMD-V). In our case, we are going to virtualize Rocky Linux, which will later in this series be used to run k3s.

## Check for `POPCNT` CPU support

POPCNT is a CPU instruction that counts the number of set bits (ones) in a binary number. CPU virtualization and Bhyve support for the POPCNT instruction are important because guest operating systems utilize this instruction to perform various tasks more efficiently. If the host CPU supports POPCNT, Bhyve can pass this capability to virtual machines for better performance. Without POPCNT support, some applications might not run or perform sub-optimally in virtualized environments.

To check for `POPCNT` support, run:

```sh
paul@f0:~ % dmesg | grep 'Features2=.*POPCNT'
  Features2=0x7ffafbbf<SSE3,PCLMULQDQ,DTES64,MON,DS_CPL,VMX,EST,TM2,SSSE3,SDBG,
	FMA,CX16,xTPR,PDCM,PCID,SSE4.1,SSE4.2,x2APIC,MOVBE,POPCNT,TSCDLT,AESNI,XSAVE,
	OSXSAVE,AVX,F16C,RDRAND>
```

So it's there! All good.

## Basic Bhyve setup

For managing the Bhyve VMs, we are using `vm-bhyve`, a tool not part of the FreeBSD operating system but available as a ready-to-use package. It eases VM management and reduces a lot of overhead. We also install the required package to make Bhyve work with the UEFI firmware.

=> https://github.com/churchers/vm-bhyve

The following commands are executed on all three hosts `f0`, `f1`, and `f2`, where `re0` is the name of the Ethernet interface (which may need to be adjusted if your hardware is different):

```sh
paul@f0:~ % doas pkg install vm-bhyve bhyve-firmware
paul@f0:~ % doas sysrc vm_enable=YES
vm_enable:  -> YES
paul@f0:~ % doas sysrc vm_dir=zfs:zroot/bhyve
vm_dir:  -> zfs:zroot/bhyve
paul@f0:~ % doas zfs create zroot/bhyve
paul@f0:~ % doas vm init
paul@f0:~ % doas vm switch create public
paul@f0:~ % doas vm switch add public re0
```

Bhyve stores all it's data in the `/bhyve` of the `zroot` ZFS pool:

```sh
paul@f0:~ % zfs list | grep bhyve
zroot/bhyve                                   1.74M   453G  1.74M  /zroot/bhyve
```

For convenience, we also create this symlink:

```sh
paul@f0:~ % doas ln -s /zroot/bhyve/ /bhyve

```

Now, Bhyve is ready to rumble, but no VMs are there yet:

```sh
paul@f0:~ % doas vm list
NAME  DATASTORE  LOADER  CPU  MEMORY  VNC  AUTO  STATE
```

## Rocky Linux VMs

TODO: Why this Distro?

### ISO download

We're going to install the Rocky Linux from the latest minimal iso:

```sh
paul@f0:~ % doas vm iso \
 https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.5-x86_64-minimal.iso
/zroot/bhyve/.iso/Rocky-9.5-x86_64-minimal.iso        1808 MB 4780 kBps 06m28s
paul@f0:/bhyve % doas vm create rocky
```
### VM configuration

The default configuration looks like this now:

```sh
paul@f0:/bhyve/rocky % cat rocky.conf
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

The `uuid` and the `network0_mac` differ on each host.

But to make Rocky Linux boot it (plus some other adjustments, e.g. as we intend to run the majority of the workload in the k3s cluster running on those Linux VMs, we give them beefy specs like 4 CPU cores and 14GB RAM). So we run `doas vm configure rocky` and modified it to:

```
guest="linux"
loader="uefi"
uefi_vars="yes"
cpu=4
memory=14G
network0_type="virtio-net"
network0_switch="public"
disk0_type="virtio-blk"
disk0_name="disk0.img"
graphics="yes"
graphics_vga=io
uuid="1c45400b-c828-11ef-8871-e8ff1ed71cac"
network0_mac="58:9c:fc:0d:13:3f"
```

### VM installation

To start the installer from the downloaded ISO, I run:

```sh
paul@f0:~ % doas vm install rocky Rocky-9.5-x86_64-minimal.iso
Starting rocky
  * found guest in /zroot/bhyve/rocky
  * booting...

paul@f0:/bhyve/rocky % doas vm list
NAME   DATASTORE  LOADER  CPU  MEMORY  VNC           AUTO  STATE
rocky  default    uefi    4    14G     0.0.0.0:5900  No    Locked (f0.lan.buetow.org)

paul@f0:/bhyve/rocky % doas sockstat -4 | grep 5900
root     bhyve       6079 8   tcp4   *:5900                *:*
```

Port 5900 now also opens for VNC connections, so I connected it with a VNC client and ran through the installation dialogues. This could be done unattended or more automated, but there are only 3 VMs to install, and the automation doesn't seem worth it as we do it only once a year or less often.

### Increase of the disk image

By default, the VM disk image is only 20G, which is a bit small for my purposes, so I stopped the VMs again, ran `truncate` on the image file to enlarge them to 100G, and re-started the installation:

```sh
paul@f0:/bhyve/rocky % doas vm stop rocky
paul@f0:/bhyve/rocky % doas truncate -s 100G disk0.img
paul@f0:/bhyve/rocky % doas vm install rocky Rocky-9.5-x86_64-minimal.iso
```

### Connect to VNC

For the installation, I opened the VNC client on my Fedora laptop (GNOME comes with a simple VNC client) and manually ran through the base installation for each of the VMs. Again, I am sure this could have been automated a bit more, but there were just three VMs, and it wasn't worth the effort. The three VNC addresses of the VMs were `vnc://f0:5900`, `vnc://f1:5900`, and `vnc://f0:5900`.

I primarily selected the default settings (auto partitioning on the 100GB drive and a root user password). After the installation, the VMs were rebooted.

## After install

I performed the following steps for all 3 VMs. In the following, the examples are all executed on `f0` (the VM `r0` running on `f0`):

### VM auto-start after host reboot

To automatically start the VM on the servers, I added the following to the `rc.conf` on the FreeBSD hosts:

```sh

paul@f0:/bhyve/rocky % cat <<END | doas tee -a /etc/rc.conf
vm_list="rocky"
vm_delay="5"
```

The `vm_delay` isn't really required. It is used to wait 5 seconds before starting each VM, but there is currently only one VM per host. Maybe later, when there are more, this will be useful. After adding, there's now a `Yes` indicator in the `AUTO` column.

```sh
paul@f0:~ % doas vm list
NAME   DATASTORE  LOADER  CPU  MEMORY  VNC           AUTO     STATE
rocky  default    uefi    4    14G     0.0.0.0:5900  Yes [1]  Running (2063)
```

### Static IP configuration

After that, I changed the network configuration of the VMs to be static (from DHCP) here. As per the previous post of this series, the 3 FreeBSD hosts were already in my `/etc/hosts` file:

```
192.168.1.130 f0 f0.lan f0.lan.buetow.org
192.168.1.131 f1 f1.lan f1.lan.buetow.org
192.168.1.132 f2 f2.lan f2.lan.buetow.org
```

For the Rocky VMs, I added those to the FreeBSD host systems as well:

```sh
paul@f0:/bhyve/rocky % cat <<END | doas tee -a /etc/hosts
192.168.1.120 r0 r0.lan r0.lan.buetow.org
192.168.1.121 r1 r1.lan r1.lan.buetow.org
192.168.1.122 r2 r2.lan r2.lan.buetow.org
END
```

And configured the IPs accordingly on the VMs themselves by opening a root shell via RDP to the VMs and entering the following commands on each of the VMs:

```sh
[root@r0 ~] % dnmcli connection modify enp0s5 ipv4.address 192.168.1.120/24
[root@r0 ~] % dnmcli connection modify enp0s5 ipv4.gateway 192.168.1.1
[root@r0 ~] % dnmcli connection modify enp0s5 ipv4.DNS 192.168.1.1
[root@r0 ~] % dnmcli connection modify enp0s5 ipv4.method manual
[root@r0 ~] % dnmcli connection down enp0s5
[root@r0 ~] % dnmcli connection up enp0s5
[root@r0 ~] % hostnamectl set-hostname r0.lan.buetow.org
[root@r0 ~] % cat <<END >>/etc/hosts
192.168.1.120 r0 r0.lan r0.lan.buetow.org
192.168.1.121 r1 r1.lan r1.lan.buetow.org
192.168.1.122 r2 r2.lan r2.lan.buetow.org
END
````

Whereas:

* `192.168.1.120` is the IP of the VM itself (here: `r0.lan.buetow.org`)
* `192.168.1.1` is the address of my home router, which also does DNS.

### Permitting root login

As these VMs aren't directly reachable via SSH from the internet, I enabled `root` login by adding a line with `PermitRootLogin yes` to `/etc/sshd/sshd_config`.

Once done, I rebooted the VM by running `reboot` inside the VM to test whether everything was configured and persisted correctly.

After reboot, I copied my public key from my Laptop to the 3 VMs:

```sh
% for i in 0 1 2; do ssh-copy-id root@r$i.lan.buetow.org; done
```

Then, I edited the `/etc/ssh/sshd_config` file again on all 3 VMs and configured `PasswordAuthentication no` to only allow SSH key authentication from now on.

### Install latest updates

```sh
[root@r0 ~] % dnf update
[root@r0 ~] % reboot
```

## Stress testing CPU

The aim is to prove that bhyve VMs are CPU efficient. As I could not find an off-the-shelf benchmarking tool available in the same version for FreeBSD as well as for Rocky Linux 9, I wrote my own silly CPU benchmarking tool in Go:

```go
package main

import "testing"

func BenchmarkCPUSilly1(b *testing.B) {
	for i := 0; i < b.N; i++ {
		_ = i * i
	}
}

func BenchmarkCPUSilly2(b *testing.B) {
	var sillyResult float64
	for i := 0; i < b.N; i++ {
		sillyResult += float64(i)
		sillyResult *= float64(i)
		divisor := float64(i) + 1
		if divisor > 0 {
			sillyResult /= divisor
		}
	}
	_ = sillyResult // to avoid compiler optimization
}
```

You can find the repository here:

=> https://codeberg.org/snonux/sillybench

### FreeBSD benchmark

To install it on FreeBSD, we run:

```sh
paul@f0:~ % doas pkg install git go
paul@f0:~ % mkdir ~/git && cd ~/git && \
  git clone https://codeberg.org/snonux/sillybench && \
  cd sillybench
```

And to run it:

```sh
paul@f0:~/git/sillybench % go version
go version go1.24.1 freebsd/amd64

paul@f0:~/git/sillybench % go test -bench=.
goos: freebsd
goarch: amd64
pkg: codeberg.org/snonux/sillybench
cpu: Intel(R) N100
BenchmarkCPUSilly1-4    1000000000               0.4022 ns/op
BenchmarkCPUSilly2-4    1000000000               0.4027 ns/op
PASS
ok      codeberg.org/snonux/sillybench 0.891s
```

### Rocky Linux VM @ Bhyve benchmark

OK, let's compare this with the Rocky Linux VM running on Bhyve:

```sh
[root@r0 ~]# dnf install golang git
[root@r0 ~]# mkdir ~/git && cd ~/git && \
  git clone https://codeberg.org/snonux/sillybench && \
  cd sillybench
````

And to run it:


```sh
[root@r0 sillybench]# go version
go version go1.22.9 (Red Hat 1.22.9-2.el9_5) linux/amd64
[root@r0 sillybench]# go test -bench=.
goos: linux
goarch: amd64
pkg: codeberg.org/snonux/sillybench
cpu: Intel(R) N100
BenchmarkCPUSilly1-4    1000000000               0.4347 ns/op
BenchmarkCPUSilly2-4    1000000000               0.4345 ns/op
```
The Linux benchmark is slightly slower than the FreeBSD one. The Go version is also a bit older. I tried the same with the up-to-date version of Go (1.24.x) with similar results. There could be a slight Bhyve overhead, or FreeBSD is just slightly more efficient in this benchmark. Overall, this shows that Bhyve performs excellently.

But as I am curious and don't want to compare apples with bananas, I decided to install a FreeBSD Bhyve VM to run the same silly benchmark in it. I am not going through the details of how to install a FreeBSD Bhyve VM here; you can easily look it up in the documentation.

But here are the results running the same silly benchmark in a FreeBSD Bhyve VM with the same FreeBSD and Go versions as the host system (I have the VM 4 vCPUs and 12GB of RAM; the benchmark won't use as many CPUs anyway):

```sh
root@freebsd:~/git/sillybench # go test -bench=.
goos: freebsd
goarch: amd64
pkg: codeberg.org/snonux/sillybench
cpu: Intel(R) N100
BenchmarkCPUSilly1      1000000000               0.4273 ns/op
BenchmarkCPUSilly2      1000000000               0.4286 ns/op
PASS
ok      codeberg.org/snonux/sillybench  0.949s
```

It's a bit better than Linux! I am sure that this is not really a scientific benchmark, so take the results with a grain of salt!
## Conclusion

Having Linux VMs running inside FreeBSD's Bhyve is a solid move for future F3s hosting in my home lab. Bhyve provides a reliable way to manage VMs without much hassle. With Linux VMs, I can tap into all the cool stuff (e.g., Kubernetes) in the Linux world while keeping the steady reliability of FreeBSD.

Future uses (out of scope for this blog series) would be additional VMs for different workloads. For example, how about a Windows VM or a NetBSD VM to tinker with?

This flexibility is great for keeping options open and managing different kinds of workloads without overcomplicating things. Overall, it's a nice setup for getting the most out of my hardware and keeping things running smoothly.


Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
