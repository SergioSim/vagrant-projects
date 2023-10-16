/*-
 *
 *  This file is part of Oracle NoSQL Database
 *  Copyright (C) 2011, 2013 Oracle and/or its affiliates.  All rights reserved.
 *
 *  Oracle NoSQL Database is free software: you can redistribute it and/or
 *  modify it under the terms of the GNU Affero General Public License
 *  as published by the Free Software Foundation, version 3.
 *
 *  Oracle NoSQL Database is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public
 *  License in the LICENSE file along with Oracle NoSQL Database.  If not,
 *  see <http://www.gnu.org/licenses/>.
 *
 *  An active Oracle commercial licensing agreement for this product
 *  supercedes this license.
 *
 *  For more information please contact:
 *
 *  Vice President Legal, Development
 *  Oracle America, Inc.
 *  5OP-10
 *  500 Oracle Parkway
 *  Redwood Shores, CA 94065
 *
 *  or
 *
 *  berkeleydb-info_us@oracle.com
 *
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  [This line intentionally left blank.]
 *  EOF
 *
 */

package pkMobileClients;

import java.util.ArrayList;
import java.util.List;

import oracle.kv.KVStore;
import oracle.kv.KVStoreConfig;
import oracle.kv.KVStoreFactory;
import oracle.kv.Key;
import oracle.kv.Value;
import oracle.kv.ValueVersion;
import oracle.kv.KeyValueVersion;
//import schema.KeyDefinition;
import oracle.kv.Direction;

//pour MultiGet
import java.util.Iterator;
import java.util.SortedMap;
import java.util.Map;
import oracle.kv.ConsistencyException;
import oracle.kv.RequestTimeoutException;

/**
 * An extremely simple KVStore client application that writes and reads a
 * single record.  It can be used to validate an installation.
 *
 * Before running this example program, start a KVStore instance.  The simplest
 * way to do that is to run KV Lite as described in the INSTALL document.  Use
 * the KVStore instance name, host and port for running this program, as
 * follows:
 *
 * <pre>
 * java schema.HelloBigDataWorld -store &lt;instance name&gt; \
 *                               -host  &lt;host name&gt;     \
 *                               -port  &lt;port number&gt;
 * </pre>
 *
 * For all examples the default instance name is kvstore, the default host name
 * is localhost and the default port number is 5000.  These defaults match the
 * defaults for running kvlite, so the simplest way to run the examples along
 * with kvlite is to omit all parameters.
 */
public class MobileClients {

    private final KVStore store;
	//private static final String loginAndMaster="oracle_sophia2021";
	//private static final String loginAndMaster="myLinuxLogin_myMaster";
    /**
     * Runs the HelloBigDataWorld command line program.
     */
    public static void main(String args[]) {
        try {
			MobileClients mobileCli = new MobileClients(args);
			mobileCli.runMobileClients();

			// mobileCli.deleteClient("Adam", "Judith", "judith.adam@gmail.com", "adresse");
			//mobileCli.getClient("Adam", "Judith", "judith.adam@gmail.com", "adresse");

			//mobileCli.mutliGetClient("Adam", "Judith", "judith.adam@gmail.com" );
			//mobileCli.clientMultiGetKeys("Adam", "Judith", "judith.adam@gmail.com");

			// mobileCli.printAllInfo();
			//mobileCli.printAllClientInfo("Adam", "Judith", "judith.adam@gmail.com");
			//mobileCli.clientMultiGetIterator("Adam", "Judith", "judith.adam@gmail.com");

			//mobileCli.clientMultiGetKeyIterator("Adam", "Judith", "judith.adam@gmail.com");

			//mobileCli.clientMultiGetKeys("Adam", "Judith", "judith.adam@gmail.com");

			mobileCli.closeStore();
			   
        } catch (RuntimeException e) {
		System.out.println("\n des soucis graves\n");
            	e.printStackTrace();
        }
    }

    /**
     * Parses command line args and opens the KVStore.
     */
    MobileClients(String[] argv) {

        String storeName = "kvstore";
        String hostName = "localhost";
        String hostPort = "5000";

        final int nArgs = argv.length;
        int argc = 0;

        store = KVStoreFactory.getStore
            (new KVStoreConfig(storeName, hostName + ":" + hostPort));
    }

