package com.shop.system.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {

    List<Map<String, Object>> getSalesTrend();

    List<Map<String, Object>> getProductSales();

    Map<String, Object> getSalesReportTotalSales();

    List<Map<String, Object>> getSalesReportProductSales();

    List<Map<String, Object>> getSalesReportDailySales();

    List<Map<String, Object>> getOrderReport();
    List<Map<String, Object>> getOrderTrend();

    List<Map<String, Object>> getOrderStatus();
    
    List<Map<String, Object>> getCategorySalesByType(@Param("category") String category);
    
    List<Map<String, Object>> getUserCategorySales(@Param("userId") Long userId);
    
    List<Map<String, Object>> getHotProducts();
    
    List<Integer> getSeasonalTrendByCategory(@Param("category") String category);
    
    // 获取所有产品类型
    List<String> getAllProductCategories();
}