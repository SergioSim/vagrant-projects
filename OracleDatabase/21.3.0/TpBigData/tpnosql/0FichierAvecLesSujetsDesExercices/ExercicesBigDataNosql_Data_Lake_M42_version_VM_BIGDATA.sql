
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
--* L'objectif ici est de mettre en oeuvre par la pratique le mod�le cl�/valeur et surtout comment construire
--* des enregistrements, comment construire des cl�s (major et minor key) des  :
--* M4.2.0: Pr�paration de l'envirionnement 
--* M4.2.1: Cr�ation, modification, suppression, lecture des enregistrements via la Command Line Interface(CLI) 
--* M4.2.2: Cr�ation, modification, suppression, lecture des enregistrements par programmation via l'API JAVA
--**************************************************************************************************************

--**************************************************************************************************************
--* M4.2.0: Pr�paration de l'envirionnement 
--* Il faut cr�er dans votre machine virtuelle un r�pertoire TpBigData
--* Sous TpBigData, cr�er les sous-dossiers suivants :
--* tpnosql : qui contiendra les ressources pour les exercices autour d'oracle NOSQL
--* tpmongo : qui contiendra les ressources pour les exercices autour de mongodb
--* etc.
--**************************************************************************************************************

----------------------------------------------------------------------------------------------------------------
-- Il faut cr�er dans le dossier vagrant le dossier TpBigData
----------------------------------------------------------------------------------------------------------------

[vagrant@oracle-21c-vagrant ~]$ ls /vagrant -la

total 3066469
drwxrwxrwx.  1 vagrant vagrant       4096 Aug 15 12:00 .
dr-xr-xr-x. 20 root    root           262 Dec  2  2022 ..
drwxrwxrwx.  1 vagrant vagrant       4096 Dec  2  2022 config
-rwxrwxrwx.  1 vagrant vagrant       1358 Dec  2  2022 .env
-rwxrwxrwx.  1 vagrant vagrant       6185 Dec  2  2022 EXAMPLES.md
-rwxrwxrwx.  1 vagrant vagrant        253 Dec  2  2022 .gitattributes
-rwxrwxrwx.  1 vagrant vagrant         20 Dec  2  2022 .gitignore
-rwxrwxrwx.  1 vagrant vagrant 3109225519 Dec  2  2022 LINUX.X64_213000_db_home.zip
drwxrwxrwx.  1 vagrant vagrant          0 Dec  2  2022 ora-response
-rwxrwxrwx.  1 vagrant vagrant      12140 Dec  2  2022 README.md
drwxrwxrwx.  1 vagrant vagrant       8192 Dec  2  2022 scripts
drwxrwxrwx.  1 vagrant vagrant          0 Dec  2  2022 userscripts
-rwxrwxrwx.  1 vagrant vagrant     879710 Dec  2  2022 V1020129-01.zip
-rwxrwxrwx.  1 vagrant vagrant   29889312 Dec  2  2022 V1030945-01.zip
drwxrwxrwx.  1 vagrant vagrant          0 Aug 15 11:47 .vagrant
-rwxrwxrwx.  1 vagrant vagrant       8221 Jan 25  2023 Vagrantfile
-rwxrwxrwx.  1 vagrant vagrant       8154 Jan 25  2023 Vagrantfile.bak

[vagrant@oracle-21c-vagrant ~]$ mkdir /vagrant/TpBigData

