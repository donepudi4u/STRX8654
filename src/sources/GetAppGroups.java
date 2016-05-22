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
import java.util.ArrayList;
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
@WebServlet(urlPatterns = {"/GetAppGroups"})
//@MultipartConfig
public class GetAppGroups extends BaseServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, InterruptedException, ExecutionException {
        JsonStreamParser p = new JsonStreamParser(req.getReader());
        JsonObject ret = new JsonObject();
        //String loginUser = null;
        //String status = null;
        String site = null;
        String strArea = null;
        String approvalGroup = null;
        String primaryArea;
        //Logger.getLogger(GetAppGroups.class.getName()).info(("***************inside GetAppGroups***" ));
        //the status is used to determine which approver group to search for approval
        //the loginUser needs to be verified against the approver group
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        if (elem.isObject()) {
            for (JsonElement el2 : obj.get("add").asArray()) {

                JsonObject eObj2 = el2.asObject();

                //loginUser = eObj2.get("loginUser").asString();
                //status = eObj2.get("status").asString();
                site = eObj2.get("site").asString();
                strArea = eObj2.get("area").asString();

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
                Logger.getLogger(GetAppGroups.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
            }
            DBCollection collection1 = db1.getCollection("STRApprovers");

           
            //parse out only the primary area from the string
            if (strArea.length() > 1) {
                primaryArea = strArea.trim().toUpperCase();
            } else {
                primaryArea = "";
            }
            String approvalKey = site.toUpperCase() + " " + primaryArea;
            String approverAreas = "";
            String siteKey = site.toUpperCase();
            BasicDBObject whereQuery = new BasicDBObject();
            if (site.contains("FAB3")) {
                whereQuery.put("_id", "APPROV07200100540"); // this document holds all approvers for NPB - FAB3
            } else {
                whereQuery.put("_id", "APPROV07200100540"); // make separate documents for the other sites
            }
            //DBCursor aDBCursor = collection1.find(whereQuery);
            JsonArray arr = new JsonArray();
            Map<String, String> approvers = new LinkedHashMap<>();
            approvers = collection1.findOne(whereQuery).toMap();
            if (approvers.isEmpty() || approvers == null) {
                Logger.getLogger(GetAppGroups.class.getName()).log(Level.WARNING, "****** Mongo query result approver list is empty********");
            } else {
                //approvers contains ALL approvers for this site - this loop grabs all approver groups for this loginUser
                List<String> appGroups = new ArrayList<>();
                String approvalFullName = "";
                for (Map.Entry<String, String> entry : approvers.entrySet()) {
                    Object key = entry.getKey();
                    Object value = entry.getValue();
                    //Logger.getLogger(GetApprovers.class.getName()).log(Level.INFO, "****** siteKey=********" + siteKey);
                    if (key.toString().contains(approvalKey)) {
                        approvalFullName = key.toString().substring(key.toString().indexOf(primaryArea) + primaryArea.length());
                        if (!key.toString().contains("-")) {
                            approvalFullName = approvalFullName + " Managers";
                        } else {
                            //approvalFullName = key.toString().substring(key.toString().indexOf(" ") + 1);
                        }
                        appGroups.add(approvalFullName);
                        arr.add(new JsonArray()
                                .add(approvalFullName));
                    }
                }
                Logger.getLogger(GetAppGroups.class.getName()).info(("***************ret.toString()***" + appGroups.toString()));
                ret.put("approved", arr);
            }
        }

        //Logger.getLogger(SearchPromisLots.class.getName()).info(("***************ret.toString()***" + ret.toString()));
        resp.getWriter().append(ret.toString());
    }

}
