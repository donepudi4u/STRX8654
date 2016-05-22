<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="java.util.Map.Entry"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.TreeMap,java.util.Map,java.text.NumberFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    //String version = automation.admin.Support.getVersion();
    String path = request.getContextPath();
    String title = "Process STR Form Web Ver 1.0" ;
    //String host = java.net.InetAddress.getByName(request.getServerName()).getCanonicalHostName().toLowerCase(); 
    //String user1 = request.getRemoteUser();
  String loginUser = request.getRemoteUser();

    String generalStatus = null;
    
%><!doctype html>
<html>
    <head>
<!--        <meta charset="utf-8">-->
        <title>Process STR Form</title>
<!--        <link href="media/dataTables/demo_page.css" rel="stylesheet" type="text/css" />
        <link href="media/dataTables/demo_table.css" rel="stylesheet" type="text/css" />
        <link href="media/dataTables/demo_table_jui.css" rel="stylesheet" type="text/css" />-->
        <link href="media/dataTables/jquery-ui.min.css" rel="stylesheet"> 
        <link href="media/dataTables/dataTables.jqueryui.css" rel="stylesheet"> 
        <link href="media/dataTables/style.min.css" rel="stylesheet"> 
        <link href="media/dataTables/root.css" rel="stylesheet"/>
<!--        <link href="media/dataTables/jquery.toolbar.css" rel="stylesheet" />-->
<!--        <link href="media/themes/smoothness/jquery-ui-1.7.2.custom.css" rel="stylesheet" type="text/css" media="all" />-->
<!--         <link href="media/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" media="all" />
         <link href="media/themes/base/jquery-ui.theme.min.css" rel="stylesheet" type="text/css" media="all" />-->
         <script src="scripts/jquery-2.2.0.min.js"></script>
        <script src="scripts/bootstrap.min.js"></script>
        <script src="scripts/jquery.hotkeys.js"></script>
        <script src="scripts/wysiwyg.js"></script>
<!--         <script src="scripts/jquery-2.1.1.min.js" type="text/javascript"></script>
         <script src="scripts/bootstrap.min.js"></script>
-->         <script src="scripts/jquery-ui.min.js" type="text/javascript"></script>
             <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
         <script src="scripts/dataTables.jqueryui.js" type="text/javascript"></script>
         <script src="scripts/jquery.toolbar.js"></script>
<!--        <script src="scripts/jquery.ba-hashchange.min.js" ></script>
        <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
        <script src="scripts/dataTables.jqueryui.js" type="text/javascript"></script>
       <script src="scripts/uielements.js"></script> 
         <script src="scripts/utility.js"></script> 
          <script src="scripts/jquery.ui.redefine.js"></script> 

<!--         <script src="scripts/jquery.ba-hashchange.min.js"></script> -->
<!--        <script src="scripts/jquery.dataTables.min.js" type="text/javascript"></script>
 
<!--        <script src="scripts/jquery.ui.redefine.js"></script> -->
<!--        <script src="scripts/jquery.uploadfile.min.js"></script> 
          <script src="scripts/jquery.form.js"></script> -->
            
<!--          <script src="scripts/bootstrap.js"></script>-->
         
        <style>
/*  #accordion-resizer {
    padding: 10px;
    //width: 1300px;
   width: 97%;
   //height: 95%;    
    height:520px;
  }*/
    
  .STR_TITLE{
      width:100%;
      padding-left:0px;
      padding-right:0px;
  }
</style>
  
        <script>

var  LotsForSTR = [];
var counter=16;
var status = "";
var approvedStatus = "test";
var approver="none";
var EditButtonClicked=0;
var approverAreas = "none";
var shipselect ="";
var scrWfrSelect ="";
 var primeArea="";
 var primaryArea = "";
var appapprovedStatus = "test";
var appapprover="none";
var appapproverAreas = "none";
var appprimeArea="";
var appprimaryArea = "";
var loginAdmin = false;
status = "${replys.get("Status")}";
//status = "Pending SCM Lot Approval";
//status = "Pending Area Approval";
//var approvedStatus = "";
//THIS IS FOR TESTING ONLY
var loginUser = "";
loginUser = "<%= loginUser%>";
// loginUser = 'unknown'; // use this for a non owner and non approver viewing the STR
 var owner = 'wingak'; // this is the sample STR owner login in for the Engineer that initiated the STR but not an approver
if( status === "" || status === null  ){
    status = "Draft";
}
//status = "Draft";


$('#Status').val(status);
$(function() {
    $( "#Date" ).datepicker();
  });
$(function() {
    $( "#FinalReportDate" ).datepicker();
  });
  $(function() {
    $( "#PresentationDate" ).datepicker();
  });
