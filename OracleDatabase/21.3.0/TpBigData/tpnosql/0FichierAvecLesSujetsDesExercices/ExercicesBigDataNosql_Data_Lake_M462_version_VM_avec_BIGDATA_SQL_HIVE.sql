
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--++ Exercice MOOCEBFR4 : Ingénierie des Données du Big Data : SGBD NoSql et Lacs de Données avec Big Data SQL
--++ par la pratique
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



--------------------------------------------------------------------------------------------------------
-- Section 1 : s'assurer que la VM a bien été installée
--
-- Avant de commencer les activités, vous devez vous assuser que la machine virtuelles big Data contenant 
-- les composants suivants: l'environnement HADOOP (Hadoop hdfs, hadoop hive, ...), Oracle Nosql, MongoDB,
-- Oracle 21c, R, kafka, ...) est installée.
-- Cet envirionnement servira pour les exercices des modules :
-- 	. Exercices Module M4.2 : Introduction à Oracle NOSQL 
--  . Exercices Module M4.3 : Oracle NoSql et le Modèle Key/Document
--  . Exercices Module M4.4 : INTRODUCTION A MONGODB ET LE MONGO SHELL
--  . Exercices Module M4.5 : INTRODUCTION A MONGODB ET SON API JAVA
--  . Exercices Module M4.6 : Architectures Big data et construction de lacs de Données avec Big Data SQL 
--    par la pratique
--
-- Si la machine virtuelle Big data n'est pas encore installée, vous devez suivre la procédure qui est dans 
-- les ressources complémentaires :
-- ..\1Ressources_complementaires_Mooc_BigData\4Installations\3_MV_BIGDATA_SERGIO_INSTALLATION_RECOMMANDE
-- ou il y a lien vers la procedure d'installation de Sergio. 

--------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------
-- Section 2 : s'assurer que les principaux composant de  VM tournent
--
-- Avant de commencer les activités, vous devez vous assuser que la machine virtuelles big Data contenant 
-- les composants suivants: l'environnement HADOOP (Hadoop hdfs, hadoop hive, ...), Oracle Nosql, MongoDB,
-- Oracle 21c, R, kafak, ...) TOURNE.
-- Cet envirionnement servira pour les exercices des modules :
-- 	. Exercices Module M4.2 : Introduction à Oracle NOSQL 
--  . Exercices Module M4.3 : Oracle NoSql et le Modèle Key/Document
--  . Exercices Module M4.4 : INTRODUCTION A MONGODB ET LE MONGO SHELL
--  . Exercices Module M4.5 : INTRODUCTION A MONGODB ET SON API JAVA
--  . Exercices Module M4.6 : Architectures Big data et construction de lacs de Données avec Big Data SQL 
--    par la pratique
--
-- Si la machine virtuelle Big data ne tourne pas, vous devez suivre la procédure ci-dessous pour démarrer
-- la MV et les composants :
--

-- Se placer dans votre dossier ou la VM est installée

-- REMPLACER LE CHEMIN DE LA VM (C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0) 
-- CI-DESSOUS ET PARTOUT PAR LE VOTRE
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Créer la variable d'environnement VAGRANT_HOME qui servira plus tard
set VAGRANT_HOME=C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- vérifier si la vm tourne
vagrant status

Current machine states:

oracle-21c-vagrant        poweroff (virtualbox)

The VM is powered off. To restart the VM, simply run `vagrant up`

-- vérifier le status global
vagrant global-status

The above shows information about all known Vagrant environments
on this machine. This data is cached and may not be completely
up-to-date (use "vagrant global-status --prune" to prune invalid
entries). To interact with any of the machines, you can go to that
directory and run Vagrant, or you can use the ID directly with
Vagrant commands from any directory. For example:
"vagrant destroy 1a2b3c4d"



-- Arrêter si nécfessaire puis Activer la machine virtuelle Big Data
vagrant halt

vagrant up

-- S'il des erreurs veuillez contacter l'administreur de la VM

-- Pour lancer des composants, se connecter à la VM via SSH en lançant
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

vagrant ssh

----------------------------------------------------------------------------------------------------------------
-- Oracle NOSQL sur vagrant 
-- démarrage du serveur oracle nosql au premier lancement de la VM en mode non secure
----------------------------------------------------------------------------------------------------------------

