#!/bin/bash

# Install R

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

__log_info 'Enable EPEL and CodeReady Builder repos for R installation'
sudo dnf config-manager --enable ol8_codeready_builder
sudo dnf install -y epel-release


__log_info 'Install the R package'
sudo yum install -y R

__log_info 'Installed R with success'
