/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jazz.str.vo;

/**
 *
 * @author kudaraa
 */
public class STRDetailsVO {

    private String strNumber;
    private String area;
    private String status;
    private String strTitle;
    private String finalReportedDate;
    private String dateCreated;
    private String dateModified;
    private String site;
    private String engineerName;
    private String processAndLot;

    public STRDetailsVO() {
    }

    public STRDetailsVO(String strNumber, String area, String status) {
        this.strNumber = strNumber;
        this.area = area;
        this.status = status;
    }

    public String getStrNumber() {
        return strNumber;
    }

    public void setStrNumber(String strNumber) {
        this.strNumber = strNumber;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStrTitle() {
        return strTitle;
    }

    public void setStrTitle(String strTitle) {
        this.strTitle = strTitle;
    }

    public String getFinalReportedDate() {
        return finalReportedDate;
    }

    public void setFinalReportedDate(String finalReportedDate) {
        this.finalReportedDate = finalReportedDate;
    }

    public String getDateCreated() {
        return dateCreated;
    }

    public void setDateCreated(String dateCreated) {
        this.dateCreated = dateCreated;
    }

    public String getDateModified() {
        return dateModified;
    }

    public void setDateModified(String dateModified) {
        this.dateModified = dateModified;
    }

    public String getSite() {
        return site;
    }

    public void setSite(String site) {
        this.site = site;
    }

    public String getEngineerName() {
        return engineerName;
    }

    public void setEngineerName(String engineerName) {
        this.engineerName = engineerName;
    }

    public String getProcessAndLot() {
        return processAndLot;
    }

    public void setProcessAndLot(String processAndLot) {
        this.processAndLot = processAndLot;
    }
    
    
}
