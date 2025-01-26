# f3s: Kubernetes with FreeBSD - Protecting from power outages - Part 3

This is the third blog post about my f3s series for my self-hosting demands in my home lab. f3s? The "f" stands for FreeBSD, and the "3s" stands for k3s, the Kubernetes distribution we will use on FreeBSD-based physical machines.

<< template::inline::index f3s-kubernetes-with-freebsd-part

=> ./f3s-kubernetes-with-freebsd-part-1/f3slogo.png f3s logo

<< template::inline::toc

## Introduction

In this blog post, we are setting up the UPS for the cluster. A UPS, or Uninterruptible Power Supply, is crucial for safeguarding my cluster from unexpected power outages and surges. It acts as a backup battery that kicks in when the electricity cuts out (especially useful for my area, as here are frequent power cuts), allowing for a graceful system shutdown and preventing data loss and corruption. This is especially important as I will also store some of my data on the f3s nodes.

## Changes since last time

### FreeBSD upgrade from 14.1 to 14.2

There has been a new release since the last blog post of this series. The upgrade from 14.1 was as easy as:

```sh
paul@f0: ~ % doas freebsd-update fetch
paul@f0: ~ % doas freebsd-update install
paul@f0: ~ % doas freebsd-update -r 14.2-RELEASE upgrade
paul@f0: ~ % doas freebsd-update install
paul@f0: ~ % doas shutdown -r now
```

And after rebooting, I run:

```sh
paul@f0: ~ % doas freebsd-update install
paul@f0: ~ % doas pkg update
paul@f0: ~ % doas pkg upgrade
paul@f0: ~ % doas shutdown -r now
```

And after another reboot, I were on 14.2:

```sh
paul@f0:~ % uname -a
FreeBSD f0.lan.buetow.org 14.2-RELEASE FreeBSD 14.2-RELEASE 
 releng/14.2-n269506-c8918d6c7412 GENERIC amd64
```

And this, of course, I run on all 3 nodes!

## A new home (behind the TV)

I've decided to put all the infrastructure behind my TV, as there is plenty of space available. The TV hides most of the setup, which improves the WAF (women acceptance factor) drastically.

=> ./f3s-kubernetes-with-freebsd-part-3/f3s-changes.jpg New hardware placement arrangement

I got rid of the mini switch I mentioned in the previous blog post, as I have the TP-Link EAP615-Wall on the wall mounted nearby, which is my OpenWrt powered Wifi hotspot, which also happened to have 3 ethernet ports to which I connected the Beelink nodes to. That's the device you see at the very top. The ethernet cables go downwards through the cable boxes to the Beelink nodes.

Besides of the Beelink f3s nodes, I will connect the TP-Link to the UPS as well (won't be further mentioned in this blog post - but the positive side effect is, that my Wifi will still work on power loss for some time).

On the very left (the black box) is the UPS, with 4 power outlets. 3 go to the Beelink nodes, and one goes to the TP-Link. There is also an USB output, which is conected o te first Beelink node `f0`.

On the very right (half way hidden behind the TV) are the 3 Beelink nodes stacked on top of each other. Only downside (or upside?) is, that my 14 months old daughter is now chaos testing the Beelink nodes as the red power buttons (which are now reachable to her) are very attractive for her to randomly press when passing by. :-)  - Luckily, that will only cause graceful system shutdowns!

## The UPS hardware.

I wanted a UPS to which I could connect to via FreeBSD and would give enough back-up power to operate the cluster for a couple of minutes (turned out to be around an hour - but that time will likely be shortened after future HW upgrades like additional drives and backup enclosure) and to automatically initate the shutdown of all the f3s nodes.

I decided on the APC Back-UPS BX750MI model due to:

* Zero noise level when there is no power-cut (some light noise when battery is in operation during a power cut.)
* Costs: Being relatively affordable (not costing thousands)
* USB connectivity: Can be connected via USB to one of the FreeBSD hosts - reading the UPS status.
* A power output of 750VA (or 410 watts), suitable for an hour of runtime of my f3s nodes.
* Multiple power outlets: Can connect all 3 f3s nodes there directly.
* User-Replaceable Batteries: So after two years or more (depending on the usage), I can replace the batteries of the UPS by myself.
* It's compact design. Overall, I like how it looks.

