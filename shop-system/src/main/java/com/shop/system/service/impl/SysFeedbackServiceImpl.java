package com.shop.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.shop.system.domain.SysFeedback;
import com.shop.system.mapper.SysFeedbackMapper;
import com.shop.system.service.ISysFeedbackService;

/**
 * 反馈 服务层实现
 * 
 * @author shop
 */
@Service
public class SysFeedbackServiceImpl implements ISysFeedbackService
{
    @Autowired
    private SysFeedbackMapper feedbackMapper;

    /**
     * 查询反馈信息
     * 
     * @param feedbackId 反馈ID
     * @return 反馈信息
     */
    @Override
    public SysFeedback selectFeedbackById(Long feedbackId)
    {
        return feedbackMapper.selectFeedbackById(feedbackId);
    }

    /**
     * 查询反馈列表
     * 
     * @param feedback 反馈信息
     * @return 反馈集合
     */
    @Override
    public List<SysFeedback> selectFeedbackList(SysFeedback feedback)
    {
        return feedbackMapper.selectFeedbackList(feedback);
    }

    /**
     * 查询用户的反馈列表
     * 
     * @param userId 用户ID
     * @return 反馈集合
     */
    @Override
    public List<SysFeedback> selectFeedbackListByUserId(Long userId)
    {
        return feedbackMapper.selectFeedbackListByUserId(userId);
    }

    /**
     * 查询未读反馈数量
     * 
     * @return 未读反馈数量
     */
    @Override
    public int selectUnreadFeedbackCount()
    {
        return feedbackMapper.selectUnreadFeedbackCount();
    }

    /**
     * 查询用户未读回复数量
     * 
     * @param userId 用户ID
     * @return 未读回复数量
     */
    @Override
    public int selectUserUnreadReplyCount(Long userId)
    {
        return feedbackMapper.selectUserUnreadReplyCount(userId);
    }

    /**
     * 新增反馈
     * 
     * @param feedback 反馈信息
     * @return 结果
     */
    @Override
    public int insertFeedback(SysFeedback feedback)
    {
        // 设置默认值
        feedback.setStatus("0"); // 0未处理
        feedback.setIsRead("0"); // 0未读
        return feedbackMapper.insertFeedback(feedback);
    }

    /**
     * 回复反馈
     * 
     * @param feedback 反馈信息
     * @return 结果
     */
    @Override
    public int replyFeedback(SysFeedback feedback)
    {
        // 设置为已处理状态
        feedback.setStatus("1");
        // 重置为未读状态，以便用户收到通知
        feedback.setIsRead("0");
        return feedbackMapper.updateFeedback(feedback);
    }

    /**
     * 标记反馈为已读
     * 
     * @param feedbackId 反馈ID
     * @return 结果
     */
    @Override
    public int markAsRead(Long feedbackId)
    {
        SysFeedback feedback = new SysFeedback();
        feedback.setFeedbackId(feedbackId);
        feedback.setIsRead("1");
        return feedbackMapper.updateFeedback(feedback);
    }

    /**
     * 批量删除反馈
     * 
     * @param feedbackIds 需要删除的反馈ID
     * @return 结果
     */
    @Override
    public int deleteFeedbackByIds(Long[] feedbackIds)
    {
        return feedbackMapper.deleteFeedbackByIds(feedbackIds);
    }
} 