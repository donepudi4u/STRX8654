package sources;
//this servlet creates a list of tools EQID for STR dialog list
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
@WebServlet(urlPatterns = {"/SearchPromisEQ"})
//public  class  UpdateStock extends BaseSqlServlet {
public class SearchPromisEQ extends BaseServlet {

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
        String tool1 = null;
        //String process1 = null;
        Integer substrLen ;
        JsonElement elem = p.next();
        JsonObject obj = elem.asObject();
        Future<PromisReply> future1 ;
        if (elem.isObject()) {
            
            for (JsonElement el2 : obj.get("add").asArray()) {
                
                JsonObject eObj2 = el2.asObject();
                
                tool1 = eObj2.get("tool").asString();
                
                Logger.getLogger(SearchPromisEQ.class.getName()).info(( "***************tool1 = " + tool1));
            }   
                if(!tool1.isEmpty()) {
                    substrLen = tool1.length();
                     //future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "ACTIVE | WHERE EQPID LIKE  '"  +  tool1 + "%'" + "|SHOW EQPID |END|"   , logger, null);
                    //future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "ACTIVE | WHERE SUBSTR(EQP,1, " + substrLen.toString() + ") = '" + tool1 + "'|SHOW EQPID |END|"   , logger, null);
                    //  future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "ACTIVE | WHERE EQPID  = '1APX01'|SHOW EQPID |END|"   , logger, null);
                  future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "EQP | WHERE SUBSTR(EQPID,1, " + substrLen.toString() + ") = '" + tool1 + "'|SHOW EQPID|END|"   , logger, null);
               }else{
                     substrLen = 1;
                     future1 = pclient.send("LOTQUERY_RPMINFO", "CIMSTATION", "Z0GNI4",  "EQP | WHERE SUBSTR(EQPID,1, " + "2" + ") = '" + "1A" + "'|SHOW EQPID|END|"   , logger, null);
                }
                PromisReply reply1 = future1.get();
                String status11 = reply1.getStatus();
               // Logger.getLogger(SearchPromisEQ.class.getName()).info( "***************status11 = " + status11);
                String after = "";
                if (! reply1.getValues().isEmpty()) {
                     List<String> replys = reply1.getValues();
                      
                     for( int i=0; i < replys.size(); i++){
                        String temp = replys.get(i);
                        after = after +  temp.trim().replaceAll(" +", ",") + "," ;
                       // Logger.getLogger(SearchPromisEQ.class.getName()).info(( "***************after = " + after));
                     }
                     
                    String[] stringArray = after.split(",");
                    List<String> items = new ArrayList<>();
                   //Logger.getLogger(SearchPromisEQ.class.getName()).info(( "***************stringArray = " + stringArray.length + "***" + items.toString()));
                    for( int i=1; i < stringArray.length ; i++){
                      
                            items.add(stringArray[ i ]);
                        
                    }

                   // Logger.getLogger(SearchPromisEQ.class.getName()).info(( "***************stringArray = " +  items.size() + "***" + items.toString()));
                    JsonArray arr = new JsonArray();
                    for( int i=0; i < items.size(); i ++){
                       
                          arr.add(new JsonArray()
                                .add(items.get(i)) );
                              
                 } 
               

                ret.put("status1", status11);
                ret.put("tools", arr);

            } else {
                    Logger.getLogger(SearchPromisEQ.class.getName()).info(( "***************promis reply was empty for " + tool1 )); 
                    ret.put("status1", status11);
                    ret.put("tools", "");
                }
        } else {
            Logger.getLogger(SearchPromisEQ.class.getName()).warning((  "Input is not a JSON array."  ));
            throw new ServletException("Input must be a JSON array.");
          
        }
        resp.getWriter().append(ret.toString());
    }

}