total 3066469
drwxrwxrwx.  1 vagrant vagrant       4096 Aug 15 12:00 .
dr-xr-xr-x. 20 root    root           262 Dec  2  2022 ..
drwxrwxrwx.  1 vagrant vagrant       4096 Dec  2  2022 config
-rwxrwxrwx.  1 vagrant vagrant       1358 Dec  2  2022 .env
-rwxrwxrwx.  1 vagrant vagrant       6185 Dec  2  2022 EXAMPLES.md
-rwxrwxrwx.  1 vagrant vagrant        253 Dec  2  2022 .gitattributes
-rwxrwxrwx.  1 vagrant vagrant         20 Dec  2  2022 .gitignore
-rwxrwxrwx.  1 vagrant vagrant 3109225519 Dec  2  2022 LINUX.X64_213000_db_home.zip
drwxrwxrwx.  1 vagrant vagrant          0 Dec  2  2022 ora-response
-rwxrwxrwx.  1 vagrant vagrant      12140 Dec  2  2022 README.md
drwxrwxrwx.  1 vagrant vagrant       8192 Dec  2  2022 scripts
drwxrwxrwx.  1 vagrant vagrant          0 Aug 15 12:00 TpBigData
drwxrwxrwx.  1 vagrant vagrant          0 Dec  2  2022 userscripts
-rwxrwxrwx.  1 vagrant vagrant     879710 Dec  2  2022 V1020129-01.zip
-rwxrwxrwx.  1 vagrant vagrant   29889312 Dec  2  2022 V1030945-01.zip
drwxrwxrwx.  1 vagrant vagrant          0 Aug 15 11:47 .vagrant
-rwxrwxrwx.  1 vagrant vagrant       8221 Jan 25  2023 Vagrantfile
-rwxrwxrwx.  1 vagrant vagrant       8154 Jan 25  2023 Vagrantfile.bak

----------------------------------------------------------------------------------------------------------------
-- Une fois le dossier TpBigData cr��, d�placer le dossier tpnosql fourni dans les ressources compl�mentaires
-- ici ..\3Mooc_BigData_BDNOSQL_DATA_LAKE\2Exercices_Mooc_BigData\Exercices_Module_4.2 ou 4.3
-- vers le dossier: TpBigData
----------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------
-- Allez dans le dosser /vagrant via l'interface graphique windows en suivant le chemin contenu dans : 
-- $VAGRANT_HOME d�fini plus haut
----------------------------------------------------------------------------------------------------------------

copiez coller tpnosql l�-bas
copy ..\3Mooc_BigData_BDNOSQL_DATA_LAKE\2Exercices_Mooc_BigData\Exercices_Module_4.2 ou 4.3/tpnosql /vagrant/TpBigData


----------------------------------------------------------------------------------------------------------------
-- D�marrage du client ligne de commandes Oracle NOSQL
----------------------------------------------------------------------------------------------------------------

[vagrant@oracle-21c-vagrant ~]$ java -jar $KVHOME/lib/kvstore.jar runadmin -port 5000 -host localhost


----------------------------------------------------------------------------------------------------------------
-- connexion � base
----------------------------------------------------------------------------------------------------------------

kv->connect store -name kvstore


--**************************************************************************************************************
--* M4.2.1: Cr�ation, modification, suppression, lecture des enregistrements via la Command Line Interface(CLI) 
--**************************************************************************************************************



-- M4.2.1.1 Identifier la liste de toutes les commandes de CLI-A&D (help)
-- Identifier les diff�rents composants avec les commandes 
-- (show, topology, map, put, put kv, put table, get, get kv, get table, ...)

kv-> help

?

-- Afficher la topology de la base

kv-> ?

?

----------------------------------------------------------------------------------------------------------------
-- M4.2.1.2 Ajouter les donn�es dans la base de donn�es via le mod�le key/value de base avec la CLI
-- (Commande Line Interface)
----------------------------------------------------------------------------------------------------------------

kv->help put 
kv->help put kv
kv->help put table


kv-> help put kv 
Usage: put kv -key <key> -value <valueString> [-file] [-hex]
        [-if-absent | -if-present]
        Puts the specified key, value pair into the store
        -file indicates that the value parameter is a file that contains the
        actual value
        -hex indates that the value is a BinHex encoded byte value with Base64
        -if-absent indicates to put a key/value pair only if no value for
        the given key is present.
        -if-present indicates to put a key/value pair only if a value for
        the given key is present.
Attention : Les cl�s sont des chaines de caract�res quelconques. 
Les valeurs aussi. Elles sont case sensitive.

