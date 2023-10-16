
/*
+++++++++++++++++++++++++++++++++++++++++ TRAVAIL A FAIRE : COMPLETER LES METHODES SUIVANTES ++++++++++++++++++++++++++++
public void createCollectionClient(String nomCollection);
public void dropCollectionClient(String nomCollection);
public void insertOneClient(String nomCollection, Document client);
public void testInsertOneClient();
public void insertManyClients(String nomCollection, List<Document> clients);
public void testInsertManyClients();
public void getClientById(String nomCollection, Integer ClientId);
public void getClients(String nomCollection, Document whereQuery, Document projectionFields, Document sortFields);
public void updateClients(String nomCollection, Document whereQuery, Document updateExpressions, UpdateOptions updateOptions);
public void deleteClients(String nomCollection, Document filters);
public void displayIterator(Iterator it, String message);
public void joinLocalAndforeignCollections(
			String localCollectionName, 
			String foreignCollectionName, 
			String localColJoinFieldName,
			String foreigColJoinFieldName,
			Document fielterFieldsOnLocalCollection,
			String namedJoinedElements
)
public void loadClientsFromJsonArrayFile (
	String collectionName,
	String filePath,
	String fileName);
	
public void loadClientsFromCSVFile(
	String collectionName,
	String filePath,
	String fileName	
	);

public void loadClientsFromJsonArrayFileWithMongoImport(
	String dbName, 
	boolean isJsonArray, 
	String collectionName,
	String filePath,
	String fileName
	);
	
public void loadClientsFromCSVFileWithMongoImport(
	String dbName, 
	boolean isCsvFile, 
	String collectionName,
	String filePath,
	String fileName	
	);
	
public void ajouterUneAppreciationAUnVol();

*/

package tpjava;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase; 
import com.mongodb.MongoClient; 
import com.mongodb.MongoCredential; 
import com.mongodb.DBObject;  
import com.mongodb.BasicDBObject; 
import com.mongodb.DBCollection; 
import com.mongodb.DBCursor;
import com.mongodb.DB; 
import org.bson.Document;  
import java.util.Arrays;
import java.util.List;
import com.mongodb.client.FindIterable; 
import java.util.Iterator; 
import java.util.ArrayList;
import com.mongodb.client.result.UpdateResult;
import com.mongodb.client.model.UpdateOptions;
import com.mongodb.util.JSON;

import java.io.*;
import java.io.File;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.FileReader;
//import org.apache.commons.io.FileUtils;

//import org.apache.commons.io.FileUtils;

import com.mongodb.client.model.InsertOneModel;
import java.io.*;
import com.mongodb.client.model.BulkWriteOptions;


import com.mongodb.client.model.Aggregates;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Indexes;
import com.mongodb.client.model.IndexOptions;



import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
//import org.json.JSONException;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.io.FileUtils;
import org.bson.Document;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import net.sf.json.*;

public class Client { 
   private MongoDatabase database;
   private String dbName="airbaseDB";
   private String hostName="localhost";
   private int port=27017;
   private String userName="uairbase";
   private String passWord="UairbasePass";
   private String clientCollectionName="colClients";
   private String volCollectionName="colVols";
   
