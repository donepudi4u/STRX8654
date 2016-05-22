/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.google.gson.Gson;
import com.jaz.str.service.impl.STRDetailsServiceImpl;
import com.jazz.str.service.STRDetailsService;
import com.jazz.str.vo.STRDetailsVO;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang3.StringUtils;

/**
 *
 * @author kudaraa
 */
@WebServlet(urlPatterns = {"/getDetails"})
public class GetSTRDetailsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            MongoDBDaoImpl dbOperations = getDabaseOperationObject();
            Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Connected DB successfully");
            String reportType = request.getParameter("type");
            if (StringUtils.equalsIgnoreCase("engineer", reportType)) {
                getSTRDetailsByEngineer(dbOperations, request, response);
            } else if (StringUtils.equalsIgnoreCase("area", reportType)) {
                getSTRDetailsByArea(dbOperations, request, response);
            } else if (StringUtils.equalsIgnoreCase("strNumber", reportType)) {
                getSTRDetailsBySTRNumber(dbOperations, request, response);
            } else if (StringUtils.equalsIgnoreCase("status", reportType)) {
                getSTRDetailsByStatus(dbOperations, request, response);
            }
            // Either of one based on the UI/Request type type and 
//            RequestDispatcher requestDispatcher = request.getRequestDispatcher("/getReports?type=\"byEng\"");
//            requestDispatcher.forward(request, response);
        } catch (Exception ex) {
            Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    private void getSTRDetailsByEngineer(MongoDBDaoImpl dbOperations, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException, Exception {
        STRDetailsService detailsService = new STRDetailsServiceImpl(dbOperations);
        List<String> siteNames = getUniqueValuesForField(detailsService, "Site");
        Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Total SITE values count : {0}", siteNames.size());
        Map<String, Map<String, List<STRDetailsVO>>> siteEnginerSTRMap = new HashMap<>();
        for (String site : siteNames) {
            try {
                List<String> engineerNames = detailsService.getEngineerNamesByFieldName("Site", site);
                if (engineerNames.size() > 0) {
                    Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Totla Enginer values received : {0}", engineerNames.size());
                    Map<String, List<STRDetailsVO>> siteSTRNumbersMap = new HashMap<>();
                    for (String engineerName : engineerNames) {
                        Map<String, String> siteSEngineerSearchMap = new HashMap<>();
                        siteSEngineerSearchMap.put("Engineer", engineerName);
                        siteSEngineerSearchMap.put("Site", site);
                        List<STRDetailsVO> strNumberBySite = getSTRNumberBySite(siteSEngineerSearchMap, detailsService);
                        Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Totla STR  values received : for area {0} and site {1} is {2}", new Object[]{site, engineerName, strNumberBySite.size()});
                        siteSTRNumbersMap.put(engineerName, strNumberBySite);
                    }
                    siteEnginerSTRMap.put(site, siteSTRNumbersMap);
                }
            } catch (Exception e) {
                Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.SEVERE, "Exception while Processing Site : {0}Exception: {1}", new Object[]{site, e.getMessage()});
            }
        }
        request.setAttribute("engineers", siteEnginerSTRMap);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("ReportByEngineersView.jsp");
        requestDispatcher.forward(request, response);
    }

    /**
     * This method id responsible for getting unique engineers details from
     * Mongo DB. 1. Connect to DB 2. Create a query to get the unique engineer
     * names from DB.
     */
    @SuppressWarnings("UnusedAssignment")
    private List<String> getUniqueValuesForField(STRDetailsService detailsService, String fieldName) {
        List<String> engineers = new ArrayList<>();
        try {
            engineers = detailsService.getUniqueFiledValues(fieldName);
        } catch (Exception e) {
            Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.SEVERE, "Exception while fetching the : {0}Exception: {1}", new Object[]{fieldName, e.getMessage()});
        }
        return engineers;
    }

    /**
     * This is responsible to get the STR numbers group by engineer name. 1.
     * Query db to get the STR numbers group by engineer 2. build #STRDetails
     * value object 3. send the list back.
     */
    private Map<String, List<STRDetailsVO>> getSTRNumberByEngineer(List<String> engineers, STRDetailsService detailsService) {
        java.util.Map<String, List<STRDetailsVO>> engineersMap = new HashMap<>();
        for (String engineer : engineers) {
            List<STRDetailsVO> strDetailsList = detailsService.getSTRDetailsForField("Engineer", engineer);
            engineersMap.put(engineer, strDetailsList);
        }
        return engineersMap;
    }

    /**
     * This is responsible to get the STR numbers group by engineer name. 1.
     * Query db to get the STR numbers group by engineer 2. build #STRDetails
     * value object 3. send the list back.
     */
    private List<STRDetailsVO> getSTRNumberBySite(Map<String, String> CategoryAndSiteNameMap, STRDetailsService detailsService) {
        java.util.Map<String, List<STRDetailsVO>> siteSTRMap = new HashMap<>();
        List<STRDetailsVO> strDetailsList = new ArrayList<>();
//        for (String site : siteName) {
        try {
            strDetailsList = detailsService.getSTRDetailsForFields(CategoryAndSiteNameMap);
//                siteSTRMap.put(site, strDetailsList);
        } catch (Exception e) {
            Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.SEVERE, "Exception while Processing Site : Exception: {0}", e);
//            }
        }
        return strDetailsList;
    }

    /**
     * Once after building all the details in a a list convert the list of
     * engineers and their STR numbers convert them into JOSN string for display
     * purpose.
     */
    private String convertStrDetailsToJsonVal(Map<String, List<STRDetailsVO>> strDetailsMap) {
        Gson gson = new Gson();
        String strDatabyEngineersJsonStr = gson.toJson(strDetailsMap);
        Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Complete JSON STR {0}", strDatabyEngineersJsonStr);
        return strDatabyEngineersJsonStr;
    }

    private MongoDBDaoImpl getDabaseOperationObject() throws Exception {
        DB cimAppsDB = MongoConstants.connectToMongo();
        MongoDBDaoImpl daoImpl = new MongoDBDaoImpl(cimAppsDB);
        DBCollection collection = cimAppsDB.getCollection(MongoConstants.MONGO_COLLECTION);
        daoImpl.setDbCollection(collection);
        return daoImpl;
    }

    private void getSTRDetailsByArea(MongoDBDaoImpl dbOperations, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        STRDetailsService detailsService = new STRDetailsServiceImpl(dbOperations);
//        Map<String, List<String>> areaSiteMap = new HashMap<>();
        List<String> sites = getUniqueValuesForField(detailsService, "Site");
        Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Total SITE values count : {0}", sites.size());
        Map<String, Map<String, List<STRDetailsVO>>> areaSiteSTRMap = new HashMap<>();
        for (String site : sites) {
            try {
                List<String> areaNames = detailsService.getAreaNamesByFieldName("Site", site);
                if (areaNames.size() > 0) {
//                    areaSiteMap.put(area, siteValues);
                    Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Totla Area values received : {0}", areaNames.size());
                    Map<String, List<STRDetailsVO>> siteSTRNumbersMap = new HashMap<>();
                    for (String areaName : areaNames) {
                        Map<String, String> areaSiteSearchMap = new HashMap<>();
                        areaSiteSearchMap.put("Area", areaName);
                        areaSiteSearchMap.put("Site", site);
                        List<STRDetailsVO> strNumberBySite = getSTRNumberBySite(areaSiteSearchMap, detailsService);
                        Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.INFO, "Totla STR  values received : for area {0} and site {1} is {2}", new Object[]{site, areaName, strNumberBySite.size()});
                        siteSTRNumbersMap.put(areaName, strNumberBySite);
                    }
//                Map<String, List<STRDetailsVO>> strNumberBySite = getSTRNumberBySite(siteValues, detailsService);
//                strDetailsByAreaMap.put(area, strNumberBySite);
                    areaSiteSTRMap.put(site, siteSTRNumbersMap);
                }
            } catch (Exception e) {
                Logger.getLogger(GetSTRDetailsServlet.class.getName()).log(Level.SEVERE, "Exception while Processing Area : {0}Exception: {1}", new Object[]{site, e.getMessage()});
            }
        }
        request.setAttribute("areas", areaSiteSTRMap);
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("ReportByAreaView.jsp");
        requestDispatcher.forward(request, response);
    }

    private void getSTRDetailsBySTRNumber(MongoDBDaoImpl dbOperations, HttpServletRequest request, HttpServletResponse response) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    private void getSTRDetailsByStatus(MongoDBDaoImpl dbOperations, HttpServletRequest request, HttpServletResponse response) {
        String status = request.getParameter("status");
    }

}
