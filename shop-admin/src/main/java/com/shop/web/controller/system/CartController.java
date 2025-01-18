package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Cart;
import com.shop.system.service.ICartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
/**
 * 购物车 Controller
 */
@RestController
@RequestMapping("/system/cart")
public class CartController extends BaseController {
    @Autowired
    private ICartService cartService;

    /**
     * 查询购物车列表
     */
    @GetMapping("/list")
    public TableDataInfo list() {
        startPage();
        List<Cart> list = cartService.selectCartList(getUserId());
        return getDataTable(list);
    }
    /**
     * 添加商品到购物车
     */
    @PostMapping
    public AjaxResult add(@RequestBody Cart cart) {
        cart.setUserId(getUserId());
        return toAjax(cartService.insertCart(cart));
    }
    /**
     * 修改购物车商品数量
     */
    @PutMapping
    public AjaxResult update(@RequestBody Cart cart) {
        return toAjax(cartService.updateCart(cart));
    }
    /**
     * 删除购物车商品
     */
    @DeleteMapping("/{cartId}")
    public AjaxResult remove(@PathVariable Long cartId) {
        return toAjax(cartService.deleteCartById(cartId));
    }
    /**
     * 批量删除购物车商品
     */
    @DeleteMapping("/product")
    public AjaxResult remove(@RequestBody Long[] ids) {
        return toAjax(cartService.deleteCartByProductIds(ids,getUserId()));
    }
}