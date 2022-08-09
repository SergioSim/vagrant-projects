#!/bin/bash

# Install KVStore

# Abort on any error
set -Eeuo pipefail

# Download Oracle KVStore Community Edition (33M)
cd /usr/local
if [[ ! -f kv-ce-21.2.46.tar.gz ]]; then
    wget "https://download.oracle.com/otn-pub/otn_software/nosql-database/kv-ce-21.2.46.tar.gz"
fi
if [[ ! -f kv-examples-21.2.19.zip ]]; then
    wget "https://download.oracle.com/otn-pub/otn_software/nosql-database/kv-examples-21.2.19.zip"
fi
if [[ ! -d $KVHOME ]]; then
    tar zxvf kv-ce-21.2.46.tar.gz
    unzip kv-examples-21.2.19.zip
    cp -rn kv-21.2.19/* kv-21.2.46
    ln -s kv-21.2.46 kv
fi

# Stop KVStore if it's already running
KVSTORE_PID="$(pgrep -f 'kvstore' || true)"
if [[ ! -z $KVSTORE_PID ]]; then
    echo "Stoping KVStore with PID $KVSTORE_PID"
    java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar stop -root $KVROOT
fi

# Give vagrant user ownership over the KVStore and KVROOT
rm -rf $KVROOT
mkdir -p $KVROOT
chown -R vagrant:vagrant /usr/local/kv-21.2.46
chown -R vagrant:vagrant $KVROOT

# Configure KVStore
su -l vagrant -c "
java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar makebootconfig \
    -root $KVROOT \
    -port 5000 \
    -host localhost \
    -harange 5010,5025 \
    -capacity 1 \
    -store-security none
"

# Start the Oracle NoSQL Database Storage Node Agent
su -l vagrant -c "
nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite \
    -secure-config disable \
    -root $KVROOT &
"

# Wait max 30sec for the KVStore to start running
KVSTORE_STATUS_RUNNING="SNA Status : RUNNING"
MAX_WAIT_TIME=30
for i in $( seq 1 $MAX_WAIT_TIME )
do
    COMMAND="java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar status -root $KVROOT || yes"
    KVSTORE_STATUS=$(su -l vagrant -c "$COMMAND")
    if [[ $KVSTORE_STATUS = $KVSTORE_STATUS_RUNNING ]]; then
        break
    fi
    echo "Waiting for KVStore to start running ${i}/${MAX_WAIT_TIME}. ${KVSTORE_STATUS}"
    sleep 1
done
