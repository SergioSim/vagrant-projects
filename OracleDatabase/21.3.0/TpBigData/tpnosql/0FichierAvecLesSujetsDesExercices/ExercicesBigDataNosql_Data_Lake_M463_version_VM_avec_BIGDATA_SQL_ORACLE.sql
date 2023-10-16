
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Exercice MOOCEBFR4 : Ing�nierie des Donn�es du Big Data : SGBD NoSql et Lacs de Donn�es avec Big Data SQL
--++ par la pratique
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--------------------------------------------------------------------------------------------------------
-- Section 1 : s'assurer que la VM a bien �t� install�e
--
-- Avant de commencer les activit�s, vous devez vous assuser que la machine virtuelles big Data contenant 
-- les composants suivants: l'environnement HADOOP (Hadoop hdfs, hadoop hive, ...), Oracle Nosql, MongoDB,
-- Oracle 21c, R, kafka, ...) est install�e.
-- Cet envirionnement servira pour les exercices des modules :
-- 	. Exercices Module M4.2 : Introduction � Oracle NOSQL 
--  . Exercices Module M4.3 : Oracle NoSql et le Mod�le Key/Document
--  . Exercices Module M4.4 : INTRODUCTION A MONGODB ET LE MONGO SHELL
--  . Exercices Module M4.5 : INTRODUCTION A MONGODB ET SON API JAVA
--  . Exercices Module M4.6 : Architectures Big data et construction de lacs de Donn�es avec Big Data SQL 
--    par la pratique
--
-- Si la machine virtuelle Big data n'est pas encore install�e, vous devez suivre la proc�dure qui est dans 
-- les ressources compl�mentaires :
-- ..\1Ressources_complementaires_Mooc_BigData\4Installations\3_MV_BIGDATA_SERGIO_INSTALLATION_RECOMMANDE
-- ou il y a lien vers la procedure d'installation de Sergio. 

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
-- Section 2 : s'assurer que les principaux composant de  VM tournent
--
-- Avant de commencer les activit�s, vous devez vous assuser que la machine virtuelles big Data contenant 
-- les composants suivants: l'environnement HADOOP (Hadoop hdfs, hadoop hive, ...), Oracle Nosql, MongoDB,
-- Oracle 21c, R, kafak, ...) TOURNE.
-- Cet envirionnement servira pour les exercices des modules :
-- 	. Exercices Module M4.2 : Introduction � Oracle NOSQL 
--  . Exercices Module M4.3 : Oracle NoSql et le Mod�le Key/Document
--  . Exercices Module M4.4 : INTRODUCTION A MONGODB ET LE MONGO SHELL
--  . Exercices Module M4.5 : INTRODUCTION A MONGODB ET SON API JAVA
--  . Exercices Module M4.6 : Architectures Big data et construction de lacs de Donn�es avec Big Data SQL 
--    par la pratique
--
-- Si la machine virtuelle Big data ne tourne pas, vous devez suivre la proc�dure ci-dessous pour d�marrer
-- la MV et les composants :
--

-- Se placer dans votre dossier ou la VM est install�e

-- REMPLACER LE CHEMIN DE LA VM (C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0) 
-- CI-DESSOUS ET PARTOUT PAR LE VOTRE
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Cr�er la variable d'environnement VAGRANT_HOME qui servira plus tard
set VAGRANT_HOME=C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- v�rifier si la vm tourne
vagrant status

Current machine states:

oracle-21c-vagrant        poweroff (virtualbox)

The VM is powered off. To restart the VM, simply run `vagrant up`

-- v�rifier le status global
vagrant global-status

The above shows information about all known Vagrant environments
on this machine. This data is cached and may not be completely
up-to-date (use "vagrant global-status --prune" to prune invalid
entries). To interact with any of the machines, you can go to that
directory and run Vagrant, or you can use the ID directly with
Vagrant commands from any directory. For example:
"vagrant destroy 1a2b3c4d"



-- Arr�ter si n�cfessaire puis Activer la machine virtuelle Big Data
vagrant halt

vagrant up

-- S'il des erreurs veuillez contacter l'administreur de la VM

