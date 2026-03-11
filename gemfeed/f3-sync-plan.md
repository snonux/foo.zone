# f3 Host Expansion Plan

## Goal

Bring `f3.lan.buetow.org` into the `f3s` environment so it is aligned with the real role of `f2`: a non-`zrepl`, non-CARP, non-NFS-HA FreeBSD node that participates in the common host baseline, WireGuard mesh, UPS shutdown coordination, local virtualization pattern, and monitoring.

This plan intentionally excludes:

- `zrepl`
- CARP
- NFS server HA failover
- `stunnel` NFS server role
- `carpcontrol.sh` and related failover automation

## Addressing Plan

Use the next free numbers in the existing address sequences.

- LAN IPv4: `192.168.1.133/24`
- Host short name: `f3`
- Host FQDN: `f3.lan.buetow.org`
- WireGuard IPv4: `192.168.2.133/24`
- WireGuard IPv6: `fd42:beef:cafe:2::133`

Expected host entries:

```txt
192.168.1.133 f3 f3.lan f3.lan.buetow.org
192.168.2.133 f3.wg0 f3.wg0.wan.buetow.org
fd42:beef:cafe:2::133 f3.wg0 f3.wg0.wan.buetow.org
```

## Scope

### Systems that need direct changes

- `f3`
- `f0`
- `f1`
- `f2`
- `r0`
- `r1`
- `r2`
- OpenBSD edge hosts that carry the static WireGuard host list
- Any admin machine with the same hand-maintained `/etc/hosts` map
- Prometheus scrape configuration

### Assumptions

- The FreeBSD ethernet interface on `f3` is `re0`, matching the earlier nodes. Verify with `ifconfig` before writing `rc.conf`.
- The home router/default gateway remains `192.168.1.1`.
- `f0` remains the UPS master node with the USB-connected APC.
- `f2` does not run `zrepl`, and `f3` should mirror that fact.
- If `f2` runs a local Rocky VM via `vm-bhyve`, `f3` should do the same. If `f2` does not, skip the VM provisioning section.
- If `f2` carries the extra SSD, USB key store, and encrypted datasets in practice, mirror that layout on `f3`; otherwise align with the real host, not the generalized blog wording.

## Global References

Primary local references from the blog series:

- `2024-12-03-f3s-kubernetes-with-freebsd-part-2.gmi.tpl`
- `2025-02-01-f3s-kubernetes-with-freebsd-part-3.gmi.tpl`
- `2025-04-05-f3s-kubernetes-with-freebsd-part-4.gmi.tpl`
- `2025-05-11-f3s-kubernetes-with-freebsd-part-5.gmi.tpl`
- `2025-07-14-f3s-kubernetes-with-freebsd-part-6.gmi.tpl`
- `2025-10-02-f3s-kubernetes-with-freebsd-part-7.gmi.tpl`
- `2025-12-07-f3s-kubernetes-with-freebsd-part-8.gmi.tpl`

This file is the authoritative execution plan for the rollout.

## Step 1: Install FreeBSD on f3 and Obtain Initial Access

Install FreeBSD on `f3` with the same baseline choices used on the original hosts:

- Guided ZFS on root with pool `zroot`
- Unencrypted root
- Enable SSH daemon
- Enable NTP service and time sync
- Enable `powerd`
- Create user `paul`
- Add `paul` to group `wheel`

Initial access can be via:

- the console, or
- a temporary DHCP address assigned by the router

Before making persistent network changes, confirm:

- detected interface name via `ifconfig`
- temporary DHCP lease currently in use
- outbound connectivity and SSH reachability

## Step 2: Convert f3 from DHCP to Static LAN Networking

After logging in over the temporary DHCP address, configure `rc.conf` to match the static pattern used by the other nodes.

First verify the interface name:

```sh
ifconfig
```

Then configure:

```sh
doas sysrc hostname="f3.lan.buetow.org"
doas sysrc ifconfig_re0="inet 192.168.1.133 netmask 255.255.255.0"
doas sysrc defaultrouter="192.168.1.1"
```

Apply the change:

```sh
doas service netif restart
doas service routing restart
```

Reconnect over:

```sh
ssh paul@192.168.1.133
```

Validation:

- `hostname` returns `f3.lan.buetow.org`
- `ifconfig re0` shows `192.168.1.133`
- default route points to `192.168.1.1`
- host is reachable by SSH on the static address

## Step 3: Apply the Common FreeBSD Baseline on f3

Install the common package baseline:

```sh
doas pkg install helix doas zfs-periodic uptimed
```

Apply the baseline settings:

- copy `/usr/local/etc/doas.conf.sample` to `/usr/local/etc/doas.conf`
- add the same `zfs-periodic` retention policy for `zroot`
- configure `uptimed`
- fully patch the host using `freebsd-update`, `pkg update`, and `pkg upgrade`

Validation:

- `doas` works for `paul`
- `uprecords` works
- periodic ZFS snapshot settings are present in `/etc/periodic.conf`

## Step 4: Update /etc/hosts Everywhere

Update `/etc/hosts` on all involved systems so `f3` is resolvable consistently.

### Add on FreeBSD hosts

- `f0`
- `f1`
- `f2`
- `f3`

Add:

```txt
192.168.1.133 f3 f3.lan f3.lan.buetow.org
192.168.2.133 f3.wg0 f3.wg0.wan.buetow.org
fd42:beef:cafe:2::133 f3.wg0 f3.wg0.wan.buetow.org
```

### Add on Rocky nodes

- `r0`
- `r1`
- `r2`

Add the same three lines above.

### Add on OpenBSD edge hosts

Any edge node with the mesh host list should get the WireGuard entries:

```txt
192.168.2.133 f3.wg0 f3.wg0.wan.buetow.org
fd42:beef:cafe:2::133 f3.wg0 f3.wg0.wan.buetow.org
```

If those systems also maintain LAN-side entries for FreeBSD hosts, add the LAN line as well.

### Add on admin machines

Any laptop or workstation with the same static map should be updated.

Validation:

- `ping f3.lan.buetow.org` works from LAN systems
- `ping f3.wg0.wan.buetow.org` works once WireGuard is configured
- no duplicate or conflicting host entries are introduced

## Step 5: Configure UPS Partner Behavior on f3

Install `apcupsd` on `f3` and configure it like `f2`, consuming UPS state remotely from `f0`.

Required intent:

- `UPSCABLE ether`
- `UPSTYPE net`
- `DEVICE f0.lan.buetow.org:3551`
- `BATTERYLEVEL 10`
- `MINUTES 6`

Enable and start the service:

```sh
doas sysrc apcupsd_enable=YES
doas service apcupsd start
```

Validation:

- `apcaccess` on `f3` returns data
- `apcaccess -h f0.lan.buetow.org` works from `f3`
- service is enabled for boot

## Step 6: Add f3 to the WireGuard Mesh

Install and enable WireGuard on `f3`:

```sh
doas pkg install wireguard-tools
doas sysrc wireguard_interfaces=wg0
doas sysrc wireguard_enable=YES
doas mkdir -p /usr/local/etc/wireguard
doas touch /usr/local/etc/wireguard/wg0.conf
```

Configure `wg0` with:

- IPv4 `192.168.2.133/24`
- IPv6 `fd42:beef:cafe:2::133`

Then update all existing mesh peers to include `f3`:

- `f0`
- `f1`
- `f2`
- `r0`
- `r1`
- `r2`
- OpenBSD edge hosts

Because the topology is full mesh, this is a cluster-wide change, not a host-local change.

Validation:

- `wg show` on `f3` shows all intended peers
- existing nodes show `f3` as a peer
- `ping 192.168.2.130`, `.131`, `.132` from `f3` works
- `ping fd42:beef:cafe:2::130` etc. works if IPv6 WG is enabled end-to-end

## Step 7: Mirror the Real Local Storage Layout of f2 on f3

This step depends on what `f2` actually runs today.

If `f2` has the extra SSD, USB key filesystem, and encrypted datasets, do the same on `f3`:

