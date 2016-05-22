<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>TOWERJAZZ <br> STR  NAVIGATOR</title>
<script type="text/javascript">
function btnClick()
{
	//alert("Testing");
	$(document).ready(function() {
		$("#editSTR").click(function() {
			//alert("Testing");
			$("#strNavigatorForm").attr("action", "/NewClass_multi");
			$("#strNavigatorForm").submit();
		});
		$("#setup").click(function() {
			$("#strNavigatorForm").attr("action", "/NewClass_multi");
			$("#strNavigatorForm").submit();
		});
	});
}
</script>
</head>
<body>
	<form action="strNavigatorForm">
		<div>
		<button class="btn-toolbar" id="editSTR" value="Create Process STR" onclick="btnClick();" title="Create Process STR" >Create Process STR</button> 
		<input type="button" id="setup" value="Create Raw Material STR">
        <!--  <button class="btn-toolbar" id="editSTR" onclick="this.blur();editSTR();"  title="Create Process STR" >Create Process STR</button> 
        <button class="btn-toolbar" id="setup" onclick="this.blur();setupSelections();"  title="Create Raw Material STR" >Create Raw Material STR</button> --> 
        <button class="btn-toolbar" id="types_save" onclick="this.blur();configSave();"  title="SCreate Small Lot STR." >Create Small Lot STR</button> 
        <button class="btn-toolbar" id="str_print" onclick="this.blur();"  title="View Process STR's">View Process STR's</button> 
        <button class="btn-toolbar" id="str_modifyLots" onclick="this.blur();configSetCallbacks.addModifyLots();addModifyLots();"  title="View Raw Material STR's" >View Raw Material STR's</button>
        <button class="btn-toolbar" id="str_approve" onclick="this.blur();selectApprover();"  title="View Small Lot STR's" >View Small Lot STR's</button>
        <button class="btn-toolbar" id="str_reject" onclick="this.blur();selectRejection();"  title="Administration" >Administration</button>
        <button  class="btn-toolbar" id="str_delete" onclick="this.blur();confirmCloseSTR();"   title="Exit" >Exit</button>
		</div>
		 <p style="text-align:left; color:#666; font-size:50px"><b> TowerJazz <br> STR  Navigator</b> </p>
	</form> 
</body>
</html>