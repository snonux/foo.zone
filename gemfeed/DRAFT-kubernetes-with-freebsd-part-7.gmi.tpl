# f3s: Kubernetes with FreeBSD - Part 6: Storage

> Published at 2025-07-13T16:44:29+03:00

This is the seventh blog post about the f3s series for self-hosting demands in a home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution used on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

## Updating

On all three Rocky Linux 9 boxes `r0`, `r1`, and `r2`:

```sh
dnf update -y
reboot
```

On the FreeBSD hosts, upgrading from FreeBSD 14.2 to 14.3-RELEASE, running this on all three hosts `f0`, `f1` and `f2`:

```sh
paul@f0:~ % doas freebsd-update fetch
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % doas freebsd-update -r 14.3-RELEASE upgrade
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % doas freebsd-update install
paul@f0:~ % doas pkg update
paul@f0:~ % doas pkg upgrade
paul@f0:~ % doas reboot
.
.
.
paul@f0:~ % uname -a
FreeBSD f0.lan.buetow.org 14.3-RELEASE FreeBSD 14.3-RELEASE
        releng/14.3-n271432-8c9ce319fef7 GENERIC amd64
```

## Installing k3s

Generating the k3s token on my Fedora Laptop with `pwgen -n 32` and selected one. And then on all 3 `r` hosts (replace SECRET_TOKEN with the actual secret!! before running the following command) run:

```sh
[root@r0 ~]# echo -n SECRET_TOKEN > ~/.k3s_token
```

The following steps are also documented on the k3s website:

=> https://docs.k3s.io/datastore/ha-embedded

So on `r0` we run:

```sh
[root@r0 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --cluster-init --tls-san=r0.wg0.wan.buetow.org
[INFO]  Finding release for channel stable
[INFO]  Using v1.32.6+k3s1 as release
.
.
.
[INFO]  systemd: Starting k3s
```

And we run on the other two nodes `r1` and `r2`:

```sh
[root@r1 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --tls-san=r1.wg0.wan.buetow.org

[root@r2 ~]# curl -sfL https://get.k3s.io | K3S_TOKEN=$(cat ~/.k3s_token) \
        sh -s - server --server https://r0.wg0.wan.buetow.org:6443 \
        --tls-san=r2.wg0.wan.buetow.org
.
.
.

```

Once done, we've got a 3 node Kubernetes cluster control plane:

```sh
[root@r0 ~]# kubectl get nodes
NAME                STATUS   ROLES                       AGE     VERSION
r0.lan.buetow.org   Ready    control-plane,etcd,master   4m44s   v1.32.6+k3s1
r1.lan.buetow.org   Ready    control-plane,etcd,master   3m13s   v1.32.6+k3s1
r2.lan.buetow.org   Ready    control-plane,etcd,master   30s     v1.32.6+k3s1
```

Other *BSD-related posts:

<< template::inline::rindex bsd

E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site
