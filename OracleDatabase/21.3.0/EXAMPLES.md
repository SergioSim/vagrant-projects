# Usage examples


## MongoDB


### Start MongoDB

> Note that by default MongoDB is configured to automatically start at startup.

```bash
sudo systemctl start mongod
```

### Connect with MongoDB client

```bash
mongo
```

#### MongoDB client interaction examples

```
// List databases
show dbs;
// Create or select existing database
use test;
// List collections
show collections;
// Create a collection
db.createCollection("persons")
// Insert documents to persons collection
db.persons.insert({name: "John Doe", age: 30})
db.persons.insert({name: "Jane Doe", age: 30})
// Query persons collection
db.persons.find({});
db.persons.find({name: "John Doe"});
// Exit
quit()
```

### Stop MongoDB

```bash
sudo systemctl stop mongod
```


## Hadoop


### Start Hadoop (HDFS & YARN)

```bash
start-dfs.sh
start-yarn.sh
```

### Create directory in HDFS

```bash
hadoop fs -mkdir input
```

### Upload files to HDFS

```bash
hadoop fs -put /usr/local/hadoop/etc/hadoop/*.xml input
```

### Run example

```bash
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar grep input output 'dfs[a-z.]+'
```

### View results

```bash
hadoop fs -ls output
hadoop fs -cat output/*
```

### Stop Hadoop

```bash
stop-yarn.sh
stop-dfs.sh
```


## Oracle NoSQL Database (KVStore)


### Start KVStore using KVLite utility

```bash
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &
```

### Ping KVStore

```bash
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar ping -host localhost -port 5000
```

### Start KVStoreAdminClient
```bash
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar runadmin -host localhost -port 5000
```

### Start SQL Shell
```bash
java -Xmx256m -Xms256m -jar $KVHOME/lib/sql.jar -helper-hosts localhost:5000 -store kvstore
```

### Usage examples

