#!/bin/bash

# Start Hadoop, Hive and KVStore

# Start HDFS
start-dfs.sh

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

if [[ SAFEMODE = "ON" ]]; then
    echo "NameNode did not exit safemode"
    exit 1
fi

# Start YARN
start-yarn.sh

# Start Hive
nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &

# Start KVStore
nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
