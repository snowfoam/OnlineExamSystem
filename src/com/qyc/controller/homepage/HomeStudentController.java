package com.qyc.controller.homepage;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.Exam;
import com.qyc.entity.ExamPaper;
import com.qyc.entity.ExamPaperAnswer;
import com.qyc.entity.Question;
import com.qyc.entity.Student;
import com.qyc.service.ExamPaperAnswerService;
import com.qyc.service.ExamPaperService;
import com.qyc.service.ExamService;
import com.qyc.service.StudentService;
import com.qyc.service.SubjectService;
import com.qyc.util.DateFormatUtil;

/**
 * ǰ̨�������Ŀ�����
 * @author Administrator
 *
 */
@RequestMapping("/home/user")
@Controller
public class HomeStudentController {
	
	@Autowired
	private StudentService studentService;
	@Autowired
	private SubjectService subjectService;
	@Autowired
	private ExamService examService;
	@Autowired
	private ExamPaperService examPaperService;
	
	@Autowired
	private ExamPaperAnswerService examPaperAnswerService;
	
	private int pageSize = 10;
	/**
	 * ����������ҳ
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/index",method = RequestMethod.GET)
	public ModelAndView index(ModelAndView model){
		model.addObject("title", "Candidate Center");
		model.setViewName("/home/user/index");
		return model;
	}
	
	/**
	 * �������Ļ�ӭҳ��
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/welcome",method = RequestMethod.GET)
	public ModelAndView welcome(ModelAndView model,HttpServletRequest request){
		model.addObject("title", "Candidate Center");
		Student student = (Student)request.getSession().getAttribute("student");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("subjectId", student.getSubjectId());
		queryMap.put("startTime", DateFormatUtil.getDate("yyyy-MM-dd hh:mm:ss", new Date()));
		queryMap.put("endTime", DateFormatUtil.getDate("yyyy-MM-dd hh:mm:ss", new Date()));
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 10);
		model.addObject("examList", examService.findListByUser(queryMap));
		queryMap.remove("subjectId");
		queryMap.put("studentId", student.getId());
		model.addObject("historyList", examPaperService.findHistory(queryMap));
		model.addObject("subject", subjectService.findById(student.getSubjectId()));
		model.setViewName("/home/user/welcome");
		return model;
	}
	
	/**
	 * ��ȡ��ǰ��¼�û����û���
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/get_current",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> getCurrent(HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		Object attribute = request.getSession().getAttribute("student");
		if(attribute == null){
			ret.put("type", "error");
			ret.put("msg", "Login information is invalid!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Get success!");
		Student student  = (Student) attribute;
		ret.put("username", student.getName());
		ret.put("truename", student.getTrueName());
		return ret;
	}
	
	/**
	 * �û�������Ϣҳ��
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/profile",method = RequestMethod.GET)
	public ModelAndView profile(ModelAndView model,HttpServletRequest request){
		Student student = (Student) request.getSession().getAttribute("student");
		model.addObject("title", "Candidate Information");
		model.addObject("student", student);
		model.addObject("subject", subjectService.findById(student.getSubjectId()));
		model.setViewName("/home/user/profile");
		return model;
	}
	
	/**
	 * �޸��û���Ϣ
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/update_info",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> updateInfo(Student student,HttpServletRequest request){
		Map<String, String> ret = new HashMap<String, String>();
		Student onlineStudent  = (Student)request.getSession().getAttribute("student");
		onlineStudent.setTel(student.getTel());
		onlineStudent.setTrueName(student.getTrueName());
		if(studentService.edit(onlineStudent) <= 0){
			ret.put("type", "error");
			ret.put("msg", "The modification failed, please contact the administrator!");
			return ret;
		}
		//����session�е��û���Ϣ
		request.getSession().setAttribute("student", onlineStudent);
		ret.put("type", "success");
		ret.put("msg", "Get success!");
		return ret;
	}
	
	/**
	 * �˳���¼
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/logout",method = RequestMethod.GET)
	public String logout(HttpServletRequest request){
		request.getSession().setAttribute("student", null);
		return "redirect:login";
	}
	
	/**
	 * �û��޸�����
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/password",method = RequestMethod.GET)
	public ModelAndView password(ModelAndView model,HttpServletRequest request){
		Student student = (Student)request.getSession().getAttribute("student");
		model.addObject("student", student);
		model.setViewName("/home/user/password");
		return model;
	}
	
	/**
	 * �޸������ύ
	 * @param student
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/update_password",method=RequestMethod.POST)
	@ResponseBody
	public Map<String,String> updatePassword(Student student,String oldPassword,HttpServletRequest request){
		Map<String, String> map = new HashMap<String, String>();
		Student onlineStudent  = (Student)request.getSession().getAttribute("student");
		if(!onlineStudent.getPassword().equals(oldPassword)){
			map.put("type", "error");
			map.put("msg", "The old password is wrong!");
			return map;
		}
		onlineStudent.setPassword(student.getPassword());
		if(studentService.edit(onlineStudent) <= 0){
			map.put("type", "error");
			map.put("msg", "The modification failed, please contact the administrator!");
			return map;
		}
		//����session�е��û���Ϣ
		request.getSession().setAttribute("student", onlineStudent);
		map.put("type", "success");
		map.put("msg", "Get success!");
		return map;
	}
	
	/**
	 * ��ȡ��ǰѧ�����ڽ��еĿ�����Ϣ
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/exam_list",method = RequestMethod.GET)
	public ModelAndView exameList(ModelAndView model,
			@RequestParam(name="name",defaultValue="") String name,
			@RequestParam(name="page",defaultValue="1") Integer page,
			HttpServletRequest request){
		Student student = (Student)request.getSession().getAttribute("student");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("subjectId", student.getSubjectId());
		queryMap.put("name", name);
		queryMap.put("offset", getOffset(page, pageSize));
		queryMap.put("pageSize", pageSize);
		model.addObject("examList", examService.findListByUser(queryMap));
		model.addObject("name", name);
		model.addObject("subject", subjectService.findById(student.getSubjectId()));
		model.setViewName("/home/user/exam_list");
		if(page < 1)page = 1;
		model.addObject("page", page);
		model.addObject("nowTime", System.currentTimeMillis());
		return model;
	}
	/**
	 * ��ȡ��ǰѧ�������Ŀ�����Ϣ
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/history_list",method = RequestMethod.GET)
	public ModelAndView historyList(ModelAndView model,
			@RequestParam(name="name",defaultValue="") String name,
			@RequestParam(name="page",defaultValue="1") Integer page,
			HttpServletRequest request){
		Student student = (Student)request.getSession().getAttribute("student");
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("name", name);
		queryMap.put("studentId", student.getId());
		queryMap.put("offset", getOffset(page, pageSize));
		queryMap.put("pageSize", pageSize);
		model.addObject("historyList", examPaperService.findHistory(queryMap));
		model.addObject("name", name);
		model.addObject("subject", subjectService.findById(student.getSubjectId()));
		model.setViewName("/home/user/history_list");
		if(page < 1)page = 1;
		model.addObject("page", page);
		return model;
	}
	
	/**
	 * 
	 * @param model
	 * @param examPaperId
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/review_exam",method = RequestMethod.GET)
	public ModelAndView index(ModelAndView model,Long examId,Long examPaperId,HttpServletRequest request){
		Student student = (Student)request.getSession().getAttribute("student");
		Exam exam = examService.findById(examId);
		if(exam == null){
			model.setViewName("/home/exam/error");
			model.addObject("msg", "The current exam does not exist!");
			return model;
		}
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("examId", examId);
		queryMap.put("studentId", student.getId());
		//���ݿ�����Ϣ��ѧ����Ϣ��ȡ�Ծ�
		ExamPaper examPaper = examPaperService.find(queryMap);
		if(examPaper == null){
			model.setViewName("/home/exam/error");
			model.addObject("msg", "No papers for the current exam");
			return model;
		}
		if(examPaper.getStatus() == 0){
			model.setViewName("/home/exam/error");
			model.addObject("msg", "����û�п������ſ��ԣ�");
			return model;
		}
		queryMap.put("examPaperId", examPaper.getId());
		List<ExamPaperAnswer> findListByUser = examPaperAnswerService.findListByUser(queryMap);
		model.addObject("title", exam.getName()+"-Review papers");
		model.addObject("singleQuestionList", getExamPaperAnswerList(findListByUser, Question.QUESTION_TYPE_SINGLE));
		model.addObject("muiltQuestionList", getExamPaperAnswerList(findListByUser, Question.QUESTION_TYPE_MUILT));
		model.addObject("chargeQuestionList", getExamPaperAnswerList(findListByUser, Question.QUESTION_TYPE_CHARGE));
		model.addObject("exam", exam);
		model.addObject("examPaper", examPaper);
		model.addObject("singleScore", Question.QUESTION_TYPE_SINGLE_SCORE);
		model.addObject("muiltScore", Question.QUESTION_TYPE_MUILT_SCORE);
		model.addObject("chargeScore", Question.QUESTION_TYPE_CHARGE_SCORE);
		model.addObject("singleQuestion", Question.QUESTION_TYPE_SINGLE);
		model.addObject("muiltQuestion", Question.QUESTION_TYPE_MUILT);
		model.addObject("chargeQuestion", Question.QUESTION_TYPE_CHARGE);
		model.setViewName("/home/user/review_exam");
		return model;
	}
	
	/**
	 * ����ָ�����͵�����
	 * @param examPaperAnswers
	 * @param questionType
	 * @return
	 */
	private List<ExamPaperAnswer> getExamPaperAnswerList(List<ExamPaperAnswer> examPaperAnswers,int questionType){
		List<ExamPaperAnswer> newExamPaperAnswers = new ArrayList<ExamPaperAnswer>();
		for(ExamPaperAnswer examPaperAnswer:examPaperAnswers){
			if(examPaperAnswer.getQuestion().getQuestionType() == questionType){
				newExamPaperAnswers.add(examPaperAnswer);
			}
		}
		return newExamPaperAnswers;
	}
	
	/**
	 * �������ݿ��ѯ�α�λ��
	 * @param page
	 * @param pageSize
	 * @return
	 */
	private int getOffset(int page,int pageSize){
		if(page < 1)page = 1;
		return (page - 1) * pageSize;
	}
}
