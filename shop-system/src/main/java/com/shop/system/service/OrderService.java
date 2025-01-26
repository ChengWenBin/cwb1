package com.shop.system.service;

import com.shop.system.domain.Order;
import com.shop.system.domain.OrderItem;
import java.util.List;

/**
 * 订单主表Service接口
 *
 * @author yourName
 * @date 2023-12-10
 */
public interface OrderService {
    /**
     * 查询订单主表
     *
     * @param orderId 订单主表主键
     * @return 订单主表
     */
    public Order selectOrderById(Long orderId);

    /**
     * 查询订单主表列表
     *
     * @param order 订单主表
     * @return 订单主表集合
     */
    public List<Order> selectOrderList(Order order);

    /**
     * 新增订单主表
     *
     * @param order 订单主表
     * @return 结果
     */
    public int insertOrder(Order order);

    /**
     * 修改订单主表
     *
     * @param order 订单主表
     * @return 结果
     */
    public int updateOrder(Order order);

    /**
     * 删除订单主表
     *
     * @param orderId 订单主表主键
     * @return 结果
     */
    public int deleteOrderById(Long orderId);

    /**
     * 批量删除订单主表
     *
     * @param orderIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderByIds(Long[] orderIds);

    /**
     * 根据订单编号查询订单
     * @param orderNo 订单编号
     * @return 订单信息
     */
    Order selectOrderByOrderNo(String orderNo);

    /**
     *  根据用户ID查询订单列表
     * @param userId 用户ID
     * @return 订单列表
     */
    List<Order> selectOrderByUserId(Long userId);

    int createOrder(List<OrderItem> orderItems, String address);
}