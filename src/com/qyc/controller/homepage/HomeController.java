package com.qyc.controller.homepage;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.Student;
import com.qyc.service.StudentService;
import com.qyc.service.SubjectService;

/**
 * 前台主页控制器
 * @author Administrator
 *
 */
@RequestMapping("/home")
@Controller
public class HomeController {
	
	@Autowired
	private SubjectService subjectService;
	
	@Autowired
	private StudentService studentService;
	
	/**
	 * 前台首页
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/index",method = RequestMethod.GET)
	public ModelAndView index(ModelAndView model){
		return model;
	}
	
	/**
	 * 前台用户登录
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/login",method = RequestMethod.GET)
	public ModelAndView login(ModelAndView model){
		model.addObject("title", "User Login");
		model.setViewName("/home/login");
		return model;
	}
	
	/**
	 * 前台用户注册
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/register",method = RequestMethod.GET)
	public ModelAndView register(ModelAndView model){
		model.addObject("title", "User Registration");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 99999);
		model.addObject("subjectList", subjectService.findList(queryMap));
		model.setViewName("/home/register");
		return model;
	}
	
	/**
	 * 用户注册提交
	 * @param student
	 * @return
	 */
	@RequestMapping(value="/register",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> register(Student student){
		Map<String, String> ret = new HashMap<String, String>();
		if(student != null) {
			Student existStudent = studentService.findByName(student.getName());
			if(existStudent != null){
				ret.put("type", "error");
				ret.put("msg", "The username already exists!");
				return ret;
			}
			student.setCreateTime(new Date());
			try {
				//数据库插入
				int i = studentService.add(student);
				if(i <= 0){
					ret.put("type", "error");
					ret.put("msg", "registration failed！");
					return ret;
				}
			} catch (Exception e) {
				// TODO: handle exception
				ret.put("type", "error");
				ret.put("msg", "Database connection error！");
				return ret;
			}
			ret.put("type", "success");
			ret.put("msg", "Registration success！");
		}
		return ret;
	}
	/**
	 * 用户登录提交
	 * @param student
	 * @return
	 */
	@RequestMapping(value="/login",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> login(Student student,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		Student existStudent = studentService.findByName(student.getName());
		if(existStudent == null){
			ret.put("type", "error");
			ret.put("msg", "The username does not exist！");
			return ret;
		}else {
			if(!student.getPassword().equals(existStudent.getPassword())){
				ret.put("type", "error");
				ret.put("msg", "wrong password！");
				return ret;
			}
			request.getSession().setAttribute("student", existStudent);
			ret.put("type", "success");
			ret.put("msg", "login successful！");
		}
		return ret;
	}
}
