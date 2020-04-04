package com.qyc.controller.adminpage;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.qyc.entity.Question;
import com.qyc.page.Page;
import com.qyc.service.QuestionService;
import com.qyc.service.SubjectService;

/**
 * 试题管理后台控制器
 * @author Administrator
 *
 */
@RequestMapping("/admin/question")
@Controller
public class QuestionController {
	
	@Autowired
	private QuestionService questionService;
	@Autowired
	private SubjectService subjectService;
	
	/**
	 * 试题列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", 0);
		queryMap.put("pageSize", 99999);
		model.addObject("subjectList", subjectService.findList(queryMap));
		model.setViewName("question/list");
		return model;
	}
	
	/**
	 * 模糊搜索分页显示列表查询
	 * @param title
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> list(
			@RequestParam(name="title",defaultValue="") String title,
			@RequestParam(name="questionType",required=false) Integer questionType,
			@RequestParam(name="subjectId",required=false) Long subjectId,
			Page page
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("title", title);
		if(questionType != null){
			queryMap.put("questionType", questionType);
		}
		if(subjectId != null){
			queryMap.put("subjectId", subjectId);
		}
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", questionService.findList(queryMap));
		ret.put("total", questionService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加试题
	 * @param question
	 * @return
	 */
	@RequestMapping(value="add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Question question){
		Map<String, String> ret = new HashMap<String, String>();
		question.setCreateTime(new Date());
		question.setScoreByType();
		if(questionService.add(question) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add failed, please contact administrator!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Added successfully!");
		return ret;
	}
	
	/**
	 * 编辑试题
	 * @param question
	 * @return
	 */
	@RequestMapping(value="edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Question question){
		Map<String, String> ret = new HashMap<String, String>();
		question.setScoreByType();
		if(questionService.edit(question) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edited fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edited successfully!");
		return ret;
	}
	
	/**
	 * 删除试题
	 * @param id
	 * @return
	 */
	@RequestMapping(value="delete",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(Long id){
		Map<String, String> ret = new HashMap<String, String>();
		try {
			if(questionService.delete(id) <= 0){
				ret.put("type", "error");
				ret.put("msg", "Delete fail!");
				return ret;
			}
		} catch (Exception e) {
			// TODO: handle exception
			ret.put("type", "error");
			ret.put("msg", "Exam information exists under this test question and cannot be deleted!");
			return ret;
		}
		
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
	
	/**
	 * 上传文件批量导入试题
	 * @param excelFile
	 * @return
	 */
	@RequestMapping(value="upload_file",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> uploadFile(MultipartFile excelFile,Long subjectId){
		Map<String, String> ret = new HashMap<String, String>();
		if(excelFile == null){
			ret.put("type", "error");
			ret.put("msg", "Please select a file!");
			return ret;
		}
		if(subjectId == null){
			ret.put("type", "error");
			ret.put("msg", "Please select the subject!");
			return ret;
		}
		if(excelFile.getSize() > 5000000){
			ret.put("type", "error");
			ret.put("msg", "File size should not exceed 5M!");
			return ret;
		}
		String suffix = excelFile.getOriginalFilename().substring(excelFile.getOriginalFilename().lastIndexOf(".")+1, excelFile.getOriginalFilename().length());
		String msg = "Import successful";
		if("xls,xlsx".contains(suffix)) {
			try {
				msg = readExcel(excelFile.getInputStream(),subjectId);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else if("txt".contains(suffix)) {
			try {
				msg = readTxt(excelFile.getInputStream(),subjectId);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}else {
			ret.put("type", "error");
			ret.put("msg", "Please upload the latest xls, xlsx format file!");
			return ret;
		}
		if("".equals(msg))msg = "All imported successfully";
		ret.put("type", "success");
		ret.put("msg", msg);
		return ret;
	}
	
	/**
	 * 读取excel文件，并插入到数据库
	 * @param fileInputStream
	 * @return
	 */
	private String readExcel(InputStream fileInputStream,Long subjectId){
		String msg = "";
		try {
			HSSFWorkbook hssfWorkbook = new HSSFWorkbook(fileInputStream);
			HSSFSheet sheetAt = hssfWorkbook.getSheetAt(0);
			if(sheetAt.getLastRowNum() <= 0){
				msg = "The file is empty";
			}
			for(int rowIndex = 1;rowIndex <= sheetAt.getLastRowNum(); rowIndex++){
				Question question = new Question();
				HSSFRow row = sheetAt.getRow(rowIndex);
				if(row.getCell(0) == null){
					msg += "No" + rowIndex + "line,Question type is empty, skip<br/>";
					continue;
				}
				Double numericCellValue = row.getCell(0).getNumericCellValue();
				question.setQuestionType(numericCellValue.intValue());
				if(row.getCell(1) == null){
					msg += "No" + rowIndex + "line,Question type is empty, skip<br/>";
					continue;
				}
				question.setTitle(row.getCell(1).getStringCellValue());
				if(row.getCell(2) == null){
					msg += "No" + rowIndex + "line,Score is empty, skip<br/>";
					continue;
				}
				numericCellValue = row.getCell(2).getNumericCellValue();
				question.setScore(numericCellValue.intValue());
				if(row.getCell(3) == null){
					msg += "No" + rowIndex + "line，Option A is empty, skip<br/>";
					continue;
				}
				question.setAttrA(row.getCell(3).getStringCellValue());
				if(row.getCell(4) == null){
					msg += "No" + rowIndex + "line，Option B is empty, skip<br/>";
					continue;
				}
				question.setAttrB(row.getCell(4).getStringCellValue());
				question.setAttrC(row.getCell(5) == null ? "" : row.getCell(5).getStringCellValue());
				question.setAttrD(row.getCell(6) == null ? "" : row.getCell(6).getStringCellValue());
				if(row.getCell(7) == null){
					msg += "No" + rowIndex + "line，Correct answer is empty, skip\n";
					continue;
				}
				question.setAnswer(row.getCell(7).getStringCellValue());
				question.setCreateTime(new Date());
				question.setSubjectId(subjectId);
				if(questionService.add(question) <= 0){
					msg += "No" + rowIndex + "line，Insert database failed\n";
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return msg;
	}
	
	/**
	 * 读取txt文件，并插入到数据库
	 * @param fileInputStream
	 * @return
	 */
	private String readTxt(InputStream fileInputStream,Long subjectId){
		InputStreamReader inputStreamReader = new InputStreamReader(fileInputStream);
		String msg = "";
		try {
			BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
			String line = "";
			while (true) {
				String s = bufferedReader.readLine();
				if(s!=null)
					line+=s+"\n";
				else
					break;
			}
			String[] questions = line.split("\n");
			int i=0;
			for(String question : questions) {
				//跳过第一次
				if(i==0) {
					i++;
					continue;
				}
				String[] infos = question.split(",");
				if(infos.length != 8) {
					msg += "This line is error.";
					continue;
				}
				Question questionObject = new Question();
				int typeInt = Integer.parseInt(infos[0].trim());
				questionObject.setQuestionType(typeInt);
				questionObject.setTitle(infos[1].trim());
				int score = Integer.parseInt(infos[2].trim());
				questionObject.setScore(score);
				questionObject.setAttrA(infos[3].trim());
				questionObject.setAttrB(infos[4].trim());
				questionObject.setAttrC(infos[5].trim());
				questionObject.setAttrD(infos[6].trim());
				questionObject.setAnswer(infos[7].trim());
				questionObject.setCreateTime(new Date());
				questionObject.setSubjectId(subjectId);
				i++;
				if(questionService.add(questionObject) <= 0){
					msg += "No" + i + "line，Insert database failed\n";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return msg;
	}
	
	
}
