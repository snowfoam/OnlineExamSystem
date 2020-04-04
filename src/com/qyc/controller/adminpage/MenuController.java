package com.qyc.controller.adminpage;

import java.io.File;
import java.util.ArrayList;
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

import com.qyc.entity.Menu;
import com.qyc.page.Page;
import com.qyc.service.MenuService;

/**
 * 菜单管理控制器
 * @author llq
 *
 */
@RequestMapping("/admin/menu")
@Controller
public class MenuController {
	
	@Autowired
	private MenuService menuService;
	
	
	/**
	 * 菜单管理列表页
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.GET)
	public ModelAndView list(ModelAndView model){
		model.addObject("topList", menuService.findTopList());
		model.setViewName("menu/list");
		return model;
	}
	
	/**
	 * 获取菜单列表
	 * @param page
	 * @param name
	 * @return
	 */
	@RequestMapping(value="/list",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMenuList(Page page,
			@RequestParam(name="name",required=false,defaultValue="") String name
			){
		Map<String, Object> ret = new HashMap<String, Object>();
		Map<String, Object> queryMap = new HashMap<String, Object>();
		queryMap.put("offset", page.getOffset());
		queryMap.put("pageSize", page.getRows());
		queryMap.put("name", name);
		List<Menu> findList = menuService.findList(queryMap);
		ret.put("rows", findList);
		ret.put("total", menuService.getTotal(queryMap));
		return ret;
	}
	
	/**
	 * 获取指定目录下的系统icon集合
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/get_icons",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getIconList(HttpServletRequest request){
		Map<String, Object> ret = new HashMap<String, Object>();
		String realPath = request.getServletContext().getRealPath("/");
		File file = new File(realPath + "\\resources\\admin\\easyui\\css\\icons");
		List<String> icons = new ArrayList<String>();
		if(!file.exists()){
			ret.put("type", "error");
			ret.put("msg", "File directory does not exist！");
			return ret;
		}
		File[] listFiles = file.listFiles();
		for(File f:listFiles){
			if(f!= null && f.getName().contains("png")){
				icons.add("icon-" + f.getName().substring(0, f.getName().indexOf(".")).replace("_", "-"));
			}
		}
		ret.put("type", "success");
		ret.put("content", icons);
		return ret;
	}
	
	/**
	 * 菜单添加
	 * @param menu
	 * @return
	 */
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> add(Menu menu){
		Map<String, String> ret = new HashMap<String, String>();
		if(menu.getParentId() == null){
			menu.setParentId(0l);
		}
		if(menuService.add(menu) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Add fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Add successfully!");
		return ret;
	}
	
	/**
	 * 菜单修改
	 * @param menu
	 * @return
	 */
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> edit(Menu menu){
		Map<String, String> ret = new HashMap<String, String>();
		if(menu.getParentId() == null){
			menu.setParentId(0l);
		}
		if(menuService.edit(menu) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Edit fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Edit successfully!");
		return ret;
	}
	
	/**
	 * 删除菜单信息
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/delete",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, String> delete(
			@RequestParam(name="id",required=true) Long id
			){
		Map<String, String> ret = new HashMap<String, String>();
		if(id == null){
			ret.put("type", "error");
			ret.put("msg", "Please select the menu information to delete!");
			return ret;
		}
		List<Menu> findChildernList = menuService.findChildernList(id);
		if(findChildernList != null && findChildernList.size() > 0){
			//表示该分类下存在子分类，不能删除
			ret.put("type", "error");
			ret.put("msg", "There are sub-categories under this category and cannot be deleted!");
			return ret;
		}
		if(menuService.delete(id) <= 0){
			ret.put("type", "error");
			ret.put("msg", "Delete fail!");
			return ret;
		}
		ret.put("type", "success");
		ret.put("msg", "Successfully deleted!");
		return ret;
	}
}
