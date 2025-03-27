<template>
  <div class="admin-alerts-container">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-card shadow="hover" class="alert-card pending-orders">
          <div slot="header" class="card-header">
            <span><i class="el-icon-s-order"></i> 待处理订单</span>
            <el-button v-if="stats.pendingOrdersCount > 0" 
                    style="float: right; padding: 3px 0" 
                    type="text"
                    @click="goToOrders">查看订单</el-button>
          </div>
          <div class="card-content">
            <div class="alert-count">{{ stats.pendingOrdersCount }}</div>
            <div class="alert-description">
              <template v-if="stats.pendingOrdersCount > 0">
                有 <span class="highlight">{{ stats.pendingOrdersCount }}</span> 个待发货的订单需要处理
              </template>
              <template v-else>
                目前没有待处理的订单
              </template>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="12">
        <el-card shadow="hover" class="alert-card low-stock">
          <div slot="header" class="card-header">
            <span><i class="el-icon-warning-outline"></i> 库存警告</span>
            <el-button v-if="stats.lowStockCount > 0" 
                    style="float: right; padding: 3px 0" 
                    type="text"
                    @click="checkLowStock">查看详情</el-button>
          </div>
          <div class="card-content">
            <div class="alert-count">{{ stats.lowStockCount }}</div>
            <div class="alert-description">
              <template v-if="stats.lowStockCount > 0">
                有 <span class="highlight">{{ stats.lowStockCount }}</span> 个商品库存不足（低于3件）
              </template>
              <template v-else>
                所有商品库存充足
              </template>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 库存警告商品对话框 -->
    <el-dialog title="库存不足商品列表" :visible.sync="lowStockDialogVisible" width="70%">
      <el-table :data="lowStockProducts" stripe style="width: 100%">
        <el-table-column prop="id" label="商品ID" width="80" />
        <el-table-column prop="name" label="商品名称" />
        <el-table-column prop="category" label="类别" width="100" />
        <el-table-column prop="stock" label="当前库存" width="100">
          <template slot-scope="scope">
            <el-tag type="danger" v-if="scope.row.stock === 0">无库存</el-tag>
            <el-tag type="warning" v-else>{{ scope.row.stock }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="price" label="价格" width="100">
          <template slot-scope="scope">
            ￥{{ scope.row.price }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template slot-scope="scope">
            <el-button type="text" @click="editProduct(scope.row)">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
    
    <!-- 快速修改库存对话框 -->
    <el-dialog title="修改库存" :visible.sync="editStockDialogVisible" width="30%">
      <el-form :model="editingProduct" label-width="80px" :rules="editRules" ref="stockForm">
        <el-form-item label="商品名称">
          <span>{{ editingProduct.name }}</span>
        </el-form-item>
        <el-form-item label="当前库存">
          <span>{{ editingProduct.stock }}</span>
        </el-form-item>
        <el-form-item label="新库存" prop="newStock">
          <el-input-number 
            v-model="editingProduct.newStock" 
            :min="0" 
            :max="999"
            controls-position="right">
          </el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="editStockDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitStockEdit" :loading="submitLoading">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getAdminStats, getLowStockProducts } from '@/api/system/dashboard'
import { getProduct, updateProduct } from '@/api/system/product'

export default {
  name: 'AdminAlerts',
  data() {
    return {
      stats: {
        pendingOrdersCount: 0,
        lowStockCount: 0
      },
      loading: false,
      lowStockDialogVisible: false,
      lowStockProducts: [],
      // 编辑库存相关数据
      editStockDialogVisible: false,
      editingProduct: {
        id: null,
        name: '',
        stock: 0,
        newStock: 0
      },
      submitLoading: false,
      editRules: {
        newStock: [
          { required: true, message: '请输入库存数量', trigger: 'blur' },
          { type: 'number', min: 0, message: '库存不能小于0', trigger: 'blur' }
        ]
      }
    }
  },
  created() {
    this.fetchAdminStats()
  },
  watch: {
    // 监听路由参数变化
    '$route.query': {
      handler(query) {
        if (query.refresh === 'alerts') {
          // 当检测到refresh=alerts参数时，刷新数据
          this.fetchAdminStats()
          // 重新获取库存警告商品列表（如果对话框可见）
          if (this.lowStockDialogVisible) {
            this.fetchLowStockProducts()
          }
        }
      },
      immediate: true
    }
  },
  // 当页面被重新激活时（如从缓存中恢复）也刷新数据
  activated() {
    this.fetchAdminStats()
  },
  methods: {
    // 获取管理员提醒数据
    fetchAdminStats() {
      // 避免频繁加载，设置loading节流
      if (this.loading) return
      
      this.loading = true
      getAdminStats()
        .then(response => {
          this.stats = response.data
          this.loading = false
        })
        .catch(error => {
          console.error('获取管理员提醒数据失败:', error)
          this.loading = false
          this.$message.error('获取提醒数据失败')
        })
    },
    
    // 查看待处理订单
    goToOrders() {
      this.$router.push({
        path: '/system/adminOrder',
        query: { orderStatus: '待发货' }
      })
    },
    
    // 查看库存不足商品
    checkLowStock() {
      this.lowStockDialogVisible = true
      this.fetchLowStockProducts()
    },
    
    // 获取库存不足商品列表
    fetchLowStockProducts() {
      // 显示加载状态
      this.lowStockProducts = []
      const loading = this.$loading({
        lock: true,
        text: '加载中...',
        spinner: 'el-icon-loading',
        background: 'rgba(255, 255, 255, 0.7)'
      })
      
      getLowStockProducts()
        .then(response => {
          this.lowStockProducts = response.rows || []
        })
        .catch(error => {
          console.error('获取库存警告商品失败:', error)
          this.$message.error('获取库存警告商品失败')
        })
        .finally(() => {
          // 无论成功失败都关闭加载状态
          loading.close()
        })
    },
    
    // 编辑商品库存
    editProduct(product) {
      // 不再跳转到其他页面，直接在当前页面编辑库存
      this.editingProduct = {
        id: product.id,
        name: product.name,
        stock: product.stock,
        newStock: product.stock
      }
      this.editStockDialogVisible = true
    },
    
    // 提交库存修改
    submitStockEdit() {
      this.$refs.stockForm.validate(valid => {
        if (valid) {
          this.submitLoading = true
          
          // 先获取完整的产品信息
          getProduct(this.editingProduct.id)
            .then(response => {
              const fullProduct = response.data
              // 只更新库存字段
              fullProduct.stock = this.editingProduct.newStock
              
              // 提交更新
              return updateProduct(fullProduct)
            })
            .then(() => {
              this.$message.success('库存修改成功')
              this.editStockDialogVisible = false
              
              // 更新库存警告列表
              this.fetchLowStockProducts()
              // 更新统计数据
              this.fetchAdminStats()
              
              // 如果新库存大于等于3，可能需要从列表中移除该商品
              if (this.editingProduct.newStock >= 3) {
                this.lowStockProducts = this.lowStockProducts.filter(
                  item => item.id !== this.editingProduct.id
                )
              } else {
                // 否则更新列表中的库存显示
                const index = this.lowStockProducts.findIndex(
                  item => item.id === this.editingProduct.id
                )
                if (index !== -1) {
                  this.lowStockProducts[index].stock = this.editingProduct.newStock
                }
              }
            })
            .catch(error => {
              console.error('修改库存失败:', error)
              this.$message.error('修改库存失败')
            })
            .finally(() => {
              this.submitLoading = false
            })
        }
      })
    }
  }
}
</script>

<style scoped>
.admin-alerts-container {
  margin-bottom: 30px;
}

.alert-card {
  height: 100%;
  transition: all 0.3s;
}

.alert-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.card-header {
  font-size: 16px;
  font-weight: 500;
}

.card-header i {
  margin-right: 5px;
}

.card-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 0;
}

.alert-count {
  font-size: 40px;
  font-weight: bold;
  margin-bottom: 10px;
}

.pending-orders .alert-count {
  color: #409EFF;
}

.low-stock .alert-count {
  color: #E6A23C;
}

.alert-description {
  color: #5f6368;
  text-align: center;
  line-height: 1.6;
}

.highlight {
  font-weight: bold;
  color: #F56C6C;
}
</style> 