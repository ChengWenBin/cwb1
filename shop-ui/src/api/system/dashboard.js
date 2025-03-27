import request from '@/utils/request' // 确保已配置 axios

// 获取销售趋势数据
export function getSalesTrend() {
  return request({
    url: '/system/dashboard/salesTrend',
    method: 'get'
  })
}

// 获取产品销售分布数据
export function getProductSales() {
  return request({
    url: '/system/dashboard/productSales',
    method: 'get'
  })
}

// 获取订单数量趋势图数据
export function getOrderTrend() {
  return request({
    url: '/system/dashboard/orderTrend',
    method: 'get'
  })
}

// 获取订单状态分布图数据
export function getOrderStatus() {
  return request({
    url: '/system/dashboard/orderStatus',
    method: 'get'
  })
}

// 获取销售数据报表
export function getSalesReport() {
  return request({
    url: '/system/dashboard/salesReport',
    method: 'get'
  })
}

// 获取订单数据报表
export function getOrderReport() {
  return request({
    url: '/system/dashboard/orderReport',
    method: 'get'
  })
}

// 获取产品类别销售数量
export function getCategorySales() {
  return request({
    url: '/system/dashboard/categorySales',
    method: 'get'
  })
}

// 获取用户个人购买类别统计
export function getUserCategorySales() {
  return request({
    url: '/system/dashboard/userCategorySales',
    method: 'get'
  })
}

// 获取热门产品排行
export function getHotProducts() {
  return request({
    url: '/system/dashboard/hotProducts',
    method: 'get'
  })
}

// 获取季节性产品热销趋势
export function getSeasonalTrend() {
  return request({
    url: '/system/dashboard/seasonalTrend',
    method: 'get'
  })
}
