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
        // 直接返回 getSalesReportProductSales 的结果
        return Map.of("productSales", dashboardMapper.getSalesReportProductSales());
    }

    @Override
    public List<Map<String, Object>> getOrderReport() {
        return dashboardMapper.getOrderReport();
    }
}
