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
            <label>Exam Name:</label><input id="search-name" class="wu-text" style="width:100px">
            <label>Subject:</label>
            <select id="search-subject" class="easyui-combobox" panelHeight="auto" style="width:150px">
            	<option value="-1">all</option>
            	<c:forEach items="${subjectList}" var="subject">
	            	<option value="${subject.id}">${subject.name}</option>
            	</c:forEach>
            </select>
            <label>Exam start time:</label><input id="search-startTime" class="wu-text easyui-datetimebox"  style="width:150px">
            <label>Exam end time:</label><input id="search-endTime" class="wu-text easyui-datetimebox" style="width:150px">
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
                <td width="150" align="right">Exam Name:</td>
                <td><input type="text" id="add-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'please enter Exam Name'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Subject:</td>
                <td>
                	<select name="subjectId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select an exam subject'">
		                <c:forEach items="${subjectList}" var="subject">
			            	<option value="${subject.id}">${subject.name}</option>
		            	</c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="150" align="right">Exam start time:</td>
                <td><input type="text" id="add-startTime" name="startTime"  class="wu-text easyui-datetimebox easyui-validatebox" editable="false"></td>
            </tr>
            <tr>
                <td  width="150" align="right">Exam end time:</td>
                <td><input type="text" id="add-endTime" name="endTime" class="wu-text easyui-datetimebox easyui-validatebox" editable="false"></td>
            </tr>
            <tr>
                <td width="150" align="right">Exam time limit:</td>
                <td><input type="text" id="add-avaliableTime" name="avaliableTime" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the test time limit'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Passing score:</td>
                <td><input type="text" id="add-passScore" name="passScore" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the passing mark'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Single Number:</td>
                <td><input type="text" placeholder="each single choice question${singleScore}score" id="add-singleQuestionNum" name="singleQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test single choice questions'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Multiple Number:</td>
                <td><input type="text" placeholder="each multiple choice question${muiltScore}score" id="add-muiltQuestionNum" name="muiltQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test multiple choice questions'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Judgment Number:</td>
                <td><input type="text" placeholder="each judgment question${chargeScore}score" id="add-chargeQuestionNum" name="chargeQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test judgment questions'" ></td>
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
                <td width="150" align="right">Exam Name:</td>
                <td><input type="text" id="edit-name" name="name" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please enter Exam Name'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Subject:</td>
                <td>
                	<select id="edit-subjectId" name="subjectId" class="easyui-combobox easyui-validatebox" panelHeight="auto" style="width:268px" data-options="required:true, missingMessage:'Please select an exam subject'">
		                <c:forEach items="${subjectList}" var="subject">
			            	<option value="${subject.id}">${subject.name}</option>
		            	</c:forEach>
		            </select>
                </td>
            </tr>
            <tr>
                <td width="150" align="right">Exam start time:</td>
                <td><input type="text" id="edit-startTime" name="startTime" class="wu-text easyui-datetimebox easyui-validatebox" editable="false"></td>
            </tr>
            <tr>
                <td width="150" align="right">Exam end time:</td>
                <td><input type="text" id="edit-endTime" name="endTime" class="wu-text easyui-datetimebox easyui-validatebox" editable="false"></td>
            </tr>
            <tr>
                <td width="150" align="right">Exam time limit:</td>
                <td><input type="text" id="edit-avaliableTime" name="avaliableTime" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the test time limit'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Passing Score:</td>
                <td><input type="text" id="edit-passScore" name="passScore" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the passing mark'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Single Number:</td>
                <td><input type="text" placeholder="each single choice question${singleScore}score" id="edit-singleQuestionNum" name="singleQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test single choice questions'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Multiple Number:</td>
                <td><input type="text" placeholder="each multiple choice question${muiltScore}score" id="edit-muiltQuestionNum" name="muiltQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test multiple choice questions'" ></td>
            </tr>
            <tr>
                <td width="150" align="right">Judgment Number:</td>
                <td><input type="text" placeholder="each judgment question${chargeScore}score" id="edit-chargeQuestionNum" name="chargeQuestionNum" class="wu-text easyui-validatebox" data-options="required:true, missingMessage:'Please fill in the number of test judgment questions'" ></td>
            </tr>
        </table>
    </form>
</div>
<%@include file="../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
//日期格式
$.fn.datebox.defaults.formatter = function(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
};
$.fn.datebox.defaults.parser = function(s){
	if (!s) return new Date();
	var ss = s.split('-');
	var y = parseInt(ss[0],10);
	var m = parseInt(ss[1],10);
	var d = parseInt(ss[2],10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
};
	
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
					$.messager.alert('message notification','added successfully！','info');
					$("#add-name").val('');
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
            title: "Edit exam information",
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
            	$("#edit-name").val(item.name);
            	$("#edit-startTime").datetimebox('setValue',format(item.startTime));
            	$("#edit-endTime").datetimebox('setValue',format(item.endTime));
            	$("#edit-passScore").val(item.passScore);
            	$("#edit-singleQuestionNum").val(item.singleQuestionNum);
            	$("#edit-muiltQuestionNum").val(item.muiltQuestionNum);
            	$("#edit-chargeQuestionNum").val(item.chargeQuestionNum);
            	$("#edit-singleQuestionNum").val(item.singleQuestionNum);
            	$("#edit-avaliableTime").val(item.avaliableTime);
            	$("#edit-subjectId").combobox('setValue',item.subjectId);
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
            title: "Add exam information",
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
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		var option = {name:$("#search-name").val()};
		var subjectId = $("#search-subject").combobox('getValue');
		if(subjectId != -1){
			option.subjectId = subjectId;
		}
		var startTime = $("#search-startTime").datetimebox('getValue');
		var endTime = $("#search-endTime").datetimebox('getValue');
		if(startTime != null && startTime != ''){
			option.startTime = startTime;
		}
		if(endTime != null && startTime != ''){
			option.endTime = endTime;
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
			{ field:'name',title:'Name',width:256,sortable:true},
			{ field:'subjectId',title:'Subject',width:180,formatter:function(value,index,row){
				var subjectList = $("#search-subject").combobox("getData");
				for(var i=0;i<subjectList.length;i++){
					if(subjectList[i].value == value)return subjectList[i].text;
				}
				return value;
			}},
			{ field:'startTime',title:'Start Time',width:200,formatter:function(value,index,row){
				return format(value);
			}},
			{ field:'endTime',title:'End Time',width:200,formatter:function(value,index,row){
				return format(value);
			}},
			{ field:'avaliableTime',title:'Limit Time',width:110,formatter:function(value,index,row){
				return value + 'minute';
			}},
			{ field:'questionNum',title:'Total number',width:135},
			{ field:'totalScore',title:'Total Score',width:120},
			{ field:'passScore',title:'Pass Line',width:100},
			{ field:'singleQuestionNum',title:'Single',width:80},
			{ field:'muiltQuestionNum',title:'Multiple',width:80},
			{ field:'chargeQuestionNum',title:'Judgment',width:95},
			{ field:'paperNum',title:'Papers',width:80},
			{ field:'examedNum',title:'Tested',width:80},
			{ field:'passNum',title:'Passed',width:80},
			{ field:'createTime',title:'Add time',width:200,formatter:function(value,index,row){
				return format(value);
			}},
		]]
	});
</script>