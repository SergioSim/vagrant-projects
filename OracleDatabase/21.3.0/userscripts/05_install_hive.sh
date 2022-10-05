#!/bin/bash

# Install Hive

# Abort on any error
set -Eeuo pipefail

# Download Hive (if it doesn't exist; 312M)
cd /usr/local
if [[ ! -f apache-hive-3.1.3-bin.tar.gz ]]; then
    wget https://dlcdn.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
fi
if [[ ! -d hive ]]; then
    tar zxvf apache-hive-3.1.3-bin.tar.gz
    ln -sf apache-hive-3.1.3-bin hive
fi

# Update the Hive configuration
rm -rf /usr/local/hive/conf
ln -sf /vagrant/config/hive /usr/local/hive/conf

# Install Mongo-Hive connector
if [[ ! -f /usr/local/hive/lib/mongo-java-driver-3.2.1.jar ]]; then
    wget "https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/3.2.1/mongo-java-driver-3.2.1.jar"
    mv mongo-java-driver-3.2.1.jar /usr/local/hive/lib
fi
if [[ ! -d mongo-hadoop ]]; then
    git clone https://github.com/RameshByndoor/mongo-hadoop.git
    cd mongo-hadoop
    git checkout hadoop3.1.0_hive3.1.1
    ./gradlew jar
    cd ..
    chown -R vagrant:vagrant /usr/local/mongo-hadoop
    ln -sf /usr/local/mongo-hadoop/core/build/libs/mongo-hadoop-core-2.0.2.jar \
        /usr/local/hive/lib/mongo-hadoop-core-2.0.2.jar
    ln -sf /usr/local/mongo-hadoop/hive/build/libs/mongo-hadoop-hive-2.0.2.jar \
        /usr/local/hive/lib/mongo-hadoop-hive-2.0.2.jar
fi

# Add KVStore libraries
rm -rf /usr/local/hive/lib/kvclient.jar
rm -rf /usr/local/hive/lib/kvstore.jar
ln -s $KVHOME/lib/kvclient.jar /usr/local/hive/lib/kvclient.jar
ln -s $KVHOME/lib/kvstore.jar /usr/local/hive/lib/kvstore.jar

# Give vagrant user ownership over Hive
chown -R vagrant:vagrant /usr/local/apache-hive-3.1.3-bin

# Create Metastore database in MySQL
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

# Create Hive HDFS directories
su -l vagrant -c "hadoop fs -mkdir -p /tmp"
su -l vagrant -c "hadoop fs -mkdir -p /user/hive/warehouse"
su -l vagrant -c "hadoop fs -mkdir -p /secrets"
su -l vagrant -c "hadoop fs -chmod g+w /tmp"
su -l vagrant -c "hadoop fs -chmod g+w /user/hive/warehouse"

# Install MySQL java connector
if [[ ! -f /usr/local/hive/lib/mysql-connector-java.jar ]]; then
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.30-1.el8.noarch.rpm
    yum localinstall -y mysql-connector-java-8.0.30-1.el8.noarch.rpm
    rm mysql-connector-java-8.0.30-1.el8.noarch.rpm
    cp /usr/share/java/mysql-connector-java.jar /usr/local/hive/lib
fi

# Configuring Metastore password for Hive
su -l vagrant -c "hadoop fs -rm -f /secrets/hive.jceks"
su -l vagrant -c "
hadoop credential create javax.jdo.option.ConnectionPassword \
    -provider jceks://hdfs/secrets/hive.jceks \
    -value ${HIVE_METASTORE_PWD:-hive}
"

# Initialize Metastore schema
su -l vagrant -c "schematool -initSchema -dbType mysql"

# Stop Hive services if they are already running
HIVE_METASTORE_PID="$(pgrep -f 'HiveMetaStore' || true)"
if [[ ! -z $HIVE_METASTORE_PID ]]; then
    echo "Stoping HiveMetaStore with PID $HIVE_METASTORE_PID"
    kill $HIVE_METASTORE_PID
fi
HIVE_SERVER_PID="$(pgrep -f 'HiveServer2' || true)"
if [[ ! -z $HIVE_SERVER_PID ]]; then
    echo "Stoping HiveServer2 with PID $HIVE_SERVER_PID"
    kill $HIVE_SERVER_PID
fi

# Start the Metastore service
echo "Starting Hive Metastore"
su -l vagrant -c "nohup hive --service metastore > /dev/null &"

# Start HiveServer
echo "Starting HiveServer2"
su -l vagrant -c "nohup hiveserver2 > /dev/null &"

# Fix Hive warning appearing when starting pyspark
python3 /vagrant/config/bin/fix-spark-hive-warning.py
