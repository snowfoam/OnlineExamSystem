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

import com.qyc.entity.Exam;
import com.qyc.entity.Question;
import com.qyc.page.Page;
import com.qyc.service.ExamService;
import com.qyc.service.QuestionService;
import com.qyc.service.SubjectService;

/**
 * 考试管理后台控制器
 * @author Administrator
 *
 */
@RequestMapping("/admin/exam")
@Controller
public class ExamController {
	
	@Autowired
	private ExamService examService;
	@Autowired
	private QuestionService questionService;
	@Autowired
	private SubjectService subjectService;
	
	/**
	 * 考试列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 99999);
		model.addObject("subjectList", subjectService.findList(queryMap));
		model.addObject("singleScore", Question.QUESTION_TYPE_SINGLE_SCORE);
		model.addObject("muiltScore", Question.QUESTION_TYPE_MUILT_SCORE);
		model.addObject("chargeScore", Question.QUESTION_TYPE_CHARGE_SCORE);
		model.setViewName("exam/list");
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
			@RequestParam(name="startTime",required=false) String startTime,
			@RequestParam(name="endTime",required=false) String endTime,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		if(subjectId != null){
			queryMap.put("subjectId", subjectId);
		}
		if(!StringUtils.isEmpty(startTime)){
			queryMap.put("startTime", startTime);
		}
		if(!StringUtils.isEmpty(endTime)){
			queryMap.put("endTime", endTime);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", examService.findList(queryMap));
		ret.put("total", examService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加考试
	 * @param exam
	 * @return
	 */
	@RequestMapping(value="add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Exam exam){
		Map<String, String> ret = new HashMap<String, String>();
		if(exam.getSingleQuestionNum() == 0 && exam.getMuiltQuestionNum() == 0 && exam.getChargeQuestionNum() == 0){
			ret.put("type", "error");
			ret.put("msg", "Single choice, multiple choice, and judgment questions!");
			return ret;
		}
		exam.setCreateTime(new Date());
		//此时去查询所填写的题型数量是否满足
		//获取单选题总数
		Map<String, Long> queryMap = new HashMap<String, Long>();
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_SINGLE));
		queryMap.put("subjectId", exam.getSubjectId());
		int singleQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getSingleQuestionNum() > singleQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of single-choice questions exceeds the total number of single-choice questions, please modify!");
			return ret;
		}
		//获取多选题总数
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_MUILT));
		int muiltQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getMuiltQuestionNum() > muiltQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of multiple-choice questions exceeds the total number of multiple-choice questions, please modify!");
			return ret;
		}
		//获取判断题总数
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_CHARGE));
		int chargeQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getChargeQuestionNum() > chargeQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of judgment questions exceeds the total number of judgment questions, please modify!");
			return ret;
		}
		exam.setQuestionNum(exam.getSingleQuestionNum() + exam.getMuiltQuestionNum() + exam.getChargeQuestionNum());
		exam.setTotalScore(exam.getSingleQuestionNum() * Question.QUESTION_TYPE_SINGLE_SCORE + exam.getMuiltQuestionNum() * Question.QUESTION_TYPE_MUILT_SCORE + exam.getChargeQuestionNum() * Question.QUESTION_TYPE_CHARGE_SCORE);
		if(examService.add(exam) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Add successfully!");
		return ret;
	}
	
	/**
	 * 编辑考试
	 * @param exam
	 * @return
	 */
	@RequestMapping(value="edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Exam exam){
		Map<String, String> ret = new HashMap<String, String>();
		if(exam.getSingleQuestionNum() == 0 && exam.getMuiltQuestionNum() == 0 && exam.getChargeQuestionNum() == 0){
			ret.put("type", "error");
			ret.put("msg", "Single choice, multiple choice, and judgment questions!");
			return ret;
		}
		//此时去查询所填写的题型数量是否满足
		//获取单选题总数
		Map<String, Long> queryMap = new HashMap<String, Long>();
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_SINGLE));
		queryMap.put("subjectId", exam.getSubjectId());
		int singleQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getSingleQuestionNum() > singleQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of single-choice questions exceeds the total number of single-choice questions, please modify!");
			return ret;
		}
		//获取多选题总数
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_MUILT));
		int muiltQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getMuiltQuestionNum() > muiltQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of multiple-choice questions exceeds the total number of multiple-choice questions, please modify!");
			return ret;
		}
		//获取判断题总数
		queryMap.put("questionType", Long.valueOf(Question.QUESTION_TYPE_CHARGE));
		int chargeQuestionTotalNum = questionService.getQuestionNumByType(queryMap);
		if(exam.getChargeQuestionNum() > chargeQuestionTotalNum){
			ret.put("type", "error");
			ret.put("msg", "The number of judgment questions exceeds the total number of judgment questions, please modify!");
			return ret;
		}
		exam.setQuestionNum(exam.getSingleQuestionNum() + exam.getMuiltQuestionNum() + exam.getChargeQuestionNum());
		exam.setTotalScore(exam.getSingleQuestionNum() * Question.QUESTION_TYPE_SINGLE_SCORE + exam.getMuiltQuestionNum() * Question.QUESTION_TYPE_MUILT_SCORE + exam.getChargeQuestionNum() * Question.QUESTION_TYPE_CHARGE_SCORE);
		if(examService.edit(exam) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edit successfully!");
		return ret;
	}
	
	/**
	 * 删除考试
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
			if(examService.delete(id) <= 0){
				ret.put("type", "error");
				ret.put("msg", "Delete fail!");
				return ret;
			}
		} catch (Exception e) {
			// TODO: handle exception
			ret.put("type", "error");
			ret.put("msg", "Examination papers or test records exist under this test and cannot be deleted!");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
	
	
	
}
