<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@include file="../common/user_header.jsp"%>
  
<body>

	<div class="tm_main">
    	
		
        
        <div class="tm_container">
        	<div class="tm_navtitle">
				<h1>Change PassWord</h1>
                <span>Modify your login password in the form below</span>
            </div>
        </div>
        
        <br/>
        <div class="tm_container">
			<form method="post" id="form_user_form" class="layui-form">
        	<table width="100%" cellpadding="5" border="0" class="layui-table">
            	<tbody>
                    <tr>
                        <th width="120">Username : </th>
                        <td>${student.name}</td>
                    </tr>
					<tr>
                        <th>Old Password : </th>
                        <td>
							<input type="password" name="old_password" id="old_password" class="validate[required] tm_txt" size="50" maxlength="30" />
							<span class="tm_required">*</span>
						</td>
                    </tr>
					<tr>
                        <th>New Password : </th>
                        <td>
							<input type="password" id="new_password" name="new_password" class="validate[required] tm_txt" size="50" maxlength="30" />
							<span class="tm_required">*</span>

							<div id="tm_level" class="pw-strength">
								<div class="pw-bar"></div>
								<div class="pw-bar-on"></div>
								<div class="pw-txt">
									<span>Weak</span>
									<span>Medium</span>
									<span>Strong</span>
								</div>
							</div>

						</td>
                    </tr>
					<tr>
						<th>Confirm Password: </th>
						<td>
							<input type="password" class="validate[required,equals[new_password]] tm_txt" name="new_password2" size="50" maxlength="30" value="" />
							<span class="tm_required">*</span>
						</td>
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
			tm_bindPasswordLevelChecker("new_password");
		});
	
		var tmProfile = {
			doUpdate : function(){
				var formcheck = $("#form_user_form").validationEngine('validate');
				if(formcheck){
					var wcm = window.confirm('Are you sure you want to change your password?');
					if(!wcm){
						return;
					}
					
					$.ajax({
						type: "POST",
						url: "update_password",
						dataType:'json',
						data:{password:$("#new_password").val(),oldPassword:$("#old_password").val()},
						success: function(data){
							if(data.type == 'success'){
								window.location.reload();
							}else{
								alert(data.msg);
							}
						},
						error : function(){
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