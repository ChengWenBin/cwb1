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
      </el-form-item>
      <el-form-item label="最小金额" prop="minAmount">
        <el-input-number v-model="queryParams.minAmount" :controls="false" placeholder="最小金额" style="width: 130px"/>
      </el-form-item>
      <el-form-item label="最大金额" prop="maxAmount">
        <el-input-number v-model="queryParams.maxAmount" :controls="false" placeholder="最大金额" style="width: 130px"/>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="fetchData">查询</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="orderList" style="width: 100%" border>
      <!-- ... 表格列保持不变 ... -->
      <el-table-column label="订单编号" prop="orderNo" />
      <el-table-column label="用户ID" prop="userId" />
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
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleDetail(scope.row)"
          >详情</el-button>
          <el-select v-model="scope.row.orderStatus" placeholder="请选择"  @change="handleStatusChange(scope.row)">
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
        <el-descriptions-item label="用户ID">{{ selectedOrder.userId }}</el-descriptions-item>
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
import { listOrder, updateOrder,selectOrderById } from '@/api/system/order';
import {listOrderItem} from '@/api/system/orderItem'

export default {
  data() {
    return {
      orderList: [],
      detailDialogVisible: false,
      queryParams:{},
      selectedOrder: {},
      orderItemList:[],
      orderStatus: '', // 新增：订单状态, 默认为空字符串（全部）
      minAmount: null, // 新增：最小金额
      maxAmount: null, // 新增：最大金额
    };
  },
  created() {
    this.fetchData();
  },
  methods: {
    fetchData(){
      listOrder(this.queryParams).then(response => {
        this.orderList = response.rows
      })
    },
    handleDetail(row) {
      this.selectedOrder = row;
      // 调用 selectOrderById 获取订单详情
      selectOrderById(row.orderId).then(response => {
        if (response.code === 200 && response.data) {
          this.selectedOrder = response.data; // 使用 selectOrderById 获取的完整订单信息
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
    resetQuery() { // 新增：重置查询条件
      this.queryParams = {
        orderNo: null,
        userId: null,
        orderStatus: '',
        minAmount: null,
        maxAmount: null,
      };
      this.fetchData(); // 重置后重新查询
    }
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
