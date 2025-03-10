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
        <el-button type="primary" @click="exportSalesReport">导出销售报表</el-button>
        <el-table v-if="!salesLoading" :data="salesReportData.productSales" border style="width: 100%">
          <el-table-column prop="name" label="产品名称"></el-table-column>
          <el-table-column prop="quantity" label="销售数量"></el-table-column>
          <el-table-column prop="amount" label="产品销售总额"></el-table-column>
        </el-table>
        <div v-else> 正在加载数据...</div>

        <h2 style="text-align: center;">订单数据报表</h2>
        <el-button type="primary" @click="exportOrderReport">导出订单报表</el-button>
        <el-table v-if="!orderLoading" :data="orderReportData" border style="width: 100%">
          <el-table-column prop="create_time" label="下单日期"></el-table-column>
          <el-table-column prop="user_id" label="下单用户"></el-table-column>
          <el-table-column prop="order_no" label="订单编号"></el-table-column>
          <el-table-column prop="order_status" label="订单状态"></el-table-column>
          <el-table-column prop="total_amount" label="总价"></el-table-column>
          <el-table-column prop="address" label="收货地址"></el-table-column>
        </el-table>
        <div v-else>正在加载数据...</div>
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
      orderReportData: []
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
          center: ['60%', '55%'],  // 调整圆心位置，为图例腾出空间。  注意这里改了
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
      const list = this.salesReportData.productSales;
      const data = this.formatJson(filterVal, list);
      this.exportExcel(data, tHeader, '销售数据报表.xlsx');
    },

    exportOrderReport() {
      const tHeader = ['下单日期', '下单用户', '订单编号', '订单状态', '总价', '收货地址'];
      const filterVal = ['create_time', 'user_id', 'order_no', 'order_status', 'total_amount', 'address'];
      const list = this.orderReportData;
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
}
</style>
