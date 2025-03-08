package com.shop.system.service.impl;

import com.shop.system.mapper.DashboardMapper;
import com.shop.system.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
        String sql = "SELECT " +
                "CASE p.category " +
                "  WHEN '电脑' THEN '电脑' " +
                "  WHEN '手机' THEN '手机' " +
                "  WHEN '平板' THEN '平板' " +
                "  WHEN '耳机' THEN '耳机' " +
                "  ELSE '其他' " +
                "END AS category, " +
                "SUM(oi.total_price) AS sales " +
                "FROM order_item oi " +
                "JOIN product p ON oi.product_id = p.id " +
                "JOIN `order` o ON oi.order_id = o.order_id " +
                "WHERE o.order_status != '已取消' " +
                "GROUP BY category";  // 按类别分组
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
}