package com.shop.system.controller;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.system.domain.Product;
import com.shop.system.service.IRecommendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 产品推荐 控制器
 */
@RestController
@RequestMapping("/system/recommend")
public class RecommendController extends BaseController {
    
    @Autowired
    private IRecommendService recommendService;
    
    /**
     * 获取基于用户订单历史的产品推荐
     */
    @GetMapping("/products")
    public AjaxResult getRecommendedProducts() {
        List<Product> products = recommendService.getRecommendedProducts();
        return AjaxResult.success(products);
    }
}