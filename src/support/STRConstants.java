package support;

import java.text.SimpleDateFormat;

/**
 * 
 * @author kudaraa
 *
 *This will have the application constants defined / used any where.
 */
public class STRConstants {

	public static final String[] FILE_ATTACHMENT_JSON_SEARCH_STR = {"data:application/","data:text/plain;base64"};
	public static final String[] IMAGE_ATTACHMENT_JSON_SEARCH_STR = {"data:image/"};
	
	// Server Constants
	public static final String SERVER_DOWNLOAD_PATH = "C:\\app\\";
	
	// Data base constants 
	public static final String CIMAPPSSTR1_GRIDFS = "cimappsSTR1";
	
	// Date constants
	public static final SimpleDateFormat SIMPLE_DATE_FORMAT = new SimpleDateFormat("ddMMyy");
	
	// Other Constants
	
	public static final String COMAPNY_CODE = "SFAB3";

}
