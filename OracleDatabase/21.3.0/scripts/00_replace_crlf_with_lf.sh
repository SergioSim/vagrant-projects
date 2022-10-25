#!/bin/bash

# Replaces 'CRFL' with 'LF' in all files in 'scripts' and 'config' directories

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Update all current packages and their dependencies'
dnf upgrade -y

__log_info 'Install dos2unix'
dnf install -y dos2unix

__log_info 'Replace CRFL with LF in all files in the "scripts" directory'
find /vagrant/scripts -type f -exec dos2unix -q {} \;

__log_info 'Replace CRFL with LF in all files in the "config" directory'
find /vagrant/config -type f -exec dos2unix -q {} \;

__log_info 'Add execute permission to "*.sh" files in the "scripts" directory'
find /vagrant/scripts -name '*.sh' -type f -exec chmod u+x {} \;
