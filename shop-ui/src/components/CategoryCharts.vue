<template>
  <div class="category-charts-container">
    <el-row :gutter="20">
      <el-col :span="24">
        <h3 class="charts-title">{{ isAdmin ? '电子产品类别销售分析' : '产品销售数据分析' }}</h3>
      </el-col>
    </el-row>
    
    <!-- 管理员可见的详细销售分析 -->
    <div v-if="isAdmin">
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="12" :lg="8">
          <div class="chart-box">
            <div class="chart-container" ref="phoneChart"></div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="12" :lg="8">
          <div class="chart-box">
            <div class="chart-container" ref="computerChart"></div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="12" :lg="8">
          <div class="chart-box">
            <div class="chart-container" ref="tabletChart"></div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="12" :lg="12">
          <div class="chart-box">
            <div class="chart-container" ref="headphoneChart"></div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="12" :lg="12">
          <div class="chart-box">
            <div class="chart-container" ref="otherChart"></div>
          </div>
        </el-col>
      </el-row>
    </div>
    
    <!-- 普通用户可见的数据分析 -->
    <div v-else>
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="12" :lg="12">
          <div class="chart-box">
            <div class="chart-container" ref="userCategoryChart"></div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="12" :md="12" :lg="12">
          <div class="chart-box">
            <div class="chart-container" ref="hotProductsChart"></div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { getCategorySales, getUserCategorySales, getHotProducts } from '@/api/system/dashboard'

