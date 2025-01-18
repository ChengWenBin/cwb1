package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.common.annotation.Log;
import com.shop.common.enums.BusinessType;
import com.shop.system.domain.Product;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 电子产品管理 Controller
 */
@RestController
@RequestMapping("/system/product")
public class ProductController extends BaseController {
    @Autowired
    private IProductService productService;

    /**
     * 查询电子产品列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Product product) {
        startPage();
        List<Product> list = productService.selectProductList(product);
        return getDataTable(list);
    }

    /**
     * 新增电子产品
     */
    @PostMapping
    @Log(title = "电子产品管理", businessType = BusinessType.INSERT)
    public AjaxResult add(@RequestBody Product product) {
        return toAjax(productService.insertProduct(product));
    }

    /**
     * 修改电子产品
     */
    @PutMapping
    @Log(title = "电子产品管理", businessType = BusinessType.UPDATE)
    public AjaxResult edit(@RequestBody Product product) {
        return toAjax(productService.updateProduct(product));
    }

    /**
     * 删除电子产品
     */
    @DeleteMapping
    @Log(title = "电子产品管理", businessType = BusinessType.DELETE)
    public AjaxResult remove(@RequestBody Long[] productIds) {
        return toAjax(productService.deleteProductByIds(productIds));
    }

    /**
     * 获取电子产品详细信息
     */
    @GetMapping("/{productId}")
    public AjaxResult getInfo(@PathVariable("productId") Long productId)
    {
        return success(productService.selectProductById(productId));
    }
}