-- Pour lancer des composants, se connecter � la VM via SSH en lan�ant
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

vagrant ssh

----------------------------------------------------------------------------------------------------------------
-- Oracle NOSQL sur vagrant 
-- d�marrage du serveur oracle nosql au premier lancement de la VM en mode non secure
----------------------------------------------------------------------------------------------------------------

nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
-- 

----------------------------------------------------------------------------------------------------------------
-- D�marrage de Hadoop
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
-- D�marrage de Hadoop HDFS
----------------------------------------------------------------------------------------------------------------

start-dfs.sh

----------------------------------------------------------------------------------------------------------------
-- D�marrage de Hadoop YARN
----------------------------------------------------------------------------------------------------------------

start-yarn.sh


----------------------------------------------------------------------------------------------------------------
-- D�marrage du serveur Hadoop HIVE
----------------------------------------------------------------------------------------------------------------


nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &


----------------------------------------------------------------------------------------------------------------
-- D�marrage de MongoDB
----------------------------------------------------------------------------------------------------------------

-- Automaquement 

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ FIN DU DEMARRAGE DES COMPOSANTS SERVEURS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



--**************************************************************************************************************
--* Exercices Module M4.2 : Introduction � Oracle NOSQL 
--**************************************************************************************************************

-- Voir les exercices de ce module



--**************************************************************************************************************
--* Exercices Module M4.3 : Oracle NoSql et le Mod�le Key/Document 
--**************************************************************************************************************

-- Voir les exercices de ce module



--*************************************************************************************************************
--* Exercices Module M4.4 : INTRODUCTION A MONGODB ET LE MONGO SHELL 
--*************************************************************************************************************

-- Voir les exercices du module M4.4


--*************************************************************************************************************
--* Exercices Module M4.5 : INTRODUCTION A MONGODB ET SON API JAVA 
--*************************************************************************************************************

-- Voir les exercices du module M4.5




--*************************************************************************************************************
--* Exercices Module M4.6 : Architectures Big data et construction de lacs de Donn�es avec Big Data SQL 
--* par la pratique
--* L'objectif ici est de mettre en oeuvre par la pratage la construction de lacs de donn�es avec Big Data SQL
--* et l'acc�s aux donn�es du lac depuis R :
--* Exercices Module M4.6.1 : Sujet
--* Exercices Module M4.6.2 : Construction de lacs de donn�es virtuel et/ou physique avec Hadoop HiveQL
--* Exercices Module M4.6.3 : Construction de lacs de donn�es virtuel et/ou physique avec Big Data SQL 
--* Oracle               
--*************************************************************************************************************


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.1 : Sujet
---------------------------------------------------------------------------------------------------------------

-- L'objectif ici est de construire deux lacs de donn�es SQL. Un premier autour de Hadoop HIVEQL et un 
-- un deuxi�me autour de Oracle SQL. Les diff�rentes sources de donn�es sont les suivantes :
-- 
-- . La source Oracle NOSQL. Dans cette source nous avons les tables suivantes :
--		- La table CLIENTS : Cette table contient les clients d'une compagnie a�rienne qui participe � des vols
--		- La table CRITERES : Cette table contient les crit�res d'appr�ciation des vols par les clients
--		- La table APPRECIATIONS : Cette table contient les appr�ciations faites par les clients sur les vols
--
-- . La source Hadoop HDFS. Dans cette source nous avons le fichier suivant :
--		- Le fichier recommandationData_txt.txt : ce fichier contient les recommandations sur des vols
--
-- . La source HIVEQL ou ORACLE SQL. Dans cette source nous chargerons directement les tables contenues dans le
--   script airbase.sql :
--		- La table PILOTE: cette table contient les informations sur les pilotes de la compagnie a�rienne
--		- La table AVION : cette table contient les informations sur les avions de la compagnie a�rienne
--		- La table VOL   : cette table contient les informations sur les vols de la compagnie a�rienne

-- Les donn�es du lac seront (apr�s construction des matrices) analys�es depuis R.


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.2 : Construction de lacs de donn�es virtuel et/ou physique avec Hadoop HiveQL
---------------------------------------------------------------------------------------------------------------

