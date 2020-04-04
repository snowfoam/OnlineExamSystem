<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../common/user_header.jsp"%>
<body>

	<div class="tm_main">
    	
		 
        <div class="tm_container">
        	<div class="tm_navtitle">
				<h1>My Exam</h1>
                <span>My exam, please choose the exam I need to take from the list below.</span>
            </div>
        </div>
        
        <div class="tm_container">
			<form action="exam_list" method="get">
			<div class="tm_searchbox">
				Exam Name :
				<input type="text" name="name" class="tm_txts" size="10" maxlength="20" value="${name}" /> &nbsp;
				<button class="tm_btns" type="submit">Search</button>
			</div>
			
			<!-- 当前日期 -->
			
        	<table width="100%" cellpadding="10" border="0" class="layui-table">
            	<thead>
                	<tr>
                        <th>Exam Name</th>
                    	<th>Time Set</th>
                        <th>Total Time</th>
                        <th>Type</th>
                        <th>Total Score</th>
                        <th>Pass Score</th>
                        <th>Option</th>
                    </tr>
                </thead>
                <tbody>
					<c:if test="${empty examList}">
						<tr>
							<td colspan="7">You have no exam information!</td>
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
								<td >
									<c:if test="${nowTime > exam.endTime.time}">
										<button type="button" class="tm_btn" >Exam has ended</button>
									</c:if>
									<c:if test="${nowTime < exam.endTime.time}">
										<button type="button" class="tm_btn tm_btn_primary" onclick="tm.startExam('tr-${exam.id }');">Start exam</button>
									</c:if>
								</td>
						</tr>
					</c:forEach>
                </tbody>
            </table>
			</form>
			<table width="100%" cellpadding="10" border="0" class="layui-table">
				<tfoot>
					<tr>
						<td>
							<div class="tm_pager_foot">
								<a href="exam_list?page=${page - 1}" class="tm_btns" style="color:white;text-decoration:none;">Previous</a>&nbsp;&nbsp;&nbsp;<font size="5" color="red"><b>${page}</b></font>&nbsp;&nbsp;&nbsp;<a href="exam_list?page=${page + 1}" class="tm_btns" style="color:white;text-decoration:none;">Next</a>&nbsp; 
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
        </div>
        
        
    </div>
<script type="text/javascript">
		window.onload = function(){
			$(".layui-table tbody tr").mouseover(function(){
				$(this).attr("style","background:#f5f5f5");
			});
			$(".layui-table tbody tr").mouseout(function(){
				$(this).attr("style","background:#ffffff");
			});
		}

		var tm = {
				startExam : function(e){
					var tr = $("#"+e);
					var eid = tr.attr("data-key");
					var html = [];
					html.push('<div style="margin:20px">');
					html.push('	<p style="line-height:20px">Are you sure you want to enter the exam paper and start the exam?</p>');
					
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
</body>
</html>