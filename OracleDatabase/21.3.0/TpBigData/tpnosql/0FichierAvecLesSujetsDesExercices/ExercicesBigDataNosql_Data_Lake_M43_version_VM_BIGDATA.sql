
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

-- Voir les exercices du module M4.2


--**************************************************************************************************************
--* Exercices Module M4.3 : Oracle NoSql et le Modèle Key/Document 
--* L'objectif ici est de mettre en oeuvre par la pratage le modèle clé/document avec les tables
--* des enregistrements, comment construire des clés (major et minor key) des  :
--* Exercices M4.3.1: Manipulation de tables via la Command Line Interface (CLI) 
--* Exercices M4.3.2: Manipulation de tables via la SQL Command Line Interface (SQL CLI) 
--* Exercices M4.3.3: Manipulation des tables par programmation via l'API JAVA
--**************************************************************************************************************



----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.1: Manipulation de tables via la Command Line Interface (CLI)
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.1.1 Création de tables via la CLI
----------------------------------------------------------------------------------------------------------------

-- Création de la table pilote2
kv-> execute 'drop table pilote2';

kv-> execute 'create table pilote2(
plnum  INTEGER ,  
plnom   STRING, 
dnaiss  STRING, 
adr     STRING, 
tel     STRING, 
sal     FLOAT, 
PRIMARY  KEY (shard(plnom, adr), plnum))';


-- Création de la table pilote2.checkup
-- Un pilote à 0 1 ou plusieurs checkup
-- Une façon d'introduire une pseudo clé étrangère sans contrainte
kv-> execute 'drop table pilote2.checkup';
kv-> execute  'create table pilote2.checkup(
cunum    	 INTEGER,  
cudate  	 STRING, 
curesultat	 STRING,
PRIMARY  KEY  (cunum))';


-- Création de la table pilote2.training
-- Un pilote fait 0 1 ou plusieurs training
-- Une façon d'introduire une pseudo clé étrangère sans contrainte
kv-> execute 'drop table pilote2.training';
kv-> execute  'create table pilote2.training(
trnum    	 INTEGER,  
trdate  	 STRING, 
trtypeTraining	 STRING,
trDureeEnHeure	INTEGER,
PRIMARY  KEY  (trnum))';


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.1.2 Insertion de lignes dans les tables créées via la CLI
----------------------------------------------------------------------------------------------------------------


-- insertion de ligne dans table pilote2 avec l'interface ligne de commande kv->

kv-> put table -name pilote2 -json 
'{"plnum":1,"plnom":"Gagarin1","dnaiss":"09/03/1934","adr":"Klouchino1, Russie", "tel":"0071122334455", "sal":10000.75}';

kv-> put table -name pilote2 -json 
'{"plnum":2,"plnom":"Gagarin2","dnaiss":"09/03/1935","adr":"Klouchino2, Russie", "tel":"0071122334456", "sal":10050.75}';

kv-> put table -name pilote2 -json 
'{"plnum":3,"plnom":"Gagarin2","dnaiss":"09/03/1960","adr":"Moscou1, Russie", "tel":"0071122334470", "sal":20050.75}';

kv-> put table -name pilote2 -json 
'{"plnum":4,"plnom":"Gagarin3","dnaiss":"09/03/1935","adr":"Klouchino3, Russie", "tel":"00711223344606", "sal":11050.75}';


-- insertion de ligne dans table pilote2.checkup avec l'interface ligne de commande kv->
kv-> put table -name pilote2.checkup -json 
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "cunum":1, "cudate":"12-12-2015", "curesultat": "BON"}';

kv-> put table -name pilote2.checkup -json 
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "cunum":2, "cudate":"11-1-2016",  "curesultat": "BON MAIS ATTENTION AU THE"}';

kv-> put table -name pilote2.checkup -if-absent -json '{"plnum":5, "plnom":"Gagarin2", "adr":"Moscou2, Russie", "cunum":1, "cudate":"12-12-2015", "curesultat": "BON"}';

