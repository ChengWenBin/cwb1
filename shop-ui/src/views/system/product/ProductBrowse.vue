<template>
  <div class="app-container">
    <el-card>
      <div class="directory-container">
        <!-- 左侧目录结构 -->
        <div class="directory-menu">
          <el-menu
            :default-active="activeCategory"
            class="el-menu-vertical"
            @select="handleCategorySelect"
          >
            <el-menu-item index="all">
              <i class="el-icon-menu"></i>
              <span slot="title">全部产品</span>
            </el-menu-item>
            <el-menu-item v-for="category in categoryOptions" :key="category" :index="category">
              <i :class="getCategoryIcon(category)"></i>
              <span slot="title">{{ category }}</span>
            </el-menu-item>
          </el-menu>
        </div>

        <!-- 右侧内容区域 -->
        <div class="directory-content">
          <div class="search-header">
            <el-form :inline="true" ref="queryForm" :model="queryParams" class="search-form">
              <el-form-item label="产品名称" prop="name">
                <el-input v-model="queryParams.name" placeholder="请输入产品名称" clearable style="width: 150px" />
              </el-form-item>
              <el-form-item label="价格区间" class="price-range">
                <div class="price-input-group">
                  <el-input v-model.number="queryParams.minPrice" placeholder="最低价格" class="price-input" style="width: 100px" />
                  <span class="price-separator">-</span>
                  <el-input v-model.number="queryParams.maxPrice" placeholder="最高价格" class="price-input" style="width: 100px" />
                </div>
              </el-form-item>
              <el-form-item label="库存数量">
                <el-input v-model.number="queryParams.minStock" placeholder="最低库存" style="width: 120px" />
              </el-form-item>
            </el-form>
            <div class="header-buttons">
              <el-button type="primary" @click="handleQuery" icon="el-icon-search">查询</el-button>
              <el-button @click="resetQuery" icon="el-icon-refresh">重置</el-button>
              <el-button type="success" @click="showRecommend" icon="el-icon-star-off">查看推荐</el-button>
            </div>
          </div>

          <!-- 价格排序下拉框 -->
          <div class="sort-container">
            <span class="sort-label">价格排序：</span>
            <el-select v-model="sortOrder" @change="handleSortChange" style="width: 150px">
              <el-option label="价格从高到低" value="desc" />
              <el-option label="价格从低到高" value="asc" />
            </el-select>
          </div>

          <!-- 产品卡片网格布局 -->
          <div v-loading="loading" class="product-grid">
            <div v-if="paginatedProductList.length === 0" class="empty-container">
              <i class="el-icon-shopping-bag-1" style="font-size: 48px; color: #909399;"></i>
              <p>暂无符合条件的产品</p>
            </div>
            <el-row :gutter="24" v-else>
              <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="(product, index) in paginatedProductList" :key="index" class="product-col">
                <el-card shadow="hover" class="product-card" :class="{ 'out-of-stock-card': product.stock <= 0 }">
                  <div class="product-img" @click="showProductDetail(product)">
                    <el-image :src="product.imageUrl" fit="cover" :preview-src-list="[product.imageUrl]"></el-image>
                    <div class="category-tag">{{ product.category }}</div>
                  </div>
                  <div class="product-info">
                    <h3 class="product-name" @click="showProductDetail(product)">{{ product.name }}</h3>
                    <div class="product-meta">
                      <p class="product-price">¥{{ product.price }}</p>
                      <p v-if="product.stock <= 0" class="product-stock out-of-stock">暂时缺货</p>
                      <p v-else class="product-stock in-stock">库存: {{ product.stock }}</p>
                    </div>
                    <el-button 
                      type="primary" 
                      size="small" 
                      class="cart-button" 
                      @click="handleAddToCart(product)" 
                      :class="{ 'out-of-stock-btn': product.stock <= 0 }"
                    >
                      <i class="el-icon-shopping-cart-full"></i>
                      {{ product.stock <= 0 ? '缺货可加购' : '加入购物车' }}
                    </el-button>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </div>

          <!-- 分页 -->
          <div class="pagination-container">
            <el-pagination
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              :current-page="currentPage"
              :page-sizes="[10, 20, 50, 100]"
              :page-size="pageSize"
              layout="total, sizes, prev, pager, next, jumper"
              :total="filteredProductList.length">
            </el-pagination>
          </div>
        </div>
      </div>
    </el-card>
    <!-- 推荐产品弹窗 -->
    <recommend-popup :visible.sync="recommendVisible" />
    <!-- 商品详情弹窗 -->
    <ProductDetail :visible.sync="productDetailVisible" :productId="selectedProductId" />
  </div>
