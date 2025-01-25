import request from '@/utils/request'

// 查询订单主表列表
export function listOrder(query) {
  return request({
    url: '/system/order/list',
    method: 'get',
    params: query
  })
}

// 修改订单主表
export function updateOrder(data) {
  return request({
    url: '/shop/order',
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
