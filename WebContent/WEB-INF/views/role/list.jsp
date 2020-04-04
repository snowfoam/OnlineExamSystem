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
            <label>Role Name:</label><input id="search-name" class="wu-text" style="width:100px">
            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">search</a>
        </div>
    </div>
    <!-- End of toolbar -->
    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<style>
.selected{
	background:red;
}
</style>
<!-- Begin of easyui-dialog -->
<div id="add-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:450px; padding:10px;">
	<form id="add-form" method="post">
        <table>
            <tr>
                <td width="100" align="right">Role Name:</td>
                <td><input type="text" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in role name '" /></td>
            </tr>
            <tr>
                <td width="100" align="right">Role Notes:</td>
                <td><textarea name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
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
                <td width="100" align="right">Role Name:</td>
                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in role name'" /></td>
            </tr>
            <tr>
                <td width="100" align="right">Role Notes:</td>
                <td><textarea id="edit-remark" name="remark" rows="6" class="wu-textarea" style="width:260px"></textarea></td>
            </tr>
        </table>
    </form>
</div>
<!-- 选择权限弹窗 -->
<div id="select-authority-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:220px;height:450px; padding:10px;">
     <ul id="authority-tree" url="get_all_menu" checkbox="true"></ul>
</div>

<%@include file="../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
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
			url:'../../admin/role/add',
			dataType:'json',
			type:'post',
			data:data,
			success:function(data){
				if(data.type == 'success'){
					$.messager.alert('message notification','added successfully！','info');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				}else{
					$.messager.alert('message notification',data.msg,'warning');
				}
			}
		});
	}
	
	function selectIcon(){
		if($("#icons-table").children().length <= 0){
			$.ajax({
				url:'../../admin/role/get_icons',
				dataType:'json',
				type:'post',
				success:function(data){
					if(data.type == 'success'){
						var icons = data.content;
						var table = '';
						for(var i=0;i<icons.length;i++){
							var tbody = '<td class="icon-td"><a onclick="selected(this)" href="javascript:void(0)" class="' + icons[i] + '">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></td>';
							if(i == 0){
								table += '<tr>' + tbody;
								continue;
							}
							if((i+1)%24 === 0){
								//console.log(i + '---' + i%12);
								table += tbody + '</tr><tr>';
								continue;
							}
							table += tbody;
						}
						table += '</tr>';
						$("#icons-table").append(table);
					}else{
						$.messager.alert('message notification',data.msg,'warning');
					}
				}
			});
		}
		
		
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
			url:'../../admin/role/edit',
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
				var item = $('#data-datagrid').datagrid('getSelected');
				$.ajax({
					url:'../../admin/role/delete',
					dataType:'json',
					type:'post',
					data:{id:item.id},
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
            title: "Add Role Information",
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
            }]
        });
	}
	
	/**
	* 打开修改窗口
	*/
	function openEdit(){
		//$('#edit-form').form('clear');
		var item = $('#data-datagrid').datagrid('getSelected');
		if(item == null || item.length == 0){
			$.messager.alert('message notification','Please select the data to be modified！','info');
			return;
		}
		
		$('#edit-dialog').dialog({
			closed: false,
			modal:true,
            title: "Update Information",
            buttons: [{
                text: 'datermine',
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
            	$("#edit-name").val(item.name);
            	$("#edit-remark").val(item.remark);
            }
        });
	}	
	
	//某个角色已经拥有的权限
	var existAuthority = null;
	function isAdded(row,rows){
		for(var k=0;k<existAuthority.length;k++){
			if(existAuthority[k].menuId == row.id && haveParent(rows,row.parentId)){
				//console.log(existAuthority[k].menuId+'---'+row.parentId);
				return true;
			}
		}
		return false;
	}
	
	//判断是否有父分类
	
	function haveParent(rows,parentId){
		for(var i=0; i<rows.length; i++){
			if (rows[i].id == parentId){
				if(rows[i].parentId != 0) return true;
			}
		}
		return false;
	}
	
	//判断是否有父类
	function exists(rows, parentId){
		for(var i=0; i<rows.length; i++){
			if (rows[i].id == parentId) return true;
		}
		return false;
	}
	
	//转换原始数据至符合tree的要求
	function convert(rows){
		var nodes = [];
		// get the top level nodes
		//首先获取所有的父分类
		for(var i=0; i<rows.length; i++){
			var row = rows[i];
			if (!exists(rows, row.parentId)){
				nodes.push({
					id:row.id,
					text:row.name
				});
			}
		}
		
		var toDo = [];
		for(var i=0; i<nodes.length; i++){
			toDo.push(nodes[i]);
		}
		while(toDo.length){
			var node = toDo.shift();	// the parent node
			// get the children nodes
			for(var i=0; i<rows.length; i++){
				var row = rows[i];
				if (row.parentId == node.id){
					var child = {id:row.id,text:row.name};
					if(isAdded(row,rows)){
						child.checked = true;
					}
					if (node.children){
						node.children.push(child);
					} else {
						node.children = [child];
					}
					//把刚才创建的孩子再添加到父分类的数组中
					toDo.push(child);
				}
			}
		}
		return nodes;
	}
	
	//打开权限选择框
	function selectAuthority(roleId){
		$('#select-authority-dialog').dialog({
			closed: false,
			modal:true,
            title: "Select Permission Information",
            buttons: [{
                text: 'determine',
                iconCls: 'icon-ok',
                handler: function(){
                	var checkedNodes = $("#authority-tree").tree('getChecked');
                	var ids = '';
                	for(var i=0;i<checkedNodes.length;i++){
                		ids += checkedNodes[i].id + ',';
                	}
                	var checkedParentNodes = $("#authority-tree").tree('getChecked', 'indeterminate');
                	for(var i=0;i<checkedParentNodes.length;i++){
                		ids += checkedParentNodes[i].id + ',';
                	}
                	//console.log(ids);
                	if(ids != ''){
                		
                		$.ajax({
                			url:'add_authority',
                			type:"post",
                			data:{ids:ids,roleId:roleId},
                			dataType:'json',
                			success:function(data){
                				if(data.type == 'success'){
                					$.messager.alert('message notification','Authorization edited successfully！','info');
                					$('#select-authority-dialog').dialog('close');
                				}else{
                					$.messager.alert('message notification',data.msg,'info');
                				}
                			}
                		});
                	}else{
                		$.messager.alert('message notification','Please select at least one permission！','info');
                	}
                }
            }, {
                text: 'cancel',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#select-authority-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	
        		//首先获取该角色已经拥有的权限
        		$.ajax({
        			url:'get_role_authority',
        			data:{roleId:roleId},
        			type:'post',
        			dataType:'json',
        			success:function(data){
        				existAuthority = data;
        				$("#authority-tree").tree({
                    		loadFilter: function(rows){
                    			return convert(rows);
                    		}
                    	});
        			}
        		});
            	
            }
        });
	}
	
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		$('#data-datagrid').datagrid('reload',{
			name:$("#search-name").val()
		});
	});
	
	/** 
	* 载入数据
	*/
	$('#data-datagrid').datagrid({
		url:'list',
		rownumbers:true,
		singleSelect:true,
		pageSize:20,           
		pagination:true,
		multiSort:true,
		fitColumns:true,
		idField:'id',
	    treeField:'name',
		fit:true,
		columns:[[
			{ field:'chk',checkbox:true},
			{ field:'name',title:'Role Name',width:100,sortable:true},
			{ field:'remark',title:'Role Notes',width:100,sortable:true},
			{ field:'icon',title:'Role Action',width:100,formatter:function(value,row,index){
				var test = '<a class="authority-edit" onclick="selectAuthority('+row.id+')"></a>'
				return test;
			}},
		]],
		onLoadSuccess:function(data){  
			$('.authority-edit').linkbutton({text:'Edit Permissions',plain:true,iconCls:'icon-edit'});  
		 }  
	});
</script>