- install the second SSD
- create `zdata`
- create and mount `/keys`
- generate `f3.lan.buetow.org:bhyve.key`
- generate `f3.lan.buetow.org:zdata.key`
- replicate the shared key distribution model used on the existing storage-capable hosts
- create encrypted datasets and enable automatic key loading

If `f2` does not use this storage path in practice, skip it and keep `f3` aligned with the actual host.

Validation:

- `zpool list` shows the expected pools
- `/keys` is mounted at boot if used
- encrypted datasets load keys correctly after reboot if used

## Step 8: Configure vm-bhyve and the Host-Local Rocky VM on f3

Only do this if `f2` has the normal host-local VM pattern.

On `f3`:

- install `vm-bhyve` and `bhyve-firmware`
- enable `vm_enable`
- set `vm_dir=zfs:zroot/bhyve`
- create the `public` switch on `re0`
- configure autostart with `vm_list="rocky"`
- provision the Rocky VM analogous to the existing `r2` pattern

If this expands the cluster with a new Rocky guest, define the next matching addresses:

- LAN IPv4 for VM: `192.168.1.123/24`
- WG IPv4 for VM: `192.168.2.123/24`
- WG IPv6 for VM: `fd42:beef:cafe:2::123`
- Hostname: `r3.lan.buetow.org`

If no new VM should exist on `f3`, explicitly skip this step.

Validation:

- `vm list` shows the expected guest
- guest boots cleanly
- guest has static network config if created
- `/etc/hosts` updates are extended for `r3` if `r3` is created

## Step 9: Install and Integrate Monitoring for f3

Install `node_exporter` on `f3`:

```sh
doas pkg install -y node_exporter
doas sysrc node_exporter_enable=YES
doas sysrc node_exporter_args='--web.listen-address=192.168.2.133:9100'
doas service node_exporter start
```

Update Prometheus additional scrape config to include:

```yaml
- '192.168.2.133:9100'  # f3 via WireGuard
```

If you use the ZFS textfile collector script on the FreeBSD hosts, deploy the same script and cron entry to `f3` if and only if `f3` has the same relevant ZFS layout.

Validation:

- `curl -s http://192.168.2.133:9100/metrics | head -3`
- Prometheus target becomes healthy
- Grafana Node Exporter dashboards show `f3`

## Step 10: Mirror Required Local FreeBSD Service Users on f3

If `f2` carries local UID/GID mappings required for shared storage ownership, reproduce them on `f3`.

Known example from the blog:

```sh
doas pw groupadd postgres -g 999
doas pw useradd postgres -u 999 -g postgres -d /var/db/postgres -s /usr/sbin/nologin
```

Only add the accounts that actually exist on `f2` today.

Validation:

- `id postgres` matches expected UID/GID if created
- user list on `f3` matches `f2` for the intended service accounts

## Step 11: End-to-End Validation

Perform a final verification pass:

- `f3` is reachable on `192.168.1.133`
- hostname and `/etc/hosts` are correct everywhere
- `apcupsd` on `f3` reads from `f0`
- WireGuard connectivity is established across the mesh
- monitoring is scraping `f3`
- optional local storage layout matches `f2`
- optional VM layout matches `f2`
- no accidental `zrepl`, CARP, NFS HA, or server-side `stunnel` config was added

Document any intentional deviations from `f2`.

## Task Breakdown

The implementation should be tracked as one task per major step:

1. Install FreeBSD and obtain initial access on `f3`
2. Convert `f3` from DHCP to static LAN networking
3. Apply the common FreeBSD baseline on `f3`
4. Update `/etc/hosts` on all involved systems
5. Configure `apcupsd` on `f3`
6. Add `f3` to the WireGuard mesh
7. Mirror the real local storage layout of `f2` on `f3`
8. Configure `vm-bhyve` and optional host-local Rocky VM on `f3`
9. Install and integrate monitoring for `f3`
10. Mirror required local service users on `f3`
11. Run final end-to-end validation

All implementation tasks should reference this file directly:

- `/home/paul/git/foo.zone-content/gemtext/gemfeed/f3-sync-plan.md`
