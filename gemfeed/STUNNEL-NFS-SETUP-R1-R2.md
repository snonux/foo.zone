# Stunnel and NFS Configuration for r1 and r2

This document provides step-by-step instructions for configuring stunnel and NFS mounts on r1 and r2 Rocky Linux systems to connect to the f3s storage cluster.

## Prerequisites

- Root access on r1 and r2
- Network connectivity to f0 (for copying the certificate)
- Network connectivity to the CARP VIP (192.168.1.138)

## Overview

The configuration provides:
- Encrypted NFS traffic using stunnel
- Automatic failover via CARP VIP (192.168.1.138)
- Persistent mounts across reboots
- Access to /data/nfs/k3svolumes for Kubernetes storage

## Configuration Steps

### Step 1: Install stunnel

```bash
dnf install -y stunnel
```

### Step 2: Copy the stunnel certificate from f0

First, create the directory:
```bash
mkdir -p /etc/stunnel
```

Then copy the certificate from f0. On f0, run:
```bash
scp /usr/local/etc/stunnel/stunnel.pem root@r1:/etc/stunnel/
scp /usr/local/etc/stunnel/stunnel.pem root@r2:/etc/stunnel/
```

### Step 3: Create stunnel client configuration

Create `/etc/stunnel/stunnel.conf`:
```bash
cat > /etc/stunnel/stunnel.conf <<'EOF'
cert = /etc/stunnel/stunnel.pem
client = yes

[nfs-ha]
accept = 127.0.0.1:2323
connect = 192.168.1.138:2323
EOF
```

### Step 4: Create systemd service for stunnel

Create `/etc/systemd/system/stunnel.service`:
```bash
cat > /etc/systemd/system/stunnel.service <<'EOF'
[Unit]
Description=SSL tunnel for network daemons
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel /etc/stunnel/stunnel.conf
ExecStop=/usr/bin/killall stunnel
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
```

### Step 5: Enable and start stunnel

```bash
systemctl daemon-reload
systemctl enable stunnel
systemctl start stunnel
systemctl status stunnel
```

### Step 6: Create NFS mount point

```bash
mkdir -p /data/nfs/k3svolumes
```

### Step 7: Test mount NFS through stunnel

```bash
mount -t nfs4 -o port=2323 127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes
```

### Step 8: Verify the mount

```bash
mount | grep k3svolumes
df -h /data/nfs/k3svolumes
ls -la /data/nfs/k3svolumes/
```

### Step 9: Configure persistent mount

First unmount the test mount:
```bash
umount /data/nfs/k3svolumes
```

Add to `/etc/fstab`:
```bash
echo "127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes nfs4 port=2323,_netdev 0 0" >> /etc/fstab
```

Mount using fstab:
```bash
mount /data/nfs/k3svolumes
```

## Automated Installation

A script is available to automate all these steps:

```bash
# Download and run the configuration script
curl -O https://raw.githubusercontent.com/.../configure-stunnel-nfs-r1-r2.sh
chmod +x configure-stunnel-nfs-r1-r2.sh
./configure-stunnel-nfs-r1-r2.sh
```

## Verification Commands

After configuration, verify everything is working:

```bash
# Check stunnel service
systemctl status stunnel

# Check NFS mount
mount | grep k3svolumes
df -h /data/nfs/k3svolumes

# Test write access
echo "Test from $(hostname) at $(date)" > /data/nfs/k3svolumes/test-$(hostname).txt
cat /data/nfs/k3svolumes/test-$(hostname).txt

# Check stunnel connection
ss -tlnp | grep 2323
```

## Troubleshooting

### Stunnel won't start

Check the logs:
```bash
journalctl -u stunnel -n 50
```

Common issues:
- Certificate file missing or wrong permissions
- Port 2323 already in use
- Configuration syntax error

### NFS mount fails

Check connectivity:
```bash
# Test if stunnel is listening
telnet 127.0.0.1 2323

# Check if CARP VIP is reachable
ping -c 3 192.168.1.138

# Try mounting with verbose output
mount -v -t nfs4 -o port=2323 127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes
```

### Mount not persistent after reboot

Verify fstab entry:
```bash
grep k3svolumes /etc/fstab
```

Test fstab mount:
```bash
mount -a
```

Check for systemd mount errors:
```bash
systemctl --failed
journalctl -b | grep mount
```

### Permission denied errors

The NFS export on f0/f1 maps root, so permission issues are rare. If they occur:
```bash
# Check export configuration on NFS server
showmount -e 192.168.1.138

# Verify your IP is allowed in the exports
# r0: 192.168.1.120
# r1: 192.168.1.121
# r2: 192.168.1.122
```

## Security Considerations

- All NFS traffic is encrypted through stunnel
- The certificate provides both authentication and encryption
- Access is restricted by IP address on the NFS server
- Root access is mapped (maproot=root) for Kubernetes operations

## Integration with Kubernetes

Once configured, Kubernetes can use this mount for persistent storage:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 127.0.0.1  # Local stunnel
    path: /data/nfs/k3svolumes
  mountOptions:
    - port=2323
    - nfsvers=4
```

## Maintenance

### Restarting services

```bash
# Restart stunnel
systemctl restart stunnel

# Remount NFS
umount /data/nfs/k3svolumes
mount /data/nfs/k3svolumes
```

### Updating certificates

When certificates expire (after 10 years):
1. Generate new certificate on f0
2. Copy to all clients (r0, r1, r2)
3. Restart stunnel on all hosts

### Monitoring

Add to your monitoring system:
- stunnel service status
- NFS mount presence
- Disk space on /data/nfs/k3svolumes
- Network connectivity to 192.168.1.138:2323

## Summary

After completing these steps on both r1 and r2:

1. **Stunnel** provides encrypted tunnel to NFS server
2. **NFS** mounts through stunnel on port 2323
3. **CARP VIP** (192.168.1.138) ensures automatic failover
4. **Persistent mount** via /etc/fstab survives reboots
5. **Kubernetes** can use /data/nfs/k3svolumes for persistent volumes

The same configuration works on r0, r1, and r2 with no modifications needed.