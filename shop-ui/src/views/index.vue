<template>
  <div class="app-container home">
    <!-- 管理员提醒区域 -->
    <div v-if="roles.some(role => role === 'admin' || role === 'normal_admin')" class="alert-section">
      <keep-alive>
        <admin-alerts />
      </keep-alive>
    </div>
    

    
    <!-- 推荐产品 -->
    <div v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')" class="recommend-section">
      <el-divider content-position="center" class="section-divider">
        <span class="divider-text">为您推荐</span>
      </el-divider>
      <div v-if="recommendLoading" class="loading-container">
        <el-skeleton :rows="3" animated />
      </div>
      <div v-else-if="recommendedProducts.length === 0" class="empty-container">
        <i class="el-icon-shopping-bag-1" style="font-size: 48px; color: #909399;"></i>
        <p>暂无推荐产品，快去购买更多商品吧！</p>
      </div>
      <div v-else class="recommend-content">
        <p class="recommend-tip">根据您的购买历史，我们为您推荐以下产品：</p>
        <el-row :gutter="24">
          <el-col :xs="24" :sm="12" :md="8" v-for="(product, index) in recommendedProducts" :key="index" class="product-col">
            <el-card shadow="hover" class="product-card">
              <div class="product-img">
                <el-image :src="product.imageUrl" fit="cover"></el-image>
              </div>
              <div class="product-info">
                <h3 class="product-name">
                  <a href="javascript:;" @click="viewProductDetail(product)">{{ product.name }}</a>
                </h3>
                <p class="product-category">{{ product.category }}</p>
                <div class="product-footer">
                  <p class="product-price">¥{{ product.price }}</p>
                  <p v-if="product.stock <= 0" class="product-stock out-of-stock">暂时缺货</p>
                  <p v-else class="product-stock in-stock">库存: {{ product.stock }}</p>
                  <el-button type="primary" size="small" @click="handleAddToCart(product)" :class="{ 'out-of-stock-btn': product.stock <= 0 }">
                    {{ product.stock <= 0 ? '缺货可加购' : '加入购物车' }}
                  </el-button>
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </div>

    <!-- 可视化图表 -->
    <div v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')" class="charts-section">
      <el-divider content-position="center" class="section-divider">
        <span class="divider-text">可视化图表</span>
      </el-divider>
      <category-charts :isAdmin="false" />
    </div>

    <!-- 核心功能 -->
    <div class="features-section">
      <el-divider content-position="center" class="section-divider">
        <span class="divider-text">快速跳转</span>
      </el-divider>
      <el-row class="features-row" :gutter="36">
        <el-col
          v-for="(feature, index) in filteredFeatures"
          :key="index"
          :xs="12"
          :sm="8"
          :md="6"
          :lg="6"
          class="feature-col"
          @click.native="goTarget(feature.path)"
        >
          <el-card shadow="hover" class="feature-card">
            <div class="function-card-content">
              <div class="icon-wrapper" :style="{ backgroundColor: feature.bgColor }">
                <i :class="[feature.icon, 'function-icon']" :style="{ color: feature.iconColor }"></i>
              </div>
              <div class="function-name">{{ feature.name }}</div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <!-- 商品详情弹窗 -->
    <ProductDetail :visible.sync="productDetailVisible" :productId="selectedProductId" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getRecommendedProducts } from '@/api/system/recommend';
import { addCart } from '@/api/system/cart';
import CategoryCharts from '@/components/CategoryCharts';
import AdminAlerts from '@/components/AdminAlerts';
import ProductDetail from '@/views/system/product/components/ProductDetail.vue';


