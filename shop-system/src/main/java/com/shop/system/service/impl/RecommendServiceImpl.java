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
     * 优化后的推荐算法：
     * 1. 获取用户的历史订单
     * 2. 从订单中提取用户购买过的产品，按类别分组并记录每个类别的价格信息
     * 3. 为每个类别单独计算价格范围，查找相同类别且价格在该范围内的产品进行推荐
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
        
        // 按类别收集用户购买过的产品价格信息
        // 使用Map存储每个类别的价格列表
        java.util.Map<String, List<BigDecimal>> categoryPricesMap = new java.util.HashMap<>();
        Set<Long> purchasedProductIds = new HashSet<>();
        
        for (Order order : userOrders) {
            // 获取订单中的商品项
            List<OrderItem> orderItems = orderItemMapper.selectOrderItemByOrderId(order.getOrderId());
            
            for (OrderItem item : orderItems) {
                // 获取产品详情
                Product product = productService.selectProductById(item.getProductId());
                if (product != null) {
                    // 按类别分组存储价格信息
                    String category = product.getCategory();
                    categoryPricesMap.computeIfAbsent(category, k -> new ArrayList<>())
                                     .add(product.getPrice());
                    purchasedProductIds.add(product.getId());
                }
            }
        }
        
        if (categoryPricesMap.isEmpty()) {
            return new ArrayList<>();
        }
        
        // 查找符合条件的推荐产品
        List<Product> recommendedProducts = new ArrayList<>();
        // 收集每个类别的推荐产品
        java.util.Map<String, List<Product>> categoryProductsMap = new java.util.HashMap<>();
        
        // 为每个类别单独计算价格范围并查找推荐产品
        for (java.util.Map.Entry<String, List<BigDecimal>> entry : categoryPricesMap.entrySet()) {
            String category = entry.getKey();
            List<BigDecimal> prices = entry.getValue();
            
            // 计算该类别产品的平均价格
            BigDecimal categoryAvgPrice = BigDecimal.ZERO;
            for (BigDecimal price : prices) {
                categoryAvgPrice = categoryAvgPrice.add(price);
            }
            categoryAvgPrice = categoryAvgPrice.divide(new BigDecimal(prices.size()), 2, BigDecimal.ROUND_HALF_UP);
            
            // 设置该类别的价格范围（平均价格的±30%）
            BigDecimal categoryMinPrice = categoryAvgPrice.multiply(new BigDecimal("0.7"));
            BigDecimal categoryMaxPrice = categoryAvgPrice.multiply(new BigDecimal("1.3"));
            
            // 构建查询条件
            Product queryProduct = new Product();
            queryProduct.setCategory(category);
            queryProduct.setMinPrice(categoryMinPrice);
            queryProduct.setMaxPrice(categoryMaxPrice);
            
            // 查询相同类别且价格在范围内的产品
            List<Product> similarProducts = productService.selectProductListByCategory(queryProduct);
            
            // 过滤掉用户已购买过的产品
            similarProducts = similarProducts.stream()
                    .filter(p -> !purchasedProductIds.contains(p.getId()))
                    .collect(Collectors.toList());
            
            // 确保只添加符合价格区间的产品
            similarProducts = similarProducts.stream()
                    .filter(p -> p.getPrice().compareTo(categoryMinPrice) >= 0 && 
                                p.getPrice().compareTo(categoryMaxPrice) <= 0)
                    .collect(Collectors.toList());
            
            // 将该类别的产品保存到映射中
            if (!similarProducts.isEmpty()) {
                categoryProductsMap.put(category, similarProducts);
            }
        }
        
        // 先确保每个类别至少有一个产品被推荐
        for (String category : categoryProductsMap.keySet()) {
            List<Product> products = categoryProductsMap.get(category);
            if (!products.isEmpty()) {
                recommendedProducts.add(products.get(0));
                products.remove(0);  // 从列表中移除已添加的产品
            }
        }
        
        // 如果总推荐数量小于6且还有产品可以推荐，继续添加产品
        if (recommendedProducts.size() < 6) {
            // 按轮询方式从每个类别添加更多产品
            List<String> categories = new ArrayList<>(categoryProductsMap.keySet());
            int categoryIndex = 0;
            
            while (recommendedProducts.size() < 6 && !categories.isEmpty()) {
                if (categories.isEmpty()) {
                    break;
                }
                
                String currentCategory = categories.get(categoryIndex % categories.size());
                List<Product> remainingProducts = categoryProductsMap.get(currentCategory);
                
                if (remainingProducts != null && !remainingProducts.isEmpty()) {
                    recommendedProducts.add(remainingProducts.remove(0));
                    
                    // 如果该类别没有更多产品，从轮询中移除
                    if (remainingProducts.isEmpty()) {
                        categories.remove(currentCategory);
                        if (categories.isEmpty()) {
                            break;
                        }
                        categoryIndex = categoryIndex % categories.size();
                    } else {
                        categoryIndex++;
                    }
                } else {
                    // 移除没有产品的类别
                    categories.remove(currentCategory);
                    if (categories.isEmpty()) {
                        break;
                    }
                    categoryIndex = categoryIndex % categories.size();
                }
            }
        }
        
        // 限制推荐产品数量，最多返回6个
        if (recommendedProducts.size() > 6) {
            recommendedProducts = recommendedProducts.subList(0, 6);
        }
        
        return recommendedProducts;
    }
}