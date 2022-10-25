#!/bin/bash

# Configure oracle to access Oracle NoSQL Database Data with external tables

# Following the example from:
# https://docs.oracle.com/en/database/other-databases/nosql-database/cookbook/index.html

# Abort on any error
set -Eeuo pipefail

# Create a directory where the External Table location files will reside
rm -rf /data
mkdir -p /data/kv
chown -R oracle:vagrant /data/kv
chmod -R a+rwx /data/kv

cp /vagrant/config/kv/nosql_stream $KVHOME/exttab/bin/nosql_stream

# Create directory objects in Oracle (note: nosql_bin_dir can't be a soft link)
su -l oracle -c "ORACLE_PDB_SID=ORCLPDB1 sqlplus / as sysdba << EOF
   CREATE OR REPLACE DIRECTORY ext_tab AS '/data/kv';
   CREATE OR REPLACE DIRECTORY nosql_bin_dir AS '/usr/local/kv-22.2.13/exttab/bin';
   exit
EOF"

# Grant appropriate permissions to Oracle users needing access to the External Table
su -l oracle -c "ORACLE_PDB_SID=ORCLPDB1 sqlplus / as sysdba << EOF
    CREATE USER nosqluser IDENTIFIED BY password;
    GRANT CREATE SESSION TO nosqluser;
    GRANT EXECUTE ON SYS.UTL_FILE TO nosqluser;
    GRANT READ, WRITE ON DIRECTORY ext_tab TO nosqluser;
    GRANT READ, EXECUTE ON DIRECTORY nosql_bin_dir TO nosqluser;
    GRANT CREATE TABLE TO nosqluser;
    exit
EOF"

# Define the External Table
su -l oracle -c "sqlplus nosqluser/password@ORCLPDB1 << EOF
    CREATE TABLE nosql_data (email VARCHAR2(30),
                             name VARCHAR2(30),
                             gender CHAR(1),
                             address VARCHAR2(40),
                             phone VARCHAR2(20))
        ORGANIZATION EXTERNAL
            (type oracle_loader
            default directory ext_tab
            access parameters (records delimited by newline
            preprocessor nosql_bin_dir:'nosql_stream'
            fields terminated by '|' missing field values are null)
        LOCATION ('nosql.dat'))
        REJECT LIMIT UNLIMITED
        PARALLEL;
    exit
EOF"

# Create Some Sample Data In NoSQL Database
su -l vagrant -c "javac -cp $CLASSPATH:$KVHOME/examples $KVHOME/examples/externaltables/*.java"

su -l vagrant -c "
java -cp $CLASSPATH:$KVHOME/examples externaltables.LoadCookbookData \
     -store kvstore -host localhost -port 5000 -nops 10
"

# Publish the configuration to the External Table Location files
# TODO: configure oracle wallet as an external password store
su -l oracle -c "
java -cp $CLASSPATH:/opt/oracle/product/21c/dbhome_1/jdbc/lib/ojdbc8.jar \
    oracle.kv.exttab.Publish \
    -config /vagrant/config/kv/config.xml -publish
"

# Test the nosql_stream script by running it in a shell:
nosql_stream /data/kv/nosql.dat
su -l oracle -c "CLASSPATH=$CLASSPATH $KVHOME/exttab/bin/nosql_stream /data/kv/nosql.dat"

su -l oracle -c "sqlplus nosqluser/password@ORCLPDB1 << EOF
    select * from nosql_data;
    exit
EOF"
