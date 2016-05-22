<%-- 
    Document   : ReportByEngineersView
    Created on : May 17, 2016, 11:47:53 AM
    Author     : kudaraa
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>STR Details by Engineers View</title>
    </head>
    <body>
        <h1>STR Details by Engineers View</h1>
             <table border="1px">
            <tr>
                            <td>--</td>
                            <td>--</td>
                            <td>STR Number</td>
                            <td>Site</td>
                            <td>Area Name</td>
                            <td>Status</td>
                            <td>Title</td>
                            <td>Engineer Name</td>
                            <td>Final Report Date</td>
                            <td>Date Created</td>
                            <td>Date Modified</td>
                            <td>Process/Lot</td>
            <c:forEach items="${engineers}" var="engineer"> 
                <tr><td colspan="100%">${engineer.key}</td></tr>
                    <c:forEach items="${engineer.value}" var="site">
                    <tr><td>--</td><td colspan="100%">${site.key}</td></tr>
                        <c:forEach var="strDetailsVO" items="${site.value}">
                        <tr>
                            <td>--</td>
                            <td>--</td>
                            <td>${strDetailsVO.strNumber}</td>
                            <td>${strDetailsVO.site}</td>
                            <td>${strDetailsVO.area}</td>
                            <td>${strDetailsVO.status}</td>
                            <td>${strDetailsVO.strTitle}</td>
                            <td>${strDetailsVO.engineerName}</td>
                            <td>${strDetailsVO.finalReportedDate}</td>
                            <td>${strDetailsVO.dateCreated}</td>
                            <td>${strDetailsVO.dateModified}</td>
                            <td>${strDetailsVO.processAndLot}</td>
                        </tr>
                    </c:forEach>
                </c:forEach>
            </c:forEach>
        </table>
    </body>
</html>
