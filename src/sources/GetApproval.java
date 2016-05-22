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
import com.mongodb.Mongo;
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
@WebServlet(urlPatterns = {"/GetApproval"})
//@MultipartConfig
public class GetApproval extends BaseServlet {

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
        String loginUser = null;
        String status = null;
        String site = null;
        String strArea = null;
        String approvalGroup = null;
        String primaryArea;
        //the status is used to determine which approver group to search for approval
        //the loginUser needs to be verified against the approver group
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        if (elem.isObject()) {
            for (JsonElement el2 : obj.get("add").asArray()) {

                JsonObject eObj2 = el2.asObject();

                loginUser = eObj2.get("loginUser").asString();
                status = eObj2.get("status").asString();
                site = eObj2.get("site").asString();
                strArea = eObj2.get("strArea").asString();

            }
            if (site.contains("NPB")) {
                site = "FAB3";
            }
            //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            //DB db1 = mongo.getDB("cimapps");
            DB db1 = null;
            try {
                db1 = MongoConstants.connectToMongo();
            } catch (Exception ex) {
                Logger.getLogger(GetApproval.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
            }
            DBCollection collection1 = db1.getCollection("STRApprovers");

            if (loginUser == null || loginUser.equals("") || status == null || status.equals("")) {
                //throw new ServletException("File Name can't be null or empty");
                Logger.getLogger(GetApproval.class.getName()).warning("status and loginUser can't be null or empty");
            } else {
                //parse out only the primary area from the string
                if (status.contains("Area")) {
                    approvalGroup = "AREA";
                } else if (status.contains("SCM")) {
                    approvalGroup = "SCM";
                } else if (status.contains("General")) {
                    approvalGroup = "General";
                 } else if (status.contains("In Process")) {
                    approvalGroup = "General";    
                } else if (status.contains("STR Complete")) {
                    approvalGroup = "General";        
                }else{
                    approvalGroup = "none";
                }
                if (strArea.length() > 1 &&  strArea.indexOf(" ", 1) > -1) {
                    primaryArea = strArea.substring(0, strArea.indexOf(" ", 1));
                } else {
                    primaryArea = "";
                }
                String approverKey = site.toUpperCase() + " " + primaryArea.toUpperCase().trim() + " " + approvalGroup;
                String approverAreas = "";
                String siteKey = site.toUpperCase();
                BasicDBObject whereQuery = new BasicDBObject();
                if ( site.contains( "FAB3")){
                    whereQuery.put("_id", "APPROV07200100540" ); // this document holds all approvers for NPB - FAB3
                }else{
                    whereQuery.put("_id", "APPROV07200100540"); // make separate documents for the other sites
                }
                //DBCursor aDBCursor = collection1.find(whereQuery);
                Map<String, String> approvers = new LinkedHashMap<>();
                approvers = collection1.findOne(whereQuery).toMap();
                if (approvers.isEmpty() || approvers == null) {
                    Logger.getLogger(GetApproval.class.getName()).log(Level.WARNING, "****** Mongo query result approver list is empty********");
                } else {
                    //approvers contains ALL approvers for this site - this loop grabs all approver groups for this loginUser
                    String approverFullName = "";
                    for (Map.Entry<String, String> entry : approvers.entrySet()) {
                        Object key = entry.getKey();
                        Object value = entry.getValue();
                        //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** siteKey=********" + siteKey);
                        if (key.toString().contains(siteKey) && !"".equals(siteKey) ) {
                            //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** value is********" + value.toString());
                            List<String> approverList = (List<String>) value;
                            if (value == null || value == "") {
                                Logger.getLogger(GetApproval.class.getName()).log(Level.WARNING, "****** approver list is null ********");
                            } else {
                                String[] stringArray = approverList.toString().replace("[", "").replace("]", "").replace("\"", "").split(" , ");
                                for (int kk = 0; kk < stringArray.length; kk++) {
                                    //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** stringArray temp is********" + temp.toString());
                                    if (loginUser.toUpperCase().trim().contentEquals(stringArray[kk].toUpperCase().trim())) {
                                        // LIST ALL AREA AND APPROVAL GROUPS FOR THIS loginUSER
                                        approverAreas = approverAreas + key.toString().substring(5).replace(" ", "_") + " "; //this sting is space delimited of unique values
                                        approverFullName = stringArray[kk + 1];
                                        //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** approverAreas is********" + approverAreas);
                                    }
                                }
                            }
                        }
                    }
                    JsonArray arr = new JsonArray();
                    
                    if( !"General".equals(approvalGroup)){
                    for (Map.Entry<String, String> entry : approvers.entrySet()) {
                        //approvers contains ALL approvers for this site & area and approver group
                        Object key = entry.getKey();
                        Object value = entry.getValue();
                        //arr = gson.toJson(value);
                        if (approverKey.equals(key.toString())) {
                            List<String> approverList = (List<String>) value;
                            if (value == null || value == "") {
                                Logger.getLogger(GetApproval.class.getName()).log(Level.WARNING, "****** approver list is null ********");
                            } else {

                                String[] stringArray = approverList.toString().replace("[", "").replace("]", "").replace("\"", "").split(" , ");
                                
                                //find the approver from the approverList - a List of values 
                                
                                String approved = "NotFound";
                                //for (String temp : stringArray) {
                                for (int kk = 0; kk < stringArray.length; kk++) {
                                    //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** stringArray temp is********" + temp.toString());
                                    if (loginUser.toUpperCase().trim().contentEquals(stringArray[kk].toUpperCase().trim())) {
                                        approved = "Ok";
                                        approverFullName = stringArray[kk + 1];

                                        break;
                                    }
                                }
                                arr.add(new JsonArray()
                                        .add(approverFullName)
                                        .add(approved)
                                        .add(approverAreas));
                                ret.put("approved", arr);
                            }
                        }
                    }
                    }else{
                        arr.add(new JsonArray()
                                        .add(approverFullName)
                                        .add("Ok")
                                        .add(approverAreas));
                                ret.put("approved", arr);
                    }
                }
            }
            
        }
       //Logger.getLogger(SearchPromisLots.class.getName()).info(("***************ret.toString()***" + ret.toString()));
        resp.getWriter().append(ret.toString());
    }

}
