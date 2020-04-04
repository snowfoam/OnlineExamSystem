package com.qyc.controller.adminpage;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.ExamPaper;
import com.qyc.page.Page;
import com.qyc.service.ExamPaperService;
import com.qyc.service.ExamService;
import com.qyc.service.StudentService;

/**
 * 试卷管理后台控制器
 * @author Administrator
 *
 */
@RequestMapping("/admin/examPaper")
@Controller
public class ExamPaperController {
	
	@Autowired
	private ExamPaperService examPaperService;
	@Autowired
	private StudentService studentService;
	@Autowired
	private ExamService examService;
	
	/**
	 * 试卷列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 99999);
		model.addObject("examList", examService.findList(queryMap));
		model.addObject("studentList", studentService.findList(queryMap));
		model.setViewName("examPaper/list");
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
			@RequestParam(name="examId",required=false) Long examId,
			@RequestParam(name="studentId",required=false) Long studentId,
			@RequestParam(name="status",required=false) Integer status,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		if(examId != null){
			queryMap.put("examId", examId);
		}
		if(studentId != null){
			queryMap.put("studentId", studentId);
		}
		if(status != null){
			queryMap.put("status", status);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", examPaperService.findList(queryMap));
		ret.put("total", examPaperService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加试卷
	 * @param examPaper
	 * @return
	 */
	@RequestMapping(value="add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(ExamPaper examPaper){
		Map<String, String> ret = new HashMap<String, String>();
		if(examPaperService.add(examPaper) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Add successfully!");
		return ret;
	}
	
	/**
	 * 编辑试卷
	 * @param examPaper
	 * @return
	 */
	@RequestMapping(value="edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(ExamPaper examPaper){
		Map<String, String> ret = new HashMap<String, String>();
		if(examPaperService.edit(examPaper) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edit successfully!");
		return ret;
	}
	
	/**
	 * 删除试卷
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
			if(examPaperService.delete(id) <= 0){
				ret.put("type", "error");
				ret.put("msg", "Delete fail!");
				return ret;
			}
		} catch (Exception e) {
			// TODO: handle exception
			ret.put("type", "error");
			ret.put("msg", "Answer information exists under this test paper and cannot be deleted!");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
	
}