=> ./f3s-kubernetes-with-freebsd-part-3/apc-back-ups.jpg The APC Back-UPS BX750MI in operation.

## Configuring FreeBSD to work with the UPS

### USB device detection

Once plugged in via USB on FreeBSD, I could see the following in the kernel messages:

```sh
paul@f0: ~ % doas dmesg | grep UPS
ugen0.2: <American Power Conversion Back-UPS BX750MI> at usbus0
```

### `apcupsd` installation

To make use of the USB connection, the `apcupsd` package had to be installed:

```sh
paul@f0: ~ % doas install apcupsd
```

I have made the following modifications to the configuration file so that the UPS can be used via the USB interface:

```sh
paul@f0:/usr/local/etc/apcupsd % diff -u apcupsd.conf.sample  apcupsd.conf
--- apcupsd.conf.sample 2024-11-01 16:40:42.000000000 +0200
+++ apcupsd.conf        2024-12-03 10:58:24.009501000 +0200
@@ -31,7 +31,7 @@
 #     940-1524C, 940-0024G, 940-0095A, 940-0095B,
 #     940-0095C, 940-0625A, M-04-02-2000
 #
-UPSCABLE smart
+UPSCABLE usb

 # To get apcupsd to work, in addition to defining the cable
 # above, you must also define a UPSTYPE, which corresponds to
@@ -88,8 +88,10 @@
 #                            that apcupsd binds to that particular unit
 #                            (helpful if you have more than one USB UPS).
 #
-UPSTYPE apcsmart
-DEVICE /dev/usv
+UPSTYPE usb
+DEVICE

 # POLLTIME <int>
 #   Interval (in seconds) at which apcupsd polls the UPS for status. This
```

I left the remaining settings as the default ones, for example, the following are of my main interest:

```
# If during a power failure, the remaining battery percentage
# (as reported by the UPS) is below or equal to BATTERYLEVEL,
# apcupsd will initiate a system shutdown.
BATTERYLEVEL 5

# If during a power failure, the remaining runtime in minutes
# (as calculated internally by the UPS) is below or equal to MINUTES,
# apcupsd, will initiate a system shutdown.
MINUTES 3
```

and enabled and started the deamon:

```sh
paul@f0:/usr/local/etc/apcupsd % doas sysrc apcupsd_enable=YES
apcupsd_enable:  -> YES
paul@f0:/usr/local/etc/apcupsd % doas service apcupsd start
Starting apcupsd.
```

### UPS connectivity test

And voila, I could now access the UPS information via the `apcaccess` command, how convenient :-) (I had a read through the manual page as well, which gives a good understanding what else can be done with it!).

```sh
paul@f0:~ % apcaccess
APC      : 001,035,0857
DATE     : 2025-01-26 14:43:27 +0200
HOSTNAME : f0.lan.buetow.org
VERSION  : 3.14.14 (31 May 2016) freebsd
UPSNAME  : f0.lan.buetow.org
CABLE    : USB Cable
DRIVER   : USB UPS Driver
UPSMODE  : Stand Alone
STARTTIME: 2025-01-26 14:43:25 +0200
MODEL    : Back-UPS BX750MI
STATUS   : ONLINE
LINEV    : 230.0 Volts
LOADPCT  : 4.0 Percent
BCHARGE  : 100.0 Percent
TIMELEFT : 65.3 Minutes
MBATTCHG : 5 Percent
MINTIMEL : 3 Minutes
MAXTIME  : 0 Seconds
SENSE    : Medium
LOTRANS  : 145.0 Volts
HITRANS  : 295.0 Volts
ALARMDEL : No alarm
BATTV    : 13.6 Volts
LASTXFER : Automatic or explicit self test
NUMXFERS : 0
TONBATT  : 0 Seconds
CUMONBATT: 0 Seconds
XOFFBATT : N/A
SELFTEST : NG
STATFLAG : 0x05000008
SERIALNO : 9B2414A03599
BATTDATE : 2001-01-01
NOMINV   : 230 Volts
NOMBATTV : 12.0 Volts
NOMPOWER : 410 Watts
END APC  : 2025-01-26 14:44:06 +0200
```

