/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sources;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
//import com.mongodb.DBCursor;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

//import.javax.servlet.RequestDispatcher;
@WebServlet(urlPatterns = {"/GetEmbeddedObjs"})
@MultipartConfig
public class GetEmbeddedObjs extends HttpServlet {

    private static final long serialVersionUID = 1L;
    // location to store file uploaded
    private static final String UPLOAD_DIRECTORY = "image_upload";
    // upload settings
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DB db1 = null;
        try {
            db1 = MongoConstants.connectToMongo();
        } catch (Exception ex) {
            Logger.getLogger(SearchPromisLotsTlog.class.getName()).log(Level.SEVERE, null, "Mongo Connection pool error:" + ex);
        }
        //DB db1 = mongo.getDB("cimapps");
        String operation = request.getParameter("operation");
        String embeddedFile = request.getParameter("fileName"); // request.getParameter("fileName");
        // //
        // "SNPBWA07190100537-Attachments.doc";//
        Logger.getLogger(DuplicateSTR.class.getName()).log(Level.INFO, "Request Received for processing  object " + embeddedFile);
        Logger.getLogger(DuplicateSTR.class.getName()).log(Level.INFO, "Request Received for operation " + operation);

        StringBuilder ObjName = new StringBuilder();
        ObjName.append(embeddedFile);
        GridFS gfscimapps = new GridFS(db1, "cimappsSTR1");
        BasicDBObject query = new BasicDBObject("filename", ObjName.toString());

        if (operation != null && operation.equalsIgnoreCase("remove")) {
            Logger.getLogger(GetEmbeddedObjs.class.getName()).log(Level.INFO, "Removing atachment from DB:" + ObjName.toString());
            gfscimapps.remove(query);
        } else {
            if (embeddedFile == null || embeddedFile.equals("")) {
                Logger.getLogger(GetEmbeddedObjs.class.getName()).log(Level.SEVERE, "File Name can't be null or empty");
                throw new ServletException("File Name can't be null or empty");
            } else {
                GridFSDBFile imageForOutput = gfscimapps.findOne(query);
                if (imageForOutput != null) {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-disposition", "attachment; filename=" + embeddedFile);
                    ServletOutputStream os = response.getOutputStream();
                    imageForOutput.writeTo(os);
                    Logger.getLogger(GetEmbeddedObjs.class.getName()).log(Level.INFO, "File downloaded at client successfully");

                }
            }
        }
        //mongo.close();
    }
}