-- insertion de ligne dans table pilote2.traning avec l'interface ligne de commande kv->
-- Insérer 3 training deux pour Gagarin2 nr 2

kv-> put table -name pilote2.training -json 
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "trnum":1, "trdate":"12-12-2015", "trtypeTraining": "Simulateur",  "trDureeEnHeure":5}';

kv-> put table -name pilote2.training -json 
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "trnum":2, "trdate":"11-1-2016",  "trtypeTraining": "Vol réel", "trDureeEnHeure":2}';

kv-> put table -name pilote2.training -json 
'{"plnum":5, "plnom":"Gagarin2", "adr":"Moscou2, Russie", "trnum":1, "trdate":"12-12-2015", "trtypeTraining": "Simulateur",  "trDureeEnHeure":3}';



----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.1.3 Consultation de données dans les tables créées via la CLI
----------------------------------------------------------------------------------------------------------------


-- Afficher les informations sur les pilotes  de nom Gagarin2
kv-> get table -name pilote2

-- Afficher les informations sur les pilotes  de nom Gagarin2
kv-> get table -name pilote2 -field plnom -value "Gagarin2"

-- Afficher les informations sur les pilotes  habitant  "Moscou1, Russie"
kv-> get table -name pilote2 -field adr -value "Moscou1, Russie"

kv-> execute 'create index idx_pilote2_adr on pilote2(adr)';

-- Afficher les informations sur les pilotes  habitant  "Moscou1, Russie"
kv-> get table -name pilote2 -field adr -value "Moscou1, Russie" -index idx_pilote2_adr

-- Afficher les informations sur les checkup du pilote de nom Gagarin2
kv-> get table -name pilote2.checkup -field plnom -value "Gagarin2"

-- Que fait cette requête ?
-- Texte ici : ?
kv-> get table -name pilote2.checkup -field plnom -value "Gagarin2" -ancestor pilote2

-- Que fait cette requête ?
-- Texte ici : ?
kv-> get table -name pilote2 -field plnom -value "Gagarin2" -child pilote2.checkup


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.1.3 Activités complémentaires sur les tables créées via la CLI
-- Requêtes avec Execute : SELECT, INSERT, UPDATE, DELETE
-- pas de get, pas de put
----------------------------------------------------------------------------------------------------------------

-- Insérer un nouveau pilote avec la syntaxe insert into tableName values (?)
?

-- Afficher les informations sur les pilotes  de nom Gagarin2
?

-- Afficher les informations sur les pilotes  de nom Gagarin2
?

-- Afficher les informations sur les pilotes  habitant  "Moscou1, Russie"
?

-- Afficher les informations sur les pilotes  habitant  "Moscou1, Russie"
?

-- Afficher les informations sur les checkup du pilote de nom Gagarin2
?


-- Modidifier le salaire de cd pilote ajouté
?

-- Supprimer le pilote de nom Gagarin2 et ses checkup
?


-- Afficher les informations sur les training du pilote de nom Gagarin2
?

-- Afficher les informations sur les training et les checkup du pilote de nom Gagarin2
?


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2: Manipulation de tables via la SQL Command Line Interface (SQL CLI)
----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.1 Lancement du client SQL de Oracle NOSQL
----------------------------------------------------------------------------------------------------------------

-- Lancement du client SQL de Oracle NOSQL
https://docs.oracle.com/en/database/other-databases/nosql-database/18.1/sqlfornosql/running-shell.html

cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0
C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0>vagrant ssh

[vagrant@oracle-21c-vagrant ~]java -jar $KVHOME/lib/sql.jar -helper-hosts localhost:5000 -store kvstore

sql->

----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.2 Création de tables via le client SQL d'Oracle NOSQL
----------------------------------------------------------------------------------------------------------------

