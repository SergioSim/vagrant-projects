#!/bin/bash

# Install Spark

# Abort on any error
set -Eeuo pipefail

# Download Spark (if it doesn't exist; 285M)
cd /usr/local
if [[ ! -f spark-3.3.0-bin-hadoop3.tgz ]]; then
    wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz
fi
if [[ ! -d spark ]]; then
    tar zxvf spark-3.3.0-bin-hadoop3.tgz
    ln -sf spark-3.3.0-bin-hadoop3 spark
fi

# Update the Spark configuration
rm -rf /usr/local/spark/conf
ln -sf /vagrant/config/spark /usr/local/spark/conf

# Give vagrant user ownership over Spark
chown -R vagrant:vagrant /usr/local/spark-3.3.0-bin-hadoop3
