package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Order;
import com.shop.system.domain.Product;
import com.shop.system.service.IDashboardService;
import com.shop.system.service.OrderService;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 数据看板 控制器
 */
@RestController
@RequestMapping("/system/dashboard")
public class DashboardController extends BaseController {

    @Autowired
    private IDashboardService dashboardService;

    @Autowired
    private OrderService orderService;
    
    @Autowired
    private IProductService productService;

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

    /**
     * 获取待处理订单数量（状态为已付款/待发货的订单）
     */
    @GetMapping("/pendingOrders")
    public AjaxResult getPendingOrdersCount() {
        Order queryParams = new Order();
        queryParams.setOrderStatus("待发货");
        List<Order> pendingOrders = orderService.selectOrderList(queryParams);
        
        Map<String, Object> result = new HashMap<>();
        result.put("count", pendingOrders.size());
        return AjaxResult.success(result);
    }

    /**
     * 获取库存警告商品列表（库存低于3的商品）
     */
    @GetMapping("/lowStockProducts")
    public TableDataInfo getLowStockProducts() {
        Product queryParams = new Product();
        queryParams.setMinStock(0); // 最小库存为0（排除库存为负的异常情况）
        queryParams.setMaxStock(3); // 库存警告阈值为3
        
        List<Product> allProducts = productService.selectProductList(queryParams);
        // 筛选库存低于3的商品
        List<Product> lowStockProducts = allProducts.stream()
                .filter(product -> product.getStock() != null && product.getStock() <= 3 && product.getStock() >= 0)
                .collect(Collectors.toList());
        
        return getDataTable(lowStockProducts);
    }
    
    /**
     * 获取管理员首页统计数据
     */
    @GetMapping("/adminStats")
    public AjaxResult getAdminStats() {
        Map<String, Object> result = new HashMap<>();
        
        // 获取待处理订单数量
        Order queryParams = new Order();
        queryParams.setOrderStatus("待发货");
        List<Order> pendingOrders = orderService.selectOrderList(queryParams);
        result.put("pendingOrdersCount", pendingOrders.size());
        
        // 获取库存警告商品数量
        Product productParams = new Product();
        productParams.setMinStock(0);
        productParams.setMaxStock(3);
        List<Product> allProducts = productService.selectProductList(productParams);
        List<Product> lowStockProducts = allProducts.stream()
                .filter(product -> product.getStock() != null && product.getStock() <= 3 && product.getStock() >= 0)
                .collect(Collectors.toList());
        result.put("lowStockCount", lowStockProducts.size());
        
        return AjaxResult.success(result);
    }
}