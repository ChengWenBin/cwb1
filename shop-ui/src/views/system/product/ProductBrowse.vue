<template>
  <div class="app-container">
    <el-card>
      <el-form :inline="true" ref="queryForm" :model="queryParams">
        <el-form-item label="产品名称" prop="name">
          <el-input v-model="queryParams.name" placeholder="请输入产品名称" clearable />
        </el-form-item>
        <el-form-item label="产品类别" prop="category">
          <el-select v-model="queryParams.category" placeholder="请选择产品类别" clearable>
            <el-option label="电脑" value="电脑" />
            <el-option label="手机" value="手机" />
            <el-option label="平板" value="平板" />
            <el-option label="耳机" value="耳机" />
            <el-option label="其他" value="其他" />
          </el-select>
        </el-form-item>
        <el-form-item label="价格区间">
          <el-input v-model.number="queryParams.minPrice" placeholder="最低价格" style="width: 90px" />
          <!-- 使用 .number 修饰符 -->
          <el-input placeholder="-" style="width: 20px; text-align: center;" readonly>
          </el-input>
          <el-input v-model.number="queryParams.maxPrice" placeholder="最高价格" style="width: 90px" />
          <!-- 使用 .number 修饰符 -->
        </el-form-item>
        <el-form-item label="库存数量">
          <el-input v-model.number="queryParams.minStock" placeholder="最低库存" />
          <!-- 使用 .number 修饰符 -->
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleQuery">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
          <el-button type="success" @click="showRecommend">查看推荐</el-button>
        </el-form-item>
      </el-form>
      <el-table v-loading="loading" :data="productList">
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
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
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
      productList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        name: "",
        category: "",   //初始 category 就是空字符串，代表查询所有类别
        minPrice: null,
        maxPrice: null,
        minStock: null,
      },
      total: 0,
      recommendVisible: false,
    };
  },
  created() {
    this.getList();
    // 页面加载后显示推荐弹窗
    this.$nextTick(() => {
      setTimeout(() => {
        this.recommendVisible = true;
      }, 1000); // 延迟1秒显示，给页面加载留出时间
    });
  },
  methods: {
    handleQuery() {
      this.queryParams.pageNum = 1; // 3. 查询时重置到第一页
      console.log("查询参数", this.queryParams);
      this.getList();
    },
    resetQuery() {
      this.$refs.queryForm.resetFields(); // 重置表单控件的值
      this.queryParams.name = "";
      this.queryParams.category = "";     // 显式地设置 category 为空，触发重新查询
      this.queryParams.minPrice = null;
      this.queryParams.maxPrice = null;
      this.queryParams.minStock = null;
      this.handleQuery();
    },
    getList() {
      this.loading = true;

      // 构建请求参数，只包含非空的筛选条件
      const params = {
        pageNum: this.queryParams.pageNum,
        pageSize: this.queryParams.pageSize,
        ...this.queryParams        //这里是关键， 直接将 queryParams 对象展开
      }

      listProduct(params)  // 使用 params 对象
        .then((response) => {
          this.productList = response.rows;
          this.total = response.total;
          this.loading = false;
        })
        .catch((err) => {
          this.loading = false;
          console.error("获取电子产品列表失败:", err);
        });
    },
    handleAddToCart(row) {
      const cart = {
        productId: row.id,
        quantity:1,
      };
      addCart(cart).then(()=>{
        this.$modal.msgSuccess("添加购物车成功");
      }).catch(err=>{
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
