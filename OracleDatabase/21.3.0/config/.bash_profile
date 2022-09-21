export PATH="/vagrant/config/bin:$HOME/.local/bin:$HOME/bin:$PATH"

# HADOOP ENVIRONMENT VARIABLES
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
export HADOOP_CREDSTORE_PASSWORD=ooups
export PATH=$PATH:$HADOOP_HOME/bin
export PATH=$PATH:$HADOOP_HOME/sbin

# SPARK ENVIRONMENT VARIABLES
export SPARK_HOME=/usr/local/spark
export PATH=$PATH:$SPARK_HOME/bin
export PYSPARK_DRIVER_PYTHON=/bin/python3
export PYSPARK_PYTHON=/bin/python3
export SPARK_LOCAL_IP=0.0.0.0
export LD_LIBRARY_PATH=$HADOOP_COMMON_LIB_NATIVE_DIR

# HIVE ENVIRONMENT VARIABLES
export HIVE_HOME=/usr/local/hive
export METASTORE_HOME=$HIVE_HOME
export PATH=$PATH:$HIVE_HOME/bin

# KVSTORE
export KVHOME=/usr/local/kv
export KVROOT=/var/kv
export MALLOC_ARENA_MAX=1

# JAVA CLASSPATH (to compile Hadoop & KVStore programs)
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
CLASSPATH="$HADOOP_HOME/share/hadoop/common/hadoop-common-3.3.3.jar"
CLASSPATH="$CLASSPATH:$HADOOP_HOME/share/hadoop/common/lib/commons-cli-1.2.jar"
CLASSPATH="$CLASSPATH:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-common-3.3.3.jar"
CLASSPATH="$CLASSPATH:$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-client-core-3.3.3.jar"
CLASSPATH="$CLASSPATH:$KVHOME/lib/kvclient.jar:$KVHOME/lib/kvstore.jar"
export CLASSPATH
