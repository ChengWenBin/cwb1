package com.shop.system.service.impl;

import com.shop.common.utils.DateUtils;
import com.shop.system.domain.OrderItem;
import com.shop.system.mapper.OrderItemMapper;
import com.shop.system.service.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 订单明细表Service业务层处理
 *
 * @author yourName
 * @date 2023-12-10
 */
@Service
public class OrderItemServiceImpl implements OrderItemService {
    @Autowired
    private OrderItemMapper orderItemMapper;

    /**
     * 查询订单明细表
     *
     * @param itemId 订单明细表主键
     * @return 订单明细表
     */
    @Override
    public OrderItem selectOrderItemById(Long itemId) {
        return orderItemMapper.selectOrderItemById(itemId);
    }

    /**
     * 查询订单明细表列表
     *
     * @param orderItem 订单明细表
     * @return 订单明细表集合
     */
    @Override
    public List<OrderItem> selectOrderItemList(OrderItem orderItem) {
        return orderItemMapper.selectOrderItemList(orderItem);
    }

    /**
     * 新增订单明细表
     *
     * @param orderItem 订单明细表
     * @return 结果
     */
    @Override
    public int insertOrderItem(OrderItem orderItem) {
        orderItem.setCreateTime(DateUtils.getNowDate());
        return orderItemMapper.insertOrderItem(orderItem);
    }

    /**
     * 修改订单明细表
     *
     * @param orderItem 订单明细表
     * @return 结果
     */
    @Override
    public int updateOrderItem(OrderItem orderItem) {
        orderItem.setUpdateTime(DateUtils.getNowDate());
        return orderItemMapper.updateOrderItem(orderItem);
    }

    /**
     * 删除订单明细表
     *
     * @param itemId 订单明细表主键
     * @return 结果
     */
    @Override
    public int deleteOrderItemById(Long itemId) {
        return orderItemMapper.deleteOrderItemById(itemId);
    }

    /**
     * 批量删除订单明细表
     *
     * @param itemIds 需要删除的数据主键集合
     * @return 结果
     */
    @Override
    public int deleteOrderItemByIds(Long[] itemIds) {
        return orderItemMapper.deleteOrderItemByIds(itemIds);
    }

    /**
     * 根据订单ID查询订单明细列表
     * @param orderId 订单ID
     * @return 订单明细列表
     */
    @Override
    public List<OrderItem> selectOrderItemByOrderId(Long orderId) {
        return orderItemMapper.selectOrderItemByOrderId(orderId);
    }
}