   private String clientsFilePath="C:\\TRAVAUX_PRATIQUES\\TPMONGO\\2021_2022\\MBDS_EMSI\\2Exercices\\tpjava\\";
   private String clientsCsvFileName="0_4Json_collection_Import_Clients_Airbase.csv";
   private String clientsJsonArrayFileName="0_4Json_collection_Import_Clients_Airbase.json";
   private String destClientsCsvFileName="0_45Json_collection_Import_Clients_Airbase.csv";

   
   public static void main( String args[] ) {  
    try{
		Client client = new Client();
		// TC1a : Supprimer et creer une collection, inserer un puis plusieurs clients
		System.out.println("\n\n TC1a ...");
		//client.dropCollectionClient(client.clientCollectionName);
		//client.createCollectionClient(client.clientCollectionName);
		//client.deleteClients(client.clientCollectionName, new Document());

		// TC1b : inserer un puis plusieurs clients depuis des variables Java
		System.out.println("\n\n TC1b ...");

		// client.testInsertOneClient();
		// client.testInsertManyClients();

		// TC1c : Importer les clients depuis un fichier json1Array. Alternatif a Tc1b et d
		System.out.println("\n\n TC1c ...");


		// client.loadClientsFromJsonArrayFile(
		// client.clientCollectionName,
		// client.clientsFilePath,
		// client.clientsJsonArrayFileName);
		
		// TC1d : Importer les clients depuis un fichier JsonArray avec MongoImport. Alternatif a Tc1b et c
		System.out.println("\n\n TC1d ...");
		
	    // client.loadClientsFromJsonArrayFileWithMongoImport(
		// client.dbName, 
		// true, 
		// client.clientCollectionName,
		// client.clientsFilePath,
		// client.clientsJsonArrayFileName
		// );	

		
		// TC1e : Importer les clients depuis un fichier CSV. Alternatif a Tc1b, c, d
		System.out.println("\n\n TC1e ...");
		// client.loadClientsFromCSVFile(
		// client.clientCollectionName,
		// client.clientsFilePath,
		// client.clientsCsvFileName);
		// TC1a : Supprimer et creer une collection, inserer un puis plusieurs clients

		// TC2a: Afficher un client connaissant son numero
		System.out.println("\n\n TC2a ...");
		//client.getClientById(client.clientCollectionName, 10);

		
		// 
		// TC2b: Afficher tous les clients sans tri ni projection
		System.out.println("\n\n TC2b ...");

		// client.getClients(
			// client.clientCollectionName, 
			// new Document(), 
			// new Document(),
			// new Document());
		
		
		// TC3 : Afficher tous les clients trie en ordre decroissant sur le nom
		System.out.println("\n\n TC3 ...");

		// client.getClients(client.clientCollectionName, 
			// new Document(),
			// new Document(),
			// new Document(?)
		// );	
		
		// TC4 : Modifier  la date de naissance et le telephone d'un client connaissant son nr		System.out.println("\n\n TC4 ...");
		
	
		// client.updateClients(client.clientCollectionName, 
		// new Document(?), 
		// new Document ("$set", ?),
		// new UpdateOptions()
		// );
		
		
		//client.deleteClients(client.clientCollectionName, new Document());		
		//client.deleteClients(client.clientCollectionName, new Document("_id", 7369));		
	
		// client.joinLocalAndforeignCollections(
			// client.clientCollectionName, 
			// client.volCollectionName, 
			// "_id",
			// "idClient",
			// new Document()
		// );
		
		// TC1d : Importer les clients depuis un fichier JsonArray avec MongoImport. Alternatif a Tc1b et c
		System.out.println("\n\n TC3a ...");
		
	    client.exportClientsToJsonCsvFileWithMongoExport(
		client.dbName, 
		true, 
		client.clientCollectionName,
		client.clientsFilePath,
		client.destClientsCsvFileName
		);		
	}catch(Exception e){
		e.printStackTrace();
	}	
   } 
 

   /**
	FC1 : Constructeur Client.
	Dans ce constructeur sont effectuees les activites suivantes:
	- Creation d'une instance du client MongoClient
	- Creation d'une BD Mongo appele RH
	- Creation d'un utilisateur appele 
	- Chargement du pointeur vers la base RH
   */
   Client(){
		// Creating a Mongo client
		
		MongoClient mongoClient = new MongoClient( hostName , port ); 

		// Creating Credentials 
		// RH : Ressources Humaines
		MongoCredential credential; 
		credential = MongoCredential.createCredential(userName, dbName, 
		 passWord.toCharArray()); 
		System.out.println("Connected to the database successfully"); 	  
		System.out.println("Credentials ::"+ credential);  
		// Accessing the database 
		database = mongoClient.getDatabase(dbName); 
   }

   /**
	FC2 : Cette fonction permet de creer une collection
	de nom nomCollection.
   */   
   public void createCollectionClient(String nomCollection){
		//Creating a collection 
		database.createCollection(nomCollection); 
		System.out.println("Collection Clients created successfully"); 

   }

   /**
	FC3 : Cette fonction permet de supprimer une collection
	connaissant son nom.
   */
   
   public void dropCollectionClient(String nomCollection){
		//Drop a collection 
		MongoCollection<Document> colClients=null; 
		System.out.println("\n\n\n*********** dans dropCollectionClient *****************");   

		System.out.println("!!!! Collection Client : "+colClients);

		colClients=database.getCollection(nomCollection);
		System.out.println("!!!! Collection Client : "+colClients);
		// Visiblement jamais !!!
		if (colClients==null)
			System.out.println("Collection inexistante");
		else {
			colClients.drop();	
			System.out.println("Collection colClients removed successfully !!!"); 
	  
		}
   }

