package sources;

//import automation.admin.BaseSqlServlet;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonStreamParser;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.logging.Logger;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import promis.PromisClient;
import promis.PromisReply;

/**
 * Returns current user interface connections.
 *
 * @author 
 *
 * @version 1.0
 */
@WebServlet(urlPatterns = {"/SearchPromis"})
//public  class  UpdateStock extends BaseSqlServlet {
public class SearchPromisLots extends BaseServlet {

    private static final long serialVersionUID = 1L;

    private PromisClient pclient;

    @Override
    public void init(ServletConfig config) {
        String[] promis = config.getServletContext().getInitParameter("promis").split(":");
        pclient = PromisClient.getClient(new InetSocketAddress(promis[0], Integer.parseInt(promis[1])));
    }

    @Override
    protected void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException, InterruptedException, ExecutionException {
        JsonStreamParser p = new JsonStreamParser(req.getReader());
        JsonObject ret = new JsonObject();
        String part1 = null;
        String process1 = null;
        Integer substrLen ;
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        Future<PromisReply> future1 ;
        if (elem.isObject()) {
            //ArrayList<String> errors = new ArrayList<>();
            for (JsonElement el2 : obj.get("add").asArray()) {
                //JsonObject obj = elem.asObject();
                 //JsonObject eObj2 = el2.asObject();
                JsonObject eObj2 = el2.asObject();
                //String i1 = eObj2.get("part").asString();
                part1 = eObj2.get("part").asString();
                process1 = eObj2.get("process").asString();
                 //part1 = obj.get("part").asString();
               //process1 = obj.get("process").asString();
            }   
                if ( part1.length() > 3) {
                    substrLen = part1.length();
                     future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "ACTIVE | WHERE SUBSTR(PARTID,1, " + substrLen.toString() + ") = '" + part1 + "'|SHOW LOTID" +"|SHOW PARTID" +"|SHOW CURPRCDID|END|"   , logger, null);
                }else{
                     substrLen = process1.length();
                     future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "ACTIVE | WHERE SUBSTR(CURPRCDID,1, " + substrLen.toString() + ") = '" + process1 + "'|SHOW LOTID" +"|SHOW PARTID" +"|SHOW CURPRCDID|END|"   , logger, null);
                }
                PromisReply reply1 = future1.get();
                String status11 = reply1.getStatus();
                String after = "";
                if (! reply1.getValues().isEmpty()) {
                     List<String> replys = reply1.getValues();
 
                     for( int i=0; i < replys.size(); i++){
                        String temp = replys.get(i);
                        after = after +  temp.trim().replaceAll(" +", ",") + "," ;
                        //Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************after = " + after));
                     }
                     
                    String[] stringArray = after.split(",");
                    List<String> items = new ArrayList<>();
                   //Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************stringArray = " + stringArray.length + "***" + items.toString()));
                    for( int i=1; i < stringArray.length ; i++){
                         if( ((i - 1 ) % 5 == 0 || i == 1) && (i - 3) < stringArray.length){
                            items.add(stringArray[ i ]);
                             items.add(stringArray[i + 1]);
                             items.add(stringArray[  i + 3]);
                         }else {
                            // Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************stringArray = " + stringArray.length + "***" + items.toString()));
                         }
                    }

                    //Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************stringArray = " +  items.size() + "***" + items.toString()));
                    JsonArray arr = new JsonArray();
                    for( int i=0; i < items.size() - 3; i += 3){
                        //if( (i - 1 ) % 5 == 0 || i == 1){
                          arr.add(new JsonArray()
                                .add(items.get(i))
                              .add(items.get(i + 1))
                              .add(items.get(i + 2)) );
                             
                          //B2773-17A5A

                 } 
               
//                }//B2773-17A5A
                ret.put("status1", status11);
                ret.put("types", arr);
                //log below can be found in the Server Log 
                //Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************final1.toString = " + final1.toString()));
                // Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************arr.toString = " + arr.toString()));
            } else {
                    Logger.getLogger(SearchPromisLots.class.getName()).info(( "***************promis reply was empty for " + part1 )); 
                    ret.put("status1", status11);
                    ret.put("types", "");
                }
        } else {
            Logger.getLogger(SearchPromisLots.class.getName()).warning((  "Input is not a JSON array."  ));
            throw new ServletException("Input must be a JSON array.");
          
        }
        resp.getWriter().append(ret.toString());
    }

}
