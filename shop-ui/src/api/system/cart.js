import request from '@/utils/request'

// 查询购物车列表
export function listCart(query) {
  return request({
    url: '/system/cart/list',
    method: 'get',
    params: query
  })
}

// 新增商品到购物车
export function addCart(data) {
  return request({
    url: '/system/cart',
    method: 'post',
    data: data
  })
}

// 修改购物车商品数量
export function updateCart(data) {
  return request({
    url: '/system/cart',
    method: 'put',
    data: data
  })
}

// 删除购物车
export function deleteCart(cartId) {
  return request({
    url: `/system/cart/${cartId}`,
    method: 'delete'
  })
}

// 根据商品批量删除
export function deleteCartByProductIds(productIds) {
  return request({
    url: '/system/cart/product', // 或者你实际的批量删除接口路径
    method: 'delete',
    data: productIds, // 使用 data 传递参数，这里直接传递数组
    headers: {
      'Content-Type': 'application/json;charset=UTF-8'
    }
  })
}
