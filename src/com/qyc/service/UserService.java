package com.qyc.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.qyc.entity.User;

/**
 * user�û�service
 * @author llq
 *
 */
@Service
public interface UserService {
	public User findByUsername(String username);
	public int add(User user);
	public int edit(User user);
	public int editPassword(User user);
	public int delete(String ids);
	public List<User> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
}
