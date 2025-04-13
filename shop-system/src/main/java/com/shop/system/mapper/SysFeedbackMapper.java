package com.shop.system.mapper;

import java.util.List;
import com.shop.system.domain.SysFeedback;

/**
 * 反馈 数据层
 * 
 * @author shop
 */
public interface SysFeedbackMapper
{
    /**
     * 查询反馈信息
     * 
     * @param feedbackId 反馈ID
     * @return 反馈信息
     */
    public SysFeedback selectFeedbackById(Long feedbackId);

    /**
     * 查询反馈列表
     * 
     * @param feedback 反馈信息
     * @return 反馈集合
     */
    public List<SysFeedback> selectFeedbackList(SysFeedback feedback);

    /**
     * 查询用户的反馈列表
     * 
     * @param userId 用户ID
     * @return 反馈集合
     */
    public List<SysFeedback> selectFeedbackListByUserId(Long userId);

    /**
     * 查询未读反馈数量
     * 
     * @return 未读反馈数量
     */
    public int selectUnreadFeedbackCount();

    /**
     * 查询用户未读回复数量
     * 
     * @param userId 用户ID
     * @return 未读回复数量
     */
    public int selectUserUnreadReplyCount(Long userId);

    /**
     * 新增反馈
     * 
     * @param feedback 反馈信息
     * @return 结果
     */
    public int insertFeedback(SysFeedback feedback);

    /**
     * 修改反馈
     * 
     * @param feedback 反馈信息
     * @return 结果
     */
    public int updateFeedback(SysFeedback feedback);

    /**
     * 批量删除反馈
     * 
     * @param feedbackIds 需要删除的反馈ID
     * @return 结果
     */
    public int deleteFeedbackByIds(Long[] feedbackIds);
} 