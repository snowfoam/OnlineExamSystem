package com.qyc.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.qyc.entity.Student;

/**
 * ѧ��dao��
 * @author Administrator
 *
 */
@Repository
public interface StudentDao {
	public int add(Student student);
	public int edit(Student student);
	public List<Student> findList(Map<String, Object> queryMap);
	public int delete(Long id);
	public Integer getTotal(Map<String, Object> queryMap);
	public Student findByName(String name);
}