package sources;

import support.Utility;
import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Base servlet that provides error handling functionality and a {@link Connection} for database connectivity.
 * 
 * @author Kenneth Gendron
 */
public abstract class BaseSqlServlet extends BaseServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Does the actual work of the GET request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doGetImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method GET is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the HEAD request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doHeadImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method HEAD is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the POST request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected   void doPostImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method POST is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the PUT request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doPutImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method PUT is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the DELETE request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doDeleteImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method DELETE is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the OPTIONS request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doOptionsImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method OPTIONS is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Does the actual work of the TRACE request.  Sub-classes should override this method.
     * <p></p>
     * This method will always throw an exception indicating the method is not supported.
     * 
     * @param req request
     * @param resp response
     * @param con database connection, will have {@link Connection#getAutoCommit() auto-commit} set to <code>false</code>
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    protected void doTraceImpl(HttpServletRequest req, HttpServletResponse resp, Connection con) throws Exception {
        throw new ServletExceptionStatus("HTTP method TRACE is not supported by " + req.getContextPath() + req.getServletPath(), HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doGetImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doGetImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doGetImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doHeadImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doHeadImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doHeadImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doPostImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected  void doPostImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doPostImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doPutImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doPutImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doPutImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doDeleteImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doDeleteImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doDeleteImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doOptionsImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doOptionsImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doOptionsImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
    /**
     * Opens a {@link Connection} and passes it to {@link #doTraceImpl(HttpServletRequest, HttpServletResponse, Connection)}.
     * 
     * @param req request
     * @param resp response
     * 
     * @throws Exception allows checked exceptions to be thrown
     */
    @Override
    protected void doTraceImpl(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        try (Connection con = Utility.getDataSource(req).getConnection()) {
            try {
                con.setAutoCommit(false);
                doTraceImpl(req, resp, con);
            } finally {
                con.rollback();
            }
        }
    }
    
}
