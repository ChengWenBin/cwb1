package com.shop.web.controller.system;

import com.shop.common.core.controller.BaseController;
import com.shop.common.core.page.TableDataInfo;
import com.shop.system.domain.OrderItem;
import com.shop.system.service.OrderItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 订单明细表 信息操作处理
 *
 * @author yourName
 * @date 2023-12-10
 */
@RestController
@RequestMapping("/system/orderItem")
public class OrderItemController extends BaseController {
    @Autowired
    private OrderItemService orderItemService;
    /**
     * 获取订单明细表列表
     */
    @GetMapping("/list")
    public TableDataInfo list(OrderItem orderItem)
    {
        startPage();
        List<OrderItem> list = orderItemService.selectOrderItemList(orderItem);
        return getDataTable(list);
    }
}
