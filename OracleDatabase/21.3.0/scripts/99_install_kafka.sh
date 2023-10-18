#!/bin/bash

# Install Apache Kafka

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

KAFKA_VERSION='kafka_2.13-3.6.0'
IFS='-' read -r _ KAFKA_VERSION_NUMBER <<< "${KAFKA_VERSION:?}"

cd /usr/local

# Note: pgrep command length limit reached, using "jps" instead.
KAFKA_BROKER_PID="$(jps | grep "Kafka" | cut -d' ' -f 1 || true)"
if [[ -n "${KAFKA_BROKER_PID}" ]]; then
    __log_info "Stop Kafka broker service with PID ${KAFKA_BROKER_PID}"
    kill "${KAFKA_BROKER_PID}"
fi

KAFKA_ZOOKEEPER_PID="$(jps | grep "QuorumPeerMain" | cut -d' ' -f 1 || true)"
if [[ -n "${KAFKA_ZOOKEEPER_PID}" ]]; then
    __log_info "Stop Zookeeper with PID ${KAFKA_ZOOKEEPER_PID}"
    kill "${KAFKA_ZOOKEEPER_PID}"
fi

__log_info 'Remove previous Kafka installation'
rm -fr "${KAFKA_HOME:?}" "${KAFKA_VERSION:?}" /tmp/kafka-logs /tmp/zookeeper

if [[ ! -f "${KAFKA_VERSION}.tgz" ]]; then
    __log_info 'Download Kafka (~102M)'
    URL="https://downloads.apache.org/kafka/${KAFKA_VERSION_NUMBER:?}/${KAFKA_VERSION}.tgz"
    wget --progress=dot:giga "${URL}"
fi

__log_info 'Untar Kafka (~102M)'
tar zxf "${KAFKA_VERSION}.tgz"
ln -sf "${KAFKA_VERSION}" "${KAFKA_HOME}"

__log_info 'Give vagrant user ownership over Kafka'
chown -R vagrant:vagrant /usr/local/${KAFKA_VERSION}

__log_info 'Start the ZooKeeper service'
su -l vagrant -c "
nohup ${KAFKA_HOME}/bin/zookeeper-server-start.sh \
    ${KAFKA_HOME}/config/zookeeper.properties > /tmp/zookeeper.log 2>&1 &
"

__log_info 'Start the Kafka broker service'
su -l vagrant -c "
nohup ${KAFKA_HOME}/bin/kafka-server-start.sh \
    ${KAFKA_HOME}/config/server.properties > /tmp/kafka.log 2>&1 &
"

__log_info 'Installed Kafka with success'