-- Ajout d'un objet quelconque dans la base.
kv->put kv -key /bonjour -value "Bienvenue dans le monde du NoSQL : mod�le cl� valeur"
Operation successful, record inserted.

-- On souhaiterais ajouter des informations sur les pilotes
-- Attention c'est votre programme qui va interpr�ter le contenu.
-- Car il s'agit d'objets non structur�s.

put kv -key /Gagarin1/Klouchino1Russie/1 -value '{"plnum":1,"plnom":"Gagarin1","dnaiss":"09/03/1934","adr":"Klouchino1, Russie", "tel":"0071122334455", "sal":10000.75}';

put kv -key /Gagarin2/Klouchino2Russie/2 -value 
'{"plnum":2,"plnom":"Gagarin2","dnaiss":"09/03/1935","adr":"Klouchino2, Russie", "tel":"0071122334456", "sal":10050.75}';

put kv -key /Gagarin2/Moscou1Russie/3 -value 
'{"plnum":3,"plnom":"Gagarin2","dnaiss":"09/03/1960","adr":"Moscou1, Russie", "tel":"0071122334470", "sal":20050.75}';

put kv -key /Gagarin3/Klouchino3Russie/4 -value 
'{"plnum":4,"plnom":"Gagarin3","dnaiss":"09/03/1935","adr":"Klouchino3, Russie", "tel":"00711223344606", "sal":11050.75}';

-- Nous venons la de cr�er 4 nouveaux pilotes.

-- Ajouter deux nouveaux pilotes

?


-- On souhaiterais ajouter des informations sur les checkups des pilotes
-- Attention c'est votre programme qui va interpr�ter le contenu.
-- Car il s'agit d'un objet non structur�.
-- /cnum/x (x de 1 � N) est une minor k�y


put kv -key /Gagarin2/Klouchino2Russie/2/-/cunum/1 -value 
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "cunum":1, "cudate":"12-12-2015", "curesultat": "BON"}';

put kv -key /Gagarin2/Klouchino2Russie/2/-/cunum/2 -value
'{"plnum":2,"plnom":"Gagarin2","adr":"Klouchino2, Russie", "cunum":2, "cudate":"11-1-2016",  "curesultat": "BON MAIS ATTENTION AU THE"}';

put kv -key /Gagarin2/Moscou2Russie/5/-/cunum/1 -value
'{"plnum":5, "plnom":"Gagarin2", "adr":"Moscou2, Russie", "cunum":3, "cudate":"12-12-2015", "curesultat": "BON"}';
-- Nous venons la de cr�er 3 checkup.

-- Ajouter quatre nouveaux checkup

?




----------------------------------------------------------------------------------------------------------------
-- M4.2.1.3 Lecture des donn�es dans la base de donn�es via le mod�le key/value avec la CLI
----------------------------------------------------------------------------------------------------------------

-- Lectures des objets quelconques avec le mod�le key/value.
-- La commande pour lire est get kv
kv->help get 
kv->help get kv
kv->help get table

kv->help get kv

Usage: get kv -key <key> [-file <output>] [-all] [-keyonly]
        [-valueonly] [-start <prefixString>] [-end <prefixString>]
        Performs a simple get operation on the key in the store.
        -key indicates the key (prefix) to use.  Optional with -all.
        -all is specified for iteration starting at the key, or with
        an empty key to iterate the entire store.
        -start and -end flags can be used for restricting the range used
        for iteration.
        -keyonly works with -all and restricts information to keys.
        -valueonly works with -all and restricts information to values.
        -file is used to specify an output file, which is truncated.


kv->get kv -key /bonjour 
QmllbiB2ZW51ZSBkYW5zIGxlIG1vbmRlIGR1IE5vU1FMIDogbW9kimxlIGNsgiB2YWxldXI= [Base64]

https://base64.guru/converter/decode

/bonjour -value "Bienvenue dans le monde du NoSQL : mod�le cl� valeur"

