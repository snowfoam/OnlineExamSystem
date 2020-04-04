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
            <label>Question Name:</label><input id="search-title" class="wu-text" style="width:100px">
            <label>Type:</label>
            <select id="search-question-type" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="-1">all</option>
            	<option value="0">single choice</option>
            	<option value="1">multiple choice</option>
            	<option value="2">judgment</option>
            </select>
            <label>Question Subject:</label>
            <select id="search-subject" class="easyui-combobox" panelHeight="auto" style="width:150px">
            	<option value="-1">all</option>
            	<c:forEach items="${subjectList}" var="subject">
	            	<option value="${subject.id}">${subject.name}</option>
            	</c:forEach>
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
                <td align="right">Question Name:</td>
                <td><input type="text" id="add-title" name="title" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the test questions'" ></td>
            </tr>
            <tr>
                <td align="right">Question Subject:</td>
                <td>
                	<select name="subjectId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select an exam subject'">
		                <c:forEach items="${subjectList}" var="subject">
			            	<option value="${subject.id}">${subject.name}</option>
		            	</c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td align="right">Type:</td>
                <td>
                	<select name="questionType" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select the question type'">
		                <option value="0">single choice</option>
		            	<option value="1">multiple choice</option>
		            	<option value="2">judgment</option>
		            </select>
                </td>
            </tr>
            <tr>
                <td align="right">optionsA:</td>
                <td><input type="text" id="add-attrA" name="attrA" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in option A'"></td>
            </tr>
            <tr>
                <td align="right">optionsB:</td>
                <td><input type="text" id="add-attrB" name="attrB" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in option B'"></td>
            </tr>
            <tr>
                <td align="right">optionsC:</td>
                <td><input type="text" id="add-attrC" name="attrC" class="wu-text" ></td>
            </tr>
            <tr>
                <td align="right">optionsD:</td>
                <td><input type="text" id="add-attrD" name="attrD" class="wu-text" ></td>
            </tr>
            <tr>
                <td align="right">correct answer:</td>
                <td><input type="text" id="add-answer" name="answer" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'please enter correct answer'"></td>
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
                <td align="right">Question Name:</td>
                <td><input type="text" id="edit-title" name="title" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'please enter Question Name'" ></td>
            </tr>
            <tr>
                <td align="right">Question Subject:</td>
                <td>
                	<select id="edit-subjectId" name="subjectId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select an exam subject'">
		                <c:forEach items="${subjectList}" var="subject">
			            	<option value="${subject.id}">${subject.name}</option>
		            	</c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td align="right">Type:</td>
                <td>
                	<select id="edit-questionType" name="questionType" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select a question type'">
		                <option value="0">single choice</option>
		            	<option value="1">multiple choice</option>
		            	<option value="2">judgment</option>
		            </select>
                </td>
            </tr>
            <tr>
                <td align="right">optionsA:</td>
                <td><input type="text" id="edit-attrA" name="attrA" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in option A'"></td>
            </tr>
            <tr>
                <td align="right">optionsB:</td>
                <td><input type="text" id="edit-attrB" name="attrB" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in option B'"></td>
            </tr>
            <tr>
                <td align="right">optionsC:</td>
                <td><input type="text" id="edit-attrC" name="attrC" class="wu-text" ></td>
            </tr>
            <tr>
                <td align="right">optionsD:</td>
                <td><input type="text" id="edit-attrD" name="attrD" class="wu-text" ></td>
            </tr>
            <tr>
                <td align="right">correct answer:</td>
                <td><input type="text" id="edit-answer" name="answer" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'please enter correct answer'"></td>
            </tr>
        </table>
    </form>
</div>
<!-- 导入文件窗口 -->
<div id="import-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-save'" style="width:500px; padding:10px;">
        <table>
           <tr>
                <td align="right">Select File:</td>
                <td><input type="text" id="import-filename" name="filename" class="wu-text easyui-validatebox" readonly="readonly" data-options="required:true, missingMessage:'Please select a file'" ></td>
            	<td><a onclick="uploadFile()" href="javascript:void(0)" id="select-file-btn" class="easyui-linkbutton" iconCls="icon-upload">Select File</a></td>
            </tr>
            <tr>
                <td align="right">Subject:</td>
                <td>
                	<select id="import-subjectId" name="subjectId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select an exam subject'">
		                <c:forEach items="${subjectList}" var="subject">
			            	<option value="${subject.id}">${subject.name}</option>
		            	</c:forEach>
		            </select>
                </td>
                <td></td>
            </tr>
        </table>
