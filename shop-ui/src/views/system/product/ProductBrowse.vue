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

          <el-table v-loading="loading" :data="paginatedProductList" :row-class-name="tableRowClassName">
            <el-table-column label="产品名称" prop="name" align="center">
              <template slot-scope="scope">
                <el-link type="primary" @click="showProductDetail(scope.row)">{{ scope.row.name }}</el-link>
              </template>
            </el-table-column>
            <!-- 注释掉产品描述列 -->
            <!-- <el-table-column label="产品描述" prop="description" align="center" /> -->
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
                  :class="{ 'out-of-stock': scope.row.stock <= 0 }"
                >{{ scope.row.stock <= 0 ? '缺货可加购' : '加入购物车' }}</el-button>
              </template>
            </el-table-column>
          </el-table>

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

<style scoped>
.app-container {
  padding: 20px;
}

.directory-container {
  display: flex;
}

.directory-menu {
  width: 200px;
  margin-right: 20px;
  border-right: 1px solid #e6e6e6;
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
  background-color: #f5f7fa;
  padding: 15px;
  border-radius: 4px;
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
  color: #606266;
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

/* 库存为0的商品行样式 */
.out-of-stock-row {
  color: #909399;
  background-color: #f5f7fa;
}

/* 库存为0的按钮样式 */
.out-of-stock {
  color: #909399 !important;
  border-color: #dcdfe6 !important;
}
</style>
