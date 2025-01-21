package com.shop.system.domain;

import java.math.BigDecimal;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.shop.common.annotation.Excel;
import com.shop.common.core.domain.BaseEntity;

/**
 * 订单对象 shop_order
 * 
 * @author ruoyi
 * @date 2025-01-21
 */
public class ShopOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 订单主键 */
    private Long id;

    /** 订单编号 */
    @Excel(name = "订单编号")
    private String orderNumber;

    /** 用户ID */
    @Excel(name = "用户ID")
    private Long userId;

    /** 订单状态（0-待支付，1-已支付，2-已完成，3-已取消） */
    @Excel(name = "订单状态", readConverterExp = "0=-待支付，1-已支付，2-已完成，3-已取消")
    private Integer status;

    /** 订单总金额 */
    @Excel(name = "订单总金额")
    private BigDecimal totalPrice;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }
    public void setOrderNumber(String orderNumber) 
    {
        this.orderNumber = orderNumber;
    }

    public String getOrderNumber() 
    {
        return orderNumber;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }
    public void setTotalPrice(BigDecimal totalPrice) 
    {
        this.totalPrice = totalPrice;
    }

    public BigDecimal getTotalPrice() 
    {
        return totalPrice;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("orderNumber", getOrderNumber())
            .append("userId", getUserId())
            .append("status", getStatus())
            .append("totalPrice", getTotalPrice())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