</template>

<script>
import { listProduct } from "@/api/system/product-browse";
import { listCategory } from "@/api/system/category";
import { addCart } from "@/api/system/cart";
import RecommendPopup from "./components/RecommendPopup.vue";
import ProductDetail from "./components/ProductDetail.vue";

export default {
  name: "ProductBrowse",
  components: {
    RecommendPopup,
    ProductDetail
  },
  data() {
    return {
      loading: true,
      allProductList: [],
      activeCategory: 'all',
      queryParams: {
        name: "",
        category: "",
        minPrice: null,
        maxPrice: null,
        minStock: null,
      },
      sortOrder: "desc",
      currentPage: 1,
      pageSize: 10,
      total: 0,
      recommendVisible: false,
      productDetailVisible: false,
      selectedProductId: null,
      categoryOptions: [],
      categoryIcons: {
        '电脑': 'el-icon-monitor',
        '手机': 'el-icon-mobile-phone',
        '平板': 'el-icon-mobile',
        '耳机': 'el-icon-headset',
        '其他': 'el-icon-goods'
      }
    };
  },
  computed: {
    filteredProductList() {
      let result = [...this.allProductList];

      if (this.queryParams.name) {
        result = result.filter(item =>
          item.name.toLowerCase().includes(this.queryParams.name.toLowerCase())
        );
      }

      if (this.queryParams.category) {
        result = result.filter(item =>
          item.category === this.queryParams.category
        );
      }

      if (this.queryParams.minPrice != null) {
        result = result.filter(item =>
          parseFloat(item.price) >= this.queryParams.minPrice
        );
      }

      if (this.queryParams.maxPrice != null) {
        result = result.filter(item =>
          parseFloat(item.price) <= this.queryParams.maxPrice
        );
      }

      if (this.queryParams.minStock != null) {
        result = result.filter(item =>
          item.stock >= this.queryParams.minStock
        );
      }

      if (this.sortOrder === 'asc') {
        result.sort((a, b) => parseFloat(a.price) - parseFloat(b.price));
      } else {
        result.sort((a, b) => parseFloat(b.price) - parseFloat(a.price));
      }

      return result;
    },

    paginatedProductList() {
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      return this.filteredProductList.slice(start, end);
    }
  },
  created() {
    this.fetchAllProducts();
    this.getCategoryOptions();
  },
  methods: {
    fetchAllProducts() {
      this.loading = true;

      const params = {
        pageNum: 1,
        pageSize: 1000,
        ...this.queryParams
      };

      listProduct(params)
        .then(response => {
          this.allProductList = response.rows;
          this.total = response.total;
          this.loading = false;
        })
        .catch(err => {
          this.loading = false;
          console.error("获取电子产品列表失败:", err);
        });
    },

    // 获取产品类型选项
    getCategoryOptions() {
      listCategory().then(response => {
        this.categoryOptions = response.rows || [];
      });
    },

    // 获取类型对应的图标
    getCategoryIcon(category) {
      return this.categoryIcons[category] || 'el-icon-goods';
    },

    handleQuery() {
      this.currentPage = 1;
      this.fetchAllProducts();
    },

    resetQuery() {
      this.$refs.queryForm.resetFields();
      this.queryParams.name = "";
      this.queryParams.category = "";
      this.queryParams.minPrice = null;
      this.queryParams.maxPrice = null;
      this.queryParams.minStock = null;
      this.sortOrder = "desc";
      this.currentPage = 1;
      this.handleQuery();
    },

    handleSortChange() {
      console.log("排序方式变更为:", this.sortOrder);
      this.currentPage = 1;
    },

    handleSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1;
    },

    handleCurrentChange(page) {
      this.currentPage = page;
    },

    tableRowClassName({row}) {
      if (row.stock <= 0) {
        return 'out-of-stock-row';
      }
      return '';
    },
    
    handleAddToCart(row) {
      const cart = {
        productId: row.id,
        quantity: 1,
      };
      addCart(cart).then(() => {
        this.$modal.msgSuccess("添加购物车成功");
      }).catch(err => {
        console.log(err);
        this.$modal.msgError("添加购物车失败");
      });
    },

    showRecommend() {
      this.recommendVisible = true;
    },

    handleCategorySelect(index) {
      this.activeCategory = index;
      this.queryParams.category = index === 'all' ? '' : index;
      this.currentPage = 1;
      this.handleQuery();
    },

    showProductDetail(row) {
      this.selectedProductId = row.id;
      this.productDetailVisible = true;
    },

    handleDetail(row) {
      this.$router.push({
        path: '/system/product/detail',
        query: { id: row.id }
      });
    }
  }
};
</script>