</div>
<div id="process-dialog" class="easyui-dialog" data-options="closed:true,iconCls:'icon-upload',title:'uploading file'" style="width:450px; padding:10px;">
<div id="p" class="easyui-progressbar" style="width:400px;" data-options="text:'uploading ...'"></div>
</div>
<input type="file" id="excel-file" style="display:none;" onchange="selected()">
<%@include file="../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
$.messager.defaults = { ok: "determine", cancel: "cancel" };
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
function selected(){
	$("#import-filename").val($("#excel-file").val());
}
function upload(){
	if($("#excel-file").val() == '')return;
	var formData = new FormData();
	formData.append('excelFile',document.getElementById('excel-file').files[0]);
	formData.append('subjectId',$("#import-subjectId").combobox('getValue'));
	$("#process-dialog").dialog('open');
	var interval = setInterval(start,200);
	$.ajax({
		url:'upload_file',
		type:'post',
		data:formData,
		contentType:false,
		processData:false,
		success:function(data){
			clearInterval(interval);
			$("#process-dialog").dialog('close');
			if(data.type == 'success'){
				 $('#import-dialog').dialog('close');
				 $('#data-datagrid').datagrid('reload');
				 $.messager.alert("message notification",data.msg,"info");
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

function uploadFile(){
	$("#excel-file").click();
	
}
	
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
					$.messager.alert('message notification','added successfully！','info');
					$("#add-name").val('');
					$("#add-password").val('');
					$("#add-truename").val('');
					$("#add-tel").val('');
					$('#add-dialog').dialog('close');
					$('#data-datagrid').datagrid('reload');
				}else{
					$.messager.alert('message notification',data.msg,'warning');
				}
			}
		});
	}
	
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
					$.messager.alert('message notification','update successfully！','info');
					$("#edit-name").val('');
					$("#edit-remark").val('');
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
				if(item == null || item.length == 0){
					$.messager.alert('message notification','Please select the data to delete！','info');
					return;
				}
				$.ajax({
					url:'delete',
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
	
	/*
	编辑
	*/
	function openEdit(){
		//$('#add-form').form('clear');
		var item = $('#data-datagrid').datagrid('getSelected');
		if(item == null || item.length == 0){
			$.messager.alert('message notification','Please select the data to edit！','info');
			return;
		}
		$('#edit-dialog').dialog({
			closed: false,
			modal:true,
            title: "Editing test question information",
            buttons: [{
                text: 'determine',
                iconCls: 'icon-ok',
                handler:edit
            }, {
                text: 'cancel',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#edit-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	//$("#add-form input").val('');
            	$("#edit-id").val(item.id);
            	$("#edit-title").val(item.title);
            	$("#edit-attrA").val(item.attrA);
            	$("#edit-attrB").val(item.attrB);
            	$("#edit-attrC").val(item.attrC);
            	$("#edit-attrD").val(item.attrD);
            	$("#edit-answer").val(item.answer);
            	$("#edit-questionType").combobox('setValue',item.questionType);
            	$("#edit-subjectId").combobox('setValue',item.subjectId);
            }
        });
	}
	
	function openImport(){
		$('#import-dialog').dialog({
			closed: false,
			modal:true,
            title: "Import exam information",
            buttons: [{
                text: 'determine',
                iconCls: 'icon-ok',
                handler: upload
            }, {
                text: 'cancel',
                iconCls: 'icon-cancel',
                handler: function () {
                    $('#import-dialog').dialog('close');                    
                }
            }],
            onBeforeOpen:function(){
            	//$("#add-form input").val('');
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
            title: "Add test question information",
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
            	$("#add-form input").val('');
            }
        });
	}
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		var option = {title:$("#search-title").val()};
		var questionType = $("#search-question-type").combobox('getValue');
		var subjectId = $("#search-subject").combobox('getValue');
		if(questionType != -1){
			option.questionType = questionType;
		}
		if(subjectId != -1){
			option.subjectId = subjectId;
		}
		$('#data-datagrid').datagrid('reload',option);
	});
	
	function add0(m){return m<10?'0'+m:m }
	function format(shijianchuo){
	//shijianchuo是整数，否则要parseInt转换
		var time = new Date(shijianchuo);
		var y = time.getFullYear();
		var m = time.getMonth()+1;
		var d = time.getDate();
		var h = time.getHours();
		var mm = time.getMinutes();
		var s = time.getSeconds();
		return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
	}
	
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
	    nowrap:false,
		fit:true,
		columns:[[
			{ field:'chk',checkbox:true},
			{ field:'title',title:'Question Name',width:250,sortable:true},
			{ field:'subjectId',title:'Subject',width:180,formatter:function(value,index,row){
				var subjectList = $("#search-subject").combobox("getData");
				for(var i=0;i<subjectList.length;i++){
					if(subjectList[i].value == value)return subjectList[i].text;
				}
				return value;
			}},
			{ field:'score',title:'Score',width:50,sortable:true},
			{ field:'questionType',title:'Type',width:150,formatter:function(value,index,row){
				switch(value){
					case 0:return 'single choice';
					case 1:return 'multiple choice';
					case 2:return 'judgement';
					default:return value;
				}
			}},
			{ field:'attrA',title:'OptionA',width:150},
			{ field:'attrB',title:'OptionB',width:150},
			{ field:'attrC',title:'OptionC',width:150},
			{ field:'attrD',title:'OptionD',width:150},
			{ field:'answer',title:'correct answer',width:150},
			{ field:'createTime',title:'add time',width:200,formatter:function(value,index,row){
				return format(value);
			}},
		]]
	});
</script>