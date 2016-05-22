package sources;

//import automation.admin.BaseSqlServlet;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonStreamParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.QueryBuilder;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import support.Utility;

/**
 * Returns current user interface connections.
 *
 * @author
 *
 * @version 1.0
 */
@WebServlet(urlPatterns = {"/SearchPromisTlog"})

public class SearchPromisLotsTlog extends BaseSqlServlet {

    private static final long serialVersionUID = 1L;

    static int nextID = 1;

    //Connection con = Utility.getDataSource(req).getConnection();
    @Override
    //protected void doGetImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws ServletException, IOException {
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws ServletException, IOException {
        JsonStreamParser p = new JsonStreamParser(req.getReader());

        JsonObject ret = new JsonObject();
        String part1 = null;
        String process1 = null;
        String wafers1 = null;
        String priority1 = null;
        String lottype1 = null;
        String pldlotex1 = null;
        Integer substrLen;
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        //Future<PromisReply> future1 ;
        if (elem.isObject()) {
            //ArrayList<String> errors = new ArrayList<>();
            for (JsonElement el2 : obj.get("add").asArray()) {
                //JsonObject obj = elem.asObject();
                //JsonObject eObj2 = el2.asObject();
                JsonObject eObj2 = el2.asObject();
                //String i1 = eObj2.get("part").asString();
                part1 = eObj2.get("part").asString().toUpperCase().trim();
                process1 = eObj2.get("process").asString().toUpperCase().trim();
                wafers1 = eObj2.get("wafers").asString().trim();
                priority1 = eObj2.get("priority").asString();
                lottype1 = eObj2.get("lottype").asString().toUpperCase().trim();
                pldlotex1 = eObj2.get("pldlotex").asString();
                 //part1 = obj.get("part").asString();
                //process1 = obj.get("process").asString();
            }
        }
        SimpleDateFormat sdf = Support.getDateFormatter();
        JsonArray arr = new JsonArray();
        int wafersi = 0;
        try {
            //try (Statement stmt = con.createStatement()) {
            //try (Connection con = Utility.getDataSource(req).getConnection()) {
            String query1 = "";
            String updateStmt = "";
                 //search also on ACTL.STAGESTARTQTY or (STARTMAINQTY , ENDMAINQTY) , ACTL.PRIORITY , ACTL.LOTTYPE , ACTL.CURMAINQTY

            //try (ResultSet rs = stmt.executeQuery("select type,modified,who from processtypes where queuesize=1 and concurrencylimit=1 order by type")) {
            try (Statement stmt = con.createStatement()) {
                if (wafers1.length() > 0) {
                    try {
                        wafersi = Integer.parseInt(wafers1);
                    } catch (NumberFormatException nfe) {

                    }

                }
                //construct sub statement for filtering if additional filters were detected
                String sub1 = "";
                if (wafersi > 0) {
                    sub1 = " AND ACTL.CURMAINQTY > " + wafers1;
                }
                if (priority1.length() > 0 && !priority1.contains("not used")) {
                    sub1 = sub1 + " AND ACTL.PRIORITY = " + priority1;
                }
                if (lottype1.length() > 0) {
                    sub1 = sub1 + " AND ACTL.LOTTYPE = '" + lottype1 + "'";
                }
                if (!part1.isEmpty()) {
                    substrLen = part1.length();
                    query1 = "SELECT ACTL.LOTID, ACTL.PARTNAME, ACTL_PRCDSTACK.PRCDSTACKPRCDID FROM ACTL, ACTL_PRCDSTACK  WHERE (SUBSTR(ACTL.PARTNAME,1, " + substrLen.toString() + ") = '" + part1 + "'  AND  ACTL.LOTID = ACTL_PRCDSTACK.LOTID AND ACTL_PRCDSTACK.INDX = 2 AND ACTL_PRCDSTACK.COMCLASS = 'W'   ";

                } else if (!process1.isEmpty()) {
                    substrLen = process1.length();
                    //query1 = "SELECT ACTL.LOTID, ACTL.PARTNAME, ACTL_PRCDSTACK.PRCDSTACKPRCDID FROM ACTL, ACTL_PRCDSTACK  WHERE (SUBSTR(ACTL.PARTNAME,1, " + substrLen.toString() + ") = '" + part1 + "'  AND  ACTL.LOTID = ACTL_PRCDSTACK.LOTID AND ACTL_PRCDSTACK.INDX = 2 AND ACTL_PRCDSTACK.COMCLASS = 'W'  ) " ;
                    query1 = "SELECT ACTL.LOTID, ACTL.PARTNAME, ACTL_PRCDSTACK.PRCDSTACKPRCDID FROM ACTL, ACTL_PRCDSTACK  WHERE (SUBSTR(ACTL_PRCDSTACK.PRCDSTACKPRCDID,1, " + substrLen.toString() + ") = '" + process1 + "'  AND  ACTL.LOTID = ACTL_PRCDSTACK.LOTID AND ACTL_PRCDSTACK.INDX = 2 AND ACTL_PRCDSTACK.COMCLASS = 'W'   ";
                }
                if (sub1.length() > 0) {
                    query1 = query1 + sub1;
                }
                query1 = query1 + " ) ";
                Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(("*******************************************query ==" + query1));
                try (ResultSet rs = stmt.executeQuery(query1)) {
                    // Logger.getLogger(RefreshTypes.class.getName()).info(( "ResultSet rs returned for Implant_main data" ));
                    nextID = 1;
                    StringBuilder sb1 = null;
                    String str1 = "";
                    while (rs.next()) {
                        // sb1.append(rs.getString("LOTID")).append(",");
                        str1 = str1 + rs.getString("LOTID") + ",";

                        arr.add(new JsonArray()
                                .add(rs.getString("LOTID"))
                                .add(rs.getString("PARTNAME"))
                                .add(rs.getString("PRCDSTACKPRCDID"))
                        );

                    }
                    str1 = str1.substring(0, str1.length() - 2);
                    //String str11 = sb1.toString();
                    String[] ary = str1.split(",");
                    //String[] finalSet = ary;
                    ArrayList resultarr = new ArrayList();
                    //now get see if the LOTID's already exist in Mongo
                    if (ary.length > 0) {
                        //MongoClient mongoClient = new MongoClient(MongoConstants.MONGO_SERVER, MongoConstants.MONGO_PORT );
                        //DB db = mongoClient.getDB("cimapps");
                        DB db = null;
                        try {
                            db = MongoConstants.connectToMongo();
                        } catch (Exception ex) {
                            Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
                        }
                        //ArrayList orList = new ArrayList();
                        //orList.add(new BasicDBObject("Lot_1", new BasicDBObject("$in", ary)));                  
                        //orList.add(new BasicDBObject("Lot_2", new BasicDBObject("$in", ary)));
                        //BasicDBObject query = new BasicDBObject("$or", orList);
                        //                     DBObject query = QueryBuilder.start("Lot_1").in(ary).get();
                        DBObject query = QueryBuilder.start().or(QueryBuilder.start("Lot_1").in(ary).get(),
                                QueryBuilder.start("Lot_2").in(ary).get(),
                                QueryBuilder.start("Lot_3").in(ary).get(),
                                QueryBuilder.start("Lot_4").in(ary).get(),
                                QueryBuilder.start("Lot_5").in(ary).get(),
                                QueryBuilder.start("Lot_6").in(ary).get(),
                                QueryBuilder.start("Lot_7").in(ary).get(),
                                QueryBuilder.start("Lot_8").in(ary).get(),
                                QueryBuilder.start("Lot_9").in(ary).get(),
                                QueryBuilder.start("Lot_10").in(ary).get(),
                                QueryBuilder.start("Lot_11").in(ary).get(),
                                QueryBuilder.start("Lot_12").in(ary).get(),
                                QueryBuilder.start("Lot_13").in(ary).get(),
                                QueryBuilder.start("Lot_14").in(ary).get(),
                                QueryBuilder.start("Lot_15").in(ary).get(),
                                QueryBuilder.start("Lot_16").in(ary).get()).get();
                        DBCursor cursor = db.getCollection("strdocs3").find(query);

                        //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************ary =  " + Arrays.toString(ary)));
                        //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************right before cursor while " ));
                        while (cursor.hasNext()) {
                            //remove the LotID from the finalSet list

                            BasicDBObject cursorobj = (BasicDBObject) cursor.next();
                            if (cursorobj.containsField("Lot_1")) {
                                if (!cursorobj.getString("Lot_1").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_1"));
                                }
                            }
                            if (cursorobj.containsField("Lot_2")) {
                                if (!cursorobj.getString("Lot_2").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_2"));
                                }
                            }
                            if (cursorobj.containsField("Lot_3")) {
                                if (!cursorobj.getString("Lot_3").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_3"));
                                }
                            }
                            if (cursorobj.containsField("Lot_4")) {
                                if (!cursorobj.getString("Lot_4").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_4"));
                                }
                            }
                            if (cursorobj.containsField("Lot_5")) {
                                if (!cursorobj.getString("Lot_5").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_5"));
                                }
                            }
                            if (cursorobj.containsField("Lot_6")) {
                                if (!cursorobj.getString("Lot_6").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_6"));
                                }
                            }
                            if (cursorobj.containsField("Lot_7")) {
                                if (!cursorobj.getString("Lot_7").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_7"));
                                }
                            }
                            if (cursorobj.containsField("Lot_8")) {
                                if (!cursorobj.getString("Lot_8").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_8"));
                                }
                            }
                            if (cursorobj.containsField("Lot_9")) {
                                if (!cursorobj.getString("Lot_9").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_9"));
                                }
                            }
                            if (cursorobj.containsField("Lot_10")) {
                                if (!cursorobj.getString("Lot_10").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_10"));
                                }
                            }
                            if (cursorobj.containsField("Lot_11")) {
                                if (!cursorobj.getString("Lot_11").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_11"));
                                }
                            }
                            if (cursorobj.containsField("Lot_12")) {
                                if (!cursorobj.getString("Lot_12").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_12"));
                                }
                            }
                            if (cursorobj.containsField("Lot_13")) {
                                if (!cursorobj.getString("Lot_13").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_13"));
                                }
                            }
                            if (cursorobj.containsField("Lot_14")) {
                                if (!cursorobj.getString("Lot_14").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_14"));
                                }
                            }
                            if (cursorobj.containsField("Lot_15")) {
                                if (!cursorobj.getString("Lot_15").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_15"));
                                }
                            }
                            if (cursorobj.containsField("Lot_16")) {
                                if (!cursorobj.getString("Lot_16").isEmpty()) {
                                    resultarr.add(cursorobj.getString("Lot_16"));
                                }
                            }
                            //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************cursorobj.getString(Lot_1) ==" + cursorobj.getString("Lot_1") ));
                        }
                        //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(("*******************************************right after cursor while result =  " + resultarr.toString()));
                        for (int i = arr.size() - 1 ; i > -1 ; i--) {
                            //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************arr.size =  " + arr.size() ));
                            for (int kk = resultarr.size() - 1; kk > -1; kk--) {
                                if (arr.get(i).toString().contains(resultarr.get(kk).toString())) {
                                    Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************removing =  " + arr.get(i).toString() ));
                                    arr.remove(i);
                                    resultarr.remove(kk);
                                   
                                }
                                //Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************arr after =  " + arr.toString() ));
                            }
                        }
                    }
                }
            }

        } catch (SQLException e) {
            Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.SEVERE, null, e);
            Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(("Failed to get query ACTL data"));
            throw new ServletException("Failed to query ACTL", e);
        }
        if (pldlotex1.contains("yes")) {
            //put the list of Lots into the IN() SQL and then remove them from arr when compared to the result set
            String inStmt = "";
            for (int i = 0; i < arr.size(); i++) {
                inStmt = inStmt +  arr.get(i).asArray().get(0) + ",";
           }
            inStmt = inStmt.substring(0, inStmt.length() - 1).replace("\"" ,  "'");
           //Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.INFO, "inStmt = " + inStmt);
            try (Connection con2 = Utility.getDataSource2(req).getConnection()) {
                try {
                    con2.setAutoCommit(false);
                    try (Statement stmt = con2.createStatement()) {
                        //Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.INFO, "Inside stmt creation");
                        String query1 = "SELECT DISTINCT PLD.PLD_LOTS.PLDLOTID FROM PLD.PLD_LOTS WHERE PLD.PLD_LOTS.PLDLOTID in (" + inStmt + ")";

                        try (ResultSet rs = stmt.executeQuery(query1)) {
                            // Logger.getLogger(RefreshTypes.class.getName()).info(( "ResultSet rs returned for Implant_main data" ));
                            nextID = 1;
                            //StringBuilder sb1 = null;
                            //String str1 = "";
                            while (rs.next()) {
                                for (int i = arr.size() - 1; i > -1; i--) {
                                    if (arr.get(i).toString().contains(rs.getString("PLDLOTID"))) {
                                           Logger.getLogger(SearchPromisLotsTlog.class.getName()).info(( "*******************************************PLD removing =  " + arr.get(i).toString() ));
                                        arr.remove(i);
                                       break;
                                    }
                                }
                              
                            }
                        }
                    }
                    //doPostImpl(req, resp, con2);
                } finally {
                    con2.rollback();
                }
            } catch (SQLException ex) {
                Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        ret.put("types", arr); // types is the JSON top element - not to be confused with the table name or other JS/HTML names
        //ret.put("updated", sdf.format(new Date()));
        // Logger.getLogger(RefreshTypes.class.getName()).info(( "types ret.toString = " + ret.toString() ));
        resp.getWriter().append(ret.toString());
    }

}