sql->drop table pilote3;
sql->drop table pilote3.checkup;
sql->drop table pilote3.training;
sql->create table pilote3.checkup(
sql->drop table pilote3.training;

sql->create table pilote3(
plnum  INTEGER ,  
plnom   STRING, 
dnaiss  STRING, 
adr     STRING, 
tel     STRING, 
sal     FLOAT, 
PRIMARY  KEY (shard(plnom, adr), plnum));


-- Création de la table pilote3.checkup
-- Un pilote à 0 1 ou plusieurs checkup
-- Une façon d'introduire une pseudo clé étrangère sans contrainte
sql->drop table pilote3.checkup;
sql->create table pilote3.checkup(
cunum    	 INTEGER,  
cudate  	 STRING, 
curesultat	 STRING,
PRIMARY  KEY  (cunum));


-- Création de la table pilote3.training
-- Un pilote fait 0 1 ou plusieurs training
-- Une façon d'introduire une pseudo clé étrangère sans contrainte
sql->drop table pilote3.training;
sql->create table pilote3.training(
trnum    	 INTEGER,  
trdate  	 STRING, 
trtypeTraining	 STRING,
trDureeEnHeure	INTEGER,
PRIMARY  KEY  (trnum));


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.3 Insertion des lignes dans la table pilote3 via le client SQL de Oracle NOSQL
----------------------------------------------------------------------------------------------------------------


insert into pilote3 values (1,"Gagarin1","09/03/1934","Klouchino1, Russie", "0071122334455", 10000.75);
insert into pilote3 values (2,"Gagarin2","09/03/1935","Klouchino2, Russie", "0071122334456", 10050.75);
insert into pilote3 values (3,"Gagarin2","09/03/1960","Moscou1, Russie", "0071122334470", 20050.75);
insert into pilote3 values (4,"Gagarin3","09/03/1935","Klouchino3, Russie", "00711223344606", 11050.75);



----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.4 Insertion des lignes dans la table pilote3.checkup via le client SQL de Oracle NOSQL
----------------------------------------------------------------------------------------------------------------

insert into pilote3.checkup values ("Gagarin2","Klouchino2, Russie", 2, 1, "12-12-2015",  "BON");
insert into pilote3.checkup values ("Gagarin2","Klouchino2, Russie", 2, 2, "11-1-2016", "BON MAIS ATTENTION AU THE");
insert into pilote3.checkup values ("Gagarin2", "Moscou2, Russie",5, 1, "12-12-2015", "BON");


----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.5 Insertion des lignes dans la table pilote3.training via le client SQL de Oracle NOSQL
----------------------------------------------------------------------------------------------------------------


-- Insérer 3 training deux pour Gagarin2 nr 2

insert into pilote3.training values ("Gagarin2","Klouchino2, Russie", 2, 1, "12-12-2015", "Simulateur", 5);
insert into pilote3.training values ("Gagarin2","Klouchino2, Russie", 2, 2, "11-1-2016",  "Vol réel",2);
insert into pilote3.training values ("Gagarin2", "Moscou2, Russie",   5, 3, "12-12-2015", "Simulateur", 3);



----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.2.6 Activités complémentaires dans les tables pilote3, pilote3.checkup  et pilote3.training
----------------------------------------------------------------------------------------------------------------

-- Rechercher les pilotes de nom Gagarin3  ?
?

-- Rechercher les checkups des pilotes de nom Gagarin2 et pour ceux qui ont des ancêtres leurs ancêtres ?
?

-- Rechercher les pilotes de nom Gagarin3 et les checkups de nom Gagarin2 ?
?

-- Lister tous les checkup
?

-- Lister tous les pilotes
?

-- Insérer un nouveau pilote avec la syntaxe insert into tableName values (?)
?

-- Modidifier le salaire de cd pilote ajouté
?

-- Supprimer le pilote de nom Gagarin2 et ses checkup
?



----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.3: Manipulation des tables par programmation via l'API JAVA
----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.3.1 Sujet
-- Les tables créés ici rentrerons dans la construction du lac de données : exercices M4.6
----------------------------------------------------------------------------------------------------------------

-- Vous avez reçu la mission de mettre en place une application de notation des vols d'une compagnie aérienne.
-- Pour cela vous devez via java créer les tables ayant les caractéristiques suivantes :
-- table CRITERES avec les colonnes suivantes :
--	CRITEREID INTEGER, 
--	TITRE STRING,
--	DESCRIPTION STRING
--	)
--	// Clé primaire : CRITEREID