## APC info on partner nodes:

### Installation on partners

I installed apcupsd via `doas pkg install apcupsd` also on f1 and f2, and then I could connect to it this way:

```sh
paul@f1:~ % apcaccess -h f0.lan.buetow.org | grep Percent
LOADPCT  : 12.0 Percent
BCHARGE  : 94.0 Percent
MBATTCHG : 5 Percent
```

But I want the daemon to be configured and enabled in such a way that it connects to the master UPS note (the one with the UPS connected via USB) so that it can also initiate the system shutdown when the UPS battery reaches low levels.

On `f1` and `f2`, I changed the configuration to use `f0` (where `upsapcd` is listening) as a remote device. I also changed the `MINUTES` setting from 3 to 6 and the `BATTERYLEVEL` setting from 5 to 10, to ensure that the `f1` and `f2` nodes could still connect to the `f0` node for UPS information before `f0` decides to shut down.

```sh
paul@f2:/usr/local/etc/apcupsd % diff -u apcupsd.conf.sample apcupsd.conf
--- apcupsd.conf.sample 2024-11-01 16:40:42.000000000 +0200
+++ apcupsd.conf        2025-01-26 15:52:45.108469000 +0200
@@ -31,7 +31,7 @@
 #     940-1524C, 940-0024G, 940-0095A, 940-0095B,
 #     940-0095C, 940-0625A, M-04-02-2000
 #
-UPSCABLE smart
+UPSCABLE ether

 # To get apcupsd to work, in addition to defining the cable
 # above, you must also define a UPSTYPE, which corresponds to
@@ -52,7 +52,6 @@
 #                            Network Information Server. This is used if the
 #                            UPS powering your computer is connected to a
 #                            different computer for monitoring.
-#
 # snmp      hostname:port:vendor:community
 #                            SNMP network link to an SNMP-enabled UPS device.
 #                            Hostname is the ip address or hostname of the UPS
@@ -88,8 +87,8 @@
 #                            that apcupsd binds to that particular unit
 #                            (helpful if you have more than one USB UPS).
 #
-UPSTYPE apcsmart
-DEVICE /dev/usv
+UPSTYPE net
+DEVICE f0.lan.buetow.org:3551

 # POLLTIME <int>
 #   Interval (in seconds) at which apcupsd polls the UPS for status. This
@@ -147,12 +146,12 @@
 # If during a power failure, the remaining battery percentage
 # (as reported by the UPS) is below or equal to BATTERYLEVEL,
 # apcupsd will initiate a system shutdown.
-BATTERYLEVEL 5
+BATTERYLEVEL 10

 # If during a power failure, the remaining runtime in minutes
 # (as calculated internally by the UPS) is below or equal to MINUTES,
 # apcupsd, will initiate a system shutdown.
-MINUTES 3
+MINUTES 6

 # If during a power failure, the UPS has run on batteries for TIMEOUT
 # many seconds or longer, apcupsd will initiate a system shutdown.

```

So I also run the following commands on `f1` and `f2`:

```sh
paul@f1:/usr/local/etc/apcupsd % doas sysrc apcupsd_enable=YES
apcupsd_enable:  -> YES
paul@f1:/usr/local/etc/apcupsd % doas service apcupsd start
Starting apcupsd.
```

And then was able to connect to localhost via the `apcaccess` command:

```sh
paul@f1:~ % doas apcaccess | grep Percent
LOADPCT  : 5.0 Percent
BCHARGE  : 95.0 Percent
MBATTCHG : 5 Percent
```

## Power outage simulation

Broadcast Message from root@f0.lan.buetow.org
        (no tty) at 15:03 EET...

Power failure. Running on UPS batteries.                                              

Broadcast Message from root@f0.lan.buetow.org
        (no tty) at 15:08 EET...

        *** FINAL System shutdown message from paul@f1.lan.buetow.org ***

System going down IMMEDIATELY


apcupsd initiated shutdown



paul@f0:/usr/local/etc/apcupsd % apcaccess | grep TIMELEFT
TIMELEFT : 63.9 Minutes

Other BSD related posts are:

<< template::inline::index bsd

E-Mail your comments to `paul@nospam.buetow.org` :-)

=> ../ Back to the main site
