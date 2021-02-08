ofed_scripts=ofed-scripts_5.2-OFED.5.2.1.0.4_amd64.deb
mlnx_ofed=mlnx-ofed-kernel-utils_5.2-OFED.5.2.1.0.4.1_amd64.deb

# Install packages
sudo apt update
cat packages.txt | xargs sudo apt-get -y install
wget http://www.mellanox.com/downloads/ofed/MLNX_OFED-5.2-1.0.4.0/MLNX_OFED_LINUX-5.2-1.0.4.0-ubuntu18.04-x86_64.tgz
tar zxf MLNX_OFED_LINUX-5.2-1.0.4.0-ubuntu18.04-x86_64.tgz
cd MLNX_OFED_LINUX-5.2-1.0.4.0-ubuntu18.04-x86_64/DEBS/ || exit
sudo dpkg -i $ofed_scripts
sudo dpkg -i $mlnx_ofed

wget https://www.mellanox.com/downloads/MFT/mft-4.16.1-9-x86_64-deb.tgz
tar xzf mft-4.16.0-105-x86_64-deb.tgz
cd mft-4.16.0-105-x86_64-deb
sudo ./install.sh
sudo mst start

curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env

kernel_boot_params="intel_iommu=on iommu=pt"
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"$kernel_boot_params /" /etc/default/grub
sudo update-grub
sudo reboot
