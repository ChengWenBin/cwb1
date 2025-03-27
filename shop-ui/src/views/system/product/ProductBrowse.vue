<template>
  <div class="app-container">
    <el-card>
      <el-form :inline="true" ref="queryForm" :model="queryParams" class="search-form">
        <el-form-item label="产品名称" prop="name">
          <el-input v-model="queryParams.name" placeholder="请输入产品名称" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item label="产品类别" prop="category">
          <el-select v-model="queryParams.category" placeholder="请选择产品类别" clearable style="width: 200px">
            <el-option label="电脑" value="电脑" />
            <el-option label="手机" value="手机" />
            <el-option label="平板" value="平板" />
            <el-option label="耳机" value="耳机" />
            <el-option label="其他" value="其他" />
          </el-select>
        </el-form-item>
        <el-form-item label="价格区间" class="price-range">
          <div class="price-input-group">
            <el-input v-model.number="queryParams.minPrice" placeholder="最低价格" class="price-input" />
            <span class="price-separator">-</span>
            <el-input v-model.number="queryParams.maxPrice" placeholder="最高价格" class="price-input" />
          </div>
        </el-form-item>
        <el-form-item label="库存数量">
          <el-input v-model.number="queryParams.minStock" placeholder="最低库存" style="width: 200px" />
        </el-form-item>
        <el-form-item class="search-buttons">
          <el-button type="primary" @click="handleQuery" icon="el-icon-search">查询</el-button>
          <el-button @click="resetQuery" icon="el-icon-refresh">重置</el-button>
          <el-button type="success" @click="showRecommend" icon="el-icon-star-off">查看推荐</el-button>
        </el-form-item>
      </el-form>

      <!-- 价格排序下拉框 -->
      <div class="sort-container">
        <span class="sort-label">价格排序：</span>
        <el-select v-model="sortOrder" @change="handleSortChange" style="width: 150px">
          <el-option label="价格从高到低" value="desc" />
          <el-option label="价格从低到高" value="asc" />
        </el-select>
      </div>

      <el-table v-loading="loading" :data="paginatedProductList">
        <el-table-column label="产品名称" prop="name" align="center" />
        <el-table-column label="产品描述" prop="description" align="center" />
        <el-table-column label="产品类别" prop="category" align="center" />
        <el-table-column label="价格" prop="price" align="center" />
        <el-table-column label="库存" prop="stock" align="center" />
        <el-table-column label="图片" prop="imageUrl" align="center" width="100">
          <template slot-scope="scope">
            <el-image style="width: 80px;height:80px" :src="scope.row.imageUrl" :preview-src-list="[scope.row.imageUrl]"></el-image>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120" align="center">
          <template slot-scope="scope">
            <el-button
              size="mini"
              type="text"
              icon="el-icon-shopping-cart-full"
              @click="handleAddToCart(scope.row)"
            >加入购物车</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 自定义分页 -->
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
    </el-card>
    <!-- 推荐产品弹窗 -->
    <recommend-popup :visible.sync="recommendVisible" />
  </div>
</template>

<script>
import { listProduct } from "@/api/system/product-browse";
import { addCart } from "@/api/system/cart";
import RecommendPopup from "./components/RecommendPopup.vue";

export default {
  components: {
    RecommendPopup
  },
  data() {
    return {
      loading: true,
      allProductList: [], // 存储所有产品的数组
      queryParams: {
        name: "",
        category: "",
        minPrice: null,
        maxPrice: null,
        minStock: null,
      },
      sortOrder: "desc", // 默认价格从高到低排序
      currentPage: 1, // 当前页码
      pageSize: 10, // 每页显示数量
      total: 0, // 总数据量
      recommendVisible: false,
    };
  },
  computed: {
    // 根据筛选条件过滤产品
    filteredProductList() {
      let result = [...this.allProductList];

      // 根据查询条件筛选
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

      // 根据排序条件排序
      if (this.sortOrder === 'asc') {
        result.sort((a, b) => parseFloat(a.price) - parseFloat(b.price));
      } else {
        result.sort((a, b) => parseFloat(b.price) - parseFloat(a.price));
      }

      return result;
    },

    // 当前页的数据
    paginatedProductList() {
      const start = (this.currentPage - 1) * this.pageSize;
      const end = start + this.pageSize;
      return this.filteredProductList.slice(start, end);
    }
  },
  created() {
    this.fetchAllProducts();
  },
  methods: {
    // 获取所有产品数据
    fetchAllProducts() {
      this.loading = true;

      // 创建一个查询参数，设置大页码以获取所有数据
      const params = {
        pageNum: 1,
        pageSize: 1000, // 设置一个足够大的值以获取所有产品
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

    handleQuery() {
      this.currentPage = 1; // 重置到第一页
      this.fetchAllProducts(); // 重新获取数据
    },

    resetQuery() {
      this.$refs.queryForm.resetFields(); // 重置表单控件的值
      this.queryParams.name = "";
      this.queryParams.category = "";
      this.queryParams.minPrice = null;
      this.queryParams.maxPrice = null;
      this.queryParams.minStock = null;
      this.sortOrder = "desc"; // 重置为默认排序方式(从高到低)
      this.currentPage = 1; // 重置到第一页
      this.handleQuery(); // 重新获取数据
    },

    // 处理排序变化
    handleSortChange() {
      // 前端已通过计算属性进行了排序
      console.log("排序方式变更为:", this.sortOrder);
      this.currentPage = 1; // 切换排序时回到第一页
    },

    // 处理每页显示数量变化
    handleSizeChange(size) {
      this.pageSize = size;
      this.currentPage = 1; // 改变每页数量时，重置到第一页
    },

    // 处理页码变化
    handleCurrentChange(page) {
      this.currentPage = page;
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
    }
  }
};
</script>

<style scoped>
.search-form {
  background-color: #f5f7fa;
  padding: 18px;
  border-radius: 4px;
  margin-bottom: 20px;
}

.price-range {
  .price-input-group {
    display: flex;
    align-items: center;
    width: 200px;
  }

  .price-input {
    width: 90px;
  }

  .price-separator {
    margin: 0 5px;
    color: #606266;
  }
}

.search-buttons {
  margin-left: 10px;
  .el-button {
    margin-left: 8px;
    &:first-child {
      margin-left: 0;
    }
  }
}

.sort-container {
  display: flex;
  align-items: center;
  margin-bottom: 15px;
  padding: 0 10px;
}

.sort-label {
  margin-right: 10px;
  font-size: 14px;
  color: #606266;
}

.pagination-container {
  margin-top: 20px;
  text-align: right;
  padding: 10px 20px;
}
</style>
