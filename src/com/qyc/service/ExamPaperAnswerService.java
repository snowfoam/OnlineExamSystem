package com.qyc.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.qyc.entity.ExamPaperAnswer;

/**
 * �Ծ�����service��
 * @author Administrator
 *
 */
@Service
public interface ExamPaperAnswerService {
	public int add(ExamPaperAnswer examPaperAnswer);
	public int edit(ExamPaperAnswer examPaperAnswer);
	public List<ExamPaperAnswer> findList(Map<String, Object> queryMap);
	public int delete(Long id);
	public Integer getTotal(Map<String, Object> queryMap);
	public List<ExamPaperAnswer> findListByUser(Map<String, Object> queryMap);
	public int submitAnswer(ExamPaperAnswer examPaperAnswer);
}
