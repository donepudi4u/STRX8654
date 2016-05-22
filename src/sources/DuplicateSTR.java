/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.google.gson.JsonArray;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonStreamParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.WriteConcern;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.logging.Level;
import org.apache.commons.lang3.StringUtils;
import support.STRConstants;

//import.javax.servlet.RequestDispatcher;
@WebServlet(urlPatterns = {"/DuplicateSTR"})
//@MultipartConfig
public class DuplicateSTR extends BaseServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, InterruptedException, ExecutionException {
        JsonStreamParser p = new JsonStreamParser(req.getReader());
        //JsonObject ret = new JsonObject();
        //Logger.getLogger(DuplicateSTR.class.getName()).info("***************************************************inside Duplicate STR");

        String STR_TITLE = null;
        String _id = null;
        String Engineer = null;
        String date1 = null;
        String Ext = null;
        String Area = null;
        String Dept = null;
        String Final_Report_Date = null;
        String purpose = null;
        String Site = null;
        String newID = null;
        String Group1 = null;
        String Group2 = null;
        String Group3 = null;
        String Group4 = null;
        String Group5 = null;
        String Group6 = null;
        String Group7 = null;
        //JsonArray arr = new JsonArray();
        //Integer substrLen ;
        JsonElement elem = p.next();
        //JsonObject obj = elem.getAsJsonObject();
        JsonObject obj = elem.asObject();
        if (elem.isObject()) {
            //if (elem.isJsonObject()) {
            //   for (JsonElement el2 : obj.get("add").getAsJsonArray()) {
            for (JsonElement el2 : obj.get("add").asArray()) {
                JsonObject eObj2 = el2.asObject();
                //JsonObject eObj2 = el2.getAsJsonObject();
                _id = eObj2.get("_id").asString();
                STR_TITLE = eObj2.get("STR_TITLE").asString();
                Engineer = eObj2.get("Engineer").asString();
                date1 = eObj2.get("date").asString();
                Ext = eObj2.get("Ext").asString();
                Area = eObj2.get("Area").asString();
                Dept = eObj2.get("Dept").asString();
                Final_Report_Date = eObj2.get("Final_Report_Date").asString();
                purpose = eObj2.get("purpose").asString();
                Site = eObj2.get("site").asString();
                Group1 = eObj2.get("Group1").asString();
                Group2 = eObj2.get("Group2").asString();
                Group3 = eObj2.get("Group3").asString();
                Group4 = eObj2.get("Group4").asString();
                Group5 = eObj2.get("Group5").asString();
                Group6 = eObj2.get("Group6").asString();
                Group7 = eObj2.get("Group7").asString();

            }
            if (Site.contains("NPB")) {
                Site = "FAB3";
            }
            //Mongo mongo = new Mongo(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT);
            //DB db1 = mongo.getDB("cimapps");
            DB db1 = null;
            try {
                db1 = MongoConstants.connectToMongo();
            } catch (Exception ex) {
                Logger.getLogger(DuplicateSTR.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
            }
            DBCollection collection1 = db1.getCollection("strdocs1");

            if (Site == null || Site.equals("") || Area == null || Area.equals("")) {
                //throw new ServletException("File Name can't be null or empty");
                Logger.getLogger(DuplicateSTR.class.getName()).warning("site and area can't be null or empty");
            } else {
                //only execute this to get the maximum value of the STR doc in the collection - a reference to start with
                BasicDBObject whereQuery = new BasicDBObject();
                //whereQuery.put("_id" , collection1.find().sort( new BasicDBObject( "number" , -1 ) ).limit(1) ) ;

                //DBCursor aDBCursor = collection1.find(whereQuery);
                Map<String, String> replys = new LinkedHashMap<>();

                Date date = new Date();
                LocalDate futureDate = LocalDate.now().plusMonths(3);
                Instant instant = futureDate.atStartOfDay().atZone(ZoneId.systemDefault()).toInstant();
                Date res = Date.from(instant);
                Final_Report_Date = new SimpleDateFormat("MM/dd/YY").format(res);
                String modifiedDate = new SimpleDateFormat("MMddYY").format(date);

                //Logger.getLogger(DuplicateSTR.class.getName()).log(Level.WARNING, "****** modified date********= " + modifiedDate );
                //newID = "S" + Site + modifiedDate + "00001";
                newID = getNextSTRNumberFromDB(req);
                //put _id entry into a new STR document in Mongo
                BasicDBObject newDoc = new BasicDBObject();

                newDoc.put("Status", "Draft");
                newDoc.put("_id", newID);
                newDoc.put("newId", newID);
                newDoc.put("Site", Site);
                newDoc.put("STR_TITLE", STR_TITLE);
                newDoc.put("Engineer", Engineer);
                newDoc.put("Date", date1);
                newDoc.put("Ext", Ext);
                newDoc.put("Area", Area);
                newDoc.put("Dept", Dept);
                newDoc.put("Final_Report_Date", Final_Report_Date);
                newDoc.put("purpose", purpose);
                newDoc.put("Group1", Group1);
                newDoc.put("Group2", Group2);
                newDoc.put("Group3", Group3);
                newDoc.put("Group4", Group4);
                newDoc.put("Group5", Group5);
                newDoc.put("Group6", Group6);
                newDoc.put("Group7", Group7);
                //MongoCollection<Document> dup = collection1.withWriteConcern(WriteConcern.JOURNALED);
                //collection1.withWriteConcern(WriteConcern.JOURNALED);
                collection1.insert(newDoc, WriteConcern.JOURNALED);
                //collection1.insert(newDoc);

                req.setAttribute("replys", replys);
                //}
            }
            //mongo.close();
        }
        JsonArray arr = new JsonArray();
        arr.add(new JsonArray()
                .add(newID));

        JsonObject ret = new JsonObject();
        ret.put("_id", arr);
        //RequestDispatcher rd = req.getRequestDispatcher("index.jsp");
        //rd.forward(req, resp);
        //Logger.getLogger(SearchPromisLots.class.getName()).info(("***************ret.toString()***" + ret.toString()));
        resp.getWriter().append(ret.toString());
    }