<style scoped lang="scss">
/* 变量定义 */
$primary-color: #1890ff;
$secondary-color: #52c41a;
$accent-color: #fa8c16;
$text-color-primary: #262626;
$text-color-secondary: #595959;
$text-color-light: #8c8c8c;
$bg-color-page: #f5f7fa;
$bg-color-card: #ffffff;
$border-color: #eaedf1;
$border-radius: 10px;
$shadow-light: 0 8px 18px rgba(0, 0, 0, 0.05);
$shadow-hover: 0 12px 24px rgba(0, 0, 0, 0.08);
$transition-common: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1);

/* 混合器定义 */
@mixin flex-center($direction: column) {
  display: flex;
  flex-direction: $direction;
  align-items: center;
  justify-content: center;
}

@mixin card-hover-effect {
  transition: $transition-common;
  &:hover {
    transform: translateY(-6px);
    box-shadow: $shadow-hover;
  }
}

.app-container {
  padding: 20px;
  background-color: $bg-color-page;
}

.directory-container {
  display: flex;
}

.directory-menu {
  width: 200px;
  margin-right: 20px;
  border-right: 1px solid $border-color;
  background-color: $bg-color-card;
  border-radius: $border-radius;
  box-shadow: $shadow-light;
  overflow: hidden;
}

.directory-content {
  flex: 1;
}

.el-menu-vertical {
  border-right: none;
}

.search-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  background-color: $bg-color-card;
  padding: 15px 20px;
  border-radius: $border-radius;
  box-shadow: $shadow-light;
}

.search-form {
  display: flex;
  align-items: center;
  gap: 15px;
  flex: 1;
  margin-right: 20px;
}

.search-form .el-form-item {
  margin-bottom: 0;
  margin-right: 0;
}

.search-form .el-form-item__content {
  display: flex;
  align-items: center;
}

.header-buttons {
  display: flex;
  gap: 8px;
  white-space: nowrap;
  margin-left: 15px;
  flex-shrink: 0;
}

.price-range {
  margin: 0 10px;
}

.price-input-group {
  display: flex;
  align-items: center;
}

.price-input {
  width: 100px;
}

.price-separator {
  margin: 0 5px;
  color: $text-color-secondary;
}

.sort-container {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding: 0 10px;
  background-color: $bg-color-card;
  border-radius: $border-radius;
  padding: 12px 20px;
  box-shadow: $shadow-light;
}

.sort-label {
  margin-right: 10px;
  font-size: 14px;
  color: $text-color-secondary;
  font-weight: 500;
}

/* 产品网格布局样式 */
.product-grid {
  margin-bottom: 20px;
}

.product-col {
  margin-bottom: 24px;
}

