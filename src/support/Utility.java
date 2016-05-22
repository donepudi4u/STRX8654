package support;

import com.mongodb.DB;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.Collection;
import java.util.Comparator;
import java.util.Random;
import java.util.TreeSet;
import java.util.logging.Level;
import javax.mail.Session;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.net.util.Base64;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import sources.MongoDBDaoImpl;

/**
 *
 * @author gendrok
 */
public class Utility {
    
    private static final Logger logger = LoggerFactory.getLogger(Utility.class);
    
    public static Session getMailSession(HttpServletRequest request) throws ServletException {
        try {
            ServletContext ctx = request.getServletContext();
            String session = ctx.getInitParameter(ContextParameters.EMAILSESSION);
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            try {
                return (Session)lctx.lookup(session);
            } finally {
                try {
                    lctx.close();
                } catch (Exception e) {
                }
            }
        } catch (NamingException e) {
            String msg = "Failed to create mail session.";
            logger.error(msg, e);
            throw new ServletException(msg, e);
        }
    }
    
    public static DataSource getDataSource(HttpServletRequest request) throws ServletException {
        try {
            ServletContext ctx = request.getServletContext();
            String datasource = ctx.getInitParameter(ContextParameters.DATASOURCE);
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            try {
                return (DataSource)lctx.lookup(datasource);
            } finally {
                try {
                    lctx.close();
                } catch (Exception e) {
                }
            }
        } catch (NamingException e) {
            String msg = "Failed to create datasource.";
            logger.error(msg, e);
            throw new ServletException(msg, e);
        }
    }
    public static DataSource getDataSource2(HttpServletRequest request) throws ServletException {
        try {
            ServletContext ctx = request.getServletContext();
            String datasource = ctx.getInitParameter(ContextParameters.DATASOURCE2);
            InitialContext ic = new InitialContext();
            Context lctx;
            try {
                lctx = (Context)ic.lookup("java:/comp/env");
            } catch (NamingException e) {
                lctx = ic;
            }
            try {
                return (DataSource)lctx.lookup(datasource);
            } finally {
                try {
                    lctx.close();
                } catch (Exception e) {
                }
            }
        } catch (NamingException e) {
            String msg = "Failed to create datasource for DataSource2.";
            //Logger.getLogger(Utility.class.getName()).info(( "Failed to get query ACTL data" ));
            logger.error(msg, e);
            throw new ServletException(msg, e);
        }
    }
    /**
     * Construct an array of internet addresses from the string representations.
     * 
     * @param addresses string addresses to convert to internet addresses
     * 
     * @return array of converted internet addresses
     * 
     * @throws AddressException if unable to convert an address
     */
    public static InternetAddress[] getAddresses(Collection<String> addresses) throws AddressException {
        TreeSet<InternetAddress> set = new TreeSet<InternetAddress>(ADDRESSCOMPARATOR);
        if (addresses!=null) {
            for (String accnt : addresses) {
                set.add(new InternetAddress(accnt));
            }
        }
        return set.toArray(new InternetAddress[set.size()]);
    }
        
    /**
     * Comparator for comparing internet addresses to ensure the same address is sent to twice.
     */
    private static final Comparator<InternetAddress> ADDRESSCOMPARATOR = new Comparator<InternetAddress>() {
        @Override
        public int compare(InternetAddress v1, InternetAddress v2) {
            String a1 = v1.getAddress();
            String a2 = v2.getAddress();
            return a1.compareTo(a2);
        }
    };
   
 public static  void printFormFiledsData(FileItem item) throws IOException{
    	StringBuilder builder = new StringBuilder();
    	if (item.getFieldName().equalsIgnoreCase("Attachments_1")) {
    		builder.append("Item name : "+ item.getFieldName());
    		builder.append("\n Item value : "+item.toString());
    		String strIntrcutions = item.getContentType();
    		builder.append("\n Item ContentType : "+strIntrcutions);
    		InputStream inputStream = item.getInputStream();
    		StringWriter stringWriter = new  StringWriter();
    	//	FileOutputStream outputStream = new FileOutputStream(new File("c:\\temp\\attachments-data.txt"));
    		IOUtils.copy(inputStream,stringWriter);
    		builder.append("\n"+stringWriter.toString());
    		FileUtils.writeStringToFile(new File("c:\\temp\\attachments-data.txt"), builder.toString());
    	}
    }
    
