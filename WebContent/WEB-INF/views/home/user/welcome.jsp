<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../common/user_header.jsp"%>
<style>
		h2{font-size:14px; margin:20px 0 10px 0;}
		.tm_param_list a{color:#000}
		.tm_param_list a:hover{color:#f00}

		.tm_blocker{float:left; width:50%;min-width:450px}
		.tm_blocker2{float:left; width:800px;}
</style>
<body>
	
    <div class="tm_main" style="min-width:1000px">
    	
        
        <div class="tm_container">
        	<div class="tm_navtitle">
            	<h1>Welcome</h1>
                <span>Welcome to Online Exam System</span>
            </div>
        </div>



			<script type="text/javascript">
				var tm = {
					startExam : function(e){
						var tr = $("#"+e);
						var eid = tr.attr("data-key");
						var html = [];
						html.push('<div style="margin:20px">');
						html.push('	<p style="line-height:20px">Are you sure you want to enter the test paper and start the exam?</p>');
						
						html.push('	<table style="margin:0 auto; width:350px" border="0" cellpadding="0" cellspacing="0">');
						html.push('	<tr>');
						html.push('		<td width="80"><img src="../../resources/home/images/paper_pencil.png" width="60" /></td>');
						html.push('		<td><p><b>Exam Name</b>：'+tr.find("td").eq(0).text()+'<p>');
						html.push('			<p><b>Time Set</b>：'+tr.find("td").eq(2).text()+'<p>');
						html.push('			<p><b>Total Score</b>：'+tr.find("td").eq(4).text()+'<p>');
						html.push('			<p><b>Pass Score</b>：'+tr.find("td").eq(5).text()+'<p>');
						html.push('		</td>');
						html.push('	</tr>');
						html.push('</table>');

						html.push('<p style="text-align:center; margin-top:30px">');
						html.push('<button class="confir-exam tm_btn tm_btn_primary" type="button" onclick="tm.joinExam(\''+eid+'\')">Determine</button>');
						html.push('</p>');

						html.push('</div>');

						layer.open({
						  type: 1,
						  title: 'Start Exam',
						  shadeClose: true,
						  shade: 0.8,
						  area: ['450px', '310px'],
						  content: html.join("")
						}); 

						return false;
					},
					joinExam : function(eid){
						$(".confir-exam").text('Please wait...');
						$(".confir-exam").attr("disabled", true);
						$.ajax({
							type: "POST",
							url: "../exam/statr_exam",
							dataType: "json",
							data: {"examId":eid},
							success: function(data){
								if(data.type == 'success'){
									top.window.location="../exam/examing?examId="+eid;
								}else{
									alert(data.msg);
									window.location.reload();
								}
							},
							error: function(){
								alert('System is busy, please try again later');
								window.location.reload();
							}
						});
					}
				};


				
			</script>



			<div class="tm_container">
				<div class="tm_blocker2">
					<h2>Exams in progress</h2>
					<table width="100%" cellpadding="10" border="0" class="layui-table">
						<thead>
							<tr>
								<th>Exam Name</th>
								<th>Time Set</th>
								<th>Total Time</th>
								<th>Subject</th>
								<th>Total Score</th>
								<th>Pass Score</th>
								<th>Option</th>
							</tr>
						</thead>
						<tbody>
							
								
									<c:if test="${empty examList}">
									<tr>
										<td colspan="7">No exams in progress</td>
									</tr>
									</c:if>
							<c:forEach items="${examList }" var = "exam">
								<tr id="tr-${exam.id }" data-key="${exam.id }">
										<td >${exam.name }</td>
										<td ><fmt:formatDate value="${exam.startTime }" pattern="yyyy-MM-dd HH:mm:ss"/>---<fmt:formatDate value="${exam.endTime }" pattern="yyyy-MM-dd HH:mm:ss"/></td>
										<td >${exam.avaliableTime }minute</td>
										<td >${subject.name }</td>
										<td >${exam.totalScore }</td>
										<td >${exam.passScore }</td>
										<td ><button class="tm_btn tm_btn_primary" onclick="tm.startExam('tr-${exam.id }');">Start Exam</button></td>
								</tr>
							</c:forEach>	
							
						</tbody>
					</table>
				</div>
			</div>

			<div class="tm_container">
				<div class="tm_blocker2">
					<h2>Exams taken</h2>
					<table width="100%" cellpadding="10" border="0" class="layui-table">
						<thead>
							<tr>
								<th>Exam Name</th>
								<th>Time Set</th>
								<th>Use Time</th>
								<th>Time</th>
								<th>Score</th>
								<th>Option</th>
							</tr>
						</thead>
						<tbody>
							
									<c:if test="${empty historyList}">
										<tr>
											<td colspan="6">You haven't tried exam yet!</td>
									</tr>
									</c:if>
								
									<c:forEach items="${historyList }" var = "history">
									<tr>
										<td>${history.exam.name}</td>
										<td><span class="tm_label">${history.exam.avaliableTime}</span> minute</td>
										<td><span class="tm_label">${history.useTime}</span> minute</td>
										<td>
											<fmt:formatDate value="${history.startExamTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
											<br/><fmt:formatDate value="${history.endExamTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
										</td>
										<td>
											<span class="tm_label">${history.score}</span>
											<c:if test="${history.exam.passScore > history.score }">
											<font color="red"><b>failed</b></font>
											</c:if>
										</td>
										<td>
													<a href="review_exam?examId=${history.exam.id }&examPaperId=${history.id}" target="_blank" class="tm_btn tm_btn_primary" style="text-decoration:none;color:white;" >Review papers</a>
										</td>
									</tr>
									</c:forEach>
									
									
								
							
						</tbody>
					</table>
				</div>
			</div>
			<div class="tm_container"></div>
        
    </div>
	
	<p>&nbsp;</p>

</body>
</html>