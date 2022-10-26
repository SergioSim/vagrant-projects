#!/bin/bash

# Install KVStore

# Abort on any error
set -Eeuo pipefail

# Import utils
source /vagrant/scripts/utils.sh

KV_VERSION="kv-22.2.13"
KV_EXAMPLES_VERSION="kv-22.1.16"

cd /usr/local

KVSTORE_PID="$(pgrep -f 'kvstore.jar' || true)"
if [[ -n "${KVSTORE_PID}" ]]; then
    __log_info "Stop KVStore with PID ${KVSTORE_PID}"
    java -Xmx64m -Xms64m -jar "${KVHOME}/lib/kvstore.jar" stop -root "${KVROOT}"
fi

__log_info 'Remove previous KVStore installation'
rm -rf "${KVHOME:?}" "${KV_VERSION:?}" "${KV_EXAMPLES_VERSION:?}"

if [[ ! -f "${KV_VERSION}.zip" ]]; then
    __log_info 'Copy the Oracle KVStore Entreprise Edition (V1030945-01.zip) from the /vagrant directory'
   cp /vagrant/V1030945-01.zip "${KV_VERSION}.zip"
fi

if [[ ! -f "${KV_EXAMPLES_VERSION}.zip" ]]; then
    __log_info 'Copy the Oracle KVStore Entreprise Edition Examples (V1020129-01.zip) from the /vagrant directory'
    cp /vagrant/V1020129-01.zip "${KV_EXAMPLES_VERSION}.zip"
fi

__log_info 'Unzip KVStore and examples'
unzip "${KV_VERSION}.zip"
unzip "${KV_EXAMPLES_VERSION}.zip"
cp -rn "${KV_EXAMPLES_VERSION}"/* "${KV_VERSION}"
ln -s "${KV_VERSION}" kv

__log_info 'Give vagrant user ownership over the KVStore and KVROOT'
rm -rf "${KVROOT:?}"
mkdir -p "${KVROOT:?}"
chown -R vagrant:vagrant "${KV_VERSION}"
chown -R vagrant:vagrant "${KVROOT}"

__log_info 'Configure KVStore'
su -l vagrant -c "
java -Xmx64m -Xms64m -jar ${KVHOME}/lib/kvstore.jar makebootconfig \
    -root ${KVROOT} \
    -port 5000 \
    -host localhost \
    -harange 5010,5025 \
    -capacity 1 \
    -store-security none
"

__log_info 'Start the Oracle NoSQL Database Storage Node Agent'
su -l vagrant -c "
nohup java -Xmx64m -Xms64m -jar ${KVHOME}/lib/kvstore.jar kvlite \
    -secure-config disable \
    -root ${KVROOT} &
"

__log_info 'Wait max 30sec for the KVStore to start running'
KVSTORE_RUNNING='FALSE'
KVSTORE_STATUS_RUNNING='SNA Status : RUNNING'
MAX_WAIT_TIME=30
for i in $( seq 1 ${MAX_WAIT_TIME} )
do
    COMMAND="java -Xmx64m -Xms64m -jar ${KVHOME}/lib/kvstore.jar status -root ${KVROOT} || yes"
    KVSTORE_STATUS=$(su -l vagrant -c "${COMMAND}")
    if [[ "${KVSTORE_STATUS}" = "${KVSTORE_STATUS_RUNNING}" ]]; then
        KVSTORE_RUNNING='TRUE'
        break
    fi
    __log_info "Waiting for KVStore to start running ${i}/${MAX_WAIT_TIME}. ${KVSTORE_STATUS}"
    sleep 1
done

if [[ "${KVSTORE_RUNNING}" = 'FALSE' ]]; then
    __log_error 'KVStore did not start running'
    exit 1
fi

__log_info 'Installed KVStore with success'