nohup java -Xmx64m -Xms64m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT &
-- 

----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop HDFS
----------------------------------------------------------------------------------------------------------------

start-dfs.sh

----------------------------------------------------------------------------------------------------------------
-- Démarrage de Hadoop YARN
----------------------------------------------------------------------------------------------------------------

start-yarn.sh


----------------------------------------------------------------------------------------------------------------
-- Démarrage du serveur Hadoop HIVE
----------------------------------------------------------------------------------------------------------------


nohup hive --service metastore > /dev/null &
nohup hiveserver2 > /dev/null &


----------------------------------------------------------------------------------------------------------------
-- Démarrage de MongoDB
----------------------------------------------------------------------------------------------------------------

-- Automaquement 

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ FIN DU DEMARRAGE DES COMPOSANTS SERVEURS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



--**************************************************************************************************************
--* Exercices Module M4.2 : Introduction à Oracle NOSQL 
--**************************************************************************************************************

-- Voir les exercices de ce module



--**************************************************************************************************************
--* Exercices Module M4.3 : Oracle NoSql et le Modèle Key/Document 
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
--* Exercices Module M4.6 : Architectures Big data et construction de lacs de Données avec Big Data SQL 
--* par la pratique
--* L'objectif ici est de mettre en oeuvre par la pratage la construction de lacs de données avec Big Data SQL
--* et l'accès aux données du lac depuis R :
--* Exercices Module M4.6.1 : Sujet
--* Exercices Module M4.6.2 : Construction de lacs de données virtuel et/ou physique avec Hadoop HiveQL
--* Exercices Module M4.6.3 : Construction de lacs de données virtuel et/ou physique avec Big Data SQL 
--* Oracle               
--*************************************************************************************************************


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.1 : Sujet
---------------------------------------------------------------------------------------------------------------

-- L'objectif ici est de construire deux lacs de données SQL. Un premier autour de Hadoop HIVEQL et un 
-- un deuxième autour de Oracle SQL. Les différentes sources de données sont les suivantes :
-- 
-- . La source Oracle NOSQL. Dans cette source nous avons les tables suivantes :
--		- La table CLIENTS : Cette table contient les clients d'une compagnie aérienne qui participe à des vols
--		- La table CRITERES : Cette table contient les critères d'appréciation des vols par les clients
--		- La table APPRECIATIONS : Cette table contient les appréciations faites par les clients sur les vols
--
-- . La source Hadoop HDFS. Dans cette source nous avons le fichier suivant :
--		- Le fichier recommandationData_txt.txt : ce fichier contient les recommandations sur des vols
--
-- . La source HIVEQL ou ORACLE SQL. Dans cette source nous chargerons directement les tables contenues dans le
--   script airbase.sql :
--		- La table PILOTE: cette table contient les informations sur les pilotes de la compagnie aérienne
--		- La table AVION : cette table contient les informations sur les avions de la compagnie aérienne
--		- La table VOL   : cette table contient les informations sur les vols de la compagnie aérienne

-- Les données du lac seront (après construction des matrices) analysées depuis R.


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.2 : Construction de lacs de données virtuel et/ou physique avec Hadoop HiveQL
---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.2.1 : Architecture du lac autour d'Hadoop HiveQL
-- Exercices Module M4.6.2.2 : Création des tables externes HIVE pointant vers les tables physiques Oracle
-- Nosql
-- Exercices Module M4.6.2.3 : Création des tables externes HIVE pointant vers des fichiers physiques Hadoop
-- Hdfs
-- Exercices Module M4.6.2.4 : Exécution du script airbase.sql contenant les tables PILOTE, AVION et VOL dans
-- HIVE
-- Exercices Module M4.6.2.5 : Construction des matrix d'analyse de données au niveau de HIVEQL frontal du lac
-- Exercices Module M4.6.2.6 : Accès à la matrix du lac de Données depuis R


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.2.1 : Architecture du lac autour d'Hadoop HiveQL
---------------------------------------------------------------------------------------------------------------

-- Le premier lac de données sera construit autour du moteur SQL Hadoop HIVE.
-- L'architecture de ce lac est contenu dans le fichier ci-dessous nommé.
-- ..\2Exercices\Architecture_lac_de_donnees_avec_HIVE.pdf
--
-- Source Oracle NOSQL					Frontal lac de données : HIVE
-- 		table CLIENTS						table externe CLIENTS_ONS_EXT
-- 		table CRITERES						table externe CRITERES_ONS_EXT
-- 		table APPRECIATIONS					table externe APPRECIATIONS_ONS_EXT
	

