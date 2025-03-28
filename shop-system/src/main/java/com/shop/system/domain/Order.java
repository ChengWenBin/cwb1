package com.shop.system.domain;

import com.shop.common.core.domain.BaseEntity;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 订单主表 对象 order
 *
 * @author yourName
 * @date 2023-12-10
 */
public class Order extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 订单ID */
    private Long orderId;

    /** 订单编号（唯一） */
    private String orderNo;

    /** 用户ID */
    private Long userId;

    /** 订单总金额 */
    private BigDecimal totalAmount;

    /** 订单状态（待付款/待发货/已发货/已完成/已取消） */
    private String orderStatus;

    /** 支付时间 */
    private Date paymentTime;

    /** 发货时间 */
    private Date deliveryTime;

    /** 完成时间 */
    private Date receiveTime;

    /** 收货地址*/
    private String address;

    /** 最小金额 (用于筛选) */
    private BigDecimal minAmount;

    /** 最大金额 (用于筛选) */
    private BigDecimal maxAmount;

    /** 用户名称 (用于筛选) */
    private String userName;


    //  minAmount 和 maxAmount 的 getter 和 setter
    public BigDecimal getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(BigDecimal minAmount) {
        this.minAmount = minAmount;
    }

    public BigDecimal getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(BigDecimal maxAmount) {
        this.maxAmount = maxAmount;
    }


    // 其余属性的 getter 和 setter ...
    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public Long getOrderId() {
        return orderId;
    }
    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getOrderNo() {
        return orderNo;
    }
    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getUserId() {
        return userId;
    }
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getOrderStatus() {
        return orderStatus;
    }
    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }
    public void setDeliveryTime(Date deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public Date getDeliveryTime() {
        return deliveryTime;
    }
    public void setReceiveTime(Date receiveTime) {
        this.receiveTime = receiveTime;
    }

    public Date getReceiveTime() {
        return receiveTime;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
    /** 订单明细集合*/
    private List<OrderItem> orderItems;

    public List<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(List<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }


    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId=" + orderId +
                ", orderNo='" + orderNo + '\'' +
                ", userId=" + userId +
                ", totalAmount=" + totalAmount +
                ", orderStatus='" + orderStatus + '\'' +
                ", paymentTime=" + paymentTime +
                ", deliveryTime=" + deliveryTime +
                ", receiveTime=" + receiveTime +
                ", address='" + address + '\'' +
                ", minAmount=" + minAmount +
                ", maxAmount=" + maxAmount +
                ", userName='" + userName + '\'' +
                ", createTime=" + getCreateTime() +
                ", updateTime=" + getUpdateTime() +
                ", remark='" + getRemark() + '\'' +
                '}';
    }
}