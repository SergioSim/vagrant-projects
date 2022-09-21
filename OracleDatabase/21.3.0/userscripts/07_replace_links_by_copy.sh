#!/bin/bash

# Replace previously created links with copies

# Abort on any error
set -Eeuo pipefail

# Do not replace links when KEEP_CONFIG_LINKS is set to true
if [[ "${KEEP_CONFIG_LINKS:-false}" = "true" ]]; then
    echo "Keeping using links from /vagrant directory"
    return 0
fi

# Prerequisites

rm -f /root/.bash_profile
rm -f /root/.bashrc
rm -f /home/vagrant/.bash_profile
rm -f /home/vagrant/.bashrc
rm -f /home/vagrant/.config/procps/toprc
rm -f /root/.config/procps/toprc
cp -fp /vagrant/config/.bash_profile /root/.bash_profile
cp -fp /vagrant/config/.bashrc /root/.bashrc
cp -fp /vagrant/config/.bash_profile /home/vagrant/.bash_profile
cp -fp /vagrant/config/.bashrc /home/vagrant/.bashrc
cp -fp /vagrant/config/toprc /home/vagrant/.config/procps/toprc
cp -fp /vagrant/config/toprc /root/.config/procps/toprc

# Hadoop
rm -rf /usr/local/hadoop/etc/hadoop
cp -rfp /vagrant/config/hadoop /usr/local/hadoop/etc/hadoop

# Spark
rm -rf /usr/local/spark/conf
cp -rfp /vagrant/config/spark /usr/local/spark/conf

# Hive
rm -rf /usr/local/hive/conf
cp -rfp /vagrant/config/hive /usr/local/hive/conf

# MongoDB
rm -f /etc/yum.repos.d/mongodb-org-4.4.repo
cp -fp /vagrant/config/yum/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo

echo "Replaced configuration links with copies!"