-- Source Hadoop HDFS					Frontal lac de données : HIVE
-- 		Fichier recommandation.txt			table externe RECOMMANDATIONS_HDFS_EXT

-- Source script						Frontal lac de données : HIVE
-- 		airbase.sql							tables physiques : PILOTE, AVION, VOL


---------------------------------------------------------------------------------------------------------------
--	Exercices Module M4.6.2.2 : Création des tables externes HIVE pointant vers les tables physiques Oracle
-- Nosql
---------------------------------------------------------------------------------------------------------------

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh


-- Connexion à HIVE via son client BEELINE
-- On suppose que le serveur beeline a été démarré.

[vagrant@oracle-21c-vagrant ~]$beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

beeline>   

beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Etape 7.1.2.3 Créer les tables externes HIVE pointant vers les tables
-- équivalentes oracle Nosql

-- table externe Hive CRITERES_ONS_EXT
0: jdbc:hive2://localhost:10000>drop table CRITERES_ONS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE  CRITERES_ONS_EXT  (CRITEREID int, TITRE string, DESCRIPTION string)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
"oracle.kv.kvstore" = "kvstore",
"oracle.kv.hosts" = "localhost:5000", 
"oracle.kv.hadoop.hosts" = "localhost/127.0.0.1", 
"oracle.kv.tableName" = "CRITERES");


-- table externe Hive APPRECIATIONS_ONS_EXT
0: jdbc:hive2://localhost:10000>drop table APPRECIATIONS_ONS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE APPRECIATIONS_ONS_EXT(
	VOLID int, 
	CRITEREID int, 
	CLIENTID int, 
	DATEVOL  string, 
	NOTE string
)
?


-- table externe Hive CLIENTS_ONS_EXT
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



	
-- vérifications
0: jdbc:hive2://localhost:10000>select * from CRITERES_ONS_EXT;
?

0: jdbc:hive2://localhost:10000>select * from CLIENTS_ONS_EXT ;
?

0: jdbc:hive2://localhost:10000>select * from APPRECIATIONS_ONS_EXT ;
?

---------------------------------------------------------------------------------------------------------------
--	Exercices Module M4.6.2.3 : Création des tables externes HIVE pointant vers des fichiers physiques Hadoop
-- Hdfs
---------------------------------------------------------------------------------------------------------------

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh

-- Fixer la variable d'environnement MYTPHOME
[vagrant@oracle-21c-vagrant ~]$ export MYTPHOME=/vagrant/TpBigData


-- Ajout du fichier recommandationData_txt.txt dans Hadoop hdfs

-- Création d'une directorie hadoop
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -mkdir /recommandation



-- Ajout du  fichier dans hdfs
-- Structure du fichier recommandation_ext.txt
-- volid, clientid, datevol, recommandation

-- Suppression du fichier si vous souhaitez le remplacer
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -rm /recommandation/recommandationData_txt.txt

-- Ajout du fichier 
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -put $MYTPHOME/tpnosql/hdfsData/recommandationData_txt.txt /recommandation

-- Vérification de l'ajout.
[vagrant@oracle-21c-vagrant ~]$ hdfs dfs -ls /recommandation


-- Création de la table externe HIVE pointant vers le fichier HDFS
-- RECOMMANDATION_HDFS_EXT (VOLID STRING, CLIENTID STRING,  DATEVOL STRING, Recommand  string )

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh


-- Lancer Hive si ce n'est déjà fait