export default {
  name: 'CategoryCharts',
  props: {
    isAdmin: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      // 管理员图表实例
      phoneChart: null,
      computerChart: null,
      tabletChart: null,
      headphoneChart: null,
      otherChart: null,
      
      // 普通用户图表实例
      userCategoryChart: null,
      hotProductsChart: null,
      
      loading: true,
      categoryData: null,
      userData: null
    }
  },
  mounted() {
    this.initCharts()
    if (this.isAdmin) {
      this.fetchCategoryData()
    } else {
      this.fetchUserData()
    }
  },
  methods: {
    initCharts() {
      if (this.isAdmin) {
        // 初始化管理员图表
        this.phoneChart = echarts.init(this.$refs.phoneChart)
        this.computerChart = echarts.init(this.$refs.computerChart)
        this.tabletChart = echarts.init(this.$refs.tabletChart)
        this.headphoneChart = echarts.init(this.$refs.headphoneChart)
        this.otherChart = echarts.init(this.$refs.otherChart)
        
        // 设置加载动画 - 管理员图表
        const loadingOption = {
          text: '加载中...',
          color: '#4ea3f4',
          textColor: '#000',
          maskColor: 'rgba(255, 255, 255, 0.8)'
        }
        
        this.phoneChart.showLoading(loadingOption)
        this.computerChart.showLoading(loadingOption)
        this.tabletChart.showLoading(loadingOption)
        this.headphoneChart.showLoading(loadingOption)
        this.otherChart.showLoading(loadingOption)
      } else {
        // 初始化普通用户图表
        this.userCategoryChart = echarts.init(this.$refs.userCategoryChart)
        this.hotProductsChart = echarts.init(this.$refs.hotProductsChart)
        
        // 设置加载动画 - 普通用户图表
        const loadingOption = {
          text: '加载中...',
          color: '#4ea3f4',
          textColor: '#000',
          maskColor: 'rgba(255, 255, 255, 0.8)'
        }
        
        this.userCategoryChart.showLoading(loadingOption)
        this.hotProductsChart.showLoading(loadingOption)
      }
    },
    
    // 管理员数据获取方法
    async fetchCategoryData() {
      try {
        const response = await getCategorySales()
        this.categoryData = response.data
        this.renderAdminCharts()
      } catch (error) {
        console.error('获取产品类别销售数据失败:', error)
        this.$message.error('获取产品类别销售数据失败')
        
        // 隐藏加载动画
        if (this.phoneChart) this.phoneChart.hideLoading()
        if (this.computerChart) this.computerChart.hideLoading()
        if (this.tabletChart) this.tabletChart.hideLoading()
        if (this.headphoneChart) this.headphoneChart.hideLoading()
        if (this.otherChart) this.otherChart.hideLoading()
      }
    },
    
    // 普通用户数据获取方法
    async fetchUserData() {
      try {
        // 并行请求多个数据源
        const [userCategoryRes, hotProductsRes] = await Promise.all([
          getUserCategorySales(),
          getHotProducts()
        ])
        
        this.userData = {
          userCategoryData: userCategoryRes.data,
          hotProductsData: hotProductsRes.data
        }
        
        this.renderUserCharts()
      } catch (error) {
        console.error('获取用户数据分析失败:', error)
        this.$message.error('获取数据分析失败')
        
        // 隐藏用户图表加载动画
        if (this.userCategoryChart) this.userCategoryChart.hideLoading()
        if (this.hotProductsChart) this.hotProductsChart.hideLoading()
      }
    },
    
    // 渲染管理员图表方法
    renderAdminCharts() {
      if (!this.categoryData) return
      
      this.renderPhoneChart()
      this.renderComputerChart()
      this.renderTabletChart()
      this.renderHeadphoneChart()
      this.renderOtherChart()
    },
    
    // 渲染普通用户图表方法
    renderUserCharts() {
      if (!this.userData) return
      
      this.renderUserCategoryChart()
      this.renderHotProductsChart()
    },
    
    // --- 管理员图表渲染方法 ---
    
    // 手机类别饼图
    renderPhoneChart() {
      const { phoneData } = this.categoryData
      
      const option = {
        title: {
          text: '手机销售分布',
          left: 'center',
          top: 10
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: phoneData.map(item => item.name)
        },
        series: [{
          name: '销售数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{c}台 ({d}%)'
          },
          data: phoneData
        }]
      }
      
      this.phoneChart.hideLoading()
      this.phoneChart.setOption(option)
    },
    
    // 电脑类别饼图
    renderComputerChart() {
      const { computerData } = this.categoryData
      
      const option = {
        title: {
          text: '电脑销售分布',
          left: 'center',
          top: 10
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: computerData.map(item => item.name)
        },
        series: [{
          name: '销售数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{c}台 ({d}%)'
          },
          data: computerData
        }]
      }
      
      this.computerChart.hideLoading()
      this.computerChart.setOption(option)
    },
    
    // 平板类别饼图
    renderTabletChart() {
      const { tabletData } = this.categoryData
      
      const option = {
        title: {
          text: '平板销售分布',
          left: 'center',
          top: 10
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: tabletData.map(item => item.name)
        },
        series: [{
          name: '销售数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{c}台 ({d}%)'
          },
          data: tabletData
        }]
      }
      
      this.tabletChart.hideLoading()
      this.tabletChart.setOption(option)
    },
    
    // 耳机类别饼图
    renderHeadphoneChart() {
      const { headphoneData } = this.categoryData
      
      const option = {
        title: {
          text: '耳机销售分布',
          left: 'center',
          top: 10
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: headphoneData.map(item => item.name)
        },
        series: [{
          name: '销售数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{c}个 ({d}%)'
          },
          data: headphoneData
        }]
      }
      
      this.headphoneChart.hideLoading()
      this.headphoneChart.setOption(option)
    },
    
    // 其他类别饼图
    renderOtherChart() {
      const { otherData } = this.categoryData
      
      const option = {
        title: {
          text: '其他产品销售分布',
          left: 'center',
          top: 10
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: otherData.map(item => item.name)
        },
        series: [{
          name: '销售数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{c}个 ({d}%)'
          },
          data: otherData
        }]
      }
      
      this.otherChart.hideLoading()
      this.otherChart.setOption(option)
    },
    
    // --- 普通用户图表渲染方法 ---
    
    // 用户个人购买类别饼图
    renderUserCategoryChart() {
      const { categoryData } = this.userData.userCategoryData
      
      const option = {
        title: {
          text: '我的购买类别分布',
          left: 'center',
          top: 10,
          textStyle: {
            fontSize: 16
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c}件 ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 10,
          top: 'center',
          data: categoryData.map(item => item.name)
        },
        series: [{
          name: '购买数量',
          type: 'pie',
          radius: ['30%', '60%'],
          center: ['60%', '55%'],
          avoidLabelOverlap: true,
          itemStyle: {
            borderRadius: 4
          },
          label: {
            formatter: '{b}\n{d}%'
          },
          data: categoryData
        }]
      }
      
      this.userCategoryChart.hideLoading()
      this.userCategoryChart.setOption(option)
    },
    
    // 热门产品排行图表
    renderHotProductsChart() {
      const { products } = this.userData.hotProductsData
      const topProducts = products.slice(0, 5) // 只显示前5个热门产品
      
      const option = {
        title: {
          text: '热门产品排行',
          left: 'center',
          top: 10,
          textStyle: {
            fontSize: 16
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'value',
          axisLabel: {
            formatter: '{value}件'
          }
        },
        yAxis: {
          type: 'category',
          data: topProducts.map(item => item.name),
          axisTick: {
            alignWithLabel: true
          }
        },
        series: [{
          name: '销售量',
          type: 'bar',
          barWidth: '60%',
          data: topProducts.map(item => item.sales),
          itemStyle: {
            color: function(params) {
              // 为不同排名设置不同的颜色
              const colorList = ['#f56c6c', '#f89e9e', '#fac5c5', '#fbd7d7', '#fce9e9'];
              return colorList[params.dataIndex];
            }
          },
          label: {
            show: true,
            position: 'right',
            formatter: '{c}件'
          }
        }]
      }
      
      this.hotProductsChart.hideLoading()
      this.hotProductsChart.setOption(option)
    }
  },
  beforeDestroy() {
    // 销毁图表实例
    if (this.isAdmin) {
      // 销毁管理员图表实例
      if (this.phoneChart) this.phoneChart.dispose()
      if (this.computerChart) this.computerChart.dispose()
      if (this.tabletChart) this.tabletChart.dispose()
      if (this.headphoneChart) this.headphoneChart.dispose()
      if (this.otherChart) this.otherChart.dispose()
    } else {
      // 销毁普通用户图表实例
      if (this.userCategoryChart) this.userCategoryChart.dispose()
      if (this.hotProductsChart) this.hotProductsChart.dispose()
    }
    
    window.removeEventListener('resize', this.resizeHandler)
  },
  activated() {
    // 自适应大小
    window.addEventListener('resize', this.resizeHandler)
  },
  deactivated() {
    window.removeEventListener('resize', this.resizeHandler)
  },
  // 窗口大小改变时，重新调整图表大小
  resizeHandler() {
    if (this.isAdmin) {
      // 重置管理员图表大小
      if (this.phoneChart) this.phoneChart.resize()
      if (this.computerChart) this.computerChart.resize() 
      if (this.tabletChart) this.tabletChart.resize()
      if (this.headphoneChart) this.headphoneChart.resize()
      if (this.otherChart) this.otherChart.resize()
    } else {
      // 重置普通用户图表大小
      if (this.userCategoryChart) this.userCategoryChart.resize()
      if (this.hotProductsChart) this.hotProductsChart.resize()
    }
  }
}
</script>

<style scoped>
.category-charts-container {
  background-color: #f8f9fc;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 6px 18px rgba(100, 115, 143, 0.08);
}

.charts-title {
  font-size: 22px;
  font-weight: 500;
  color: #303133;
  text-align: center;
  margin-bottom: 20px;
}

.chart-box {
  background-color: #fff;
  border-radius: 10px;
  padding: 15px;
  margin-bottom: 20px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  transition: all 0.3s;
}

.chart-box:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  transform: translateY(-5px);
}

.chart-container {
  height: 300px;
}

@media (max-width: 768px) {
  .chart-container {
    height: 250px;
  }
  
  .chart-box {
    padding: 10px;
  }
}
</style>