.product-card {
  height: 100%;
  @include card-hover-effect;
  border-radius: $border-radius;
  overflow: hidden;
  border: none;
  
  &.out-of-stock-card {
    opacity: 0.85;
  }
  
  ::v-deep .el-card__body {
    padding: 0;
  }
}

.product-img {
  height: 220px;
  overflow: hidden;
  position: relative;
  cursor: pointer;

  .el-image {
    width: 100%;
    height: 100%;
    transition: transform 0.7s ease;
  }

  &:hover .el-image {
    transform: scale(1.08);
  }
  
  /* 添加产品图片顶部渐变遮罩 */
  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 40px;
    background: linear-gradient(to bottom, rgba(0,0,0,0.2), transparent);
    z-index: 1;
  }
}

.category-tag {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: rgba($primary-color, 0.8);
  color: white;
  padding: 4px 10px;
  border-radius: 15px;
  font-size: 12px;
  font-weight: 500;
  z-index: 2;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.product-info {
  padding: 15px;
  display: flex;
  flex-direction: column;
  background-color: white;
  min-height: 140px;
}

.product-name {
  margin: 0 0 10px;
  font-size: 16px;
  font-weight: 700;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: $text-color-primary;
  letter-spacing: 0.3px;
  cursor: pointer;
  
  &:hover {
    color: $primary-color;
  }
}

.product-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.product-price {
  color: #ff4d4f;
  font-size: 18px;
  font-weight: 700;
  margin: 0;
}

.product-stock {
  font-size: 13px;
  margin: 0;
  padding: 3px 8px;
  border-radius: 12px;
}

.out-of-stock {
  color: #ff4d4f;
  background-color: rgba(#ff4d4f, 0.1);
  font-weight: 500;
}

.in-stock {
  color: $secondary-color;
  background-color: rgba($secondary-color, 0.1);
  font-weight: 500;
}

.cart-button {
  width: 100%;
  border-radius: 6px;
  height: 36px;
  font-weight: 500;
  letter-spacing: 0.5px;
  font-size: 14px;
  margin-top: auto;
  
  &.el-button--primary {
    background-color: $primary-color;
    border-color: $primary-color;
    
    &:hover, &:focus {
      background-color: darken($primary-color, 5%);
      border-color: darken($primary-color, 5%);
    }
  }
  
  &.out-of-stock-btn {
    background-color: #fff2f0;
    border-color: #ffccc7;
    color: #ff4d4f;
    
    &:hover, &:focus {
      background-color: #fff1ef;
      border-color: #ffb4a9;
      color: #ff4d4f;
    }
  }
}

.empty-container {
  @include flex-center;
  padding: 40px 0;
  min-height: 300px;
  background-color: $bg-color-card;
  border-radius: $border-radius;
  box-shadow: $shadow-light;
  
  .el-icon-shopping-bag-1 {
    margin-bottom: 18px;
  }
  
  p {
    margin-top: 15px;
    color: $text-color-light;
    font-size: 16px;
    font-weight: 500;
  }
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
  padding: 15px 20px;
  background-color: $bg-color-card;
  border-radius: $border-radius;
  box-shadow: $shadow-light;
}

/* 响应式布局调整 */
@media (max-width: 992px) {
  .product-img {
    height: 200px;
  }
  
  .product-info {
    min-height: 130px;
  }
}

@media (max-width: 768px) {
  .directory-container {
    flex-direction: column;
  }
  
  .directory-menu {
    width: 100%;
    margin-right: 0;
    margin-bottom: 20px;
    border-right: none;
  }
  
  .search-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-form {
    margin-right: 0;
    margin-bottom: 15px;
    flex-wrap: wrap;
  }
  
  .header-buttons {
    margin-left: 0;
    justify-content: flex-end;
  }
  
  .product-img {
    height: 180px;
  }
}

@media (max-width: 576px) {
  .product-img {
    height: 160px;
  }
  
  .product-info {
    padding: 12px;
    min-height: 120px;
  }
  
  .product-name {
    font-size: 15px;
  }
  
  .product-price {
    font-size: 16px;
  }
  
  .cart-button {
    height: 34px;
    font-size: 13px;
  }
}
</style>
