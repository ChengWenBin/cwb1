import request from '@/utils/request'

// 查询反馈列表
export function listFeedback(query) {
  return request({
    url: '/system/feedback/list',
    method: 'get',
    params: query
  })
}

// 查询当前用户反馈列表
export function listMyFeedback() {
  return request({
    url: '/system/feedback/mylist',
    method: 'get'
  })
}

// 查询未读反馈数量
export function getUnreadCount() {
  return request({
    url: '/system/feedback/unread',
    method: 'get'
  })
}

// 查询用户未读回复数量
export function getUserUnreadCount() {
  return request({
    url: '/system/feedback/user/unread',
    method: 'get'
  })
}

// 查询反馈详细
export function getFeedback(feedbackId) {
  return request({
    url: '/system/feedback/' + feedbackId,
    method: 'get'
  })
}

// 用户查询反馈详细
export function getFeedbackDetail(feedbackId) {
  return request({
    url: '/system/feedback/detail/' + feedbackId,
    method: 'get'
  })
}

// 新增反馈
export function addFeedback(data) {
  return request({
    url: '/system/feedback',
    method: 'post',
    data: data
  })
}

// 回复反馈
export function replyFeedback(data) {
  return request({
    url: '/system/feedback/reply',
    method: 'put',
    data: data
  })
}

// 标记为已读
export function markAsRead(feedbackId) {
  return request({
    url: '/system/feedback/read/' + feedbackId,
    method: 'put'
  })
}

// 用户标记为已读
export function userMarkAsRead(feedbackId) {
  return request({
    url: '/system/feedback/user/read/' + feedbackId,
    method: 'put'
  })
}

// 删除反馈
export function delFeedback(feedbackId) {
  return request({
    url: '/system/feedback/' + feedbackId,
    method: 'delete'
  })
} 