kv->get kv -key /bonjour -all -valueonly

Bienvenue dans le monde du NoSQL : mod�le cl� valeur

-- Afficher les informations sur tous les pilotes de nom Gagarin2 
?

-- afficher les informations sur les pilotes de nom Gagarin2 habitant Klouchino2Russie
?

-- afficher les informations sur les checkup du pilote avec la cl� major /Gagarin2/Klouchino2Russie/2 

?

-- afficher les informations surun checkup connaissant son identifiant 

?


-- M4.2.1.4 Supprimer un objet de votre choix. V�rifier qu�il est bien supprim�

kv-> get kv -key /bonjour

kv-> delete kv -key /bonjour


-- V�rifier l'absence
kv-> ? 
?


--**************************************************************************************************************
--* M4.2.2: Cr�ation, modification, suppression, lecture des enregistrements par programmation via l'API JAVA

-- Dans ce cours il y trois exercices :
--	- Exercice M4.2.2.1 : conception d�un record
--	- Exercice M4.2.2.2 : Test de la classe existante HelloBigDataWorld.java
--  - Exercice M4.2.2.3 : Coder votre propre classe MobileClients.java
--  - Afin d''effectuer ces exercices vous devez avoir d�marr� la base kvstore. Activation du serveur :

--La documentation sur l''API se trouve dans la JAVADOC, ici :
https://docs.oracle.com/cd/NOSQL/html/javadoc/index.html
-- Les principales fonctions sont aussi expliqu�es en fran�ais dans support de cours.
--**************************************************************************************************************


----------------------------------------------------------------------------------------------------------------
-- Exercice M4.2.2.1 : conception d�un record
----------------------------------------------------------------------------------------------------------------

-- Soient les informations suivantes sur la structure d''op�rateur mobile
-- Concevoir les cl�s Majeures et les cl�s mineures ainsi que la valeur 
-- correspondant � la structure d�un client d�un op�rateur t�l�phonique :
-- Email
-- Nom
-- Pr�nom
-- T�l�phone mobile
-- Photo profil actuelle
-- Photos profiles anciennes
-- Adresse (num�ro, rue, code postal, ville )
-- Date abonnement
-- 10 Derniers Appels �mis
-- 10 derniers appels re�us

-- Un exemple de Structure des enregistrements (majorKey-MinorKeys)
-- /Nom/Prenom/Email/-minorKeys
-- Exemple :
-- /Nom/Prenom/Email/-
-- /Nom/Prenom/Email/-/info/
-- /Nom/Prenom/Email/-/info/adresse
-- /Nom/Prenom/Email/-/appels
-- /Nom/Prenom/Email/-/appels/derniersAppelsRecus
-- /Nom/Prenom/Email/-/appels/derniersAppelsEmis
-- /Nom/Prenom/Email/-/images
-- /Nom/Prenom/Email/-/images/photoProfile
-- /Nom/Prenom/Email/-/images/photoProfileAncienne
-- /Nom/Prenom/Email/-/T�lMobile
-- /Nom/Prenom/Email/-/DateAbonnement



----------------------------------------------------------------------------------------------------------------
-- Exercice M4.2.2.2 : Test de la classe existante HelloBigDataWorld.java  
---------------------------------------------------------------------------------------------------------------- 
-- Afin de comprendre les bases du mod�le Key/Value de la base NoSQL Oracle

-- L�enjeu est de comprendre et valider les points suivants :
-- Comment cr�er un handle pour �crire et lire des objets dans la base KVSTORE 
-- (role des classes KVStore, KVStoreFactory et KVStoreConfig)
-- Comment �crire un objet dans la base avec la function put de la classe KVStore
-- Comment lire un objet dans la base avec la function get de la classe KVStore
-- Comment fermer un handle vers la base kvstore

-- Actions  par �tape :
-- Etape 1 : Assurez que vous �tes connect�s sur la machine virtuel Big Data
-- Si vous avez votre propre machine virtuelle, vous devez ouvrir un xterm 
-- et d�marrer le serveur 
-- kvlite avec la commande suivante
-- activation du serveur. si pas d�marr�
-- java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite

