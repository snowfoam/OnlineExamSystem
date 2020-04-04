<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../common/header.jsp"%>
<div class="easyui-layout" data-options="fit:true">
    <!-- Begin of toolbar -->
    <div id="wu-toolbar">
        <div class="wu-toolbar-button">
            <%@include file="../common/menus.jsp"%>
        </div>
        <div class="wu-toolbar-search">
            <label>User Name:</label><input id="search-name" class="wu-text" style="width:100px">
            <label>Role:</label>
            <select id="search-role" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="-1">all</option>
            	<c:forEach items="${roleList }" var="role">
            		<option value="${role.id }">${role.name }</option>
            	</c:forEach>
            </select>
            <label>Gender:</label>
            <select id="search-sex" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="-1">all</option>
            	<option value="0">unknown</option>
            	<option value="1">male</option>
            	<option value="2">female</option>
            </select>
            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">search</a>
        </div>
    </div>
    <!-- End of toolbar -->
    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<!-- Begin of easyui-dialog -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:420px; padding:10px;">
	<form id="add-form" method="post">
        <table>
            <tr>
                <td width="60" align="right">Preview:</td>
                <td valign="middle">
                	<img id="preview-photo" style="float:left;" src="/BaseProjectSSM/resources/admin/easyui/images/user_photo.jpg" width="100px">
                	<a style="float:left;margin-top:40px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true">upload image</a>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Avatar:</td>
                <td><input type="text" id="add-photo" name="photo" value="/BaseProjectSSM/resources/admin/easyui/images/user_photo.jpg" readonly="readonly" class="wu-text " /></td>
            </tr>
            <tr>
                <td width="60" align="right">UserName:</td>
                <td><input type="text" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please enter your username'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">Password:</td>
                <td><input type="password" name="password" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the password'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">Role:</td>
                <td>
                	<select name="roleId" class="easyui-combobox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select a role'">
		                <c:forEach items="${roleList }" var="role">
		                <option value="${role.id }">${role.name }</option>
		                </c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Gender:</td>
                <td>
                	<select name="sex" class="easyui-combobox" panelHeight="auto" style="width:268px">
		                <option value="0">unknown</option>
            			<option value="1">male</option>
            			<option value="2">female</option>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Age:</td>
                <td><input type="text" name="age" class="wu-text easyui-numberbox easyui-validatebox" data-options="required:true,min:1,precision:0, missingMessage:'Please fill in age '" /></td>
            </tr>
            <tr>
                <td width="60" align="right">Address:</td>
                <td><input type="text" name="address" class="wu-text easyui-validatebox" /></td>
            </tr>
        </table>
    </form>
</div>
<!-- 修改窗口 -->
<div id="edit-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
	<form id="edit-form" method="post">
        <input type="hidden" name="id" id="edit-id">
        <table>
            <tr>
                <td width="60" align="right">Preview:</td>
                <td valign="middle">
                	<img id="edit-preview-photo" style="float:left;" src="/BaseProjectSSM/resources/admin/easyui/images/user_photo.jpg" width="100px">
                	<a style="float:left;margin-top:40px;" href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-upload" onclick="uploadPhoto()" plain="true">upload image</a>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Avatar:</td>
                <td><input type="text" id="edit-photo" name="photo" value="/BaseProjectSSM/resources/admin/easyui/images/user_photo.jpg" readonly="readonly" class="wu-text " /></td>
            </tr>
            <tr>
                <td width="60" align="right">UserName:</td>
                <td><input type="text" id="edit-username" name="username" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please enter your username'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">Role:</td>
                <td>
                	<select id="edit-roleId" name="roleId" class="easyui-combobox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select a role'">
		                <c:forEach items="${roleList }" var="role">
		                <option value="${role.id }">${role.name }</option>
		                </c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Gender:</td>
                <td>
                	<select id="edit-sex" name="sex" class="easyui-combobox" panelHeight="auto" style="width:268px">
		                <option value="0">unknown</option>
            			<option value="1">male</option>
            			<option value="2">female</option>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="60" align="right">Age:</td>
                <td><input type="text" id="edit-age" name="age" value="1" class="wu-text easyui-numberbox easyui-validatebox" data-options="required:true,min:1,precision:0, missingMessage:'Please fill in the age'" /></td>
            </tr>
            <tr>
                <td width="60" align="right">Address:</td>
                <td><input type="text" id="edit-address" name="address" class="wu-text easyui-validatebox" /></td>
            </tr>
        </table>
    </form>
