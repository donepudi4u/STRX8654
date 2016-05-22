/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonStreamParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
//import com.mongodb.DBCursor;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import.javax.servlet.RequestDispatcher;
@WebServlet(urlPatterns = {"/GetApprovers"})
//@MultipartConfig
public class GetApprovers extends BaseServlet {

    private static final long serialVersionUID = 1L;
    // location to store file uploaded
//    private static final String UPLOAD_DIRECTORY = "image_upload";
//    // upload settings
//    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
//    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
//    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB
    //   private static final Gson gson = new GsonBuilder().disableHtmlEscaping().create();
    //   private static final Type TT_mapStringString = new TypeToken<Map<String,String>>(){}.getType();

    @Override
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, InterruptedException, ExecutionException {
        JsonStreamParser p = new JsonStreamParser(req.getReader());
        JsonObject ret = new JsonObject();
        String site1 = null;
        String area1 = null;
        String status1 = null;
        String approvalGroup = null;
        //JsonArray arr = new JsonArray();
        //Integer substrLen ;
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        if (elem.isObject()) {
            for (JsonElement el2 : obj.get("add").asArray()) {

                JsonObject eObj2 = el2.asObject();

                site1 = eObj2.get("site").asString();
                area1 = eObj2.get("area").asString().trim();
                status1 = eObj2.get("status").asString();
            }
             if(site1.contains("NPB"))
            {           
                site1 = "FAB3";
            }
             String primaryArea ;
             Integer aa = 0;
            //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            //DB db1 = mongo.getDB("cimapps");
             DB db1 = null;
            try {
                db1 = MongoConstants.connectToMongo();
            } catch (Exception ex) {
                Logger.getLogger(GetApprovers.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
            }
            DBCollection collection1 = db1.getCollection("STRApprovers");

            if (site1 == null || site1.equals("") || area1 == null || area1.equals("")) {
                //throw new ServletException("File Name can't be null or empty");
                Logger.getLogger(GetApprovers.class.getName()).warning("site and area can't be null or empty");
            } else {
               if( area1.contains(" ")) {
                   aa = area1.indexOf(" ");
               }
                
                if (aa > 1 ){
                    primaryArea = area1.substring(0, area1.trim().indexOf(" ", 1));
                } else {
                    primaryArea = area1;
                }
                //parse out only the primary area from the string
                //String primaryArea = area1.substring(0, area1.trim().indexOf(" ", 1));
                if(status1.contains("Area") || status1.contains("Draft")){
                    approvalGroup = "AREA";
                }else if(status1.contains("SCM")){
                   approvalGroup = "SCM";
                }
                //THIS ONLY GETS THE APPROVERS FOR THE AREA MANAGERS
                String approverKey = site1.toUpperCase() + " " + primaryArea.toUpperCase().trim() + " " + approvalGroup;

                BasicDBObject whereQuery = new BasicDBObject();
                whereQuery.put("_id", "APPROV07200100540");

                //DBCursor aDBCursor = collection1.find(whereQuery);
                Map<String, String> approvers = new LinkedHashMap<>();
                approvers = collection1.findOne(whereQuery).toMap();
                if (approvers.isEmpty() || approvers == null) {
                    Logger.getLogger(GetApprovers.class.getName()).log(Level.WARNING, "****** Mongo query result approver list is empty********");
                } else {

                    for (Map.Entry<String, String> entry : approvers.entrySet()) {

                        Object key = entry.getKey();
                        Object value = entry.getValue();
                        //arr = gson.toJson(value);
                        if (approverKey.equals(key.toString())) {
                            List<String> approverList = (List<String>) value;
                            if (value == null || value == "") {
                                Logger.getLogger(GetApprovers.class.getName()).log(Level.WARNING, "****** approver list is null ********");
                            } else {
                          // Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** approver json is********" + approverList.toString());
                                //stringArray = stringArray.toString().replace("[", "").replace("]", "").replace("\"", "");
                                String[] stringArray = approverList.toString().replace("[", "").replace("]", "").replace("\"", "").split(" , ");

                                JsonArray arr = new JsonArray();
                                for (int i = 0; i < stringArray.length - 2; i += 3) {
                                    
                                    arr.add(new JsonArray()
                                            .add(stringArray[i + 1]));

                                }
                                ret.put("approver", arr);

                            }

                        }

                    }

                }
            }

            //mongo.close();

        }

        Logger.getLogger(SearchPromisLots.class.getName()).info(("***************ret.toString()***" + ret.toString()));
        resp.getWriter().append(ret.toString());
    }

}
