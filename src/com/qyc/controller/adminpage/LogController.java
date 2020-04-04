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

import com.qyc.entity.Log;
import com.qyc.page.Page;
import com.qyc.service.LogService;

/**
 * 日志管理控制器
 * @author llq
 *
 */
@RequestMapping("/admin/log")
@Controller
public class LogController {
	@Autowired
	private LogService logService;
	
	/**
	 * 日志列表页面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.setViewName("log/list");
		return model;
	}
	
	/**
	 * 获取日志列表
	 * @param page
	 * @param content
	 * @param roleId
	 * @param sex
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getList(Page page,
			@RequestParam(name="content",required=false,defaultValue="") String content
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("content", content);
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		ret.put("rows", logService.findList(queryMap));
		ret.put("total", logService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 添加日志
	 * @param user
	 * @return
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Log log){
		Map<String, String> ret = new HashMap<String, String>();
		log.setCreateTime(new Date());
		if(logService.add(log) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Log add failed！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Log add successfully!");
		return ret;
	}
	
	
	
	/**
	 * 批量删除日志
	 * @param ids
	 * @return
	 */
	@RequestMapping(value="/delete",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(String ids){
		Map<String, String> ret = new HashMap<String, String>();
		if(StringUtils.isEmpty(ids)){
			ret.put("type", "error");
			ret.put("msg", "Select data to delete！");
			return ret;
		}
		if(ids.contains(",")){
			ids = ids.substring(0,ids.length()-1);
		}
		if(logService.delete(ids) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Log delete failed！");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Log delete successfully！");
		return ret;
	}
	
	
}