-- Etape 2 : dossier du tp appel� tpnosql 
-- Assurez vous que ce dossier soit disponible dans $MYTPHOME

-- Ouvrir un CMD pour lancer la compilation et l'ex�cution avec java
export MYTPHOME=/vagrant/TpBigData

-- Sous MYTPHOME on trouvera:
tpnosql/hello/HelloBigDataWorld.java
tpnosql/pkMobileClients/MobileClients.java
tpnosql/airbase/Airbase.java


-- Etape 3 : Compiler et executer la classe HelloBigDataWorld.java

-- compilation
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql $MYTPHOME/tpnosql/hello/HelloBigDataWorld.java  

-- Ex�cution
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql hello.HelloBigDataWorld 


-- -host localhost -port 5000 -store kvstore

-- Il s'affiche
?

-- Etape 4 : Analyser le code de la classe HelloBigDataWorld.java et plus 
-- particuli�rement le main et la m�thode runExample afin de valider les 
-- enjeux d�crits au d�but de l�exercice


----------------------------------------------------------------------------------------------------------------
-- Exercice M4.2.2.3 : Coder votre propre classe MobileClients.java
----------------------------------------------------------------------------------------------------------------

-- Apr�s avoir test� la classe existante HelloBigDataWorld.java afin de comprendre les bases du mod�le Key/Value
-- de la base NoSQL Oracle. Vous devez aller plus loin en codant votre propre classe pour g�rer des clients
-- d�un op�rateur mobile. Cette classe appellee MobileClients.java est dans le package pkMobileClients. 

-- Editeur de texte simple dans la MV BIG DATA : nano
https://www.nano-editor.org/docs.php
https://www.hostinger.fr/tutoriels/nano/

-- Vous pouvez aussi utiliser tout �diteur de texte Windows, tel que notepad++

-- Ci-dessous les lignes de Compilation et execution de la classe MobileClients.java


-- Pour lancer des composants, se connecter � la VM via SSH en lan�ant
cmd

cd C:\Logiciels\19VM_SERGIO\vagrant-projects\OracleDatabase\21.3.0

vagrant ssh

-- Fixer la vairiable d'environnement MYTPHOME qui pointe vers les exercices du cours 
-- sont dans le dossier tpnosql

export MYTPHOME=/vagrant/TpBigData

-- Compilation de la classe MobileClients.java
javac -g -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql $MYTPHOME/tpnosql/pkMobileClients/MobileClients.java  

-- Ex�cution
java -Xmx256m -Xms256m  -cp $KVHOME/lib/kvclient.jar:$MYTPHOME/tpnosql pkMobileClients.MobileClients 
?


-- Compiler et tester vos fonctions au fil de leur codage. Il faut si utile adapter les chemins � votre contexte
-- Attention !!! V�rifier que le code du package pkMobileClients n'est pas une correction. Si c'est une
-- correction il n'y a plus qu'� compiler !!!

-- Structure des enregistrements (majorKey-MinorKeys)
/Nom/Prenom/Email/-minorKeys
Exemple :
/Nom/Prenom/Email/-
/Nom/Prenom/Email/-/info/
/Nom/Prenom/Email/-/info/adresse
/Nom/Prenom/Email/-/appels
/Nom/Prenom/Email/-/appels/derniersAppelsRecus
/Nom/Prenom/Email/-/appels/derniersAppelsEmis
/Nom/Prenom/Email/-/images
/Nom/Prenom/Email/-/images/photoProfile
/Nom/Prenom/Email/-/images/photoProfileAncienne
/Nom/Prenom/Email/-/T�lMobile
/Nom/Prenom/Email/-/DateAbonnement

-- La valeur associ�e � chaque cl� sera dans cet exercice uniquement un String. Voir les fonctions plus loin.

