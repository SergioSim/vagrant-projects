#!/bin/bash

# Install MongoDB

# Abort on any error
set -Eeuo pipefail

# Setup the yum repo
ln -sf /vagrant/config/yum/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo

# Install the MongoDB packages
sudo yum install -y mongodb-org

# Start MongoDB
systemctl start mongod
systemctl enable mongod
