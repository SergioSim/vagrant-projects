#!/bin/bash

# Install Spark

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

SPARK_VERSION="spark-3.5.0-bin-hadoop3"

cd /usr/local

__log_info 'Remove previous Spark installation'
rm -rf "${SPARK_HOME:?}" "${SPARK_VERSION:?}"

if [[ ! -f "${SPARK_VERSION}.tgz" ]]; then
    __log_info 'Download Spark (~285M)'
    wget --progress=dot:giga "https://dlcdn.apache.org/spark/spark-3.5.0/${SPARK_VERSION}.tgz"
fi

__log_info 'Untar Spark (~285M)'
tar zxf "${SPARK_VERSION}.tgz"
ln -sf "${SPARK_VERSION}" "${SPARK_HOME}"

__log_info 'Update the Spark configuration'
cp -f /vagrant/config/spark/* "${SPARK_HOME:?}/conf"

__log_info 'Give vagrant user ownership over Spark'
chown -R vagrant:vagrant "${SPARK_VERSION}"

__log_info 'Installed Spark with success'
