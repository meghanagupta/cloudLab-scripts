#!/bin/bash

# Variables
HOSTNAME=$(hostname -f | cut -d"." -f1)
HW_TYPE=$(geni-get manifest | grep $HOSTNAME | grep -oP 'hardware_type="\K[^"]*')
OS_VER="ubuntu`lsb_release -r | cut -d":" -f2 | xargs`"
NUM_CPUS=$(lscpu | grep '^CPU(s):' | awk '{print $2}')

# Test if startup service has run before.
if [ -f /local/startup_service_done ]; then
    # Configurations that need to be (re)done after each reboot

    # TODO: Bind NIC to dpdk.

    exit 0
fi

# Install common utilities
apt-get update
apt-get --assume-yes install mosh vim tmux pdsh tree axel

# Install NetBricks dependencies.
apt-get --assume-yes install libgnutls30 libgnutls-openssl-dev \
        libcurl4-gnutls-dev libnuma-dev libpcap-dev clang numactl

# Change user login shell to Bash
for user in `ls /users`; do
    chsh -s `which bash` $user
done

# Fix "rcmd: socket: Permission denied" when using pdsh
echo ssh > /etc/pdsh/rcmd_default

kernel_boot_params="isolcpus=4,9,14,19,24,29,34,39"
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$kernel_boot_params /" /etc/default/grub

echo "fs.file-max = 65536" >> /etc/sysctl.conf

echo "*  soft nproc  65535" >> /etc/security/limits.conf
echo "*  hard nproc  65535" >> /etc/security/limits.conf
echo "*  soft nofile 65535" >> /etc/security/limits.conf
echo "*  hard nofile 65535" >> /etc/security/limits.conf

update-grub
# Mark the startup service has finished
> /local/startup_service_done

# Reboot to let the configuration take effects
reboot
