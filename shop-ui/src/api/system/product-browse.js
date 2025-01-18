import request from '@/utils/request'
// 查询电子产品列表
export function listProduct(query) {
  return request({
    url: '/system/product-browse/list',
    method: 'get',
    params: query
  })
}
