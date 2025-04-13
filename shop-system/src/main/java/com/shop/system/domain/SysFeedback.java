package com.shop.system.domain;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.shop.common.core.domain.BaseEntity;
import com.shop.common.xss.Xss;

/**
 * 用户反馈表 sys_feedback
 * 
 * @author shop
 */
public class SysFeedback extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 反馈ID */
    private Long feedbackId;

    /** 用户ID */
    private Long userId;

    /** 用户名称 */
    private String userName;

    /** 反馈内容 */
    private String content;

    /** 回复内容 */
    private String reply;

    /** 处理状态（0未处理 1已处理） */
    private String status;
    
    /** 是否已读（0未读 1已读） */
    private String isRead;

    public Long getFeedbackId()
    {
        return feedbackId;
    }

    public void setFeedbackId(Long feedbackId)
    {
        this.feedbackId = feedbackId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    @Xss(message = "反馈内容不能包含脚本字符")
    @NotBlank(message = "反馈内容不能为空")
    @Size(min = 0, max = 500, message = "反馈内容不能超过500个字符")
    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getReply()
    {
        return reply;
    }

    public void setReply(String reply)
    {
        this.reply = reply;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }
    
    public String getIsRead()
    {
        return isRead;
    }

    public void setIsRead(String isRead)
    {
        this.isRead = isRead;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("feedbackId", getFeedbackId())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("content", getContent())
            .append("reply", getReply())
            .append("status", getStatus())
            .append("isRead", getIsRead())
            .append("createTime", getCreateTime())
            .append("createBy", getCreateBy())
            .append("updateTime", getUpdateTime())
            .append("updateBy", getUpdateBy())
            .toString();
    }
} 