#!/bin/sh

ofed_scripts=ofed-scripts_5.2-OFED.5.2.1.0.4_amd64.deb
mlnx_ofed=mlnx-ofed-kernel-utils_5.2-OFED.5.2.1.0.4.1_amd64.deb

# Install packages
sudo apt update
sudo apt-get --assume-yes install mosh vim tmux pdsh tree axel python3 python3-pip
sudo apt-get --assume-yes install linux-tools-common linux-tools-${kernel_release} \
        hugepages cpuset msr-tools i7z

kernel_boot_params="intel_iommu=on iommu=pt"
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$kernel_boot_params /" /etc/default/grub
sudo update-grub
sudo reboot
