#!/bin/bash

# Install Hadoop

# Abort on any error
set -Eeuo pipefail

# Download Hadoop (if it doesn't exist; 615M)
cd /usr/local
if [[ ! -f hadoop-3.3.3.tar.gz ]]; then
    wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.3/hadoop-3.3.3.tar.gz
fi
if [[ ! -d hadoop ]]; then
    tar zxvf hadoop-3.3.3.tar.gz
    ln -sf hadoop-3.3.3 hadoop
    rm -f hadoop/etc/hadoop/*.cmd hadoop/sbin/*.cmd hadoop/bin/*.cmd
fi

# Setup passphraseless ssh
rm -f /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/id_rsa.pub
ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
ssh-keyscan -t ecdsa-sha2-nistp256 localhost > /home/vagrant/.ssh/known_hosts
chown vagrant:vagrant /home/vagrant/.ssh/*


# Update the Hadoop configuration
# cp -r /vagrant/config/hadoop/* /usr/local/hadoop/etc/hadoop
rm -rf /usr/local/hadoop/etc/hadoop
ln -sf /vagrant/config/hadoop /usr/local/hadoop/etc/hadoop

# Give vagrant user ownership over hadoop
chown vagrant:vagrant -R /usr/local/hadoop-3.3.3

# Stop YARN and HDFS if they are already running
if [[ ! -z "$(pgrep -f 'ResourceManager|NodeManager' || true)" ]]; then
    su -l vagrant -c "stop-yarn.sh"
fi
if [[ ! -z "$(pgrep -f 'NameNode|DataNode|SecondaryNameNode' || true)" ]]; then
    su -l vagrant -c "stop-dfs.sh"
fi

# Clear previous hadoop data directory and format the Hadoop filesystem
rm -rf /tmp/hadoop-vagrant
su -l vagrant -c "yes | hdfs namenode -format"

# Start HDFS
su -l vagrant -c "start-dfs.sh"

# Wait max 30sec for the NameNode to exit safemode
SAFEMODE="ON"
MAX_WAIT_TIME=30
for i in $( seq 1 $MAX_WAIT_TIME )
do
    if [[ "$(hdfs dfsadmin -safemode get)" = "Safe mode is OFF" ]]; then
        SAFEMODE="OFF"
        break
    fi
    echo "Waiting for NameNode to exit safemode ${i}/${MAX_WAIT_TIME}"
    sleep 1
done

if [[ $SAFEMODE = "ON" ]]; then
    echo "NameNode did not exit safemode"
    exit 1
fi

# Create vagrant user home directory
su -l vagrant -c "hadoop fs -mkdir -p /user/vagrant"

# Start YARN
su -l vagrant -c "start-yarn.sh"
