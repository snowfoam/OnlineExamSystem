<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../common/header.jsp"%>
<div class="easyui-layout" data-options="fit:true">
    <!-- Begin of toolbar -->
    <div id="wu-toolbar">
  
           <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cross'" onclick="remove()" plain="true">delete</a>
   
        <div class="wu-toolbar-search">
            <label>Exam:</label>
            <select id="search-exam" class="easyui-combobox" panelHeight="200px" style="width:120px">
            	<option value="-1">all</option>
            	<c:forEach items="${examList}" var="exam">
	            	<option value="${exam.id}">${exam.name}</option>
            	</c:forEach>
            </select>
            <label>Student:</label>
            <select id="search-student" class="easyui-combobox" panelHeight="200px" style="width:120px">
            	<option value="-1">all</option>
            	<c:forEach items="${studentList}" var="student">
	            	<option value="${student.id}">${student.name}</option>
            	</c:forEach>
            </select>
            <label>Exam Questions:</label>
            <select id="search-question" class="easyui-combobox" panelHeight="300px" style="width:120px">
            	<option value="-1">all</option>
            	<c:forEach items="${questionList}" var="question">
	            	<option value="${question.id}">${question.title}</option>
            	</c:forEach>
            </select>
            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">search</a>
        </div>
    </div>
    <!-- End of toolbar -->
    <table id="data-datagrid" class="easyui-datagrid" toolbar="#wu-toolbar"></table>
</div>
<%@include file="../common/footer.jsp"%>

<!-- End of easyui-dialog -->
<script type="text/javascript">
	
	
	
$.messager.defaults = { ok: "determine", cancel: "cancel" };
	
	
	
	//搜索按钮监听
	$("#search-btn").click(function(){
		var option = {};
		var examId = $("#search-exam").combobox('getValue');
		if(examId != -1){
			option.examId = examId;
		}
		var studentId = $("#search-student").combobox('getValue');
		if(studentId != -1){
			option.studentId = studentId;
		}
		var questionId = $("#search-question").combobox('getValue');
		if(questionId != -1){
			option.questionId = questionId;
		}
		$('#data-datagrid').datagrid('reload',option);
	});
	
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
			{ field:'examId',title:'Exam',width:180,formatter:function(value,index,row){
				var examList = $("#search-exam").combobox("getData");
				console.log(examList);
				console.log(value);
				for(var i=0;i<examList.length;i++){
					if(examList[i].value == value)return examList[i].text;
				}
				return value;
			}},
			{ field:'examPaperId',title:'Paper ID',width:200},
			{ field:'questionId',title:'Exam Questions',width:200,formatter:function(value,index,row){
				var questionList = $("#search-question").combobox("getData");
				for(var i=0;i<questionList.length;i++){
					if(questionList[i].value == value)return questionList[i].text;
				}
				return value;
			}},
			{ field:'studentId',title:'Student',width:180,formatter:function(value,index,row){
				var studentList = $("#search-student").combobox("getData");
				for(var i=0;i<studentList.length;i++){
					if(studentList[i].value == value)return studentList[i].text;
				}
				return value;
			}},
			{ field:'answer',title:'Submit Answer',width:200},
			{ field:'isCorrect',title:'Is Correct',width:200,formatter:function(value,index,row){
				if(value == 0) return 'error';
				return 'correct';
			}},
		]]
	});
</script>