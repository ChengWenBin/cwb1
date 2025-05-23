import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from '@/views/system/data/Dashboard.vue'
Vue.use(Router)

/* Layout */
import Layout from '@/layout'

// 公共路由
export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login'),
    hidden: true
  },
  {
    path: '/register',
    component: () => import('@/views/register'),
    hidden: true
  },
  {
    path: '/404',
    component: () => import('@/views/error/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error/401'),
    hidden: true
  },
  {
    path: '',
    component: Layout,
    redirect: 'index',
    children: [
      {
        path: 'index',
        component: () => import('@/views/index'),
        name: 'Index',
        meta: { title: '首页', icon: 'dashboard', affix: true }
      }
    ]
  },
  {
    path: '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'profile',
        component: () => import('@/views/system/user/profile/index'),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user' }
      }
    ]
  },
  {
    path: '/feedback',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: '',
        component: () => import('@/views/system/feedback/index'),
        name: 'FeedbackManage',
        meta: { title: '客服反馈', icon: 'message', roles: ['admin', 'normal_admin'] }
      }
    ]
  }
]

// 动态路由，基于用户权限动态去加载
export const dynamicRoutes = [
  {
    path: '/system/user-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:user:edit'],
    children: [
      {
        path: 'role/:userId(\\d+)',
        component: () => import('@/views/system/user/authRole'),
        name: 'AuthRole',
        meta: { title: '分配角色', activeMenu: '/system/user' }
      }
    ]
  },
  {
    path: '/system/role-auth',
    component: Layout,
    hidden: true,
    permissions: ['system:role:edit'],
    children: [
      {
        path: 'user/:roleId(\\d+)',
        component: () => import('@/views/system/role/authUser'),
        name: 'AuthUser',
        meta: { title: '分配用户', activeMenu: '/system/role' }
      }
    ]
  },
  {
    path: '/system/dict-data',
    component: Layout,
    hidden: true,
    permissions: ['system:dict:list'],
    children: [
      {
        path: 'index/:dictId(\\d+)',
        component: () => import('@/views/system/dict/data'),
        name: 'Data',
        meta: { title: '字典数据', activeMenu: '/system/dict' }
      }
    ]
  },
  {
    path: '/monitor/job-log',
    component: Layout,
    hidden: true,
    permissions: ['monitor:job:list'],
    children: [
      {
        path: 'index/:jobId(\\d+)',
        component: () => import('@/views/monitor/job/log'),
        name: 'JobLog',
        meta: { title: '调度日志', activeMenu: '/monitor/job' }
      }
    ]
  },
  {
    path: '/tool/gen-edit',
    component: Layout,
    hidden: true,
    permissions: ['tool:gen:edit'],
    children: [
      {
        path: 'index/:tableId(\\d+)',
        component: () => import('@/views/tool/gen/editTable'),
        name: 'GenEdit',
        meta: { title: '修改生成配置', activeMenu: '/tool/gen' }
      }
    ]
  },
  {
    path: '/system',
    component: Layout,
    meta: { title: '系统管理', icon: 'el-icon-setting', alwaysShow: true },
    children: [
      {
        path: 'product',
        name: 'Product',
        component: () => import('@/views/system/product/index'),
        meta: { title: '电子产品管理', icon: 'shopping' }
      },
      {
        path: 'product-browse',
        component: () => import('@/views/system/product/ProductBrowse'),
        name: 'ProductBrowse',
        meta: { title: '电子产品浏览', icon: 'el-icon-s-goods' }
      },
      {
        path: 'cart',
        name: 'Cart',
        component: () => import('@/views/system/product/Cart'),
        meta: { title: '购物车', icon: 'el-icon-shopping-cart-full' }
      },
      {
        path: 'order',
        component: () => import('@/views/system/order/userOrder'),
        name: 'UserOrder',
        meta: { title: '我的订单', icon: 'el-icon-s-order' }
      },
      {
        path: 'adminOrder',
        component: () => import('@/views/system/order/adminOrder'),
        name: 'AdminOrder',
        meta: { title: '订单管理', icon: 'el-icon-s-order' }
      },
      {
        path: 'dashboard', // 添加新的 dashboard 路由
        name: 'Dashboard',
        component: Dashboard, // 确保这里指向了正确的组件
        meta: { title: '数据看板', icon: 'dashboard' } // 您可以自定义图标和标题
      }
    ]
  },
]

// 防止连续点击多次路由报错
let routerPush = Router.prototype.push;
let routerReplace = Router.prototype.replace;
// push
Router.prototype.push = function push(location) {
  return routerPush.call(this, location).catch(err => err)
}
// replace
Router.prototype.replace = function push(location) {
  return routerReplace.call(this, location).catch(err => err)
}

export default new Router({
  mode: 'history', // 去掉url中的#
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})
