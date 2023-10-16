package airbase;

import oracle.kv.KVStore;
import java.util.List;
import java.util.Iterator;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.FaultException;
import oracle.kv.StatementResult;
import oracle.kv.table.TableAPI;
import oracle.kv.table.Table;
import oracle.kv.table.Row;
import oracle.kv.table.PrimaryKey;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;
import java.lang.Integer;
import oracle.kv.table.TableIterator;
import oracle.kv.table.EnumValue;
import java.io.File;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import java.util.StringTokenizer;
import java.util.ArrayList;
import java.util.List;



/**
 * Cette classe fournit les fonctions nécessaires pour gérer les tables.
 * La fonction void executeDDL(String statement) reçoit en paramètre 
 * une commande ddl et l'applique dans la base nosql.
 * La displayResult affiche l'état de l'exécution de la commande
 * la fonction createTableCritere permet de créer une table critère>.
 */

 
 public class Airbase {
    private final KVStore store;
	private final String myTpPath="/vagrant/TpBigData";
//	private final String myTpPath="/home/myLinuxLogin/TpBigData";

	private final String tabCriteres="CRITERES";
	private final String tabClients="CLIENTS";
	private final String tabAppreciations="APPRECIATIONS";

//	private final String tabCriteres="CRITERES_myMaster_myLinuxLogin";
//	private final String tabClients="CLIENTS_myMaster_myLinuxLogin";
//	private final String tabAppreciations="APPRECIATIONS_myMaster_myLinuxLogin";

	
    /**
     * Runs the DDL command line program.
     */
    public static void main(String args[]) {
        try {
            	Airbase arb= new Airbase(args);
		//arb.initAirbaseTablesAndData(arb);

		arb.getAppreciationByKey(100, 1, 1, "03/03/1989");
		arb.getClientByKey(1);

		arb.getCritereByKey(1);


		arb.getCritereRows();
		arb.getAppreciationRows();
		arb.getClientRows();


        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }
    /**
     * Parses command line args and opens the KVStore.
     */
	Airbase(String[] argv) {

		String storeName = "kvstore";
		String hostName = "localhost";
		String hostPort = "5000";

		final int nArgs = argv.length;
		int argc = 0;
		store = KVStoreFactory.getStore
		    (new KVStoreConfig(storeName, hostName + ":" + hostPort));
	}

	
/**
* Affichage du résultat pour les commandes DDL (CREATE, ALTER, DROP)
*/

	private void displayResult(StatementResult result, String statement) {
		System.out.println("===========================");
		if (result.isSuccessful()) {
			System.out.println("Statement was successful:\n\t" +
			statement);
			System.out.println("Results:\n\t" + result.getInfo());
		} else if (result.isCancelled()) {
			System.out.println("Statement was cancelled:\n\t" +
			statement);
		} else {
			/*
			* statement was not successful: may be in error, or may still
			* be in progress.
			*/
			if (result.isDone()) {
				System.out.println("Statement failed:\n\t" + statement);
				System.out.println("Problem:\n\t" +
				result.getErrorMessage());
			}
			else {

				System.out.println("Statement in progress:\n\t" +
				statement);
				System.out.println("Status:\n\t" + result.getInfo());
			}
		}
	}
	
	/**
	* initAirbaseTablesAndData : cette méthode appelle plusieurs méthodes; Elle permet:
	- De supprimer les tables CLIENT, APPRECIATION et CRITERE si elles existent
	- De créer ou récréer les tables CLIENT, APPRECIATIONet CRITERE
	- D'insérer des lignes dans la table critere
	- De charger des apprécitions et des clients depuis des fichiers
	*/

	public void initAirbaseTablesAndData(Airbase arb) {
		arb.dropTableAppreciation();
		arb.dropTableCriteres() ;
		arb.dropTableClient();
		arb.createTableClient();
		arb.createTableCriteres();
		arb.createTableAppreciation();
		arb.insertCritresRows();
		arb.loadClientDataFromFile(myTpPath+"/tpnosql/airbase/clientData_txt.txt");
		arb.loadAppreciationDataFromFile(myTpPath+"/tpnosql/airbase/appreciationData_txt.txt");


	}

	/**
		Méthode de suppression de la table criteres.
	*/	
	public void dropTableCriteres() {
		String statement = null;
		
		statement ="drop table "+tabCriteres;
		executeDDL(statement);
	}

	/**
		Méthode de suppression de la table clients.
	*/	
	public void dropTableClient() {
		String statement = null;
		
		statement ="drop table "+tabClients;
		executeDDL(statement);
	}

	/**
		Méthode de suppression de la table Appreciation.
	*/
	public void dropTableAppreciation() {
		String statement = null;
		
		statement ="drop table "+tabAppreciations;
		executeDDL(statement);
	}

	/**
		Méthode de création de la table criteres.
	*/

	public void createTableCriteres() {
		String statement = null;
		statement="Create table "+ tabCriteres+" ("
		+ "CRITEREID INTEGER," 
		+ "TITRE STRING,"
		+ "DESCRIPTION STRING,"
		+ "PRIMARY KEY (CRITEREID))";
		executeDDL(statement);

	}

	/**
		Méthode de création de la table client.
	*/

	public void createTableClient() {
		String statement = null;
		statement="create table "+tabClients+" ("
		+"ClIENTID INTEGER,"
		+"NOM STRING,"
		+"PRENOM STRING,"
		+"CODEPOSTAL STRING,"
		+"VILLE STRING,"
		+"ADRESSE  STRING,"
		+"TELEPHONE STRING,"
		+"ANNEENAISS STRING,"
		+"PRIMARY KEY(ClIENTID))";
		executeDDL(statement);
		
	}

	/**
		Méthode de création de la table Appreciation.
	*/
	public void createTableAppreciation() {
		String statement = null;
		statement ="create table " + tabAppreciations+ "  ("+
		"VOLID    INTEGER,"+  
		"CRITEREID  INTEGER,"+
		"CLIENTID  INTEGER,"+
		"DATEVOL  STRING,"+
		"NOTE  ENUM (EXCELLENT, TRES_BIEN, BIEN, MOYEN, PASSABLE, MEDIOCRE),"+
		"PRIMARY KEY (VOLID,CRITEREID, CLIENTID, DATEVOL ))";
		executeDDL(statement);
		
	}

	/**
	* insertCritresRows : Insère de nouvelles lignes dans la table pilote en appelant la fonction insertACritereRow
	*/
 
	public void insertCritresRows() {
		System.out.println("********************************** Dans : insertCriteresRows *********************************" );

		try {
			this.insertACritereRow(1, "La qualité du site reservation", "Ce critère permet d'apprécier la qualité du site de reservation");
			this.insertACritereRow(2, "Le prix", "Ce critère permet d'apprécier le prix");
			this.insertACritereRow(3, "La nourriture à bord", "Ce critère permet d'apprécier la nourriture à bord");
			this.insertACritereRow(4, "La qualité du siege", "Ce critère permet d'apprécier la qualité du siege");
			this.insertACritereRow(5, "L’accueil au guichet", "Ce critère permet d'apprécier l’accueil au guichet");
			this.insertACritereRow(6, "L’accueil à bord", "Ce critère permet d'apprécier l’accueil à bord");

		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}
	}


	/**
		Méthode générique pour executer les commandes DDL
	*/
	public void executeDDL(String statement) {
		TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		
		System.out.println("****** Dans : executeDDL ********" );
		try {
		/*
		* Add a table to the database.
		* Execute this statement asynchronously.
		*/
		
		result = store.executeSync(statement);
		displayResult(result, statement);
		} catch (IllegalArgumentException e) {
		System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
		System.out.println("Statement couldn't be executed, please retry: " + e);
		}
	}

	/**	
		Cette méthode insère une nouvelle ligne dans la table CRITERES
	*/

	private void insertACritereRow(int critereid, String titre, String description){
		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("********************************** Dans : insertACritereRow *********************************" );

		try {

			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableCriteres = tableH.getTable(tabCriteres);
			// Get a Row instance
			Row critereRow = tableCriteres.createRow();
			// Now put all of the cells in the row.
			// This does NOT actually write the data to
			// the store.


			// Create one row
			critereRow.put("critereId", critereid);
			critereRow.put("titre", titre);
			critereRow.put("description", description);

			// Now write the table to the store.
			// "item" is the row's primary key. If we had not set that value,
			// this operation will throw an IllegalArgumentException.
			tableH.put(critereRow, null, null);

		} 
		catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} 
		catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

	/**
		private void insertAClientRow(int clientid, String nom, String prenom, String codePostal, String ville, 
			String adresse, String telephone, String anneeNaiss)
		Cette méthode insère une nouvelle ligne dans la table CLIENT
	*/

	private void insertAClientRow(int clientid, String nom, String prenom, String codePostal, String ville, 
			String adresse, String telephone, String anneeNaiss){
		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("********************************** Dans : insertAClientRow *********************************" );

		try {

			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableClient = tableH.getTable(tabClients);
			
			// Get a Row instance
			Row clientRow = tableClient.createRow();
			// Now put all of the cells in the row.
			// This does NOT actually write the data to
			// the store.

			// Create one row
			clientRow.put("clientid", clientid);
			clientRow.put("nom", nom);
			clientRow.put("prenom", prenom);
			clientRow.put("codePostal", codePostal);
			clientRow.put("ville", ville);
			clientRow.put("adresse", adresse);
			clientRow.put("telephone", telephone);
			clientRow.put("anneeNaiss", anneeNaiss);

			// Now write the table to the store.
			// "item" is the row's primary key. If we had not set that value,
			// this operation will throw an 
			// IllegalArgumentException.
	 
	
			// A compléter !!!

		} 
		catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} 
		catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

	/**
		private void insertAppreciationRow(int volid, int critereid, int clientid, String dateVol,   String note)
		Cette méthode insère une nouvelle ligne dans la table APPRECIATION
	*/

	private void insertAppreciationRow(int volid, int critereid, int clientid, String dateVol,   String note){
		System.out.println("********************************** Dans : insertAppreciationRow *********************************" );

		TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("********************************** Dans : insertAClientRow *********************************" );

		// A compléter
		
	}

	/**
		void loadClientDataFromFile(String clientDataFileName)
		cette methodes permet de charger les clients depuis le fichier 
		appelé clientData_txt.txt. 
		Pour chaque client chargé, la
		méthide insertAClientRow sera appélée
	*/
	void loadClientDataFromFile(String clientDataFileName){
		InputStreamReader 	ipsr;
		BufferedReader 		br=null;
		InputStream 		ips;
		
		// Variables pour stocker les données lues d'un fichier. 
		String 		ligne; 
		System.out.println("********************************** Dans : loadClientDataFromFile *********************************" );
		
		/* parcourir les lignes du fichier texte et découper chaque ligne */
		try {
			ips  = new FileInputStream(clientDataFileName); 
			ipsr = new InputStreamReader(ips); 
			br   = new BufferedReader(ipsr); 
  
			/* open text file to read data */

			//parcourir le fichier ligne par ligne et découper chaque ligne en 
			//morceau séparés par le symbole ;  
			while ((ligne = br.readLine()) != null) { 
				//int clientid; 
				//String nom, prenom, codePostal, ville, adresse, telephone, anneeNaiss;

				ArrayList<String> clientRecord= new ArrayList<String>();	
				StringTokenizer val = new StringTokenizer(ligne,";");
				while(val.hasMoreTokens()) { 
						clientRecord.add(val.nextToken().toString()); 
				}
				int clientid		= Integer.parseInt(clientRecord.get(0));
				String nom		= clientRecord.get(1);
				String prenom		= clientRecord.get(2);
				String codePostal	= clientRecord.get(3);
				String ville		= clientRecord.get(4);
				String adresse		= clientRecord.get(5);
				String telephone	= clientRecord.get(6);
				String anneeNaiss	= clientRecord.get(7);
				System.out.println("clientid="+clientid+" nom="+nom+" prenom="+prenom
				+" codePostal="+codePostal+" ville="+ville+" adresse="+adresse
				+" telephone="+telephone+" anneeNaiss="+anneeNaiss);
				// Add the client in the KVStore
				this.insertAClientRow(clientid, nom, prenom, codePostal, ville, adresse, telephone, anneeNaiss);
			}
		}
		catch(Exception e){
			e.printStackTrace(); 
		}
	}



	/**
		void loadAppreciationDataFromFile(String clientDataFileName)
		cette methodes permet de charger les appréciationss depuis 
		le fichier appelé appreciationData_txt.txt. Pour chaque client
		chargé, la méthide insertAppreciationRow sera appélée
	*/

	void loadAppreciationDataFromFile(String clientDataFileName){
		InputStreamReader 	ipsr;
		BufferedReader 		br=null;
		InputStream 		ips;
			
		// à compléter

	}

	/**
		private void displayCritereRow (Row critereRow)
		Cette méthode d'afficher une ligne de la table critere.
	*/
	private void displayCritereRow (Row critereRow) {
   		System.out.println("============= DANS : displayCritereRow ==============");
		Integer critereId = 	critereRow.get("CRITEREID").asInteger().get();
		String titre = critereRow.get("TITRE").asString().get();
		String description = critereRow.get("DESCRIPTION").asString().get();

		System.out.println(" Critere row :{ critereId=" + critereId + 
		" TITRE="+titre +" description="+description+"}");

	}

	/**
		private void displayClientRow (Row clientRow)
		Cette méthode d'afficher une ligne de la table client.
	*/
	private void displayClientRow (Row clientRow) {
   		System.out.println("========== DANS : displayClientRow =================");
		// A compléter

	}
	
	/**
		private void displayAppreciationRow (Row a^^reciationRow)
		Cette méthode d'afficher une ligne de la table client.
	*/	
	private void displayAppreciationRow (Row appreciationRow) {
  		System.out.println("========== DANS : displayAppreciationRow =================");
		// A compléter
	
	}


	/**
		private void getCritereByKey (int critereId)
		Cette méthode de charger  une ligne de la table critere
		connaissant sa clé
	*/
	public void getCritereByKey(int critereId){

		StatementResult result = null;
		String statement = null;
		System.out.println("\n\n********************************** Dans : getCritereByKey *********************************" );

		try { 
			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableCritere = tableH.getTable(tabCriteres);

			PrimaryKey key=tableCritere.createPrimaryKey();
			key.put("critereId", critereId);
			// Retrieve the row. This performs a store read operation.
			// Exception handling is skipped for this trivial example.
			Row row = tableH.get(key, null);
			// Now retrieve the individual fields from the row.
			displayCritereRow(row);
		} catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}

	}

	/**
		private void getClientByKey (int clientId)
		Cette méthode de charger  une ligne de la table client
		connaissant sa clé
	*/
	public void getClientByKey(int clientId){

		StatementResult result = null;
		String statement = null;
		System.out.println("\n\n********************************** Dans : getClientByKey *********************************" );

		// A compléter

	}

	/**
		private void getAppreciationByKey (int volId, int critereId, int clientid, String dateVol)
		Cette méthode de charger  une ligne de la table appreciation
		connaissant sa clé
	*/
	
	public void getAppreciationByKey(int volId, int critereId, int clientid, String dateVol){

		StatementResult result = null;
		String statement = null;
		System.out.println("\n\n********************************** Dans : getAppreciationByKey *********************************" );

		// A compléter
	}



	/**
		public void getCritereRows()
		Cette méthode permet de charger  toutes les lignes de la table critere
		connaissant sa clé
	*/
	public void getCritereRows(){


		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("******************************** LISTING DES CRITERES ******************************************* ");

		try {
			TableAPI tableH = store.getTableAPI();
			// The name you give to getTable() must be identical
			// to the name that you gave the table when you created
			// the table using the CREATE TABLE DDL statement.
			Table tableCritere = tableH.getTable(tabCriteres);
			
			PrimaryKey key = tableCritere.createPrimaryKey();
			//key.put("critereId", 1);
			//key.put("adr", adr);

			// Exception handling is omitted, but in production code
			// ConsistencyException, RequestTimeException, and FaultException
			// would have to be handle
			TableIterator<Row> iter = tableH.tableIterator(key, null, null);
			try {
				while (iter.hasNext()) {
					Row critereRow = iter.next();
					displayCritereRow(critereRow);
				}
			} finally {
				if (iter != null) {
				iter.close();
			}
			}
		} 
		catch (IllegalArgumentException e) {
			System.out.println("Invalid statement:\n" + e.getMessage());
		} 
		catch (FaultException e) {
			System.out.println("Statement couldn't be executed, please retry: " + e);
		}


	}

	/**
		public void getClientRows()
		Cette méthode permet de charger  toutes les lignes de la table client
		connaissant sa clé
	*/
	public void getClientRows(){

		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("******************************** LISTING DES CLIENTS ******************************************* ");

		// A compléter


	}

	/**
		public void getAppreciationRows()
		Cette méthode permet de charger  toutes les lignes de la table appreciation
		connaissant sa clé
	*/
	public void getAppreciationRows(){

		//TableAPI tableAPI = store.getTableAPI();
		StatementResult result = null;
		String statement = null;
		System.out.println("******************************** LISTING DES APPRECIATIONS ******************************************* ");

		// A compléter

	}


 }