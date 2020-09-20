#!/bin/bash

# Variables
HOSTNAME=$(hostname -f | cut -d"." -f1)
HW_TYPE=$(geni-get manifest | grep $HOSTNAME | grep -oP 'hardware_type="\K[^"]*')
OS_VER="ubuntu`lsb_release -r | cut -d":" -f2 | xargs`"
NUM_CPUS=$(lscpu | grep '^CPU(s):' | awk '{print $2}')
MLNX_OFED="MLNX_OFED_LINUX-4.6-1.0.1.1-$OS_VER-x86_64"

# Install common utilities
apt-get update
apt-get --assume-yes install mosh vim tmux pdsh tree axel

# Mark the startup service has finished
> /local/startup_service_done