   /**
	FC4 : Cette fonction permet d'inserer un client dans une collection.
   */
   
   public void insertOneClient(String nomCollection, Document client){
		//Drop a collection 
		MongoCollection<Document> colClients=database.getCollection(nomCollection);
		colClients.insertOne(client); 
		System.out.println("Document inserted successfully");     
   }


   /**
	FC5 : Cette fonction permet de tester la methode insertOneClient.
   */

   public void testInsertOneClient(){
		
		Document  client = new Document("_id", "07")
		.append ("nom", "Bond")
		.append("prenom", Arrays.asList("James"))
		.append("telephone", "673212293")
		.append("DateNaiss","03/02/1990")
		.append("adresse", new Document( "numero", 20)
			.append("rue", "queens avenue")
			.append("codePostal",  "EC4R 2SU")
			.append("ville",  "Londres")
			.append("pays",  "Royaune Uni")
		);
		this.insertOneClient(this.clientCollectionName, client);
		System.out.println("Document inserted successfully");     
   }

   /**
	FC6 : Cette fonction permet d'inserer plusieurs clients dans une collection
   */

   public void insertManyClients(String nomCollection, List<Document> clients){
		//Drop a collection 
		MongoCollection<Document> colClients=database.getCollection(nomCollection);
		colClients.insertMany(clients); 
		System.out.println("Many Documents inserted successfully");     
   }

   /**
	FC7 : Cette fonction permet de tester la fonction insertManyClients
   */

   public void testInsertManyClients(){
		List<Document> clients = Arrays.asList(
		new Document("_id", 1)
		   .append("nom",  "Martin")
		   .append("prenom", Arrays.asList("Aaron", "Frida"))
		   .append("telephone", "673212284")
		   .append("DateNaiss", "01/01/1980")
		   .append("adresse",  new Document("numero",  11)
					  .append("rue", "Allee Cavendish")
					  .append("codePostal",  "06000")
					  .append("ville",  "Nice")
					  .append("pays",  "France")
				  ),

	   new Document("_id",  2)
	   .append("nom",  "Bernard")
	   .append("prenom",  Arrays.asList("Abel"))
	   .append("telephone", "673212285")
	   .append("DateNaiss", "05/05/1984")
	   .append("adresse", 
				new Document("numero",  12)
				  .append("rue", "Allee de la Chapelle Saint-Pierre")
				  .append("codePostal",  "06000")
				  .append("ville",  "Nice")
				  .append("pays",  "France")
			  ),

	   new Document("_id",  3)
	   .append("nom",  "Dubois")
	   .append("prenom", Arrays.asList("Abella", "Mehdi"))
	   .append("telephone", "673212286")
	   .append("DateNaiss", "02/02/1990")
	   .append("adresse", new Document("numero",  13)
				  .append("rue", "Rue la Fontaine aux Oiseaux")
				  .append("codePostal",  "06000")
				  .append("ville",  "Nice")
				  .append("pays",  "France")
			  ),

	   new Document("_id",  4)
	   .append("nom",  "Thomas")
	   .append("prenom", Arrays.asList("Abelard"))
	   .append("telephone", "673212287")
	   .append("DateNaiss", "01/06/1987")
	   .append("adresse", new Document("numero",  14)
				  .append("rue", "Rue La Palmeraie")
				  .append("codePostal",  "France")
				  .append("ville",  "Nice")
				  .append("pays",  "France")
			   ),

	   new Document("_id",  5)
	   .append("nom",  "Walter")
	   .append("prenom", Arrays.asList("Robert"))
	   .append("telephone", "673212288")
	   .append("DateNaiss", "01/08/1983")
	   .append("adresse",  new Document("numero",  15)
				  .append("rue", "Rue de la Resistance")
				  .append("codePostal",  "10001")
				  .append("ville",  "New-york")
				  .append("pays",  "USA")
			   ),

	   new Document("_id",  6)
	   .append("nom",  "Richard")
	   .append("prenom", Arrays.asList("Maria", "Abondance"))
	   .append("telephone", "673212289")
	   .append("DateNaiss", "12/01/1980")
	   .append("adresse", new Document("numero",  16)
				  .append("rue", "Allee des Citronniers")
				  .append("codePostal",  "75001")
				  .append("ville",  "Paris")
				  .append("pays",  "France")
			  ),

	   new Document("_id",  7)
	   .append("nom",  "Petit")
	   .append("prenom", Arrays.asList("Abraham", "Leonard"))
	   .append("telephone", "673212290")
	   .append("DateNaiss", "01/08/1980")
	   .append("adresse",  new Document("numero",  17)
				  .append("rue", "Allee des Faunes")
				  .append("codePostal",  "69001")
				  .append("ville",  "Lyon")
				  .append("pays",  "France")
			   ),

	   new Document("_id",  8)
	   .append("nom",  "Durand")
	   .append("prenom", Arrays.asList("Mari", "Achille"))
	   .append("telephone", "673212291")
	   .append("DateNaiss", "01/09/1989")
	   .append("adresse",  new Document("numero",  18)
				  .append("rue", "Rue des Isnards")
				  .append("codePostal",  "75001")
				  .append("ville",  "Paris")
				  .append("pays",  "France")
			   ),

	   new Document("_id",  9)
	   .append("nom",  "Leroy")
	   .append("prenom", Arrays.asList("Ada", "Mousse"))
	   .append("telephone", "673212292")
	   .append("DateNaiss", "28/07/1985")
	   .append("adresse",  new Document("numero",  19)
				  .append("rue", "Rue des Lucioles")
				  .append("codePostal",  "13001")
				  .append("ville",  "Marseille")
				  .append("pays",  "France")
			   ),

	   new Document("_id",  10)
	   .append("nom", "Moreau")
	   .append("prenom", Arrays.asList("Adam"))
	   .append("telephone", "673212293")
	   .append("DateNaiss", "03/02/1990")
	   .append("adresse", new Document("numero", 20)
				  .append("rue", "Allee des Palmiers")
				  .append("codePostal",  "31000")
				  .append("ville",  "Toulouse")
				  .append("pays", "France")
			   )
	   );
		this.insertManyClients(this.clientCollectionName, clients);
   }

