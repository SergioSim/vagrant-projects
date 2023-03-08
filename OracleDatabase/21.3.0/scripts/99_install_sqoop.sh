#!/bin/bash

# Install Apache Sqoop

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

SQOOP_VERSION='sqoop-1.4.7.bin__hadoop-2.6.0'


cd /usr/local

__log_info 'Remove previous Sqoop installation'
rm -fr "${SQOOP_HOME:?}" "${SQOOP_VERSION:?}"

if [[ ! -f "${SQOOP_VERSION}.tar.gz" ]]; then
    __log_info 'Download Sqoop (~18M)'
    URL="https://archive.apache.org/dist/sqoop/1.4.7/${SQOOP_VERSION}.tar.gz"
    wget --progress=dot:mega "${URL}"
fi

__log_info 'Untar Sqoop (~18M)'
tar zxf "${SQOOP_VERSION}.tar.gz"
ln -sf "${SQOOP_VERSION}" "${SQOOP_HOME:?}"

if [[ ! -f "${SQOOP_HOME}/lib/commons-lang-2.6.jar" ]]; then
    __log_info 'Patch Sqoop by replacing commons-lang3-3.4.jar with commons-lang-2.6.jar'
    rm -f "${SQOOP_HOME}/lib/commons-lang3-3.4.jar"
    URL='https://repo1.maven.org/maven2/commons-lang/commons-lang/2.6/commons-lang-2.6.jar'
    wget -O "${SQOOP_HOME}/lib/commons-lang-2.6.jar" --progress=dot:binary "${URL}"
fi

__log_info 'Add MySQL JDBC driver to Sqoop classpath'
cp /usr/share/java/mysql-connector-java.jar "${SQOOP_HOME}/lib"

__log_info 'Add Hive common library to Sqoop classpath'
cp "$HIVE_HOME/lib/hive-common-"* "$SQOOP_HOME/lib"

__log_info 'Installed Sqoop with success'