-- Voir le fichier ..\2Exercices_Mooc_BigData\Exercices_Module_4.6\SujetExercices\ExercicesBigDataNosql_Data_Lake_M462_version_VM_avec_BIGDATA_SQL_HIVE.SQL


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3 : Construction de lacs de donn�es virtuel et/ou physique avec Big Data SQL Oracle
---------------------------------------------------------------------------------------------------------------

-- Exercices Module M4.6.3.1 : Architecture du lac autour d'Oracle SQL
-- Exercices Module M4.6.3.2 : Cr�ation des tables externes HIVE pointant vers les tables physiques Oracle
-- Nosql
-- Exercices Module M4.6.3.3 : Cr�ation des tables externes HIVE pointant vers des fichiers physiques Hadoop
-- Hdfs
-- Exercices Module M4.6.3.4 : Cr�ation de tables externes Oracle pointant vers les tables externes HIVE
-- Exercices Module M4.6.3.5 : Ex�cution du script airbase.sql contenant les tables PILOTE, AVION et VOL
-- Exercices Module M4.6.3.6 : Construction des matrix d'analyse de donn�es au niveau de Oracle SQL frontal du
-- lac
-- Exercices Module M4.6.3.7 : Acc�s � la matrix du lac de Donn�es depuis R


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3.1 : Architecture du lac autour d'Hadoop HiveQL
---------------------------------------------------------------------------------------------------------------

-- Le deuxi�me lac de donn�es sera construit autour du moteur SQL ORACLE.
-- L'architecture de ce lac est contenu dans le fichier ci-dessous nomm�.
-- ..\2Exercices\Architecture_lac_de_donnees_avec_ORACLE.pdf
--
-- Source Oracle NOSQL		Pont du lac de donn�es : HIVEQL			Frontal du lac de donn�es ORACLE SQL
   -------------------      -------------------------------         ------------------------------------
-- table CLIENTS<---------- table externe CLIENTS_ONS_EXT<----------table externe CLIENTS_ONS_H_EXT
-- table CRITERES<---------	table externe CRITERES_ONS_EXT<---------table externe CRITERES_ONS_H_EXT
-- table APPRECIATIONS<---- table externe APPRECIATIONS_ONS_EXT<----table externe APPRECIATIONS_ONS_H_EXT
	

--Source Hadoop HDFS		  Frontal lac de donn�es : HIVE			   Frontal du lac de donn�es ORACLE SQL
  ------------------          -----------------------------			   ------------------------------------
--Fichier recommandation.txt<-table externe recommandations_hdfs_ext<--table externe recommandations_hdfs_h_ext

--Source script													   	   Frontal du lac de donn�es ORACLE SQL
  -------------  		             							   	   ------------------------------------
-- airbase.sql<--------------------------------------------------------tables physiques : PILOTE, AVION, VOL


---------------------------------------------------------------------------------------------------------------
--	Exercices Module M4.6.3.2 : Cr�ation des tables externes HIVE pointant vers les tables physiques Oracle
-- Nosql
---------------------------------------------------------------------------------------------------------------
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh

-- Connexion � HIVE via son client BEELINE
-- On suppose que le serveur beeline a �t� d�marr�.

[vagrant@oracle-21c-vagrant ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

beeline>   

-- Etape 7.1.2.2 Se connecter � HIVE

beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Cr�ation des tables externes HIVE pointant vers les tables �quivalentes oracle Nosql

-- Table externe Hive CRITERES_ONS_EXT
0: jdbc:hive2://localhost:10000>drop table CRITERES_ONS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE  CRITERES_ONS_EXT  (
CRITEREID int, 
TITRE string, 
DESCRIPTION string)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "CRITERES");


-- Table externe Hive APPRECIATIONS_ONS_EXT
0: jdbc:hive2://localhost:10000>drop table APPRECIATIONS_ONS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE APPRECIATIONS_ONS_EXT(
	VOLID int, 
	CRITEREID int, 
	CLIENTID int, 
	DATEVOL  string, 
	NOTE string
)
?


