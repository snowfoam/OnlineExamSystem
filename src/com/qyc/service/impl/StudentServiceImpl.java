package com.qyc.service.impl;
/**
 * 考生service实现类
 */
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.qyc.dao.StudentDao;
import com.qyc.entity.Student;
import com.qyc.service.StudentService;
@Service
public class StudentServiceImpl implements StudentService {

	@Autowired
	private StudentDao studentDao;

	@Override
	public int add(Student student) {
		// TODO Auto-generated method stub
		return studentDao.add(student);
	}

	@Override
	public int edit(Student student) {
		// TODO Auto-generated method stub
		return studentDao.edit(student);
	}

	@Override
	public List<Student> findList(Map<String, Object> queryMap) {
		// TODO Auto-generated method stub
		return studentDao.findList(queryMap);
	}

	@Override
	public int delete(Long id) {
		// TODO Auto-generated method stub
		return studentDao.delete(id);
	}

	@Override
	public Integer getTotal(Map<String, Object> queryMap) {
		// TODO Auto-generated method stub
		return studentDao.getTotal(queryMap);
	}

	@Override
	public Student findByName(String name) {
		// TODO Auto-generated method stub
		return studentDao.findByName(name);
	}

	@Override
	public Student checkLogin(String username, String password) {
		Student student = studentDao.findByName(username);
		if (student != null && student.getPassword().equals(password)) {
			return student;
		}
		return null;
	}
	
	

}