    private void usage(String message) {
        System.out.println("\n" + message + "\n");
        System.out.println("usage: " + getClass().getName());
        System.out.println("\t-store <instance name> (default: kvstore) " +
                           "-host <host name> (default: localhost) " +
                           "-port <port number> (default: 5000)");
        System.exit(1);
    }

    /**
     * Performs example operations and closes the KVStore.
     */
    void runExamples() {

        final String keyString = "Hello";
        final String valueString = "Big Data World!";

        store.put(Key.createKey(keyString),
                  Value.createValue(valueString.getBytes()));

        final ValueVersion valueVersion = store.get(Key.createKey(keyString));

        System.out.println(keyString + " " +
                           new String(valueVersion.getValue().getValue()));

        //store.close();
    }

	/**
		void createClient(String lastName, String firstName, String email, 
		String minorComponent, String data)
		Cette méthode permet d’ajouter des clients dans la base nosql
		Travail attendu : Mettre les lignes de cette function dans le bon ordre. Compiler et tester. 
		Vérifier la presence des objets ajoutés dans l’interface CLI (kv->)
	*/
  void createClient(String lastName, String firstName, String email, 
		String minorComponent, String data) {
						   					   
		List<String> majorPath = new ArrayList<String>();

		majorPath.add(lastName); 
		majorPath.add(firstName);
		majorPath.add(email);

		// Mettre les lignes dans le bon sens

	 	store.put(myKey,myValue);

		final ValueVersion valueVersion = store.get(myKey);

		System.out.println(myKey + " " +
		                   new String(valueVersion.getValue().getValue()));
						   
		Value myValue = Value.createValue(data.getBytes());

		Key myKey = Key.createKey(majorPath, minorComponent);	
		
    }
   
   /**
		void runMobileClients()
		Cette méthode permet de créer quelques clients
	*/
    void runMobileClients() {
		System.out.println("\n\n*********** Dans runMobileClients *************\n");

		createClient("Smith", "Bob", "bob.Smith@gmail.com", "adresse", "12, rue du congrès, 06000 Nice");
		createClient("Smith", "Bob", "bob.Smith@gmail.com", "appelsReçus", "0611223367, 0021206732122");
		createClient("Adam", "Judith", "judith.adam@gmail.com", "adresse", "15, rue des sauges, 06560 Valbonne");
		createClient("Adam", "Judith", "judith.adam@gmail.com", "appelsEmis", "0611223367, 0021206732122, 2211111111");
		createClient("Adam", "Julian", "julian.adam@gmail.com", "etatCil", "Julian Adam Nee 15/11/1976 Denver");
		createClient("Adam", "Robert", "robert.adam@gmail.com", "CV", "Nee aux USA Son pere s'appelait Adam");
  
    }
	
	/**
		void deleteClient(String lastName, String firstName, String email, String minorComponent)
		Cette méthode permet de supprimer un  client connaissant sa clé.
		Travail attendu : Compléter et tester cette function
    */
	void deleteClient(String lastName, String firstName, String email, String minorComponent) {
		List<String> majorPath = new ArrayList<String>();
		System.out.println("\n\n*********** Dans deleteClient *************\n");

	// A compléter
  
    }
	
	/**
		void getClient(String lastName, String firstName, String email, String minorComponent)
		Cette méthode permet de Lire un  client connaissant sa clé.
		Travail attendu : Compléter et tester cette function
	*/
	void getClient(String lastName, String firstName, String email, String minorComponent) 
	{
		List<String> majorPath = new ArrayList<String>();
		System.out.println("\n\n*********** Dans getClient *************\n");
		
	// A compléter

    }

	/**
		void mutliGetClient(String lastName, String firstName, String email)
		Cette méthode permet d’itérer sur plusieurs clients ayant une même   
		major key. 
		Travail attendu : Généraliser la function en introduisant un parameter. Compléter et 
		tester cette function avec l’utilisation de la méthode multiGet du package KVStore
	*/
    void mutliGetClient(String lastName, String firstName, String email) {
		List<String> majorPath = new ArrayList<String>();
		System.out.println("\n\n*********** Dans multiGetClient *************\n");
		majorPath.add(lastName); 
		majorPath.add(firstName);
		majorPath.add(email);
		Key myKey = Key.createKey(majorPath); //, minorComponent);
		SortedMap<Key, ValueVersion> myRecords = null;
		myRecords = store.multiGet(myKey, null, null);

		// a compléter pour effectuer un parcours


	  
    }


