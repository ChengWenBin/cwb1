<template>
  <div class="dashboard-container">
    <el-row :gutter="20">
      <el-col :span="12">
        <div class="chart-container" ref="salesTrendChart"></div>
      </el-col>
      <el-col :span="12">
        <div class="chart-container" ref="productSalesChart"></div>
      </el-col>
    </el-row>
    <el-row :gutter="20">
      <el-col :span="12">
        <div class="chart-container" ref="orderTrendChart"></div>
      </el-col>
      <el-col :span="12">
        <div class="chart-container" ref="orderStatusChart"></div>
      </el-col>
    </el-row>

    <el-row style="margin-top: 20px;">
      <el-col :span="24">
        <h2 style="text-align: center;">销售数据报表</h2>
        <div class="table-operations">
          <el-button type="primary" @click="exportSalesReport">导出销售报表</el-button>
          <el-input
            placeholder="搜索产品名称"
            v-model="salesSearchQuery"
            style="width: 200px; margin-left: 10px;"
            clearable
            @clear="handleSalesSearchClear"
            @input="handleSalesSearchInput"
          >
            <i slot="prefix" class="el-input__icon el-icon-search"></i>
          </el-input>
        </div>
        <el-table v-if="!salesLoading" :data="paginatedSalesData" border style="width: 100%">
          <el-table-column prop="name" label="产品名称"></el-table-column>
          <el-table-column prop="quantity" label="销售数量"></el-table-column>
          <el-table-column prop="amount" label="产品销售总额"></el-table-column>
        </el-table>
        <div v-else class="loading-container">
          <el-loading :visible="salesLoading" text="正在加载数据..." :element-loading-spinner-size="30">加载中</el-loading>
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
          class="pagination-container">
        </el-pagination>
        <div v-if="!salesLoading && filteredSalesData.length === 0" class="empty-data">
          <i class="el-icon-document"></i>
          <p>暂无数据</p>
        </div>

        <h2 style="text-align: center;">订单数据报表</h2>
        <div class="table-operations">
          <el-button type="primary" @click="exportOrderReport">导出订单报表</el-button>
          <el-input
            placeholder="搜索订单编号"
            v-model="orderSearchQuery"
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
            style="width: 180px; margin-left: 10px;"
            clearable
            @clear="handleUserSearchClear"
            @input="handleUserSearchInput"
          >
            <i slot="prefix" class="el-input__icon el-icon-user"></i>
          </el-input>
        </div>
        <el-table v-if="!orderLoading" :data="paginatedOrderData" border style="width: 100%">
          <el-table-column prop="create_time" label="下单日期"></el-table-column>
          <el-table-column prop="user_id" label="下单用户"></el-table-column>
          <el-table-column prop="order_no" label="订单编号"></el-table-column>
          <el-table-column prop="order_status" label="订单状态">
            <template slot-scope="scope">
              <el-tag 
                :type="getOrderStatusTagType(scope.row.order_status)" 
                size="medium">
                {{ scope.row.order_status }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="total_amount" label="总价"></el-table-column>
          <el-table-column prop="address" label="收货地址"></el-table-column>
        </el-table>
        <div v-else class="loading-container">
          <el-loading :visible="orderLoading" text="正在加载数据..." :element-loading-spinner-size="30">加载中</el-loading>
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
          class="pagination-container">
        </el-pagination>
        <div v-if="!orderLoading && filteredOrderData.length === 0" class="empty-data">
          <i class="el-icon-document"></i>
          <p>暂无数据</p>
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
      searchTimeout: null
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
  },
  methods: {
    async fetchData() {
      try {
        const salesTrendRes = await getSalesTrend()
        const productSalesRes = await getProductSales()
        const orderTrendRes = await getOrderTrend()
        const orderStatusRes = await getOrderStatus()
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

    initCharts() {
      this.salesTrendChart = echarts.init(this.$refs.salesTrendChart)
      this.productSalesChart = echarts.init(this.$refs.productSalesChart)
      this.orderTrendChart = echarts.init(this.$refs.orderTrendChart)
      this.orderStatusChart = echarts.init(this.$refs.orderStatusChart)
    },

    renderSalesTrendChart(data) {
      const dates = data.map(item => item.date)
      const sales = data.map(item => item.sales)

      const option = {
        title: {
          text: '销售趋势',
          left: 'center' // 标题居中
        },
        xAxis: {
          type: 'category',
          data: dates
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          data: sales,
          type: 'line' // 或 'bar'
        }]
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
        xAxis: {
          type: 'category',
          data: dates
        },
        yAxis: {
          type: 'value'
        },
        series: [{
          data: orderCounts,
          type: 'line'
        }]
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
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
}

.chart-container {
  height: 400px;
  margin-bottom: 20px;
}

.table-operations {
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}

.pagination-container {
  margin-top: 15px;
  margin-bottom: 30px;
  text-align: right;
}

.loading-container {
  min-height: 150px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.empty-data {
  padding: 40px 0;
  text-align: center;
  color: #909399;
}

.empty-data i {
  font-size: 48px;
  margin-bottom: 10px;
}

.empty-data p {
  font-size: 14px;
}
</style>
