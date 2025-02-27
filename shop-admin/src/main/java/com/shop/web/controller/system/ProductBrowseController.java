package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Product;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

/**
 * 电子产品浏览 Controller
 */
@RestController
@RequestMapping("/system/product-browse")
public class ProductBrowseController extends BaseController {
    @Autowired
    private IProductService productService;

    @GetMapping("/list")
    public TableDataInfo list(Product product) {
        startPage();
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }
}