#!/bin/bash

# Disable MongoDB authentication

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Stop MongoDB'
systemctl stop mongod

__log_info 'Update MongoDB configuration file'
cp -f /vagrant/config/mongodb/mongod.default.conf /etc/mongod.conf

__log_info 'Start MongoDB'
systemctl start mongod

__log_info 'Disabled MongoDB authentication with success'
