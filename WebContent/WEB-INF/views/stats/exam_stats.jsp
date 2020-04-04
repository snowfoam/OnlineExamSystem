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
            <label>Exam List:</label>
             <select id="search-exam" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="-1">all</option>
            	<c:forEach items="${examList}" var="exam">
	            	<option value="${exam.id}">${exam.name}</option>
            	</c:forEach>
             </select>
              <label>EChart:</label>
             <select id="search-chart" class="easyui-combobox" panelHeight="auto" style="width:120px">
            	<option value="-1">all</option>
			<%String[] str={"bar chart","line chart"}; 
			     request.setAttribute("str",str);
			    %>
            	<c:forEach items="${str}" var="s">
	            	<option value="${s}">${s}</option>
            	</c:forEach>
             </select>
            <a href="#" id="search-btn" class="easyui-linkbutton" iconCls="icon-search">search</a>
        </div>
    </div>
    
    <div class="easyui-accordion" style="width:950px;height:660px;">
		<div title="Performance Statistics Chart Display" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
			 <div id="main" style="width: 880px;height:560px;"></div>	
		</div>
	</div>
    
    
</div>
<%@include file="../common/footer.jsp"%>
<!-- End of easyui-dialog -->
<script src="../../resources/admin/easyui/js/echarts.min.js"></script>
<script type="text/javascript">
	
//基于准备好的dom，初始化echarts实例
var myChart = echarts.init(document.getElementById('main'));

// 指定图表的配置项和数据




$("#search-btn").click(function(){
	var examId = $("#search-exam").combobox('getValue');
	var chart = $("#search-chart").combobox('getValue');
	if(examId == -1){
		$.messager.alert('message notification','Please select the test to be counted！','info');
		return;
	}
	$.ajax({
		type: "POST",
		url: "get_stats",
		dataType: "json",
		data: {"examId":examId},
		success: function(data){
			if(data.type == 'success'){
				if(chart == 'bar chart'){
					var option = {
							title: {
				                text: data.name
				            },
							tooltip: {
						        trigger: 'axis',
						        axisPointer: {
						            type: 'cross',
						            crossStyle: {
						                color: '#999'
						            }
						        }
						    },
						    legend: {
				                data:['score']
				            },
						    xAxis: {
						        type: 'category',
						        data: data.studentList
						    },
						    yAxis: {
						        type: 'value'
						    },
						    series: [{
						    	name: 'score',
						        data: data.studentScore,
						        type: 'bar'
						    }]
						};
					// 使用刚指定的配置项和数据显示图表。
					myChart.setOption(option);
				} else if(chart == 'line chart') {
					var option = {
							title: {
				                text: data.name
				            },
							tooltip: {
						        trigger: 'axis',
						        axisPointer: {
						            type: 'cross',
						            crossStyle: {
						                color: '#999'
						            }
						        }
						    },
						    legend: {
				                data:['score']
				            },
						    xAxis: {
						        type: 'category',
						        data: data.studentList
						    },
						    yAxis: {
						        type: 'value'
						    },
						    series: [{
						    	name: 'score',
						        data: data.studentScore,
						        type: 'line'
						    }]
						};
					// 使用刚指定的配置项和数据显示图表。
					myChart.setOption(option);
				}else{
					$.messager.alert('message notification','Please select a chart！','info');
				}
			}else{
				alert(data.msg);
			}
		},
		error: function(){
			alert('System is busy, please try again later');
			window.location.reload();
		}
	}); 
});
	
</script>