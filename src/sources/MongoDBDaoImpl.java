package sources;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import com.google.gson.Gson;
import com.jazz.str.vo.STRDetailsVO;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;
import com.mongodb.util.JSON;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import support.STRConstants;

/**
 * @author kudaraa
 *
 * This class is to maintain all the DB operations in one place.
 */
public class MongoDBDaoImpl {

    //private static final Logger LOG = LoggerFactory.getLogger(MongoDBDaoImpl.class);
    private DB cimAppsDB;
    private DBCollection dbCollection;

    public MongoDBDaoImpl(DB cimAppsDB) {
        this.cimAppsDB = cimAppsDB;
    }

    /**
     * Will save any attachment from localpath to mongoDB using GridFs.
     */
    public void saveEmbeddedObject(String filepath, String fileName) {
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "saving EmbeddedObject :" + fileName);
        try {
            File docFile = new File(filepath);
            // create a "cimappsSTR" namespace
            GridFS gfscimapps = new GridFS(this.cimAppsDB, STRConstants.CIMAPPSSTR1_GRIDFS);
            // get doc file from local drive
            GridFSInputFile gfsFile = gfscimapps.createFile(docFile);
            // set a new filename for identify purpose
            gfsFile.setFilename(fileName);
            // save the image file into mongoDB
            gfsFile.save();
            // get image file by it's filename
            // gfscimapps.findOne(fileName);
            // imageForOutput.	
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "saving EmbeddedObject :" + fileName + " [Sucess]");
        } catch (UnknownHostException e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "exception while saving embedded object [ " + fileName + "]" + e);
        } catch (IOException e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Database/IO  Exception while saving embedded object [ " + fileName + "]" + e);
        }
    }

    /**
     * Will Insert the details of form (non-attachment data) to STRDOCS
     * collection in CIMAPPS DB.
     */
    public void insertIntoMongoDBCollection(String id, String valueJsonStr) {
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "insertIng  into MongoDBCollection start for id :" + id);
        DBCollection collection1 = this.cimAppsDB.getCollection("strdocs1");
        // delete document from mongo if it exists....
        BasicDBObject docQuery = new BasicDBObject();
        docQuery.put("_id", id);
        collection1.remove(docQuery);
        //String resultQueryStr = resultQuery.toString();
        // now re-insert the document
        try {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "objstr : " + valueJsonStr);
            DBObject dbobject = (DBObject) JSON.parse(valueJsonStr);
            collection1.insert(dbobject);
            //String resultStr = result.toString();
            // String STRinsertError = result.getError();
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "inserted sucessfully into MongoDBCollection for id : " + id);
        } catch (Exception e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "exception while inserting  into mongo DB collecton for id  : " + id + " : " + e);
        }
    }

    /**
     * Overloaded method to save the attachments to MONGODB using GridFs
     */
    /*public void insertIntoMongoUsingGridFs(String str_number, GridFS gridFS, BasicDBObject basicDBObject)
     throws IOException {
     Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO,"insertIng  into GridFs start for str : " + str_number);
     String json = JSONUtilities.MapToJSON(basicDBObject.toMap());
     FileUtils.writeStringToFile(new File("c:\\app\\insert-gridfs-data.txt"), json);
     BasicDBObject dbObject = new BasicDBObject();
     dbObject.put("_id", str_number);
     gridFS.remove(dbObject);
     GridFSInputFile createFile = gridFS.createFile(IOUtils.toInputStream(json));
     createFile.setId(str_number);
     createFile.setFilename(str_number + ".txt");
     createFile.save();
     Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO,"inserted successfully  into GridFs start for str : " + str_number);
     }*/
    /**
     * To get the details /attachments from MONGO DB using GridFs
     */
    @SuppressWarnings("unchecked")
    public Map<Object, Object> getFileDetailsFromGridFs(GridFS gridFS, BasicDBObject basicDBObject) throws IOException {
        // GridFS gridFS = new GridFS(myCollectionDB,"cimappsSTR1");
        GridFSDBFile gridFSDBFile = gridFS.findOne(basicDBObject);

        InputStream inputStream = gridFSDBFile.getInputStream();
        StringWriter writer = new StringWriter();
        IOUtils.copy(inputStream, writer);
        FileUtils.writeStringToFile(new File("c:\\app\\data-from-gridfs-after-insert.txt"), writer.toString());
        Gson gson = new Gson();
        Map<Object, Object> map = new HashMap<Object, Object>();
        map = (Map<Object, Object>) gson.fromJson(writer.toString(), map.getClass());
        return map;
    }

    /**
     * Overloaded method to get the attachments from MONGO DB using GridFS
     */
    public BasicDBObject getDetailsFromGridFs(GridFS gridFS, BasicDBObject basicDBObject) throws IOException {
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "getDetailsFromGridFs  for :" + basicDBObject);
        // GridFS gridFS = new GridFS(myCollectionDB,"cimappsSTR1");
        GridFSDBFile gridFSDBFile = gridFS.findOne(basicDBObject);
        InputStream inputStream = gridFSDBFile.getInputStream();
        StringWriter writer = new StringWriter();
        IOUtils.copy(inputStream, writer);
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "Writing downloaded file lo local disk");
        FileUtils.writeStringToFile(new File("c:\\app\\data-from-gridfs.txt"), writer.toString());
        BasicDBObject dbObject = (BasicDBObject) JSON.parse(writer.toString());
        return dbObject;

    }

    public Object getAutogeneratedSTRNumber() {
        DBCollection strNumberCounterCollection = getCimAppsDB().getCollection("strNumber_counter");
        if (strNumberCounterCollection.count() == 0) {
            createCountersCollection(strNumberCounterCollection);
        }
        return getNextSequence(strNumberCounterCollection, "strNumber");
    }

    private void createCountersCollection(DBCollection countersCollection) {
        BasicDBObject document = new BasicDBObject();
        document.append("_id", "strNumber");
        document.append("seq", 0);
        countersCollection.insert(document);
    }

    private Object getNextSequence(DBCollection countersCollection, String name) {

        BasicDBObject searchQuery = new BasicDBObject("_id", name);
        BasicDBObject increase = new BasicDBObject("seq", 1);
        BasicDBObject updateQuery = new BasicDBObject("$inc", increase);
        DBObject result = countersCollection.findAndModify(searchQuery, null, null, false, updateQuery, true, false);
        return result.get("seq");
    }

    public List<String> getUniqueValuesByFieldName(String filedName) {
        List replyValuesList = getDbCollection().distinct(filedName);
        return replyValuesList;
    }

    public DB getCimAppsDB() {
        return cimAppsDB;
    }

    public void setCimAppsDB(DB cimAppsDB) {
        this.cimAppsDB = cimAppsDB;
    }

    public DBCollection getDbCollection() {
        return dbCollection;
    }

    public void setDbCollection(DBCollection dbCollection) {
        this.dbCollection = dbCollection;
    }

    public List<DBObject> getSTRDetailsForField(String fieldName, String fieldValue) {
        DBCursor find = null;
        BasicDBObject dBObject = new BasicDBObject();
        dBObject.put(fieldName, fieldValue);
        DBCollection collection = getCimAppsDB().getCollection("strdocs2");
        try {
            find = collection.find(dBObject);
            if (find != null && find.count() > 0) {
                Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "STR numbers count for {0}:{1} is : {2}", new Object[]{fieldName, fieldValue, find.count()});
                return find.toArray();
            }
        } catch (Exception e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "SITES  count for {0}:{1} is : {2}", new Object[]{fieldName, fieldValue, find.count()});
        } finally {
            if (find != null) {
                find.close();
            }
        }
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Got Zero results for  {0}:{1}", new Object[]{fieldName, fieldValue});
        return new ArrayList<>();
    }

    public List<DBObject> getSTRDetailsForFields(Map<String, String> fields) {
        DBCursor find = null;
        BasicDBObject searchQuery = new BasicDBObject();
        for (Map.Entry<String, String> entrySet : fields.entrySet()) {
            searchQuery.put(entrySet.getKey(), entrySet.getValue());
        }
        BasicDBObject requiredFileds =new BasicDBObject();
        requiredFileds.put("Status", 1);
        requiredFileds.put("Area", 1);
        
        DBCollection collection = getCimAppsDB().getCollection("strdocs2");
        try {
            find = collection.find(searchQuery);
            if (find != null && find.count() > 0) {
                Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "STR numbers count for is : {0}", find.count());
                return find.toArray();
            }
        } catch (Exception e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Exception while retriving str details : {0}",e);
        } finally {
            if (find != null) {
                find.close();
            }
        }
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Got Zero results");
        return new ArrayList<>();
    }

    public List<DBObject> getAreaNamesBy(String fieldName, String fieldVal) {
        DBCursor find = null;
        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put(fieldName, fieldVal);

        BasicDBObject fields = new BasicDBObject();
        fields.put("Area", 1);
        fields.put("_id", 0);
        try {
            find = getDbCollection().find(whereQuery, fields);
            if (find != null && find.count() > 0) {
                Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "Area - numbers count for {0}:{1} is : {2}", new Object[]{fieldName, fieldVal, find.count()});
                return find.toArray();
            }
        } catch (Exception e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Area  count for {0}:{1} is : {2}", new Object[]{fieldName, fieldVal, find.count()});
        } finally {
            if (find != null) {
                find.close();
            }
        }
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Got Zero Area results for  {0}:{1}", new Object[]{fieldName, fieldVal});
        return new ArrayList<>();

    }
    
    public List<DBObject> getEngineerNamesBy(String fieldName, String fieldVal) {
        DBCursor find = null;
        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put(fieldName, fieldVal);

        BasicDBObject fields = new BasicDBObject();
        fields.put("Engineer", 1);
        fields.put("_id", 0);
        try {
            find = getDbCollection().find(whereQuery, fields);
            if (find != null && find.count() > 0) {
                Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.INFO, "Engineer Names - count for {0}:{1} is : {2}", new Object[]{fieldName, fieldVal, find.count()});
                return find.toArray();
            }
        } catch (Exception e) {
            Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Enginer  count for {0}:{1} is : {2}", new Object[]{fieldName, fieldVal, find.count()});
        } finally {
            if (find != null) {
                find.close();
            }
        }
        Logger.getLogger(MongoDBDaoImpl.class.getName()).log(Level.SEVERE, "Got Zero Area results for  {0}:{1}", new Object[]{fieldName, fieldVal});
        return new ArrayList<>();

    }
}
