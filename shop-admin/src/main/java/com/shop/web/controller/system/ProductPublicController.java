package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Product;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 电子产品公共 Controller (无需用户认证)
 */
@RestController
@RequestMapping("/public/product") // 修改请求映射路径
public class ProductPublicController extends BaseController {

    @Autowired
    private IProductService productService;

    /**
     * 查询电子产品列表 (无需登录)
     */
    @GetMapping("/list")
    public TableDataInfo list(Product product) {
        startPage();
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }


    /**
     * 查询电子产品详情(无需登录)
     */
    @GetMapping("/{productId}")
    public AjaxResult getInfo(@PathVariable("productId") Long productId)
    {
        return success(productService.selectProductById(productId));
    }
}