package com.qyc.controller.adminpage;

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

import com.qyc.entity.Subject;
import com.qyc.page.Page;
import com.qyc.service.SubjectService;

/**
 * 学科专业管理后台控制器
 * @author Administrator
 *
 */
@RequestMapping("/admin/subject")
@Controller
public class SubjectController {
	
	@Autowired
	private SubjectService subjectService;
	
	/**
	 * 学科专业列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("subject/list");
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
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", subjectService.findList(queryMap));
		ret.put("total", subjectService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加学科专业
	 * @param subject
	 * @return
	 */
	@RequestMapping(value="add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Subject subject){
		Map<String, String> ret = new HashMap<String, String>();
		if(subject == null){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the correct subject information!");
			return ret;
		}
		if(StringUtils.isEmpty(subject.getName())){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the subject name!");
			return ret;
		}
		if(subjectService.add(subject) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add failed!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Add successfully!");
		return ret;
	}
	
	/**
	 * 编辑学科专业
	 * @param subject
	 * @return
	 */
	@RequestMapping(value="edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Subject subject){
		Map<String, String> ret = new HashMap<String, String>();
		if(subject == null){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the correct subject information!");
			return ret;
		}
		if(StringUtils.isEmpty(subject.getName())){
			ret.put("type", "error");
			ret.put("msg", "Please fill in the subject name!");
			return ret;
		}
		if(subjectService.edit(subject) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit failed!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edited successfully!");
		return ret;
	}
	
	/**
	 * 删除学科专业
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
			if(subjectService.delete(id) <= 0){
				ret.put("type", "error");
				ret.put("msg", "Failed to delete!");
				return ret;
			}
		} catch (Exception e) {
			// TODO: handle exception
			ret.put("type", "error");
			ret.put("msg", "Student information exists in this subject and cannot be deleted!");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
}
