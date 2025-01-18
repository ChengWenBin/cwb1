import request from '@/utils/request'
import data from "@/views/system/dict/data.vue";

// 查询电子产品列表
export function listProduct(query) {
  return request({
    url: '/system/product/list',
    method: 'get',
    params: query
  })
}

// 新增电子产品
export function addProduct(data) {
  return request({
    url: '/system/product',
    method: 'post',
    data: data
  })
}

// 修改电子产品
export function updateProduct(data) {
  return request({
    url: '/system/product',
    method: 'put',
    data: data
  })
}

// 删除电子产品
export function deleteProduct(productIds) {
  return request({
    url: `/system/product`,
    method: 'delete',
    data: productIds
  })
}
// 根据id查询
export function getProduct(productId) {
  return request({
    url: `/system/product/${productId}`,
    method: 'get'
  })
}
