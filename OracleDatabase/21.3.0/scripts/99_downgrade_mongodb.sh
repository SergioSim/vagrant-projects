#!/bin/bash

# Install Oracle Database Gateway for ODBC

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Update /etc/yum.repos.d/mongodb-org-3.4.repo'
sudo rm -f /etc/yum.repos.d/mongodb-org-4.4.repo
echo '[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc' | sudo tee /etc/yum.repos.d/mongodb-org-3.4.repo

__log_info 'Remove previous MongoDB installation'
sudo dnf remove -y mongodb-org

__log_info 'Remove logs and data files'
sudo rm -rf /var/lib/mongo/* /var/log/mongodb/* /data/db/*

__log_info 'Recreate log and data file directories'
sudo mkdir -p /var/lib/mongo /var/log/mongodb /data/db

__log_info 'Give mongod user ownership over the directories'
sudo chown -R mongod:mongod /var/lib/mongo /var/log/mongodb /data/db

__log_info 'Install mongodb-org-3.4.24'
sudo dnf install -y mongodb-org-3.4.24

__log_info 'Start MongoDB'
sudo systemctl start mongod
sudo systemctl enable mongod