   /**
	FC8 : Cette fonction permet de rechercher un client dans une collection
	connaissant son id.
   */
   public void getClientById(String nomCollection, Integer ClientId){
		//Drop a collection 
		System.out.println("\n\n\n*********** dans getClientById *****************");   

		MongoCollection<Document> colClients=database.getCollection(nomCollection);

		//BasicDBObject whereQuery = new BasicDBObject();
		Document whereQuery = new Document();

		whereQuery.put("_id", ClientId );
		//DBCursor cursor = colClients.find(whereQuery);
		FindIterable<Document> listClient=colClients.find(whereQuery);

		// Getting the iterator 
		Iterator it = listClient.iterator();
		while(it.hasNext()) {
				System.out.println(it.next());
		}		
   } 
   
   
    /**
	FC9 : Cette fonction permet de rechercher des clients dans une collection.
	Le parametre whereQuery : permet de passer des conditions de rechercher
	Le parametre projectionFields : permet d'indiquer les champs a afficher
	Le parametre sortFields : permet d'indiquer les champs de tri.
   */   
   public void getClients(String nomCollection, 
	Document whereQuery, 
	Document projectionFields,
	Document sortFields){
		//Drop a collection 
		System.out.println("\n\n\n*********** dans getClients *****************");   

		MongoCollection<Document> colClients=null;
		System.out.println("Dans getClients 2.1 *****************"+colClients);   
		System.out.println("Dans getClients 2.2 : database:"+database);

		colClients=database.getCollection(nomCollection);
		System.out.println("Dans getClients 2.1 *****************"+colClients);   

		FindIterable<Document> listClient=colClients.find(whereQuery).sort(sortFields).projection(projectionFields);
		//System.out.println("colClients.count():"+colClients.count());
		// Getting the iterator 
		Iterator it = listClient.iterator();
		System.out.println("Dans getClients 2.1 *****************");   

		while(it.hasNext()) {
				System.out.println("Dans getClients 2.3 *****************");   

				System.out.println(it.next());
		}		
   } 


    /**
	FC10 : Cette fonction permet de modifier des clients dans une collection.
	Le parametre whereQuery : permet de passer des conditions de recherche
	Le parametre updateExpressions : permet d'indiquer les champs a modifier
	Le parametre UpdateOptions : permet d'indiquer les options de mise a jour :
		.upSert : insere si le document n'existe pas
   */
   public void updateClients(String nomCollection, 
	Document whereQuery, 
	Document updateExpressions,
	UpdateOptions updateOptions
	){
		//Drop a collection 
		System.out.println("\n\n\n*********** dans updateClients *****************");   

		// A completer 

   }


