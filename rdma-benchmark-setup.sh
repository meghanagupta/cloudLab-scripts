#!/bin/sh

# Add keys to ssh between nodes
/usr/bin/geni-get key > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 644 ~/.ssh/authorized_keys

# Install packages
sudo apt update
sudo apt-get --assume-yes install mosh vim tmux pdsh tree axel python3 python3-pip
sudo apt-get --assume-yes install linux-tools-common linux-tools-${kernel_release} \
        hugepages cpuset msr-tools i7z

kernel_boot_params="intel_iommu=on iommu=pt"
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$kernel_boot_params /" /etc/default/grub
sudo update-grub
sudo reboot
