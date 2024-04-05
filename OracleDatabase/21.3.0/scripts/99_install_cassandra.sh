#!/bin/bash

# Install Apache Cassandra

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Set default python version'
update-alternatives --set python /usr/bin/python3.9

__log_info 'Add Apache repository of Cassandra to /etc/yum.repos.d/cassandra.repo'
cat > /etc/yum.repos.d/cassandra.repo <<EOL
[cassandra]
name=Apache Cassandra
baseurl=https://redhat.cassandra.apache.org/41x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.apache.org/cassandra/KEYS
EOL

__log_info 'Install Apache Cassandra'
yum install -y cassandra

__log_info 'Install Cassandra python dependencies'
su -l vagrant -c "pip3 install --user cqlsh"

__log_info 'Start Cassandra'
systemctl daemon-reload
systemctl start cassandra

__log_info 'Make Cassandra start automatically after reboot'
chkconfig cassandra on

__log_info 'Installed Apache Cassandra with success'
