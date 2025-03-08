import request from '@/utils/request'

// 获取基于用户订单历史的产品推荐
export function getRecommendedProducts() {
  return request({
    url: '/system/recommend/products',
    method: 'get'
  })
}