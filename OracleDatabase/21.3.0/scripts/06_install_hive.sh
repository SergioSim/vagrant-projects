#!/bin/bash

# Install Hive

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

HIVE_VERSION="apache-hive-3.1.3-bin"

cd /usr/local

HIVE_METASTORE_PID="$(pgrep -f 'HiveMetaStore' || true)"
if [[ -n "${HIVE_METASTORE_PID}" ]]; then
    __log_info "Stop HiveMetaStore with PID ${HIVE_METASTORE_PID}"
    kill "${HIVE_METASTORE_PID}"
fi

HIVE_SERVER_PID="$(pgrep -f 'HiveServer2' || true)"
if [[ -n "${HIVE_SERVER_PID}" ]]; then
    __log_info "Stop HiveServer2 with PID ${HIVE_SERVER_PID}"
    kill "${HIVE_SERVER_PID}"
fi

__log_info 'Remove previous Hive installation'
rm -fr "${HIVE_HOME:?}" "${HIVE_VERSION:?}"

if [[ ! -f "${HIVE_VERSION}.tar.gz" ]]; then
    __log_info 'Download Hive (~312M)' 
    wget https://dlcdn.apache.org/hive/hive-3.1.3/${HIVE_VERSION}.tar.gz
fi

__log_info 'Untar Hive (~312M)'
tar zxf "${HIVE_VERSION}.tar.gz"
ln -sf "${HIVE_VERSION}" "${HIVE_HOME}"

__log_info 'Update the Hive configuration'
cp -f /vagrant/config/hive/* "${HIVE_HOME}/conf"

__log_info 'Download Mongo-Hive Java driver'
wget 'https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/3.2.1/mongo-java-driver-3.2.1.jar'
mv mongo-java-driver-3.2.1.jar "${HIVE_HOME}/lib"

if [[ ! -d mongo-hadoop ]]; then
    __log_info 'Setup Mongo-Hive connector'
    git clone -b hadoop3.1.0_hive3.1.1 https://github.com/RameshByndoor/mongo-hadoop.git
    cd mongo-hadoop
    ./gradlew core:jar
    ./gradlew hive:jar
    cd ..
    chown -R vagrant:vagrant /usr/local/mongo-hadoop
    ln -sf /usr/local/mongo-hadoop/core/build/libs/mongo-hadoop-core-2.0.2.jar \
        "${HIVE_HOME}/lib/mongo-hadoop-core-2.0.2.jar"
    ln -sf /usr/local/mongo-hadoop/hive/build/libs/mongo-hadoop-hive-2.0.2.jar \
        "${HIVE_HOME}/lib/mongo-hadoop-hive-2.0.2.jar"
fi

__log_info 'Add KVStore libraries'
rm -rf "${HIVE_HOME:?}/lib/kvclient.jar"
rm -rf "${HIVE_HOME:?}/lib/kvstore.jar"
ln -sf "${KVHOME}/lib/kvclient.jar" "${HIVE_HOME}/lib/kvclient.jar"
ln -sf "${KVHOME}/lib/kvstore.jar" "${HIVE_HOME}/lib/kvstore.jar"

__log_info 'Give vagrant user ownership over Hive'
chown -R vagrant:vagrant /usr/local/${HIVE_VERSION}

__log_info 'Create Metastore database in MySQL'
mysql --execute="
DROP DATABASE IF EXISTS metastore;
DROP USER IF EXISTS hive;
CREATE DATABASE metastore;
USE metastore;
CREATE USER 'hive'@'%' IDENTIFIED BY '${HIVE_METASTORE_PWD:-hive}';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'%';
GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'%';
FLUSH PRIVILEGES;
"

__log_info 'Create Hive HDFS directories'
su -l vagrant -c 'hadoop fs -mkdir -p /tmp'
su -l vagrant -c 'hadoop fs -mkdir -p /user/hive/warehouse'
su -l vagrant -c 'hadoop fs -mkdir -p /secrets'
su -l vagrant -c 'hadoop fs -chmod g+w /tmp'
su -l vagrant -c 'hadoop fs -chmod g+w /user/hive/warehouse'

__log_info 'Install MySQL java connector'
if [[ ! -f "${HIVE_HOME}/lib/mysql-connector-java.jar" ]]; then
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.30-1.el8.noarch.rpm
    yum localinstall -y mysql-connector-java-8.0.30-1.el8.noarch.rpm
    rm mysql-connector-java-8.0.30-1.el8.noarch.rpm
    cp /usr/share/java/mysql-connector-java.jar ${HIVE_HOME}/lib
fi

__log_info 'Configuring Metastore password for Hive'
su -l vagrant -c 'hadoop fs -rm -f /secrets/hive.jceks'
su -l vagrant -c "
hadoop credential create javax.jdo.option.ConnectionPassword \
    -provider jceks://hdfs/secrets/hive.jceks \
    -value ${HIVE_METASTORE_PWD:-hive}
"

__log_info 'Initialize Metastore schema'
su -l vagrant -c 'schematool -initSchema -dbType mysql'

__log_info 'Start Hive Metastore service'
su -l vagrant -c 'nohup hive --service metastore > /dev/null &'

__log_info 'Start HiveServer2'
su -l vagrant -c 'nohup hiveserver2 > /dev/null &'

__log_info 'Fix Hive warning appearing when starting pyspark'
python3 /vagrant/config/bin/fix-spark-hive-warning.py

__log_info 'Installed Hive with success'
