<template>
  <div class="app-container home">
    <!-- 推荐产品 -->
    <el-divider content-position="center" class="section-divider" v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')">
      <span class="divider-text">为您推荐</span>
    </el-divider>
    <div v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')">
      <div v-if="recommendLoading" class="loading-container">
        <el-skeleton :rows="3" animated />
      </div>
      <div v-else-if="recommendedProducts.length === 0" class="empty-container">
        <i class="el-icon-shopping-bag-1" style="font-size: 48px; color: #909399;"></i>
        <p>暂无推荐产品，快去购买更多商品吧！</p>
      </div>
      <div v-else>
        <p class="recommend-tip">根据您的购买历史，我们为您推荐以下产品：</p>
        <el-row :gutter="20">
          <el-col :xs="24" :sm="12" :md="8" v-for="(product, index) in recommendedProducts" :key="index" class="product-col">
            <el-card shadow="hover" class="product-card">
              <div class="product-img">
                <el-image :src="product.imageUrl" fit="cover"></el-image>
              </div>
              <div class="product-info">
                <h3 class="product-name">{{ product.name }}</h3>
                <p class="product-category">{{ product.category }}</p>
                <p class="product-description">{{ product.description }}</p>
                <p class="product-price">¥{{ product.price }}</p>
                <el-button type="primary" size="small" @click="handleAddToCart(product)">加入购物车</el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </div>
    
    <!-- 产品类别销售分析 -->
    <el-divider content-position="center" class="section-divider" v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')">
      <span class="divider-text">产品类别销售分析</span>
    </el-divider>
    <div v-if="!roles.some(role => role === 'admin' || role === 'normal_admin')">
      <category-charts :isAdmin="false" />
    </div>
    
    <!-- 核心功能 -->
    <el-divider content-position="center" class="section-divider">
      <span class="divider-text">快速跳转</span>
    </el-divider>
    <el-row class="features-row" :gutter="30">
      <el-col
        v-for="(feature, index) in filteredFeatures"
        :key="index"
        :xs="24"
        :sm="12"
        :md="8"
        class="feature-col"
        @click.native="goTarget(feature.path)"
      >
        <el-card shadow="never" class="feature-card">
          <div class="function-card-content">
            <div class="icon-wrapper" :style="{ backgroundColor: feature.bgColor }">
              <!-- 动态绑定图标颜色 -->
              <i :class="[feature.icon, 'function-icon']" :style="{ color: feature.iconColor }"></i>
            </div>
            <div class="function-name">{{ feature.name }}</div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getRecommendedProducts } from '@/api/system/recommend';
import { addCart } from '@/api/system/cart';
import CategoryCharts from '@/components/CategoryCharts';

export default {
  name: "Index",
  components: {
    CategoryCharts
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
          feature.name === '数据看板'
        );
      }

      // 普通用户只显示这些功能
      return allFeatures.filter(feature =>
        feature.name === '电子产品浏览' ||
        feature.name === '购物车' ||
        feature.name === '我的订单' ||
        feature.name === '数据看板'
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
      { bgColor: '#f9f0ff', iconColor: '#722ed1' }
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
      ],
      // 推荐产品数据
      recommendedProducts: [],
      recommendLoading: true
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
          this.recommendedProducts = response.data || [];
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
    }
  }
};
</script>

<style scoped lang="scss">
// --- SCSS 变量定义 ---
$primary-color: #4ea3f4; // 主色调
$text-color-primary: #303133; // 主要文字颜色
$text-color-secondary: #5f6368; // 次要文字颜色
$text-color-light: #909399; // 浅色文字
$bg-color-page: #f8f9fc; // 页面背景色
$bg-color-card: #ffffff; // 卡片背景色
$border-color: #ebeef5; // 边框颜色
$border-radius: 10px; // 圆角大小
$shadow-light: 0 6px 18px rgba(100, 115, 143, 0.08); // 轻微阴影
$shadow-hover: 0 8px 25px rgba(100, 115, 143, 0.12); // 悬停时阴影
$transition-common: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); // 通用过渡效果

// --- 混合器定义 ---
@mixin flex-center($direction: column) {
  display: flex;
  flex-direction: $direction;
  align-items: center;
  justify-content: center;
}

