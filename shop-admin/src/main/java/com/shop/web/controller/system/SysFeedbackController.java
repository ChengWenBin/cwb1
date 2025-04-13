package com.shop.web.controller.system;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.shop.common.annotation.Log;
import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.domain.entity.SysUser;
import com.shop.common.core.page.TableDataInfo;
import com.shop.common.enums.BusinessType;
import com.shop.common.utils.SecurityUtils;
import com.shop.system.domain.SysFeedback;
import com.shop.system.service.ISysFeedbackService;
import com.shop.system.service.ISysUserService;

/**
 * 反馈 信息操作处理
 * 
 * @author shop
 */
@RestController
@RequestMapping("/system/feedback")
public class SysFeedbackController extends BaseController
{
    @Autowired
    private ISysFeedbackService feedbackService;

    @Autowired
    private ISysUserService userService;

    /**
     * 获取反馈列表
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysFeedback feedback)
    {
        startPage();
        List<SysFeedback> list = feedbackService.selectFeedbackList(feedback);
        return getDataTable(list);
    }

    /**
     * 获取当前用户的反馈列表
     */
    @GetMapping("/mylist")
    public TableDataInfo myList()
    {
        startPage();
        List<SysFeedback> list = feedbackService.selectFeedbackListByUserId(SecurityUtils.getUserId());
        return getDataTable(list);
    }

    /**
     * 获取未读反馈数量
     */
    @GetMapping("/unread")
    public AjaxResult unreadCount()
    {
        int count = feedbackService.selectUnreadFeedbackCount();
        return AjaxResult.success(count);
    }

    /**
     * 获取用户未读回复数量
     */
    @GetMapping("/user/unread")
    public AjaxResult userUnreadCount()
    {
        Long userId = SecurityUtils.getUserId();
        int count = feedbackService.selectUserUnreadReplyCount(userId);
        return AjaxResult.success(count);
    }

    /**
     * 获取反馈详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:query')")
    @GetMapping(value = "/{feedbackId}")
    public AjaxResult getInfo(@PathVariable Long feedbackId)
    {
        // 标记为已读
        feedbackService.markAsRead(feedbackId);
        return success(feedbackService.selectFeedbackById(feedbackId));
    }

    /**
     * 用户获取反馈详细信息
     */
    @GetMapping(value = "/detail/{feedbackId}")
    public AjaxResult getDetail(@PathVariable Long feedbackId)
    {
        return success(feedbackService.selectFeedbackById(feedbackId));
    }

    /**
     * 新增反馈
     */
    @Log(title = "反馈管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysFeedback feedback)
    {
        Long userId = SecurityUtils.getUserId();
        SysUser user = userService.selectUserById(userId);
        
        feedback.setUserId(userId);
        feedback.setUserName(user.getUserName());
        feedback.setCreateBy(getUsername());
        
        return toAjax(feedbackService.insertFeedback(feedback));
    }

    /**
     * 回复反馈
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:reply')")
    @Log(title = "反馈管理", businessType = BusinessType.UPDATE)
    @PutMapping(value = "/reply")
    public AjaxResult reply(@RequestBody SysFeedback feedback)
    {
        feedback.setUpdateBy(getUsername());
        return toAjax(feedbackService.replyFeedback(feedback));
    }

    /**
     * 标记为已读
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:edit')")
    @PutMapping(value = "/read/{feedbackId}")
    public AjaxResult markRead(@PathVariable Long feedbackId)
    {
        return toAjax(feedbackService.markAsRead(feedbackId));
    }

    /**
     * 用户标记自己的反馈为已读
     */
    @PutMapping(value = "/user/read/{feedbackId}")
    public AjaxResult userMarkRead(@PathVariable Long feedbackId)
    {
        // 验证是否是当前用户的反馈
        SysFeedback feedback = feedbackService.selectFeedbackById(feedbackId);
        if (feedback != null && feedback.getUserId().equals(SecurityUtils.getUserId()))
        {
            return toAjax(feedbackService.markAsRead(feedbackId));
        }
        return AjaxResult.error("无法标记不属于您的反馈");
    }

    /**
     * 删除反馈
     */
    @PreAuthorize("@ss.hasPermi('system:feedback:remove')")
    @Log(title = "反馈管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{feedbackIds}")
    public AjaxResult remove(@PathVariable Long[] feedbackIds)
    {
        return toAjax(feedbackService.deleteFeedbackByIds(feedbackIds));
    }
} 