export default {
  name: "Index",
  components: {
    CategoryCharts,
    AdminAlerts,
    ProductDetail
  },
  filters: {
    // 添加文本截断过滤器
    truncateText(text, length) {
      if (!text) return '';
      if (text.length <= length) return text;
      return text.substring(0, length) + '...';
    }
  },
  computed: {
    ...mapGetters([
      'roles'
    ]),
    // 根据用户角色过滤显示的功能
    filteredFeatures() {
      // 定义所有功能
      const allFeatures = this.coreFeatures;

      // 判断是否为超级管理员角色
      const isAdmin = this.roles.some(role => role === 'admin');

      // 判断是否为普通管理员角色
      const isNormalAdmin = this.roles.some(role => role === 'normal_admin');

      // 如果是超级管理员，显示所有功能
      if (isAdmin) {
        return allFeatures;
      }

      // 如果是普通管理员，显示部分管理功能
      if (isNormalAdmin) {
        return allFeatures.filter(feature =>
          feature.name === '用户管理' ||
          feature.name === '电子产品管理' ||
          feature.name === '订单管理' ||
          feature.name === '数据看板' ||
          feature.name === '个人中心' 
        );
      }

      // 普通用户只显示这些功能
      return allFeatures.filter(feature =>
        feature.name === '电子产品浏览' ||
        feature.name === '购物车' ||
        feature.name === '我的订单' ||
        feature.name === '个人中心'
      );
    }
  },
  data() {
    // 定义柔和的背景色和对应的图标颜色
    const featureStyles = [
      { bgColor: '#e6f7ff', iconColor: '#1890ff' },
      { bgColor: '#fff7e6', iconColor: '#fa8c16' },
      { bgColor: '#f6ffed', iconColor: '#52c41a' },
      { bgColor: '#e6fffb', iconColor: '#13c2c2' },
      { bgColor: '#f9f0ff', iconColor: '#722ed1' },
      { bgColor: '#fff1f0', iconColor: '#f5222d' },
      { bgColor: '#f0f5ff', iconColor: '#2f54eb' },
      { bgColor: '#f9f0ff', iconColor: '#722ed1' },
      { bgColor: '#e6f7ff', iconColor: '#1890ff' },
    ]

    return {
      coreFeatures: [
        { icon: "el-icon-user", name: "用户管理", path: "/system/user", ...featureStyles[0] },
        { icon: "el-icon-user-solid", name: "角色管理", path: "/system/role", ...featureStyles[1] },
        { icon: "el-icon-s-goods", name: "电子产品管理", path: "/system/product", ...featureStyles[2] },
        { icon: "el-icon-view", name: "电子产品浏览", path: "/system/product-browse", ...featureStyles[3] },
        { icon: "el-icon-shopping-cart-full", name: "购物车", path: "/system/cart", ...featureStyles[4] },
        { icon: "el-icon-document", name: "我的订单", path: "/system/order", ...featureStyles[5] },
        { icon: "el-icon-s-order", name: "订单管理", path: "/system/adminOrder", ...featureStyles[6] },
        { icon: "el-icon-data-analysis", name: "数据看板", path: "/dashboard", ...featureStyles[7] },
        { icon: "el-icon-s-home", name: "个人中心", path: "/user/profile", ...featureStyles[8] }
      ],
      // 推荐产品数据
      recommendedProducts: [],
      recommendLoading: true,
      // 设置推荐产品最大展示数量
      maxRecommendProducts: 6,
      // 商品详情弹窗
      productDetailVisible: false,
      selectedProductId: null
    };
  },
  created() {
    // 页面创建时获取推荐产品
    this.fetchRecommendedProducts();
  },
  methods: {
    goTarget(path) {
      if (path) {
        this.$router.push({ path });
      } else {
        this.$message.warning('该功能暂未开放或路径未配置');
        console.warn("未配置跳转路径");
      }
    },
    // 获取推荐产品数据
    fetchRecommendedProducts() {
      this.recommendLoading = true;
      getRecommendedProducts()
        .then(response => {
          // 限制最大展示数量
          this.recommendedProducts = (response.data || []).slice(0, this.maxRecommendProducts);
          this.recommendLoading = false;
        })
        .catch(error => {
          console.error('获取推荐产品失败:', error);
          this.recommendLoading = false;
        });
    },
    // 添加到购物车
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
    },
    // 查看商品详情
    viewProductDetail(product) {
      this.selectedProductId = product.id;
      this.productDetailVisible = true;
    }
  }
};
</script>

<style scoped lang="scss">
// --- SCSS 变量定义 ---
$primary-color: #1890ff; // 更新主色调为更现代的蓝色
$secondary-color: #52c41a; // 次要色调
$accent-color: #fa8c16; // 强调色调
$text-color-primary: #262626; // 更深的主要文字颜色
$text-color-secondary: #595959; // 次要文字颜色
$text-color-light: #8c8c8c; // 浅色文字
$bg-color-page: #f5f7fa; // 更柔和的页面背景色
$bg-color-card: #ffffff; // 卡片背景色
$border-color: #eaedf1; // 更柔和的边框颜色
$border-radius: 10px; // 更大的圆角
$shadow-light: 0 8px 18px rgba(0, 0, 0, 0.05); // 升级阴影效果
$shadow-hover: 0 12px 24px rgba(0, 0, 0, 0.08); // 升级悬停阴影
$transition-common: all 0.35s cubic-bezier(0.25, 0.8, 0.25, 1); // 略微放慢过渡时间

