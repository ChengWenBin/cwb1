<template>
  <div class="app-container">
    <el-table :data="orderList" style="width: 100%" border>
      <el-table-column label="订单编号" prop="orderNo" width="180"/>
      <el-table-column label="下单时间" prop="createTime" width="180"/>
      <el-table-column label="总金额" prop="totalAmount"  width="150"/>
      <el-table-column label="收货地址" prop="address"  width="250"/>
      <el-table-column label="订单状态" prop="orderStatus" width="120">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.orderStatus === '待付款'" type="info">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '待发货'" type="warning">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已发货'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已完成'" type="success">{{ scope.row.orderStatus }}</el-tag>
          <el-tag v-else-if="scope.row.orderStatus === '已取消'" type="danger">{{ scope.row.orderStatus }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            @click="handleDetail(scope.row)"
          >详情</el-button>
          <el-button
            size="mini"
            type="success"
            :disabled="scope.row.orderStatus !== '待付款'"
            @click="handlePay(scope.row)"
          >支付</el-button>
          <el-button
            size="mini"
            type="danger"
            :disabled="scope.row.orderStatus !== '待付款'"
            @click="handleCancel(scope.row)"
          >取消</el-button>
          <el-button size="mini" type="info" @click="handleRemark(scope.row)">备注</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog title="订单详情" :visible.sync="detailDialogVisible" width="70%">
      <el-descriptions :column="3" border>
        <el-descriptions-item label="订单编号">{{ selectedOrder.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="下单时间">{{ selectedOrder.createTime | formatDate}}</el-descriptions-item>
        <el-descriptions-item label="总金额">{{ selectedOrder.totalAmount }}</el-descriptions-item>
        <el-descriptions-item label="收货地址">{{ selectedOrder.address }}</el-descriptions-item>
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

    <el-dialog title="确认支付" :visible.sync="payDialogVisible" width="30%">
      <span>是否确认支付此订单？</span>
      <div slot="footer" class="dialog-footer">
        <el-button @click="payDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmPay">确定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="添加备注" :visible.sync="remarkDialogVisible" width="40%">
      <el-input type="textarea" v-model="currentRemark" :rows="4" placeholder="请输入备注"></el-input>
      <div slot="footer" class="dialog-footer">
        <el-button @click="remarkDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmRemark">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listOrder, cancelOrder, updateOrder, selectOrderById } from '@/api/system/order';
import {listOrderItem} from '@/api/system/orderItem'
import { getToken } from "@/utils/auth";

export default {
  data() {
    return {
      orderList: [],
      detailDialogVisible: false,
      selectedOrder: {},
      payDialogVisible: false,
      orderItemList:[],
      userId: "",  // 用于存储当前用户的 ID
      remarkDialogVisible: false, // 控制备注对话框的显示/隐藏
      currentRemark: '',        // 存储当前订单的备注内容
      currentOrderId: null,     // 存储当前操作的订单ID
      queryParams: {
        pageNum: 1,
        pageSize: 10
      }, // 查询参数,
      total:0
    };
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
          this.userId = payload.userId; // 获取用户 ID
        } catch (e) {
          console.error("解析token失败", e);
        }
      }
    },
    //  修改这里， 传入 userId
    fetchData() {
      listOrder({ userId: this.userId, ...this.queryParams }).then(response => {
        this.orderList = response.rows;
        this.total = response.total;
      })
    },
    handleDetail(row) {
      this.detailDialogVisible = true;
      this.selectedOrder = row; // 先赋值基本信息
      // 调用 selectOrderById 获取订单详情
      selectOrderById(row.orderId).then(response => {
        if (response.code === 200 && response.data) {
          this.selectedOrder = response.data; // 使用 selectOrderById 获取的完整订单信息
          listOrderItem({orderId:row.orderId}).then(response => {
            this.orderItemList = response.rows;
          })
        } else {
          this.$modal.msgError("加载订单详情失败");
        }
      });
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
    handlePay(row){
      this.selectedOrder = row;
      this.payDialogVisible = true;
    },
    confirmRemark() {
      // 调用后端 API 更新备注
      updateOrder({ orderId: this.currentOrderId, remark: this.currentRemark,orderStatus:this.selectedOrder.orderStatus })
        .then(response => { //  这里把新增的备注随着订单一起更新
          if (response.code === 200) {
            this.$message.success("备注更新成功");
            this.remarkDialogVisible = false; // 关闭对话框
            // 刷新订单列表 (或者只更新当前行的备注, 这里是全部刷新)
            this.fetchData();
          } else {
            this.$modal.msgError("备注更新失败");
          }
        })
        .catch(() => {
          this.$modal.msgError("备注更新失败");
        });
    },
    confirmPay(){
      this.payDialogVisible = false;
      this.selectedOrder.orderStatus = '待发货';
      updateOrder(this.selectedOrder).then(response => {
        if(response.code === 200){
          this.$message.success("支付成功")
          // 支付成功后， 立即重新获取订单详情
          selectOrderById(this.selectedOrder.orderId).then(detailResponse => { //  调用 selectOrderById
            if (detailResponse.code === 200 && detailResponse.data) {
              this.selectedOrder = detailResponse.data; // 更新 selectedOrder 为最新的订单详情
              // this.fetchData(); // 刷新订单列表, 这里可以不刷新
            } else {
              this.$modal.msgError("支付成功，但订单详情加载失败"); // 提示用户订单详情加载失败
              this.fetchData(); // 即使详情加载失败，也刷新订单列表
            }
          }).catch(() => {
            this.$modal.msgError("支付成功，但订单详情加载失败"); // 提示用户订单详情加载失败
            this.fetchData(); // 即使详情加载失败，也刷新订单列表
          });
        }else{
          this.$message.error("支付失败")
        }
      })
    },
    handleRemark(row) {
      this.currentOrderId = row.orderId; // 保存当前订单 ID
      this.currentRemark = row.remark || ''; // 获取当前订单的备注 (如果订单没有备注，则设置为空字符串)
      this.remarkDialogVisible = true;     // 显示备注对话框
    },
  },
};
</script>