--	Valeurs de la colonne "Titre" des critères à noter :
--	La qualité du site reservation
--	Le prix
--	La nourriture à bord
--	La qualité du siege
--	L’accueil au guichet
--	L’accueil à bord.

--	table CLIENT avec les colonnes suivantes :
--	ClIENTID INTEGER, 
--		NOM STRING, 
--		PRENOM STRING, 
--		CODEPOSTAL STRING,
--		VILLE STRING,
--		ADRESSE  STRING,
--		TELEPHONE STRING,
--		ANNEENAISS STRING)
--		// Clé primaire : CLIENTID

--	table APPRECIATION avec les colonnes suivantes :
--		VOLID INTEGER, 
--		CRITEREID INTEGER, 
--		CLIENTID INTEGER, 
--		DATEVOL  STRING, 
--		NOTE ENUM (EXCELLENT, TRES_BIEN, BIEN, MOYEN PASSABLE)
		
--		// Clé primaire : VOLID, CRITEREID, CLIENTID, DATEVOL

--	La note peut être  (une contrainte est à poser  sous forme d’ENUM)
--		NOTE :  EXCELLENT, TRES_BIEN, BIEN, MOYEN, PASSABLE, MEDIOCRE


-- Afin d''effectuer ces exercices vous devez avoir démarré la base kvstore. 

--La documentation sur l''API TABLE se trouve dans la JAVADOC, ici 
https://docs.oracle.com/cd/NOSQL/html/javadoc/index.html
-- Les principales fonctions sont aussi expliquées en françaisdans le support de cours.

Vous devez compléter les méthodes dans la classe Airbase.java

/**
 * Cette classe fournit les fonctions nécessaires pour gérer les tables.
 * La fonction void executeDDL(String statement) reçoit en paramètre 
 * une commande ddl et l'applique dans la base nosql.
 * La displayResult affiche l'état de l'exécution de la commande
 * la fonction createTableCritere permet de créer une table critère>.
 */
 
-- disponible dans le dossier $MYTPHOME/tpnosql/airbase

-- Certaines méthodes sont déjà codées, d'autres sont à compléter. Voici les différentes méthodes :

/**
* Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
*/

private void displayResult(StatementResult result, String statement);



/**
* initAirbaseTablesAndData : cette méthode appelle plusieurs méthodes; Elle permet:
- De supprimer les tables CLIENT, APPRECIATION et CRITERE si elles existent
- De créer ou récréer les tables CLIENT, APPRECIATIONet CRITERE
- D'insérer des lignes dans la table critere
- De charger des apprécitions et des clients depuis des fichiers
*/
public void initAirbaseTablesAndData(Airbase arb) ;