// --- 混合器定义 ---
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

// --- 基础样式 ---
.app-container.home {
  padding: 25px 30px;
  background-color: $bg-color-page;
  min-height: calc(100vh - 84px);
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.03);
}

// 每个区域块样式
.alert-section, .recommend-section, .charts-section, .features-section, .order-stats-section {
  margin-bottom: 28px;
  background-color: $bg-color-card;
  border-radius: $border-radius;
  box-shadow: $shadow-light;
  padding: 20px;
  position: relative;
  overflow: hidden;
  
  // 添加左侧边框装饰
  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    width: 4px;
    background: linear-gradient(to bottom, $primary-color, lighten($primary-color, 15%));
  }
}

// --- 分隔线样式 ---
.section-divider {
  margin: 18px 0 25px;
  .divider-text {
    font-size: 20px;
    font-weight: 600;
    color: $primary-color;
    padding: 0 20px;
    background-color: $bg-color-card;
    position: relative;
    
    &::after {
      content: '';
      display: block;
      position: absolute;
      bottom: -5px;
      left: 50%;
      width: 40px;
      height: 3px;
      background-color: $primary-color;
      transform: translateX(-50%);
      border-radius: 3px;
    }
  }
  
  ::v-deep .el-divider__line {
    border-color: rgba($primary-color, 0.15);
    border-width: 1px;
  }
}

// --- 推荐产品区域样式 ---
.recommend-content {
  padding: 5px 10px;
}

.recommend-tip {
  margin-bottom: 15px;
  font-size: 15px;
  color: $text-color-secondary;
  text-align: center;
  font-weight: 500;
  letter-spacing: 0.5px;
}

.product-col {
  margin-bottom: 20px;
}

.product-card {
  height: 100%;
  @include card-hover-effect;
  border-radius: $border-radius;
  overflow: hidden;
  border: none;
  
  ::v-deep .el-card__body {
    padding: 0;
  }
}