	/**
		void printAllInfo()
		Cette méthode permet d’itérer sur l’ensemble des objets écrits 
		dans la base.
		Travail attendu : Tester cette function et décrire son effet
	*/
    void printAllInfo() {

        System.out.println("\n\n\n**************** printAllInfo *********************************");

		final Iterator<KeyValueVersion> iter = store.storeIterator(Direction.UNORDERED, 0);

		while (iter.hasNext()) {
			final KeyValueVersion keyValue = iter.next();
			System.out.println(keyValue.getKey()+ " " +  new String(keyValue.getValue().toByteArray())); //.getValue());
		}
    }

	/**
		void printAllClientInfo(String lastName, String firstName, String email)
		Cette méthode permet d’itérer sur l’ensemble des objets écrits 
		dans la base pour un client connaissant sa majorkey ou une partie
		de sa major key.
		Travail attendu : Compléter et tester cette function et décrire 
		son effet
	*/
	void printAllClientInfo(String lastName, String firstName, String email) {

        System.out.println("\n\n\n**************** printAllClientInfo *********************************");
		List<String> majorPath = new ArrayList<String>();
		majorPath.add(lastName); 
		majorPath.add(firstName);
		//majorPath.add(email);
		Key myKey = Key.createKey(majorPath); //, minorComponent);
	
		final Iterator<KeyValueVersion> iter = store.storeIterator(Direction.UNORDERED, 0,
		myKey, null, null);

		// a compléter pour effectuer un parcours


    }

	/**
		void clientMultiGetIterator(String lastName, String firstName, String email)
		Cette méthode permet d’itérer sur plusieurs clients ayant une même   
		major key. Quelle est la difference avec la méthode multiGet?
		Travail attendu : Généraliser la function en introduisant des paramètres. Compléter 
		et tester cette function avec l’utilisation de la méthode multiGetIterator du 
		package KVStore
	*/
	void clientMultiGetIterator(String lastName, String firstName, String email) {
	List<String> majorPath = new ArrayList<String>();

	
		majorPath.add(lastName); 
		majorPath.add(firstName);
		majorPath.add(email);
		
		Key myKey = Key.createKey(majorPath); //, minorComponent);

			System.out.println("\n\n\n**************** clientMultiGetIterator 1 *********************************");

		Iterator<KeyValueVersion> i = store.multiGetIterator(Direction.FORWARD, 0, myKey, null, null);

		// à compléter

    }

	/**
		void clientMultiGetKeyIterator(String lastName, String firstName, String email)
		Cette méthode permet d’itérer sur plusieurs clés de clients ayant une même   
		major key. Quelle est la difference avec la méthode multiGet?
		Travail attendu : Généraliser la function en introduisant des paramètres. Compléter 
		et tester cette function avec l’utilisation de la méthode multiGetKeyIterator du 
		package KVStore
	*/
	void clientMultiGetKeyIterator(String lastName, String firstName, String email){
		List<String> majorPath = new ArrayList<String>();
		majorPath.add(lastName); 
		majorPath.add(firstName);
		majorPath.add(email);
		
		Key myKey = Key.createKey(majorPath); //, minorComponent);

			System.out.println("\n\n\n**************** clientMultiGetKeyIterator *********************************");

		// à compléter

	}

	/**
		void clientMultiGetKeys()
		Cette méthode permet d’itérer sur plusieurs clés pointant vers des clients
		ayant une même  major key. 
		Travail attendu : Ecrire et tester cette function avec l’utilisation de la méthode 
		multiGetKey du package KVStore*
	*/
	void clientMultiGetKeys(String lastName, String firstName, String email){	
		//multiGetKeys(Key parentKey, KeyRange subRange, Depth depth)
		List<String> majorPath = new ArrayList<String>();

		// multiGetKeysIterator(Direction direction, int batchSize,
		//	Key parentKey, KeyRange subRange, Depth depth)
		// à généraliser
		majorPath.add(lastName); 
		majorPath.add(firstName);
		majorPath.add(email);
		
		Key myKey = Key.createKey(majorPath); //, minorComponent);

		System.out.println("\n\n\n**************** dans clientMultiGetKeys *********************************");
        
		// à compléter



	}
	
	/**
		void closeStore()
		Cette méthode permet de fermer le store
	*/
    void closeStore() {
        store.close();
  
    }

}