The original and much more detailed version of these examples can be found at the
[Oracle KVStore documentation](https://docs.oracle.com/en/database/other-databases/nosql-database/21.2/)

#### Hello World example

[Original version](https://docs.oracle.com/en/database/other-databases/nosql-database/21.2/java-driver-table/verifying-installation.html)

This example puts a single key value pair into the KVStore, then retrieves and prints it.

```bash
mkdir -p examples
javac $KVHOME/examples/hello/HelloBigDataWorld.java -d examples
java -cp $CLASSPATH:examples hello.HelloBigDataWorld
```

#### Create and Populate vehicle table example

[Original version](https://docs.oracle.com/en/database/other-databases/nosql-database/21.2/integrations/counttablerows-support-programs.html#GUID-F05AFFE1-1AA4-4139-AF60-F8424FA3CDED)

This example creates and populates a table named vehicleTable in the KVStore.
It also prints out the inserted records.

```bash
javac -cp $CLASSPATH:$KVHOME/examples $KVHOME/examples/hadoop/table/LoadVehicleTable.java -d examples
java -cp $CLASSPATH:examples hadoop.table.LoadVehicleTable -store kvstore -host localhost -port 5000
```

### Stop KVStore

```bash
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar stop -root $KVROOT
```


## Hive


### Start Hive (Metastore service & HiveServer2)

> Note: Prior starting Hive, it is required that Hadoop services are running.
> See [Start Hadoop](#start-hadoop-hdfs--yarn)

```bash
nohup hive --service metastore > hive_metastore.log 2>&1 &
nohup hiveserver2 > hive_server.log 2>&1 &
```

### Connect to Hive

> Note: Prior connecting to Hive, make sure to wait for 1-3 minutes after
> launching HiveServer2 as the Hive service needs some time to become operational.

```bash
beeline -u jdbc:hive2://localhost:10000 vagrant
```

#### Beeline usage example

```SQL
-- Create a database and a table
CREATE DATABASE IF NOT EXISTS books;
USE books;
CREATE TABLE IF NOT EXISTS dictionary (word STRING, description STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- Insert data into the table
INSERT INTO dictionary VALUES ("a", "the letter a");
INSERT INTO dictionary VALUES ("b", "the letter b");
INSERT INTO dictionary VALUES ("c", "the letter c");

-- Query the table
SELECT * from dictionary;

-- Use Ctrl + C to exit
```

### Query MongoDB from Hive example

> Note that this example expects that the previous [MongoDB client interaction examples](#mongodb-client-interaction-examples) where executed.

```SQL
-- Create example database
CREATE DATABASE IF NOT EXISTS mongo_examples;
USE mongo_examples;

-- Remove the persons_ext table if it exists
DROP TABLE IF EXISTS persons_ext;

-- Create MongoDB connected external table
CREATE EXTERNAL TABLE persons_ext ( id STRING, name STRING, age INT )
STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler'
WITH SERDEPROPERTIES('mongo.columns.mapping'='{"id":"_id"}')
TBLPROPERTIES('mongo.uri'='mongodb://localhost:27017/test.persons');

-- Query the external table
SELECT * FROM persons_ext;

-- Insert a few documents
INSERT INTO persons_ext VALUES ("62f11a3e79454103db0b9aab", "John Roe", 50);
INSERT INTO persons_ext VALUES ("62f11a3e79454103db0b9aac", "Jane Roe", 50);
```

### Query KVStore from Hive example

> Note that this example expects that the previous [Create and Populate vehicle table example](#create-and-populate-vehicle-table-example) was executed.

[Original version](https://docs.oracle.com/en/database/other-databases/nosql-database/21.2/integrations/mapping-hive-external-table-vehicletable-non-secure-store.html)

```SQL
-- Create example database
CREATE DATABASE IF NOT EXISTS kvstore_examples;
USE kvstore_examples;

-- Remove the vehicletable table if it exists
DROP TABLE IF EXISTS vehicletable;

-- Create the KVStore connected external table
CREATE EXTERNAL TABLE IF NOT EXISTS vehicleTable (
    type STRING,
    make STRING,
    model STRING,
    class STRING,
    color STRING,
    price DOUBLE,
    count INT,
    dealerid DECIMAL,
    delivered TIMESTAMP
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
    "oracle.kv.kvstore" = "kvstore",
    "oracle.kv.hosts" = "localhost:5000",
    "oracle.kv.tableName" = "vehicleTable"
);

-- Query the external table
select type,make,model,class,color,price,count,dealerid from vehicletable;
```

### Stop Hive

```bash
pkill -f "HiveMetaStore|HiveServer2"
```

## Apache Kafka

[Original version](https://kafka.apache.org/documentation)

### Install Kafka

See [Optional Provisioners](./README.md#optional-provisioners) section.

### Start Kafka

```bash
# Start Zookeeper
nohup ${KAFKA_HOME}/bin/zookeeper-server-start.sh \
    ${KAFKA_HOME}/config/zookeeper.properties > zookeeper.log 2>&1 &
# Start Kafka broker
nohup ${KAFKA_HOME}/bin/kafka-server-start.sh \
    ${KAFKA_HOME}/config/server.properties > kafka.log 2>&1 &
```

### Stop Kafka

```bash
# Stop Kafka broker
kill $(jps | grep "Kafka" | cut -d' ' -f 1)
# Stop Zookeeper
kill $(jps | grep "QuorumPeerMain" | cut -d' ' -f 1 )
```

### Create Kafka Topic

```bash
${KAFKA_HOME}/bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092
```

### Write events into Kafka Topic

```bash
echo -e "Hello\nWord" | ${KAFKA_HOME}/bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092
```

### Read events from Kafka Topic

```bash
${KAFKA_HOME}/bin/kafka-console-consumer.sh --topic quickstart-events --from-beginning --bootstrap-server localhost:9092
```


## Sqoop

### Import data from MySQL to Hive

```bash
# Create test database and aux table in Hive
beeline -u jdbc:hive2://localhost:10000 -e "
    CREATE DATABASE IF NOT EXISTS test;
    DROP TABLE IF EXISTS test.aux;
    CREATE TABLE IF NOT EXISTS test.aux (mt_key1 STRING, mt_key2 INT, mt_comment STRING)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
"
# Import MySQL table to Hive with Sqoop
sqoop import -D org.apache.sqoop.splitter.allow_text_splitter=true --connect jdbc:mysql://localhost:3306/metastore?characterEncoding=latin1 --driver com.mysql.cj.jdbc.Driver --username hive --password hive --table AUX_TABLE --fields-terminated-by ',' --lines-terminated-by '\n' --hive-import --hive-table test.aux
# Check that the table was imported to Hive
beeline -u jdbc:hive2://localhost:10000 -e "SELECT * FROM test.aux;"
```

## Hbase

See [Optional Provisioners](./README.md#optional-provisioners) section.

### Start Hbase

> Note: Prior starting Hbase, it is required that Hadoop services are running.
> See [Start Hadoop](#start-hadoop-hdfs--yarn)

```bash
start-hbase.sh
```

### Stop Hbase

```bash
stop-hbase.sh
```

### Start Hbase Shell

```bash
hbase shell
```

For more Hbase usage examples, see the [official getting started guide](https://hbase.apache.org/book.html#_get_started_with_hbase).

## Apache Cassandra

See [Optional Provisioners](./README.md#optional-provisioners) section.

### Start Cassandra

> Note that by default Cassandra is configured to automatically start at startup.

```bash
sudo systemctl start cassandra
```

### Stop Cassandra

```bash
sudo systemctl stop cassandra
```

# Use Cassandra Query Language Shell

```bash
cqlsh localhost
```

```cql
-- Create a Keyspace
CREATE KEYSPACE IF NOT EXISTS ks
   WITH replication = {'class': 'NetworkTopologyStrategy'};

-- Use the Keyspace
USE ks;

-- Create a table inside the Keyspace
CREATE TABLE IF NOT EXISTS t (
    pk int,
    t int,
    v text,
    s text static,
    PRIMARY KEY (pk, t)
);

-- Instert values into the table
INSERT INTO t (pk, t, v, s) VALUES (0, 0, 'val0', 'static0');
INSERT INTO t (pk, t, v, s) VALUES (0, 1, 'val1', 'static1');

-- Query the table
SELECT * FROM t;

-- Use Ctrl + D to exit the Shell or the exit command
exit;
```

For more Cassandra usage examples, see the [official getting started guide](https://cassandra.apache.org/doc/latest/cassandra/getting-started/index.html).
