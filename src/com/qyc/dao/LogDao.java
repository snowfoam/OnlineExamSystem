package com.qyc.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.qyc.entity.Authority;
import com.qyc.entity.Log;

/**
 * 系统日志类dao
 * @author llq
 *
 */
@Repository
public interface LogDao {
	public int add(Log log);
	public List<Log> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int delete(String ids);
}
