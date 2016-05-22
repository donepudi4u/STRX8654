/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.mongodb.DB;
import com.mongodb.MongoClient;

/**
 *
 * @author sato
 */
public abstract class MongoConstants {
    
    public static final String LOGGER_NAME = "FMTView";
    //public static final String MONGO_SERVER = "mongo-dev";
    public static final String MONGO_SERVER = "mongo-dev";
    public static final int MONGO_PORT = 27017;
    
    // DB Collection names 
    public static final String MONGO_COLLECTION = "strdocs";
    


private static MongoClient client = null;

public static DB connectToMongo() throws Exception {
     //   String DBNAME;
    if (null != client) {
        return client.getDB("cimapps");
    }       
    client = new MongoClient(MONGO_SERVER,MONGO_PORT);                
    return client.getDB("cimapps");    
}
}