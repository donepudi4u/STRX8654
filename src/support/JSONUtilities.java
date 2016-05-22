package support;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

//import org.json.JSONException;

import com.google.gson.Gson;


/**
 * @author kudaraa
 * utility Class for perform common JSON operations.
 */
public class JSONUtilities {
	  //private static final  Logger LOG =  Logger.getLogger(JSONUtilities.class);

	@SuppressWarnings("unchecked")
	public static  Map<String,Object>  jsonToMap(String tjsonStr)  {
		Logger.getLogger(JSONUtilities.class.getName()).log(Level.INFO,"JSON String received" + tjsonStr);
		Gson gson = new Gson(); 
		Map<String,Object> map = new HashMap<String,Object>();
		map = (Map<String,Object>) gson.fromJson(tjsonStr, map.getClass());
		return map;
	}
	
	@SuppressWarnings("rawtypes")
	public static String  MapToJSON(Map jsonMap)  {
		Logger.getLogger(JSONUtilities.class.getName()).log(Level.INFO,"Converting MAP to JSON");
		Gson gson = new Gson(); 
		String jsonStr = gson.toJson(jsonMap);
		Logger.getLogger(JSONUtilities.class.getName()).log(Level.INFO,"JSON values of MAP is " + jsonStr);
		return jsonStr;
	}


}
