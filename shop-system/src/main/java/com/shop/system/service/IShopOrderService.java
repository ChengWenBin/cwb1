package com.shop.system.service;

import java.util.List;
import com.shop.system.domain.ShopOrder;

/**
 * 订单Service接口
 * 
 * @author ruoyi
 * @date 2025-01-21
 */
public interface IShopOrderService 
{
    /**
     * 查询订单
     * 
     * @param id 订单主键
     * @return 订单
     */
    public ShopOrder selectShopOrderById(Long id);

    /**
     * 查询订单列表
     * 
     * @param shopOrder 订单
     * @return 订单集合
     */
    public List<ShopOrder> selectShopOrderList(ShopOrder shopOrder);

    /**
     * 新增订单
     * 
     * @param shopOrder 订单
     * @return 结果
     */
    public int insertShopOrder(ShopOrder shopOrder);

    /**
     * 修改订单
     * 
     * @param shopOrder 订单
     * @return 结果
     */
    public int updateShopOrder(ShopOrder shopOrder);

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的订单主键集合
     * @return 结果
     */
    public int deleteShopOrderByIds(Long[] ids);

    /**
     * 删除订单信息
     * 
     * @param id 订单主键
     * @return 结果
     */
    public int deleteShopOrderById(Long id);
}
