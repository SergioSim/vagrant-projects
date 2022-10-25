#!/bin/bash

# Install Hadoop

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

HADOOP_VERSION="hadoop-3.3.4"

cd /usr/local

__log_info 'Remove previous Hadoop installation'
rm -fr "${HADOOP_HOME:?}" "${HADOOP_VERSION:?}"

__log_info 'Remove previous Hadoop data directory and recreate it'
rm -rf /var/hadoop
mkdir -p /var/hadoop
chown vagrant:vagrant -R /var/hadoop

if [[ ! -f "${HADOOP_VERSION}.tar.gz" ]]; then
    __log_info 'Download Hadoop (~615M)'
    wget "https://dlcdn.apache.org/hadoop/common/${HADOOP_VERSION}/${HADOOP_VERSION}.tar.gz"
fi

__log_info 'Untar Hadoop (~615M)'
tar zxf "${HADOOP_VERSION}.tar.gz"
ln -sf "${HADOOP_VERSION}" "${HADOOP_HOME}"
rm -f hadoop/etc/hadoop/*.cmd hadoop/sbin/*.cmd hadoop/bin/*.cmd

__log_info 'Setup passphraseless ssh'
rm -f /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/id_rsa.pub
ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
ssh-keyscan -t ecdsa-sha2-nistp256 localhost > /home/vagrant/.ssh/known_hosts
chown vagrant:vagrant /home/vagrant/.ssh/*

__log_info 'Update the Hadoop configuration'
cp -f /vagrant/config/hadoop/* "${HADOOP_HOME}/etc/hadoop"

__log_info 'Give vagrant user ownership over Hadoop'
chown vagrant:vagrant -R "${HADOOP_VERSION}"

if [[ -n "$(pgrep -f 'ResourceManager|NodeManager' || true)" ]]; then
    __log_info "Stop YARN"
    su -l vagrant -c "stop-yarn.sh"
fi

if [[ -n "$(pgrep -f 'NameNode|DataNode|SecondaryNameNode' || true)" ]]; then
    __log_info "Stop HDFS"
    su -l vagrant -c "stop-dfs.sh"
fi

__log_info 'Format the Hadoop Distributed FileSystem'
su -l vagrant -c "yes | hdfs namenode -format"

__log_info 'Start HDFS'
su -l vagrant -c "start-dfs.sh"

__log_info 'Wait max 30sec for the NameNode to exit safemode'
SAFEMODE='ON'
MAX_WAIT_TIME=30
for i in $( seq 1 ${MAX_WAIT_TIME} )
do
    if [[ "$(hdfs dfsadmin -safemode get)" = 'Safe mode is OFF' ]]; then
        SAFEMODE='OFF'
        break
    fi
    __log_info "Waiting for NameNode to exit safemode ${i}/${MAX_WAIT_TIME}"
    sleep 1
done

if [[ "${SAFEMODE}" = "ON" ]]; then
    __log_error 'NameNode did not exit safemode'
    exit 1
fi

__log_info 'Create HDFS vagrant user home directory'
su -l vagrant -c 'hadoop fs -mkdir -p /user/vagrant'

__log_info 'Start YARN'
su -l vagrant -c 'start-yarn.sh'

__log_info 'Installed Hadoop with success'