   /**
	FC11 : Cette fonction permet de supprimer des clients dans une collection.
	Le parametre filters : permet de passer des conditions de recherche des employes a supprimer
   */	    
   public void deleteClients(String nomCollection, Document filters){
		
		System.out.println("\n\n\n*********** dans deleteClients *****************");   
		// A completer 

   } 	
   
   /**
	FC12 : Parcours un iterateur et affiche les documents qui s'y trouvent
   */
   public void displayIterator(Iterator it, String message){
	System.out.println(" \n #### "+ message + " ################################");
	while(it.hasNext()) {
		System.out.println(it.next());
	}		
   }
   

   
   /**FC13 : 
   .6.4 Afficher les informations sur 1 client ainsi que ses appreciations
	sur les vols
	Trouver les bons parametres.
   */
   public void joinLocalAndforeignCollections(
	String localCollectionName, 
	String foreignCollectionName, 
	String localColJoinFieldName,
	String foreigColJoinFieldName,
	Document whereQuery
	){

		System.out.println("\n\n\n*********** dans joinTwoCollections *****************");   
		// A completer 

		
	}

   /**FC14 : 
   charger plusieurs documents (clients) JSON depuis un fichier vers une collection mongoDB
   Utilisez le fichier 2Json_collection_Import_Clients_Airbase.json vu dans le cours
   	Trouver les bons parametres.
   */ 
 
   	public void loadClientsFromJsonArrayFile (
	String collectionName,
	String filePath,
	String fileName){
		System.out.println(" \n ####  DANS loadClientsFromJsonArrayFile ################################");
		// A completer 

	}
	
 
    /** FC15 : 
   charger des clients contenu dans un fichier CSV vers une collection mongoDB
   Construisez un fichier CSV a partir du fichier json 2Json_collection_Import_Clients_Airbase
   	Trouver les bons parametres.
   
   */    
   
	public void loadClientsFromCSVFile(
	String collectionName,
	String filePath,
	String fileName	
	){
		System.out.println(" \n ####  DANS loadClientsFromCSVFile ################################");
 		// A completer 

   }  




 /**FC16 : 
   charger plusieurs documents (clients) JSON depuis un fichier vers une collection mongoDB
   Utilisez le fichier 2Json_collection_Import_Clients_Airbase.json vu dans le cours.
   Invoquer l'utilitaire MongoImport.
   */ 
 
    public void loadClientsFromJsonArrayFileWithMongoImport(
	String dbName, 
	boolean isJsonArray, 
	String collectionName,
	String filePath,
	String fileName
	){
		System.out.println(" \n ####  DANS loadClientsFromJsonArrayFileWithMongoImport ################################");

		// A completer 

   } 
  
   /** FC17 : 
   charger des clients contenu dans un fichier CSV vers une collection mongoDB
   Construisez un fichier CSV a partir du fichier json 2Json_collection_Import_Clients_Airbase
   	Trouver les bons parametres. Invoquer l'utilitaire MongoImport.
   
   */    
   
	public void loadClientsFromCSVFileWithMongoImport(
	String dbName, 
	boolean isCsvFile, 
	String collectionName,
	String filePath,
	String fileName	
	){
		System.out.println(" \n ####  DANS loadClientsFromCSVFileWithMongoImport ################################");
		// A completer 

   }  
   
    /** FC18 : 
   Ajouter des appreciations pour un client donne et un vol donne.
   	Trouver les bons parametres.
   
   */  
	public void ajouterUneAppreciationAUnVol(){
		// A completer 
		
	}

 /**FC19 : 
   Exporter plusieurs documents (clients) JSON d'une collection mongoDB vers un fichier vers un fichier CSV.
   Invoquer l'utilitaire MongoExport.
   */ 
 //  String command = "mongoexport --host Host --port Port --db " + db + " //--collection " + col + " --csv --out " + fileName + "";

    public void exportClientsToJsonCsvFileWithMongoExport(
	String dbName, 
	boolean isJsonArray, 
	String collectionName,
	String filePath,
	String destFileName
	){
		System.out.println(" \n ####  DANS exportClientsToJsonCsvFileWithMongoExport ################################");
		// A completer 

   } 
  

	
}