.product-img {
  height: 170px;
  overflow: hidden;
  position: relative;

  .el-image {
    width: 100%;
    height: 100%;
    transition: transform 0.7s ease;
  }

  &:hover .el-image {
    transform: scale(1.08);
  }
  
  // 添加产品图片顶部渐变遮罩
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

.product-info {
  padding: 12px;
  display: flex;
  flex-direction: column;
  background-color: white;
  min-height: 140px;
}

.product-name {
  margin: 0 0 6px;
  font-size: 16px;
  font-weight: 700;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: $text-color-primary;
  letter-spacing: 0.3px;
}

.product-name a {
  color: inherit;
  text-decoration: none;
  cursor: pointer;
}

.product-name a:hover {
  color: $primary-color;
  text-decoration: underline;
}

.product-category {
  color: $primary-color;
  font-size: 13px;
  margin: 0 0 6px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  font-weight: 500;
  display: inline-block;
  padding: 3px 10px;
  background-color: rgba($primary-color, 0.08);
  border-radius: 15px;
}

.product-description {
  color: $text-color-secondary;
  font-size: 13px;
  margin: 0 0 10px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  line-height: 1.5;
  flex-grow: 1;
}

.product-footer {
  margin-top: auto;
  border-top: 1px solid rgba($border-color, 0.7);
  padding-top: 10px;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.product-price {
  color: #ff4d4f;
  font-size: 18px;
  font-weight: 700;
  margin: 3px 0;
}

.product-stock {
  font-size: 13px;
  margin: 2px 0 10px;
  padding: 3px 0;
}

.out-of-stock {
  color: #ff4d4f;
  font-weight: 500;
}

.in-stock {
  color: $secondary-color;
  font-weight: 500;
}

.el-button {
  width: 100%;
  border-radius: 6px;
  height: 34px;
  font-weight: 500;
  letter-spacing: 0.5px;
  font-size: 13px;
  
  &.el-button--primary {
    background-color: $primary-color;
    border-color: $primary-color;
    
    &:hover, &:focus {
      background-color: darken($primary-color, 5%);
      border-color: darken($primary-color, 5%);
    }
  }
}

.out-of-stock-btn {
  background-color: #fff2f0;
  border-color: #ffccc7;
  color: #ff4d4f;
  
  &:hover, &:focus {
    background-color: #fff1ef;
    border-color: #ffb4a9;
    color: #ff4d4f;
  }
}

.loading-container,
.empty-container {
  @include flex-center;
  padding: 40px 0;
  min-height: 300px;
}

.empty-container {
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

// --- 功能卡片区域样式 ---
.features-row {
  margin: 15px -10px;
}

.feature-col {
  margin-bottom: 25px;
  padding: 0 10px;
  cursor: pointer;
}

.feature-card {
  border-radius: $border-radius;
  border: none;
  box-shadow: $shadow-light;
  transition: $transition-common;
  height: 160px;
  overflow: hidden;
  position: relative;
  
  &:hover {
    transform: translateY(-6px);
    box-shadow: $shadow-hover;
    
    &::after {
      opacity: 1;
    }
  }
  
  // 添加悬停时的细微背景效果
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at center, rgba($primary-color, 0.08) 0%, transparent 70%);
    opacity: 0;
    transition: opacity 0.5s ease;
    z-index: 0;
  }

  ::v-deep .el-card__body {
    padding: 20px;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    z-index: 1;
  }
}

// 功能卡片内部内容样式
.function-card-content {
  text-align: center;
  width: 100%;
  position: relative;
  z-index: 2;

  .icon-wrapper {
    width: 70px;
    height: 70px;
    border-radius: 50%;
    margin: 0 auto 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: $transition-common;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    position: relative;
    
    &::after {
      content: '';
      position: absolute;
      inset: -5px;
      border-radius: 50%;
      border: 2px dashed transparent;
      transition: all 0.5s ease;
    }

    .function-icon {
      font-size: 32px;
      transition: transform 0.4s ease;
    }
  }

  .function-name {
    font-size: 18px;
    font-weight: 600;
    color: $text-color-primary;
    transition: color 0.3s ease;
    letter-spacing: 0.5px;
    margin-top: 10px;
    position: relative;
    display: inline-block;
    
    &::after {
      content: '';
      position: absolute;
      bottom: -6px;
      left: 50%;
      width: 0;
      height: 2px;
      background-color: $primary-color;
      transition: all 0.4s ease;
      transform: translateX(-50%);
    }
  }

  // 卡片悬停时内容的特定效果
  .feature-card:hover & {
    .icon-wrapper {
      transform: scale(1.05);
      box-shadow: 0 8px 20px rgba($primary-color, 0.2);
      
      &::after {
        border-color: rgba($primary-color, 0.3);
        transform: rotate(45deg);
      }
    }
    .function-icon {
      transform: scale(1.1);
    }
    .function-name {
      color: $primary-color;
      
      &::after {
        width: 80%;
      }
    }
  }
}

// --- 响应式布局调整 ---
@media (max-width: 992px) {
  .app-container.home {
    padding: 20px 25px;
  }
  
  .feature-card {
    height: 140px;
  }
  
  .icon-wrapper {
    width: 60px;
    height: 60px;
    .function-icon {
      font-size: 28px;
    }
  }
  
  .function-name {
    font-size: 16px;
  }
  
  .product-img {
    height: 180px;
  }
  
  .product-info {
    min-height: 150px;
  }
}

@media (max-width: 768px) {
  .app-container.home {
    padding: 15px 20px;
  }
  
  .section-divider .divider-text {
    font-size: 18px;
  }
  
  .product-img {
    height: 160px;
  }
  
  .product-name {
    font-size: 16px;
  }
  
  .product-category {
    font-size: 13px;
  }
  
  .alert-section, .recommend-section, .charts-section, .features-section {
    padding: 15px;
    margin-bottom: 20px;
  }
}

@media (max-width: 576px) {
  .app-container.home {
    padding: 12px 15px;
  }
  
  .feature-card {
    height: 120px;
  }
  
  .icon-wrapper {
    width: 50px;
    height: 50px;
    margin-bottom: 10px;
    
    .function-icon {
      font-size: 24px;
    }
  }
  
  .function-name {
    font-size: 14px;
    margin-top: 6px;
  }
  
  .product-img {
    height: 140px;
  }
  
  .product-info {
    padding: 12px;
    min-height: 140px;
  }
  
  .product-description {
    -webkit-line-clamp: 2;
    font-size: 13px;
    margin-bottom: 8px;
  }
  
  .product-price {
    font-size: 18px;
  }
  
  .product-stock {
    font-size: 13px;
    margin-bottom: 10px;
  }
  
  .el-button {
    height: 36px;
    font-size: 13px;
  }
  
  .section-divider {
    margin: 15px 0 20px;
    
    .divider-text {
      font-size: 17px;
      padding: 0 15px;
      
      &::after {
        bottom: -4px;
        width: 30px;
        height: 2px;
      }
    }
  }
}
</style>
