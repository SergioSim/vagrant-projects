
/**
Le package TPJAVA contient deux autres classes. La classe Vol et la classe Client
Chacune de ces classes est dans son propre fichier.
La classe Vol contient les methodes suivantes :



public void insertOneVol(String nomCollection, Document vol);
public void testInsertOneVol();
public void insertManyVols(String nomCollection, List<Document> vols);
public void testInsertManyVols();
public void getVolById(String nomCollection, Integer volId);


Chaque methode est decrite lors de sa declaration dans la classe.

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
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Indexes;
import com.mongodb.client.model.IndexOptions;

public class Vol { 
   private MongoDatabase database;
   private String dbName="airbaseDB";
   private String hostName="localhost";
   private int port=27017;
   private String userName="uairbase";
   private String passWord="UairbasePass";
   private String volCollectionName="colVols";

   /**
   Le  
	
   */
   public static void main( String args[] ) {  
    try{
		Vol vol= new Vol();
		vol.dropCollectionVol(vol.volCollectionName);
		vol.createCollectionVol(vol.volCollectionName);
		vol.deleteVols(vol.volCollectionName, new Document());
		vol.testInsertOneVol();
		vol.testInsertManyVols();
		vol.getVolById(vol.volCollectionName, "121");

		vol.getVols(vol.volCollectionName, 
			new Document(), 
			new Document(),
			new Document()
		);
	}catch(Exception e){
		e.printStackTrace();
	}	
   } 
   
   /**
	FV1 : Constructeur Vol.
	Dans ce constructeur sont effectuees les activites suivantes:
	- Creation d'une instance du client MongoClient
	- Creation d'une BD Mongo appele RH
	- Creation d'un utilisateur appele 
	- Chargement du pointeur vers la base RH
   */
   
   Vol(){
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
	FV2 : Cette fonction permet de creer une collection
	de nom nomCollection.
   */
   public void createCollectionVol(String nomCollection){
		//Creating a collection 
		database.createCollection(nomCollection); 
		System.out.println("Collection Vols created successfully"); 

   }
   
   
   /**
	FV3 : Cette fonction permet de supprimer une collection
	de nom nomCollection.
   */
   
   public void dropCollectionVol(String nomCollection){
		//Drop a collection 
		MongoCollection<Document> colVols=null; 
		System.out.println("!!!! Collection Vol : "+colVols);

		colVols=database.getCollection(nomCollection);
		System.out.println("!!!! Collection Vol : "+colVols);
		// Visiblement jamais !!!
		if (colVols==null)
			System.out.println("Collection inexistante");
		else {
			colVols.drop();	
			System.out.println("Collection colVols removed successfully !!!"); 
	  
		}
   }

   /**
	FV4 : Cette fonction permet d'inserer un vol dans une collection.
   */
   
   public void insertOneVol(String nomCollection, Document vol){
		//Drop a collection 
		MongoCollection<Document> colVols=database.getCollection(nomCollection);
		colVols.insertOne(vol); 
		System.out.println("Document inserted successfully");     
   }

   /**
	FV5 : Cette fonction permet de tester la methode insertOneVol.
   */

   public void testInsertOneVol(){
		Document vol =  new Document("_id", "121")
      .append("villeDepart","Paris")
      .append("villeArrivee", "Nantes")
      .append("heureDepart", "13:15")
      .append("heureArrivee", "14:45")
      .append("dateVol", "14/12/2019")
      .append("appreciations", 
         Arrays.asList(
			new Document("idClient", "07")
            .append("notes", Arrays.asList(
				   new Document("apid", "071")
					  .append("critereANoter", "SiteWeb")
					  .append("note", "BIEN"),
					  
					new Document("apid", "072")
					  .append("critereANoter", "Prix")
					  .append("note", "BIEN"),

					new Document("apid", "073")
					  .append("critereANoter", "Nourritureabord")
					  .append("note", "BIEN"),
				 
					new Document("apid", "074")
					  .append("critereANoter", "Qualitesiege")
					  .append("note", "BIEN"),

					new Document("apid", "075")
					  .append("critereANoter", "Accueilguichet")
					  .append("note", "BIEN"),
					  
					new Document("apid", "076")
					  .append("critereANoter", "Accueilabord")
					  .append("note", "EXCELLENT")
					)
				)
			)
		);
      
		this.insertOneVol(this.volCollectionName, vol);
		System.out.println("Document inserted successfully");     
   }

   /**
	FV6 : Cette fonction permet d'inserer plusieurs Vols dans une collection
   */

   public void insertManyVols(String nomCollection, List<Document> vols){
		//Drop a collection 
		MongoCollection<Document> colVols=database.getCollection(nomCollection);
		colVols.insertMany(vols); 
		System.out.println("Many Documents inserted successfully");     
   }

   /**
	FV7 : Cette fonction permet de tester la fonction insertManyVols
   */

   public void testInsertManyVols(){
		List<Document> vols = 
		
		Arrays.asList(
   new Document("_id","100")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","10,15")
      .append("heureArrivee","11,45")
      .append("dateVol","12/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",  Arrays.asList(
               new Document("apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document("apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"),
				  
               new Document("apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document("apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document("apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","101")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","10,15")
      .append("heureArrivee","11,45")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document("apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document("apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document("apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","MEDIOCRE"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document("apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","102")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","13,15")
      .append("heureArrivee","14,45")
      .append("dateVol","14/12/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","PASSABLE"
               )
            )
         ),
         new Document("idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","103")
      .append("villeDepart","Nice")
      .append("villeArrivee","Lyon")
      .append("heureDepart","16,15")
      .append("heureArrivee","17,45")
      .append("dateVol","11/06/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","MOYEN"
               )
            )
         )
      )
   ),
   new Document("_id","104")
      .append("villeDepart","Lyon")
      .append("villeArrivee","Toulouse")
      .append("heureDepart","09,15")
      .append("heureArrivee","10,45")
      .append("dateVol","16/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",7)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",71)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",72)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",73)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",74)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",75)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",76)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","105")
      .append("villeDepart","Toulouse")
      .append("villeArrivee","Paris")
      .append("heureDepart","14,20")
      .append("heureArrivee","15,55")
      .append("dateVol","16/08/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","MEDIOCRE"
               )
            )
         ),
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","106")
      .append("villeDepart","Paris")
      .append("villeArrivee","Haiti")
      .append("heureDepart","09,15")
      .append("heureArrivee","17,45")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","107")
      .append("villeDepart","Bordeaux")
      .append("villeArrivee","Paris")
      .append("heureDepart","11,00")
      .append("heureArrivee","11,55")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","108")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","16,15")
      .append("heureArrivee","17,45")
      .append("dateVol","14/12/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","109")
      .append("villeDepart","Nice")
      .append("villeArrivee","Lyon")
      .append("heureDepart","17,15")
      .append("heureArrivee","18,45")
      .append("dateVol","11/05/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","110")
      .append("villeDepart","Lyon")
      .append("villeArrivee","Toulouse")
      .append("heureDepart","08,05")
      .append("heureArrivee","09,55")
      .append("dateVol","16/05/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","111")
      .append("villeDepart","Toulouse")
      .append("villeArrivee","Paris")
      .append("heureDepart","14,20")
      .append("heureArrivee","15,55")
      .append("dateVol","16/05/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",9)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",91)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",92)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",93)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",94)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",95)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",96)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","112")
      .append("villeDepart","Beauvais")
      .append("villeArrivee","Marseille")
      .append("heureDepart","10,15")
      .append("heureArrivee","11,45")
      .append("dateVol","12/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","PASSABLE"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","113")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","10,15")
      .append("heureArrivee","11,45")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","114")
      .append("villeDepart","Nice")
      .append("villeArrivee","Paris")
      .append("heureDepart","13,15")
      .append("heureArrivee","14,45")
      .append("dateVol","14/12/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","115")
      .append("villeDepart","Nice")
      .append("villeArrivee","Lyon")
      .append("heureDepart","20,05")
      .append("heureArrivee","20,57")
      .append("dateVol","11/05/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",22)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","116")
      .append("villeDepart","Lyon")
      .append("villeArrivee","Toulouse")
      .append("heureDepart","12,15")
      .append("heureArrivee","13,15")
      .append("dateVol","16/05/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document(
            "idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document(
            "idClient",7)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",71)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",72)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",73)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",74)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",75)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",76)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","117")
      .append("villeDepart","Toulouse")
      .append("villeArrivee","Paris")
      .append("heureDepart","14,20")
      .append("heureArrivee","15,55")
      .append("dateVol","16/05/2018")
      .append("appreciations",Arrays.asList(
         new Document(
            "idClient",6)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document(
            "idClient",5)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",52)
                  .append("critereANoter","Prix")
                  .append("note","PASSABLE"
               ),
               new Document(
                  "apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document(
            "idClient",10)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",101)
                  .append("critereANoter","SiteWeb")
                  .append("note","EXCELLENT"
               ),
               new Document(
                  "apid",102)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",103)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",104)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",105)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",106)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document(
            "idClient",8)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",81)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",82)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",83)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",84)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",85)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",86)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document(
            "idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document(
            "idClient",3)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document(
                  "apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document(
            "idClient",4)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document(
                  "apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document(
                  "apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","118")
      .append("villeDepart","Paris")
      .append("villeArrivee","Haiti")
      .append("heureDepart","08,30")
      .append("heureArrivee","17,21")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document(
            "idClient",1)
            .append("notes",Arrays.asList(
               new Document(
                  "apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document("apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",2)
            .append("notes",Arrays.asList(
               new Document("apid",21)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",22)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",23)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",24)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document("apid",25)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",26)
                  .append("critereANoter","Accueilabord")
                  .append("note","MEDIOCRE"
               )
            )
         )
      )
   ),
   new Document("_id","119")
      .append("villeDepart","Paris")
      .append("villeArrivee","Ney-York")
      .append("heureDepart","10,15")
      .append("heureArrivee","16,45")
      .append("dateVol","05/11/2018")
      .append("appreciations",Arrays.asList(
         new Document("idClient",1)
            .append("notes",Arrays.asList(
               new Document("apid",11)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document("apid",12)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",13)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",14)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document("apid",15)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",16)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         ),
         new Document("idClient",3)
            .append("notes",Arrays.asList(
               new Document("apid",31)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",32)
                  .append("critereANoter","Prix")
                  .append("note","MEDIOCRE"
               ),
               new Document("apid",33)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",34)
                  .append("critereANoter","Qualitesiege")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",35)
                  .append("critereANoter","Accueilguichet")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",36)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         ),
         new Document("idClient",4)
            .append("notes",Arrays.asList(
               new Document("apid",41)
                  .append("critereANoter","SiteWeb")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",42)
                  .append("critereANoter","Prix")
                  .append("note","MOYEN"
               ),
               new Document("apid",43)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",44)
                  .append("critereANoter","Qualitesiege")
                  .append("note","TRES_BIEN"
               ),
               new Document("apid",45)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document("apid",46)
                  .append("critereANoter","Accueilabord")
                  .append("note","BIEN"
               )
            )
         )
      )
   ),
   new Document("_id","120")
      .append("villeDepart","Paris")
      .append("villeArrivee","Nantes")
      .append("heureDepart","13,15")
      .append("heureArrivee","14,45")
      .append("dateVol","14/12/2018")
      .append("appreciations",Arrays.asList(
			new Document("idClient",7)
            .append("notes",Arrays.asList(
               new Document("apid",61)
                  .append("critereANoter","SiteWeb")
                  .append("note","BIEN"
               ),
               new Document("apid",62)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",63)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",64)
                  .append("critereANoter","Qualitesiege")
                  .append("note","BIEN"
               ),
               new Document("apid",65)
                  .append("critereANoter","Accueilguichet")
                  .append("note","BIEN"
               ),
               new Document("apid",66)
                  .append("critereANoter","Accueilabord")
                  .append("note","EXCELLENT"
               )
            )
         ),
         new Document("idClient",8)
            .append("notes",Arrays.asList(
               new Document("apid",51)
                  .append("critereANoter","SiteWeb")
                  .append("note","PASSABLE"
               ),
               new Document("apid",52)
                  .append("critereANoter","Prix")
                  .append("note","BIEN"
               ),
               new Document("apid",53)
                  .append("critereANoter","Nourritureabord")
                  .append("note","BIEN"
               ),
               new Document("apid",54)
                  .append("critereANoter","Qualitesiege")
                  .append("note","MOYEN"
               ),
               new Document(
                  "apid",55)
                  .append("critereANoter","Accueilguichet")
                  .append("note","MOYEN"
               ),
               new Document("apid",56)
                  .append("critereANoter","Accueilabord")
                  .append("note","TRES_BIEN"
               )
            )
         )
      )
   )
   );

		this.insertManyVols(this.volCollectionName, vols);
   }

   /**
	FV6 : Cette fonction permet de rechercher un vol dans une collection
	connaissant son id.
   */

   public void getVolById(String nomCollection, String volId){
		//Drop a collection 
		System.out.println("\n\n\n*********** dans getVolById *****************");   

		MongoCollection<Document> colVols=database.getCollection(nomCollection);

		//BasicDBObject whereQuery = new BasicDBObject();
		Document whereQuery = new Document();

		whereQuery.put("_id", volId );
		//DBCursor cursor = colVols.find(whereQuery);
		FindIterable<Document> listVol=colVols.find(whereQuery);

		// Getting the iterator 
		Iterator it = listVol.iterator();
		while(it.hasNext()) {
				System.out.println(it.next());
		}		
   } 

    /**
	FV7 : Cette fonction permet de supprimer des vols dans une collection.
	Le parametre filters : permet de passer des conditions de recherche des vols a supprimer
   */
   public void deleteVols(String nomCollection, Document filters){
		
		System.out.println("\n\n\n*********** dans deleteVols *****************");   
		FindIterable<Document> listVol;
		Iterator it;
		MongoCollection<Document> colVols=database.getCollection(nomCollection);
		
		listVol=colVols.find(filters).sort(new Document("_id", 1));
		it = listVol.iterator();// Getting the iterator
		this.displayIterator(it, "Dans deleteVols: avant suppression");

		colVols.deleteMany(filters);
		listVol=colVols.find(filters).sort(new Document("_id", 1));
		it = listVol.iterator();// Getting the iterator
		this.displayIterator(it, "Dans deleteVols: Apres suppression");
   } 	

   /**
	FV8 : Parcours un iterateur et affiche les documents qui s'y trouvent
   */
   public void displayIterator(Iterator it, String message){
		System.out.println(" \n #### "+ message + " ################################");
		while(it.hasNext()) {
			System.out.println(it.next());
				
		}
   }
   
    /**
	FD9 : Cette fonction permet de rechercher des employes dans une collection.
	Le parametre whereQuery : permet de passer des conditions de rechercher
	Le parametre projectionFields : permet d'indiquer les champs a afficher
	Le parametre sortFields : permet d'indiquer les champs de tri.
   */   
   public void getVols(String nomCollection, 
	Document whereQuery, 
	Document projectionFields,
	Document sortFields){
		//Drop a collection 
		System.out.println("\n\n\n*********** dans getDepts *****************");   

		MongoCollection<Document> colDepts=database.getCollection(nomCollection);

		FindIterable<Document> listDept=colDepts.find(whereQuery).sort(sortFields).projection(projectionFields);

		// Getting the iterator 
		Iterator it = listDept.iterator();
		while(it.hasNext()) {
				System.out.println(it.next());
		}		
   } 


   
}
