<template>
  <div class="user-order-stats-container">
    <el-row :gutter="20">
      <el-col :xs="12" :sm="6" :md="6" :lg="6" v-for="(item, index) in orderStats" :key="index">
        <el-card shadow="hover" class="order-stat-card" :class="item.class">
          <div class="card-content">
            <div class="stat-icon">
              <i :class="item.icon"></i>
            </div>
            <div class="stat-info">
              <div class="stat-count">{{ item.count }}</div>
              <div class="stat-name">{{ item.name }}</div>
            </div>
          </div>
          <div class="card-footer" @click="goToOrders(item.status)">
            <span>查看订单</span>
            <i class="el-icon-arrow-right"></i>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { getUserOrderStats } from '@/api/system/dashboard';

export default {
  name: 'UserOrderStats',
  data() {
    return {
      loading: true,
      orderStats: [
        { name: '待付款', count: 0, icon: 'el-icon-wallet', class: 'pending-payment', status: '待付款' },
        { name: '待发货', count: 0, icon: 'el-icon-box', class: 'pending-delivery', status: '待发货' },
        { name: '已发货', count: 0, icon: 'el-icon -truck', class: 'pending-receive', status: '已发货' },
        { name: '已完成', count: 0, icon: 'el-icon-circle-check', class: 'completed', status: '已完成' }
      ]
    };
  },
  created() {
    this.fetchOrderStats();
  },
  methods: {
    fetchOrderStats() {
      this.loading = true;
      getUserOrderStats()
        .then(response => {
          const data = response.data || {};
          // 更新订单状态数量
          this.orderStats[0].count = data.pendingPayment || 0;
          this.orderStats[1].count = data.pendingDelivery || 0;
          this.orderStats[2].count = data.pendingReceive || 0;
          this.orderStats[3].count = data.completed || 0;
          this.loading = false;
        })
        .catch(error => {
          console.error('获取订单状态统计失败:', error);
          this.loading = false;
        });
    },
    goToOrders(status) {
      this.$router.push({
        path: '/system/order',
        query: status ? { status } : {}
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.user-order-stats-container {
  margin-bottom: 20px;
}

.order-stat-card {
  border-radius: 10px;
  overflow: hidden;
  transition: all 0.3s ease;
  margin-bottom: 15px;
  border: none;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  }

  &.pending-payment {
    .stat-icon i {
      color: #ff9800;
      background-color: rgba(255, 152, 0, 0.1);
    }
    .card-footer {
      background-color: rgba(255, 152, 0, 0.05);
      color: #ff9800;
    }
  }

  &.pending-delivery {
    .stat-icon i {
      color: #2196f3;
      background-color: rgba(33, 150, 243, 0.1);
    }
    .card-footer {
      background-color: rgba(33, 150, 243, 0.05);
      color: #2196f3;
    }
  }

  &.pending-receive {
    .stat-icon i {
      color: #9c27b0;
      background-color: rgba(156, 39, 176, 0.1);
    }
    .card-footer {
      background-color: rgba(156, 39, 176, 0.05);
      color: #9c27b0;
    }
  }

  &.completed {
    .stat-icon i {
      color: #4caf50;
      background-color: rgba(76, 175, 80, 0.1);
    }
    .card-footer {
      background-color: rgba(76, 175, 80, 0.05);
      color: #4caf50;
    }
  }
}

.card-content {
  display: flex;
  align-items: center;
  padding: 15px;
}

.stat-icon {
  margin-right: 15px;

  i {
    font-size: 24px;
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

.stat-info {
  flex: 1;
}

.stat-count {
  font-size: 24px;
  font-weight: 700;
  line-height: 1.2;
  color: #333;
}

.stat-name {
  font-size: 14px;
  color: #666;
  margin-top: 5px;
}

.card-footer {
  padding: 10px 15px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s ease;

  &:hover {
    background-color: rgba(0, 0, 0, 0.03);
  }
}
</style>