/**
	Méthode de suppression de la table criteres.
*/	
public void dropTableCriteres();
	

	/**
		Méthode de suppression de la table clients.
	*/	
	public void dropTableClient();
	
	/**
		Méthode de suppression de la table Appreciation.
	*/
	public void dropTableAppreciation();	


	/**
		Méthode de création de la table criteres.
	*/
	public void createTableCriteres()


	/**
		Méthode de création de la table client.
	*/
	public void createTableClient()


	/**
		Méthode de création de la table Appreciation.
	*/
	public void createTableAppreciation()

	/**
	* insertCritresRows : Insère de nouvelles lignes dans la table pilote en appelant la fonction insertACritereRow
	*/

	public void insertCritresRows();
	
	/**
		Méthode générique pour executer les commandes DDL
	*/
	public void executeDDL(String statement);


	/**	
		Cette méthode insère une nouvelle ligne dans la table CRITERES
	*/
	private void insertACritereRow(int critereid, String titre, String description);



	/**
		private void insertAClientRow(int clientid, String nom, String prenom, String codePostal, String ville, 
			String adresse, String telephone, String anneeNaiss)
		Cette méthode insère une nouvelle ligne dans la table CLIENT
	*/
	private void insertAClientRow(int clientid, String nom, String prenom, String codePostal, String ville, 
			String adresse, String telephone, String anneeNaiss);


	/**
		private void insertAppreciationRow(int volid, int critereid, int clientid, String dateVol,   String note)
		Cette méthode insère une nouvelle ligne dans la table APPRECIATION
		
		A créer
	*/
	private void insertAppreciationRow(int volid, int critereid, int clientid, String dateVol,   String note);


	/**
		void loadClientDataFromFile(String clientDataFileName)
		cette methodes permet de charger les clients depuis le fichier 
		appelé clientData_txt.txt. 
		Pour chaque client chargé, la
		méthide insertAClientRow sera appélée
	*/
	void loadClientDataFromFile(String clientDataFileName);	


	/**
		void loadAppreciationDataFromFile(String clientDataFileName)
		cette methodes permet de charger les appréciationss depuis 
		le fichier appelé appreciationData_txt.txt. Pour chaque client
		chargé, la méthide insertAppreciationRow sera appélée
		
		A compléter
	*/
	void loadAppreciationDataFromFile(String clientDataFileName)
	

	/**
		private void displayCritereRow (Row critereRow)
		Cette méthode d'afficher une ligne de la table critere.
	*/
	private void displayCritereRow (Row critereRow);


	/**
		private void displayClientRow (Row clientRow)
		Cette méthode d'afficher une ligne de la table client.
		
		A compléter
	*/
	private void displayClientRow (Row clientRow)


	/**
		private void displayAppreciationRow (Row a^^reciationRow)
		Cette méthode d'afficher une ligne de la table client.
		
		A compléter
	*/	
	private void displayAppreciationRow (Row appreciationRow)


	/**
		private void getCritereByKey (int critereId)
		Cette méthode de charger  une ligne de la table critere
		connaissant sa clé
	*/
	public void getCritereByKey(int critereId)


/**
		private void getClientByKey (int clientId)
		Cette méthode de charger  une ligne de la table client
		connaissant sa clé
		
		A compléter
	*/
	public void getClientByKey(int clientId)



	/**
		private void getAppreciationByKey (int volId, int critereId, int clientid, String dateVol)
		Cette méthode de charger  une ligne de la table appreciation
		connaissant sa clé
		
		A compléter
	*/
	
	public void getAppreciationByKey(int volId, int critereId, int clientid, String dateVol)


	/**
		public void getCritereRows()
		Cette méthode permet de charger  toutes les lignes de la table critere
		connaissant sa clé
	*/
	public void getCritereRows()


	/**
		public void getClientRows()
		Cette méthode permet de charger  toutes les lignes de la table client
		connaissant sa clé
		
		A compléter
	*/
	public void getClientRows()


	/**
		public void getAppreciationRows()
		Cette méthode permet de charger  toutes les lignes de la table appreciation
		connaissant sa clé
		
		A compléter
	*/
	public void getAppreciationRows()

---------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.3.2 Lignes de compilation
---------------------------------------------------------------------------------------------------------------

-- Ouvrir un invite de commande DOS
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0


-- Pour lancer des composants, se connecter à la VM via SSH en lançant
vagrant ssh

[vagrant@oracle-21c-vagrant ~]$ export MYTPHOME=/vagrant/TpBigData


-- compilation
[vagrant@oracle-21c-vagrant ~]$ javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql $MYTPHOME/tpnosql/airbase/Airbase.java  
?
-- Exécution
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql airbase.Airbase 
?

---------------------------------------------------------------------------------------------------------------
-- Exercices M4.3.3.3 implémenter l'ensemble des méthodes définies en M4.3.3.1
---------------------------------------------------------------------------------------------------------------

-- Vous devez coder et exécuter les méthodes décrites plus
-- les tables Oracle nosql ici créées serviront pour la construction des lacs de données (voir les exercices 
-- du Module M4.6


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
--*************************************************************************************************************

-- Voir les exercices du module M4.6