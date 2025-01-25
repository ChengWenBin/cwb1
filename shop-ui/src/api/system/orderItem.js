import request from '@/utils/request'

// 查询订单明细表列表
export function listOrderItem(query) {
  return request({
    url: '/system/orderItem/list',
    method: 'get',
    params: query
  })
}
