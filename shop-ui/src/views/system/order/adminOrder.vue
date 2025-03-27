<template>
  <div class="app-container">
    <el-form :inline="true" :model="queryParams" class="demo-form-inline" size="small">
      <el-form-item label="订单编号" prop="orderNo">
        <el-input
          v-model="queryParams.orderNo"
          placeholder="订单编号"
          clearable
          style="width: 160px"
        />
      </el-form-item>
      <el-form-item label="用户ID" prop="userId">
        <el-input
          v-model="queryParams.userId"
          placeholder="用户ID"
          clearable
          style="width: 120px"
        />
      </el-form-item>
      <el-form-item label="状态" prop="orderStatus">
        <el-select v-model="queryParams.orderStatus" placeholder="全部" clearable style="width: 120px">
          <el-option label="全部" value="" />
          <el-option label="待付款" value="待付款" />
          <el-option label="待发货" value="待发货" />
          <el-option label="已发货" value="已发货" />
          <el-option label="已完成" value="已完成" />
          <el-option label="已取消" value="已取消" />
        </el-select>
        <el-tag v-if="queryParams.orderStatus" type="warning" size="small" style="margin-left: 5px">
          过滤中: {{ queryParams.orderStatus }}
        </el-tag>
      </el-form-item>
      <el-form-item label="最小金额" prop="minAmount">
        <el-input-number
          v-model="queryParams.minAmount"
          :controls="false"
          placeholder="最小金额"
          style="width: 130px"
          :value="queryParams.minAmount === undefined ? undefined : queryParams.minAmount"
        />
      </el-form-item>
      <el-form-item label="最大金额" prop="maxAmount">
        <el-input-number
          v-model="queryParams.maxAmount"
          :controls="false"
          placeholder="最大金额"
          style="width: 130px"
          :value="queryParams.maxAmount === undefined ? undefined : queryParams.maxAmount"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="fetchData">查询</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="orderList" style="width: 100%" border>
      <el-table-column label="订单编号" prop="orderNo" />
      <el-table-column label="用户名称">
        <template #default="scope">
          <span v-if="userNameCache[scope.row.userId]">{{ userNameCache[scope.row.userId] }}</span>
          <el-tag v-else size="small" type="info">加载中...</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="下单时间" prop="createTime" width="180">
        <template #default="scope">
          {{ scope.row.createTime | formatDate }}
        </template>
      </el-table-column>
      <el-table-column label="总金额" prop="totalAmount" width="100"/>
      <el-table-column label="收货地址" prop="address"/>
      <el-table-column label="订单状态" prop="orderStatus" width="120">
        <template #default="scope">
          <el-tag v-if="scope.row.orderStatus === '待付款'" type="info">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '待发货'" type="warning">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已发货'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已完成'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已取消'" type="danger">{{ scope.row.orderStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="详情" width="90" align="center">
        <template #default="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleDetail(scope.row)"
          >详情</el-button>
        </template>
      </el-table-column>
      <el-table-column label="状态操作" width="160" align="center">
        <template #default="scope">
          <el-select v-model="scope.row.orderStatus" placeholder="请选择" size="mini" style="width: 100%" @change="handleStatusChange(scope.row)">
            <el-option label="待付款" value="待付款"></el-option>
            <el-option label="待发货" value="待发货"></el-option>
            <el-option label="已发货" value="已发货"></el-option>
            <el-option label="已完成" value="已完成"></el-option>
            <el-option label="已取消" value="已取消"></el-option>
          </el-select>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="订单详情" :visible.sync="detailDialogVisible" width="70%">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="订单编号">{{ selectedOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="用户名称">
          {{ userNameCache[selectedOrder.userId] || '未知用户' }}
        </el-descriptions-item>
        <el-descriptions-item label="下单时间">{{ selectedOrder.createTime | formatDate}}</el-descriptions-item>
        <el-descriptions-item label="总金额">{{ selectedOrder.totalAmount }}</el-descriptions-item>
        <el-descriptions-item label="收货地址">{{selectedOrder.address}}</el-descriptions-item>
        <el-descriptions-item label="订单状态" >
          <el-tag v-if="selectedOrder.orderStatus === '待付款'" type="info">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '待发货'" type="warning">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已发货'" type="success">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已完成'" type="success">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已取消'" type="danger">{{ selectedOrder.orderStatus }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ selectedOrder.paymentTime | formatDate }}</el-descriptions-item>
        <el-descriptions-item label="发货时间">{{ selectedOrder.deliveryTime | formatDate }}</el-descriptions-item>
        <el-descriptions-item label="完成时间">{{ selectedOrder.receiveTime | formatDate }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ selectedOrder.remark }}</el-descriptions-item>
      </el-descriptions>
      <h3>订单商品</h3>
      <el-table :data="orderItemList" style="width: 100%" border>
        <el-table-column label="产品ID" prop="productId" width="100"/>
        <el-table-column label="产品名称" prop="productName" />
        <el-table-column label="购买数量" prop="quantity" width="100"/>
        <el-table-column label="单价" prop="unitPrice" width="100"/>
        <el-table-column label="总价" prop="totalPrice" width="100"/>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { listOrder, updateOrder, selectOrderById } from '@/api/system/order';
import { listOrderItem } from '@/api/system/orderItem';
import { getUser } from '@/api/system/user';

export default {
  data() {
    return {
      orderList: [],
      detailDialogVisible: false,
      queryParams: {
        orderNo: undefined,
        userId: undefined,
        orderStatus: '',
        minAmount: undefined, // 使用 undefined 而不是 null
        maxAmount: undefined  // 使用 undefined 而不是 null
      },
      selectedOrder: {},
      orderItemList: [],
      orderStatus: '', // 默认为空字符串（全部）
      // 用户名称缓存
      userNameCache: {}
    };
  },
  created() {
    // 检查URL查询参数并应用到queryParams
    const { orderStatus } = this.$route.query;
    if (orderStatus) {
      this.queryParams.orderStatus = orderStatus;
    }
    
    this.fetchData();
  },
  watch: {
    // 监听路由参数变化
    '$route.query': {
      handler(query) {
        // 当订单状态参数变化时，更新查询条件并重新获取数据
        if (query.orderStatus !== undefined) {
          this.queryParams.orderStatus = query.orderStatus;
          this.fetchData();
        }
      },
      immediate: false // 不立即执行，避免与created中的逻辑重复
    }
  },
  methods: {
    fetchData(){
      // 创建一个新对象用于发送请求，过滤掉 undefined 值
      const params = {};
      for (const key in this.queryParams) {
        if (this.queryParams[key] !== undefined) {
          params[key] = this.queryParams[key];
        }
      }
      listOrder(params).then(response => {
        // 按下单时间倒序排序
        this.orderList = response.rows.sort((a, b) => {
          return new Date(b.createTime) - new Date(a.createTime);
        });
        // 获取所有订单的用户名称
        this.fetchUserNames();
      })
    },
    handleDetail(row) {
      this.selectedOrder = row;
      // 调用 selectOrderById 获取订单详情
      selectOrderById(row.orderId).then(response => {
        if (response.code === 200 && response.data) {
          this.selectedOrder = response.data; // 使用 selectOrderById 获取的完整订单信息
          
          // 确保用户名称已加载
          if (this.selectedOrder.userId && !this.userNameCache[this.selectedOrder.userId]) {
            getUser(this.selectedOrder.userId).then(res => {
              if (res.data && res.code === 200) {
                this.$set(this.userNameCache, this.selectedOrder.userId, res.data.nickName || res.data.userName || '未知用户');
              } else {
                this.$set(this.userNameCache, this.selectedOrder.userId, '未知用户');
              }
            }).catch(() => {
              this.$set(this.userNameCache, this.selectedOrder.userId, '未知用户');
            });
          }
          
          listOrderItem({orderId:row.orderId}).then(response => {
            this.orderItemList = response.rows;
            this.detailDialogVisible = true;
          })
        } else {
          this.$modal.msgError("加载订单详情失败");
        }
      });
    },
    handleStatusChange(row){
      //这里直接调用了this.fetchData()方法来刷新数据，你也可以按照userOrder.vue里面一样，调用selectOrderById来获取更新后的数据，效果是一样的。
      updateOrder(row).then(response =>{
        if (response.code === 200){
          this.$message.success("修改成功")
        }else {
          this.$message.error("修改失败")
        }
        this.fetchData()
      })
    },
    resetQuery() { // 修改：重置查询条件
      this.queryParams = {
        orderNo: undefined,
        userId: undefined,
        orderStatus: '',
        minAmount: undefined, // 关键修改：使用 undefined 而不是 null
        maxAmount: undefined  // 关键修改：使用 undefined 而不是 null
      };
      this.fetchData(); // 重置后重新查询
    },
    // 获取用户名称
    fetchUserNames() {
      // 收集所有需要获取名称的用户ID
      const userIds = [];
      this.orderList.forEach(order => {
        if (order.userId && !this.userNameCache[order.userId]) {
          userIds.push(order.userId);
        }
      });
      
      // 如果没有需要获取的用户名，直接返回
      if (userIds.length === 0) {
        return;
      }
      
      // 获取每个用户的名称
      const promises = userIds.map(userId => {
        return getUser(userId).then(res => {
          if (res.data && res.code === 200) {
            // 优先使用昵称，如果没有则使用用户名
            this.$set(this.userNameCache, userId, res.data.nickName || res.data.userName || '未知用户');
          } else {
            this.$set(this.userNameCache, userId, '未知用户');
          }
        }).catch(() => {
          this.$set(this.userNameCache, userId, '未知用户');
        });
      });
      
      // 等待所有请求完成
      Promise.all(promises).catch(error => {
        console.error('获取用户名称发生错误:', error);
      });
    },
  },
  filters: {
    formatDate(time) {
      if (!time) {
        return ''; // 或其他默认值
      }
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, '0'); // 月份从 0 开始，所以要 +1
      const day = date.getDate().toString().padStart(2, '0');
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      const seconds = date.getSeconds().toString().padStart(2, '0'); // 添加秒
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
  },
}
</script>

<style scoped>
.app-container {
  padding: 20px;
}

.el-table {
  margin-top: 15px;
}

.el-tag {
  font-weight: bold;
}

.el-select {
  margin-top: 5px;
}

.el-form-item {
  margin-bottom: 15px;
}

.el-descriptions {
  margin-bottom: 20px;
}

h3 {
  margin-top: 25px;
  margin-bottom: 15px;
  font-weight: 600;
  color: #303133;
}
</style>
