<template>
  <div class="dashboard-container">
    <!-- 统计卡片区域 -->
    <el-row :gutter="20">
      <el-col :xs="24" :sm="8" :md="8" :lg="8">
        <div class="stat-card sales-card" v-loading="salesLoading">
          <div class="stat-icon">
            <i class="el-icon-money"></i>
          </div>
          <div class="stat-content">
            <div class="stat-title">总销售额</div>
            <div class="stat-value">¥ {{ totalSales }}</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8" :md="8" :lg="8">
        <div class="stat-card orders-card" v-loading="orderLoading">
          <div class="stat-icon">
            <i class="el-icon-s-order"></i>
          </div>
          <div class="stat-content">
            <div class="stat-title">订单总数</div>
            <div class="stat-value">{{ totalOrders }}</div>
          </div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="8" :md="8" :lg="8">
        <div class="stat-card products-card" v-loading="salesLoading">
          <div class="stat-icon">
            <i class="el-icon-shopping-cart-full"></i>
          </div>
          <div class="stat-content">
            <div class="stat-title">售出产品数量</div>
            <div class="stat-value">{{ totalProducts }}</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <div class="chart-card">
          <div class="chart-header">
            <h3>销售趋势分析</h3>
          </div>
          <div class="chart-container" ref="salesTrendChart"></div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <div class="chart-card">
          <div class="chart-header">
            <h3>产品销售分布</h3>
          </div>
          <div class="chart-container" ref="productSalesChart"></div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="chart-row">
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <div class="chart-card">
          <div class="chart-header">
            <h3>订单走势分析</h3>
          </div>
          <div class="chart-container" ref="orderTrendChart"></div>
        </div>
      </el-col>
      <el-col :xs="24" :sm="24" :md="12" :lg="12">
        <div class="chart-card">
          <div class="chart-header">
            <h3>订单状态分布</h3>
          </div>
          <div class="chart-container" ref="orderStatusChart"></div>
        </div>
      </el-col>
    </el-row>

    <!-- 数据表格区域 -->
    <el-row :gutter="20" class="report-row">
      <el-col :span="24">
        <div class="table-card">
          <div class="table-header">
            <h3>销售数据报表</h3>
            <div class="table-tools">
              <el-button type="primary" size="small" icon="el-icon-download" @click="exportSalesReport">导出报表</el-button>
              <el-input
                placeholder="搜索产品名称"
                v-model="salesSearchQuery"
                size="small"
                style="width: 200px; margin-left: 10px;"
                clearable
                @clear="handleSalesSearchClear"
                @input="handleSalesSearchInput"
              >
                <i slot="prefix" class="el-input__icon el-icon-search"></i>
              </el-input>
            </div>
          </div>
          <el-table 
            v-if="!salesLoading" 
            :data="paginatedSalesData" 
            border 
            stripe
            style="width: 100%"
            :header-cell-style="{background:'#f5f7fa',color:'#606266'}"
            :row-class-name="tableRowClassName"
            highlight-current-row
          >
            <el-table-column prop="name" label="产品名称" min-width="150"></el-table-column>
            <el-table-column prop="quantity" label="销售数量" width="120">
              <template slot-scope="scope">
                <el-progress 
                  :percentage="getQuantityPercentage(scope.row.quantity)" 
                  :color="getProgressColor(scope.row.quantity, 'quantity')"
                  :show-text="false"
                  :stroke-width="12"
                  class="sale-progress"
                ></el-progress>
                <span>{{ scope.row.quantity }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="amount" label="产品销售总额" width="150">
              <template slot-scope="scope">
                <span style="font-weight:bold">¥ {{ scope.row.amount }}</span>
              </template>
            </el-table-column>
          </el-table>
          <div v-else
               class="loading-container"
               v-loading="salesLoading"
               element-loading-text="正在加载数据..."
               element-loading-spinner="el-icon-loading"
          >
            <!-- 加载指示器将覆盖此容器 -->
          </div>
          <el-pagination
            v-if="!salesLoading && filteredSalesData.length > 0"
            @size-change="handleSalesSizeChange"
            @current-change="handleSalesCurrentChange"
            :current-page="salesPagination.currentPage"
            :page-sizes="[5, 10, 20, 50]"
            :page-size="salesPagination.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="filteredSalesData.length"
            background
            class="pagination-container">
          </el-pagination>
          <div v-if="!salesLoading && filteredSalesData.length === 0" class="empty-data">
            <i class="el-icon-document"></i>
            <p>暂无数据</p>
          </div>
        </div>

        <div class="table-card">
          <div class="table-header">
            <h3>订单数据报表</h3>
            <div class="table-tools">
              <el-button type="primary" size="small" icon="el-icon-download" @click="exportOrderReport">导出报表</el-button>
              <el-input
                placeholder="搜索订单编号"
                v-model="orderSearchQuery"
                size="small"
                style="width: 180px; margin-left: 10px;"
                clearable
                @clear="handleOrderSearchClear"
                @input="handleOrderSearchInput"
              >
                <i slot="prefix" class="el-input__icon el-icon-search"></i>
              </el-input>
              <el-input
                placeholder="搜索下单用户"
                v-model="userSearchQuery"
                size="small"
                style="width: 180px; margin-left: 10px;"
                clearable
                @clear="handleUserSearchClear"
                @input="handleUserSearchInput"
              >
                <i slot="prefix" class="el-input__icon el-icon-user"></i>
              </el-input>
            </div>
          </div>
          <el-table 
            v-if="!orderLoading" 
            :data="paginatedOrderData" 
            border 
            stripe
            style="width: 100%"
            :header-cell-style="{background:'#f5f7fa',color:'#606266'}"
            :row-class-name="tableRowClassName"
            highlight-current-row
          >
            <el-table-column prop="create_time" label="下单日期" width="160"></el-table-column>
            <el-table-column prop="user_id" label="下单用户" width="120"></el-table-column>
            <el-table-column prop="order_no" label="订单编号" width="180"></el-table-column>
            <el-table-column prop="order_status" label="订单状态" width="120">
              <template slot-scope="scope">
                <el-tag 
                  :type="getOrderStatusTagType(scope.row.order_status)" 
                  size="medium"
                  effect="dark"
                >
                  {{ scope.row.order_status }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="total_amount" label="总价" width="120">
              <template slot-scope="scope">
                <span style="font-weight:bold">¥ {{ scope.row.total_amount }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="address" label="收货地址" min-width="200"></el-table-column>
          </el-table>
          <div v-else
               class="loading-container"
               v-loading="orderLoading"
               element-loading-text="正在加载数据..."
               element-loading-spinner="el-icon-loading"
          >
            <!-- 加载指示器将覆盖此容器 -->
          </div>
          <el-pagination
            v-if="!orderLoading && filteredOrderData.length > 0"
            @size-change="handleOrderSizeChange"
            @current-change="handleOrderCurrentChange"
            :current-page="orderPagination.currentPage"
            :page-sizes="[5, 10, 20, 50]"
            :page-size="orderPagination.pageSize"
            layout="total, sizes, prev, pager, next, jumper"
            :total="filteredOrderData.length"
            background
            class="pagination-container">
          </el-pagination>
          <div v-if="!orderLoading && filteredOrderData.length === 0" class="empty-data">
            <i class="el-icon-document"></i>
            <p>暂无数据</p>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import * as echarts from 'echarts'
import { getSalesTrend, getProductSales, getOrderTrend, getOrderStatus, getSalesReport, getOrderReport } from '@/api/system/dashboard'
import * as XLSX from 'xlsx'
import { saveAs } from 'file-saver'

export default {
  data() {
    return {
      salesTrendChart: null,
      productSalesChart: null,
      orderTrendChart: null,
      orderStatusChart: null,
      salesLoading: false,
      orderLoading: false,
      salesReportData: {
        productSales: [] // 只保留 productSales
      },
      orderReportData: [],
      // 分页相关数据
      salesPagination: {
        currentPage: 1,
        pageSize: 10
      },
      orderPagination: {
        currentPage: 1,
        pageSize: 10
      },
      // 搜索相关数据
      salesSearchQuery: '',
      orderSearchQuery: '',
      userSearchQuery: '',
      searchTimeout: null,
      
      // 统计卡片数据
      totalSales: 0,
      totalOrders: 0,
      totalProducts: 0,
      
      // 趋势增长率
      salesGrowthRate: 0,
      ordersGrowthRate: 0,
      productsGrowthRate: 0,
    }
  },
  computed: {
    // 根据搜索条件过滤的销售数据
    filteredSalesData() {
      if (!this.salesSearchQuery) {
        return this.salesReportData.productSales || [];
      }
      const query = this.salesSearchQuery.toLowerCase();
      return (this.salesReportData.productSales || []).filter(item => 
        item.name && item.name.toLowerCase().includes(query)
      );
    },
    // 分页后的销售数据
    paginatedSalesData() {
      const start = (this.salesPagination.currentPage - 1) * this.salesPagination.pageSize;
      const end = start + this.salesPagination.pageSize;
      return this.filteredSalesData.slice(start, end);
    },
    // 根据搜索条件过滤的订单数据
    filteredOrderData() {
      if (!this.orderSearchQuery && !this.userSearchQuery) {
        return this.orderReportData || [];
      }
      
      return (this.orderReportData || []).filter(item => {
        const matchesOrderNo = !this.orderSearchQuery || 
          (item.order_no && item.order_no.toLowerCase().includes(this.orderSearchQuery.toLowerCase()));
        
        const matchesUser = !this.userSearchQuery || 
          (item.user_id && item.user_id.toString().includes(this.userSearchQuery));
        
        return matchesOrderNo && matchesUser;
      });
    },
    // 分页后的订单数据
    paginatedOrderData() {
      const start = (this.orderPagination.currentPage - 1) * this.orderPagination.pageSize;
      const end = start + this.orderPagination.pageSize;
      return this.filteredOrderData.slice(start, end);
    }
  },
  mounted() {
    this.initCharts()
    this.fetchData()
    this.fetchReportData()
    
    // 获取统计卡片数据
    this.fetchStatCardData()
    
    // 响应窗口大小变化，重绘图表
    window.addEventListener('resize', this.resizeCharts)
  },
  beforeDestroy() {
    // 移除事件监听
    window.removeEventListener('resize', this.resizeCharts)
  },
  methods: {
    // 获取统计卡片真实数据
    async fetchStatCardData() {
      try {
        // 在真实后端中，应使用专门的API获取统计数据
        // 这里暂时从已有的API获取数据
        this.salesLoading = true
        
        // 获取销售总额和增长率
        const salesSummary = await this.getDashboardSummary('sales')
        this.totalSales = salesSummary.total || 0
        this.salesGrowthRate = salesSummary.growthRate || 0
        
        // 获取订单总数和增长率
        const orderSummary = await this.getDashboardSummary('orders')
        this.totalOrders = orderSummary.total || 0
        this.ordersGrowthRate = orderSummary.growthRate || 0
        
        // 获取产品总数和增长率
        const productSummary = await this.getDashboardSummary('products')
        this.totalProducts = productSummary.total || 0
        this.productsGrowthRate = productSummary.growthRate || 0
        
        this.salesLoading = false
      } catch (error) {
        console.error('Error fetching stat card data:', error)
        this.salesLoading = false
        
        // 如API无法获取，使用现有数据
        this.initStatCardsWithDummyData()
      }
    },
    
    // 模拟获取仪表盘摘要数据的API调用
    async getDashboardSummary(type) {
      // 此方法应替换为真实API调用
      // 在真实实现中，应该有专门的后端API来获取这些统计数据
      
      try {
        // 基于销售数据和订单数据计算一些统计值
        if (type === 'sales') {
          // 从销售报表计算销售总额
          const salesReport = await getSalesReport()
          let total = 0
          
          if (salesReport && salesReport.data && salesReport.data.productSales) {
            total = salesReport.data.productSales.reduce((sum, item) => sum + (item.amount || 0), 0)
          }
          
          // 生成增长率，实际项目中应从API获取
          const growthRate = 12.5
          
          return { total, growthRate }
        }
        
        if (type === 'orders') {
          // 从订单报表计算订单总数
          const orderReport = await getOrderReport()
          const total = orderReport?.data?.length || 0
          
          // 生成增长率，实际项目中应从API获取
          const growthRate = 8.7
          
          return { total, growthRate }
        }
        
        if (type === 'products') {
          // 计算售出产品总数量，从销售报表中获取
          const salesReport = await getSalesReport()
          let total = 0
          
          if (salesReport && salesReport.data && salesReport.data.productSales) {
            // 计算所有产品销售数量总和
            total = salesReport.data.productSales.reduce((sum, item) => sum + (item.quantity || 0), 0)
          }
          
          // 生成增长率，实际项目中应从API获取
          const growthRate = 5.2
          
          return { total, growthRate }
        }
        
        return { total: 0, growthRate: 0 }
      } catch (error) {
        console.error(`Error getting dashboard summary for ${type}:`, error)
        return { total: 0, growthRate: 0 }
      }
    },
    
    // 使用模拟数据初始化统计卡片（后备方案）
    initStatCardsWithDummyData() {
      this.totalSales = 127886
      this.salesGrowthRate = 12.5
      
      this.totalOrders = 14
      this.ordersGrowthRate = 8.7
      
      this.totalProducts = 6
      this.productsGrowthRate = 5.2
    },
    
    // 初始化统计卡片数据（保留作为后备方案）
    initStatCards() {
      // 使用真实数据替代
      this.fetchStatCardData()
    },
    
    async fetchData() {
      try {
        // 获取各种图表数据
        const salesTrendRes = await getSalesTrend()
        const productSalesRes = await getProductSales()
        const orderTrendRes = await getOrderTrend()
        const orderStatusRes = await getOrderStatus()
        
        // 直接渲染销售趋势图，保留美观的蓝色样式
        this.renderSalesTrendChart(salesTrendRes.data)
        this.renderProductSalesChart(productSalesRes.data)
        this.renderOrderTrendChart(orderTrendRes.data)
        this.renderOrderStatusChart(orderStatusRes.data)
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    },

    async fetchReportData() {
      try {
        this.salesLoading = true;
        const salesReportRes = await getSalesReport();

        // 对 productSales 数组进行排序 (倒序)
        this.salesReportData.productSales = salesReportRes.data.productSales.sort((a, b) => {
          return b.amount - a.amount; // 从大到小排序
        });

        this.salesLoading = false;

        this.orderLoading = true;
        const orderReportRes = await getOrderReport();
        this.orderReportData = orderReportRes.data;
        this.orderLoading = false;
      } catch (error) {
        this.salesLoading = false;
        this.orderLoading = false;
        console.error('Error fetching report data:', error);
      }
    },

    renderSalesTrendChart(data) {
      // 确保图表对象存在
      if (!this.salesTrendChart) {
        this.salesTrendChart = echarts.init(this.$refs.salesTrendChart)
      }
      
      const dates = data.map(item => item.date)
      const sales = data.map(item => item.sales)

      const option = {
        title: {
          text: '销售趋势',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          formatter: '{b}<br />{a}: ¥{c}'
        },
        xAxis: {
          type: 'category',
          data: dates,
          axisLabel: {
            rotate: dates.length > 7 ? 45 : 0 // 日期较多时旋转标签
          }
        },
        yAxis: {
          type: 'value',
          name: '销售额（元）',
          axisLabel: {
            formatter: '¥{value}'
          }
        },
        series: [{
          name: '销售额',
          data: sales,
          type: 'line',
          smooth: true, // 平滑曲线
          symbol: 'circle', // 数据点样式
          symbolSize: 6,
          itemStyle: {
            color: '#409EFF'
          },
          lineStyle: {
            width: 3
          },
          areaStyle: {
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [{
                offset: 0, color: 'rgba(64, 158, 255, 0.3)' // 渐变起点
              }, {
                offset: 1, color: 'rgba(64, 158, 255, 0.1)' // 渐变终点
              }]
            }
          }
        }],
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        }
      }
      this.salesTrendChart.setOption(option)
    },

    renderProductSalesChart(data) {
      const categories = data.map(item => item.category);
      const sales = data.map(item => item.sales);

      const option = {
        title: {
          text: '产品类型销售分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical', // 垂直排列
          left: 'left',       // 左侧
          top: 'center',      // 垂直居中
          data: categories
        },
        series: [{
          name: '销售额',
          type: 'pie',
          radius: '50%',
          center: ['60%', '55%'],  // 调整圆心位置，为图例腾出空间
          data: data.map(item => ({ value: item.sales, name: item.category })),
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          label: {
            formatter: '{b}\n{d}%',
            avoidLabelOverlap: true,
          },
          labelLine: {
            length: 10,
            length2: 5
          }
        }]
      };

      this.productSalesChart.setOption(option)
    },
    
    renderOrderTrendChart(data) {
      const dates = data.map(item => item.date);
      const orderCounts = data.map(item => item.orderCount);

      const option = {
        title: {
          text: '订单数量趋势',
          left: 'center'
        },
        tooltip: {
          trigger: 'axis',
          formatter: '{b}<br />{a}: {c}'
        },
        xAxis: {
          type: 'category',
          data: dates,
          axisLabel: {
            rotate: dates.length > 7 ? 45 : 0 // 日期较多时旋转标签
          }
        },
        yAxis: {
          type: 'value',
          name: '订单数量',
          minInterval: 1, // 强制最小间隔为1，确保只显示整数
          axisLabel: {
            formatter: function(value) {
              return Math.floor(value); // 确保只显示整数部分
            }
          }
        },
        series: [{
          name: '订单数量',
          data: orderCounts,
          type: 'line',
          smooth: true, // 平滑曲线
          symbol: 'circle', // 数据点样式
          symbolSize: 6,
          itemStyle: {
            color: '#409EFF'
          },
          lineStyle: {
            width: 3
          },
          areaStyle: {
            color: {
              type: 'linear',
              x: 0,
              y: 0,
              x2: 0,
              y2: 1,
              colorStops: [{
                offset: 0, color: 'rgba(64, 158, 255, 0.3)' // 渐变起点
              }, {
                offset: 1, color: 'rgba(64, 158, 255, 0.1)' // 渐变终点
              }]
            }
          }
        }],
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        }
      };
      this.orderTrendChart.setOption(option);
    },

    renderOrderStatusChart(data) {
      const option = {
        title: {
          text: '订单状态分布',
          left: 'center'
        },
        tooltip: {
          trigger: 'item',
          formatter: '{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical', // 垂直排列
          left: 'left',       // 左侧
          top: 'center',      // 垂直居中
          data: data.map(item => item.status)
        },
        series: [{
          name: '订单状态',
          type: 'pie',
          radius: '50%',
          center: ['60%', '55%'], // 调整圆心，为图例腾出更多空间。 注意这里也改了
          data: data.map(item => ({ value: item.count, name: item.status })),
          label: {
            formatter: '{b}\n{d}%',
            avoidLabelOverlap: true,
          },
          labelLine: {
            length: 8,
            length2: 4
          }
        }]
      };
      this.orderStatusChart.setOption(option);
    },

    exportSalesReport() {
      const tHeader = ['产品名称', '销售数量', '产品销售总额'];  // 改回原来的表头
      const filterVal = ['name', 'quantity', 'amount']; // 改回原来的字段
      // 导出所有数据，不只是当前页
      const list = this.filteredSalesData;
      const data = this.formatJson(filterVal, list);
      this.exportExcel(data, tHeader, '销售数据报表.xlsx');
    },

    exportOrderReport() {
      const tHeader = ['下单日期', '下单用户', '订单编号', '订单状态', '总价', '收货地址'];
      const filterVal = ['create_time', 'user_id', 'order_no', 'order_status', 'total_amount', 'address'];
      // 导出所有数据，不只是当前页
      const list = this.filteredOrderData;
      const data = this.formatJson(filterVal, list);
      this.exportExcel(data, tHeader, '订单数据报表.xlsx');
    },

    formatJson(filterVal, jsonData) {
      return jsonData.map(item => {
        return filterVal.map(key => item[key] || '');
      });
    },

    exportExcel(data, header, filename) {
      const ws = XLSX.utils.aoa_to_sheet([header]);
      const jsonData = data;
      XLSX.utils.sheet_add_json(ws, jsonData, { origin: 'A2', skipHeader: true });
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
      const wbout = XLSX.write(wb, { bookType: "xlsx", type: "array" });
      saveAs(new Blob([wbout], { type: "application/octet-stream" }), filename);
    },

    // 表格行样式
    tableRowClassName({row, rowIndex}) {
      if (rowIndex % 2 === 0) {
        return 'even-row'
      }
      return 'odd-row'
    },
    
    // 获取销售量百分比（用于进度条）
    getQuantityPercentage(quantity) {
      // 找出最大值用作百分比计算基准
      const maxQuantity = Math.max(...this.filteredSalesData.map(item => item.quantity))
      if (maxQuantity === 0) return 0
      return Math.round((quantity / maxQuantity) * 100)
    },
    
    // 获取进度条颜色
    getProgressColor(value, type) {
      if (type === 'quantity') {
        if (value > 100) return '#67c23a'
        if (value > 50) return '#409eff'
        return '#e6a23c'
      }
      return '#409eff'
    },

    // 获取订单状态对应的标签类型
    getOrderStatusTagType(status) {
      const statusMap = {
        '待付款': 'info',
        '待发货': 'warning',
        '已发货': 'success',
        '已完成': 'success',
        '已取消': 'danger'
      };
      return statusMap[status] || 'info';
    },

    // 窗口大小变化时重绘图表
    resizeCharts() {
      if (this.salesTrendChart) this.salesTrendChart.resize()
      if (this.productSalesChart) this.productSalesChart.resize()
      if (this.orderTrendChart) this.orderTrendChart.resize()
      if (this.orderStatusChart) this.orderStatusChart.resize()
    },

    // 处理销售数据分页大小改变
    handleSalesSizeChange(val) {
      this.salesPagination.pageSize = val;
      // 确保当前页是有效的
      const maxPage = Math.ceil(this.filteredSalesData.length / val) || 1;
      if (this.salesPagination.currentPage > maxPage) {
        this.salesPagination.currentPage = maxPage;
      }
    },

    // 处理销售数据当前页改变
    handleSalesCurrentChange(val) {
      this.salesPagination.currentPage = val;
    },

    // 处理订单数据分页大小改变
    handleOrderSizeChange(val) {
      this.orderPagination.pageSize = val;
      // 确保当前页是有效的
      const maxPage = Math.ceil(this.filteredOrderData.length / val) || 1;
      if (this.orderPagination.currentPage > maxPage) {
        this.orderPagination.currentPage = maxPage;
      }
    },

    // 处理订单数据当前页改变
    handleOrderCurrentChange(val) {
      this.orderPagination.currentPage = val;
    },

    // 处理销售数据搜索输入
    handleSalesSearchInput() {
      // 重置当前页到第一页
      this.salesPagination.currentPage = 1;
      // 使用防抖处理搜索
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout);
      }
      this.searchTimeout = setTimeout(() => {
        // 搜索逻辑已经在计算属性中处理
      }, 300);
    },

    // 处理销售数据搜索清除
    handleSalesSearchClear() {
      this.salesSearchQuery = '';
      this.salesPagination.currentPage = 1;
    },

    // 处理订单数据搜索输入
    handleOrderSearchInput() {
      // 重置当前页到第一页
      this.orderPagination.currentPage = 1;
      // 使用防抖处理搜索
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout);
      }
      this.searchTimeout = setTimeout(() => {
        // 搜索逻辑已经在计算属性中处理
      }, 300);
    },

    // 处理订单数据搜索清除
    handleOrderSearchClear() {
      this.orderSearchQuery = '';
      this.orderPagination.currentPage = 1;
    },

    // 处理用户搜索输入
    handleUserSearchInput() {
      // 重置当前页到第一页
      this.orderPagination.currentPage = 1;
      // 使用防抖处理搜索
      if (this.searchTimeout) {
        clearTimeout(this.searchTimeout);
      }
      this.searchTimeout = setTimeout(() => {
        // 搜索逻辑已经在计算属性中处理
      }, 300);
    },

    // 处理用户搜索清除
    handleUserSearchClear() {
      this.userSearchQuery = '';
      this.orderPagination.currentPage = 1;
    },

    initCharts() {
      this.salesTrendChart = echarts.init(this.$refs.salesTrendChart)
      this.productSalesChart = echarts.init(this.$refs.productSalesChart)
      this.orderTrendChart = echarts.init(this.$refs.orderTrendChart)
      this.orderStatusChart = echarts.init(this.$refs.orderStatusChart)
    },
  }
}
</script>

