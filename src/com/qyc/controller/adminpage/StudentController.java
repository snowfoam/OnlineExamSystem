package com.qyc.controller.adminpage;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.Student;
import com.qyc.page.Page;
import com.qyc.service.StudentService;
import com.qyc.service.SubjectService;

/**
 * 考生管理后台控制器
 * @author Administrator
 *
 */
@RequestMapping("/admin/student")
@Controller
public class StudentController {
	
	@Autowired
	private StudentService studentService;
	@Autowired
	private SubjectService subjectService;
	
	/**
	 * 考生列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 99999);
		model.addObject("subjectList", subjectService.findList(queryMap));
		model.setViewName("student/list");
		return model;
	}
	
	/**
	 * 模糊搜索分页显示列表查询
	 * @param name
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(
			@RequestParam(name="name",defaultValue="") String name,
			@RequestParam(name="subjectId",required=false) Long subjectId,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		if(subjectId != null){
			queryMap.put("subjectId", subjectId);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", studentService.findList(queryMap));
		ret.put("total", studentService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加考生
	 * @param student
	 * @return
	 */
	@RequestMapping(value="add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Student student){
		Map<String, String> ret = new HashMap<String, String>();
//		if(student == null){
//			ret.put("type", "error");
//			ret.put("msg", "Please fill in the correct candidate information!");
//			return ret;
//		}
//		if(StringUtils.isEmpty(student.getName())){
//			ret.put("type", "error");
//			ret.put("msg", "Please fill in the candidate username!");
//			return ret;
//		}
//		if(StringUtils.isEmpty(student.getPassword())){
//			ret.put("type", "error");
//			ret.put("msg", "Please fill in the candidate password!");
//			return ret;
//		}
//		if(student.getSubjectId() == null){
//			ret.put("type", "error");
//			ret.put("msg", "Please select the subject!");
//			return ret;
//		}
		student.setCreateTime(new Date());
		//添加之前判断登录名是否存在
		if(isExistName(student.getName(), -1l)){
			ret.put("type", "error");
			ret.put("msg", "The login account already exists!");
			return ret;
		}
		if(studentService.add(student) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add failed!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Add successfully!");
		return ret;
	}
	
	/**
	 * 编辑考生
	 * @param student
	 * @return
	 */
	@RequestMapping(value="edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Student student){
		Map<String, String> ret = new HashMap<String, String>();
		if(studentService.edit(student) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit failed!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edited successfully!");
		return ret;
	}
	
	/**
	 * 删除考生
	 * @param id
	 * @return
	 */
	@RequestMapping(value="delete",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(Long id){
		Map<String, String> ret = new HashMap<String, String>();
		if(id == null){
			ret.put("type", "error");
			ret.put("msg", "Please select the data to delete!");
			return ret;
		}
		try {
			if(studentService.delete(id) <= 0){
				ret.put("type", "error");
				ret.put("msg", "Failed to delete!");
				return ret;
			}
		} catch (Exception e) {
			// TODO: handle exception
			ret.put("type", "error");
			ret.put("msg", "Exam information exists for this candidate and cannot be deleted!");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
	
	/**
	 * 判断用户名是否存在
	 * @param name
	 * @param id
	 * @return
	 */
	private boolean isExistName(String name,Long id){
		Student student = studentService.findByName(name);
		if(student == null)return false;
		if(student.getId().longValue() == id.longValue())return false;
		return true;
	}
	
}
