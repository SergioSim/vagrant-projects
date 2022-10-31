#!/bin/bash

# Utility script updating changes made in config directory on the virtual machine 

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Update .bash_profile, .bashrc and toprc'
cp -f /vagrant/config/.bash_profile /root/.bash_profile
cp -f /vagrant/config/.bashrc /root/.bashrc
cp -f /vagrant/config/.bash_profile /home/vagrant/.bash_profile
cp -f /vagrant/config/.bashrc /home/vagrant/.bashrc
cp -f /vagrant/config/toprc /home/vagrant/.config/procps/toprc
cp -f /vagrant/config/toprc /root/.config/procps/toprc

__log_info 'Update Hadoop configuration'
cp -f /vagrant/config/hadoop/* "${HADOOP_HOME:?}/etc/hadoop"

__log_info 'Update Spark configuration'
cp -f /vagrant/config/spark/* "${SPARK_HOME:?}/conf"

__log_info 'Update Hive configuration'
cp -f /vagrant/config/hive/* "${HIVE_HOME:?}/conf"

__log_info "Updated configuration with success"
