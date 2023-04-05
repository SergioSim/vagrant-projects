#!/bin/bash

# Install Jupyter Notebook

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

su -l vagrant -c "python3.9 -m pip install --user -U pip"
su -l vagrant -c "python3.9 -m pip install --user notebook pyspark"

__log_info 'Installed Jupyter Notebook with success'
