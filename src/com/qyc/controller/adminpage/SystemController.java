package com.qyc.controller.adminpage;

import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.Authority;
import com.qyc.entity.Menu;
import com.qyc.entity.Role;
import com.qyc.entity.User;
import com.qyc.service.AuthorityService;
import com.qyc.service.LogService;
import com.qyc.service.MenuService;
import com.qyc.service.RoleService;
import com.qyc.service.UserService;
import com.qyc.util.CpachaUtil;
import com.qyc.util.MenuUtil;

/**
 * ϵͳ�����������
 * @author llq
 *
 */
@Controller
@RequestMapping("/system")
public class SystemController {
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	@Autowired
	private AuthorityService authorityService;
	
	@Autowired
	private MenuService menuService;
	
	@Autowired
	private LogService logService;
	
	/**
	 * ϵͳ��¼�����ҳ
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public ModelAndView index(ModelAndView model,HttpServletRequest request){
		List<Menu> userMenus = (List<Menu>) request.getSession().getAttribute("userMenus");
		model.addObject("topMenuList", MenuUtil.getAllTopMenu(userMenus));
		model.addObject("secondMenuList", MenuUtil.getAllSecondMenu(userMenus));
		model.setViewName("system/index");
		return model;//WEB-INF/views/+system/index+.jsp = WEB-INF/views/system/index.jsp
	}
	
	/**
	 * ϵͳ��¼��Ļ�ӭҳ
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/welcome",method=RequestMethod.GET)
	public ModelAndView welcome(ModelAndView model){
		model.setViewName("system/welcome");
		return model;
	}
	/**
	 * ��½ҳ��
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public ModelAndView login(ModelAndView model){
		model.setViewName("system/login");
		return model;
	}
	
	/**
	 * ��¼���ύ���������
	 * @param user
	 * @param cpacha
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> loginAct(User user,String cpacha,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		if(user == null){
			ret.put("type", "error");
			ret.put("msg", "Please fill in user information��");
			return ret;
		}
		if(StringUtils.isEmpty(cpacha)){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the verification code��");
			return ret;
		}
		if(StringUtils.isEmpty(user.getUsername())){
			ret.put("type", "error");
			ret.put("msg", "Please enter your username��");
			return ret;
		}
		if(StringUtils.isEmpty(user.getPassword())){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the password��");
			return ret;
		}
		Object loginCpacha = request.getSession().getAttribute("loginCpacha");
		if(loginCpacha == null){
			ret.put("type", "error");
			ret.put("msg", "Session timed out, please refresh the page��");
			return ret;
		}
		if(!cpacha.toUpperCase().equals(loginCpacha.toString().toUpperCase())){
			ret.put("type", "error");
			ret.put("msg", "Verification code error��");
			logService.add("Username"+user.getUsername()+"entered wrong verification code when logging in!");
			return ret;
		}
		User findByUsername = userService.findByUsername(user.getUsername());
		if(findByUsername == null){
			ret.put("type", "error");
			ret.put("msg", "The username does not exist��");
			return ret;
		}
		if(!user.getPassword().equals(findByUsername.getPassword())){
			ret.put("type", "error");
			ret.put("msg", "wrong password��");
			logService.add("Username"+user.getUsername()+" entered wrong password when logging in!");
			return ret;
		}
		//˵���û������뼰��֤�붼��ȷ
		//��ʱ��Ҫ��ѯ�û��Ľ�ɫȨ��
		Role role = roleService.find(findByUsername.getRoleId());
		List<Authority> authorityList = authorityService.findListByRoleId(role.getId());//���ݽ�ɫ��ȡȨ���б�
		String menuIds = "";
		for(Authority authority: authorityList){
			menuIds += authority.getMenuId() + ",";
		}
		if(!StringUtils.isEmpty(menuIds)){
			menuIds = menuIds.substring(0,menuIds.length()-1);
		}
		List<Menu> userMenus = menuService.findListByIds(menuIds);
		//�ѽ�ɫ��Ϣ���˵���Ϣ�ŵ�session��
		request.getSession().setAttribute("admin", findByUsername);
		request.getSession().setAttribute("role", role);
		request.getSession().setAttribute("userMenus", userMenus);
		ret.put("type", "success");
		ret.put("msg", "login successful��");
		logService.add("username {"+user.getUsername()+"}��role {"+role.getName()+"}Of users logged in successfully!");
		return ret;
	}
	
	/**
	 * ��̨�˳�ע������
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/logout",method=RequestMethod.GET)
	public String logout(HttpServletRequest request){
		HttpSession session = request.getSession();
		session.setAttribute("admin", null);
		session.setAttribute("role", null);
		request.getSession().setAttribute("userMenus", null);
		return "redirect:login";
	}
	
	/**
	 * �޸�����ҳ��
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/edit_password",method=RequestMethod.GET)
	public ModelAndView editPassword(ModelAndView model){
		model.setViewName("system/edit_password");
		return model;
	}
	
	@RequestMapping(value="/edit_password",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> editPasswordAct(String newpassword,String oldpassword,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		if(StringUtils.isEmpty(newpassword)){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the new password��");
			return ret;
		}
		User user = (User)request.getSession().getAttribute("admin");
		if(!user.getPassword().equals(oldpassword)){
			ret.put("type", "error");
			ret.put("msg", "The original password is wrong��");
			return ret;
		}
		user.setPassword(newpassword);
		if(userService.editPassword(user) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Password change failed, please contact administrator��");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Password reset complete��");
		logService.add("Username {"+user.getUsername()+"}��Of users successfully changed their password!");
		return ret;
	} 
	
	/**
	 * ��ϵͳ���е���֤������ô˷���
	 * @param vcodeLen
	 * @param width
	 * @param height
	 * @param cpachaType:����������֤������ͣ������ַ���
	 * @param request
	 * @param response
	 */
	@RequestMapping(value="/get_cpacha",method=RequestMethod.GET)
	public void generateCpacha(
			@RequestParam(name="vl",required=false,defaultValue="4") Integer vcodeLen,
			@RequestParam(name="w",required=false,defaultValue="100") Integer width,
			@RequestParam(name="h",required=false,defaultValue="30") Integer height,
			@RequestParam(name="type",required=true,defaultValue="loginCpacha") String cpachaType,
			HttpServletRequest request,
			HttpServletResponse response){
		CpachaUtil cpachaUtil = new CpachaUtil(vcodeLen, width, height);
		String generatorVCode = cpachaUtil.generatorVCode();
		request.getSession().setAttribute(cpachaType, generatorVCode);
		BufferedImage generatorRotateVCodeImage = cpachaUtil.generatorRotateVCodeImage(generatorVCode, true);
		try {
			ImageIO.write(generatorRotateVCodeImage, "gif", response.getOutputStream());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
