#!/bin/bash

# Prerequisites

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Update all current packages and their dependencies'
dnf upgrade -y

__log_info 'Install git, JDK8, mysql, vim and nano'
dnf install -y git java-1.8.0-openjdk-devel mysql-server vim nano

__log_info 'Install python 3.9'
dnf module install -y python39
dnf install -y python3-requests python39-pip

__log_info 'Start MySQL'
systemctl start mysqld
systemctl enable mysqld

__log_info 'Setup bash configuration files'
cp -f /vagrant/config/.bash_profile /root/.bash_profile
cp -f /vagrant/config/.bashrc /root/.bashrc
cp -f /vagrant/config/.bash_profile /home/vagrant/.bash_profile
cp -f /vagrant/config/.bashrc /home/vagrant/.bashrc

__log_info 'Give vagrant user ownership for his bash configuration files'
chown vagrant:vagrant /home/vagrant/.bash_profile /home/vagrant/.bashrc

__log_info 'Link toprc configuration'
mkdir -p /home/vagrant/.config/procps
cp -f /vagrant/config/toprc /home/vagrant/.config/procps/toprc
chown vagrant:vagrant /home/vagrant/.config/procps/toprc
mkdir -p /root/.config/procps
cp -f /vagrant/config/toprc /root/.config/procps/toprc

__log_info 'Installed prerequisites with success'
