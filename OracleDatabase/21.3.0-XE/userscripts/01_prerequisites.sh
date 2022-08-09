#!/bin/bash

# Prerequisites

# Abort on any error
set -Eeuo pipefail

# Update packages
yum update -y

# Install git, JDK8, mysql vim
yum install -y git java-1.8.0-openjdk-devel mysql-server vim

# Install python 3.9
dnf module install -y python39
yum install -y python3-requests python39-pip

# Start MySQL
systemctl start mysqld
systemctl enable mysqld

# Setup bash configuration files
if [[ ! -h /root/.bash_profile ]]; then
    ln -sf /vagrant/config/.bash_profile /root/.bash_profile
    ln -sf /vagrant/config/.bashrc /root/.bashrc
    ln -sf /vagrant/config/.bash_profile /home/vagrant/.bash_profile
    ln -sf /vagrant/config/.bashrc /home/vagrant/.bashrc
fi

# Give vagrant user ownership for his bash configuration files
chown vagrant:vagrant /home/vagrant/.bash_profile /home/vagrant/.bashrc

# Source defined environment variables
. /root/.bash_profile
BASHRCSOURCED=N . /root/.bashrc

# Bonus: Link toprc configuration
mkdir -p /home/vagrant/.config/procps
mkdir -p /root/.config/procps
ln -sf /vagrant/config/toprc /home/vagrant/.config/procps/toprc
ln -sf /vagrant/config/toprc /root/.config/procps/toprc
chown vagrant:vagrant /root/.config/procps/toprc