// --- 基础样式 ---
.app-container.home {
  padding: 30px;
  background-color: $bg-color-page;
  min-height: calc(100vh - 84px); // 根据头部高度调整
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.03); // 添加轻微阴影提升立体感
}

// --- 顶部展示区域样式 ---
.hero-row {
  background: linear-gradient(135deg, $primary-color, darken($primary-color, 15%)); // 添加渐变背景
  border-radius: $border-radius;
  color: #fff;
  margin-bottom: 40px;
  box-shadow: $shadow-light;
  overflow: hidden;
  position: relative; // 为可能的装饰元素做准备

  .hero-content {
    text-align: center;
    padding: 65px 30px; // 增加一点垂直内边距

    .home-title {
      font-size: 36px; // 增大标题字号
      font-weight: 600;
      margin-bottom: 15px;
      letter-spacing: 0.5px;
      text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
    }
    .home-description {
      font-size: 18px;
      color: rgba(255, 255, 255, 0.9);
      margin-bottom: 25px;
      font-weight: 400;
      max-width: 700px; // 限制宽度提高可读性
      margin-left: auto;
      margin-right: auto;
    }
    .hero-divider {
      border: none;
      border-top: 2px solid rgba(255, 255, 255, 0.4);
      width: 60px;
      margin: 0 auto;
    }
  }
}

// --- 系统简介部分样式 ---
.intro-row {
  margin-bottom: 45px; // 增加一点底部间距

  .intro-box {
    background-color: $bg-color-card;
    border-radius: $border-radius;
    box-shadow: $shadow-light;
    padding: 40px 45px; // 增加内边距
    border-top: 3px solid $primary-color; // 添加顶部边框增强视觉效果

    .section-title {
      font-size: 24px;
      font-weight: 600;
      color: $text-color-primary;
      margin-bottom: 25px; // 增加标题与内容的间距
      text-align: center;
      position: relative; // 为装饰元素做准备

      &:after { // 添加下划线装饰
        content: '';
        display: block;
        width: 40px;
        height: 3px;
        background-color: $primary-color;
        margin: 12px auto 0;
        border-radius: 2px;
      }
    }
    .system-description {
      font-size: 16px;
      line-height: 1.8;
      color: $text-color-secondary;
      text-align: justify;
      hyphens: auto;
      margin: 0 auto;
      max-width: 800px;
      letter-spacing: 0.3px; // 增加字间距提高可读性
    }
  }
}

// --- 分隔线样式 ---
.section-divider {
  margin: 50px 0; // 增加分隔线与上下内容的间距
  .divider-text {
    font-size: 22px; // 增大字号
    font-weight: 500;
    color: $text-color-primary; // 使用主要文字颜色增强对比度
    padding: 0 20px; // 增加左右内边距
    background-color: $bg-color-page; // 确保文本背景与页面背景匹配
  }
  // 使用深度选择器修改Element UI内部元素
  ::v-deep .el-divider__line {
    border-color: lighten($primary-color, 30%); // 使用主色调的浅色版本作为分隔线颜色
    border-width: 1px; // 调整分隔线宽度
  }
}

// --- 功能卡片区域样式 ---
.features-row {
  // 间距通过模板中的 :gutter="30" 应用
}
.feature-col {
  margin-bottom: 35px; // 增加列间距
}
.feature-card {
  background-color: $bg-color-card;
  border-radius: $border-radius;
  border: 1px solid $border-color; // 细微边框
  box-shadow: none; // 初始无阴影
  transition: $transition-common;
  cursor: pointer;
  height: 200px; // 增加卡片高度
  overflow: hidden; // 防止内容溢出
  @include flex-center(); // 使用混合器居中内容

  &:hover {
    transform: translateY(-8px); // 增强悬停时的上浮效果
    box-shadow: $shadow-hover; // 悬停时添加阴影
    border-color: lighten($primary-color, 15%); // 悬停时边框颜色变化

    // 添加悬停时的背景色变化
    background-color: rgba(lighten($primary-color, 38%), 0.3);
  }

  // 使用深度选择器修改卡片内部样式
  ::v-deep .el-card__body {
    padding: 25px; // 增加内边距
    width: 100%;
    height: 100%;
    @include flex-center(); // 同样在卡片体内居中内容
  }
}

