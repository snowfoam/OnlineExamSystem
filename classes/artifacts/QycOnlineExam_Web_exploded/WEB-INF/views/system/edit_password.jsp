<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="copyright" content="All Rights Reserved, Copyright (C) 2013, 猿来入此, Ltd." />
<title></title>
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/easyui/1.3.4/themes/metro/easyui.css" />
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/wu.css" />
<link rel="stylesheet" type="text/css" href="../resources/admin/easyui/css/icon.css" />
<script type="text/javascript" src="../resources/admin/easyui/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="../resources/admin/easyui/easyui/1.3.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../resources/admin/easyui/easyui/1.3.4/locale/easyui-lang-zh_CN.js"></script>
<body class="easyui-layout">

<!-- 修改密码窗口 -->
<div id="edit-dialog" class="easyui-dialog" data-options="closed:false,iconCls:'icon-save',modal:true,title:'Change Password',buttons:[{text:'Confirm Change',iconCls: 'icon-ok',handler:submitEdit}]" style="width:500px; padding:10px;">
	<form id="edit-form" method="post">
        <table>
           <tr>
                <td width="160" align="left">User Name:</td>
                <td><input type="text" name="username" class="wu-text easyui-validatebox" readonly="readonly" value="${admin.username }" /></td>
            </tr>
            <tr>
                <td width="160" align="left">Old Password:</td>
                <td><input type="password" id="oldPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the password'" /></td>
            </tr>
            <tr>
                <td width="160" align="left">New Password:</td>
                <td><input type="password" id="newPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the password'" /></td>
            </tr>
            <tr>
                <td width="160" align="left">Repeat New Password:</td>
                <td><input type="password" id="reNewPassword" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the password'" /></td>
            </tr>
        </table>
    </form>
</div>

</body>

<!-- End of easyui-dialog -->
<script type="text/javascript">
$.messager.defaults = { ok: "determine", cancel: "cancel" };
	function submitEdit(){
		var validate = $("#edit-form").form("validate");
		if(!validate){
			$.messager.alert("message notification","Please check the data you entered!","warning");
			return;
		}
		if($("#newPassword").val() != $("#reNewPassword").val()){
			$.messager.alert("message notification","Passwords entered twice are inconsistent!","warning");
			return;
		}
		$.ajax({
			url:'edit_password',
			type:'post',
			data:{newpassword:$("#newPassword").val(),oldpassword:$("#oldPassword").val()},
			dataType:'json',
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert("message notification","Password reset complete!","warning");
				}else{
					$.messager.alert("message notification",data.msg,"warning");
				}
			}
		})
	}


</script>