package com.shop.system.mapper;

import com.shop.system.domain.OrderItem;
import java.util.List;

/**
 * 订单明细表Mapper接口
 *
 * @author yourName
 * @date 2023-12-10
 */
public interface OrderItemMapper {
    /**
     * 查询订单明细表
     *
     * @param itemId 订单明细表主键
     * @return 订单明细表
     */
    public OrderItem selectOrderItemById(Long itemId);

    /**
     * 查询订单明细表列表
     *
     * @param orderItem 订单明细表
     * @return 订单明细表集合
     */
    public List<OrderItem> selectOrderItemList(OrderItem orderItem);

    /**
     * 新增订单明细表
     *
     * @param orderItem 订单明细表
     * @return 结果
     */
    public int insertOrderItem(OrderItem orderItem);

    /**
     * 修改订单明细表
     *
     * @param orderItem 订单明细表
     * @return 结果
     */
    public int updateOrderItem(OrderItem orderItem);

    /**
     * 删除订单明细表
     *
     * @param itemId 订单明细表主键
     * @return 结果
     */
    public int deleteOrderItemById(Long itemId);

    /**
     * 批量删除订单明细表
     *
     * @param itemIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteOrderItemByIds(Long[] itemIds);

    /**
     * 根据订单ID查询订单明细列表
     *
     * @param orderId 订单ID
     * @return 订单明细列表
     */
    List<OrderItem> selectOrderItemByOrderId(Long orderId);
}
