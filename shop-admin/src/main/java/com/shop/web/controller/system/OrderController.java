package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.domain.AjaxResult;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.Order;
import com.shop.system.service.OrderService;
import com.shop.system.service.impl.OrderServiceImpl; // 导入实现类
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/system/order")
public class OrderController extends BaseController {
    @Autowired
    private OrderService orderService;

    @Autowired
    private OrderServiceImpl orderServiceImpl; // 注入 OrderServiceImpl

    /**
     * 获取当前用户订单列表 (我的订单)
     */
    @GetMapping("/myList")
    public TableDataInfo myList() { // 不需要传入 Order 对象
        startPage();
        List<Order> list = orderServiceImpl.selectMyOrderList(); // 调用新的方法
        return getDataTable(list);
    }

    /**
     * 获取所有订单列表 (订单管理)
     */
    @GetMapping("/list")
    public TableDataInfo list(Order order) {
        startPage();
        List<Order> list = orderService.selectOrderList(order); // 使用原来的方法
        return getDataTable(list);
    }

    // ... 其他方法保持不变 ...
    /**
     * 获取订单主表详细信息
     */
    @GetMapping(value = "/{orderId}")
    public AjaxResult getInfo(@PathVariable("orderId") Long orderId) {
        return AjaxResult.success(orderService.selectOrderById(orderId));
    }

    /**
     * 新增订单主表
     */
    @PostMapping
    public AjaxResult add(@RequestBody Order order) {
        return toAjax(orderService.insertOrder(order));
    }

    /**
     * 修改订单主表
     */
    @PutMapping
    public AjaxResult update(@RequestBody Order order) {
        if ("待发货".equals(order.getOrderStatus())) { //  <==  判断订单状态
            order.setPaymentTime(new Date()); // <==  设置 paymentTime
        } else if ("已发货".equals(order.getOrderStatus())) {
            order.setDeliveryTime(new Date()); // 设置发货时间
        } else if ("已完成".equals(order.getOrderStatus())) {
            order.setReceiveTime(new Date());  // 设置完成时间
        }
        return toAjax(orderService.updateOrder(order));
    }

    /**
     * 删除订单主表
     */
    @DeleteMapping("/{orderIds}")
    public AjaxResult remove(@PathVariable Long[] orderIds) {
        return toAjax(orderService.deleteOrderByIds(orderIds));
    }

    @PutMapping("/cancel")
    public AjaxResult cancel(@RequestBody Order order){
        order.setOrderStatus("已取消");
        return toAjax(orderService.updateOrder(order));
    }

    @PostMapping("/create")
    public AjaxResult createOrder(@RequestBody Order order){
        return toAjax(orderService.createOrder(order.getOrderItems(),order.getAddress()));
    }

}