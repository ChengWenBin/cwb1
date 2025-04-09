package com.shop.web.controller.system;

import com.shop.common.annotation.Log;
import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.common.enums.BusinessType;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 产品类型管理 Controller
 */
@RestController
@RequestMapping("/system/category")
public class CategoryController extends BaseController {
    @Autowired
    private IProductService productService;

    /**
     * 获取所有产品类型
     */
    @GetMapping("/list")
    public TableDataInfo list() {
        startPage();
        List<String> list = productService.selectAllCategories();
        return getDataTable(list);
    }

    /**
     * 新增产品类型
     */
    @PostMapping
    @Log(title = "产品类型管理", businessType = BusinessType.INSERT)
    public AjaxResult add(@RequestBody Map<String, String> params) {
        String category = params.get("category");
        return toAjax(productService.insertCategory(category));
    }

    /**
     * 修改产品类型
     */
    @PutMapping
    @Log(title = "产品类型管理", businessType = BusinessType.UPDATE)
    public AjaxResult edit(@RequestBody Map<String, String> params) {
        String oldCategory = params.get("oldCategory");
        String newCategory = params.get("newCategory");
        return toAjax(productService.updateCategory(oldCategory, newCategory));
    }

    /**
     * 删除产品类型
     */
    @DeleteMapping("/{category}")
    @Log(title = "产品类型管理", businessType = BusinessType.DELETE)
    public AjaxResult remove(@PathVariable("category") String category) {
        return toAjax(productService.deleteCategory(category));
    }
    
    /**
     * 获取产品类型使用数量
     */
    @GetMapping("/count/{category}")
    public AjaxResult getCategoryCount(@PathVariable("category") String category) {
        int count = productService.getCategoryCount(category);
        Map<String, Object> data = new HashMap<>();
        data.put("count", count);
        return AjaxResult.success(data);
    }
}
