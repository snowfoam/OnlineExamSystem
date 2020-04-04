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
 * ǰ̨��ҳ������
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
	 * ǰ̨��ҳ
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/index",method = RequestMethod.GET)
	public ModelAndView index(ModelAndView model){
		return model;
	}
	
	/**
	 * ǰ̨�û���¼
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
	 * ǰ̨�û�ע��
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
	 * �û�ע���ύ
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
				//���ݿ����
				int i = studentService.add(student);
				if(i <= 0){
					ret.put("type", "error");
					ret.put("msg", "registration failed��");
					return ret;
				}
			} catch (Exception e) {
				// TODO: handle exception
				ret.put("type", "error");
				ret.put("msg", "Database connection error��");
				return ret;
			}
			ret.put("type", "success");
			ret.put("msg", "Registration success��");
		}
		return ret;
	}
	/**
	 * �û���¼�ύ
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
			ret.put("msg", "The username does not exist��");
			return ret;
		}else {
			if(!student.getPassword().equals(existStudent.getPassword())){
				ret.put("type", "error");
				ret.put("msg", "wrong password��");
				return ret;
			}
			request.getSession().setAttribute("student", existStudent);
			ret.put("type", "success");
			ret.put("msg", "login successful��");
		}
		return ret;
	}
}
