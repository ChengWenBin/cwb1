<template>
  <div class="app-container home">
    <!-- 顶部 Hero 区域 -->
    <el-row :gutter="20" class="hero-row">
      <el-col :span="24" class="hero-content">
        <h2 class="home-title">欢迎进入电子产品销售系统</h2>
        <p class="home-description">专业高效的电子产品全流程管理平台</p>
        <hr />
      </el-col>
    </el-row>

    <!-- 系统简介 -->
    <el-row :gutter="20" class="intro-row">
      <el-col :span="24" class="intro-box">
        <h2 class="section-title">系统简介</h2>
        <p class="system-description">
          电子产品销售系统是一套集电子产品管理、订单管理、购物车管理、电子产品浏览、数据分析于一体的综合性电子产品销售系统。
          系统采用先进的前后端分离架构，提供从商品上架到售后服务全流程数字化管理。通过智能化的数据分析和实时的库存监控，助力企业提升运营效率，优化客户体验。
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
              @click.native="goTarget(feature.path)"
              class="feature-col"
            >
              <el-card shadow="hover" class="feature-card">
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
        { icon: "el-icon-s-goods", name: "电子产品管理", path: "/system/product" },
        { icon: "el-icon-shopping-cart-full", name: "购物车", path: "/system/cart" },
        { icon: "el-icon-s-order", name: "订单管理", path: "/system/adminOrder" },
        { icon: "el-icon-view", name: "电子产品浏览", path: "/system/product-browse" },
        { icon: "el-icon-data-analysis", name: "数据看板", path: "/dashboard" },
        { icon: "el-icon-document", name: "我的订单", path: "/system/order" }
      ]
    };
  },
  methods: {
    goTarget(path) {
      if (path) {
        this.$router.push({ path });
      } else {
        console.warn("未配置跳转路径");
      }
    }
  }
};
</script>

<style scoped lang="scss">
.home {
  padding: 20px;

  /* 顶部 Hero 区域，使用渐变背景 + 内边距 */
  .hero-row {
    background: linear-gradient(100deg, #3a8ee6, #8cc6ff);
    border-radius: 8px;
    color: #fff;
    margin-bottom: 30px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

    .hero-content {
      text-align: center;
      padding: 40px 20px;

      .home-title {
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 10px;
      }

      .home-description {
        font-size: 16px;
        margin-bottom: 20px;
      }

      hr {
        border: none;
        border-top: 1px solid rgba(255, 255, 255, 0.3);
        width: 50%;
        margin: 0 auto;
      }
    }
  }

  .intro-row {
    margin-bottom: 30px;

    .intro-box {
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
      padding: 20px 30px;

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
  }

  .features-row {
    margin-top: 30px;
  }

  .core-features {
    border-radius: 8px;
    .el-card__header {
      background-color: #f5f7fa;
      font-size: 20px;
      font-weight: bold;
      text-align: center;
      border-radius: 8px 8px 0 0;
    }
  }

  /* 功能卡片：增加 hover 动画，圆角与阴影 */
  .feature-col {
    margin-bottom: 20px;
    .feature-card {
      border-radius: 8px;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      &:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      }
    }
  }

  .function-card {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 150px;
    text-align: center;

    .function-icon {
      font-size: 48px;
      color: #409eff;
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