function getCurrentDate(){
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //January is 0!
        var yyyy = today.getFullYear();
        var time1 = today.getTime();
        var hours = today.getHours();
        var minutes = today.getMinutes();
        var ampm = hours >= 12 ? 'pm' : 'am';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        var strTime = hours + ':' + minutes + ' ' + ampm;
        if(dd<10) {
            dd='0'+dd;
        } 
        if(mm<10) {
            mm='0'+mm;
        } 
        today = mm+'/'+dd+'/'+yyyy;
       var today1 = mm+'/'+dd+'/'+yyyy + " "  + strTime;
       return today1;
}
function setSTRFieldsEdit() {
  //  alert("inside setSTRFieldsEdit status = " + status);
   $("#goIntoProduction").val("${replys.get("goIntoProduction")}");
    if("${replys.get("ReliabilityTestsI")}"=== "yes" ){
        $("#ReliabilityRequired").prop("checked", true);
    }else{
        $("#ReliabilityRequired_1").prop("checked", true);
    }
    //RelTestReqDispN    
    if("${replys.get("RelTestReqDispI")}"=== "yes" ){
        $("#RelTestReqDispY").prop("checked", true);
    }else{
        $("#RelTestReqDispN").prop("checked", true);
    }
    if("${replys.get("RelToProductionI")}"=== "yes" ){
        $("#RelToProductionY").prop("checked", true);
    }else{
        $("#RelToProductionN").prop("checked", true);
    }        
     if("${replys.get("CustDeliveryI")}"=== "yes" ){
        $("#CustDeliveryY").prop("checked", true);
    }else{
        $("#CustDeliveryN").prop("checked", true);
    }        
    $(".Disptr").each(function() {
               var b = $(this).find("input:text[class=ProbI]").val("on") ;
                if(b === true){ 
                    //these checkboxes need to pass values to the hidden inputs
                    $(this).find("input:checkbox[class=Prob]").is(':checked');
                    //alert($("#ProbI1").val());
                }    
   
    });
     $(".SCMtr").each(function() {
            var b = !$(this).find("input:text[class=LotConyI]").val() ;
            //if( !$(this).val() && $(this).val() != "") 
            if(b === true){ 
                //these checkboxes need to pass values to the hidden inputs
                $(this).find("input:checkbox[class=LotCony]").is(':checked');
                //alert($("#LotCony1").val());
            }   
           var c = $(this).find("input:text[class=AppRejI]").val("on") ;
            if(c === true){ 
                //these checkboxes need to pass values to the hidden inputs
                $(this).find("input:checkbox[class=AppRej]").is(':checked');
                //alert($("#AppRej1").val());
            } 
        });
        // $('.Disptr').prop('disabled',true); 
       $("#str_requestLotChanges").hide();
       $("#str_PEshiplots").hide();
       $(".STRtableLotApproval").find("input,button,textarea,select").prop("disabled", true); //
        
       $('#Status').val(status);
        if(status !=="Draft"){
        $("#setup").hide();
        }
        if(status ==="Draft"){
        $("#str_reject").hide();
         $('#str_approve').hide();
        }
       if (EditButtonClicked === 1){
            //alert("showing buttons and approvedStatus = " + approvedStatus);
//         $('#str_approve').show();
//         $("#str_reject").show();
//         $('#types_save').show();
        $('#str_modifyLots').show();
    }
        
        if(( status ==="Pending Area Approval" || status ==="Draft"  ) ){
            //$("#str_reject").hide();
            //alert("inside pending area approval with approver not ok")
            //only show the approve buttons if there are lots designated
            var rowCount = $('table#STRtable4 tr:last').index() ;
            if (rowCount > 1 ){
                //alert(rowCount);
                $('#str_approve').show();
                $('#str_approve span').text('Submit for Area Mgr. App.');
                $('#setup').hide();
            }    
        }else if(status ==="Pending Area Approval" && approvedStatus.indexOf("Ok") > 0){
            //alert("inside pending area approval with approver ok");
         //   $("#str_reject").show();
         var rowCount = $('table#STRtable4 tr:last').index() ;
            if (rowCount > 1 ){
                $('#str_approve').show();
               $('#str_approve span').text('Approve');
               $('#setup').hide();
            }    

        } else if(   status === "Submit For SCM Lot Approval"  ){
        //    $("#str_reject").show();
            var rowCount = $('table#STRtable4 tr:last').index() ;
                if (rowCount > 1 ){
                $('#str_approve').show();
                $('#str_approve span').text('Submit for SCM Mgr. App.');
            }
            
        }else if(status ==="Pending SCM Lot Approval" && approvedStatus.indexOf("Ok") > 0){
          //  $("#str_reject").show();
          //alert("inside pending SCM Lot Approval ok ");
          $('#str_approve').show();
          $('#str_approve span').text('Approve');
          //$('#STRtable4').find("input,button,textarea,select").prop('disabled', false);
         // $('#STRtable4').find("input,button,textarea,select").prop('readonly', false);
          
//          $(".Lot_").prop('disabled', true);    
//          $(".DeviceL").prop('disabled', true);  
//          $(".ProcessL").prop('disabled', true);    
          $('.AppRej').prop('disabled', false);
          $('.LotCony').prop('disabled', false);
          $('.AppRej').prop('readonly', false);
          $('.LotCony').prop('readonly', false);
          
         
       }else if(status ==="Pending SCM Lot Approval" && approvedStatus.indexOf("Ok") < 0){
          //  $("#str_reject").show();
          //alert("inside pending SCM Lot Approval not ok ");
          $('#str_approve').hide();
          //  $('#str_approve span').text('Approve');
          $('.AppRej').prop('disabled', true);
          $('.LotCony').prop('disabled', true);   
          $('.AppRej').prop('readonly', true);
          $('.LotCony').prop('readonly', true);
          $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
          $("#STRtable4").find("input,button,textarea,select").prop("readonly", true);
          //     $('.STRtableLotApproval').prop('readonly',false); 
        }else if(status ==="Pending General Approval" && ( approvedStatus.indexOf("Ok") < 0 )){
            $('#str_approve').hide();
           // alert("inside pending SCM Lot Approval not ok ");
//          $('.AppRej').prop('disabled', true);
//          $('.LotCony').prop('disabled', true);
//          $('.AppRej').prop('readonly', true);
//          $('.LotCony').prop('readonly', true);
          $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
          $("#STRtable4").find("input,button,textarea,select").prop("readonly", true);
           // $('#str_approve span').text('Submit For Mgnt. App.');
            
             
        }else if(status ==="Pending General Approval" && ( approvedStatus.indexOf("Ok") > 0 )){
            $('#str_approve').show();
            $('#str_approve span').text('Approve');
//            $('.AppRej').prop('disabled', true);
//          $('.LotCony').prop('disabled', true);
//          $('.AppRej').prop('readonly', true);
//          $('.LotCony').prop('readonly', true);
           $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
            $("#STRtable4").find("input,button,textarea,select").prop("readonly", true);
            
        }else if(status ==="In Process" && ( approvedStatus.indexOf("Ok") > 0 )){
            $('#str_approve').show();
             $("#str_reject").show();
           // alert("inside In Process and OK");
            $('#str_approve span').text('Complete STR');
            $("#str_reject span").text('Cancel STR');
             $("#str_delete span").text('Close STR');
              $('#str_approve span').show();
            $("#str_reject span").show();
             $("#str_delete span").show();
             $("#str_requestLotChanges").show();
             $("#str_PEshiplots").show();
             $('#types_save').hide();
         }else if(status ==="In Process" && ( approvedStatus.indexOf("Ok") < 0 ) ){    
             $('#str_approve').hide();
            $("#str_reject").hide();
            $("#str_delete").hide();
            $('#types_save').hide();
            $("#str_requestLotChanges").show();
         }else if(status ==="STR Complete" && (approverAreas.indexOf(primeArea + "_QA" ) > 0 ) ){ 
             $("#str_reject").show();
              $('#str_approve').show();
            $('#str_approve span').text('QA Feedback');
            $("#str_reject span").text('Cancel STR');  
            $("#str_delete span").text('Close STR');
            $('#types_save').hide();
        }else if(status ==="STR Complete" && ( approvedStatus.indexOf("Ok") > 0 )   ){     
             $('#str_approve').hide();
              $("#str_reject").show();
             // $('#str_approve').show();
             $("#str_reject span").text('Cancel STR');  
            $("#str_delete span").text('Close STR');
             $('#types_save').hide();
        } else if(status ==="STR Complete") {
             $('#str_approve ').hide();
            $("#str_reject").hide();
             $("#str_delete").hide();
             $('#types_save').hide();
        }
        
//    if(EditButtonClicked === 1){
        
//    } 
     if(loginAdmin === false){
        if( EditButtonClicked !== 1 || status === 'STR Closed'){
           // alert("edit button not clicked");
            //$('#str_approve').hide();
            //$('#types_save').hide();
            $('#str_SCMPC_changeLots').hide();
            $('#str_modifyLots').hide();
            $(".STRtable").find("input,button,textarea,select").prop("disabled", true);
           $('#STRtableDisp').find("input,button,textarea,select").prop('disabled', true);
              $('#STRtableDisp').find("input,button,textarea,select").prop('readonly', true);
              $('#STRtable4').find("input,button,textarea,select").prop('disabled', true);
              $('#STRtable4').find("input,button,textarea,select").prop('readonly', true);
            //$(".STRtableGeneralApproval").find("input,button,textarea,select").prop("disabled", true); 
             $('#STR_INSTRUCTION').attr('contenteditable', false);
             $('#SCMRecord').attr('contenteditable', false);
             $('#Attachments').attr('contenteditable', false);
             $('#PostCompletionComments').attr('contenteditable', false);
              $('#Attachments_1').attr('contenteditable', false);
            //richtext fields have to be set differently
         }
         if( ( status ==="Draft" || status.indexOf("Pending") > -1 ) && EditButtonClicked === 1){
              //alert("edit button  clicked");
           $("#STR_TITLE").prop('disabled', false);
           $("#Area").prop('disabled', false);
           $("#Dept").prop('disabled', false);
           $("#TypeChange").prop('disabled', false);
           $("#ChangeText").prop('disabled', false);
           $("#opener").prop('disabled', false);
           $("#Tool").prop('disabled', false); 
           $("#toolSelect").prop('disabled', false); 
           $("#FinalReportDate").prop('disabled', false); 
           $("#Total_Lots").prop('disabled', true); 
           $("#Shippable").prop('disabled', true); 
           $("#ReliabilityRequired").prop('disabled', false); 
           $("#RelTestButton").prop('disabled', false); 
           $("#ReliabilityTests").prop('disabled', true); 
            $("#AddtionalTesting").prop('disabled',false); 
            $("#AddtionalTestComment").prop('disabled',false); 
            $("#LotTypeConv").prop('disabled',true); 
            // $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
            $("#Purpose").prop('disabled',false); 
            $('#STR_INSTRUCTION').attr('contenteditable', true);
            $('#STR_successcriteria').prop('disabled',false); 
            $('#STR_successplan').prop('disabled',false); 
            
            //Approver Groups are always disabled but then enabled when updated only and then put into readonly so to update the database
            $("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
             $('#ApprovalComments').prop('disabled',true);
             $('#SCMRecord').attr('contenteditable', false);
             $('#Attachments').attr('contenteditable', true);
             $('#PostCompletionComments').attr('contenteditable', false);
             $('#STRtableLotChg').find("input,button,textarea,select").prop('disabled', true);
             $('#STRtableRburn').find("input,button,textarea,select").prop('disabled', true);
             $('#Attachments_1').attr('contenteditable', false);
            // $('#STRtableQA').find("input,button,textarea,select").prop('disabled', true);
             //Table below holds scrape waffer lists


             //$('#STRtableQAF').find("input,button,textarea,select").prop('disabled', true);
             //change buttons title
             //$('#str_approve').prop('value', 'Submit for Area Mgr. App.');

             $('#types_save span').text( 'Save As Draft');
             $("#str_SCMPC_changeLots").hide();

             $("#str_delete").hide();
             $("#rejectioncomments").hide();
             $("#STRtable9").hide(); // this is the rejection table holding the rejection rich text
             $("#SCMapprovalTitle").hide(); 
             $("#SCMRecord").hide(); // this is the SCM rich text div
             $("#poststrattachment").hide();
             $("#poststrattachment2").hide();
             $("#PostCompletionComments").hide();// this is the PostCompletion Comment rich text div PostCompletionComments
             $("#lotchangerecord").hide();
             $("#STRtableLotChg").hide();
             $("#strreportattachment").hide();
             $("#strreportattachment2").hide();
             $("#Attachments").hide();
             $("#strdisposition").hide();
             $("#strdisposition2").hide();
             $("#STRtableRburn").hide();
             $("#Attachments_1").hide();
             $("#STRtableQA").hide();
             //$("#STRtableDisp").hide();
             $("#STRtableQAF").hide();

         }
          if( ( status.indexOf("Pending SCM Lot Approval") > -1 ) && EditButtonClicked === 1){
          
         }
          if( ( status.indexOf("Pending General Approval") > -1 ) && EditButtonClicked === 1 && ( approvedStatus.indexOf("Ok") > 0 )   ){
             //$('.AppRej').attr('disabled', false);
             //$('.LotCony').attr('disabled', false);   
            // alert("inside pending general approval")
            $('#STRtable4').find("input,button,textarea,select").prop('disabled', true);
              $('#STRtable4').find("input,button,textarea,select").prop('readonly', true);;
             $('#STRtableDisp').find("input,button,textarea,select").prop('disabled', false);
              $('#STRtableDisp').find("input,button,textarea,select").prop('readonly', false);
              //$(".STRtableLotApproval").find("input,button,textarea,select").prop("disabled", false); //
              $(".QADispL").prop("disabled", true);
         }
         if( ( status.indexOf("Pending General Approval") > -1 ) &&  ( approvedStatus.indexOf("Ok") <  0 )   ){
             //$('.AppRej').attr('disabled', false);
             //$('.LotCony').attr('disabled', false);   
            // alert("inside pending general approval");
            $('#STRtable4').find("input,button,textarea,select").prop('disabled', true);
              $('#STRtable4').find("input,button,textarea,select").prop('readonly', true);
             $('#STRtableDisp').find("input,button,textarea,select").prop('disabled', true);
              $('#STRtableDisp').find("input,button,textarea,select").prop('readonly', true);
              //$(".STRtableLotApproval").find("input,button,textarea,select").prop("disabled", false); //
              //$(".QADispL").prop("disabled", true);
         }
         if( (  status === "In Process" || status === "STR Complete") && EditButtonClicked === 1){
             $('#STR_successcriteria').prop('disabled',false); 
             $('#STR_successplan').prop('disabled',false); 
             $('#STR_successcriteria').prop('readonly',false); 
             $('#STR_successplan').prop('readonly',false); 
              $('#Attachments').attr('contenteditable', true);
              $("#goIntoProduction").prop('disabled',false); 
              $("#goIntoProduction").prop('readonly',false); 
              //$("#STRtableDisp").prop('disabled',false); 
              //$("#STRtableDisp").prop('readonly',false); 
             
              //$('.STRtableGeneralApproval').prop('disabled',true); 
               //$('.STRtableGeneralApproval').prop('readonly',true); 
               $('.STRtableLotApproval').prop('disabled',true); 
               $('.STRtableLotApproval').prop('readonly',true); 
         }


               $('#UpdatedByRevisions').prop('readonly',true);    
             //$('#STRtableDisp').find("input,button,textarea,select").prop('disabled', false);
             //$('#STRtableDisp').find("input,button,textarea,select").prop('readonly', true);
             $('#STRtable14').find("input,button,textarea,select").prop('readonly', true); //this is the UpdatedByRevisions comments area
        } else if( loginAdmin === true){
             //$('#str_SCMPC_changeLots').hide();
            $("#types_save").val("Save");
             $("#types_save span").text("Save");
            $("#types_save").show();
            $('#str_modifyLots').show();
            $(".STRtable").find("input,button,textarea,select").prop("disabled", false);
            $(".STRtableLotApproval").find("input,button,textarea,select").prop("disabled", false); //
            $(".STRtableGeneralApproval").find("input,button,textarea,select").prop("disabled", false); 
            $('#STR_INSTRUCTION').attr('contenteditable', true);
            $('#SCMRecord').attr('contenteditable', true);
            $('#Attachments').attr('contenteditable', true);
            $('#PostCompletionComments').attr('contenteditable', true);
            $('#Attachments_1').attr('contenteditable', true);
            $("#str_SCMPC_changeLots").show();

             $("#str_delete").show();
             $("#rejectioncomments").show();
             $("#STRtable9").show(); // this is the rejection table holding the rejection rich text
             $("#SCMapprovalTitle").show(); 
             $("#SCMRecord").show(); // this is the SCM rich text div
             $("#poststrattachment").show();
             $("#poststrattachment2").show();
             $("#PostCompletionComments").show();// this is the PostCompletion Comment rich text div PostCompletionComments
             $("#lotchangerecord").show();
             $("#STRtableLotChg").show();
             $("#strreportattachment").show();
             $("#strreportattachment2").show();
             $("#Attachments").show();
             $("#strdisposition").show();
             $("#strdisposition2").show();
             $("#STRtableRburn").show();
             $("#Attachments_1").show();
             $("#STRtableQA").show();
             //$("#STRtableDisp").show();
             $("#STRtableQAF").show();
        }
}

   
//Prevents backspace except in the case of textareas and text inputs to prevent user navigation.
$(document).keydown(function (e) {
        var preventKeyPress;
        if (e.keyCode === 8) {
            var d = e.srcElement || e.target;
            switch (d.tagName.toUpperCase()) {
                case 'TEXTAREA':
                    preventKeyPress = d.readOnly || d.disabled;
                    break;
                case 'INPUT':
                    preventKeyPress = d.readOnly || d.disabled ||
                        (d.attributes["type"] && $.inArray(d.attributes["type"].value.toLowerCase(), ["radio", "checkbox", "submit", "button"]) >= 0);
                    break;
                case 'DIV':
                    preventKeyPress = d.readOnly || d.disabled || !(d.attributes["contentEditable"] && d.attributes["contentEditable"].value === "true");
                    break;
                default:
                    preventKeyPress = true;
                    break;
            }
        }
        else
            preventKeyPress = false;

        if (preventKeyPress)
            e.preventDefault();
    });       
  
  $(window).load(function() {
      //wrapUIElements();
      $("button").button();
    //$("#STRtable4").prop("disabled", false); //this table row is created dynamically so always goes back to the server and in again
    //$("#STRtableDisp").prop("disabled", false);//this table row is created dynamically so always goes back to the server and in again
    // $("#STRtable4").prop("readonly", false); //this table row is created dynamically so always goes back to the server and in again
    //$("#STRtableDisp").prop("readonly", false);//this table row is created dynamically so always goes back to the server and in again
        //the scrap wafers are always reprocessed for now - same with revisions...
      shipselect =  ' <option value="Ship Lot">Ship Lot</option>' +
                               ' <option value="Scrap Lot">Scrap Lot</option>' +
                                '<option value="Partial Scrap Lot">Partial Scrap Lot</option>' + 
                               ' <option value="Terminate Lot">Terminate Lot</option>';
      scrWfrSelect =  ' <option value=1>1</option>' +
                               ' <option value=2>2</option>' +
                                '<option value=3>3</option>' + 
                               ' <option value=4>4</option>' +
                               ' <option value=5>5</option>' +
                               ' <option value=6>6</option>' +
                                '<option value=7>7</option>' + 
                               ' <option value=8>8</option>' +
                               ' <option value=9>9</option>' +
                               ' <option value=10>10</option>' +
                                '<option value=11>11</option>' + 
                               ' <option value=12>12</option>' +
                               ' <option value=13>13</option>' +
                               ' <option value=14>14</option>' +
                                '<option value=15>15</option>' + 
                               ' <option value=16>16</option>' +
                                ' <option value=17>17</option>' +
                               ' <option value=18>18</option>' +
                               ' <option value=19>19</option>' +
                                '<option value=20>20</option>' + 
                               ' <option value=21>21</option>' +
                               ' <option value=22>22</option>' +
                               ' <option value=23>23</option>' +
                                '<option value=24>24</option>' + 
                               ' <option value=25>25</option>';
                  
var  LotsForSTR1 = ["${replys.get("DeviceL1")}" ,"${replys.get("ProcessL1")}" , "${replys.get("Lot_1")}", "${replys.get("QADispL1")}","${replys.get("PLD_1")}","${replys.get("PEMgrOKSHip1")}","${replys.get("CommentDispL1")}" ,"${replys.get("LotConyI1")}","${replys.get("AppRejI1")}","${replys.get("ProbI1")}","${replys.get("ScrWfrI1")}","${replys.get("DispositionL1")}","${replys.get("SCM_1")}"];
var  LotsForSTR2 = ["${replys.get("DeviceL2")}" ,"${replys.get("ProcessL2")}" , "${replys.get("Lot_2")}", "${replys.get("QADispL2")}","${replys.get("PLD_2")}","${replys.get("PEMgrOKSHip2")}" ,"${replys.get("CommentDispL2")}" ,"${replys.get("LotConyI2")}","${replys.get("AppRejI2")}","${replys.get("ProbI2")}","${replys.get("ScrWfrI2")}","${replys.get("DispositionL2")}","${replys.get("SCM_2")}"];
var  LotsForSTR3 = ["${replys.get("DeviceL3")}" ,"${replys.get("ProcessL3")}" , "${replys.get("Lot_3")}", "${replys.get("QADispL3")}","${replys.get("PLD_3")}","${replys.get("PEMgrOKSHip3")}" ,"${replys.get("CommentDispL3")}" ,"${replys.get("LotConyI3")}","${replys.get("AppRejI3")}","${replys.get("ProbI3")}","${replys.get("ScrWfrI3")}","${replys.get("DispositionL3")}","${replys.get("SCM_3")}"];
var  LotsForSTR4 = ["${replys.get("DeviceL4")}" ,"${replys.get("ProcessL4")}" , "${replys.get("Lot_4")}", "${replys.get("QADispL4")}","${replys.get("PLD_4")}","${replys.get("PEMgrOKSHip4")}","${replys.get("CommentDispL4")}" ,"${replys.get("LotConyI4")}","${replys.get("AppRejI4")}","${replys.get("ProbI4")}","${replys.get("ScrWfrI4")}","${replys.get("DispositionL4")}","${replys.get("SCM_4")}"];
var  LotsForSTR5 = ["${replys.get("DeviceL5")}" ,"${replys.get("ProcessL5")}" , "${replys.get("Lot_5")}", "${replys.get("QADispL5")}","${replys.get("PLD_5")}","${replys.get("PEMgrOKSHip5")}" ,"${replys.get("CommentDispL5")}" ,"${replys.get("LotConyI5")}","${replys.get("AppRejI5")}","${replys.get("ProbI5")}","${replys.get("ScrWfrI5")}","${replys.get("DispositionL5")}","${replys.get("SCM_5")}"];
var  LotsForSTR6 = ["${replys.get("DeviceL6")}" ,"${replys.get("ProcessL6")}" , "${replys.get("Lot_6")}", "${replys.get("QADispL6")}","${replys.get("PLD_6")}","${replys.get("PEMgrOKSHip6")}" ,"${replys.get("CommentDispL6")}" ,"${replys.get("LotConyI6")}","${replys.get("AppRejI6")}","${replys.get("ProbI6")}","${replys.get("ScrWfrI6")}","${replys.get("DispositionL6")}","${replys.get("SCM_6")}"];
var  LotsForSTR7 = ["${replys.get("DeviceL7")}" ,"${replys.get("ProcessL7")}" , "${replys.get("Lot_7")}", "${replys.get("QADispL7")}","${replys.get("PLD_7")}","${replys.get("PEMgrOKSHip7")}","${replys.get("CommentDispL7")}" ,"${replys.get("LotConyI7")}","${replys.get("AppRejI7")}","${replys.get("ProbI7")}","${replys.get("ScrWfrI7")}","${replys.get("DispositionL7")}","${replys.get("SCM_7")}"];
var  LotsForSTR8 = ["${replys.get("DeviceL8")}" ,"${replys.get("ProcessL8")}" , "${replys.get("Lot_8")}", "${replys.get("QADispL8")}","${replys.get("PLD_8")}","${replys.get("PEMgrOKSHip8")}" ,"${replys.get("CommentDispL8")}" ,"${replys.get("LotConyI8")}","${replys.get("AppRejI8")}","${replys.get("ProbI8")}","${replys.get("ScrWfrI8")}","${replys.get("DispositionL8")}","${replys.get("SCM_8")}"];
var  LotsForSTR9 = ["${replys.get("DeviceL9")}" ,"${replys.get("ProcessL9")}" , "${replys.get("Lot_9")}", "${replys.get("QADispL9")}","${replys.get("PLD_9")}","${replys.get("PEMgrOKSHip9")}" ,"${replys.get("CommentDispL9")}" ,"${replys.get("LotConyI9")}","${replys.get("AppRejI9")}","${replys.get("ProbI9")}" ,"${replys.get("ScrWfrI9")}","${replys.get("DispositionL9")}","${replys.get("SCM_9")}"];
var  LotsForSTR10 = ["${replys.get("DeviceL10")}" ,"${replys.get("ProcessL10")}" , "${replys.get("Lot_10")}", "${replys.get("QADispL10")}","${replys.get("PLD_10")}","${replys.get("PEMgrOKSHip10")}","${replys.get("CommentDispL10")}" ,"${replys.get("LotConyI10")}","${replys.get("AppRejI10")}","${replys.get("ProbI10")}","${replys.get("ScrWfrI10")}","${replys.get("DispositionL10")}","${replys.get("SCM_10")}"];
var  LotsForSTR11 = ["${replys.get("DeviceL11")}" ,"${replys.get("ProcessL11")}" , "${replys.get("Lot_11")}", "${replys.get("QADispL11")}","${replys.get("PLD_11")}","${replys.get("PEMgrOKSHip11")}" ,"${replys.get("CommentDispL11")}" ,"${replys.get("LotConyI11")}","${replys.get("AppRejI11")}","${replys.get("ProbI11")}","${replys.get("ScrWfrI11")}","${replys.get("DispositionL11")}","${replys.get("SCM_11")}"];
var  LotsForSTR12 = ["${replys.get("DeviceL12")}" ,"${replys.get("ProcessL12")}" , "${replys.get("Lot_12")}", "${replys.get("QADispL12")}","${replys.get("PLD_12")}","${replys.get("PEMgrOKSHip12")}" ,"${replys.get("CommentDispL12")}" ,"${replys.get("LotConyI12")}","${replys.get("AppRejI12")}","${replys.get("ProbI12")}","${replys.get("ScrWfrI12")}","${replys.get("DispositionL12")}","${replys.get("SCM_12")}"];
var  LotsForSTR13 = ["${replys.get("DeviceL13")}" ,"${replys.get("ProcessL13")}" , "${replys.get("Lot_13")}", "${replys.get("QADispL13")}","${replys.get("PLD_13")}","${replys.get("PEMgrOKSHip13")}" ,"${replys.get("CommentDispL13")}" ,"${replys.get("LotConyI13")}","${replys.get("AppRejI13")}","${replys.get("ProbI13")}","${replys.get("ScrWfrI13")}","${replys.get("DispositionL13")}","${replys.get("SCM_13")}"];
var  LotsForSTR14 = ["${replys.get("DeviceL14")}" ,"${replys.get("ProcessL14")}" , "${replys.get("Lot_14")}", "${replys.get("QADispL14")}","${replys.get("PLD_14")}","${replys.get("PEMgrOKSHip14")}","${replys.get("CommentDispL14")}" ,"${replys.get("LotConyI14")}","${replys.get("AppRejI14")}","${replys.get("ProbI14")}","${replys.get("ScrWfrI14")}" ,"${replys.get("DispositionL14")}","${replys.get("SCM_14")}"];
var  LotsForSTR15 = ["${replys.get("DeviceL15")}" ,"${replys.get("ProcessL15")}" , "${replys.get("Lot_15")}", "${replys.get("QADispL15")}","${replys.get("PLD_15")}","${replys.get("PEMgrOKSHip15")}" ,"${replys.get("CommentDispL15")}" ,"${replys.get("LotConyI15")}","${replys.get("AppRejI15")}","${replys.get("ProbI51")}","${replys.get("ScrWfrI15")}","${replys.get("DispositionL15")}","${replys.get("SCM_15")}"];
var  LotsForSTR16 = ["${replys.get("DeviceL16")}" ,"${replys.get("ProcessL16")}" , "${replys.get("Lot_16")}", "${replys.get("QADispL16")}","${replys.get("PLD_16")}","${replys.get("PEMgrOKSHip16")}" ,"${replys.get("CommentDispL16")}" ,"${replys.get("LotConyI16")}","${replys.get("AppRejI16")}","${replys.get("ProbI16")}","${replys.get("ScrWfrI16")}","${replys.get("DispositionL16")}","${replys.get("SCM_16")}"];;

  LotsForSTR.push(LotsForSTR1);  
  LotsForSTR.push(LotsForSTR2);       
  LotsForSTR.push(LotsForSTR3);  
   LotsForSTR.push(LotsForSTR4);  
  LotsForSTR.push(LotsForSTR5);       
  LotsForSTR.push(LotsForSTR6);  
   LotsForSTR.push(LotsForSTR7);  
  LotsForSTR.push(LotsForSTR8);       
  LotsForSTR.push(LotsForSTR9);  
   LotsForSTR.push(LotsForSTR10);  
  LotsForSTR.push(LotsForSTR11);       
  LotsForSTR.push(LotsForSTR12);  
  LotsForSTR.push(LotsForSTR13);  
   LotsForSTR.push(LotsForSTR14);  
  LotsForSTR.push(LotsForSTR15);       
  LotsForSTR.push(LotsForSTR16);  
  
  //$("#STRtableDisp").find("input,button,textarea,select").prop("disabled", false);
    for(i=1; i<counter; i++){
        // var row;
        // var row2;
        var Scm;
         var ScrWfrLa;
        var ScrWfrLSplit = new Array();
        //var PCMDispositiona ;
        var  row = $('<tr  class="SCMtr" style="display:table-row;"><TD  style="width:100px">' +
                '<input style="border:none" type="text" class="DeviceL" id="DeviceL' + i + '" name="DeviceL' + i + '"  value =' + LotsForSTR[ i - 1][ 0] + '></TD>' +
                '<TD  style="width:100px" ><input style="border:none" type="text" class="ProcessL"  id="ProcessL' + i + '" name="ProcessL' + i + '"  value =' + LotsForSTR[ i - 1][ 1] + '></TD>' +
                '<TD style="width:100px"><input style="border:none" type="text" class="Lot_" id="Lot_' + i + '" name="Lot_' + i + '"  value =' + LotsForSTR[ i - 1][ 2] + '></TD>' +
                '<TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + i + '" name="AppRej' + i + '" >Approve or Reject<input class="AppRejI" id="AppRejI' + i + '" name="AppRejI' + i + '" type="hidden" value= "' + LotsForSTR[ i - 1][ 8] + '" ></TD>' +
                '<TD style="width:130px"><input style="border:none" type="text" class ="SCMApp" id="SCM_' + i + '" name="SCM_' + i + '"  value =""></TD>'
                + '<TD style="width:100px"><input type="checkbox" class ="LotCony" id="LotCony' + i + '" name="LotCony' + i + '" >Yes<input class="LotConyI" id="LotConyI' + i + '" name="LotConyI' + i + '" type="hidden" value= "' + LotsForSTR[ i - 1][ 7] + '" ></TD></tr>');

      var  row2 = $('<tr class="Disptr" style="display:table-row;"><TD style="width:100px"><input  style="border:none" type="text" class = "QADispL" id="QADispL' + i + '" name="QADispL' + i + '"  value ="' + LotsForSTR[ i - 1 ][ 3 ] + '"></TD ><TD  style="width:100px">' +
              '<input   type="checkbox" class="Prob" id="Prob' + i + '" name="Prob' + i + '">Yes<input class="ProbI"  id="ProbI' + i + '" name="ProbI' + i + '"  type="hidden" value=' + LotsForSTR[ i - 1][ 9] + ' ></TD><TD  style="width:100px">' + ' <select  id= "DispositionL' + i + '" name="DispositionL' + i + '">' +       
                               shipselect +
                        '</select></TD><TD style="width:100px"><input style="border:none" type="text" id="PLD_' + i + '" name="PLD_' + i + '"  value ="' + LotsForSTR[ i - 1][ 4] + '"></TD><TD  style="width:200px"><input  style="border:none" type="text" id="PEMgrOKSHip' + i + '" name="PEMgrOKSHip' + i + '"  value ="' + LotsForSTR[ i - 1][ 5] + '"></TD><TD  style="width:100px">' + 
                        '<select  multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + i + '" name="ScrWfrL' + i + '" class= "ScrWfrL"  >' + 
                       scrWfrSelect + 
                       '</select><input class="ScrWfrI"  id="ScrWfrI' + i + '" name="ScrWfrI' + i + '"  type="hidden" value= "' + LotsForSTR[ i - 1][10] + '" ></TD><TD><textarea   id="CommentDispL' + i + '"  name="CommentDispL' + i + '"  style="border: none"  ROWS=4  >' + LotsForSTR[ i - 1][ 6] + '</textarea></TD></tr>');
        if( LotsForSTR[i - 1][0]  !== "" || LotsForSTR[i - 1][1]  !== "" || LotsForSTR[ i - 1][2]   !== "" ){
             $("#STRtable4").find('tbody').append(row);

         }
          if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){ 
              $("#STRtableDisp").find('tbody').append(row2);
               if(LotsForSTR[i - 1][9] === "on" ){
                    $("#Prob" + i.toString() ).prop("checked", true);
                 };
                 ScrWfrLa = LotsForSTR[i - 1][10];
                 ScrWfrLSplit = ScrWfrLa.split(/[\s,]+/);
                 $("#ScrWfrL" + i.toString() ).val(ScrWfrLSplit); 
                 $("#DispositionL" + i.toString() ).val(LotsForSTR[i - 1][11]);
                 $("#SCM_1").val(LotsForSTR[i - 1][12]);
           }
                           
        if( LotsForSTR[i - 1][0]  !== "" || LotsForSTR[i - 1][1]  !== "" || LotsForSTR[ i - 1][2]   !== "" ){
                 if(LotsForSTR[i - 1][8] === "on" ){
                     //alert(LotsForSTR[i - 1][8] );
                    $("#AppRej" + i.toString() ).prop("checked", true);
                 };
                 if(LotsForSTR[i - 1][7] === "on" ){
                      //alert(LotsForSTR[i - 1][7] );
                    //$("#LotCony1").prop("checked", true);
                    $("#LotCony" + i.toString() ).prop("checked", true);
            };
        }           
                           
//        switch(i) {
//            
//            case 1:
//            
//            if(LotsForSTR[i - 1][3]   !== "" || LotsForSTR[i - 1][4]  !== "" || LotsForSTR[i - 1][5]   !== "" || LotsForSTR[i - 1][6]  !== "" ){  
//                        
//                        PCMDispositiona = "${replys.get("DispositionL1")}";
//                        $("#DispositionL1").val(PCMDispositiona);
//           
//                         Scm = "${replys.get("SCM_1")}";
//                        $("#SCM_1").val(Scm);
//
//                    }
//                 break;
//             default:
//        }
       
    }
   
  // $("#STRtable4").find("input,button,textarea,select").prop("disabled", true);
  //changing  fields to disabled readlonly depending on the user and status of the STR

        var options;
            $('#element').toolbar( options );  
           $('#button').toolbar({
                content: '#toolbar-options',
                position: 'bottom',
                style: 'primary',
                animation: 'flip'
        });
//turn on and off inputs based on current status - using disabled feature so non-editable fields do not post back to server when updating STR



// if loginUser is a member of the approverGroup that is needed then change approval button to "Approve"
//the status would be changed when the owner of the draft clicks the Submit for Area Mgr App button.
//alert(status.substr(0,7)); Also bring back all approval areas this login is in
//BELOW IS only to see if we show the APPROVE & REJECT  button to an approver
//alert(status.substr(0,10));
   //     if( status.substr(0,7) === "Pending" || status.substr(0,10) === "In Process" || status.substr(0,12) === "STR Complete"){
//if( status === "Pl"){
       // alert(status.substr(0,10));
    //determine if login user is an Area approver and if so, change the button title and then when clicked, puts the approval info in the Approvers table
                loginUser = 'whitnem'; 
                var siteVal = $("#site").val().toString();
                 var areaVal = $("#Area").val().toString();
                 //var statusVal = $("#Status").val().toString();
                 var obj = {
                add:[]
                 };
                
                obj.add[obj.add.length] = {
                    loginUser: loginUser,
                    status: status,
                    site:siteVal,
                    strArea: areaVal
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                if (obj.length!==0) {
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                   $.ajax({ url:"/STRX8654/GetApproval",
                    method: "POST",
                    data: JSON.stringify(obj) 
                }).done(function(msg) {
                    var json = JSON.parse(msg);
                    //alert("before msg check = " + msg);
                    if(msg.toString().indexOf("Ok") > 0 ){
                        approvedStatus = msg;
                        approver = json.approved[0].toString();
                        approver = approver.substring(0, ( approver.indexOf(".com" ) + 4 ) );
                        approverAreas =  approvedStatus.substring( approvedStatus.lastIndexOf(",") + 2 ,  approvedStatus.length - 4);
                        primaryArea = $('#Area').val().toString(); 
                        var index1 = primaryArea.trim().indexOf(" ");
                        primeArea = primaryArea.substring(0, index1 + 1).toUpperCase();
                        appapprovedStatus = approvedStatus;
                        appapproverAreas = approverAreas;
                        appapprover=approver;
                        appprimeArea=primeArea;
                        appprimaryArea = primaryArea ;
                       // alert("primeArea=" + primeArea);
                        //alert()
                      $('#Status').val(status);
                    }
                });
      //      }
            
     //$('#Status').val("Pending Lot Approval");
    //alert("after msg check approverAreas = " + approverAreas);
     //$('#Status').val(status);
    }

    if($("#_id").val() === "") {   }else{
        //('#Status').val("Pending Lot Approval");
        //alert("status is " + status);
        // alert("going into setSTRFieldsEdit");
         
        setSTRFieldsEdit();//$('#STR_INSTRUCTION').attr('contenteditable', true);
        }
   
 });
  </script>
  
    </head>
    <body id="dt_example" >
       <div id="toolbar-options" class="hidden">
<!--        <a href="#"><i class="fa fa-plane"></i></a>
        <a href="#"><i class="fa fa-car"></i></a>
        <a href="#"><i class="fa fa-bicycle"></i></a>-->
    </div>
             <% 
                TreeMap<Integer, String> attachments = new TreeMap<>();
                int attachmentCounter = 0;
                
                String richText = request.getParameter("richtext");
                String newRichText = "";
                if (richText!=null) {
                    String aBegin = "<a attachment=\"";
                    String hrefAttr = "\" href=\"";
                    String aEnd = "\">";

                    StringBuilder newText = new StringBuilder();
                    int indx, prevIndx=0;
                    while ((indx = richText.indexOf(aBegin, prevIndx))!=-1) {
                        //Append everything up to now
                        newText.append(richText.substring(prevIndx, indx));

                        //Get file name from attachment attribute
                        prevIndx = indx + aBegin.length();
                        indx = richText.indexOf(hrefAttr, prevIndx);
                        String fileName = richText.substring(prevIndx, indx);

                        //Get attachment body
                        prevIndx = indx + hrefAttr.length();
                        indx = richText.indexOf(aEnd, prevIndx);
                        String fileBody = richText.substring(prevIndx, indx);
                        prevIndx = indx + aEnd.length();

                        //Add attachment to map of attachments
                        attachments.put(attachmentCounter, fileName + " ==> " + fileBody);

                        //Rewrite the link
                        newText.append("<a href=\"");
                        newText.append(attachmentCounter++);
                        newText.append("\">");
                    }
                    newText.append(richText.substring(prevIndx));
                    newRichText = newText.toString();
                }
            %>    
        <div>
<!--         <button onclick="this.blur();typesRefresh();" title="Refresh All Tables.">Refresh</button> -->
         <button class="btn-toolbar" id="editSTR" onclick="this.blur();editSTR();"  title="Settings" >Edit Process STR</button> 
         <button class="btn-toolbar" id="setup" onclick="this.blur();setupSelections();"  title="Settings" >New Draft Settings</button> 
         <button class="btn-toolbar" id="types_save" onclick="this.blur();configSave();"  title="Save As Draft." >Save As Draft</button> 
         <button class="btn-toolbar" id="str_print" onclick="this.blur();"  title="Print STR.">Print</button> 
         <button class="btn-toolbar" id="str_modifyLots" onclick="this.blur();configSetCallbacks.addModifyLots();addModifyLots();"  title="Modify Lots." >Add/Modify Lots</button>
         <button class="btn-toolbar" id="str_approve" onclick="this.blur();selectApprover();"  title="Approve" >Approve</button>
          <button class="btn-toolbar" id="str_reject" onclick="this.blur();selectRejection();"  title="Reject." >Reject</button>
         <button  class="btn-toolbar" id="str_delete" onclick="this.blur();confirmCloseSTR();"   title="Close STR" >Close</button>
         <button class="btn-toolbar" id="str_SCMPC_changeLots" onclick="this.blur();addModifyLots();"  title="SCM/PC Change Lots." >SCM/PC Change Lots</button>
          <button class="btn-toolbar" id="str_requestLotChanges" onclick="this.blur();requestLotChanges();"  title="Request Lot Change." >Request Lot Change</button>
          <button class="btn-toolbar" id="str_PEshiplots" onclick="this.blur();PEshipLots();"  title="PE Mgr OK Lot to Ship" >PE Mgr OK Lot to Ship</button>
         <button class="btn-toolbar" id="str_duplicate" onclick="this.blur();duplicateSTR()"  title="Duplicate STR." >Duplicate STR</button>
         <button class="btn-toolbar" id="str_reset" onclick="this.blur();resetSTR();"  title="Reset STR" >Reset STR</button>
         <button class="btn-toolbar" id="str_loginApp" onclick="this.blur();loginAsApprover();"  title="login as approver" >Login as approver</button>
         <button class="btn-toolbar" id="str_loginOther" onclick="this.blur();loginAsOther();"  title="login as other" >Login as other</button>
         <button class="btn-toolbar" id="str_loginAdmin" onclick="this.blur();loginAsAdmin();"  title="login as admin" >Login as Admin</button>
<!--         <button id="types_save" onclick="this.blur();configSave();"  title="Save Changes To All Tables.">Save As Draft</button> -->
<!--         <button id="logout" onclick="this.blur();logout1();"  title="Log out of the system" style="vertical-align:top; float: right">Logout</button> -->
<!--       <button id="logout" onclick="this.blur();configLogout();"  title="Log out of the system" style="vertical-align:top; float: right">Logout</button> -->
        </div>
        <p style="text-align:center; font-size:20px"><b> PROCESS SPECIAL TEST REQUEST (STR)</b> </p>
<!--         <div id="config_refresh" title="Refresh Without Saving" style="display:none">
                <p>Are you sure you wish to refresh without saving?</p>
                <div style="text-align:right">
                    <button onclick="$('#config_refresh').dialog('close');configSetCallbacks.refresh();">Yes</button>&nbsp;
                    <button onclick="$('#config_refresh').dialog('close');" autofocus>No</button>
                </div>
          </div>-->
            <div id="config_save" title="Save As Draft" style="display:none">
                <p>Do you want to save your changes?</p>
                <div style="text-align:right">
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;-->
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.historyAdd();">Yes</button>&nbsp;-->
                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;
                    <button onclick="$('#config_save').dialog('close');" autofocus>No</button>
                </div>   
             </div>
              <div id="config_logout" title="Logout" style="display:none">
                <p>Do you wish to logout?</p>
                <div style="text-align:right">
<!--                    <button onclick="$('#config_save').dialog('close');configSetCallbacks.save();">Yes</button>&nbsp;-->
                    <button onclick="$('#config_logout').dialog('close');logout1();">Yes</button>&nbsp;
                    <button onclick="$('#config_logout').dialog('close');" autofocus>No</button>
                </div>   
             </div>
       <div id="accordion-resizer" class="ui-widget-content">
        <div id="accordion" >
<!--            <p class="accordion-expand-all"><b><a href="#">Expand all sections</a></b></p>-->
           <h3 class="accordion-header">Main STR Section </h3> 
           
            <!-- The template to display files available for upload -->
           <form   id="myForm" name="myForm" method="post" action="NewClass_multi" enctype="multipart/form-data"     >
<!--<form   id="myForm" method="post" action="NewClass"  >-->
<!--             <button type="submit" >Submit</button>  -->
              
<!--             <form class= "STRform" id="STRform" action="#"  >    -->
            <div id="container">
<!--               <div>${mongodb}</div>   -->
                Site: <input   disabled style="border:none" type="text" id="site" name="site" value ="${replys.get("Site")}"  >
                 <input style="border:none"  type='text' id="newid" name="newid"  value= "" >   
<!--                <i class="str-info">Click on a entry to change.</i><i class="str-updated">(Last Refresh: <span id="str_updated">Never</span>)</i>-->
                <TABLE class= "STRtable"id="STRtable1" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR No:</TD>
<!--             "SZMW012516037733"-->
<!--                    \${fn:escapeXml(param.STRNumber)}-->
                     <td style="width:475px"><input   style="display:none;  width:100%;" type="text" id="_id" name="_id" value ="${replys.get("_id")}"  >${replys.get("_id")}</td>
                
                     <TD style="width:70px" bgcolor="lightgray">Status:</TD>
                     <TD  style="width:200px" ><input   style="display:table-cell; width:100%; color: red;" type="text" id="Status" name="Status" value =""   ></TD>
                    </TR>
                </TABLE>
                 <br>
                 <TABLE class= "STRtable" id="STRtable2" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">STR Title:</TD>
                     <TD style="width:770px" colspan="3"><input name="STR_TITLE" id="STR_TITLE"    type='text' style="border:none"   value="${replys.get("STR_TITLE")}"  ></TD>
                    </TR>
                    <TR>
                     <TD style="width:90px" bgcolor="lightgray">Engineer:</TD>
                    <TD style="width:450px" ><input  name="Engineer" id="Engineer"style="border:none" type='text' value="${replys.get("Engineer")}" ></TD>
                    <TD style="width:70px" bgcolor="lightgray">Sign-Off Date:</TD>
                    <TD style="width:200px" ><input  name="Date" id="Date" type="text" style="border:none"  value="${replys.get("Date")}"></TD>
                     </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Extension:</TD>
                    <TD style="width:450px" ><input  name="Ext" id="Ext" style="border:none" type='text' value="${replys.get("Ext")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Area:</TD>
                    <TD style="width:200px" ><textarea  id="Area"  readonly name="Area"  style="border: none"  ROWS=2  >${replys.get("Area")}</textarea></TD>
<!--                        <input disabled style="display:table-cell; width:100%;" type="text" id="Area" name="Area"  value ="${replys.get("Area")}" ></TD>-->
                    </TR>
                    <TR>
                     <TD style="width:90px"  bgcolor="lightgray">Dept:</TD>
                    <TD style="width:450px" ><input  id="Dept" name="Dept" style="border:none" type='text' value="${replys.get("Dept")}"/></TD>
                    <TD style="width:70px" bgcolor="lightgray">Final Report Date:</TD>
                    <TD style="width:200px" ><input  style="border:none" name="Final_Report_Date" id="Final_Report_Date" type="text" value="${replys.get("Final_Report_Date")}" ></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Type of Change:</TD>
                    <TD style="width:720px" colspan="3" ><button id="opener" class="opener" type="button" >Type Change</button><input style="border: 0px solid #000000;" name="TypeChange" id="TypeChange" type="text" value= "${replys.get("TypeChange")}" ><textarea  id="ChangeText"  readonly name="ChangeText"  style="border: none"  ROWS=2  >${replys.get("ChangeText")}</textarea></TD>
<!--                    <input   id="typechangeselected" style="width:100%; padding-left:0px; padding-right:0px;" type='text' value='Button - Selected Type of Change'/>-->
                    </TR>
                   <TR>
                    <TD style="width:90px" bgcolor="lightgray">Tool Qualification Selection:</TD>
                    <TD style="width:720px" colspan="3" ><button id="toolSelect" class="toolSelect" type="button" onclick="this.blur();selectTool();" >Select Tool</button>
                        <input style="border: 0px solid #000000;" name="Tool" id="Tool" type="text" value= "${replys.get("Tool")}" ></TD>
                    </TR>
                   <TR>
                   <TD style="width:90px" bgcolor="lightgray">Abstract:</TD>
                    <TD  style="width:720px"  colspan="3"  ><textarea  id="Abstract"  readonly name="Abstract"  style="border: none"  ROWS=4  > ${replys.get("Abstract")}</textarea></TD>
                    </TR>
                </TABLE>                    

  
        <ul>


        </ul>

<p><b>Lots Designated for STR:</b></p>
<!--              <i class="table-info">  </i> <i class="table-updated"> (Last Refresh: <span id="history_updated">Never</span>)</i>-->
             <TABLE class= "STRtable" id="STRtable3" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <TR>
                    <TD style="width:90px"  bgcolor="lightgray">Total Lots Requested:</TD>
                    <TD style="width:470px" ><input  id="Total_Lots" name="Total_Lots" style="border:none" type='text' value= "${replys.get("Total_Lots")}" ></TD>
                    <TD style="width:90px" bgcolor="lightgray">Are Lots Shippable?:</TD>
                    <TD style="width:200px" ><input id="Shippable" name="Shippable" style="border:none" type='text'value= "${replys.get("Shippable")}" ></TD>
                     </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Reliability Required:</TD>
                    <TD style="width:470px" > <input type="radio" id="ReliabilityRequired" name="ReliabilityRequired" value= "${replys.get("ReliabilityRequired")}">Yes<input type="radio" id="ReliabilityRequired_1" name="ReliabilityRequired" value= "${replys.get("ReliabilityRequired_1")}">No<input id="ReliabilityTestsI" name="ReliabilityTestsI"  type='hidden' value= "${replys.get("ReliabilityTestsI")}" ></TD>
                    <TD style="width:90px" bgcolor="lightgray">Select Reliability Tests That Are Required:</TD>
                    <TD style="width:200px" ><button id="RelTestButton" class="RelTestButton" type="button" onclick="this.blur();selectTests();">Select</button><input id="ReliabilityTests" name="ReliabilityTests" style="border:none" type='text' value= "${replys.get("ReliabilityTests")}" ></TD>
                    </TR>
                    <TR>
                    <TD style="width:90px" bgcolor="lightgray">Number of splits (2 Days/split):</TD>
                    <TD style="width:470px"  ><input  id="AddtionalTesting" name="AddtionalTesting" style="border:none" type="text"  value= "${replys.get("AdditionalTesting")}" ></TD> 
                    <TD style="width:90px" bgcolor="lightgray">Comment:</TD>
                    <TD style="width:200px"  ><input  id="AddtionalTestComment" name="AddtionalTestComment" style="border:none" type='text' value= "${replys.get("AddtionalTestComment")}" ></TD>
                    </TR>
                     <TR>
                    <TD style="width:90px" bgcolor="lightgray">Lots Converted to Proper Lot Type:</TD>
                    <TD style="width:760px" colspan="3"  ><input  id="LotTypeConv" name="LotTypeConv" style="border:none" type='text' value= "${replys.get("LotTypeConv")}"><input  id="LotTypeConvDate" name="LotTypeConvDate" style="border:none" type='text' value= "${replys.get("LotTypeConvDate")}"></TD>
                    </TR>
                </TABLE>
               <br>
                 <TABLE class= "STRtableLotApproval" id="STRtable4" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                    <th colspan="6" >LOTS DESIGNATED FOR STR</th>
                     <TR>
                     <th style="width:140px" bgcolor="lightgray">Device Full Pathname</th>
                    <th  style="width:110px"bgcolor="lightgray">Process</th>
                    <th  style="width:110px"bgcolor="lightgray">Lot No.</th>
                    <th  style="width:40px"bgcolor="lightgray" >SCM/PC Approval</th>
                     <th  style="width:240px"bgcolor="lightgray">Approver</th>
                     <th  style="width:130px" bgcolor="lightgray">Lot Converted to Proper Lot Type</th>
                       </TR>
                      
                </TABLE>
            <br>
            <p><b>Purpose of STR:</b></p>
            <TABLE class= "STRtable" id="STRtable5" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >Type the purpose, including the benefits and risks, for this STR inside this box.</th>
                      <TR >
                          <TD class="tdpurpose" > <textarea disabled style="border: none" id="Purpose" name="Purpose"   ROWS=1 >${replys.get("Purpose")}</textarea></TD>
                      </TR>
            </table>
            <br>


<p><b>STR Instructions: </b><div class="strinstructions" id="STR_INSTRUCTION" name="STR_INSTRUCTION" contenteditable="true" style="width: 870px;height: 300px;overflow: auto;border: 1px solid black">${replys.get("STR_INSTRUCTION")}</div></p>
          

          <br>
            <p><b>Success Criteria:</b></p>
            <TABLE class= "STRtable" id="STRtable6" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >What is the success criteria (null and alternative hypothesis) STR results must meet to move to the next stage</th>
                      <TR>
                          <TD  > <textarea  style="border: none"  name="STR_successcriteria" id="STR_successcriteria" ROWS=1 >${replys.get("STR_successcriteria")}</textarea></TD>
                      </TR>
            </table> 
           <br>
          <p><b>Success Plan:</b></p>
            <TABLE class= "STRtable" id="STRtable7" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                      <th style="width:870px" >If successful what is the next phase?</th>
                      <TR >
                          <TD > <textarea disabled style="border: none"  ROWS=1 name="STR_successplan" id="STR_successplan" >${replys.get("STR_successplan")}</textarea></TD>
                      </TR>
            </table>   
            <br>
            <p><b>Approver Groups:</b></p>
             <TABLE  class= "STRtable" id="STRtableApp" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                 <TR>
                 <th style="width:130px" bgcolor="lightgray">Approver Groups:</th>
                <th  style="width:470px"bgcolor="lightgray">Approvers:</th>
                <th  style="width:100px"bgcolor="lightgray">Action:</th>
                <th  style="width:150px"bgcolor="lightgray" >Date:</th>
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group1" name="Group1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group1")}' ></TD>    
                 <TD  style="width:470px"><input  id="Who1" name="Who1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who1")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken1" name="ActionTaken1" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken1")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate1" name="ActionDate1"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate1")}' "></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group2" name="Group2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group2")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who2" name="Who2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who2")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken2" name="ActionTaken2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken2")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate2" name="ActionDate2"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate2")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group3" name="Group3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group3")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who3" name="Who3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who3")}'></TD>
                 <TD  style="width:100px"><input  id="ActionTaken3" name="ActionTaken3"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken3")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate3" name="ActionDate3"  style="display:table-cell; width:100%;"type='text'value='${replys.get("ActionDate3")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group4" name="Group4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group4")}' ></TD>    
                <TD i style="width:470px"><input  id="Who4" name="Who4"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who4")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken4" name="ActionTaken4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken4")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate4" name="ActionDate4"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate4")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group5" name="Group5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group5")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who5" name="Who5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who5")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken5" name="ActionTaken5"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken5")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate5" name="ActionDate5"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionDate5")}' ></TD>    
                 </TR>
                 <TR>
                 <TD style="width:130px"><input  id="Group6" name="Group6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group6")}' ></TD>    
                <TD i style="width:470px"><input  id="Who6" name="Who6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who6")}'  ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken6" name="ActionTaken6"  style="display:table-cell; width:100%;" type='text'value='${replys.get("ActionTaken6")}' ></TD>    
                  <TD  style="width:150px"><input  id="ActionDate6" name="ActionDate6"  style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate6")}' ></TD>    
                 </TR>
                  <TR>
                 <TD style="width:130px"><input  id="Group7" name="Group7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Group7")}' ></TD>    
                 <TD i style="width:470px"><input  id="Who7" name="Who7"  style="display:table-cell; width:100%;" type='text' value='${replys.get("Who7")}' ></TD>
                 <TD  style="width:100px"><input  id="ActionTaken7" name="ActionTaken7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionTaken7")}' "></TD>    
                  <TD  style="width:150px"><input  id="ActionDate7" name="ActionDate7" style="display:table-cell; width:100%;" type='text' value='${replys.get("ActionDate7")}'></TD>    
                 </TR>
           </TABLE>
          <br>
             <p id="rejectioncomments"><b>Rejection Comments:</b></p>
            <TABLE class= "STRtable"id="STRtable9" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD  style="width:870px" ><textarea  disabled style="border: none"  id="ApprovalComments" name="ApprovalComments" ROWS=1 >${replys.get("ApprovalComments")}</textarea></TD>
                    </TR>
                </TABLE>
           <br> 
           <p id="SCMapprovalTitle" ><b>SCM/PC Approval Record:</b></p>
            <p><div   class= "STRtable" name="SCMRecord"  id="SCMRecord" contenteditable="true" style="width: 870px;height: 100px;overflow: auto;border: 1px solid black">${replys.get("SCMRecord")}</div></p>
           <br>
            <p id="lotchangerecord"><b>Lot Change Record:</b></p>
            <TABLE  class= "STRtable"id="STRtableLotChg" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Change Request Comments:</TD>
                     <TD style="width:770px" ><textarea  disabled  style="border: none"  ROWS=1  id="ChangeRequestComment"  name="ChangeRequestComment">${replys.get("ChangeRequestComment")}</textarea></TD>
                     </TR>
                     <TR>
                     <TD style="width:100px" bgcolor="lightgray">Lot Change Comments:</TD>
                     <TD style="width:770px" ><textarea  disabled style="border: none"  ROWS=1 id="LotChangeComment" name="LotChangeComment" >${replys.get("LotChangeComment")}</textarea></TD>
                    </TR>
                </TABLE>
            <br>
           <p id="strreportattachment"><b>STR Report Attachment:</b></p>
            <p id="strreportattachment2">Attach STR Report.</p>
           <p><div id="Attachments" name="Attachments"  id= "Attachments" class="strinstructions" contenteditable="true" style="width: 870px;height: 300px;overflow: auto;border: 1px solid black">${replys.get("Attachments")}</div></p>
            <p id="willGoIntoProductionTitle" ><b>Will the result of this STR evaluation go into production?</b><select name="goIntoProduction" id="goIntoProduction">        
                                <option value="Yes">Yes</option>
                                <option value="No">No</option>
                </select></p>
          <br>
          <p id="poststrattachment"><b>Post Completion Comments:</b></p>
            <p id="poststrattachment2">Comments to be added after a STR has completed.</p>
           <p><div id="PostCompletionComments" name="PostCompletionComments" contenteditable="true" class= "strinstructions"  style="width: 870px;height: 300px;overflow: auto;border: 1px solid black">${replys.get("PostCompletionComments")}</div></p>            
            
           <br>
            <p id="strdisposition"><b>STR Disposition:</b></p>
            <p id="strdisposition2" ><Font COLOR=RED  >->Reliability Test Burn In Boards:</Font></p> 
            <TABLE class= "STRtable" id="STRtableRburn" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Test Required?</TD>
            <TD  style="width:100px" ><input type="radio" name="RelTestReqDisp" id="RelTestReqDispY" value="yes"  >Yes<input type="radio" name="RelTestReqDisp" id="RelTestReqDispN" value="no">No<input id="RelTestReqDispI" name="RelTestReqDispI"  type='hidden' value= "${replys.get("RelTestReqDispI")}" ></TD>
            <TD style="width:50px" bgcolor="lightgray">Rel:</TD>
            <TD  style="width:400px" ><input id="RelTestMgr" name="RelTestMgr"  style="border: none" type='text' value='${replys.get("RelTestRelMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input id="RelTestDate" name="RelTestDate"  style="border: none" type='text' value='${replys.get("RelTestDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Reliability Tests:</TD>
            <TD  colspan="5" style="width:730px" ><input id="RelTestsList" name="RelTestsList" style="border: none" type='text' value='${replys.get("RelTestsList")}' ></TD>
             </TR>
              <TR>
            <TD style="width:100px"  bgcolor="lightgray">Rel Manager Comment About Reliability Tests:</TD>
            <TD  colspan="5" style="width:730px" ><input disabled id="Rel1Comment" name="Rel1Comment"  style="border: none" type='text' value='${replys.get("Rel1Comment")}' ></TD>
             </TR>
            </table>
            <p>Attach Reliability Report:<div id="Attachments_1" name="Attachments_1"  class= "strinstructions" contenteditable="true" style="width: 870px;height: 200px;overflow: auto;border: 1px solid black">${replys.get("Attachments_1")}</div></p>   
            <TABLE class= "STRtable" id="STRtableQA" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
            <TR>
            <TD style="width:100px"  bgcolor="lightgray">For Delivery to Customer</TD>
            <TD  style="width:100px" ><input   type="radio"  id="CustDeliveryY" name="CustDelivery" class="CustDelivery" value='yes'>Yes<input type="radio"  class="CustDelivery"  id="CustDeliveryN" name="CustDelivery" value='no'>No<input id="CustDeliveryI" name="CustDeliveryI"  type='hidden' value= "${replys.get("CustDeliveryI")}" ></TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD style="width:400px" ><input  id="CustDelQAMgr"  name="CustDelQAMgr"  style="border:none" type='text' value='${replys.get("CustDelQAMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input   id="CustDelDate"  name="CustDelDate"  style="border:none" type='text' value='${replys.get("CustDelDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:100px"  bgcolor="lightgray">Final Release to Production</TD>
            <TD  style="width:80px" ><input type="radio" id="RelToProductionY" name="RelToProduction" class="RelToProduction" value='yes'>Yes<input type="radio"  class="RelToProduction" id="RelToProductionN" name="RelToProduction" value='no' >No<input id="RelToProductionI" name="RelToProductionI"  type='hidden' value= "${replys.get("RelToProductionI")}" ></TD>
            <TD style="width:50px" bgcolor="lightgray">QA:</TD>
            <TD  style="width:400px" ><input id="RelProdQAMgr"  name="RelProdQAMgr"  style="border:none" type='text' value='${replys.get("RelProdQAMgr")}' ></TD>
            <TD style="width:50px" bgcolor="lightgray">Date:</TD>
            <TD  style="width:150px" ><input  id="RelProdDate"   name="RelProdDate"  style="border:none" type='text' value='${replys.get("RelProdDate")}' ></TD>
             </TR>
             <TR>
            <TD style="width:200px" colspan="2"  bgcolor="lightgray">QA Manager Comment About Deliverable Lots:</TD>
            <TD colspan="4" style="width:530px" ><textarea    style="border: none"  id="QA1Comment" name="QA1Comment" ROWS=1 >${replys.get("QA1Comment")}</textarea></TD>
             </TR>
              <TR>
            <TD style="width:200px"  colspan="2" bgcolor="lightgray">QA Manager Comment About Final Release to Prod</TD>
            <TD  colspan="4" style="width:530px" ><textarea    style="border: none"  id="QA2Comment" name="QA2Comment" ROWS=1 >${replys.get("QA2Comment")}</textarea></TD>
             </TR>
            </table>
            <br>
<!--            <div class="table12">-->
             <TABLE class= "STRtableGeneralApproval" id="STRtableDisp"  BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                   <TR>
                     <th style="width:100px" bgcolor="lightgray">Lot Number:</th>
                    <th  style="width:100px"bgcolor="lightgray">Lot Tracked Into STR_INV:</th>
                    <th  style="width:100px"bgcolor="lightgray">PCM Disposition:</th>
                    <th  style="width:100px"bgcolor="lightgray" >PLD Number:</th>
                     <th  style="width:200px"bgcolor="lightgray">PE Mgr OK to Ship Prior to STR Report:</th>
                     <th  style="width:100px" bgcolor="lightgray">Scrap Wafers:</th>
                     <th  style="width:130px" bgcolor="lightgray">Comment:</th>
                  </TR>
                  
             </table>
<!--            </div>-->
            <br>
             <p  class="qafeedback"><b>QA Feedback Section:</b></p>
            <TABLE  class= "STRtable" id="STRtableQAF" BORDER="2" CELLPADDING="2" CELLSPACING="2" >
                <TR >
                     <th style="width:200px" bgcolor="lightgray">STR-REL Submit Date</th>
                     <th style="width:200px" bgcolor="lightgray">QA Response Date:</th>
                     <th style="width:520px" bgcolor="lightgray">QA Response Comments:</th>
                     </TR>
                  <TR >
                       <TD  style="width:200px" ><input   id="STRSubDate"   name="STRSubDate"  style="border:none" type='text' value='${replys.get("STRSubDate")}' ></TD>
                       <TD  style="width:200px" ><input  id="QAFeedbackDate1"   name="QAFeedbackDate1"  style="border:none" type='text' value='${replys.get("QAFeedbackDate1")}' ></TD>  
                       <TD  style="width:520px" ><textarea   style="border: none"  id="QAFeedback1" name="QAFeedback1" ROWS=1 >${replys.get("QAFeedback1")}</textarea></TD>    
                         
                      </TR>
            </table>
             <br>
            <p  class="revisionhistory"><b>Revision History:</b></p> 
            <TABLE   class= "STRtable" id="STRtable14" BORDER="0" CELLPADDING="2" CELLSPACING="2" >
                <tr>
                <TD  style="width:750px" ><textarea    style="border: none"  ROWS=5 id="UpdatedByRevisions" name="UpdatedByRevisions" >${replys.get("UpdatedByRevisions")}</textarea></TD>    
                </tr>
               
            </TABLE>
                  <script>
            //Add textarea (must be textarea to allow large files) after all contenteditable fields to receive HTML during submission
           
  var textareas ;          
            $('[contenteditable]').each(function(i,e) {
                e = $(e);
                e.after($('<textarea>').attr('name',e.attr('name')).hide()).wysiwyg();
                
            });
//            $("#STRtitle").val(<
 //       %= newSTRtitle %>);
//            //Have all forms copy editable content to the adjacent input before submitting
            $('#myForm').on('submit', function() {
                $(this).find('[contenteditable]').each(function(i,e) {
                   
                    e=$(e);
                     
 
                          e.next('textarea').val(e.html());

                  textareas = e;
                });

            });
        </script>
      </div>
            
  </form>
       <div id="selectLots" class="selectLots" style="display: none">        
   <form class= "LotGroup1" id="formAddLots" action="#" title="Add Lots"  width="auto" >

                  <legend>Search for Appropriate Lots : Enter 4 or more characters for Part or Process Search.</legend> 
                  <TABLE class= "SearchTable"id="SearchTable" BORDER="2" CELLPADDING="2" CELLSPACING="2"  >
                  <TR>
                     <TD style="width:100px" bgcolor="lightgray">Part#:</TD>
                     <TD style="width:150px" colspan="2"><input name="SearchPart" id="SearchPart"    type='text' style="border:none"   value="${replys.get("SearchPart")}"  ></TD>
                    <TD style="width:100px" bgcolor="lightgray"> OR Process:</TD>
                    <TD style="width:150px" colspan="2"><input  name="SearchProcess" id="SearchProcess" style="border:none" type='text' value="${replys.get("SearchProcess")}" ></TD>
                    </tr>
                     <tr>
                    <TD style="width:100px" bgcolor="lightgray">Wafers # > :</TD>
                    <TD style="width:100px" ><input name="Wafers" id="Wafers" type="number" style="border:none"  value="${replys.get("Wafers")}"></TD>
                     <TD style="width:100px" bgcolor="lightgray">Priority:</TD>
                    <TD style="width:100px" ><select name="Priority" id="Priority" size="1">  
                                 <option value="not used">not used</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                        </select></TD>
                    <TD style="width:100px" bgcolor="lightgray">Lot Type:</TD>
                    <TD style="width:100px" ><input name="LotType" id="LotType" type="text" style="border:none"  value="${replys.get("LotType")}"></TD>
                     </tr>
                    <tr>
                    <TD style="width:100px" bgcolor="lightgray">Lots Not Past Stage:</TD>
                    <TD style="width:150px" colspan="2" ><input name="LotsStage" id="LotsStage" type="text" style="border:none""  value="${replys.get("LotsStage")}"></TD>
                     <TD style="width:100px" bgcolor="lightgray">Exclude PLD Lots:</TD>
                    <TD style="width:150px"  colspan="2" ><input type="checkbox" id="ExcludePLDs" name="ExcludePLDs" >Yes</TD>
                     </tr>
                    <tr>
                        <TD style="width:100px"   colspan="2" ><button id="ClearSearchEntries" name="ClearSearchEntries" type="button" style="display:table-cell; width:100%;"onclick="this.blur();">Clear Search</button></td>   
                     <TD style="width:100px" colspan="2"><button id="Search" name="Search" type="button" style="border:none" >Search</button></td>
                     </TR>
                  </table>
                     <br>
           <div style="width: 100%;">
               <div id="fromList" class="toolbar" style="width: 50%; float: left;">
                   <caption>
                            Table 1: <i>Select Lots For This STR</i>
                        </caption>
                  <table id="lotList" class="inlineTable" style="display: inline-block; border: 1px solid; float: left;" cellspacing="0"   >
                      
                    <thead>
                        <tr>
                            <th>LOT</th>
                            <th>PART</th>
                            <th>PROCESS</th>
                        </tr>
                    </thead>
                   <tbody  class="selectable" align="center">

                    </tbody>
                </table>
            </div>  
                
            <div id="toList" style="width: 50%; float:left;">   
                 <caption>
                            Table 2: <i>Lots Designated For This STR</i>
                        </caption>
                <table id ="lotsToSave" class="inlineTable"  style="display: inline-block; border: 1px solid; float: left;" cellspacing="0"  >
                         <thead>
                        <tr>
                            <th>LOT</th>
                            <th>PART</th>
                            <th>PROCESS</th>
                        </tr>
                    </thead>
                     <tbody  class="selectable" align="center">

                    </tbody>
                </table>
            </div>
              
          </div>
            
        </form>
        </div>             
            <div id="openerform" class="openerform" title="Select Type of Change" style="display: none">
                <form name="opendialog" action="#" id="opendialog">

             <fieldset class="radiogroup" id="radiogroup" name="radiogroup">
                 <legend>Select the appropriate change type</legend> 
                  <p>
                  <input type="radio" id="radio1" name="Typec" class="Typec" value="Type 1" /><label for="radio1"><b>Type 1 Change:</b><br> This is a change that might impact cost or capacity, but will most likely not impact electrical performance,reliability or quality. Type 1 changes do not have to be reported to the customer.<br></label>
                  <input type="radio" id="radio2" name="Typec" class="Typec" value="Type 2" /><label for="radio2"><b>Type 2 Change:</b><br> This is a change that might impact electrical performance, reliability or cost [yield], fab capacity or quality of the customer's product. A typical type 2 change may require two CCB reviews. This first review will include the results evaluation and implementation plan. A subsequent review may be required upon completion of the evaluation and when the CCB determines that customer notification is required, a PCN [FCD 0673] must be generated by the Project Champion. The PCN must be distributed to all CCB members for review prior to the second CCB meeting.<br></label>
                  <input type="radio" id="radio3" name="Typec" class="Typec" value="Type 3" /><label for="radio3"><b>Type 3 Change:</b><br> This is a significant change that will impact electrical performance, reliability, cost [yield], fab capacity or quality of the customer's product. Type 3 changes must be reviewed by the CCB.  Customer notification is required. A PCN [FCD 0673] must be generated by the Project Chanpion and distributed prior to CCB review. The PCN must be distributed to all CCB members prior to CCB review.</label>
                  </p>
             </fieldset>
      </form>
       </div>
       <div id="setupSelect" class="setupSelect" style="display: none">        
                 <form class= "setupSelect" id="setupSelect" action="#" title="Setup New STR"  style="overflow:hidden" width="auto" >
                    <div style="width: 100%;">
                        <div id="location" class="location" style="width: 20%; float: left;">
                        <legend>Select Location</legend> 
                        <select name="location" id="location" size="4">        
                                <option value="Fab1">Fab1</option>
                                <option value="Fab2">Fab2</option>
                                <option value="Fab3">Fab3</option>
                                <option value="Fab4">Fab4</option>
                        </select>
                        </div>
                  <div id="primaryList" class="primaryList" style="width: 40%; float: left;">
                   <caption>
                             <i>Select Primary Area</i>
                        </caption>
                       <select name="primaryArea" id="primaryArea" size="10">        
                                <option value="APT">APT</option>
                                <option value="Diffusion">Diffusion</option>
                                <option value="ETCH">ETCH</option>
                                <option value="Implant">Implant</option>
                                <option value="MAP">MAP</option>
                                <option value="METAL">METAL</option>
                                <option value="NVL/CMP/WET">NVL/CMP/WET</option>
                                <option value="Photo">Photo</option>
                                <option value="QA">QA</option>
                                <option value="Scribe">Scribe</option>
                        </select>
                     </div>    
                <div id="secondaryList" class="secondaryList" style="width: 40%; float: left;">
                 <caption>
                             <i>Select Secondary Areas</i>
                        </caption>
                    <select name="secondaryArea" id="secondaryArea" multiple="multiple" size="10">        
                                <option value="APT">APT</option>
                                <option value="Diffusion">Diffusion</option>
                                <option value="ETCH">ETCH</option>
                                <option value="Implant">Implant</option>
                                <option value="MAP">MAP</option>
                                <option value="METAL">METAL</option>
                                <option value="NVL/CMP/WET">NVL/CMP/WET</option>
                                <option value="Photo">Photo</option>
                                <option value="QA">QA</option>
                                <option value="Scribe">Scribe</option>
                        </select>
                     </div>    
                   </div>         
                </form>
        </div>
        <div id="selectRTest" class="selectRTest" style="display: none">        
                 <form class= "selectRTest" id="selectRTest" action="#" title="Select Reliability Tests"  style="overflow:hidden" width="auto" >
                   
                <div id="selectRList" class="selectRList" >
               
                        <select name="selectRL" id="selectRL" multiple="multiple" size="4">        
                                <option value="TC/TS">TC/TS</option>
                                <option value="Operating Life">Operating Life</option>
                                <option value="Electromigration">Electromigration</option>
                                <option value="Autoclave">Autoclave</option>
                                
                        </select>
                     </div>    
                   </form>
             </div>   
              <div id="selectQTool" class="selectQTool" style="display: none">        
                 <form class= "selectQTool" id="formSelectQTool" action="#" title="Search and Select Tool"   width="auto" >
                  <legend>Search for Appropriate Tool : Enter 3 or more characters for Search.</legend> 
                  <TABLE class= "SearchToolT"id="SearchToolT" BORDER="2" CELLPADDING="2" CELLSPACING="2"  >
                  <TR>
                     <TD style="width:100px" bgcolor="lightgray">Tool ID:</TD>
                     <TD style="width:100px" colspan="1"><input name="SearchTool" id="SearchTool"    type='text' style="display:table-cell; width:100%;"   value="${replys.get("SearchTool")}"  ></TD>
                  </tr>   
                  <tr>
                      <TD style="width:100px" colspan="2"><button id="SearchT" name="SearchT" type="button" style="display:table-cell; width:100%;" >Search</button></td>
                    </tr>
                 </table>
                 <caption>
                     <i>Select a Tool For This STR</i>
                </caption>
                  <br>
                <div id="fromTool" class="toolbar" >
                <table id ="toolToSave"   style="display: inline-block; border: 1px solid; width:100%" cellspacing="0"   >
                         <thead>
                        <tr>
                            <th>EQPID</th>
                       </tr>
                    </thead>
                     <tbody  class="selectable" align="center"  >

                    </tbody>
                </table>   
               </form>
             </div>
             </div>           
            <div id="divAapprovalGroup" class="divApprovalGroup" style="display: none">        
                 <form class= "formApprovalGroup" id="formApprovalGroup" action="#" title="Select approvers for sending approval requests"  style="overflow:hidden" width="auto" >
                   <legend>Select approvers</legend>
                         <div id="approvalGList" class="approvalGList" >
                         <select name="selectApprover" id="selectApprover"  size="8"  multiple="multiple">        

                         </select>
                     </div>    
                   </form>
             </div>
           <div id="divNeedSplits" class="NeedSplits" style="display: none">        
                 <form class= "NeedSplits" id="formNeedSplits" action="#" title="STR Entries Are Needed Before Approval"  style="overflow:hidden" width="auto" >
                     <legend>Please be sure that: There is a title for this STR, the STR Purpose is entered and the number of splits for this STR is completed before proceeding.</legend>
                 </form>    
          </div>
           <div id="divSCMNeedLots" class="SCMNeedLots" style="display: none">        
                 <form class= "SCMNeedLots" id="formSCMNeedLots" action="#" title="Lots Needed For This STR"  style="overflow:hidden" width="auto" >
                     <legend>Please add Lots for this STR before proceeding.</legend>
                 </form>    
          </div>   
          <div id="divConfirmApproval" class="ConfirmApproval" style="display: none">        
                 <form class= "ConfirmApproval" id="formConfirmApproval" action="#" title="Confirm Approval"  style="overflow:hidden" width="auto" >
                     <legend>Do you want to approve this STR at this stage? Please confirm.</legend>
                     <p id="noLotsSelected" style="display: none"><b>Please select Lots to approve before proceeding.</b></p>
                 </form>    
          </div>
           <div id="divConfirmRejection" class="ConfirmRejection" style="display: none">        
                 <form class= "ConfirmRejection" id="formConfirmRejection" action="#" title="Confirm Rejection"  style="overflow:hidden" width="auto" >
                     <legend>By rejecting this STR you prevent any further modifications to it.  Do you wish to reject this STR?</legend>
                 </form>    
          </div>   
           <div id="divAllHoldsPlaced" class="AllHoldsPlaced" style="display: none">        
                 <form class= "AllHoldsPlaced" id="formAllHoldsPlaced" action="#" title="!! All Holds Placed !!"  style="overflow:hidden" width="auto" >
                     <legend>Have you placed all necessary holds on lots(This does not apply to new lot starts)?</legend>
                 </form>    
          </div> 
          <div id="divPresentationDate" class="PresentationDate" style="display: none">        
                 <form class= "PresentationDate" id="formPresentationDate" action="#" title="Select Presentation Date"  style="overflow:hidden" width="auto" >
                     <legend>Please select the date you would like to present your STR. Meeting Days are Monday, Wednesday or Friday</legend>
                     <input  name="PresentationDate" id="PresentationDate" type="text" style="display:table-cell; width:100%;"  value="${replys.get("Final_Report_Date")}"/>
                 </form>    
          </div>              
            <div id="divAreaManagerComments" class="AreaManagerComments" style="display: none">        
                 <form class= "AreaManagerComments" id="formAreaManagerComments" action="#" title="Area Manager's Comments"  style="overflow:hidden" width="auto" >
                     <fieldset class="radiogroup2" id="radiogroup2" name="radiogroup2">
                     <legend>Will all wafers from lots be shippable after STR completion?</legend>
                      <legend>(Chose Partial if less than all are shippable):</legend>
                      <p>
                        <input type="radio" id="radio1" name="Type" value="Yes" /><label for="radio1"><b>Yes</b></label>
                        <input type="radio" id="radio2" name="Type" value="No" /><label for="radio2"><b>No</b></label>
                        <input type="radio" id="radio3" name="Type" value="Partial" /><label for="radio3"><b>Partial</b></label>
                        </p>
                   </fieldset>
                 </form>    
          </div> 
          <div id="divQAManagerComments" class="QAManagerComments" style="display: none">        
                 <form class= "QAManagerComments" id="formQAManagerComments" action="#" title="QA Manager's Comments"  style="overflow:hidden" width="auto" >
                     <fieldset class="radiogroup3" id="radiogroup3" name="radiogroup3">
                     <legend>Will parts be delivered to customer?</legend>
                      <p>
                        <input type="radio" id="radio1a" name="Type1" value="Yes"/><label for="radio1a"><b>Yes</b></label>
                        <input type="radio" id="radio2a" name="Type1"  value="No" /><label for="radio2a"><b>No</b></label>
                         </p>
                          </fieldset>
                       <legend>Add comments about lots being deliverable (optional)</legend>  
                       <textarea   style="border: solid #000000 thin"  id="QAMComment1" name="QAMComment1" ROWS=3 ></textarea>
                       <fieldset class="radiogroup4" id="radiogroup4" name="radiogroup4">
                       <legend>Final release to production?</legend>
                      <p>
                          
                        <input type="radio" id="radio1b" name="Type2" value="Yes" /><label for="radio1b"><b>Yes</b></label>
                        <input type="radio" id="radio2b" name="Type2" value="No" /><label for="radio2b"><b>No</b></label>
                         </p>
                          </fieldset>
                       <legend>Add comments about final release to production (optional)</legend>  
                       <textarea   style="border: solid #000000 thin"  id="QAMComment2" name="QAMComment2" ROWS=3 ></textarea>
                  
                 </form>    
          </div>
          <div id="divSTRReportNotAttached" class="STRReportNotAttached" style="display: none">        
                 <form class= "STRReportNotAttached" id="formSTRReportNotAttached" action="#" title="STR Report is needed"  style="overflow:hidden" width="auto" >
                     <legend>STR Report is not attached. Please attach the report before changed the status to Completed</legend>
                 </form>    
          </div>   
           <div id="divSTRDispNotComplete" class="STRDispNotComplete" style="display: none">        
                 <form class= "STRDispNotComplete" id="formSTRDispNotComplete" action="#" title="STR Disposition Section Not Complete"  style="overflow:hidden" width="auto" >
                     <legend>You must complete the STR disposition section for all lots prior to changing the status to Complete</legend>
                 </form>    
          </div>
          <div id="divBriefAbstract" class="BriefAbstract" style="display: none">        
                 <form class= "BriefAbstract" id="formBriefAbstract" action="#" title="Abstract About STR"  style="overflow:hidden" width="auto" >
                     <legend>Please add brief abstract about this STR (4 - 5 lines).</legend>
                      <textarea   style="border: solid #000000 thin"  id="AbstractAboutSTR" name="AbstractAbout STR" ROWS=7 ></textarea>
                 </form>    
          </div>
          <div id="divQAMFeedback" class="QAMFeedback" style="display: none">        
                 <form class= "QAMFeedback" id="formQAMFeedback" action="#" title="QA Manager's Feedback"  style="overflow:hidden" width="auto" >
                     <legend>Please add comments regarding problem with STR</legend>
                      <textarea   style="border: solid #000000 thin"  id="QAMFeedbackT" name="QAMFeedbackT" ROWS=7 ></textarea>
                 </form>    
          </div>
           <div id="divChangeLots" class="ChangeLots" style="display: none">        
                 <form class= "ChangeLots" id="formChangeLots" action="#" title="Modify Lots"  style="overflow:hidden" width="auto" >
                     <legend>Please give details of the lot(s) changed and the reason for the change.</legend>
                     <legend>Please be specific. If lot(s) are bing replaced, please list old lot number followed by lot number for replacement lot.</legend>
                     <legend>If lot(s) are being added, please state which lot(s) were added subsequent to STR signoff.</legend>
                      <textarea   style="border: solid #000000 thin"  id="ChangeLotsSTR" name="ChangeLotsSTR" ROWS=7 ></textarea>
                 </form>    
          </div>
           <div id="divRequestLotChange" class="RequestLotChange" style="display: none">        
                 <form class= "RequestLotChange" id="formRequestLotChange" action="#" title="Modify Lots"  style="overflow:hidden" width="auto" >
                     <legend>Please enter lot change request. Please be specific including explanation as to why lot change request is being made.</legend>
                     <textarea   style="border: solid #000000 thin"  id="RequestChangeLots" name="RequestChangeLots" ROWS=7 ></textarea>
                 </form>    
          </div>
           <div id="divPEMgrOKShip" class="PEMgrOKShip" style="display: none">        
                 <form class= "PEMgrOKShip" id="formPEMgrOKShip" action="#" title="Select Lots To Ship"  style="overflow:hidden" width="auto" >
                     <legend>Please select lot(s) that you would like shipped</legend>
                    <div id="shipList" class="shipList" >
                       <table id ="PEtable"   style="display: inline-block; border: 1px solid; width:100%" cellspacing="0"   >
                     <tbody  class="PEbody" align="center"  >

                    </tbody>
                </table>    
                  </div>    
              </form>    
          </div>       
         <div id="divCloseSTR" class="CloseSTR" style="display: none">        
                 <form class= "CloseSTR" id="formCloseSTR" action="#" title="CloseSTR"  style="overflow:hidden" width="auto" >
                     <legend>Select response YES if all STR lots have been dispositioned (shipped/scrapped). Selecting YES will close the STR, and no further changes to the STR document will be allowed. Select response NO if all lots have not been dispositioned.</legend>
                 </form>    
          </div>
          <div id="divResetSTR" class="ResetSTR" style="display: none">        
                 <form class= "ResetSTR" id="formResetSTR" action="#" title="Continue?"  style="overflow:hidden" width="auto" >
                     <legend>Do you want to reset the STR? Resetting the STR will put the STR status to "Pending Lot Approval".</legend>
                 </form>    
          </div>
          <div id="divDuplicateSTR" class="DuplicateSTR" style="display: none">        
                 <form class= "DuplicateSTR" id="formDuplicateSTR" action="#" title="Confirmation"  style="overflow:hidden" width="auto" >
                     <legend>Do you want to create a duplicate of this STR. Please confirm.</legend>
                 </form>    
          </div>
           <div id="divNewSettingsValid" class="NewSettingsValid" style="display: none">        
                 <form class= "NewSettingsValid" id="formNewSettingsValid" action="#" title="Settings Not Complete"  style="overflow:hidden" width="auto" >
                     <legend>Please Select a Site and Primary Area to Proceed.</legend>
                 </form>    
          </div> 
           <div id="divPartorProcessErr" class="PartorProcessErr" style="display: none">        
                 <form class= "PartorProcessErr" id="formPartorProcessErr" action="#" title="Additional Part or Process Entry Needed"  style="overflow:hidden" width="auto" >
                     <legend>Please Enter At Least 4 Characters to Search on Part or Process .</legend>
                 </form>    
          </div>
           <div id="divAddLotsEmpty" class="AddLotsEmpty" style="display: none">        
                 <form class= "AddLotsEmpty" id="formAddLotsEmpty" action="#" title="No Lots Selected For STR"  style="overflow:hidden" width="auto" >
                     <legend>Please Select and Add Lots To Table 2 to Save Them to the STR </legend>
                 </form>    
          </div>             
        </div>
      
   
            <script>
 //var typesTable;
 var lotsList;
 var lotsToSave;
 var toolsToSave;
 var searchTable;
 var gformAddLots;
 var tr ;
 var clickedRow;
 var option;
 var clickedRowHistory; 
 var nextRowAdd=0;
 var cancelAdd = 0;
 //var heightOffset = 115;
 var editorTest;
    $(document).ready(function () {
       //alert("document ready status is " + status);
       //$("#Status").val(status);
        //$('input[type=text].Status').val(status);
        //$('#Status').val(status);
      
      lotsList =  $("#lotList").DataTable({
                   // "dom": '<"top">Bifrt',
                    "dom": 'rt',
//                    buttons: [
//                        { text: 'Add' , action: function ( e, dt, node, config ) {typesAdd(); } },
//                        { text: 'Remove' , action: function ( e, dt, node, config ) {typesRemove(); } },
//                        { text: 'Copy' , action: function ( e, dt, node, config ) {typesCopy(); } }
//                    ],
                    
                   // "processing": true,
                    //"paginationType": "full_numbers",
                    "jQueryUI": true,
                    "scrollY":   "200px",
                    "scrollX": "100%",
                    //"scrollY": "10vh",
                    //"scrollCollapse": true, //clears the table - inadvertantly
                    "scrollXInner": "100%",
                    paging: false,
                    "columns": [
                        {"name": "LOT" ,
                            "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"
                        },
                        {"name": "PART",
                                "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"},
                        {"name": "PROCESS",
                        "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"}
                    ]
                });  
                $('#lotList tbody').on( 'click', 'tr', function () {
                    $(this).toggleClass('selected');
                } );
                 //$(".dataTables_wrapper").css("width","98%"); //this keeps the datatable inside the dialog
                //$("div.toolbar").html('<b>Select Lots From the List Below</b>');
                //$("#lotList_wrapper").css("width","50%");
                 lotsToSave =  $("#lotsToSave").DataTable({
                   // "dom": '<"top">Bifrt',
                    "dom": 'rt',
//                    buttons: [
//                        { text: 'Add' , action: function ( e, dt, node, config ) {typesAdd(); } },
//                        { text: 'Remove' , action: function ( e, dt, node, config ) {typesRemove(); } },
//                        { text: 'Copy' , action: function ( e, dt, node, config ) {typesCopy(); } }
//                    ],
                    
                   // "processing": true,
                    //"paginationType": "full_numbers",
                    "jQueryUI": true,
                    "scrollY":   "200px",
                    "scrollX": "100%",
                    
                   // "scrollCollapse": true, //clears the table - inadvertantly
                    "scrollXInner": "100%",
                    paging: false,
                    "columns": [
                        {"name": "LOT" ,
                            "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"
                        },
                        {"name": "PART",
                                "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"},
                        {"name": "PROCESS",
                        "searchable": false,
                            "sortable": false,
                            "visible": true,
                            className: "noteditable"}
                    ]
                });  
                $('#lotsToSave tbody').on( 'click', 'tr', function () {
                    $(this).toggleClass('selected');
                } );
                // $(".dataTables_wrapper").css("width","98%"); //this keeps the datatable inside the dialog
               // $(".dataTables_wrapper").css("width","98%"); //this keeps the datatable from using more than 50% of the dialog window
              // $(".dataTables_wrapper").css("width","50%"); //this keeps the datatable from using more than 50% of the dialog window
             toolsToSave =  $("#toolToSave").DataTable({
                 "dom": 'rt',
                    "jQueryUI": true,
                    "scrollY":    "200px",
                    "scrollX": "100%",
                    "scrollXInner": "105%",
                    paging: false,
                    "columns": [
                    {"name": "EQPID" ,
                        "searchable": false,
                        "sortable": false,
                        "visible": true,
                        className: "noteditable"
                    }
                    ]
                });  
                $('#toolToSave tbody').on( 'click', 'tr', function () {
                    $(this).toggleClass('selected');
                } );
                $(".dataTables_wrapper").css("width","98%"); //this keeps the datatable inside the dialog
                //$(".dataTables_wrapper").css("height","50%"); //this keeps the datatable inside the dialog
              // $(".dataTables_wrapper").css("width","50%")
    });       

var typesRefresh;
var typesAdd;
var typesCopy;
var changeType;
var addModifyLots;
var addLotsToSTR;
var typesRemove;
var select1;
var historyRemove;
var setupSelections;
var selectTests;
var selectTool;
var selectApprover;
var selectRejection;
var confirmCloseSTR;
var resetSTR;
var duplicateSTR;
var loginAsApprover;
var loginAsOther;
var loginAsAdmin;
var requestLotChanges;
var PEshipLots;

$(function() {
        var theDialog=$( "#openerform" ).dialog({
            autoOpen:false,
             height: 600,
                width: 600,
                title: 'Select Type of Change',
                //addModifyLots2 
                buttons: {
                    
                   
                    'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                        $(this).dialog('close');
                        }, 
                      'OK' : function () {
                        cancelAdd = 0;
                       var selected = $(".Typec:checked");
                                $('#ChangeText').val( selected.next().text());
                                //$('#ChangeText').val($("idVal").text().substring(0));
                                $('#TypeChange').val(selected.val());
                        
                        $(this).dialog('close');
                        //save();
                         }
              }
        
        
        });
        $("#opener").click(function(evt){
             theDialog.dialog('open');
             return false;
        });
         selectTool = function () {
          $( "#selectQTool" ).dialog({
               
            open: function() {
              
             },
             height: 600,
              width: 300,
             
                title: 'Select EQP ID',
                //need to add lots to the lotsToSave dialog that are already in the STR
              
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
//                            var selected="";
//                             var multipleValues = [];
//                             $("#toolToSave tr td").find('td.highlight-selected').each(function(){ 
//                                //if ( $(this.cell.data()).is(selected)) ) {
//                                    alert($(this).text());
//                                    multipleValues.push($(this).text()); 
//                                 // }
//                             });
                              var table = toolsToSave;

                            var ids = $.map(table.rows('.selected').data(), function (item) {
                                       return item;
                           });
                           //alert(ids.toString());
                            $("#Tool").val(ids.toString());
                            $(this).dialog('close');
                           // save();
                        }
                    },
                     resizeStop: function(event, ui) {
                    //alert("Width: " + $(this).outerWidth() + ", height: " + $(this).outerHeight());    
                    var heightOffset = 170;
                    var cHeight = $(this).height();
                    //alert(cHeight);
                    var dHeight = 0;
                    var oSettings = $('#toolToSave').dataTable().fnSettings();
                    oSettings.oScroll.sY = dHeight + "px";
                    $(".dataTables_scrollBody").height(cHeight - heightOffset);
                    
                 }
                    
                }); 
           
       //addModifyLots2();
    }; 
      $("#SearchT").click(function(evt){
                //alert("search entries clicked");
                //call servlet to return Promis query results
                var toolVal = $("#SearchTool").val();
                
                 var obj = {
                add:[]
                 };
                //var pk22 = values["reticle"];
                //var pk33 = values["stock"];
                obj.add[obj.add.length] = {
                    tool: toolVal
                  };
                  //alert(toolVal);
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                if (obj.length!==0) {
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                   $.ajax({ url:"/STRX8654/SearchPromisEQ",
                    method: "POST",
                    data: JSON.stringify(obj) 
                }).done(function(msg) {
                   var json = JSON.parse(msg);
                    $("toolToSave th").css("width", "0px");
                    //alert(msg);
                    var table =  toolsToSave;
                    table.clear();
                    table.rows.add(json.tools);
                    table.column( '0' ).order( 'asc' );
                    table.draw();
                });
            }
    
            
        });
        //the script below triggers a search when the enter key is hit inside the Part or Process search field
        $('#SearchTool').keypress(function (e) {
            var key = e.which;
            
            if(key === 13 )  // the enter key code
             {
               
               $("#SearchT").click();
               return false;  
             }
           });   
            
        $("#ClearSearchEntries").click(function(evt){
               $("#SearchPart").val("");
               $("#SearchProcess").val("");
               $("#Wafers").val(0);
               $("#Priority").val("not used");
               $("#LotType").val("");
        });
        //the Search button is on the Lots for STR dialog window and returns lots from Promis
         $("#Search").click(function(evt){
                //alert("search entries clicked");
                if($("#SearchPart").val().toString().length < 4 && $("#SearchProcess").val().toString().length < 4  ){
                        $( "#formPartorProcessErr" ).dialog({
                        width: 500,
                         buttons: {

                             'OK' : function () {

                               $(this).dialog('close');

                           }
                         }
                     }); 
               } else {
                //call servlet to return Promis query results
                var partVal = $("#SearchPart").val();
                var processVal = $("#SearchProcess").val();
                var wafersVal = $("#Wafers").val();
                var priorityVal = $("#Priority").val();
                var lottypeVal = $("#LotType").val();
                var pldlotexVal = "";
                if($('#ExcludePLDs').is(':checked')) {
                         pldlotexVal = "yes";
                     }        
                 var obj = {
                add:[]
                 };
                //var pk22 = values["reticle"];
                //var pk33 = values["stock"];
                obj.add[obj.add.length] = {
                    part: partVal,
                    process: processVal,
                    wafers: wafersVal,
                    priority: priorityVal,
                    lottype: lottypeVal,
                    pldlotex: pldlotexVal
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                if (obj.length!==0) {
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                   $.ajax({ url:"/STRX8654/SearchPromisTlog",
                    method: "POST",
                    data: JSON.stringify(obj) 
                }).done(function(msg) {
                    setTable(msg);
                });
            }
    
        }  
        });
   
        //the script below triggers a search when the enter key is hit inside the Part or Process search field
        $('#SearchPart').keypress(function (e) {
            var key = e.which;
            // alert($("#SearchPart").val().toString().length);
//            if($("#SearchPart").val().toString().length > 2 || $("#SearchProcess").val().toString().length > 2) {
//               
//                $("#Search").prop("disabled", false);
//            } else {
//                $("#Search").prop("disabled", true);
//            }
            if(key === 13 )  // the enter key code
               
             {
               $("#Search").click();
               return false;  
             }
           });   
            $('#SearchProcess').keypress(function (e) {
            var key = e.which;
             //alert($("#SearchProcess").val().toString().length);
//            if($("#SearchPart").val().toString().length > 2 || $("#SearchProcess").val().toString().length > 2) {
//                $("#Search").prop("disabled", false);
//            } else {
//                $("#Search").prop("disabled", true);
//            }
            if(key === 13 )  // the enter key code
             {
               $("#Search").click();
               return false;  
             }
           });   
    });
            var ajax = function(options) {
            var ret = {
                r: $.ajax(options),
                callback: null,
                done: function(callback) {
                    ret.r.done(function(msg, status, xhr) {

                            callback(msg, status, xhr);

                    });
                }
            };
            ret.r.fail(function(xhr, status, error) {
                $('#header_error_message').html(xhr.responseText);
                $('#header_error').dialog({
                    width: "auto",
                    minHeight: "0px",
                    resizable: false,
                    modal: true,
                    position:{ my: 'center', at: 'center', of: window }
                });
            });
            return ret;
        };
 (function() {
    editSTR = function(){
         EditButtonClicked = 1;
         $("#editSTR").hide();
         setSTRFieldsEdit();
        };
     addLotsToSTR = function() {
            //var lundo;

    };      
    confirmCloseSTR = function () { 
        
       if(status.indexOf("STR Complete" ) > -1 ){ 
         //  alert(status);
         $( "#formCloseSTR" ).dialog({
             buttons: {
                  'Yes' : function () {
                       $('#Status').prop('disabled',false);
                       $("#Status").val("STR Closed");
                       $('#UpdatedByRevisions').prop('disabled',false); 
                        $('#UpdatedByRevisions').prop('readonly',false); 
                        //update revision history and then submit changes to save permanately
                        var lastrev = $('#UpdatedByRevisions').val().toString();
                        $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                       $(this).dialog('close');
                        save();
                        }, 
                     'No' : function () {
                          $(this).dialog('close');
                     }
             }
         });
     }
    }; 
       resetSTR = function () { 
        
       if(status.indexOf(" Lot " ) < 0 && status.indexOf(" Area ") < 0 && status.indexOf( "Draft" ) < 0 ){ 
         //  alert(status);
         $( "#formResetSTR" ).dialog({
             buttons: {
                  'Yes' : function () {
                       $('#Status').prop('disabled',false);
                       $("#Status").val("Pending SCM Lot Approval");
                       $('#UpdatedByRevisions').prop('disabled',false); 
                        $('#UpdatedByRevisions').prop('readonly',false); 
                        //update revision history and then submit changes to save permanately
                        var lastrev = $('#UpdatedByRevisions').val().toString();
                        $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                       $(this).dialog('close');
                        save();
                        }, 
                     'No' : function () {
                          $(this).dialog('close');
                     }
             }
         });
     }
    }; 
 
    typesRefresh = function() {
            configSetCallbacks(canSave, save, typesRefresh, typesAdd, typesRemove, addModifyLots, changeType);
            //ajax({url:"<%=path%>/secure/config/types/refreshtypes"}).done(function(msg) {
//            $.ajax({url:"/ImplantEdit/refreshtypes"}).done(function(msg) {
//                //console.log("ajax done with msg sending to setTable msg = " + msg);
//                setTable(msg);
//            });  
//            
//             $.ajax({url:"/ImplantEdit/refreshhistory"}).done(function(msg) {
//                //console.log("ajax done with msg sending to setTable msg = " + msg);
//                setHistory(msg);
//            });
//                ajax({url:"/ImplantEdit/refreshtypes"}).done(function(msg) {
//                    setTable(msg);
//                });
        };
   logout1 = function() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    
        //console.log("submitting ajax request to logout"  );
        
        $.ajax({ url: "/ImplantEdit/logout",
                method: "POST"
                //method: "GET"
                 });
            window.location ="http://jaz-cimdev2/ImplantEdit/index.jsp";
   
    };
     function canSave() {
         // alert("inside canSave function")
          return !$("#types_save").button("option", "disabled");
         //return !$("#types_save").button();
    };
       
     function save() {
        // alert("inside save function");
      $('#Status').prop('disabled',false);
      $('#_id').prop('disabled',false);
     
       //alert($("#newid").val());
         // alert("3newID=" + newID );
          //alert("3newID2=" + newID2);
      if(loginAdmin === true){
         //before saving need to update all checkboxes and radios and multiple lists to hidden fields
         if($('#ReliabilityRequiredY').is(':checked')) {
        
                $("#ReliabilityTestsI").val("yes");
          }else{
              $("#ReliabilityTestsI").val("no");
          }
           if($('#RelTestReqDispY').is(':checked')) {
           
               $("#RelTestReqDispI").val("yes");
          }else{
               $("#RelTestReqDispI").val("no");
          }
        if($('#RelToProductionY').is(':checked')) {
        
              $("#RelToProductionI").val("yes");
          }else{
               $("#RelToProductionI").val("no");
          }        
           if($("#CustDeliveryY").is(":checked") ){
              $("#CustDeliveryI").val("yes");
          }else{
               $("#CustDeliveryI").val("no");
          }        
          var counterDispA  = $("#STRtableDisp tr:last").index().valueOf() + 1;
            for(var iii=1; iii < counterDispA; iii++){
                if($('#Prob' + iii.toString()).is(':checked')) {
                    $("#ProbI" + iii.toString()).val("on");
                }else {
                    $("#ProbI" + iii.toString()).val("");
                }    
                 var selected1 = "";
                $('#ScrWfrL' + iii.toString() + ' :selected').each(function(i, sel){ 
                        //alert( "selected value is " + $(sel).val()); 
                         selected1 = selected1 + " " + $(sel).val();
                });
                //alert("selected1=" + selected1);
                $('#ScrWfrI' + iii.toString()).val(selected1);    
            }
             var counterDispB  = $("#STRtable4 tr:last").index().valueOf() + 1;
            for(var iii=1; iii < counterDispB; iii++){
                if($('#LotCony' + iii.toString()).is(':checked')) {
                    $("#LotConyI" + iii.toString()).val("on");
                }else {
                    $("#LotConyI" + iii.toString()).val("");
                } 
                 if($('#AppRej' + iii.toString()).is(':checked')) {
                    $("#AppRejI" + iii.toString()).val("on");
                }else {
                    $("#AppRejI" + iii.toString()).val("");
                }    
                
            }

        }
      
      //$("#STRtable4").prop("disabled", false); //this table row is created dynamically so always goes back to the server and in again
      //$("#STRtableDisp").prop("disabled", false);//this table row is created dynamically so always goes back to the server and in again
      //$("#STRtable4").prop("readonly", false); //this table row is created dynamically so always goes back to the server and in again
      //$("#STRtableDisp").prop("readonly", false);//this table row is created dynamically so always goes back to the server and in again
      //$('#STRtableDisp').find("input,button,textarea,select").prop('disabled', false);
       
        $('#UpdatedByRevisions').find("input,button,textarea,select").prop('disabled', false);
      
        $( "#myForm" ).submit();

        if(cancelAdd !== 0){
            return;
        }
      
        
    };
        duplicateSTR = function () { 
         //var newID = "";
      // if(status.indexOf(" Lot " ) < 0 && status.indexOf(" Area ") < 0 && status.indexOf( "Draft" ) < 0 ){ 
         //  alert(status);
         $( "#formDuplicateSTR" ).dialog({
             open: function() {
              //call servlet to create a new STR and fill in STRtable1 and STRtable2 from the current table
                       var _idVal = $("#_id").val();
                       var STR_TITLEVal = $("#STR_TITLE").val();
                       var EngineerVal = loginUser;
                       var dateVal = getCurrentDate().toString();
                       var ExtVal = $("#Ext").val();
                       var AreaVal = $("#Area").val();
                       var DeptVal = $("#Dept").val();
                       var date = new Date(getCurrentDate());
                       var newdate = new Date(date);
                       newdate.setDate(newdate.getDate() + 90);
                       var str =   (date.getMonth() ) + "/" + date.getDate() + "/" +  date.getFullYear();
                       var Final_Report_DateVal = str.toString();
                       var purposeVal = $("#Purpose").val();
                       var siteVal = $("#site").val();
                       var Group1Val = $("#Group1").val();
                       var Group2Val = $("#Group2").val();
                       var Group3Val = $("#Group3").val();
                       var Group4Val = $("#Group4").val();
                       var Group5Val = $("#Group5").val();
                       var Group6Val = $("#Group6").val();
                       var Group7Val = $("#Group7").val();
                        // alert("Final+Report_DateVal=" + Final_Report_DateVal );
                         var obj = {
                        add:[]
                             };
                            //var pk22 = values["reticle"];
                            //var pk33 = values["stock"];
                            obj.add[obj.add.length] = {
                                _id: _idVal,
                                STR_TITLE: STR_TITLEVal,
                                Engineer:EngineerVal,
                                date:dateVal,
                                Ext:ExtVal,
                                Area:AreaVal,
                                Dept:DeptVal,
                                Final_Report_Date:Final_Report_DateVal,
                                purpose:purposeVal,
                                site: siteVal,
                                Group1: Group1Val,
                                Group2: Group2Val,
                                Group3: Group3Val,
                                Group4: Group4Val,
                                Group5: Group5Val,
                                Group6: Group6Val,
                                Group7: Group7Val
                             };
                            
                            if (obj.length!==0) {
                                //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
                               $.ajax({ url:"/STRX8654/DuplicateSTR",
                                method: "POST",
                                data: JSON.stringify(obj) 
                            }).done(function(msg) {
                                var json = JSON.parse(msg);
                                var  newid1 = json._id[0].toString();
                               newid1.replace(/[\[\]']+/g,'');
                                // alert("json._id=" + newID);
                                $('#newid').prop('disabled',false);
                                 $('#newid').prop('readonly',false);
                                $("#newid").val(newid1);

                            });
                        }
             },
             buttons: {
                  'Yes' : function () {
                       $(this).dialog('close');
                      save();
                      
                       },
                      'No' : function () {
                          $("#newid").val("");
                          $(this).dialog('close');
                     }
             }
         });
          
    };
    requestLotChanges = function() {
      $( "#formRequestLotChange" ).dialog({
                                     width: 500,
                                      buttons: {
                                          'Cancel' : function () {
                                            //cancelAdd = 1;
                                            //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                                            $(this).dialog('close');
                                            }, 
                                          'OK' : function () {
                                            //cancelAdd = 0;
                                            //$("#STRtable4").find("input,button,textarea,select").prop("disabled", false);
                                            $("#ChangeRequestComment").prop("disabled", false);
                                            $("#ChangeRequestComment").prop("readonly", false);
                                            var addChange = approver + " at " + getCurrentDate().toString() + " " + $("#RequestChangeLots").val() + " "  ;
                                            $("#ChangeRequestComment").val(  $("#ChangeRequestComment").val() + addChange  );
                                            //$("#STRtableLotChg").find("input,button,textarea,select").prop("readonly", true);
                                            $(this).dialog('close');
                                            save();
                                        }
                                      }
                                  });  
    };
     addModifyLots = function () {
         var firstTimeAssigningLots = true;
          $( "#formAddLots" ).dialog({
                 //resizable: false,
              //width:'auto',
              //height:'auto',
            //  autoOpen:false,
           
            open: function() {
                 //$("#Search").prop("disabled", true);
//                  if($("#SearchPart").val().toString().length > 2 || $("#SearchProcess").val().toString().length > 2) {
//                        $("#Search").prop("disabled", false);
//                    } else {
//                        $("#Search").prop("disabled", true);
//                    }
                // do something on load
                //alert("inside open function");
                lotsToSave.clear();
                for(i=1; i<counter; i++){
                    if( LotsForSTR[i - 1][0]  !== "" || LotsForSTR[i - 1][1]  !== "" || LotsForSTR[ i - 1][2]   !== "" ){
                             var lotsToSaveRow1 = lotsToSave.row.add( [ LotsForSTR[ i - 1][2] ,  LotsForSTR[i - 1][1]  , LotsForSTR[i - 1][0] ] ); 
                            // alert( LotsForSTR[i - 1][0]);
                             
                     }
                     
                     lotsToSave.draw(true);
                }
                
             },
             height: 400,
             width: 800,
             
                title: 'Search and Add Lots',
                
                //need to add lots to the lotsToSave dialog that are already in the STR
                //var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                //addModifyLots2 
                buttons: {
 
                   'Add Selected Lots To This STR' : function () {
                       // cancelAdd = 1;
                       var table = lotsList;
                     //  $('#button').click(function (evt) {
                         var ids = $.map(table.rows('.selected').data(), function (item) {
                                    return item;
                        });
                        if(ids.length === 0 ){
                            alert("No Lots have been selected. Please select 1 or more Lots");
                        }
                        for(var i = 0; i <ids.length ; i += 3) {
                            
                            var $tds = $('#lotsToSave tr > td:nth-child(1)').filter(function () {
                                return $.trim($(this).text()) === ids[i];
                            });
                            if ($tds.length !== 0) {
                                //alert("Lot " + ids[i] + " is already part of this STR");
                            } else {
                                var lotsToSaveRow = lotsToSave.row.add( [ ids[i],  ids[i + 1] , ids[ i + 2] ] );    
                            } 
                         }   
                  
                        lotsToSave.draw(true);

                        }, 
                     'Remove Designated Lots From This  STR' : function () {
                        var table = $('#lotsToSave').DataTable();
                          var removeLots = $.map(table.rows('.selected').data(), function (item) {
                                    return item;
                        });
                         if(removeLots.length === 0 ){
                            alert("No Lots have been selected to be removed. Please select 1 or more Lots");
                        } 
                         var rowsDeleted = table
                            .rows( '.selected' )
                            .remove()
                            .draw();
                            
                       
                        }, 
                        
                    'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                        lotsToSave.clear();
                        $(this).dialog('close');
                        }, 
                     'Save' : function () {
                            cancelAdd = 0;
                            var rowCount = $('table#lotsToSave tr:last').index() ;
                            if (rowCount === 0 ){
                                  $( "#formAddLotsEmpty" ).dialog({
                                     width: 500,
                                      buttons: {
                                          'OK' : function () {
                                             $(this).dialog('close');
                                         }
                                      }
                                  });    
                            } else {           
                            //formAddLotsEmpty
                             //need to clear all content in table first 
                             //$("#STRtable4 > tbody").html("");
                            /// $("#tbodyid").empty()
                            $("#STRtableDisp").find("input,button,textarea,select").prop("disabled", false);
                            $('#STRtableDisp tr').has('td').remove();
                            $("#STRtable4").find("input,button,textarea,select").prop("disabled", false);
                            $('#STRtable4 tr').has('td').remove();
                            
                            
 
                             var lot;
                             var part;
                             var process;
                             var vals = [];
                             var counter1=1;      
                            lotsToSave.cells().eq(0).each( function ( index ) {
                            var cell = lotsToSave.cell( index );
                            var data = cell.data();
                            vals.push(data);                                        
                            } );
                            //  $("#STRtable4").find('tbody').remove();
                            for(var kk = 0; kk < vals.length ; kk +=3) {
                                 lot =  vals[ kk ];
                                 part =   vals[ kk + 1 ];
                                 process =  vals[ kk + 2 ];
                               //var  row1 = $('<tr  style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + counter1 + '" name="DeviceL' + counter1 + '" readonly value =' + port + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + counter1 + '" name="ProcessL' + counter1 + '" readonly value =' + process + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + counter1 + '" name="Lot_' + counter1 + '" readonly value =' + lot + '></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + '" type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM_' + counter1 + '" name="SCM_' + counter1 + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + counter1 + '" name="LotCony' + counter1 + '" >Yes</TD></tr>');
                              //   var  row1 = $('<tr  class="SCMtr" style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + counter1 + '" name="DeviceL' +counter1 + '"  value =' + LotsForSTR[ counter1 - 1][ 0] + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + counter1 + '" name="ProcessL' + counter1 + '"  value =' + LotsForSTR[ counter1 - 1][ 1] + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + counter1 + '" name="Lot_' + counter1 + '"  value =' + LotsForSTR[ counter1 - 1][ 2] + '></TD><TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + counter1 + '" name="AppRej' + counter1 + '" >Approve or Reject</TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" class ="SCMApp" id="SCM_' + counter1 + '" name="SCM_' + counter1 + '"  value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + counter1 + '" name="LotCony' + counter1 + '" >Yes</TD></tr>');
                               //   var  row11 = $('<tr  class="SCMtr" style="display:table-row;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + counter1 + '" name="DeviceL' +counter1 + '"  value =' + port + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + counter1 + '" name="ProcessL' + counter1 + '"  value =' + process + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + counter1 + '" name="Lot_' + counter1 + '"  value =' + lot + '></TD><TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + counter1 + '" name="AppRej' + counter1 + '" >Approve or Reject</TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" class ="SCMApp" id="SCM_' + counter1 + '" name="SCM_' + counter1 + '"  value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + counter1 + '" name="LotCony' + counter1 + '" class ="LotCony" >Yes</TD></tr>');
                                  var  row11 = $('<tr  class="SCMtr" style="display:table-row;"><TD  style="width:100px">' +
                '<input style="display:table-cell; width:100%;" type="text" id="DeviceL' + counter1 + '" name="DeviceL' + counter1 + '"  value ="' + part + '"></TD>' +
                '<TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + counter1 + '" name="ProcessL' + counter1 + '"  value ="' + process + '"></TD>' +
                '<TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + counter1 + '" name="Lot_' + counter1 + '"  value ="' + lot + '"></TD>' +
                '<TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + counter1 + '" name="AppRej' + counter1 + '" >Approve or Reject<input class="AppRej" id="AppRejI' + counter1 + '" name="AppRejI' + counter1 + '" type="hidden" value= "' + "" + '" ></TD>' +
                '<TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" class ="SCMApp" id="SCM_' + counter1 + '" name="SCM_' + counter1 + '"  value =""></TD>'
                + '<TD style="width:100px"><input type="checkbox" class ="LotCony" id="LotCony' + counter1 + '" name="LotCony' + counter1 + '" >Yes<input class="LotCony" id="LotConyI' + counter1 + '" name="LotConyI' + counter1 + '" type="hidden" value= "' + "" + '" ></TD></tr>');
                                $("#STRtable4").find('tbody').append(row11);
                                
                                var row22 = $('<tr class="Disptr" style="display:table-row;"><TD style="width:100px"><input  style="display:table-cell; width:100%;" type="text" id="QADispL' + counter1 + '" name="QADispL' + counter1 + '"  value ="' + lot + '"></TD ><TD  style="width:100px">' +
                                 '<input   type="checkbox" class="Prob" id="Prob' + counter1 + '" name="Prob' + counter1 + '">Yes<input class="ProbI"  id="ProbI' + counter1 + '" name="ProbI' + counter1 + '"  type="hidden" value= "" ></TD><TD  style="width:100px">' + ' <select  id= "DispositionL' + counter1 + '" name="DispositionL' + counter1 + '">' +       
                               shipselect +
                                '</select></TD><TD style="width:100px"><input  style="display:table-cell; width:100%;" type="text" id="PLD_' + counter1 + '" name="PLD_' + counter1 + '"  value =""></TD><TD  style="width:200px"><input  style="width:100%;" type="text" id="PEMgrOKSHip' + counter1 + '" name="PEMgrOKSHip' + counter1 + '"  value =""></TD><TD  style="width:100px">' + 
                                '<select  multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + counter1 + '" name="ScrWfrL' + counter1 + '" class= "ScrWfrL"  >' + 
                               scrWfrSelect + 
                               '</select><input class="ScrWfrI"  id="ScrWfrI' + counter1 + '" name="ScrWfrI' + counter1 + '"  type="hidden" value= "' + "" + '" ></TD><TD> <textarea   id="CommentDispL' + counter1 + '"  name="CommentDispL' + counter1 + '"  style="border: none"  ROWS=4  ></textarea></TD></tr>');
                               
                               $("#STRtableDisp").find('tbody').append(row22);
                                 counter1 = counter1 + 1;
                             }
                             //Below is needed to clear out any delete rows so the DB update also contain no values for any fields that are no longer used
                             for(var kk =  counter1; kk <= counter ; kk ++) {
                               // var  row1 = $('<tr style="display:none;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + kk + '" name="DeviceL' + kk + '" readonly value =' + "" + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' + kk + '" name="ProcessL' + kk + '" readonly value =' + "" + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + kk + '" name="Lot_' + kk + '" readonly value =' + "" + '></TD><TD style="width:100px"><button id="AppRej' + i + '" name="AppRej' + i + '" type="button" >AppRej</button></TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" id="SCM_' + kk + '" name="SCM_' + kk + '" readonly value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + kk + '" name="LotCony' + kk + '" >Yes</TD></tr>');
                                //var  row111 = $('<tr  class="SCMtr" style="display:none;"><TD  style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="DeviceL' + kk + '" name="DeviceL'+  kk + '"  value =' + "" + '></TD><TD  style="width:100px" ><input style="display:table-cell; width:100%;" type="text" id="ProcessL' +kk + '" name="ProcessL' + kk + '"  value =' + "" + '></TD><TD style="width:100px"><input style="display:table-cell; width:100%;" type="text" id="Lot_' + kk + '" name="Lot_' +kk + '"  value =' + "" + '></TD><TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + kk + '" name="AppRej' + kk + '" >Approve or Reject</TD><TD style="width:130px"><input style="display:table-cell; width:100%;" type="text" class ="SCMApp" id="SCM_' + kk + '" name="SCM_' + kk + '"  value =""></TD><TD style="width:100px"><input type="checkbox" id="LotCony' + kk + '" name="LotCony' + kk + '" class ="LotCony" >Yes</TD></tr>');
                                 var  row111 = $('<tr  class="SCMtr" style="display:none;"><TD  style="width:100px">' +
                '<input style="display:none; width:100%;" type="text" id="DeviceL' + kk + '" name="DeviceL' + kk + '"  value =' + "" + '></TD>' +
                '<TD  style="width:100px" ><input style="display:none; width:100%;" type="text" id="ProcessL' +kk + '" name="ProcessL' + kk + '"  value =' + "" + '></TD>' +
                '<TD style="width:100px"><input style="display:none; width:100%;" type="text" id="Lot_' + kk + '" name="Lot_' + kk + '"  value =' + "" + '></TD>' +
                '<TD style="width:100px"><input type="checkbox" class ="AppRej" id="AppRej' + kk + '" name="AppRej' + kk + '" >Approve or Reject<input class="AppRej" id="AppRejI' + kk + '" name="AppRejI' + kk + '" type="hidden" value= "' + "" + '" ></TD>' +
                '<TD style="width:130px"><input style="display:none; width:100%;" type="text" class ="SCMApp" id="SCM_' + kk + '" name="SCM_' + kk + '"  value =""></TD>'
                + '<TD style="width:100px"><input type="checkbox" class ="LotCony" id="LotCony' + kk + '" name="LotCony' + kk + '" >Yes<input class="LotCony" id="LotConyI' + kk + '" name="LotConyI' + kk + '" type="hidden" value= "' + "" + '" ></TD></tr>');
                                $("#STRtable4").find('tbody').append(row111);
                                
                                var row222 = $('<tr class="Disptr" style="display:none;"><TD style="width:100px"><input  style="display:none;width:100%;" type="text" id="QADispL' + kk + '" name="QADispL' + kk + '"  value ="' + "" + '"></TD ><TD  style="width:100px">' +
                                 '<input   type="checkbox" class="Prob" id="Prob' + kk + '" name="Prob' + kk + '">Yes<input class="ProbI"  id="ProbI' + kk + '" name="ProbI' + kk + '"  type="hidden" value= "" ></TD><TD  style="width:100px">' + ' <select  id= "DispositionL' + kk + '" name="DispositionL' + kk + '">' +       
                               shipselect +
                                '</select></TD><TD style="width:100px"><input  style="display:none; width:100%;" type="text" id="PLD_' + kk + '" name="PLD_' + kk + '"  value =""></TD><TD  style="width:200px"><input  style="width:100%;" type="text" id="PEMgrOKSHip' + kk + '" name="PEMgrOKSHip' + kk + '"  value =""></TD><TD  style="width:100px">' + 
                                '<select  multiple size=4 style="height: 100%; width:100%;"  id= "ScrWfrL' + kk + '" name="ScrWfrL' + kk + '" class= "ScrWfrL"  >' + 
                               scrWfrSelect + 
                               '</select></TD><TD> <textarea   id="CommentDispL' + kk + '"  name="CommentDispL' + kk + '"  style="border: none"  ROWS=4  ></textarea></TD></tr>');
                                //alert(row222);
                                $("#STRtableDisp").find('tbody').append(row222);
                            }  
                            //DO NOT disable the rows once they are appended since they have to update the DB
                           //  $("#STRtable4").find("input,button,textarea,select").prop("readonly", true);
                            //update the Total_Lots entry
                            $("#Total_Lots").prop("disabled", false);
                            $("#Total_Lots").val(counter1 - 1);
                             $(this).dialog('close');
                             //alert(LotsForSTR[0][0] );
                              if( LotsForSTR[0][0]  !== "" || LotsForSTR[0][1]  !== "" || LotsForSTR[0][2]   !== "" ){
                                  firstTimeAssigningLots = false;
                              }
                             //  alert(firstTimeAssigningLots);
                             if( firstTimeAssigningLots === false){
                                 $( "#formChangeLots" ).dialog({
                                     //width: 500,
                                      buttons: {
                                          'Cancel' : function () {
                                            //cancelAdd = 1;
                                            //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                                            $(this).dialog('close');
                                            }, 
                                          'OK' : function () {
                                            //cancelAdd = 0;
                                            //$("#STRtable4").find("input,button,textarea,select").prop("disabled", false);
                                            $("#STRtableLotChg").find("input,button,textarea,select").prop("disabled", false);
                                            $("#STRtableLotChg").find("input,button,textarea,select").prop("readonly", false);
                                            var addChange = approver + " " + getCurrentDate().toString() + " " + $("#ChangeLotsSTR").val() + " "  ;
                                            $("#LotChangeComment").val(  $("#LotChangeComment").val() + addChange  );
                                            $("#STRtableLotChg").find("input,button,textarea,select").prop("readonly", true);
                                            $(this).dialog('close');
                                            save();
                                        }
                                      }
                                  });
                             }
                     }
                }    
              },
               resizeStop: function(event, ui) {
                    //alert("Width: " + $(this).outerWidth() + ", height: " + $(this).outerHeight());    
                    var heightOffset = 1;
                    var cHeight = $(this).height();
                    //alert(cHeight);
                    var dHeight = 0;
                    var oSettings = $('#lotList').dataTable().fnSettings();
                    oSettings.oScroll.sY = dHeight + "px";
                    $(".dataTables_scrollBody").height(cHeight - heightOffset);
                     var oSettings = $('#lotsToSave').dataTable().fnSettings();
                    oSettings.oScroll.sY = dHeight + "px";
                    $(".dataTables_scrollBody").height(cHeight - heightOffset);
                    
                 }
             
           }); 
       addModifyLots2();
    };
  addModifyLots2 = function () { 
 
    };
    setupSelections = function () {
          $( "#setupSelect" ).dialog({
                
            open: function() {
                // do something on load
               
               
             },
             height: 400,
                width: 500,
                //when STR is first opened the AREA and LOCATION NEED TO BE SELECTED
                title: 'Select Location and Applicable Areas',
               
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
                            var selected = $('#location').find(':selected').text();
                            //var location = $('#location').val();
                            var primary = $('#primaryArea').find(':selected').text();
                            if( selected === "" || primary === "" ) {
                                $( "#formNewSettingsValid").dialog({
                                    buttons: {
                                         'Ok' : function () {
                                             $(this).dialog('close');
                                         }
                                      } 
                             });
                             }else{
                            var obj = {
                                    add:[]
                             };

                            obj.add[obj.add.length] = {
                                site: selected,
                                area: primary
                               // status:statusVal
                              };
                                    if (obj.length!==0) {
                                           $.ajax({ url:"/STRX8654/GetAppGroups",
                                            method: "POST",
                                            data: JSON.stringify(obj) 
                                        }).done(function(msg) {
                                        var json = JSON.parse(msg);
                                        //alert("before msg check = " + msg);
                                        approvedStatus = msg;
                                        
                                        var key, count = 0;
                                        for(key in json.approved) {
                                          if(json.approved.hasOwnProperty(key)) {
                                             var approval1 = json.approved[count].toString();
                                             if(approval1.toString().indexOf("AREA ") > 0){
                                                $("#Group1").val("Area Managers");
                                            }else if(approval1.toString().indexOf("SCM ") > 0){
                                                $("#Group2").val("SCM Managers");
                                            }else if(approval1.toString().indexOf("QA ") > 0){
                                                $("#Group3").val("QA Managers");
                                            }else if(approval1.toString().indexOf("QA-DISPOSITION") > 0){
                                                $("#Group4").val("QA-Disposition");
                                            }else if(approval1.toString().indexOf("DEVICE ") > 0){
                                                $("#Group4").val("Device");
                                           }else if(approval1.toString().indexOf("PRODUCTION-CONTROL") > 0){
                                                $("#Group5").val("Production Control");     
                                          }else if(approval1.toString().indexOf("PRODUCTION ") > 0){
                                                $("#Group6").val("Production Managers"); 
                                          }else if(approval1.toString().indexOf("PROENG ") > 0){
                                                $("#Group7").val("ProEng Managers");     
                                            }      
                                            count++;
                                          }
                                        }
                                     });
                                }
                                
                            $("#secondaryArea option:selected").each(function () {
                                    var $this = $(this);
                                    if ($this.length) {
                                        var selText = $this.text();
                                        if ( primary.indexOf(selText) === -1 ) {
                                            primary = primary + " " + selText;
                                       }
                                   }
                              });

                              $('#Area').val(primary );
                              $('#site').val(selected );
                             
                             $(this).dialog('close');
                         }
                     }
              },
               close: function() {
                // do something on close
               
               
             },
               resizeStop: function(event, ui) {

                 }
             
           }); 
           
       //addModifyLots2();
    }; 
        selectTests = function () {
          $( "#selectRTest" ).dialog({
               
            open: function() {
              
             },
             height: 300,
              width: 300,
             
                title: 'Select Reliability Tests',
                //need to add lots to the lotsToSave dialog that are already in the STR
              
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Save' : function () {
                            cancelAdd = 0;
                            var selected="";
                             $("#selectRL option:selected").each(function () {
                                    var $this = $(this);
                                    if ($this.length) {
                                        var selText = $this.text();
                                           selected = selected + " " + selText;
                                    }
                              });
                              
                              $("#ReliabilityTests").prop('disabled', false); 
                              $('#ReliabilityTests').val(selected );
                              $("#ReliabilityTests").prop('readonly', true); 
                             $(this).dialog('close');
                             save();
                         }
              }

   }); 
           
       //addModifyLots2();
    }; 
     PEshipLots = function () {
          var counterDisp1  = $("#STRtableDisp tr:last").index().valueOf() + 1;  
          $( "#formPEMgrOKShip" ).dialog({
            
            open: function() {
              //add the lots to the select
               //var counterDisp1  = $("#STRtableDisp tr:last").index().valueOf() + 1;
                for(var iii=1; iii < counterDisp1; iii++){
                    var lot1 = $("#QADispL" + iii.toString()).val();
                   var  rowPE = $('<tr  class="PEtr" style="display:table-row;"><TD  style="width:100px">' +
                '<TD style="width:100px"><input type="checkbox" class ="PEcheck" id="PElot' + iii + '" name="PElot' + iii + '" >' + iii.toString() + " " + lot1 + '</TD></tr>');
                    $("#PEtable").find('tbody').append(rowPE);
                }
             },
             height: 300,
              width: 300,
             
                title: 'Select Lots To Ship',
                //need to add lots to the lotsToSave dialog that are already in the STR
              
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'OK' : function () {
                            cancelAdd = 0;
                            var selected="";
                             $('#STRtableDisp').find("input,button,textarea,select").prop('disabled', false);
                            $('#STRtableDisp').find("input,button,textarea,select").prop('readonly', false); 
                              for(var iii=1; iii < counterDisp1; iii++){
                                    if($('#PElot' + iii.toString()).is(':checked')) {
                                        //alert(approver);
                                        var PEstring = "Ship " + approver.toString();
                                        $("#PEMgrOKSHip" + iii.toString()).val(PEstring );
                                     }else {
                                         $("#PEMgrOKSHip" + iii.toString()).val("" );
                                     }
                                 }       
                             $(this).dialog('close');
                             save();
                         }
              }

   }); 
           
       //addModifyLots2();
    }; 
     selectRejection = function () {
           //alert($('#AddtionalTesting').val());
         
         
           //alert("primaryArea =" + primaryArea);
           
           //alert("index1 = " + index1);
          
           //alert(primeArea);
           
          $( "#formConfirmRejection").dialog({
                    buttons: {
                    'Yes' : function () {
                     $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
                            //move the current date into a function ...
                         
                     if( status.indexOf(" Area " ) > 0 ){
                                $("#Who1").val(approver);
                                $("#ActionTaken1").val("Rejected");
                                 var today1 = getCurrentDate();   
                                $("#ActionDate1").val(today1.toString());
                               
                      } else if(status.indexOf("Pending SCM" ) > -1 ){
                                  //just reject the newly checked lots - not the whole STR unless all Lots are checked
                                   var notCompletedSCM=false;
                                    //first update any approvers who just added checkboxes
                                    $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
                                     //update the Lots Designated for STR table for new approver
                                    $(".SCMtr").each(function() {
                                        var a = $(this).find("input:checkbox[class=AppRej]").is(':checked');
                                        //alert(a);
                                        if(a === true && $(this).find("input:text[class=SCMApp]").val() === "" ){
                                            $(this).find("input:text[class=SCMApp]").val("Rejected by:" +  approver);
                                        }
                                     });
                                     
                                        //ONLY IF ALL LOTS ARE APPROVED/REJECTED
                                        //if(all approvers in the LOTS DESIGNATED FOR STR are filled in and checkboxes checked...
                                        $(".SCMtr").each(function() {
                                          var a = $(this).find("input:checkbox[class=AppRej]").is(':checked');
                                           if(a === true && $(this).find("input:text[class=SCMApp]").val() !== "" ){
                                               //lot approval/rejection completed
                                           }else{
                                               notCompletedSCM = true;
                                           }
                                         });
                                         //alert(notCompletedSCM);
                                         if( notCompletedSCM === false){
                                           var today1 = getCurrentDate();
                                            $("#Who2").val(approver);
                                            $("#ActionTaken2").val("Rejected");
                                            $("#ActionDate2").val(today1.toString());
                                             $("#STRtable14").find("input,button,textarea,select").prop('disabled', false);
                                            $('#UpdatedByRevisions').prop('disabled',false); 
                                            $('#UpdatedByRevisions').prop('readonly',false); 
                                            //update revision history and then submit changes to save permanately
                                            var lastrev = $('#UpdatedByRevisions').val().toString();
                                            $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                                            //$("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
                                             
                                            $("#Status").val("STR Rejected");
                                            
                                      }
                                       
                                  }
           
                 
                 if(approverAreas.indexOf(primeArea + "_QA" ) > 0 ) { 
                //    }else if(status.indexOf(" QA " ) > 0 ){
                        $("#Who3").val(approver);
                        $("#ActionTaken3").val("Rejected");
                        $("#ActionDate3").val(getCurrentDate().toString());
                   }
                   if(approverAreas.indexOf(primeArea + "_IE" ) > 0 ) {      
                  //   } else if(status.indexOf(" IE " ) > 0 ){
                        $("#Who5").val(approver);
                        $("#ActionTaken5").val("Rejected");
                        $("#ActionDate5").val(getCurrentDate().toString());
                   //  }else if(status.indexOf(" Production " ) > 0 ){
                     }
                     if(approverAreas.indexOf(primeArea + "_Production" ) > 0 ) {      
                        $("#Who6").val(approver);
                        $("#ActionTaken6").val("Rejected");
                        $("#ActionDate6").val(today1.toString());
                     }
                    if(approverAreas.indexOf(primeArea + "_ProEng" ) > 0 ) {      
                    // }else if(status.indexOf(" ProEng " ) > 0 ){
                        $("#Who7").val(approver);
                        $("#ActionTaken7").val("Rejected");
                        $("#ActionDate7").val(getCurrentDate().toString());
                     }                            
                     if( notCompletedSCM !== true){       
                            $("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
                            $('#str_approve span').hide();
                            $('#str_reject').hide();
                            $("#STRtable4").find("button").prop("disabled", false);
                            $("#Status").val("STR Rejected");
                            //update revision history and then submit changes to save permanately
                             $("#STRtable14").find("input,button,textarea,select").prop('disabled', false);
                            $('#UpdatedByRevisions').prop('disabled',false); 
                             $('#UpdatedByRevisions').prop('readonly',false); 
                             //update revision history and then submit changes to save permanately
                              var lastrev = $('#UpdatedByRevisions').val().toString();
                                $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                    }
               
                        //now submit changes. to update to MongoDB...
                     $(this).dialog('close');
                     save();
                    },
                    'No' : function () {
                        $(this).dialog('close');
                    }
                } 
            });
           
        };   
       selectApprover = function () {
          // alert("approvedStatus=" + approvedStatus);
           var primaryArea = "";
           var primeArea = "";
           primaryArea = $('#Area').val().toString();
           //alert("primaryArea =" + primaryArea);
           var index1 = primaryArea.trim().indexOf(" ");
           //alert("index1 = " + index1);
           primeArea = primaryArea.substring(0, index1 + 1).toUpperCase();
           
           //alert(primeArea);
           if( ( $('#AddtionalTesting').val() === "" || $('#STR_TITLE').val() === "" || $('#Purpose').val() === "" )  &&  status.indexOf("Pending" ) > -1  ){
                $( "#formNeedSplits").dialog({
                   buttons: {
                        'Ok' : function () {
                            $(this).dialog('close');
                        }
                     } 
            });
        
        }else if( approvedStatus.indexOf("Ok") > 0 && status === "Pending Area Approval" ){
            //the approvedStatus is Ok if the loginUser can approve the current status state of the STR
            $( "#formAreaManagerComments").dialog({
                buttons: {
                        'Ok' : function () {
                             $(".radiogroup2").each(function() {
                                 var selectedVal = "";
                                var selected = $("input[type='radio'][name='Type']:checked");
                                if (selected.length > 0) {
                                    selectedVal = selected.val();
                                    //alert(selectedVal);
                                    $("#Shippable").prop('disabled', false); 
                                    $('#Shippable').val( selectedVal + " " + approver );
                               }  
                            //$('#Shippable').val($("label[for='"+idVal+"']").text().substring(0));
                            //$("#Shippable").prop('disabled', true); 
                            //$('#TypeChange').val($(this).attr("value"));
                            });
                           $(this).dialog('close');
                              $( "#formConfirmApproval").dialog({
                                   buttons: {
                                       'Yes' : function () {
                                            $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
                                            $("#Who1").val(approver);
                                            $("#ActionTaken1").val("Approved");
                                           var today1 = getCurrentDate();
                                            $("#STRtable14").find("input,button,textarea,select").prop('disabled', false);
                                           $('#UpdatedByRevisions').prop('disabled',false); 
                                            $('#UpdatedByRevisions').prop('readonly',false); 
                                            //update revision history and then submit changes to save permanately
                                             var lastrev = $('#UpdatedByRevisions').val().toString();
                                        $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                                            $("#ActionDate1").val(getCurrentDate().toString());
                                            //$("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
                                            //  alert("UpdatedByRevisions=" + $('#UpdatedByRevisions').val()) ;
                                            //$("#STRtable4").find("checkbox").prop("disabled", false);
                                             
                                            
                                            $("#Status").val("Submit For SCM Lot Approval");
                                            //now submit changes. to update to MongoDB...

                                         $(this).dialog('close');
                                         save();
                                        },
                                        'No' : function () {
                                            $(this).dialog('close');
                                        }
                                    } 
                              });   
                         },
                         'Cancel' : function () {
                             $(this).dialog('close');
                         }
                     } 
                });  
        }else if( approvedStatus.indexOf("Ok") > 0 && status === "Pending SCM Lot Approval" ){
            //the approvedStatus is Ok if the loginUser can approve the current status state of the STR           
              $( "#formConfirmApproval").dialog({
                    buttons: {
                        'Yes' : function () {
                            var notCompletedSCM=false;
                            //first update any approvers who just added checkboxes
                           $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
                            //update the Lots Designated for STR table for new approver
                            $("#STRtable4").find("input,button,textarea,select").prop('disabled', false);
                            $("#STRtable4").find("input,button,textarea,select").prop('readonly', false);
                            var counter4  = $("#STRtable4 tr:last").index().valueOf() + 1;
                            for(var jj=1; jj < counter4; jj++){
                                if($('#LotCony' + jj.toString()).is(':checked')) {
                                    $("#LotConyI" + jj.toString()).val("on");
                                }else{
                                     $("#LotConyI" + jj.toString()).val("");
                                }    
                                if($('#AppRej' + jj.toString()).is(':checked')) {
                                    $("#AppRejI" + jj.toString()).val("on");
                                }else{
                                    $("#AppRejI" + jj.toString()).val("");
                                }
                            }
                           $(".SCMtr").each(function() {
//                               var b = $(this).find("input:checkbox[class=LotCony]").is(':checked');
//                                if(b === true){ 
//                                    //these checkboxes need to pass values to the hidden inputs
//                                   $(this).find("input:text[class=LotConyI]").val("on");
//                                   $("#LotConyI1").val("on");
//                                    alert("#LotConyI1= on" );
//                                }
                               var a =  $(this).find("input.AppRej:checkbox").is(':checked');
//                               //var a = $(this).find("input:checkbox[class=AppRej]").is(':checked');
//                               //alert("input:checkbox[class=AppRej]).is(:checked)");
//                                if(a === true){ 
//                                    alert("input:checkbox[class=AppRej]).is(:checked)");
//                                    //these checkboxes need to pass values to the hidden inputs
//                                    $(this).find("input:text[class=AppRejI]").val("on");
//                                    //alert(a);
//                                }
                               if(a === true && $(this).find("input:text[class=SCMApp]").val() === "" ){
                                   $(this).find("input:text[class=SCMApp]").val("Approved by:" +  approver);
                                }
                              });
                             //ONLY IF ALL LOTS ARE APPROVED
                             //if(all approvers in the LOTS DESIGNATED FOR STR are filled in and checkboxes checked...
                             $(".SCMtr").each(function() {
                               var a = $(this).find("input:checkbox[class=AppRej]").is(':checked');
                                if(a === true && $(this).find("input:text[class=SCMApp]").val() !== "" ){
                                    //lot approval/rejection completed
                                }else{
                                    notCompletedSCM = true;
                                }
                              });
                              //alert(notCompletedSCM);
                              if( notCompletedSCM === false){
                                var today1 = getCurrentDate();
                               $("#Who2").val(approver);
                               $("#ActionTaken2").val("Approved");
                               $("#ActionDate2").val(today1.toString());
                               $("#STRtable14").find("input,button,textarea,select").prop('disabled', false);
                              $('#UpdatedByRevisions').prop('disabled',false); 
                             $('#UpdatedByRevisions').prop('readonly',false); 
                             //update revision history and then submit changes to save permanately
                             var lastrev = $('#UpdatedByRevisions').val().toString();
                                $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 

                               //$("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);

                               $("#Status").val("Pending General Approval");
                            }       
                             //Update LOTS DESIGNATED FOR STR TABLE 
                              //now submit changes. to update to MongoDB...
                             
                            $(this).dialog('close');
                             save();
                         },
                         'No' : function () {
                             $(this).dialog('close');
                         }
                     } 
               });      
        }else if(   status === "Submit For SCM Lot Approval" ){
            //first check that lots have been selected and if not show a dialog to that effect  
            //var rows = $('#STRtable4 tr').length;
            var rows =$('table#STRtable4 tr:last').index() ;
            //alert("STRtable4 tr length=" + rows);
            if(rows < 2){
                //the tr index returns 1 for the column headings...
                 //show dialog warning that Lots need to be added to the STR
                 $('#formSCMNeedLots').dialog({
                     buttons: {
                        'Ok' : function () {
                            $(this).dialog('close');
                         }       
                     } 
               });   
            }else{
              $( "#formConfirmApproval").dialog({
                    buttons: {
                        'Yes' : function () {
                             var notCompletedSCM=false;
                            //first update any approvers who just added checkboxes
                           $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
 
                             //ONLY IF ALL LOTS ARE APPROVED
                             //if(all approvers in the LOTS DESIGNATED FOR STR are filled in and checkboxes checked...

                               $("#Status").val("Pending SCM Lot Approval");
                                 
                             //Update LOTS DESIGNATED FOR STR TABLE 
                              //now submit changes. to update to MongoDB...
                             
                            $(this).dialog('close');
                             save();
                         },
                         'No' : function () {
                             $(this).dialog('close');
                         }
                    }
               });   
        }
        }else if(  status === "Pending General Approval" ){
            counterDisp  = $("#STRtableDisp tr:last").index().valueOf() + 1;
            for(var iii=1; iii < counterDisp; iii++){
                if($('#Prob' + iii.toString()).is(':checked')) {
                    $("#ProbI" + iii.toString()).val("on");
                }else {
                    $("#ProbI" + iii.toString()).val("");
                }    
                 var selected1 = "";
                $('#ScrWfrL' + iii.toString() + ' :selected').each(function(i, sel){ 
                        //alert( "selected value is " + $(sel).val()); 
                         selected1 = selected1 + " " + $(sel).val();
                });
                //alert("selected1=" + selected1);
                $('#ScrWfrI' + iii.toString()).val(selected1);    
            }
 
//                    var holdsPlaced = "no";
//                    $('#formAllHoldsPlaced').dialog({
//                         buttons: {
//                        'Yes' : function () {
//                            $(this).dialog('close');
//                            $('#formPresentationDate').dialog({
//                                    open: function() {
//                                     $( "#PresentationDate" ).datepicker();
//                                    },
//                                    buttons: {
//                                   'Ok' : function () {
//                                       $(this).dialog('close');
//                                                $( "#formConfirmApproval").dialog({
//                                                buttons: {
//                                                    'Yes' : function () {
//                                                       var counterA = 0;
//                                                       //alert(approverAreas);
//                                                        //update the Final Report Date with the date selected - if selected
//                                                        $("#Final_Report_Date").prop('readonly', false); 
//                                                       $("#Final_Report_Date").prop('disabled', false); 
//                                                       //alert($('#PresentationDate').val().toString());
//                                                        $("#Final_Report_Date").val($('#PresentationDate').val().toString());
                                                        $("#STRtableApp").find("input,button,textarea,select").prop('disabled', false);
                                                        if(approverAreas.indexOf(primeArea + "_QA" ) > 0 ) { 
                                                    //    }else if(status.indexOf(" QA " ) > 0 ){
                                                            //alert("inside QA approval");
                                                            $("#Who3").val(approver);
                                                            $("#ActionTaken3").val("Approved");
                                                            $("#ActionDate3").val(getCurrentDate().toString());
                                                            counterA = counterA + 1;
                                                       }
                                                       if(approverAreas.indexOf(primeArea + "_IE" ) > 0 ) {      
                                                      //   } else if(status.indexOf(" IE " ) > 0 ){
                                                            $("#Who5").val(approver);
                                                            $("#ActionTaken5").val("Approved");
                                                            $("#ActionDate5").val(getCurrentDate().toString());
                                                       //  }else if(status.indexOf(" Production " ) > 0 ){
                                                            counterA = counterA + 1;
                                                         }
                                                         if(approverAreas.indexOf(primeArea + "_Production" ) > 0 ) {      
                                                            $("#Who6").val(approver);
                                                            $("#ActionTaken6").val("Approved");
                                                            $("#ActionDate6").val(getCurrentDate().toString());
                                                             counterA = counterA + 1;
                                                        }
                                                        if(approverAreas.indexOf(primeArea + "_ProEng" ) > 0 ) {      
                                                        // }else if(status.indexOf(" ProEng " ) > 0 ){
                                                            $("#Who7").val(approver);
                                                            $("#ActionTaken7").val("Approved");
                                                            $("#ActionDate7").val(getCurrentDate().toString());
                                                             counterA = counterA + 1;
                                                         } 
                                                         //alert("CN=" + approver +  " " + getCurrentDate().toString());
                                                         $("#STRtable14").find("input,button,textarea,select").prop('disabled', false);
                                                         //$('#UpdatedByRevisions').prop('disabled',false); 
                                                           $('#UpdatedByRevisions').prop('disabled',false); 
                                                        $('#UpdatedByRevisions').prop('readonly',false); 
                                                        //update revision history and then submit changes to save permanately
                                                         var lastrev = $('#UpdatedByRevisions').val().toString();
                                                        $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                                                            //alert(('#UpdatedByRevisions').val());
                                                           //$("#STRtableApp").find("input,button,textarea,select").prop('disabled', true);
                                                           //check if all needed approvers are filled in so can go to next status level = In Process
                                                          
                                                           $("#Status").val("Pending General Approval");
                                                          //  $("#Status").val("");
                                                         //Update LOTS DESIGNATED FOR STR TABLE 
                                                          //now submit changes. to update to MongoDB...
                                                           
                                                           
                                         //                  $(this).dialog('close');
                                                           if(approverAreas.indexOf(primeArea + "_QA" ) > 0 ) { 
                                                            $( "#formQAManagerComments").dialog({
                                                                 buttons: {
                                                                 'Ok' : function () {
                                                                    $("#STRtableQA").find("input,button,textarea,select").prop('disabled', false);
                                                                    $("#STRtableQA").find("input,button,textarea,select").prop('readonly', false);
                                                                    if($('#radio1a').is(':checked')) {
//                                                                        alert("inside radio1a is checked");
//                                                                        $("#CustDeliveryY").prop("checked" , true);
                                                                       // $("#CustDeliveryY").val("yes");
                                                                        //$("#CustDeliveryN").val("");
                                                                        $("#CustDeliveryI").val("yes");
                                                                        //alert($("#CustDeliveryI").val());
                                                                        $("input[name=CustDelivery][value=" + "yes" + "]").prop('checked', true);
                                                                    }
                                                                    if($('#radio2a').is(':checked')) {
//                                                                         alert("inside radio2a is checked");
//                                                                        $("#CustDeliveryN").prop("checked" , true);
                                                                        //$("#CustDeliveryN").val("no");
                                                                       $("#CustDeliveryI").val("no");
                                                                        $("input[name=CustDelivery][value=" + "no" + "]").prop('checked', true);
                                                                    }
                                                                   $("#QA2Comment").val($("#QAMComment2").val()); 
                                                                  //alert("$('#radio1b').is(':checked')=" + $('#radio1b').is(':checked'));
                                                                    if($('#radio1b').is(':checked')) {
//                                                                         alert("inside radio2a is checked");
//                                                                        $("#RelToProductionY").prop("checked" , true);
                                                                        // $("#RelToProductionY").val("yes");
                                                                       // $("#RelToProductionN").val("");
                                                                        $("#RelToProductionI").val("yes");
                                                                         $("input[name=RelToProduction][value=" + "yes" + "]").prop('checked', true);
                                                                    }
                                                                    if($('#radio2b').is(':checked')) {
                                                                         //alert("inside radio2b is checked");
                                                                       // $("#RelToProductionN").prop("checked" , true); 
                                                                        //$("#RelToProductionN").val("no");
                                                                        //$("#RelToProductionY").val("");
                                                                        $("#RelToProductionI").val("no");
                                                                         $("input[name=RelToProduction][value=" + "no" + "]").prop('checked', true);
                                                                    }
                                                                    $("#QA1Comment").val($("#QAMComment1").val());
                                                                    //alert("QAMComment2=" + $("#QAMComment2").val());
                                                                    $("#QA2Comment").val($("#QAMComment2").val());
                                                                    $("#CustDelDate").val(getCurrentDate().toString());
                                                                    $("#RelProdDate").val(getCurrentDate().toString());
                                                                    $("#CustDelQAMgr").val(approver);
                                                                    $("#RelProdQAMgr").val(approver);
                                                                   $(this).dialog('close');
                                                                    // alert("counterA=" + counterA);
                                                                      if ( counterA === 4){
                                                                            $("#Status").val("In Process");
                                                                        }
                                                                        
  //                                                                    save();   
                                                                 },
                                                                 'Cancel' : function () {
                                                                     $(this).dialog('close');
                                                                 }
                                                             }
                                                            });
                                                            } 
                                                          save();   
//                                                     },
//                                                     'No' : function () {
//                                                         $(this).dialog('close');
//                                                     }
//                                                 } 
//                                           }); 
//                                           
//                                       },
//                                    'Cancel' : function () {
//                                        $(this).dialog('close');
//                                      }
//                                   }
//                              });
//                             
//                            },
//                         'No' : function () {
//                             $(this).dialog('close');
//                         }
//                        }
//                     }); 
                     
           }else if(  status === "In Process" ){            
               //the approve button is called "Complete STR" at this point
               //check if the attachments rich text has content
               var cummulativeCheck="";
              if($('#Attachments').html().length < 5){
                  $( "#formSTRReportNotAttached" ).dialog({
                       buttons: {
                        'OK' : function () {
                            $(this).dialog('close');
                        }
                    }
                  });
              }else{
                  cummulativeCheck = cummulativeCheck + "1";
              }    
              if($("#STRtableDisp tr:last").index() < 2 ){
                  $( "#formSTRDispNotComplete" ).dialog({
                       buttons: {
                        'OK' : function () {
                            $(this).dialog('close');
                        }
                    }
                  });
              } else{
                  cummulativeCheck = cummulativeCheck + "2";
              } 
              //alert("cummulativeCheck=" + cummulativeCheck);
               if($("#STRtableDisp tr:last").index() > 1 && cummulativeCheck === "12" ){ 
                   var counterDisp = 0;
                 // alert($("#STRtableDisp tr:last").index().valueOf());
                   counterDisp  = $("#STRtableDisp tr:last").index().valueOf() + 1;
                   for(ii=1; ii < counterDisp; ii++){
//                       //if( LotsForSTR[ i - 1 ][ 3 ]  === "" || $("#DispositionL" + i).val() === ""  ){
                        var endingVar = "DispositionL" + ii.toString();
                        //alert("Disposition=  " + $("#" + endingVar).val().toString());
                        if($("#" + endingVar).val().toString() === "" || LotsForSTR[ ii - 1 ][ 3 ]  === "" ){
                            //  alert(" endingVar=  " + endingVar);
                            cummulativeCheck === "12" + i.toString();
                           //alert("Disposition=  " + $("#" + endingVar).val());
                           //alert("DispositionL1=  " + $("#DispositionL1").val());
                           $( "#formSTRDispNotComplete" ).dialog({
                                buttons: {
                                 'OK' : function () {
                                     $(this).dialog('close');
                                     save();
                                 }
                             }
                           });
                      }   
                }
            } 
           if(cummulativeCheck === "12"){
               //formBriefAbstract
                $( "#formBriefAbstract" ).dialog({
                        width: 450,
                        height: 300,
                       buttons: {
                        'OK' : function () {
//                            $("#STRtable4").prop("disabled", false); //this table row is created dynamically so always goes back to the server and in again
//                            $("#STRtableDisp").prop("disabled", false);//this table row is created dynamically so always goes back to the server and in again
//                             $("#STRtable4").prop("readonly", false); //this table row is created dynamically so always goes back to the server and in again
//                            $("#STRtableDisp").prop("readonly", false);//this table row is created dynamically so always goes back to the server and in again
                            $("#Abstract").prop("disabled", false);
                            $("#Abstract").prop("readonly", false);
                            $("#Abstract").val($("#AbstractAboutSTR").val());
                            $("#Status").val("STR Complete");
                            $('#UpdatedByRevisions').prop('disabled',false); 
                             $('#UpdatedByRevisions').prop('readonly',false); 
                             //update revision history and then submit changes to save permanately
                               var lastrev = $('#UpdatedByRevisions').val().toString();
                                $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                            $(this).dialog('close');
                            save();
                        }
                    }
                  });
           }
               
            
         }else if(  status === "STR Complete" ){   
             //dialog for QA Managers feedback
             $( "#formQAMFeedback" ).dialog({
                        width: 450,
                        height: 300,
                       buttons: {
                        'OK' : function () {
                            $("#QAFeedbackDate1").prop("disabled", false);
                            $("#QAFeedbackDate1").prop("readonly", false);
                            $("#QAFeedback1").prop("disabled", false);
                            $("#QAFeedback1").prop("readonly", false);
                            $("#QAFeedbackDate1").val( getCurrentDate().toString());
                            
                            $("#QAFeedback1").val( approver + " " + $("#QAMFeedbackT").val());
                            $("#Status").val("In Process");
                            $('#UpdatedByRevisions').prop('disabled',false); 
                             $('#UpdatedByRevisions').prop('readonly',false); 
                             //update revision history and then submit changes to save permanately
                               var lastrev = $('#UpdatedByRevisions').val().toString();
                                $('#UpdatedByRevisions').val("CN " + approver +  " " + getCurrentDate().toString() + "\n" + lastrev  ); 
                            $(this).dialog('close');
                            save();
                        }
                    }
                  });
        }else {
           $( "#formApprovalGroup" ).dialog({
               
            open: function() {
                      var siteVal = $("#site").val().toString();
                      var areaVal = $("#Area").val().toString();
                      var statusVal = status;
                       var obj = {
                      add:[]
                       };
                      
                      obj.add[obj.add.length] = {
                          site: siteVal,
                          area: areaVal,
                          status:statusVal
                        };
                      
                      if (obj.length!==0) {
                          
                         $.ajax({ url:"/STRX8654/GetApprovers",
                          method: "POST",
                          data: JSON.stringify(obj) 
                      }).done(function(msg) {
                        var json = JSON.parse(msg);
                     $('#selectApprover').children().remove().end();
                        $.each(json.approver, function(i, value) {
                                $('#selectApprover').append($('<option>').text(value).attr('value', value));
                            });

                      });
                  }
             },
             height: 300,
              width: 300,
              title: 'Select  approvers for email requests',
                
                buttons: {
                  'Cancel' : function () {
                        cancelAdd = 1;
                        //console.log("cancel button clicked cancelAdd = " + cancelAdd);
                       
                        $(this).dialog('close');
                        }, 
                      'Ok' : function () {
                            cancelAdd = 0;
                            //var selected="";
                             if($('#Status').val() === 'Draft' || $('#Status').val() === "Pending Area Approval" ){
                                 //check that atleast 1 approver was selected and get list for emailing
                                 var rr = []; 
                                $('#selectApprover :selected').each(function(i, selected){ 
                                     rr[i] = $(selected).text(); 
                                 });
                                 //alert(rr.toString());
                                 if(rr.length > 0 ){
                                        $("#Status").prop('disabled', false);
                                        $("#Status").val("Pending Area Approval");
                                        $(this).dialog('close');
                                         save();
                                    }else {
                                        
                                    }    
                                }
                           }
              }

         }); 
           
        }    //addModifyLots2();
    };
    loginAsAdmin = function() {
       loginUser = "whitnem";
       loginAdmin = true;
       status = $("#Status").val().toString();
        
      //   if( status.substr(0,7) === "Pending" || status.substr(0,10) === "In Process" || status.substr(0,12) === "STR Complete"){

    //determine if login user is an Area approver and if so, change the button title and then when clicked, puts the approval info in the Approvers table
                 var siteVal = $("#site").val().toString();
                 var areaVal = $("#Area").val().toString();
                 
                approvedStatus = appapprovedStatus;
                approver=appapprover;
                primeArea=appprimeArea;
                primaryArea = appprimaryArea ;
                approverAreas = appapproverAreas;
       setSTRFieldsEdit(); // tjhis sets the buttons for each approval state 
      
       
   };
   loginAsApprover = function() {
       loginUser = "whitnem";
        loginAdmin = false;
       status = $("#Status").val().toString();
      //   if( status.substr(0,7) === "Pending" || status.substr(0,10) === "In Process" || status.substr(0,12) === "STR Complete"){

    //determine if login user is an Area approver and if so, change the button title and then when clicked, puts the approval info in the Approvers table
                 var siteVal = $("#site").val().toString();
                 var areaVal = $("#Area").val().toString();
                 //var statusVal = $("#Status").val().toString();
                 
                 //alert("status, loginUser, site, area = " + status + " ," + loginUser + "," + siteVal)
                 var obj = {
                add:[]
                 };
                
                obj.add[obj.add.length] = {
                    loginUser: loginUser,
                    status: status,
                    site:siteVal,
                    strArea: areaVal
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
                approvedStatus = appapprovedStatus;
                approver=appapprover;
                primeArea=appprimeArea;
                primaryArea = appprimaryArea ;
                approverAreas = appapproverAreas;
    
       setSTRFieldsEdit();
   };
   loginAsOther = function(){
       loginUser = 'wingak';
        loginAdmin = false;
       status = $("#Status").val().toString();
     //  if( status.substr(0,7) === "Pending" || status.substr(0,10) === "In Process" || status.substr(0,12) === "STR Complete"){

    //determine if login user is an Area approver and if so, change the button title and then when clicked, puts the approval info in the Approvers table
                 var siteVal = $("#site").val().toString();
                 var areaVal = $("#Area").val().toString();
                 //var statusVal = $("#Status").val().toString();
                 var obj = {
                add:[]
                 };
                
                obj.add[obj.add.length] = {
                    loginUser: loginUser,
                    status: status,
                    site:siteVal,
                    strArea: areaVal
                  };
                //var obj = { part: partVal   };   
                //obj = $("#SearchPart").val();
              
                    //console.log("submitting TYPES ajax request= " + JSON.stringify(obj) );
 
                   // var json = JSON.parse("msg");
                    //alert("before msg check = " + msg);
                    
                        approvedStatus ="none";
                        // alert(approvedStatus);
                        //approver = json.approved[0].toString();
                        approver = loginUser;
                        approverAreas =  "";
                        primaryArea = $('#Area').val().toString(); 
                        var index1 = primaryArea.trim().indexOf(" ");
                        primeArea = primaryArea.substring(0, index1 + 1).toUpperCase();
                        approverAreas = "none";
                       // alert("primeArea=" + primeArea);
                        //alert()
                      //$('#Status').val(status);
                    
               // });
            
       // }   
     
    
    //alert(approver);
        setSTRFieldsEdit();
    };
    //this wraps all elements in the page to jquery UI formats
   //wrapUIElements();
   //console.log("typesRefresh is being called");
   typesRefresh();
//  });      
})();
function configSetCallbacks(canSave, save, refresh, ins, del, addModifyLots , changeType) {
    //console.log("inside configSetCallbacks canSave = " +  canSave);
     //alert("inside configSetCallbacks");
    configSetCallbacks.canSave = canSave;
    
    configSetCallbacks.save = save;
    configSetCallbacks.refresh = refresh;
    configSetCallbacks.insert = ins;
    configSetCallbacks.delete = del;
    configSetCallbacks.addModifyLots = addModifyLots;
    configSetCallbacks.changeType = changeType;
}
function configRefresh() {
    if (configSetCallbacks.canSave()) {
        $('#config_refresh').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    } else {
        configSetCallbacks.refresh();
    }
}
function configSave() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    if (configSetCallbacks.canSave()) {
        $('#config_save').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    }
}
function configLogout() {
    //console.log("configSetCallbacks.canSave() = " + configSetCallbacks.canSave() );
    //if (configSetCallbacks.canSave()) {
        $('#config_logout').dialog({
            width: 'auto',
            minHeight: '0px',
            resizable: false,
            modal: true,
            position:{ my: 'center', at: 'center', of: window }
        });
    //}
} 
 
 
function setTable(msg) {
        var json = JSON.parse(msg);

        //$("#types_updated").html(json.updated);
        $("lotList th").css("width", "0px");
        //alert(msg);
        var table =  lotsList;
        table.clear();
        table.rows.add(json.types);
        table.column( '0' ).order( 'asc' );
//        var heightOffset = 200;
//        var cHeight = $('#formAddLots').height();
//        alert(cHeight);
//        var dHeight = 0;
//        var oSettings = $('#lotList').dataTable().fnSettings();
//        oSettings.oScroll.sY = dHeight + "px";
//        $(".dataTables_scrollBody").height(cHeight - heightOffset);
        table.draw();
       
        //editor.clear();
    }
    
     function setHistory(msg) {
        var json = JSON.parse(msg);

        $("#history_updated").html(json.updated);
        $("implant_history th").css("width", "0px");
       
        var table = historyTable;
        table.clear();
        table.rows.add(json.types);
        table.draw();
       
    }
  
    
            </script> 
 
 
    </body>

</html>

