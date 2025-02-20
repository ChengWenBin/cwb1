package com.shop.system.service.impl;

import com.shop.common.utils.DateUtils;
import com.shop.common.utils.SecurityUtils;
import com.shop.common.utils.StringUtils;
import com.shop.system.domain.Order;
import com.shop.system.domain.OrderItem;
import com.shop.system.mapper.OrderMapper;
import com.shop.system.mapper.OrderItemMapper;
import com.shop.system.service.IProductService;
import com.shop.system.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
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

    @Autowired
    private IProductService productService;

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
     *
     * @param orderNo 订单编号
     * @return 订单信息
     */
    @Override
    public Order selectOrderByOrderNo(String orderNo) {
        return orderMapper.selectOrderByOrderNo(orderNo);
    }

    /**
     * 根据用户ID查询订单列表
     *
     * @param userId 用户ID
     * @return 订单列表
     */
    @Override
    public List<Order> selectOrderByUserId(Long userId) {
        return orderMapper.selectOrderByUserId(userId);
    }

    @Override
    @Transactional // 添加事务注解, 确保订单状态更新和库存扣减的原子性
    public int createOrder(List<OrderItem> orderItems, String address) {
        if (orderItems == null || orderItems.isEmpty()) {
            throw new IllegalArgumentException("订单商品列表不能为空");
        }
        Order order = new Order();
        // 使用时间戳+用户ID生成订单编号
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        String userId = SecurityUtils.getUserId().toString();
        String orderNo = timestamp + userId;
        order.setOrderNo(orderNo);
        order.setUserId(SecurityUtils.getUserId());
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (OrderItem orderItem : orderItems) {
            totalAmount = totalAmount.add(orderItem.getTotalPrice());
        }
        order.setTotalAmount(totalAmount);
        order.setOrderStatus("待付款");
        order.setCreateTime(DateUtils.getNowDate());
        order.setAddress(address);
        int orderInsert = orderMapper.insertOrder(order);

        for(OrderItem orderItem : orderItems){
            orderItem.setOrderId(order.getOrderId());
            orderItemMapper.insertOrderItem(orderItem);
            // 调用 ProductService 的 reduceStock 方法
            boolean success = productService.reduceStock(orderItem.getProductId(), orderItem.getQuantity()); // 使用 productService 对象调用
            if (!success) {
                // 库存不足，抛出异常,  这里可以自定义业务异常
                throw new RuntimeException("商品 " + orderItem.getProductName() + " 库存不足！");
            }

        }
        return  orderInsert;
    }
}