</div>
<div id="process-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-upload',title:'Uploading picture'" style="width:450px; padding:10px;">
<div id="p" class="easyui-progressbar" style="width:400px;" data-options="text:'Uploading ...'"></div>
</div>
<input type="file" id="photo-file" style="display:none;" onchange="upload()">
<%@include file="../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
	//上传图片
	function start(){
			var value = $('#p').progressbar('getValue');
			if (value < 100){
				value += Math.floor(Math.random() * 10);
				$('#p').progressbar('setValue', value);
			}else{
				$('#p').progressbar('setValue',0)
			}
	};
	function upload(){
		if($("#photo-file").val() == '')return;
		var formData = new FormData();
		formData.append('photo',document.getElementById('photo-file').files[0]);
		$("#process-dialog").dialog('open');
		var interval = setInterval(start,200);
		$.ajax({
			url:'upload_photo',
			type:'post',
			data:formData,
			contentType:false,
			processData:false,
			success:function(data){
				clearInterval(interval);
				$("#process-dialog").dialog('close');
				if(data.type == 'success'){
					$("#preview-photo").attr('src',data.filepath);
					$("#add-photo").val(data.filepath);
					$("#edit-preview-photo").attr('src',data.filepath);
					$("#edit-photo").val(data.filepath);
				}else{
					$.messager.alert("message notification",data.msg,"warning");
				}
			},
			error:function(data){
				clearInterval(interval);
				$("#process-dialog").dialog('close');
				$.messager.alert("message notification","upload failed!","warning");
			}
		});
	}
	
	function uploadPhoto(){
		$("#photo-file").click();
		
	}
	
	$.messager.defaults = { ok: "determine", cancel: "cancel" };
	
	/**
	*  添加记录
	*/
	function add(){
		var validate = $("#add-form").form("validate");
		if(!validate){
			$.messager.alert("message notification","Please check the data you entered!","warning");
			return;
		}
		var data = $("#add-form").serialize();
		$.ajax({
			url:'add',
			dataType:'json',
			type:'post',
			data:data,
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert('message notification','Added successfully！','info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				}else{
					$.messager.alert('message notification',data.msg,'warning');
				}
			}
		});
	}
	
	/**
	* Name 修改记录
	*/
	function edit(){
		var validate = $("#edit-form").form("validate");
		if(!validate){
			$.messager.alert("message notification","Please check the data you entered!","warning");
			return;
		}
		var data = $("#edit-form").serialize();
		$.ajax({
			url:'edit',
			dataType:'json',
			type:'post',
			data:data,
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert('message notification','Successfully modified！','info');
					$('#edit-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				}else{
					$.messager.alert('message notification',data.msg,'warning');
				}
			}
		});
	}
	
	/**
	* 删除记录
	*/
	function remove(){
		$.messager.confirm('message notification','Are you sure you want to delete this record？', function(result){
			if(result){
				var item = $('#data-datagrid').datagrid('getSelections');
				if(item == null || item.length == 0){
					$.messager.alert('message notification','Please select the data to delete！','info');
					return;
				}
				var ids = '';
				for(var i=0;i<item.length;i++){
					ids += item[i].id + ',';
				}
				$.ajax({
					url:'delete',
					dataType:'json',
					type:'post',
					data:{ids:ids},
					success:function(data){
						if(data.type == 'success'){
							$.messager.alert('message notification','successfully deleted！','info');
							$('#data-datagrid').datagrid('reload');
						}else{
							$.messager.alert('message notification',data.msg,'warning');
						}
					}
				});
			}	
		});
	}
	
	/**
	* Name 打开添加窗口
	*/
	function openAdd(){
		//$('#add-form').form('clear');
		$('#add-dialog').dialog({
			closed: false,
			modal:true,
            title: "Add user information",
            buttons: [{
                text: 'determine',
                iconCls: 'icon-ok',
                handler: add
            }, {
                text: 'cancel',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#add-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	//$("#add-form input").val('');
            }
        });
	}
	
	/**
	* 打开修改窗口
	*/
	function openEdit(){
		//$('#edit-form').form('clear');
		var item = $('#data-datagrid').datagrid('getSelections');
		if(item == null || item.length == 0){
			$.messager.alert('message notification','Please select the data to be modified！','info');
			return;
		}
		if(item.length > 1){
			$.messager.alert('message notification','Please select a piece of data to modify！','info');
			return;
		}
		item = item[0];
		$('#edit-dialog').dialog({
			closed: false,
			modal:true,
            title: "Modify user information",
            buttons: [{
                text: 'determine',
                iconCls: 'icon-ok',
                handler: edit
            }, {
                text: 'cancel',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#edit-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	$("#edit-id").val(item.id);
            	$("#edit-preview-photo").attr('src',item.photo);
				$("#edit-photo").val(item.photo);
            	$("#edit-username").val(item.username);
            	$("#edit-roleId").combobox('setValue',item.roleId);
            	$("#edit-sex").combobox('setValue',item.sex);
            	$("#edit-age").val(item.age);
            	$("#edit-address").val(item.address);
            }
        });
	}	
	
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		var roleId = $("#search-role").combobox('getValue');
		var sex = $("#search-sex").combobox('getValue')
		var option = {username:$("#search-name").val()};
		if(roleId != -1){
			option.roleId = roleId;
		}
		if(sex != -1){
			option.sex = sex;
		}
		$('#data-datagrid').datagrid('reload',option);
	});
	
	/** 
	* 载入数据
	*/
	$('#data-datagrid').datagrid({
		url:'list',
		rownumbers:true,
		singleSelect:false,
		pageSize:20,           
		pagination:true,
		multiSort:true,
		fitColumns:true,
		idField:'id',
	    treeField:'name',
		fit:true,
		columns:[[
			{ field:'chk',checkbox:true},
			{ field:'photo',title:'Profile Picture',width:100,align:'center',formatter:function(value,row,index){
				var img = '<img src="'+value+'" width="50px" />';
				return img;
			}},
			{ field:'username',title:'User Name',width:100,sortable:true},
			{ field:'password',title:'Password',width:100},
			{ field:'roleId',title:'Role',width:100,formatter:function(value,row,index){
				var roleList = $("#search-role").combobox('getData');
				for(var i=0;i<roleList.length;i++){
					if(value == roleList[i].value)return roleList[i].text;
				}
				return value;
			}},
			{ field:'sex',title:'Gender',width:100,formatter:function(value,row,index){
				switch(value){
					case 0:{
						return 'unknown';
					}
					case 1:{
						return 'male';
					}
					case 2:{
						return 'female';
					}
				}
				return value;
			}},
			{ field:'age',title:'Age',width:100},
			{ field:'address',title:'Address',width:200}
		]],
		onLoadSuccess:function(data){  
			$('.authority-edit').linkbutton({text:'Edit permissions',plain:true,iconCls:'icon-edit'});  
		 }  
	});
</script>