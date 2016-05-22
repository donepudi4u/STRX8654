/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jaz.str.service.impl;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.jazz.str.service.STRDetailsService;
import com.jazz.str.vo.STRDetailsVO;
import com.mongodb.DBObject;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import sources.MongoDBDaoImpl;

/**
 *
 * @author kudaraa
 */
public class STRDetailsServiceImpl implements STRDetailsService {

    private MongoDBDaoImpl dbOperations;

    public STRDetailsServiceImpl(MongoDBDaoImpl dbOperations) {
        this.dbOperations = dbOperations;
    }

    /**
     * This method id responsible for getting unique engineers details from
     * Mongo DB. 1. Connect to DB 2. Create a query to get the unique engineer
     * names from DB.
     *
     * @param filedName
     * @return
     * @throws java.lang.Exception
     */
    @Override
    @SuppressWarnings("UnusedAssignment")
    public List<String> getUniqueFiledValues(String filedName) throws Exception {
        List<String> valuesList = new ArrayList<>();
        valuesList = dbOperations.getUniqueValuesByFieldName(filedName);
        return valuesList;
    }

    @Override
    public List<STRDetailsVO> getSTRDetailsForField(String fieldName, String fieldVal) {
        List<DBObject> strDetailsForEngineer = getDbOperations().getSTRDetailsForField(fieldName, fieldVal);
        List<STRDetailsVO> strDetailsList = buildSTRDetailsVoFromResponse(strDetailsForEngineer);
        Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.INFO, "Total StrDetails Size :", strDetailsList.size());
        return strDetailsList;
    }

    private List<STRDetailsVO> buildSTRDetailsVoFromResponse(List<DBObject> strDetailsForEngineer) {
        List<STRDetailsVO> strDetailsList = new ArrayList<STRDetailsVO>();
        for (DBObject dbObject : strDetailsForEngineer) {
            try {
                STRDetailsVO strDetails = new STRDetailsVO();
                if (dbObject.get("_id") != null) {
                    strDetails.setStrNumber((String) dbObject.get("_id"));
                }
                if (dbObject.get("Status") != null) {
                    strDetails.setStatus((String) dbObject.get("Status"));
                }
                if (dbObject.get("Area") != null) {
                    strDetails.setArea((String) dbObject.get("Area"));
                }
                if (dbObject.get("STR_TITLE") != null) {
                    strDetails.setStrTitle((String) dbObject.get("STR_TITLE"));
                }
                if (dbObject.get("Final_Report_Date") != null) {
                    strDetails.setFinalReportedDate((String) dbObject.get("Final_Report_Date"));
                }
                if (dbObject.get("Date") != null) {
                    strDetails.setDateCreated((String) dbObject.get("Date"));
                }
                if (dbObject.get("ModDate") != null) {
                    strDetails.setDateModified((String) dbObject.get("ModDate"));
                }
                if (dbObject.get("Site") != null) {
                    strDetails.setSite((String) dbObject.get("Site"));
                }
                if (dbObject.get("Engineer") != null) {
                    strDetails.setEngineerName((String) dbObject.get("Engineer"));
                }
                strDetailsList.add(strDetails);
            } catch (Exception e) {
                System.out.println("Error : " + e.getMessage());
                Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.SEVERE, "Error While procesing data for Engineer : ", (String) dbObject.get("_id"));
            }
        }
        return strDetailsList;
    }

    @Override
    public List<String> getAreaNamesByFieldName(String fieldName, String fieldVal) {
        List<DBObject> AreaNames = getDbOperations().getAreaNamesBy(fieldName, fieldVal);
        List<String> areaNamesList = new ArrayList<>();
        for (DBObject areaName : AreaNames) {
            try {
                System.out.println("Area Name : " + (String) areaName.get("Area"));
                areaNamesList.add((String) areaName.get("Area"));
            } catch (Exception e) {
                System.out.println("Exception while procesing area :" + e);
                Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.SEVERE, "Exception while prcessing Area Names :", e);
            }
//            JsonParser parser = new JsonParser();
//            String serializedSiteName = JSON.serialize(siteName);
//            Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.INFO, "Serialised Sites Json string{0}", serializedSiteName);
//            JsonElement siteNameElement = parser.parse(serializedSiteName);
//            return getListFromJsonString(siteNameElement);
        }
        return areaNamesList;
    }

    public MongoDBDaoImpl getDbOperations() {
        return dbOperations;
    }

    public void setDbOperations(MongoDBDaoImpl dbOperations) {
        this.dbOperations = dbOperations;
    }

    private List<String> getListFromJsonString(JsonElement siteNameElement) {
        List<String> replyList = new ArrayList<>();
        JsonParser parser = new JsonParser();
        Gson gson = new Gson();
        try {

            if (siteNameElement.isNull()) {
                // do  othing 
            } else if (siteNameElement.isArray()) {
                JsonArray jArray = parser.parse(siteNameElement.toString()).asArray();
                for (JsonElement arrayVal : jArray) {
                    replyList.add(gson.fromJson(arrayVal, String.class));
                }
            } else if (siteNameElement.isObject()) {
                replyList.add(gson.fromJson(siteNameElement, String.class));
            } else if (siteNameElement.isPrimitive()) {
                replyList.add(siteNameElement.toString());
            } else {
                replyList.add(siteNameElement.toString());
            }
        } catch (Exception e) {
            System.out.println(e);
            Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.SEVERE, "Error While parsing data from db json string :{0}", e);
            replyList.add(siteNameElement.toString());
        }
        return replyList;
    }

    @Override
    public List<STRDetailsVO> getSTRDetailsForFields(Map<String, String> fieldsMap) {
        List<STRDetailsVO> strDetailsList = new ArrayList<>();
        List<DBObject> strDetailsForEngineer = getDbOperations().getSTRDetailsForFields(fieldsMap);
        strDetailsList = buildSTRDetailsVoFromResponse(strDetailsForEngineer);
        Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.INFO, "Total StrDetails Size :", strDetailsList.size());
        return strDetailsList;
    }

    @Override
    public List<String> getEngineerNamesByFieldName(String fieldName, String fieldVal) {
        {
            List<DBObject> engineerNames = getDbOperations().getEngineerNamesBy(fieldName, fieldVal);
            List<String> engineerNamesList = new ArrayList<>();
            for (DBObject engineerName : engineerNames) {
                try {
                    System.out.println("Engineer Name : " + (String) engineerName.get("Engineer"));
                    engineerNamesList.add((String) engineerName.get("Engineer"));
                } catch (Exception e) {
                    System.out.println("Exception while procesing area :" + e);
                    Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.SEVERE, "Exception while prcessing Engineer Names :", e);
                }
//            JsonParser parser = new JsonParser();
//            String serializedSiteName = JSON.serialize(siteName);
//            Logger.getLogger(STRDetailsServiceImpl.class.getName()).log(Level.INFO, "Serialised Sites Json string{0}", serializedSiteName);
//            JsonElement siteNameElement = parser.parse(serializedSiteName);
//            return getListFromJsonString(siteNameElement);
            }
            return engineerNamesList;
        }
    }

}
