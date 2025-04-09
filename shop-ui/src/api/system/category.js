import request from '@/utils/request'

// 查询产品类型列表
export function listCategory() {
  return request({
    url: '/system/category/list',
    method: 'get'
  })
}

// 新增产品类型
export function addCategory(data) {
  return request({
    url: '/system/category',
    method: 'post',
    data: data
  })
}

// 修改产品类型
export function updateCategory(data) {
  return request({
    url: '/system/category',
    method: 'put',
    data: data
  })
}

// 删除产品类型
export function delCategory(category) {
  return request({
    url: '/system/category/' + category,
    method: 'delete'
  })
}

// 获取产品类型使用数量
export function getCategoryCount(category) {
  return request({
    url: '/system/category/count/' + category,
    method: 'get'
  })
}
