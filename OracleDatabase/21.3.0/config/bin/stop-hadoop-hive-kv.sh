#!/bin/bash

# Stop Hadoop, Hive and KVStore

# Stop KVStore
java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar stop -root $KVROOT

# Stop Hive services
pkill -f "HiveMetaStore|HiveServer2"

# Stop Hadoop services
stop-yarn.sh
stop-dfs.sh