    public  static String  parseHtmlContent(String readFileToString, DB db2, String sTRNumber, String fieldName) throws IOException {
    	 java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO,"parseHtmlContent start  for STR# ["+sTRNumber+"] fieldName: ["+fieldName+"]");
		Document document = Jsoup.parse(readFileToString);
		if(hasFileAttachment(readFileToString,STRConstants.FILE_ATTACHMENT_JSON_SEARCH_STR)){
			 java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO,"Field has attachment");
			Elements anchorTag = document.select("a[attachment]");
			processAttachMentjson(db2, sTRNumber, fieldName, anchorTag,"href");
		}
		 if(hasFileAttachment(readFileToString,STRConstants.IMAGE_ATTACHMENT_JSON_SEARCH_STR)){
			Elements anchorTag = document.select("img");
			processAttachMentjson(db2, sTRNumber, fieldName, anchorTag,"src");
		}
		
		return document.toString();
	}

	private static boolean hasFileAttachment(String readFileToString,String[] attachmentType) {
		Boolean hasAttachment = Boolean.FALSE;
		for (String fileType : attachmentType) {
			hasAttachment  =  StringUtils.contains(readFileToString, fileType);
			if(hasAttachment)
					break;
		}
		return hasAttachment;
	}
/**
 * 
 * To manipulate Data coming from drag and drop.
 */
    private static void processAttachMentjson(DB db2, String sTRNumber, String fieldName, Elements elements, String htmlttribute) {
        java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO, "processing Attachment JSON string");
        ///Elements anchorTag = document.select("a[attachment]");
        for (org.jsoup.nodes.Element link : elements) {
            String attrVal = link.attr(htmlttribute);
            String displayName = link.text();
            String fileName = sTRNumber + "-" + fieldName;
            attrVal = removejsonTextFromAttachment(attrVal);
            if (!isImageAttachment(htmlttribute)) {
                fileName = fileName + "-" + link.text();
                String downloadURL = buildEmeddedPbjectDownloadURL(fileName, displayName);
                Document newDoc = Jsoup.parse(downloadURL);
                Element anchortag2 = newDoc.getElementById("noEdit");
                //	Element el = document.createElement(downloadURL);
                link.replaceWith(anchortag2);
                //	link.append(downloadURL);
            } else {
                java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO, "Processing Image File/ embedded image");
                fileName = fileName + getRandomImageFileNumber() + ".jpg";
                displayName = fileName;
            }
            decodeAttachmentAndUploadToDB(attrVal, fileName, db2);
        }
        java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO, "Attachment JSON string processed successfully");
    }
    
    private static String getRandomImageFileNumber() {
    		Random ran = new Random();
    		int x = ran.nextInt(50) + 1;
    		return String.valueOf(x);
	}

	private static boolean isImageAttachment(String htmlttribute) {
    	return htmlttribute.equalsIgnoreCase("src");
	}

	private static String removejsonTextFromAttachment(String attrVal) {
		String attachMentStr = StringUtils.substring(attrVal,attrVal.indexOf(",")+1,attrVal.length()-1);
		return attachMentStr; 
	}
    
    private static String buildEmeddedPbjectDownloadURL( String fileName,String displaName) {
		return "<a id=\"noEdit\" href=\"GetEmbeddedObjs?fileName="+fileName+"\">"+displaName+"</a><br/>";
	}
    
    private static String buildEmeddedPbjectDownloadURLWithRemoveLink( String fileName,String displaName) {
		return "a href=\"GetEmbeddedObjs?fileName="+fileName+"\">"+displaName+"</a> -  <a href=\"GetEmbeddedObjs?fileName="+fileName+"&operation=remove\">Remove</a><br/";
	}
    
    private static  void decodeAttachmentAndUploadToDB(String byteData, String fileName, DB cimAppsDB) {
    	FileOutputStream fileOutputStream = null;
		try {
			String dirName = STRConstants.SERVER_DOWNLOAD_PATH + fileName;
			byte[] bytearray = Base64.decodeBase64(byteData);
			fileOutputStream = new FileOutputStream(dirName);
			java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO,"Writing Data to File");
			fileOutputStream.write(bytearray);
			fileOutputStream.flush();
			MongoDBDaoImpl daoImpl = new MongoDBDaoImpl(cimAppsDB);
			 java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.INFO,"Saving to mongo DB fileName: " +fileName);
			daoImpl.saveEmbeddedObject(dirName, fileName);
		} catch (FileNotFoundException ex) {
			 java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.SEVERE,"FileNotFound Exception while processing attachment json value : " + ex);
		} catch (IOException ex) {
			 java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.SEVERE,"IOException while processing attachment json value : : " + ex);
		}finally {
			try {
				fileOutputStream.close();
			} catch (IOException e) {
				java.util.logging.Logger.getLogger(Utility.class.getName()).log(Level.SEVERE,"Exception  while closing  fileoutput Stream : : " + e);
			}
		}
	}    
    
}
