package com.shop.system.service;

import java.util.List;
import java.util.Map;

public interface IDashboardService {

    List<Map<String, Object>> getSalesTrend();

    List<Map<String, Object>> getProductSales();

    List<Map<String, Object>> getOrderTrend();

    List<Map<String, Object>> getOrderStatus();

    Map<String, Object> getSalesReport();

    List<Map<String, Object>> getOrderReport();

    List<Map<String, Object>> getSalesReportProductSales();
    
    Map<String, Object> getCategorySales();
    
    Map<String, Object> getUserCategorySales(Long userId);
    
    Map<String, Object> getHotProducts();
    
    Map<String, Object> getSeasonalTrend();
}