-- Table externe Hive CLIENTS_ONS_EXT
0: jdbc:hive2://localhost:10000>drop  table CLIENTS_ONS_EXT;
0: jdbc:hive2://localhost:10000>create external table CLIENTS_ONS_EXT (
	ClIENTID int, 
	NOM string, 
	PRENOM string, 
	CODEPOSTAL string,
	VILLE string,
	ADRESSE  string,
	TELEPHONE string,
	ANNEENAISS string
)
?


-- V�rifications
0: jdbc:hive2://localhost:10000>select * from CRITERES_ONS_EXT;
?

0: jdbc:hive2://localhost:10000>select * from CLIENTS_ONS_EXT ;
?

0: jdbc:hive2://localhost:10000>select * from APPRECIATIONS_ONS_EXT ;
?


---------------------------------------------------------------------------------------------------------------
--	Exercices Module M4.6.3.3 : Cr�ation des tables externes HIVE pointant vers des fichiers physiques Hadoop
-- Hdfs
---------------------------------------------------------------------------------------------------------------

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh

-- Fixer la variable d'environnement MYTPHOME
[vagrant@oracle-21c-vagrant ~]$ export MYTPHOME=/vagrant/TpBigData

-- Creation du fichier recommandationData_txt.txt dans Hadoop hdfs

-- Cr�ation d'une directorie hadoop
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /recommandation

-- Ajout du  fichier dans hdfs
-- Structure du fichier recommandation_ext.txt
-- volid, clientid, datevol, recommandation

-- Suppression du fichier si vous souhaitez le remplacer
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -rm /recommandation/recommandationData_txt.txt

-- Ajout du fichier 
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/tpnosql/hdfsData/recommandationData_txt.txt /recommandation

-- V�rification de l'ajout.
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /recommandation


-- Cr�ation de la table externe HIVE pointant vers le fichier HDFS
-- RECOMMANDATION_HDFS_EXT (VOLID STRING, CLIENTID STRING,  DATEVOL STRING, Recommand  string )

-- Lancer Hive si ce n'est d�j� fait