// --- 推荐产品区域样式 ---
.recommend-tip {
  margin-bottom: 20px;
  font-size: 16px;
  color: $text-color-secondary;
  text-align: center;
}

.product-col {
  margin-bottom: 25px;
}

.product-card {
  height: 100%;
  transition: $transition-common;
  border-radius: $border-radius;
  overflow: hidden;
  
  &:hover {
    transform: translateY(-5px);
    box-shadow: $shadow-hover;
  }
}

.product-img {
  height: 180px;
  overflow: hidden;
  
  .el-image {
    width: 100%;
    height: 100%;
  }
}

.product-info {
  padding: 15px;
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
  color: $text-color-light;
  font-size: 14px;
  margin: 5px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2; /* 限制显示两行 */
  -webkit-box-orient: vertical;
  line-height: 1.4;
}

.product-price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: bold;
  margin: 10px 0;
}

.loading-container,
.empty-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 0;
  
  .el-icon-shopping-bag-1 {
    margin-bottom: 15px;
  }
}

.empty-container p {
  margin-top: 15px;
  color: $text-color-light;
  font-size: 16px;
}

// 功能卡片内部内容样式
.function-card-content {
  text-align: center; // 文本居中

  .icon-wrapper {
    width: 75px; // 增大图标背景尺寸
    height: 75px;
    border-radius: 50%; // 圆形背景
    margin: 0 auto 25px auto; // 水平居中并增加底部间距
    @include flex-center(); // 使用混合器居中图标
    transition: $transition-common;
    position: relative; // 为可能添加的伪元素做准备
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05); // 添加轻微阴影增强立体感
    // 背景色通过 :style 动态设置

    .function-icon {
      font-size: 34px; // 增大图标尺寸
      transition: transform 0.3s ease;
      // 图标颜色通过 :style 动态设置
    }
  }

  .function-name {
    font-size: 17px; // 增大字号
    font-weight: 500;
    color: $text-color-primary;
    transition: color $transition-common;
    letter-spacing: 0.5px; // 增加字间距
    margin-top: 5px; // 增加与图标的间距
  }

  // 卡片悬停时内容的特定效果
  .feature-card:hover & {
    .icon-wrapper {
      transform: scale(1.05); // 悬停时图标背景轻微放大
      box-shadow: 0 6px 15px rgba(0, 0, 0, 0.08); // 增强阴影
    }
    .function-icon {
      transform: scale(1.15); // 悬停时图标放大
    }
    .function-name {
      color: $primary-color; // 悬停时文本颜色变为主色调
      font-weight: 600; // 悬停时加粗文本
    }
  }
}

// --- 响应式布局调整 ---
@media (max-width: 768px) {
  .app-container.home {
    padding: 20px; // 在小屏幕上减少内边距
  }
  .hero-content {
    padding: 45px 20px;
    .home-title { font-size: 28px; }
    .home-description {
      font-size: 16px;
      max-width: 100%; // 确保在小屏幕上不会溢出
    }
  }
  .intro-box {
    padding: 30px 20px;
    .section-title {
      font-size: 22px;
      &:after {
        margin-top: 10px; // 调整装饰线位置
      }
    }
    .system-description { font-size: 15px; }
  }
  .feature-card {
    height: 180px; // 调整小屏幕上的卡片高度
  }
  .icon-wrapper {
    width: 65px;
    height: 65px;
    margin-bottom: 15px; // 调整间距
    .function-icon { font-size: 30px; } // 调整图标大小
  }
  .function-name {
    font-size: 15px; // 调整字体大小
  }
  .section-divider {
    margin: 35px 0; // 减少分隔线间距
    .divider-text {
      font-size: 20px; // 减小分隔线文本大小
    }
  }
}

// 添加更小屏幕的响应式调整
@media (max-width: 480px) {
  .hero-content {
    padding: 40px 15px;
    .home-title { font-size: 26px; }
    .home-description { font-size: 15px; }
  }
  .intro-box {
    padding: 25px 15px;
  }
  .feature-card {
    height: 160px; // 进一步调整超小屏幕的卡片高度
  }
  .icon-wrapper {
    width: 60px;
    height: 60px;
    margin-bottom: 12px;
  }
}
</style>
