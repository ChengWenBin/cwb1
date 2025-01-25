package com.shop.system.service.impl;

import com.shop.common.utils.DateUtils;
import com.shop.common.utils.SecurityUtils;
import com.shop.common.utils.StringUtils;
import com.shop.system.domain.Order;
import com.shop.system.domain.OrderItem;
import com.shop.system.mapper.OrderMapper;
import com.shop.system.mapper.OrderItemMapper;
import com.shop.system.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

/**
 * 订单主表Service业务层处理
 *
 * @author yourName
 * @date 2023-12-10
 */
@Service
public class OrderServiceImpl implements OrderService {
    @Autowired
    private OrderMapper orderMapper;

    @Autowired
    private OrderItemMapper orderItemMapper;

    /**
     * 查询订单主表
     *
     * @param orderId 订单主表主键
     * @return 订单主表
     */
    @Override
    public Order selectOrderById(Long orderId) {
        return orderMapper.selectOrderById(orderId);
    }

    /**
     * 查询订单主表列表
     *
     * @param order 订单主表
     * @return 订单主表集合
     */
    @Override
    public List<Order> selectOrderList(Order order) {
        return orderMapper.selectOrderList(order);
    }

    /**
     * 新增订单主表
     *
     * @param order 订单主表
     * @return 结果
     */
    @Override
    public int insertOrder(Order order) {
        order.setCreateTime(DateUtils.getNowDate());
        return orderMapper.insertOrder(order);
    }

    /**
     * 修改订单主表
     *
     * @param order 订单主表
     * @return 结果
     */
    @Override
    public int updateOrder(Order order) {
        order.setUpdateTime(DateUtils.getNowDate());
        return orderMapper.updateOrder(order);
    }

    /**
     * 删除订单主表
     *
     * @param orderId 订单主表主键
     * @return 结果
     */
    @Override
    public int deleteOrderById(Long orderId) {
        return orderMapper.deleteOrderById(orderId);
    }

    /**
     * 批量删除订单主表
     *
     * @param orderIds 需要删除的数据主键集合
     * @return 结果
     */
    @Override
    public int deleteOrderByIds(Long[] orderIds) {
        return orderMapper.deleteOrderByIds(orderIds);
    }

    /**
     * 根据订单编号查询订单
     * @param orderNo 订单编号
     * @return 订单信息
     */
    @Override
    public Order selectOrderByOrderNo(String orderNo) {
        return orderMapper.selectOrderByOrderNo(orderNo);
    }

    /**
     *  根据用户ID查询订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    @Override
    public List<Order> selectOrderByUserId(Long userId) {
        return orderMapper.selectOrderByUserId(userId);
    }

    @Override
    public int createOrder(List<OrderItem> orderItems) {
        if (orderItems == null || orderItems.isEmpty()) {
            throw new IllegalArgumentException("订单商品列表不能为空");
        }

        Order order = new Order();
        // 生成订单编号
        String orderNo = UUID.randomUUID().toString().replace("-", "").substring(0, 20);
        order.setOrderNo(orderNo);
        order.setUserId(SecurityUtils.getUserId());
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItem orderItem : orderItems) {
            totalAmount = totalAmount.add(orderItem.getTotalPrice());
        }

        order.setTotalAmount(totalAmount);
        order.setOrderStatus("待付款");
        order.setCreateTime(DateUtils.getNowDate());
        int orderInsert = orderMapper.insertOrder(order);

        for(OrderItem orderItem : orderItems){
            orderItem.setOrderId(order.getOrderId());
            orderItemMapper.insertOrderItem(orderItem);
        }

        return  orderInsert;
    }
}