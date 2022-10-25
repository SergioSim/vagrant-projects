#!/bin/bash

# Install MongoDB

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Setup the mongodb-org-4.4 yum repo'
ln -sf /vagrant/config/yum/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo

__log_info 'Install the MongoDB packages'
sudo yum install -y mongodb-org

__log_info 'Start MongoDB'
systemctl start mongod
systemctl enable mongod

__log_info 'Installed MongoDB with success'