-- 5.3.1 Fonctions � completer ou am�liorer

	/**
		void createClient(String lastName, String firstName, String email, 
		String minorComponent, String data)
		Cette m�thode permet d�ajouter des clients dans la base nosql
		Travail attendu : Mettre les lignes de cette function dans le bon ordre. Compiler et tester. 
		V�rifier la presence des objets ajout�s dans l�interface CLI (kv->)
	*/
  void createClient(String lastName, String firstName, String email, String minorComponent, String data);


	/**
		void runMobileClients()
		Cette m�thode permet de cr�er quelques clients
	*/
    void runMobileClients();


	/**
		void deleteClient(String lastName, String firstName, String email, String minorComponent)
		Cette m�thode permet de supprimer un  client connaissant sa cl�.
		Travail attendu : Compl�ter et tester cette function
    */
	void deleteClient(String lastName, String firstName, String email, String minorComponent);
	

	/**
		void getClient(String lastName, String firstName, String email, String minorComponent)
		Cette m�thode permet de Lire un  client connaissant sa cl�.
		Travail attendu : Compl�ter et tester cette function
	*/
	void getClient(String lastName, String firstName, String email, String minorComponent);	
	
	/**
		void mutliGetClient(String lastName, String firstName, String email)
		Cette m�thode permet d�it�rer sur plusieurs clients ayant une m�me   
		major key. 
		Travail attendu : G�n�raliser la function en introduisant un parameter. Compl�ter et 
		tester cette function avec l�utilisation de la m�thode multiGet du package KVStore
	*/
    void mutliGetClient(String lastName, String firstName, String email);


	/**
		void printAllInfo()
		Cette m�thode permet d�it�rer sur l�ensemble des objets �crits 
		dans la base.
		Travail attendu : Tester cette function et d�crire son effet
	*/
    void printAllInfo();


	/**
		void printAllClientInfo(String lastName, String firstName, String email)
		Cette m�thode permet d�it�rer sur l�ensemble des objets �crits 
		dans la base pour un client connaissant sa majorkey ou une partie
		de sa major key.
		Travail attendu : Compl�ter et tester cette function et d�crire 
		son effet
	*/
	void printAllClientInfo(String lastName, String firstName, String email):


	/**
		void clientMultiGetIterator(String lastName, String firstName, String email)
		Cette m�thode permet d�it�rer sur plusieurs clients ayant une m�me   
		major key. Quelle est la difference avec la m�thode multiGet?
		Travail attendu : G�n�raliser la function en introduisant des param�tres. Compl�ter 
		et tester cette function avec l�utilisation de la m�thode multiGetIterator du 
		package KVStore
	*/
	void clientMultiGetIterator(String lastName, String firstName, String email);

	/**
		void clientMultiGetKeyIterator(String lastName, String firstName, String email)
		Cette m�thode permet d�it�rer sur plusieurs cl�s de clients ayant une m�me   
		major key. Quelle est la difference avec la m�thode multiGet?
		Travail attendu : G�n�raliser la function en introduisant des param�tres. Compl�ter 
		et tester cette function avec l�utilisation de la m�thode multiGetKeyIterator du 
		package KVStore
	*/
	void clientMultiGetKeyIterator(String lastName, String firstName, String email);	


	/**
		void clientMultiGetKeys()
		Cette m�thode permet d�it�rer sur plusieurs cl�s pointant vers des clients
		ayant une m�me  major key. 
		Travail attendu : Ecrire et tester cette function avec l�utilisation de la m�thode 
		multiGetKey du package KVStore*
	*/
	void clientMultiGetKeys(String lastName, String firstName, String email);
	
	
	/**
		void closeStore()
		Cette m�thode permet de fermer le store
	*/
    void closeStore();
	
	


--**************************************************************************************************************
--* Exercices Module M4.3 : Oracle NoSql et le Mod�le Key/Document 
--**************************************************************************************************************

-- Voir les exercices du module M4.3


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
--*************************************************************************************************************

-- Voir les exercices du module M4.6
