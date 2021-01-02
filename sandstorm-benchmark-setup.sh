kernel_boot_params="isolcpus=4,9,14,19,24,29,34,39"
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"/GRUB_CMDLINE_LINUX_DEFAULT=\"$kernel_boot_params /" /etc/default/grub
update-grub

echo "fs.file-max = 65536" >> /etc/sysctl.conf

echo "*  soft nproc  65535" >> /etc/security/limits.conf
echo "*  hard nproc  65535" >> /etc/security/limits.conf
echo "*  soft nofile 65535" >> /etc/security/limits.conf
echo "*  hard nofile 65535" >> /etc/security/limits.conf

> /local/startup_service_done
reboot
