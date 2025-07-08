#!/bin/sh
# Configure stunnel and NFS mounts on r1 and r2 for f3s storage
# This script should be run on both r1 and r2 Rocky Linux systems

set -e

# Function to print colored status messages
print_status() {
    echo -e "\n\033[1;34m>>> $1\033[0m"
}

print_error() {
    echo -e "\033[1;31mERROR: $1\033[0m"
    exit 1
}

print_success() {
    echo -e "\033[1;32m✓ $1\033[0m"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root"
fi

# Detect hostname
HOSTNAME=$(hostname -s)
if [ "$HOSTNAME" != "r1" ] && [ "$HOSTNAME" != "r2" ]; then
    print_error "This script should only be run on r1 or r2"
fi

print_status "Configuring stunnel and NFS on $HOSTNAME"

# Step 1: Install stunnel package
print_status "Installing stunnel package..."
dnf install -y stunnel || print_error "Failed to install stunnel"
print_success "stunnel installed"

# Step 2: Create stunnel directory
print_status "Creating stunnel configuration directory..."
mkdir -p /etc/stunnel
print_success "Directory created"

# Step 3: Copy stunnel certificate from f0
print_status "Copying stunnel certificate from f0..."
echo "Please copy the certificate manually:"
echo "On f0, run: scp /usr/local/etc/stunnel/stunnel.pem root@$HOSTNAME:/etc/stunnel/"
echo ""
echo "Press Enter when the certificate has been copied..."
read -r

# Verify certificate exists
if [ ! -f /etc/stunnel/stunnel.pem ]; then
    print_error "Certificate not found at /etc/stunnel/stunnel.pem"
fi
print_success "Certificate found"

# Step 4: Create stunnel client configuration
print_status "Creating stunnel client configuration..."
cat > /etc/stunnel/stunnel.conf <<'EOF'
cert = /etc/stunnel/stunnel.pem
client = yes

[nfs-ha]
accept = 127.0.0.1:2323
connect = 192.168.1.138:2323
EOF
print_success "Stunnel configuration created"

# Step 5: Create systemd service for stunnel
print_status "Creating stunnel systemd service..."
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
print_success "Systemd service created"

# Step 6: Enable and start stunnel service
print_status "Enabling and starting stunnel service..."
systemctl daemon-reload
systemctl enable stunnel
systemctl start stunnel
systemctl status stunnel --no-pager || print_error "Stunnel failed to start"
print_success "Stunnel service is running"

# Step 7: Create mount point for NFS
print_status "Creating NFS mount point..."
mkdir -p /data/nfs/k3svolumes
print_success "Mount point created"

# Step 8: Test mount NFS through stunnel
print_status "Testing NFS mount through stunnel..."
mount -t nfs4 -o port=2323 127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes || print_error "Failed to mount NFS"
print_success "NFS mounted successfully"

# Step 9: Verify the mount
print_status "Verifying NFS mount..."
mount | grep k3svolumes || print_error "NFS mount not found"
df -h /data/nfs/k3svolumes
print_success "NFS mount verified"

# Step 10: Unmount for fstab configuration
print_status "Unmounting NFS to configure fstab..."
umount /data/nfs/k3svolumes
print_success "Unmounted"

# Step 11: Add entry to /etc/fstab for persistent mount
print_status "Adding NFS mount to /etc/fstab..."
# Check if entry already exists
if grep -q "127.0.0.1:/data/nfs/k3svolumes" /etc/fstab; then
    print_status "Entry already exists in /etc/fstab"
else
    echo "127.0.0.1:/data/nfs/k3svolumes /data/nfs/k3svolumes nfs4 port=2323,_netdev 0 0" >> /etc/fstab
    print_success "Added to /etc/fstab"
fi

# Step 12: Mount using fstab
print_status "Mounting NFS using fstab entry..."
mount /data/nfs/k3svolumes || print_error "Failed to mount from fstab"
print_success "Mounted from fstab"

# Step 13: Final verification
print_status "Final verification..."
echo ""
echo "Stunnel status:"
systemctl is-active stunnel || print_error "Stunnel is not active"
echo ""
echo "NFS mount status:"
mount | grep k3svolumes
echo ""
echo "Disk usage:"
df -h /data/nfs/k3svolumes
echo ""

# Step 14: Test write access
print_status "Testing write access..."
TEST_FILE="/data/nfs/k3svolumes/test-$HOSTNAME-$(date +%s).txt"
echo "Test from $HOSTNAME at $(date)" > "$TEST_FILE" || print_error "Failed to write test file"
cat "$TEST_FILE"
print_success "Write test successful"

print_success "Configuration complete on $HOSTNAME!"
echo ""
echo "Summary:"
echo "- Stunnel is configured as a client connecting to 192.168.1.138:2323 (CARP VIP)"
echo "- NFS is mounted through stunnel at /data/nfs/k3svolumes"
echo "- Mount is persistent across reboots (configured in /etc/fstab)"
echo "- All traffic between this host and the NFS server is encrypted"
echo ""
echo "To verify everything after reboot:"
echo "  systemctl status stunnel"
echo "  mount | grep k3svolumes"
echo "  ls -la /data/nfs/k3svolumes/"