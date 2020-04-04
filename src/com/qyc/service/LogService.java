package com.qyc.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.qyc.entity.Authority;
import com.qyc.entity.Log;

/**
 * ��־�ӿ�
 * @author llq
 *
 */
@Service
public interface LogService {
	public int add(Log log);
	public int add(String content);
	public List<Log> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int delete(String ids);
}
