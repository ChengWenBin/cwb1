<template>
  <div class="app-container">
    <el-table :data="orderList" style="width: 100%" border>
      <el-table-column label="订单编号" prop="orderNo" />
      <el-table-column label="下单时间" prop="createTime" width="180" />
      <el-table-column label="总金额" prop="totalAmount" width="100"/>
      <el-table-column label="订单状态" prop="orderStatus" width="120" >
        <template slot-scope="scope">
          <el-tag v-if="scope.row.orderStatus === '待付款'" type="info">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '待发货'" type="warning">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已发货'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已完成'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已取消'" type="danger">{{ scope.row.orderStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="150">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleDetail(scope.row)"
          >详情</el-button>
          <el-button
            size="mini"
            type="danger"
            :disabled="scope.row.orderStatus !== '待付款'"
            @click="handleCancel(scope.row)"
          >取消</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="订单详情" :visible.sync="detailDialogVisible" width="70%">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="订单编号">{{ selectedOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="下单时间">{{ selectedOrder.createTime }}</el-descriptions-item>
        <el-descriptions-item label="总金额">{{ selectedOrder.totalAmount }}</el-descriptions-item>
        <el-descriptions-item label="订单状态" >
          <el-tag v-if="selectedOrder.orderStatus === '待付款'" type="info">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '待发货'" type="warning">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已发货'" type="success">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已完成'" type="success">{{ selectedOrder.orderStatus }}</el-tag>
          <el-tag v-else-if="selectedOrder.orderStatus === '已取消'" type="danger">{{ selectedOrder.orderStatus }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="支付时间">{{ selectedOrder.paymentTime }}</el-descriptions-item>
        <el-descriptions-item label="发货时间">{{ selectedOrder.deliveryTime }}</el-descriptions-item>
        <el-descriptions-item label="完成时间">{{ selectedOrder.receiveTime }}</el-descriptions-item>
        <el-descriptions-item label="备注">{{ selectedOrder.remark }}</el-descriptions-item>
      </el-descriptions>
      <h3>订单商品</h3>
      <el-table :data="orderItemList" style="width: 100%" border>
        <el-table-column label="产品ID" prop="productId" width="100"/>
        <el-table-column label="产品名称" prop="productName" />
        <el-table-column label="购买数量" prop="quantity" width="100"/>
        <el-table-column label="单价" prop="unitPrice" width="100" />
        <el-table-column label="总价" prop="totalPrice" width="100"/>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
import { listOrder, cancelOrder } from '@/api/system/order';
import {listOrderItem} from '@/api/system/orderItem'
import { getToken } from "@/utils/auth";

export default {
  data() {
    return {
      orderList: [],
      detailDialogVisible: false,
      selectedOrder: {},
      orderItemList:[],
      userId: ""
    };
  },
  created() {
    this.getUserId();
    this.fetchData();
  },
  methods: {
    getUserId() {
      const token = getToken();
      if (token) {
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          this.userId = payload.userId;

        } catch (e) {
          console.error("解析token失败", e);
        }
      }
    },
    fetchData() {
      listOrder({userId: this.userId}).then(response => {
        this.orderList = response.rows
      })
    },
    handleDetail(row) {
      this.selectedOrder = row;
      listOrderItem({orderId:row.orderId}).then(response => {
        this.orderItemList = response.rows;
        this.detailDialogVisible = true;
      })

    },
    handleCancel(row) {
      this.$confirm("确定取消该订单吗?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning"
      }).then(() => {
        cancelOrder({orderId:row.orderId}).then(response =>{
          if (response.code === 200){
            this.$message.success("取消成功");
            this.fetchData()
          }else{
            this.$message.error("取消失败")
          }
        });
      }).catch(() =>{

      });
    },
  },
};
</script>