[vagrant@oracle-21c-vagrant ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

beeline>   

-- Se connecter � HIVE
beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Cr�er la table externe HIVE pointant vers le fichier recommandation_ext.txt

-- table externe Hive RECOMMANDATIONS_HDFS_H_EXT
0: jdbc:hive2://localhost:10000>drop table recommandations_HDFS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE  recommandations_HDFS_EXT  (VOLID STRING, CLIENTID STRING,  DATEVOL STRING, Recommand  string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE LOCATION 'hdfs:/recommandation';

-- V�rifier la pr�sence des lignes et de la table
0: jdbc:hive2://localhost:10000>select * from recommandations_HDFS_EXT;

---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3.4 : Cr�ation de tables externes Oracle pointant vers les tables externes HIVE
---------------------------------------------------------------------------------------------------------------

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh


-- Etape 7.1.3.Cr�er les tables externes Oracle SQl pointant vers les tables
-- externes HIVE qui elles m�mes pointent vers les tables �quivalentes 
-- oracle Nosql
-- Etape 7.1.3.1 D�marrer la base Oracle SQL CDH si elle ne l'est pas d�j�
-- ourvrir un xterm


-- si vous voyez le message suivant :
-- connected to a iddle instance
-- faites startup

[vagrant@oracle-21c-vagrant ~]$ sudo su oracle	

[oracle@oracle-21c-vagrant vagrant]$ sqlplus sys as sysdba

SQL*Plus: Release 21.0.0.0.0 - Production on Sat Aug 19 01:09:27 2023
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Enter password:

Connected to:
Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

-- Modifier les mots de passes des comptes SYS et SYSTEM
SQL>alter user sys identified by OracleWelcome1;
SQL>alter user system identified by OracleWelcome1;

-- Afficher la liste des bases Oracle pluggables
sql> show pdbs
 
    CON_ID CON_NAME                       OPEN MODE  RESTRICTED
---------- ------------------------------ ---------- ----------
         2 PDB$SEED                       READ ONLY  NO
         3 ORCLPDB1                       READ WRITE NO

-- Si vous voyez read write en face de ORCLPDB1, cett base tourne
-- Sinon fait ce qui suit pour la mettre en mode open :
sql> alter pluggable database ORCLPDB1 open;
sql> alter pluggable database ORCLPDB1 save state;


-- Afficher le nom de la base Oracle
sql>show parameter db_name
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
db_name                              string      ORCLCDB

-- Afficher le nom du service de la base Oracle
sql>show parameter service_names
NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
service_names                        string      ORCLCDB


-- Se connecter sur la base de donn�es pluggable et cr�er compte qui contiendra les tables du Lac Oracle SQL
sql>connect system@ORCLPDB1/OracleWelcome1

sql>create user uairbase identified by Uairbase01;
sql>grant dba to uairbase;
sql>revoke unlimited tablespace from uairbase;
sql>alter user uairbase quota unlimited on users;


-- Se connecter sur la base sur cloud de l'UNS 
-- lancez sqlplus comme suit :

sql>connect uairbase@ORCLPDB1/Uairbase01


-- Cr�er les deux directories suivantes si pas cr�� : ORACLE_BIGDATA_CONFIG et ORA_BIGDATA_CL_bigdatalite. 
-- La directorie ORACLE_BIGDATA_CONFIG sert � stocker les lignes rappatri�es des bases distantes.
-- Op�ration � faire une seule fois. 

-- v�rification
SQL> set pagesize 100
sql> set linesize 200
sql> col DIRECTORY_NAME format a30
sql> col DIRECTORY_PATH format a70
SQL> select DIRECTORY_NAME, DIRECTORY_PATH from dba_directories;

DIRECTORY_NAME                 DIRECTORY_PATH
------------------------------ ----------------------------------------------------------------------
SDO_DIR_ADMIN                  /opt/oracle/product/21c/dbhome_1/md/admin
XMLDIR                         /opt/oracle/product/21c/dbhome_1/rdbms/xml
XSDDIR                         /opt/oracle/product/21c/dbhome_1/rdbms/xml/schema
ORACLE_OCM_CONFIG_DIR2         /opt/oracle/homes/OraDB21Home1/ccr/state
ORACLE_OCM_CONFIG_DIR          /opt/oracle/homes/OraDB21Home1/ccr/state
ORACLE_BASE                    /opt/oracle
ORACLE_HOME                    /opt/oracle/product/21c/dbhome_1
OPATCH_INST_DIR                /opt/oracle/product/21c/dbhome_1/OPatch
DATA_PUMP_DIR                  /opt/oracle/admin/ORCLCDB/dpdump/EED6D9ACDC237A0BE0530101007F32A4
DBMS_OPTIM_LOGDIR              /opt/oracle/product/21c/dbhome_1/cfgtoollogs
DBMS_OPTIM_ADMINDIR            /opt/oracle/product/21c/dbhome_1/rdbms/admin
OPATCH_SCRIPT_DIR              /opt/oracle/product/21c/dbhome_1/QOpatch
OPATCH_LOG_DIR                 /opt/oracle/homes/OraDB21Home1/rdbms/log
JAVA$JOX$CUJS$DIRECTORY$       /opt/oracle/product/21c/dbhome_1/javavm/admin/

14 rows selected.


SQL> create or replace directory ORACLE_BIGDATA_CONFIG as '/vagrant/bigdatasql_config';
SQL> create or replace directory "ORA_BIGDATA_CL_bigdatalite" as '';



-- v�rification
SQL> set pagesize 100
sql> set linesize 200
sql> col DIRECTORY_NAME format a30
sql> col DIRECTORY_PATH format a70
SQL> select DIRECTORY_NAME, DIRECTORY_PATH from dba_directories;

DIRECTORY_NAME                 DIRECTORY_PATH
------------------------------ ----------------------------------------------------------------------
SDO_DIR_ADMIN                  /opt/oracle/product/21c/dbhome_1/md/admin
XMLDIR                         /opt/oracle/product/21c/dbhome_1/rdbms/xml
XSDDIR                         /opt/oracle/product/21c/dbhome_1/rdbms/xml/schema
ORACLE_OCM_CONFIG_DIR2         /opt/oracle/homes/OraDB21Home1/ccr/state
ORACLE_OCM_CONFIG_DIR          /opt/oracle/homes/OraDB21Home1/ccr/state
ORACLE_BASE                    /opt/oracle
ORACLE_HOME                    /opt/oracle/product/21c/dbhome_1
OPATCH_INST_DIR                /opt/oracle/product/21c/dbhome_1/OPatch
DATA_PUMP_DIR                  /opt/oracle/admin/ORCLCDB/dpdump/EED6D9ACDC237A0BE0530101007F32A4
DBMS_OPTIM_LOGDIR              /opt/oracle/product/21c/dbhome_1/cfgtoollogs
DBMS_OPTIM_ADMINDIR            /opt/oracle/product/21c/dbhome_1/rdbms/admin
OPATCH_SCRIPT_DIR              /opt/oracle/product/21c/dbhome_1/QOpatch
OPATCH_LOG_DIR                 /opt/oracle/homes/OraDB21Home1/rdbms/log
JAVA$JOX$CUJS$DIRECTORY$       /opt/oracle/product/21c/dbhome_1/javavm/admin/
ORA_BIGDATA_CL_bigdatalite
ORACLE_BIGDATA_CONFIG          /vagrant/bigdatasql_config

16 rows selected.



-- Cr�er les tables externes Oracle CRITERES_ONS_H_EXT, APPRECIATIONS_ONS_H_EXT, CLIENTS_ONS_H_EXT,
-- RECOMMANDATIONS_HDFS_H_EXT pointant vers les tables externes HIVE �quivalentes.

-- Cr�ation de ma table externe Oracle SQL CRITERES_ONS_H_EXT pointant vers la table externe HIVE
-- CRITERES_ONS_EXT
SQL> drop table CRITERES_ONS_H_EXT;

SQL> CREATE TABLE  CRITERES_ONS_H_EXT(
CRITEREID number(8), 
TITRE varchar2(50),
DESCRIPTION varchar2(100)
)
ORGANIZATION EXTERNAL (
TYPE ORACLE_HIVE 
DEFAULT DIRECTORY   ORACLE_BIGDATA_CONFIG
ACCESS PARAMETERS 
(
com.oracle.bigdata.tablename=default.CRITERES_ONS_EXT
)
) 
REJECT LIMIT UNLIMITED;

-- Cr�ation de ma table externe Oracle SQL APPRECIATIONS_ONS_H_EXT pointant vers la table externe HIVE
-- APPRECIATIONS_ONS_EXT
SQL> drop table APPRECIATIONS_ONS_H_EXT; 

SQL> CREATE TABLE APPRECIATIONS_ONS_H_EXT(
VOLID number(8), 
CRITEREID number(8), 
CLIENTID number(8),  
DATEVOL  varchar2(12), 
NOTE varchar2(12)
)

?

-- Cr�ation de ma table externe Oracle SQL CLIENTS_ONS_H_EXT pointant vers la table externe HIVE
-- CLIENTS_ONS_EXT
SQL> drop table CLIENTS_ONS_H_EXT;

SQL> create table CLIENTS_ONS_H_EXT (
ClIENTID 	number(8), 
NOM 		varchar2(50), 
PRENOM 		varchar2(50), 
CODEPOSTAL 	varchar2(7),
VILLE 		varchar2(100), 
ADRESSE  	varchar2(100), 
TELEPHONE 	varchar2(12), 
ANNEENAISS 	varchar2(6)
)
?;

SQL> CREATE  TABLE  recommandations_HDFS_H_EXT  (
VOLID varchar2(15), 
CLIENTID varchar2(15),  
DATEVOL varchar2(15), 
Recommand  varchar2(10)
)
?;



-- Structure des tables externes
SQL> desc CLIENTS_ONS_H_EXT;
SQL> desc APPRECIATIONS_ONS_H_EXT;
SQL> desc CRITERES_ONS_H_EXT;

-- CONSULTATION DES TABLES

-- V�rifications
SQL> select count(*) from CLIENTS_ONS_H_EXT;
SQL> select count(*) from APPRECIATIONS_ONS_H_EXT;
SQL> select count(*) from CRITERES_ONS_H_EXT;
SQL> select count(*) from recommandations_HDFS_H_EXT ;

-- consultation de la table externe CLIENTS_ONS_H_EXT et formatage des colonnes
-- Se limiter aux N premi�res lignes
SQL> set linesize 200
SQL> col NOM format 	A20
SQL> col PRENOM 	format A20
SQL> col VILLE 	format A30 
SQL> col ADRESSE format A40
SQL> select * from CLIENTS_ONS_H_EXT 
where rownum <10;

-- consultation de la table externe APPRECIATIONS_ONS_H_EXT  Se limiter aux N premi�res lignes
SQL> select * from APPRECIATIONS_ONS_H_EXT 
where rownum <10;

-- consultation de la table externe CRITERES avec formatage des colonnes
SQL> set linesize 200
SQL> col TITRE format 	A40
SQL> col DESCRIPTION format A40
SQL> select * from CRITERES_ONS_H_EXT;


-- consultation de la table recommandations_HDFS_H_EXT 
SQL> select * from recommandations_HDFS_H_EXT;

---------------------------------------------------------------------------------------------------------------
--  Exercices Module M4.6.3.5 : Ex�cuter le script airbase.sql contenant les tables PILOTE, AVION et VOL
---------------------------------------------------------------------------------------------------------------

sql> connect uairbase@ORCLPDB1/Uairbase01


sql> @$MYTPHOME/tpnosql/scripts/airbase.sql

-- v�rifications
sql> select * from pilote;
?

sql> select * from avion;
?

sql> select * from vol;
?


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3.6 : Construction des matrix d'analyse de donn�es au niveau de Oracle SQL frontal du
-- lac
---------------------------------------------------------------------------------------------------------------

En fonction des donn�es venant du lac de donn�es :
- Les donn�es venant d''Oracle nosql: CLIENTS_ONS_EXT, CRITERES_ONS_EXT, APPRECIATIONS_ONS_EXT
- Les donn�es venant d''Hadoop hdfs : RECOMMANDATIONS_HDFS_EXT
- Les donn�es venant du script airbase.hql : PILOTE, AVION, VOL

Vous devez avec BIG DATA SQL construire la matrix n�cessaire pour pr�dire l''itin�raire prioritaire 
n�cessitant de cr�er de nouveaux vols en fonction des des appr�ciations et des recommandations des clients.

Vous devez proc�der aux pr�traitement des donn�es et construire progressive la matrix avec Big Data SQL :
- Transformation des donn�es si utile (date, ...), 
- Harmoniser les donn�es (sexe : F, Feminin, Femal=> F par exemple)
- Introduire des colonnes calculer (salaire annuel � partir de salaires mensuels)
- Remplacer des colonnes par d''autres (remplacer la date de naissance par l''ann�e)
- Fusion des donn�es si utile 
- Supprimer les colonnes sans influences (colonne avec valeurs nulles, ...)
- changer l''�chelle des valeurs (0 � 1000 => 0 � 1)
Tout cela en utilisant sql comme ETL
Ne pas h�siter � utilser les vues pour cr�er des �tapes interm�diaires voir pour la
matrix finale.

A la fin vous devez obtenir une requ�te SQL (RSMX) mat�rialisant la matrix qui sera n�cessaire dans R.




---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3.7 : Acc�s � la matrix du lac de Donn�es depuis R
---------------------------------------------------------------------------------------------------------------

En suivant la proc�dure contenue dans le fichier ci-dessous,  

..\1Ressources_complementaires_Mooc_BigData\1Installations\3_MV_BIGDATA_SERGIO_INSTALLATION_RECOMMANDE\2MV_SERGIO_CONNEXION_HIVE_R\Installation_R_Et_Connexion_A_HIVE_MV_BIGDATA_SERGIO_SIMONIAN_R_INSIDE.sql


Vous devez y charger la requ�te RSMX d�finie en M4.6.3.6.



