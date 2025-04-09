<template>
  <el-dialog
    :title="dynamicTitle"
    :visible.sync="dialogVisible"
    width="800px"
    append-to-body
    @close="handleClose"
  >
    <el-card class="product-card" shadow="never">
      <div class="product-header">
        <div class="product-image-container">
          <div class="image-zoom-container">
            <el-image
              :src="product.imageUrl"
              class="product-image"
              fit="contain"
              :preview-src-list="[product.imageUrl]"
            ></el-image>
            <div class="zoom-hint">
              <i class="el-icon-zoom-in"></i> 点击查看大图
            </div>
          </div>
        </div>
        <div class="product-info">
          <h1 class="product-title">{{ product.name }}</h1>
          
          <div class="price-action-row">
            <div class="product-price-container">
              <span class="price-symbol">¥</span>
              <span class="price-value">{{ product.price }}</span>
            </div>
            
            <div class="action-buttons">
              <el-button type="danger" size="medium" icon="el-icon-shopping-cart-2" @click="addToCart" :disabled="product.stock <= 0">
                {{ product.stock > 0 ? '加入购物车' : '暂时缺货' }}
              </el-button>
            </div>
          </div>
          
          <div class="product-meta">
            <el-tag size="small" type="success" class="stock-tag">
              <i class="el-icon-goods"></i> 库存: {{ product.stock }}
            </el-tag>
            <el-tag size="small" type="info" class="category-tag">
              <i class="el-icon-collection-tag"></i> 分类: {{ product.category }}
            </el-tag>
          </div>

          <div v-if="product.description" class="product-description">
            <div v-html="product.description"></div>
          </div>
        </div>
      </div>

      <!-- 规格参数部分 -->
      <template v-if="hasSpecifications">
        <el-divider content-position="left">
          <span class="divider-title">规格参数</span>
        </el-divider>
        
        <div class="specifications-section">
          <el-descriptions :column="2" border>
            <el-descriptions-item v-for="(spec, index) in parsedSpecifications" :key="index" :label="spec.name">
              {{ spec.value }}
            </el-descriptions-item>
          </el-descriptions>
        </div>
      </template>

      <!-- 图片展示部分 -->
      <div class="product-content">
        <template v-if="descriptionImages && descriptionImages.length > 0">
          <el-divider content-position="left">
            <span class="divider-title">商品图库</span>
          </el-divider>

          <div class="description-images">
            <div class="image-gallery">
              <div v-for="(image, index) in descriptionImages" :key="index" class="image-item">
                <el-image
                  :src="image"
                  :preview-src-list="descriptionImages"
                  fit="cover">
                </el-image>
              </div>
            </div>
          </div>
        </template>

        <!-- 详细描述HTML内容部分 -->
        <template v-if="product.detailHtml">
          <el-divider content-position="left">
            <span class="divider-title">详细介绍</span>
          </el-divider>

          <div class="detail-html-content">
            <div v-html="product.detailHtml"></div>
          </div>
        </template>
      </div>
    </el-card>
  </el-dialog>
</template>

<script>
import { getProduct } from '@/api/system/product'
import { addCart } from '@/api/system/cart'