    /**
     * STR Number is combination of 
     * 1) Area/company code. Ex: NPB 
     * 2) Logged in User first letters of First name and Last name (AK : Avinash Kudaravalli)
     * 3) Date format (dd/mm/yy) 
     * 4) next Sequence form mongo DB (0001)
     *
     * @param request
     */
    private String getNextSTRNumberFromDB(HttpServletRequest request) throws UnknownHostException {
        StringBuilder strNumberBuilder = new StringBuilder();
        strNumberBuilder.append(STRConstants.COMAPNY_CODE);
        //strNumberBuilder.append(getLoggedinUserName(request));
        strNumberBuilder.append(getDateValue());

        Object strNextSequenceNumber = getNextSTRSequenceNumber();
        strNumberBuilder.append(StringUtils.leftPad(strNextSequenceNumber.toString(), 6, "0"));
        return strNumberBuilder.toString();
    }

    private String getDateValue() {
        return STRConstants.SIMPLE_DATE_FORMAT.format(new Date());
    }

    private Object getNextSTRSequenceNumber() {
        Object strNextSequenceNum = null;
        try {
            DB db2 = MongoConstants.connectToMongo();
            MongoDBDaoImpl daoImpl = new MongoDBDaoImpl(db2);
            strNextSequenceNum = daoImpl.getAutogeneratedSTRNumber();
        } catch (Exception e) {
            Logger.getLogger(NewClass_multi.class.getName()).log(Level.SEVERE, "Exeption while generating next sequence from mong db" + e.getMessage());
        }
        return strNextSequenceNum;
    }

    /**
     * get the logged-in user first letters of first name and last name.
     */
    /*private String getLoggedinUserName(HttpServletRequest request) {
        String remoteUser = request.getRemoteUser();
        //return remoteUser;
        return "AK";//StringUtils.EMPTY;
    }*/

}
