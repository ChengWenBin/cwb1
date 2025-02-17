import request from '@/utils/request'

// 查询订单主表列表
export function listOrder(query) {
  return request({
    url: '/system/order/list',
    method: 'get',
    params: query
  })
}

// 查询订单主表详细
export function selectOrderById(orderId) {  //  <==  添加 `selectOrderById` 函数，并使用 export 导出
  return request({
    url: '/system/order/' + orderId,
    method: 'get'
  })
}

// 修改订单主表
export function updateOrder(data) {
  return request({
    url: '/system/order',
    method: 'put',
    data: data
  })
}

// 取消订单主表
export function cancelOrder(data) {
  return request({
    url: '/system/order/cancel',
    method: 'put',
    data: data
  })
}

// 新增订单主表
export function createOrder(data) {
  return request({
    url: '/system/order/create',
    method: 'post',
    data: data
  })
}
