package com.shop.system.service.impl;

import com.shop.system.mapper.DashboardMapper;
import com.shop.system.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DashboardServiceImpl implements IDashboardService {

    @Autowired
    private DashboardMapper dashboardMapper;

    @Override
    public List<Map<String, Object>> getSalesTrend() {
        return dashboardMapper.getSalesTrend();
    }
    @Override
    public List<Map<String, Object>> getProductSales() {
        return dashboardMapper.getProductSales();
    }


    @Override
    public List<Map<String, Object>> getOrderTrend() {
        return dashboardMapper.getOrderTrend();
    }

    @Override
    public List<Map<String, Object>> getOrderStatus() {
        return dashboardMapper.getOrderStatus();
    }

    @Override
    public Map<String, Object> getSalesReport() {
        Map<String, Object> report = new HashMap<>();
        Map<String, Object> totalSalesResult = dashboardMapper.getSalesReportTotalSales();
        report.put("totalSales", totalSalesResult.getOrDefault("totalSales", 0));
        report.put("productSales", dashboardMapper.getSalesReportProductSales());
        report.put("dailySales", dashboardMapper.getSalesReportDailySales());
        return report;
    }

    @Override
    public List<Map<String, Object>> getOrderReport() {
        return dashboardMapper.getOrderReport();
    }
    @Override
    public List<Map<String, Object>> getSalesReportProductSales() {
        String sql =  "SELECT p.name, SUM(oi.quantity) AS quantity, SUM(oi.total_price) AS amount " +
                "FROM order_item oi " +
                "JOIN product p ON oi.product_id = p.id " +
                "JOIN `order` o ON oi.order_id = o.order_id " +
                "WHERE o.order_status != '已取消' " +
                "GROUP BY p.name"; // 改回按商品名称分组

        return dashboardMapper.getSalesReportProductSales();
    }
    
    @Override
    public Map<String, Object> getCategorySales() {
        Map<String, Object> categoryData = new HashMap<>();
        
        // 获取所有产品类型
        List<String> categories = dashboardMapper.getAllProductCategories();
        
        // 确保"其他"类别也被处理
        if (!categories.contains("其他")) {
            categories.add("其他");
        }
        
        // 为每个类别获取销售数据
        for (String category : categories) {
            List<Map<String, Object>> data = dashboardMapper.getCategorySalesByType(category);
            
            // 如果数据为空，添加占位数据
            if (data.isEmpty()) {
                Map<String, Object> placeholder = new HashMap<>();
                placeholder.put("name", "暂无数据");
                placeholder.put("value", 0);
                data.add(placeholder);
            }
            
            // 使用类别名称作为key，避免硬编码
            String categoryKey = category.replaceAll("\\s+", "") + "Data";
            categoryData.put(categoryKey, data);
        }
        
        return categoryData;
    }
    
    @Override
    public Map<String, Object> getUserCategorySales(Long userId) {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> categoryData = dashboardMapper.getUserCategorySales(userId);
        
        // 如果数据为空，添加占位数据
        if (categoryData.isEmpty()) {
            Map<String, Object> placeholder = new HashMap<>();
            placeholder.put("name", "暂无购买记录");
            placeholder.put("value", 0);
            categoryData.add(placeholder);
        }
        
        result.put("categoryData", categoryData);
        return result;
    }
    
    @Override
    public Map<String, Object> getHotProducts() {
        Map<String, Object> result = new HashMap<>();
        List<Map<String, Object>> products = dashboardMapper.getHotProducts();
        
        // 如果数据为空，添加占位数据
        if (products.isEmpty()) {
            Map<String, Object> placeholder = new HashMap<>();
            placeholder.put("name", "暂无热门产品");
            placeholder.put("sales", 0);
            products.add(placeholder);
        }
        
        result.put("products", products);
        return result;
    }
    
    @Override
    public Map<String, Object> getSeasonalTrend() {
        Map<String, Object> result = new HashMap<>();
        
        // 设置季节数据
        List<String> seasons = new ArrayList<>();
        seasons.add("春季");
        seasons.add("夏季");
        seasons.add("秋季");
        seasons.add("冬季");
        
        // 获取不同类别产品的季节性销售趋势数据
        List<Integer> phoneData = dashboardMapper.getSeasonalTrendByCategory("手机");
        List<Integer> computerData = dashboardMapper.getSeasonalTrendByCategory("电脑");
        List<Integer> tabletData = dashboardMapper.getSeasonalTrendByCategory("平板");
        List<Integer> headphoneData = dashboardMapper.getSeasonalTrendByCategory("耳机");
        
        // 如果数据为空，提供默认值
        if (phoneData.isEmpty()) {
            phoneData = new ArrayList<>();
            phoneData.add(25);
            phoneData.add(20);
            phoneData.add(28);
            phoneData.add(27);
        }
        
        if (computerData.isEmpty()) {
            computerData = new ArrayList<>();
            computerData.add(22);
            computerData.add(18);
            computerData.add(30);
            computerData.add(30);
        }
        
        if (tabletData.isEmpty()) {
            tabletData = new ArrayList<>();
            tabletData.add(20);
            tabletData.add(25);
            tabletData.add(28);
            tabletData.add(27);
        }
        
        if (headphoneData.isEmpty()) {
            headphoneData = new ArrayList<>();
            headphoneData.add(24);
            headphoneData.add(30);
            headphoneData.add(26);
            headphoneData.add(20);
        }
        
        result.put("seasons", seasons);
        result.put("phoneData", phoneData);
        result.put("computerData", computerData);
        result.put("tabletData", tabletData);
        result.put("headphoneData", headphoneData);
        
        return result;
    }
}