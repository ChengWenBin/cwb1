package com.shop.system.service;

import com.shop.system.domain.Product;
import java.util.List;

/**
 * 产品推荐服务接口
 */
public interface IRecommendService {
    
    /**
     * 根据用户订单历史获取推荐产品
     * 
     * @return 推荐产品列表
     */
    List<Product> getRecommendedProducts();
}