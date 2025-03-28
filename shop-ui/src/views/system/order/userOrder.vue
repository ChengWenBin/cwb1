<template>
  <div class="app-container">
    <!-- 页面标题和筛选区域 -->
    <div class="order-header">
      <div class="title-area">
        <i class="el-icon-s-order"></i>
        <span>我的订单</span>
      </div>
      <div class="filter-area">
        <el-select v-model="statusFilter" placeholder="订单状态" size="small" clearable @change="handleFilterChange">
          <el-option label="全部订单" value=""></el-option>
          <el-option label="待付款" value="待付款"></el-option>
          <el-option label="待发货" value="待发货"></el-option>
          <el-option label="已发货" value="已发货"></el-option>
          <el-option label="已完成" value="已完成"></el-option>
          <el-option label="已取消" value="已取消"></el-option>
        </el-select>
      </div>
    </div>

    <!-- 订单列表 -->
    <el-table 
      v-loading="loading"
      :data="filteredOrders" 
      style="width: 100%" 
      border 
      stripe 
      :header-cell-style="{background:'#f5f7fa'}"
    >
      <el-table-column label="订单编号" prop="orderNo" width="180" show-overflow-tooltip/>
      <el-table-column label="下单时间" width="180">
        <template slot-scope="scope">
          <i class="el-icon-time"></i>
          <span style="margin-left: 5px">{{ scope.row.createTime | formatDate }}</span>
        </template>
      </el-table-column>
      <el-table-column label="总金额" width="110" align="center">
        <template slot-scope="scope">
          <span class="amount">¥ {{ scope.row.totalAmount }}</span>
        </template>
      </el-table-column>
      <el-table-column label="收货地址" min-width="200" show-overflow-tooltip>
        <template slot-scope="scope">
          <i class="el-icon-location"></i>
          <span style="margin-left: 5px">{{ scope.row.address }}</span>
        </template>
      </el-table-column>
      <el-table-column label="备注" min-width="140" show-overflow-tooltip>
        <template slot-scope="scope">
          <span v-if="scope.row.remark">{{ scope.row.remark }}</span>
          <span v-else class="no-data">暂无备注</span>
        </template>
      </el-table-column>
      <el-table-column label="修改地址" width="95" align="center">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="warning"
            plain
            :disabled="!['待付款', '待发货'].includes(scope.row.orderStatus)"
            @click="handleAddress(scope.row)"
          >修改</el-button>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" width="95" align="center">
        <template slot-scope="scope">
          <el-tag
            :type="getStatusType(scope.row.orderStatus)"
            effect="dark"
            size="small"
          >
            {{ scope.row.orderStatus }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center">
        <template slot-scope="scope">
          <div class="action-buttons">
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
            <el-button 
              size="mini" 
              type="info" 
              @click="handleRemark(scope.row)"
            >备注</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>

    <!-- 无数据提示 -->
    <div v-if="!loading && filteredOrders.length === 0" class="empty-data">
      <i class="el-icon-shopping-bag-2"></i>
      <p>暂无订单数据</p>
      <el-button type="primary" size="small" @click="goToShopping">去购物</el-button>
    </div>

    <!-- 订单详情对话框 -->
    <el-dialog title="订单详情" :visible.sync="detailDialogVisible" width="70%" class="detail-dialog">
      <div v-loading="detailLoading" element-loading-text="加载订单详情中..." class="detail-content">
        <div class="order-detail-header">
          <el-tag :type="getStatusType(selectedOrder.orderStatus)" effect="dark">
            {{ selectedOrder.orderStatus }}
          </el-tag>
          <div class="order-no">订单编号：{{ selectedOrder.orderNo }}</div>
        </div>
        
        <el-card shadow="never" class="detail-card">
          <div slot="header" class="card-header">
            <i class="el-icon-user"></i> 订单信息
          </div>
          <el-descriptions :column="3" border size="medium">
            <el-descriptions-item label="下单时间">{{ selectedOrder.createTime | formatDate }}</el-descriptions-item>
            <el-descriptions-item label="总金额">
              <span class="amount">¥ {{ selectedOrder.totalAmount }}</span>
            </el-descriptions-item>
            <el-descriptions-item label="收货地址">{{ selectedOrder.address }}</el-descriptions-item>
            <el-descriptions-item label="支付时间">{{ selectedOrder.paymentTime | formatDate }}</el-descriptions-item>
            <el-descriptions-item label="发货时间">{{ selectedOrder.deliveryTime | formatDate }}</el-descriptions-item>
            <el-descriptions-item label="完成时间">{{ selectedOrder.receiveTime | formatDate }}</el-descriptions-item>
            <el-descriptions-item label="备注" :span="3">{{ selectedOrder.remark || '无' }}</el-descriptions-item>
          </el-descriptions>
        </el-card>

        <el-card shadow="never" class="detail-card" style="margin-top: 20px;">
          <div slot="header" class="card-header">
            <i class="el-icon-shopping-cart-full"></i> 商品信息
          </div>
          <el-table :data="orderItemList" style="width: 100%" border stripe>
            <el-table-column label="商品图片" width="100" align="center">
              <template slot-scope="scope">
                <el-image 
                  v-if="scope.row.imageUrl" 
                  style="width: 70px; height: 70px; border-radius: 4px;" 
                  :src="scope.row.imageUrl" 
                  :preview-src-list="[scope.row.imageUrl]"
                  fit="cover">
                  <div slot="placeholder" class="image-slot">
                    <i class="el-icon-loading"></i>
                  </div>
                  <div slot="error" class="image-slot">
                    <i class="el-icon-picture-outline"></i>
                  </div>
                </el-image>
                <div v-else-if="scope.row.imageLoading" class="product-image-placeholder">
                  <i class="el-icon-loading"></i>
                </div>
                <div v-else class="product-image-placeholder">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </template>
            </el-table-column>
            <el-table-column label="商品名称" prop="productName" min-width="200" show-overflow-tooltip align="center"/>
            <el-table-column label="购买数量" prop="quantity" width="100" align="center"/>
            <el-table-column label="单价" width="120" align="center">
              <template slot-scope="scope">
                <span class="amount">¥ {{ scope.row.unitPrice }}</span>
              </template>
            </el-table-column>
            <el-table-column label="小计" width="120" align="center">
              <template slot-scope="scope">
                <span class="amount">¥ {{ scope.row.totalPrice }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </div>
    </el-dialog>

    <!-- 支付确认对话框 -->
    <el-dialog title="确认支付" :visible.sync="payDialogVisible" width="30%" center>
      <div class="pay-dialog-content">
        <div class="pay-icon">
          <i class="el-icon-wallet"></i>
        </div>
        <div class="pay-message">确认支付此订单吗？</div>
        <div class="pay-amount">
          <span>订单金额：</span>
          <span class="amount">¥ {{ selectedOrder.totalAmount }}</span>
        </div>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="payDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmPay">确认支付</el-button>
      </div>
    </el-dialog>

    <!-- 备注对话框 -->
    <el-dialog title="订单备注" :visible.sync="remarkDialogVisible" width="40%">
      <el-form :model="remarkForm" ref="remarkForm">
        <el-form-item label="备注信息" :label-width="formLabelWidth">
          <el-input
            type="textarea"
            v-model="remarkForm.remark"
            :rows="4"
            placeholder="请输入备注信息"
            maxlength="200"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="remarkDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmRemark">保存备注</el-button>
      </div>
    </el-dialog>

    <!-- 修改地址对话框 -->
    <el-dialog title="修改收货地址" :visible.sync="addressDialogVisible" width="40%">
      <el-form :model="addressForm" ref="addressForm" :rules="addressRules">
        <el-form-item label="当前地址" :label-width="formLabelWidth">
          <div class="current-address">{{ addressForm.oldAddress }}</div>
        </el-form-item>
        <el-form-item label="新收货地址" prop="address" :label-width="formLabelWidth">
          <el-input
            type="textarea"
            v-model="addressForm.address"
            :rows="3"
            placeholder="请输入新的收货地址"
            maxlength="100"
            show-word-limit
          ></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addressDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmAddressChange">确认修改</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listOrder, cancelOrder, updateOrder, selectOrderById, listMyOrder} from '@/api/system/order';
import {listOrderItem} from '@/api/system/orderItem';
import request from '@/utils/request';
import { getToken } from "@/utils/auth";

export default {
  data() {
    return {
      orderList: [],
      loading: false,
      detailLoading: false, // 订单详情加载状态
      statusFilter: '',
      detailDialogVisible: false,
      selectedOrder: {},
      payDialogVisible: false,
      orderItemList: [],
      userId: "",
      
      // 备注相关
      remarkDialogVisible: false,
      remarkForm: {
        remark: '',
        orderId: null
      },
      
      // 修改地址相关
      addressDialogVisible: false,
      addressForm: {
        oldAddress: '',
        address: '',
        orderId: null
      },
      addressRules: {
        address: [
          { required: true, message: '请输入收货地址', trigger: 'blur' },
          { min: 5, max: 100, message: '地址长度在 5 到 100 个字符之间', trigger: 'blur' }
        ]
      },
      
      // 通用表单设置
      formLabelWidth: '100px'
    };
  },
  computed: {
    // 根据过滤条件筛选订单
    filteredOrders() {
      if (!this.statusFilter) {
        return this.orderList;
      }
      return this.orderList.filter(order => order.orderStatus === this.statusFilter);
    }
  },
  filters: {
    formatDate(time) {
      if (!time) {
        return '暂无';
      }
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      const seconds = date.getSeconds().toString().padStart(2, '0');
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
  },
  created() {
    this.fetchData();
  },
  methods: {
    // 获取订单状态标签类型
    getStatusType(status) {
      const statusMap = {
        '待付款': 'info',
        '待发货': 'warning',
        '已发货': 'success',
        '已完成': 'success',
        '已取消': 'danger'
      };
      return statusMap[status] || 'info';
    },
    
    // 处理状态筛选变化
    handleFilterChange() {
      // 使用计算属性自动过滤
    },
    
    // 获取订单数据
    fetchData() {
      this.loading = true;
      listMyOrder().then(response => {
        // 按下单时间倒序排列
        if (response.rows) {
          this.orderList = response.rows.sort((a, b) => {
            return new Date(b.createTime) - new Date(a.createTime);
          });
        } else {
          this.orderList = [];
        }
        this.loading = false;
      }).catch(error => {
        console.error("获取订单列表失败:", error);
        this.$message.error("获取订单列表失败");
        this.loading = false;
      });
    },
    
    // 查看订单详情
    handleDetail(row) {
      this.selectedOrder = row; // 先赋值基本信息
      this.detailDialogVisible = true;
      this.detailLoading = true; // 显示订单详情加载状态
      this.orderItemList = []; // 清空之前的数据
      
      // 调用API获取订单详情
      selectOrderById(row.orderId).then(response => {
        if (response.code === 200 && response.data) {
          this.selectedOrder = response.data; // 更新为完整订单信息
          
          // 获取订单商品明细
          return listOrderItem({orderId: row.orderId});
        } else {
          this.$message.error("加载订单详情失败");
          this.detailLoading = false;
          return Promise.reject();
        }
      }).then(itemResponse => {
        if (itemResponse && itemResponse.rows) {
          this.orderItemList = itemResponse.rows.map(item => ({
            ...item,
            imageLoading: true, // 添加图片加载状态
            imageUrl: ''
          }));
          // 获取产品图片
          return this.getProductInfo();
        } else {
          this.$message.warning("订单商品信息加载失败");
          this.detailLoading = false;
          return Promise.reject();
        }
      }).catch((error) => {
        if (error) console.error("订单详情加载失败:", error);
        this.detailLoading = false;
      }).finally(() => {
        this.detailLoading = false;
      });
    },
    
    // 获取产品图片信息
    async getProductInfo() {
      try {
        // 创建所有产品图片的请求
        const productInfoPromises = this.orderItemList.map(async (item, index) => {
          if (item && item.productId) {
            try {
              return this.getProduct(item.productId).then(res => {
                if (res && res.imageUrl) {
                  // 更新单个商品的图片，不等待所有请求完成
                  this.$set(this.orderItemList[index], 'imageUrl', res.imageUrl);
                  this.$set(this.orderItemList[index], 'imageLoading', false);
                  return { ...item, imageUrl: res.imageUrl, imageLoading: false };
                } else {
                  this.$set(this.orderItemList[index], 'imageLoading', false);
                  return { ...item, imageLoading: false };
                }
              });
            } catch (e) {
              console.error(`获取商品(ID:${item.productId})图片失败:`, e);
              this.$set(this.orderItemList[index], 'imageLoading', false);
              return { ...item, imageLoading: false };
            }
          }
          return item;
        });
        
        // 等待所有请求完成，但通过上面的代码已经逐个更新了视图
        await Promise.all(productInfoPromises);
        return Promise.resolve();
      } catch (e) {
        console.error('获取商品图片失败', e);
        this.$message.warning('获取商品图片失败');
        return Promise.reject(e);
      }
    },
    
    // 获取单个产品信息
    async getProduct(productId) {
      try {
        const response = await request({ url: `/system/product/${productId}`, method: 'get' });
        if (response && response.data) {
          return response.data;
        } else {
          console.error("获取商品信息失败:", response);
          return { imageUrl: '' };
        }
      } catch (e) {
        console.error("获取商品信息失败:", e);
        return { imageUrl: '' };
      }
    },
    
    // 去购物页面
    goToShopping() {
      this.$router.push('/system/product-browse');
    },
    
    // 处理订单支付
    handlePay(row) {
      this.selectedOrder = row;
      this.payDialogVisible = true;
    },
    
    // 确认支付
    confirmPay() {
      this.payDialogVisible = false;
      this.selectedOrder.orderStatus = '待发货';
      
      updateOrder(this.selectedOrder).then(response => {
        if (response.code === 200) {
          this.$message.success({
            message: "订单支付成功",
            duration: 2000
          });
          
          // 支付成功后刷新订单列表
          this.fetchData();
          
          // 如果详情对话框打开，更新订单状态
          if (this.detailDialogVisible) {
            selectOrderById(this.selectedOrder.orderId).then(response => {
              if (response.code === 200 && response.data) {
                this.selectedOrder = response.data;
              }
            });
          }
        } else {
          this.$message.error("订单支付失败，请稍后重试");
        }
      }).catch(() => {
        this.$message.error("支付请求发送失败，请检查网络连接");
      });
    },
    
    // 处理订单取消
    handleCancel(row) {
      this.$confirm("确定要取消该订单吗？取消后无法恢复。", "提示", {
        confirmButtonText: "确定取消",
        cancelButtonText: "再考虑一下",
        type: "warning"
      }).then(() => {
        cancelOrder({orderId: row.orderId}).then(response => {
          if (response.code === 200) {
            this.$message.success("订单已成功取消");
            this.fetchData(); // 刷新订单列表
          } else {
            this.$message.error("订单取消失败，请稍后重试");
          }
        }).catch(() => {
          this.$message.error("取消请求发送失败，请检查网络连接");
        });
      });
    },
    
    // 处理订单备注
    handleRemark(row) {
      this.selectedOrder = row;
      this.remarkForm = {
        remark: row.remark || '',
        orderId: row.orderId
      };
      this.remarkDialogVisible = true;
    },
    
    // 确认保存备注
    confirmRemark() {
      // 调用API保存备注
      updateOrder({
        orderId: this.remarkForm.orderId,
        remark: this.remarkForm.remark,
        orderStatus: this.selectedOrder.orderStatus
      }).then(response => {
        if (response.code === 200) {
          this.$message.success("备注保存成功");
          this.remarkDialogVisible = false;
          
          // 刷新订单列表
          this.fetchData();
          
          // 如果详情对话框打开，更新备注
          if (this.detailDialogVisible && this.selectedOrder.orderId === this.remarkForm.orderId) {
            this.selectedOrder.remark = this.remarkForm.remark;
          }
        } else {
          this.$message.error("备注保存失败");
        }
      }).catch(() => {
        this.$message.error("备注保存请求发送失败，请检查网络连接");
      });
    },
    
    // 处理修改地址
    handleAddress(row) {
      this.selectedOrder = row;
      this.addressForm = {
        oldAddress: row.address || '',
        address: row.address || '',
        orderId: row.orderId
      };
      this.addressDialogVisible = true;
    },
    
    // 确认修改地址
    confirmAddressChange() {
      this.$refs.addressForm.validate(valid => {
        if (valid) {
          // 调用API修改地址
          updateOrder({
            orderId: this.addressForm.orderId,
            address: this.addressForm.address,
            orderStatus: this.selectedOrder.orderStatus
          }).then(response => {
            if (response.code === 200) {
              this.$message.success("收货地址修改成功");
              this.addressDialogVisible = false;
              
              // 刷新订单列表
              this.fetchData();
              
              // 如果详情对话框打开，更新地址
              if (this.detailDialogVisible && this.selectedOrder.orderId === this.addressForm.orderId) {
                this.selectedOrder.address = this.addressForm.address;
              }
            } else {
              this.$message.error("地址修改失败，请稍后重试");
            }
          }).catch(() => {
            this.$message.error("地址修改请求发送失败，请检查网络连接");
          });
        }
      });
    },
    
    // 处理下拉菜单命令
    handleCommand(command) {
      const { type, row } = command;
      switch (type) {
        case 'detail':
          this.handleDetail(row);
          break;
        case 'pay':
          this.handlePay(row);
          break;
        case 'address':
          this.handleAddress(row);
          break;
        case 'cancel':
          this.handleCancel(row);
          break;
        case 'remark':
          this.handleRemark(row);
          break;
      }
    }
  }
};
</script>

<style scoped>
.app-container {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 120px);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  background-color: #fff;
  padding: 15px 20px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.title-area {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
}

.title-area i {
  font-size: 24px;
  margin-right: 10px;
  color: #409EFF;
}

.filter-area {
  width: 150px;
}

/* 操作栏样式 */
.action-row {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.action-icons {
  display: flex;
  gap: 5px;
  justify-content: center;
}

.action-dropdown {
  display: none;
}

.action-buttons {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(2, auto);
  gap: 5px;
  justify-content: center;
  width: 100%;
  margin: 0 auto;
}

.action-buttons .el-button {
  margin: 0;
  width: 100%;
  height: 28px;
  padding: 5px 6px;
  font-size: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-data {
  text-align: center;
  padding: 60px 0;
  background-color: #fff;
  border-radius: 4px;
  margin-top: 20px;
}

.empty-data i {
  font-size: 60px;
  color: #909399;
}

.empty-data p {
  margin: 20px 0;
  color: #909399;
}

/* 订单详情样式 */
.order-detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  border-bottom: 1px solid #EBEEF5;
  padding-bottom: 15px;
}

.order-no {
  font-size: 14px;
  color: #606266;
}

.detail-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  align-items: center;
}

.card-header i {
  margin-right: 5px;
  color: #409EFF;
}

.product-image-placeholder {
  width: 70px;
  height: 70px;
  background-color: #f5f7fa;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  margin: 0 auto;
}

.product-image-placeholder i {
  font-size: 24px;
  color: #909399;
}

/* 金额样式 */
.amount {
  font-weight: bold;
  color: #F56C6C;
}

/* 支付对话框样式 */
.pay-dialog-content {
  text-align: center;
  padding: 20px 0;
}

.pay-icon {
  font-size: 40px;
  color: #E6A23C;
  margin-bottom: 15px;
}

.pay-message {
  font-size: 16px;
  margin-bottom: 20px;
}

.pay-amount {
  font-size: 16px;
}

/* 当前地址样式 */
.current-address {
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
  border-left: 4px solid #409EFF;
  line-height: 1.6;
  color: #606266;
}

/* 响应式调整 */
@media screen and (max-width: 992px) {
  .action-icons {
    display: none;
  }
  
  .action-dropdown {
    display: block;
  }
}

@media screen and (max-width: 768px) {
  .order-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .filter-area {
    margin-top: 10px;
    width: 100%;
  }
}

.no-data {
  color: #909399;
  font-size: 12px;
  font-style: italic;
}

.el-image {
  display: flex;
  margin: 0 auto;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background-color: #f5f7fa;
  color: #909399;
}

.image-slot .el-icon-loading {
  font-size: 20px;
  color: #409EFF;
  animation: rotating 2s linear infinite;
}

.detail-content {
  min-height: 300px;
  position: relative;
}

@keyframes rotating {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
