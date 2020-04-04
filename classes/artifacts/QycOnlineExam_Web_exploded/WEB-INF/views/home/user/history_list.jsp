<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="../common/user_header.jsp"%>
<body>

	<div class="tm_main">
    	
        
        <div class="tm_container">
        	<div class="tm_navtitle">
				<h1>History Exam</h1>
                <span>History exams, please select the exams I took in the list below for details.</span>
            </div>
        </div>
        
        <div class="tm_container">
			<form action="history_list" method="get">
			<div class="tm_searchbox">
				Exam Name :
				<input type="text" name="name" class="tm_txts" size="10" maxlength="20" value="${name }" /> &nbsp;
				<button class="tm_btns" type="submit">Search</button>
			</div>

        	<table width="100%" cellpadding="10" border="0" class="layui-table">
            	<thead>
                	<tr>
                        <th>Exam Name</th>
						<th>Exam Status</th>
                        <th>Total Time</th>
                    	<th>Use Time</th>
                    	<th>Time</th>
                        <th>Subject</th>
                        <th>Score</th>
                        <th>Total Score</th>
                        <th>Option</th>
                    </tr>
                </thead>
                <tbody>
					<c:if test="${empty historyList}">
						<tr>
							<td colspan="9">You haven't tried it yet!</td>
					</tr>
					</c:if>
				
					<c:forEach items="${historyList }" var = "history">
					<tr>
						<td>${history.exam.name}</td>
						<td>Reviewed</td>
						<td><span class="tm_label">${history.exam.avaliableTime}</span> minute</td>
						<td><span class="tm_label">${history.useTime}</span> minute</td>
						<td>
							<fmt:formatDate value="${history.startExamTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
							<br/><fmt:formatDate value="${history.endExamTime }" pattern="yyyy-MM-dd HH:mm:ss"/>
						</td>
						<td >${subject.name }</td>
						<td>
							<span class="tm_label">${history.score}</span>
							<c:if test="${history.exam.passScore > history.score }">
							<font color="red"><b>failed</b></font>
							</c:if>
						</td>
						<td >${history.exam.passScore }/${history.exam.totalScore }</td>
						<td>
							<a href="review_exam?examId=${history.exam.id }&examPaperId=${history.id}" target="_blank" class="tm_btn tm_btn_primary" style="text-decoration:none;color:white;" >Review Papers</a>
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
								<a href="history_list?page=${page - 1}" class="tm_btns" style="color:white;text-decoration:none;">Previous</a>&nbsp;&nbsp;&nbsp;<font size="5" color="red"><b>${page}</b></font>&nbsp;&nbsp;&nbsp;<a href="history_list?page=${page + 1}" class="tm_btns" style="color:white;text-decoration:none;">Next</a>&nbsp; 
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
	</script>
</body>
</html>