export default {
  name: 'ProductDetail',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    productId: {
      type: [Number, String],
      default: null
    }
  },
  data() {
    return {
      title: '商品详情',
      dialogVisible: false,
      product: {
        name: '',
        price: 0,
        stock: 0,
        category: '',
        imageUrl: '',
        description: '',
        detailHtml: '',
        specifications: []
      },
      descriptionImages: []
    }
  },
  computed: {
    dynamicTitle() {
      return this.product.name ? `${this.product.name} - 详情` : this.title;
    },
    hasSpecifications() {
      return this.product.specifications && this.product.specifications.length > 0;
    },
    parsedSpecifications() {
      // 如果后端提供的是字符串格式，尝试解析它
      if (typeof this.product.specifications === 'string') {
        try {
          return JSON.parse(this.product.specifications);
        } catch (e) {
          console.error('解析规格参数失败', e);
          return [];
        }
      }
      return this.product.specifications || [];
    }
  },
  watch: {
    visible(val) {
      this.dialogVisible = val;
      if (!val) {
        this.$emit('update:visible', false);
      }
    },
    productId: {
      handler(newVal) {
        if (newVal && this.visible) {
          this.getProductDetail(newVal);
        }
      },
      immediate: true
    }
  },
  methods: {
    getProductDetail(productId) {
      getProduct(productId).then(response => {
        this.product = response.data
        // 处理描述图片JSON
        if (this.product.descriptionImagesJson) {
          try {
            this.descriptionImages = JSON.parse(this.product.descriptionImagesJson);
          } catch (e) {
            console.error('解析描述图片JSON失败', e);
            this.descriptionImages = [];
          }
        } else {
          this.descriptionImages = [];
        }
      })
    },
    handleClose() {
      this.$emit('update:visible', false);
      this.$emit('update:productId', null);
      // 重置产品数据
      this.product = {
        name: '',
        price: 0,
        stock: 0,
        category: '',
        imageUrl: '',
        description: '',
        detailHtml: '',
        specifications: []
      };
      this.descriptionImages = [];
    },
    addToCart() {
      if (this.product.stock <= 0) {
        this.$message.warning('该商品暂时缺货');
        return;
      }
      
      const cart = {
        productId: this.product.id,
        quantity: 1
      };
      
      addCart(cart).then(() => {
        this.$message.success('已添加到购物车');
      }).catch(err => {
        this.$message.error('添加购物车失败');
        console.error('添加购物车失败:', err);
      });
    }
  }
}
</script>

<style scoped>
.product-card {
  border-radius: 6px;
  overflow: hidden;
}

.product-header {
  display: flex;
  margin-bottom: 20px;
  gap: 25px;
}

.product-image-container {
  flex: 0 0 280px;
  height: 280px;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #fafafa;
}

.image-zoom-container {
  position: relative;
  width: 100%;
  height: 100%;
  cursor: zoom-in;
}

.zoom-hint {
  position: absolute;
  bottom: 10px;
  left: 0;
  right: 0;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  padding: 4px 0;
  font-size: 12px;
  opacity: 0;
  transition: opacity 0.3s;
}

.image-zoom-container:hover .zoom-hint {
  opacity: 1;
}

.product-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  transition: transform 0.3s;
}

.product-image:hover {
  transform: scale(1.05);
}

.product-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.product-title {
  margin: 0 0 20px 0;
  font-size: 22px;
  font-weight: 600;
  color: #303133;
  line-height: 1.3;
}

.price-action-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin: 10px 0 15px;
}

.product-price-container {
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 18px;
  font-weight: 600;
  color: #f56c6c;
}

.price-value {
  font-size: 26px;
  font-weight: 700;
  color: #f56c6c;
  margin-left: 2px;
}

.product-meta {
  display: flex;
  gap: 12px;
  margin-top: 15px;
  margin-bottom: 15px;
}

.stock-tag, .category-tag {
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 12px;
}

.product-description {
  font-size: 14px;
  line-height: 1.6;
  color: #606266;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px dashed #ebeef5;
  max-height: 120px;
  overflow-y: auto;
}

.divider-title {
  font-size: 16px;
  font-weight: 600;
  color: #606266;
}

.product-content {
  margin-top: 15px;
}

.specifications-section {
  margin: 15px 0;
}

.description-images {
  margin: 15px 0;
}

.image-gallery {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
}

.image-item {
  width: 140px;
  height: 140px;
  border-radius: 4px;
  overflow: hidden;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s, box-shadow 0.3s;
}

.image-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.image-item .el-image {
  width: 100%;
  height: 100%;
}

.detail-html-content {
  padding: 10px 5px 15px;
  max-height: 300px;
  overflow-y: auto;
}

.action-buttons .el-button {
  padding: 10px 20px;
  font-size: 14px;
}
</style>
