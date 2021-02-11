#!/usr/bin/env bash

# Add keys to ssh between nodes
/usr/bin/geni-get key > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys

# Install packages
apt update
apt --assume-yes install mosh vim tmux pdsh tree axel python3 python3-pip
apt --assume-yes install linux-tools-common linux-tools-${kernel_release} hugepages cpuset msr-tools i7z

if [ -f /local/startup_service_done ]; then
    exit 0
fi

kernel_boot_params="intel_iommu=on iommu=pt"
sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$kernel_boot_params /" /etc/default/grub
update-grub

> /local/startup_service_done

reboot
