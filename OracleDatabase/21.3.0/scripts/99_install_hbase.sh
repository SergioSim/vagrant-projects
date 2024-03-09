#!/bin/bash

# Install Apache Hbase

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

HBASE_VERSION='hbase-3.0.0-beta-1'

cd /usr/local

__log_info 'Remove previous Hbase installation'
rm -fr "${HBASE_HOME:?}" "${HBASE_VERSION:?}"

__log_info 'Remove previous Hbase data directory and recreate it'
rm -fr /var/hbase
mkdir -p /var/hbase
chown vagrant:vagrant -R /var/hbase

if [[ ! -f "${HBASE_VERSION}-bin.tar.gz" ]]; then
    __log_info 'Download Hbase (~326M)'
    URL="https://dlcdn.apache.org/hbase/3.0.0-beta-1/${HBASE_VERSION}-bin.tar.gz"
    wget --progress=dot:mega "${URL}"
fi

__log_info 'Untar Hbase (~326M)'
tar zxf "${HBASE_VERSION}-bin.tar.gz"
ln -sf "${HBASE_VERSION}" "${HBASE_HOME:?}"

__log_info 'Update the Hbase configuration'
cp -f /vagrant/config/hbase/* "${HBASE_HOME}/conf"\

__log_info 'Give vagrant user ownership over Hbase'
chown vagrant:vagrant -R "${HBASE_VERSION}"

if [[ -n "$(pgrep -f 'HMaster' || true)" ]]; then
    __log_info "Stop HBase"
    su -l vagrant -c "stop-hbase.sh"
fi

__log_info 'Remove Hbase HDFS directory'
su -l vagrant -c 'hadoop fs -rm -f -r /hbase'

__log_info 'Create Hbase HDFS directory'
su -l vagrant -c 'hadoop fs -mkdir -p /hbase'
su -l vagrant -c 'hadoop fs -chmod g+w /hbase'

__log_info 'Start Hbase'
su -l vagrant -c 'yes | start-hbase.sh'

__log_info 'Installed Hbase with success'
