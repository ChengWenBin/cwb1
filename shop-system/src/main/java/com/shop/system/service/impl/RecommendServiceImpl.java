package com.shop.system.service.impl;

import com.shop.common.utils.SecurityUtils;
import com.shop.system.domain.Order;
import com.shop.system.domain.OrderItem;
import com.shop.system.domain.Product;
import com.shop.system.mapper.OrderItemMapper;
import com.shop.system.service.IProductService;
import com.shop.system.service.IRecommendService;
import com.shop.system.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * 产品推荐服务实现类
 */
@Service
public class RecommendServiceImpl implements IRecommendService {

    @Autowired
    private OrderService orderService;
    
    @Autowired
    private OrderItemMapper orderItemMapper;
    
    @Autowired
    private IProductService productService;
    
    /**
     * 根据用户订单历史获取推荐产品
     * 推荐算法：
     * 1. 获取用户的历史订单
     * 2. 从订单中提取用户购买过的产品类别和价格范围
     * 3. 查找相同类别且价格相近的产品进行推荐
     * 
     * @return 推荐产品列表
     */
    @Override
    public List<Product> getRecommendedProducts() {
        // 获取当前登录用户ID
        Long userId = SecurityUtils.getUserId();
        
        // 获取用户的历史订单
        List<Order> userOrders = orderService.selectOrderByUserId(userId);
        
        if (userOrders == null || userOrders.isEmpty()) {
            // 如果用户没有订单历史，返回空列表
            return new ArrayList<>();
        }
        
        // 过滤订单状态，只保留待发货、已发货和已完成的订单
        userOrders = userOrders.stream()
                .filter(order -> "待发货".equals(order.getOrderStatus()) ||
                               "已发货".equals(order.getOrderStatus()) ||
                               "已完成".equals(order.getOrderStatus()))
                .collect(Collectors.toList());
        
        if (userOrders.isEmpty()) {
            // 如果过滤后没有符合条件的订单，返回空列表
            return new ArrayList<>();
        }
        
        // 收集用户购买过的产品类别和价格信息
        Set<String> userCategories = new HashSet<>();
        List<BigDecimal> userPrices = new ArrayList<>();
        Set<Long> purchasedProductIds = new HashSet<>();
        
        for (Order order : userOrders) {
            // 获取订单中的商品项
            List<OrderItem> orderItems = orderItemMapper.selectOrderItemByOrderId(order.getOrderId());
            
            for (OrderItem item : orderItems) {
                // 获取产品详情
                Product product = productService.selectProductById(item.getProductId());
                if (product != null) {
                    userCategories.add(product.getCategory());
                    userPrices.add(product.getPrice());
                    purchasedProductIds.add(product.getId());
                }
            }
        }
        
        if (userCategories.isEmpty()) {
            return new ArrayList<>();
        }
        
        // 计算用户购买产品的平均价格
        BigDecimal avgPrice = BigDecimal.ZERO;
        for (BigDecimal price : userPrices) {
            avgPrice = avgPrice.add(price);
        }
        avgPrice = avgPrice.divide(new BigDecimal(userPrices.size()), 2, BigDecimal.ROUND_HALF_UP);
        
        // 设置价格范围（平均价格的±30%）
        BigDecimal minPrice = avgPrice.multiply(new BigDecimal("0.7"));
        BigDecimal maxPrice = avgPrice.multiply(new BigDecimal("1.3"));
        
        // 查找符合条件的推荐产品
        List<Product> recommendedProducts = new ArrayList<>();
        
        for (String category : userCategories) {
            Product queryProduct = new Product();
            queryProduct.setCategory(category);
            queryProduct.setMinPrice(minPrice);
            queryProduct.setMaxPrice(maxPrice);
            
            // 查询相同类别且价格在范围内的产品
            List<Product> similarProducts = productService.selectProductListByCategory(queryProduct);
            
            // 过滤掉用户已购买过的产品
            similarProducts = similarProducts.stream()
                    .filter(p -> !purchasedProductIds.contains(p.getId()))
                    .collect(Collectors.toList());
            
            recommendedProducts.addAll(similarProducts);
        }
        
        // 限制推荐产品数量，最多返回6个
        if (recommendedProducts.size() > 6) {
            recommendedProducts = recommendedProducts.subList(0, 6);
        }
        
        return recommendedProducts;
    }
}