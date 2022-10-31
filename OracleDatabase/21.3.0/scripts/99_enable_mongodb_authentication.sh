#!/bin/bash

# Enable MongoDB authentication

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

SCRIPT='/vagrant/config/mongodb/create_admin_user.js'
USERNAME="${MONGO_ADMIN_USERNAME:?}"
PASSWORD="${MONGO_ADMIN_PASSWORD:?}"

__log_info 'Check whether MongoDB is running'
systemctl is-active --quiet mongod || {
    __log_info 'Start MongoDB'
    systemctl start mongod 
}

__log_info 'Check whether MongoDB authentication is disabled'
mongo_test_command="$(mongo --eval 'db.getUsers()' || true)"
isAuth="$( echo "${mongo_test_command}" | grep 'requires authentication' || true)"
if [ -n "$isAuth" ]; then
   __log_error 'MongoDB authentication is already enabled, please disable if first!'
   exit 1
fi


__log_info 'Create or Update MongoDB user administrator'
mongo --eval "const username = '${USERNAME}', password = '${PASSWORD}';" "${SCRIPT}"

__log_info 'Update MongoDB configuration file'
cp -f /vagrant/config/mongodb/mongod.auth.conf /etc/mongod.conf

__log_info 'Restart MongoDB'
systemctl restart mongod

__log_info 'Enabled MongoDB authentication with success'
