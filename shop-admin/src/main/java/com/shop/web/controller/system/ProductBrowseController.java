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
@RequestMapping("/system/product-browse")  //修改了RequestMapping路径
public class ProductBrowseController extends BaseController {
    @Autowired
    private IProductService productService;

    /**
     * 查询电子产品列表 (按类别)
     */
    @GetMapping("/list")
    public TableDataInfo list(Product product) {
        startPage();
        List<Product> list = productService.selectProductListByCategory(product);
        return getDataTable(list);
    }
}
