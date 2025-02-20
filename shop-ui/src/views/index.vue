<template>
  <div class="app-container home">
    <!-- 欢迎区域 -->
    <el-row :gutter="20" class="header-row">
      <el-col :span="24">
        <h2 class="home-title">欢迎进入电子产品销售系统</h2>
        <p class="home-description">专业高效的电子产品全流程管理平台</p>
        <hr />
      </el-col>
    </el-row>

    <!-- 系统简介 -->
    <el-row :gutter="20" class="intro-row">
      <el-col :span="24">
        <h2 class="section-title">系统简介</h2>
        <p class="system-description">
          电子产品销售系统是一套集电子产品管理、订单管理、购物车管理、电子产品浏览、数据分析于一体的综合性产品销售系统。系统采用先进的前后端分离架构，提供从商品上架到售后服务全流程数字化管理。通过智能化的数据分析和实时的库存监控，助力企业提升运营效率，优化客户体验。
        </p>
      </el-col>
    </el-row>

    <!-- 核心功能 -->
    <el-divider />
    <el-row class="features-row">
      <el-col :span="24">
        <el-card class="core-features">
          <template #header>
            <span>核心功能</span>
          </template>
          <el-row :gutter="20">
            <el-col
              v-for="(feature, index) in coreFeatures"
              :key="index"
              :xs="24"
              :sm="12"
              :md="8"
            >
              <el-card shadow="hover">
                <div class="function-card">
                  <i :class="[feature.icon, 'function-icon']"></i>
                  <div class="function-name">{{ feature.name }}</div>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
      version: "1.0.0",
      coreFeatures: [
        { icon: "el-icon-s-goods", name: "电子产品管理" },
        { icon: "el-icon-shopping-cart-full", name: "购物车管理" },
        { icon: "el-icon-s-order", name: "订单管理" },
        { icon: "el-icon-view", name: "电子产品浏览" },
        { icon: "el-icon-data-analysis", name: "数据分析" },
        { icon: "el-icon-document", name: "我的订单" }
      ]
    };
  },
  methods: {
    goTarget(href) {
      // 使用 Vue Router 进行路由跳转
      this.$router.push(href);
    }
  }
};
</script>

<style scoped lang="scss">
.home {
  padding: 20px;

  .header-row {
    text-align: center;
    margin-bottom: 30px;
  }

  .home-title {
    font-size: 32px;
    font-weight: bold;
    margin-bottom: 10px;
  }

  .home-description {
    font-size: 16px;
    color: #606266;
    margin-bottom: 20px;
  }

  hr {
    border: none;
    border-top: 1px solid #ebeef5;
    width: 80%;
    margin: 0 auto;
  }

  .intro-row {
    margin-bottom: 30px;
    .section-title {
      font-size: 24px;
      margin-bottom: 15px;
      text-align: center;
    }
    .system-description {
      font-size: 16px;
      line-height: 1.6;
      text-align: justify;
      margin: 0 auto;
      max-width: 800px;
    }
  }

  .features-row {
    margin-top: 30px;
  }

  .core-features {
    .el-card__header {
      background-color: #f5f7fa;
      font-size: 20px;
      font-weight: bold;
      text-align: center;
    }
  }

  .function-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 150px;
    padding: 20px;
    text-align: center;

    .function-icon {
      font-size: 48px;
      color: #409EFF;
      margin-bottom: 10px;
    }

    .function-name {
      font-size: 18px;
      font-weight: bold;
      color: #303133;
    }
  }
}
</style>
