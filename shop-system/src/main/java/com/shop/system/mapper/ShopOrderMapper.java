package com.shop.system.mapper;

import java.util.List;
import com.shop.system.domain.ShopOrder;

/**
 * 订单Mapper接口
 * 
 * @author ruoyi
 * @date 2025-01-21
 */
public interface ShopOrderMapper 
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
     * 删除订单
     * 
     * @param id 订单主键
     * @return 结果
     */
    public int deleteShopOrderById(Long id);

    /**
     * 批量删除订单
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteShopOrderByIds(Long[] ids);
}
