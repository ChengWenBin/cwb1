<template>
  <el-dialog
    :title="title"
    :visible.sync="dialogVisible"
    width="800px"
    append-to-body
    @close="handleClose"
  >
    <el-card>
      <div class="product-header">
        <el-image :src="product.imageUrl" class="product-image"></el-image>
        <div class="product-info">
          <h2>{{ product.name }}</h2>
          <p class="price">¥{{ product.price }}</p>
          <p class="stock">库存: {{ product.stock }}</p>
          <p class="category no-pointer-events">类别: {{ product.category }}</p>
        </div>
      </div>

      <div class="product-content">
        <el-tabs v-model="activeTab">
          <el-tab-pane label="商品详情" name="detail">
            <div class="detail-content">
              <div v-html="product.description"></div>
              <!-- 显示描述图片，调整标题和样式 -->
              <div v-if="descriptionImages && descriptionImages.length > 0" class="description-images">
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
              <div v-html="product.detailHtml" class="detail-html-content"></div>
            </div>
          </el-tab-pane>
          <el-tab-pane label="规格参数" name="spec">
            <el-table :data="product.specifications" border style="width: 100%">
              <el-table-column prop="name" label="规格名称" width="180"></el-table-column>
              <el-table-column prop="value" label="规格值"></el-table-column>
            </el-table>
          </el-tab-pane>
        </el-tabs>
      </div>
    </el-card>
  </el-dialog>
</template>

<script>
import { getProduct } from '@/api/system/product'

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
      activeTab: 'detail',
      descriptionImages: []
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
      this.activeTab = 'detail';
      this.descriptionImages = []
    }
  }
}
</script>

<style scoped>
.product-header {
  display: flex;
  margin-bottom: 30px;
}

.product-image {
  width: 300px;
  height: 300px;
  margin-right: 30px;
}

.product-info {
  flex: 1;
}

.product-info h2 {
  margin: 0 0 20px 0;
  font-size: 24px;
}

.price {
  color: #f56c6c;
  font-size: 24px;
  margin: 10px 0;
}

.stock, .category {
  color: #606266;
  margin: 10px 0;
}

.no-pointer-events {
  pointer-events: none;
}

.detail-content {
  margin: 20px 0;
}

.detail-html-content {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #ebeef5;
}

.description-images {
  margin-top: 20px;
}

.image-gallery {
  display: flex;
  flex-wrap: wrap;
}

.image-item {
  margin: 10px;
  width: 150px;
  height: 150px;
}

.image-item .el-image {
  width: 100%;
  height: 100%;
}
</style>
