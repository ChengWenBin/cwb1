package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.system.service.IDashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/system/dashboard")
public class DashboardController extends BaseController {

    @Autowired
    private IDashboardService dashboardService;

    @GetMapping("/salesTrend")
    public AjaxResult getSalesTrend() {
        return AjaxResult.success(dashboardService.getSalesTrend());
    }

    @GetMapping("/productSales")
    public AjaxResult getProductSales() {
        return AjaxResult.success(dashboardService.getProductSales());
    }

    @GetMapping("/orderTrend")
    public AjaxResult getOrderTrend() {
        return AjaxResult.success(dashboardService.getOrderTrend());
    }

    @GetMapping("/orderStatus")
    public AjaxResult getOrderStatus() {
        return AjaxResult.success(dashboardService.getOrderStatus());
    }

    @GetMapping("/salesReport")
    public AjaxResult getSalesReport() {
        return AjaxResult.success(dashboardService.getSalesReport());
    }

    @GetMapping("/orderReport")
    public AjaxResult getOrderReport() {
        return AjaxResult.success(dashboardService.getOrderReport());
    }
    
    @GetMapping("/categorySales")
    public AjaxResult getCategorySales() {
        return AjaxResult.success(dashboardService.getCategorySales());
    }
    
    @GetMapping("/userCategorySales")
    public AjaxResult getUserCategorySales() {
        Long userId = getUserId();
        return AjaxResult.success(dashboardService.getUserCategorySales(userId));
    }
    
    @GetMapping("/hotProducts")
    public AjaxResult getHotProducts() {
        return AjaxResult.success(dashboardService.getHotProducts());
    }
    
    @GetMapping("/seasonalTrend")
    public AjaxResult getSeasonalTrend() {
        return AjaxResult.success(dashboardService.getSeasonalTrend());
    }
}