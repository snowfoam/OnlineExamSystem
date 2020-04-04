<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../common/user_header.jsp"%>
  
<body>

	<div class="tm_main">
    	
		
        <div class="tm_container">
        	<div class="tm_navtitle">
				<h1>Change Account Info</h1>
                <span>Modify your account information in the form below</span>
            </div>
        </div>
        
        <br/>
        <div class="tm_container">
			<form method="post" id="form_user_load">
        	<table width="100%" cellpadding="5" border="0" class="layui-table">
            	<tbody>
                    <tr>
                        <th width="120">Username : </th>
                        <td>${student.name}</td>
                    </tr>
                    <tr>
                        <th width="120">Subject : </th>
                        <td>${subject.name}</td>
                    </tr>
					<tr>
                        <th>Full Name : </th>
                        <td>
							<input type="text" id="truename" name="truename" class="validate[required] tm_txt" size="50" maxlength="30" value="${student.trueName}" />
							<span class="tm_required">*</span> 
							<span class="tm_tip">Fill in the user's real name</span>
						</td>
                    </tr>
					
					<tr>
                        <th>Phone : </th>
                        <td><input type="text" id="tel" name="tel" class="tm_txt" size="50" maxlength="30" value="${student.tel}" /></td>
                    </tr>
					
                </tbody>
                
                <tfoot>
                	<tr>
                    	<th></th>
                        <td>
                        	<button class="tm_btn tm_btn_primary" type="button" onclick="tmProfile.doUpdate();">Submit</button>
                        </td>
                    </tr>
                </tfoot>
            </table>

			</form>
        </div>
        
        
    </div>
<script type="text/javascript">
		$(document).ready(function() { 
			
		});

		var tmProfile = {
			doUpdate : function(){
				var formcheck = $("#form_user_load").validationEngine('validate');
				if(formcheck){
					var wcm = window.confirm('Confirm the changes?');
					if(!wcm){
						return;
					}
					$.ajax({
						type: "POST",
						url: "update_info",
						dataType:'json',
						data:{trueName:$("#truename").val(),tel:$("#tel").val()},
						success: function(data){
							if(data.type == 'success'){
								window.location.reload();
							}else{
								alert('fail to edit');
							}
						},
						error : function(){
							//top.location.href = "home/login";
							alert('Network Error');
						}
					});

				}else{
					return false;
				}
			}
		};
	</script>
</body>
</html>