<template>
  <el-dialog
    title="为您推荐"
    :visible.sync="visible"
    width="70%"
    :before-close="handleClose"
    class="recommend-dialog"
  >
    <div v-if="loading" class="loading-container">
      <el-skeleton :rows="3" animated />
    </div>
    <div v-else-if="recommendedProducts.length === 0" class="empty-container">
      <i class="el-icon-shopping-bag-1" style="font-size: 48px; color: #909399;"></i>
      <p>暂无推荐产品，快去购买更多商品吧！</p>
    </div>
    <div v-else>
      <p class="recommend-tip">根据您的购买历史，我们为您推荐以下产品：</p>
      <el-row :gutter="20">
        <el-col :span="8" v-for="(product, index) in recommendedProducts" :key="index" class="product-col">
          <el-card shadow="hover" class="product-card">
            <div class="product-img">
              <el-image :src="product.imageUrl" fit="cover"></el-image>
            </div>
            <div class="product-info">
              <h3 class="product-name">{{ product.name }}</h3>
              <p class="product-category">{{ product.category }}</p>
              <p class="product-price">¥{{ product.price }}</p>
              <p class="product-description">{{ product.description }}</p>
              <p v-if="product.stock <= 0" class="product-stock out-of-stock">暂时缺货</p>
              <p v-else class="product-stock in-stock">库存: {{ product.stock }}</p>
              <el-button type="primary" size="small" @click="handleAddToCart(product)" :class="{ 'out-of-stock-btn': product.stock <= 0 }">{{ product.stock <= 0 ? '缺货可加购' : '加入购物车' }}</el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </el-dialog>
</template>

<script>
import { getRecommendedProducts } from '@/api/system/recommend';
import { addCart } from '@/api/system/cart';

export default {
  name: 'RecommendPopup',
  props: {
    visible: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      recommendedProducts: [],
      loading: true
    };
  },
  watch: {
    visible(val) {
      if (val) {
        this.fetchRecommendedProducts();
      }
    }
  },
  methods: {
    fetchRecommendedProducts() {
      this.loading = true;
      getRecommendedProducts()
        .then(response => {
          this.recommendedProducts = response.data || [];
          this.loading = false;
        })
        .catch(error => {
          console.error('获取推荐产品失败:', error);
          this.loading = false;
        });
    },
    handleClose() {
      this.$emit('update:visible', false);
    },
    handleAddToCart(product) {
      const cart = {
        productId: product.id,
        quantity: 1
      };
      addCart(cart)
        .then(() => {
          this.$modal.msgSuccess('添加购物车成功');
        })
        .catch(err => {
          console.error(err);
          this.$modal.msgError('添加购物车失败');
        });
    }
  }
};
</script>

<style scoped>
.recommend-dialog >>> .el-dialog__body {
  padding: 20px 30px;
}

.recommend-tip {
  margin-bottom: 20px;
  font-size: 16px;
  color: #606266;
}

.product-col {
  margin-bottom: 20px;
}

.product-card {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.product-img {
  height: 180px;
  overflow: hidden;
}

.product-img .el-image {
  width: 100%;
  height: 100%;
}

.product-info {
  padding: 10px 0;
}

.product-name {
  margin: 5px 0;
  font-size: 16px;
  font-weight: bold;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-category {
  color: #909399;
  font-size: 14px;
  margin: 5px 0;
}

.product-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: bold;
  margin: 10px 0;
}
.product-description {
  color: #606266;
  font-size: 14px;
  margin: 10px 0;
}
.loading-container,
.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
}

.empty-container p {
  margin-top: 15px;
  color: #909399;
  font-size: 16px;
}

.product-stock {
  margin: 5px 0;
  font-size: 14px;
}

.out-of-stock {
  color: #f56c6c;
}

.in-stock {
  color: #67c23a;
}

.out-of-stock-btn {
  color: #909399 !important;
  border-color: #dcdfe6 !important;
}
</style>