[vagrant@oracle-21c-vagrant ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

beeline>   

-- Se connecter à HIVE
beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Créer la table externe HIVE pointant vers le fichier recommandation_ext.txt

-- Table externe Hive RECOMMANDATIONS_HDFS_H_EXT
0: jdbc:hive2://localhost:10000>drop table recommandations_HDFS_EXT;

0: jdbc:hive2://localhost:10000>CREATE EXTERNAL TABLE  recommandations_HDFS_EXT  (VOLID STRING, CLIENTID STRING,  DATEVOL STRING, Recommand  string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '|'
STORED AS TEXTFILE LOCATION 'hdfs:/recommandation';

-- Vérifier la présence des lignes et de la table
0: jdbc:hive2://localhost:10000>select * from recommandations_HDFS_EXT;



---------------------------------------------------------------------------------------------------------------
--  Exercices Module M4.6.2.4 : Exécuter le script airbase.hql contenant les tables PILOTE, AVION et VOL
---------------------------------------------------------------------------------------------------------------

-- A revoir !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- Ouvrir un nouvel invite de commandes

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

-- Lancer ssh
vagrant ssh

-- Fixer la variable d'environnement MYTPHOME
[vagrant@oracle-21c-vagrant ~]$ export MYTPHOME=/vagrant/TpBigData


-- Lancer Hive si ce n'est déjà fait

[vagrant@oracle-21c-vagrant ~]$ beeline
Beeline version 1.1.0-cdh5.4.0 by Apache Hive

beeline>   

-- Se connecter à HIVE
beeline>   !connect jdbc:hive2://localhost:10000

Enter username for jdbc:hive2://localhost:10000: oracle
Enter password for jdbc:hive2://localhost:10000: ********
(password : welcome1)

-- Exécution du script le script airbase.hql contenant les tables PILOTE, AVION et VOL
0: jdbc:hive2://localhost:10000>@$MYTPHOME/scripts/airbase.hql

A vérifier !!!!!!!!!!!!!!!!!!!!!!!!!!!

-- vérifications

0: jdbc:hive2://localhost:10000>select * from pilote;
?

0: jdbc:hive2://localhost:10000>select * from avion;
?

0: jdbc:hive2://localhost:10000>select * from vol;
?


---------------------------------------------------------------------------------------------------------------
--Exercices Module M4.6.2.5 : Construction des matrix d'analyse de données au niveau de HIVEQL frontal du lac
---------------------------------------------------------------------------------------------------------------

En fonction des données venant du lac de données :
- Les données venant d''Oracle nosql: CLIENTS_ONS_EXT, CRITERES_ONS_EXT, APPRECIATIONS_ONS_EXT
- Les données venant d''Hadoop hdfs : RECOMMANDATIONS_HDFS_EXT
- Les données venant du script airbase.hql : PILOTE, AVION, VOL

Vous devez avec BIG DATA SQL construire la matrix nécessaire pour prédire l''itinéraire prioritaire 
nécessitant de créer de nouveaux vols en fonction des des appréciations et des recommandations des clients.

Vous devez procéder aux prétraitement des données et construire progressive la matrix avec Big Data SQL :
- Transformation des données si utile (date, ...), 
- Harmoniser les données (sexe : F, Feminin, Femal=> F par exemple)
- Introduire des colonnes calculer (salaire annuel à partir de salaires mensuels)
- Remplacer des colonnes par d''autres (remplacer la date de naissance par l''année)
- Fusion des données si utile 
- Supprimer les colonnes sans influences (colonne avec valeurs nulles, ...)
- changer l''échelle des valeurs (0 à 1000 => 0 à 1)
Tout cela en utilisant sql comme ETL
Ne pas hésiter à utilser les vues pour créer des étapes intermédiaires voir pour la
matrix finale.

A la fin vous devez obtenir une requête SQL (RSMX) matérialisant la matrix qui sera nécessaire dans R.


---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.2.6 : Accès à la matrix du lac de Données depuis R
---------------------------------------------------------------------------------------------------------------

En suivant la procédure contenue dans le fichier ci-dessous,  

..\1Ressources_complementaires_Mooc_BigData\1Installations\3_MV_BIGDATA_SERGIO_INSTALLATION_RECOMMANDE\3MV_SERGIO_CONNEXION_R_ORACLE\2Connexion_R_A_SGBD_Oracle_Dans_MV_BIGDATA_ORACLE_INSIDE_GOOD.sql


Vous devez y charger la requête RSMX définie en M4.6.3.6.



---------------------------------------------------------------------------------------------------------------
-- Exercices Module M4.6.3 : Construction de lacs de données virtuel et/ou physique avec Big Data SQL Oracle
---------------------------------------------------------------------------------------------------------------

-- Voir le fichier ..\2Exercices_Mooc_BigData\Exercices_Module_4.6\SujetExercices\ExercicesBigDataNosql_Data_Lake_M463_version_VM_avec_BIGDATA_SQL_ORACLE.SQL