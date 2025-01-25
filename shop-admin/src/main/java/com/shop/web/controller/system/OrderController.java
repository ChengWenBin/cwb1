package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Order;
import com.shop.system.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 订单主表 信息操作处理
 *
 * @author yourName
 * @date 2023-12-10
 */
@RestController
@RequestMapping("/system/order")
public class OrderController extends BaseController {
    @Autowired
    private OrderService orderService;

    /**
     * 获取订单主表列表
     */
    @GetMapping("/list")
    public TableDataInfo list(Order order)
    {
        startPage();
        List<Order> list = orderService.selectOrderList(order);
        return getDataTable(list);
    }
    @PutMapping("/cancel")
    public AjaxResult cancel(@RequestBody Order order){
        order.setOrderStatus("已取消");
        return toAjax(orderService.updateOrder(order));
    }
    @PutMapping
    public AjaxResult update(@RequestBody Order order){
        return toAjax(orderService.updateOrder(order));
    }
}