<style lang="scss" scoped>
.dashboard-container {
  padding: 20px;
  background-color: #f0f2f5;
  min-height: calc(100vh - 84px);
  
  // 统计卡片样式
  .stat-card {
    position: relative;
    background: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    display: flex;
    overflow: hidden;
    transition: all 0.3s;
    
    &:hover {
      transform: translateY(-5px);
      box-shadow: 0 5px 15px 0 rgba(0, 0, 0, 0.15);
    }
    
    .stat-icon {
      height: 60px;
      width: 60px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-right: 15px;
      
      i {
        font-size: 28px;
        color: #fff;
      }
    }
    
    .stat-content {
      flex: 1;
    }
    
    .stat-title {
      font-size: 14px;
      color: #606266;
      margin-bottom: 8px;
    }
    
    .stat-value {
      font-size: 24px;
      font-weight: bold;
      color: #303133;
      margin-bottom: 5px;
    }
    
    .stat-footer {
      font-size: 12px;
      
      .trend-up {
        color: #67c23a;
        margin-right: 8px;
      }
      
      .trend-down {
        color: #f56c6c;
        margin-right: 8px;
      }
      
      .trend-desc {
        color: #909399;
      }
    }
  }
  
  .sales-card {
    .stat-icon {
      background-color: #f56c6c;
    }
  }
  
  .orders-card {
    .stat-icon {
      background-color: #409eff;
    }
  }
  
  .products-card {
    .stat-icon {
      background-color: #67c23a;
    }
  }
  
  .users-card {
    .stat-icon {
      background-color: #e6a23c;
    }
  }
  
  // 图表区域样式
  .chart-row {
    margin-bottom: 20px;
  }
  
  .chart-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    
    .chart-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      
      h3 {
        margin: 0;
        font-size: 16px;
        color: #303133;
      }
    }
    
    .chart-container {
      height: 300px;
      width: 100%;
    }
  }
  
  // 表格区域样式
  .report-row {
    margin-bottom: 20px;
  }
  
  .table-card {
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    
    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      
      h3 {
        margin: 0;
        font-size: 16px;
        color: #303133;
      }
      
      .table-tools {
        display: flex;
        align-items: center;
      }
    }
  }
  
  // 空数据样式
  .empty-data {
    text-align: center;
    padding: 30px 0;
    color: #909399;
    
    i {
      font-size: 48px;
      margin-bottom: 10px;
    }
    
    p {
      margin: 0;
    }
  }
  
  // 进度条样式
  .sale-progress {
    width: 60%;
    margin-right: 10px;
    display: inline-block;
    vertical-align: middle;
  }
  
  // 分页容器
  .pagination-container {
    margin-top: 15px;
    text-align: right;
  }
  
  // 表格行样式
  ::v-deep .even-row {
    background-color: #fafafa;
  }
  
  ::v-deep .odd-row {
    background-color: #ffffff;
  }
  
  // 加载容器
  .loading-container {
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  // 下拉链接样式
  .el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
  }
}

// 响应式样式
@media (max-width: 768px) {
  .dashboard-container {
    padding: 10px;
    
    .chart-container {
      height: 250px !important;
    }
    
    .table-header {
      flex-direction: column;
      align-items: flex-start !important;
      
      .table-tools {
        margin-top: 10px;
        flex-wrap: wrap;
        
        .el-input {
          margin-top: 10px;
        }
      }
    }
  }
}
</style>
