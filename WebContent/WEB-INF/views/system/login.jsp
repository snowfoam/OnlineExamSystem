<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!-- saved from url=(0051)http://demo1.mycodes.net/denglu/HTML5_yonghudenglu/ -->
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Background Administrator Login</title>
  <meta name="description" content="particles.js is a lightweight JavaScript library for creating particles.">
  <meta name="author" content="Vincent Garreau">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link rel="stylesheet" media="screen" href="../resources/admin/login/css/style.css">
  <link rel="stylesheet" type="text/css" href="../resources/admin/login/css/reset.css">
<body>

<div id="particles-js">
		<div class="login" style="display: block;">
			<div class="login-top">
				Login
			</div>
			<div class="login-center clearfix">
				<div class="login-center-img"><img src="../resources/admin/login/images/name.png"></div>
				<div class="login-center-input">
					<input type="text" name="username" id="username" value="" placeholder="Please enter your username" onfocus="this.placeholder=&#39;&#39;" onblur="this.placeholder=&#39;请输入您的用户名&#39;">
					<div class="login-center-input-text">User Name :</div>
				</div>
			</div>
			<div class="login-center clearfix">
				<div class="login-center-img"><img src="../resources/admin/login/images/password.png"></div>
				<div class="login-center-input">
					<input type="password" name="password" id="password" value="" placeholder="Please enter your password" onfocus="this.placeholder=&#39;&#39;" onblur="this.placeholder=&#39;请输入您的密码&#39;">
					<div class="login-center-input-text">Password :</div>
				</div>
			</div>
			<div class="login-center clearfix">
				<div class="login-center-img"><img src="../resources/admin/login/images/cpacha.png"></div>
				<div class="login-center-input">
					<input style="width:50%;" type="text" name="cpacha" id="cpacha" value="" placeholder="Please enter verification code" onfocus="this.placeholder=&#39;&#39;" onblur="this.placeholder=&#39;enter verification code&#39;">
					<div class="login-center-input-text">Verification Code :</div>
					<img id="cpacha-img" title="Click to switch verification code" style="cursor:pointer;" src="get_cpacha?vl=4&w=150&h=40&type=loginCpacha" width="110px" height="30px" onclick="changeCpacha()">
				</div>
			</div>
			<div class="login-button">
				Log In
			</div>
		</div>
		<div class="sk-rotating-plane"></div>
<canvas class="particles-js-canvas-el" width="1147" height="952" style="width: 100%; height: 100%;"></canvas></div>

<!-- scripts -->
<script src="../resources/admin/login/js/particles.min.js"></script>
<script src="../resources/admin/login/js/app.js"></script>
<script src="../resources/admin/login/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
	function hasClass(elem, cls) {
	  cls = cls || '';
	  if (cls.replace(/\s/g, '').length == 0) return false; //当cls没有参数时，返回false
	  return new RegExp(' ' + cls + ' ').test(' ' + elem.className + ' ');
	}
	 
	function addClass(ele, cls) {
	  if (!hasClass(ele, cls)) {
	    ele.className = ele.className == '' ? cls : ele.className + ' ' + cls;
	  }
	}
	 
	function removeClass(ele, cls) {
	  if (hasClass(ele, cls)) {
	    var newClass = ' ' + ele.className.replace(/[\t\r\n]/g, '') + ' ';
	    while (newClass.indexOf(' ' + cls + ' ') >= 0) {
	      newClass = newClass.replace(' ' + cls + ' ', ' ');
	    }
	    ele.className = newClass.replace(/^\s+|\s+$/g, '');
	  }
	}
	
	function changeCpacha(){
		$("#cpacha-img").attr("src",'get_cpacha?vl=4&w=150&h=40&type=loginCpacha&t=' + new Date().getTime());
	}
		document.querySelector(".login-button").onclick = function(){
				var username = $("#username").val();
				var password = $("#password").val();
				var cpacha = $("#cpacha").val();
				if(username == '' || username == 'undefined'){
					alert("Please enter your username!");
					return;
				}
				if(password == '' || password == 'undefined'){
					alert("Please fill in the password!");
					return;
				}
				if(cpacha == '' || cpacha == 'undefined'){
					alert("Please fill in the verification code!");
					return;
				}
				addClass(document.querySelector(".login"), "active")
				addClass(document.querySelector(".sk-rotating-plane"), "active")
				document.querySelector(".login").style.display = "none"
				$.ajax({
					url:'login',
					data:{username:username,password:password,cpacha:cpacha},
					type:'post',
					dataType:'json',
					success:function(data){
						if(data.type == 'success'){
							window.parent.location = 'index';
						}else{
							removeClass(document.querySelector(".login"), "active");
							removeClass(document.querySelector(".sk-rotating-plane"), "active");
							document.querySelector(".login").style.display = "block";
							alert(data.msg);
							changeCpacha();
						}
					}
				});
				
		}
</script>
</body></html>