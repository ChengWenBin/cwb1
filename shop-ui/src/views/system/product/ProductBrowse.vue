<template>
  <div class="app-container">
    <el-card>
      <el-form :inline="true">
        <el-form-item label="产品类别">
          <el-select v-model="queryParams.category" placeholder="请选择产品类别">
            <el-option label="电脑" value="电脑" />
            <el-option label="手机" value="手机" />
            <el-option label="平板" value="平板" />
            <el-option label="耳机" value="耳机" />
            <el-option label="其他" value="其他" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleQuery">查询</el-button>
          <el-button @click="resetQuery">重置</el-button>
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
  </div>
</template>

<script>
import { listProduct } from "@/api/system/product-browse";
import { addCart } from "@/api/system/cart";

export default {
  data() {
    return {
      loading: true,
      productList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        category: "",
      },
      total: 0,
    };
  },
  created() {
    this.getList();
  },
  methods: {
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    getList() {
      this.loading = true;
      listProduct(this.queryParams)
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
  }
};
</script>
