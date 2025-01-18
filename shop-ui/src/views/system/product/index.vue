<template>
  <div class="app-container">
    <el-form ref="queryForm" :model="queryParams" :inline="true">
      <el-form-item label="产品名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="请输入产品名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery"
        >搜索</el-button
        >
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          icon="el-icon-plus"
          @click="handleAdd"
          v-hasPermi="['system:product:add']"
        >新增</el-button
        >
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          icon="el-icon-delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:product:remove']"
        >删除</el-button
        >
      </el-col>
    </el-row>

    <el-table
      v-loading="loading"
      :data="productList"
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column prop="name" label="产品名称" align="center" />
      <el-table-column prop="price" label="价格" align="center" />
      <el-table-column prop="stock" label="库存" align="center" />
      <el-table-column prop="description" label="产品描述" align="center"/>
      <el-table-column prop="category" label="产品类型" align="center"/>    <!-- 添加的产品类型列 -->
      <el-table-column prop="imageUrl" label="产品图片" align="center" width="100">
        <template slot-scope="scope">
          <el-image
            style="width: 80px; height: 80px"
            :src="scope.row.imageUrl"
            :preview-src-list="[scope.row.imageUrl]"
          ></el-image>
        </template>
      </el-table-column>
      <el-table-column prop="createdTime" label="上架时间" align="center" width="160" />
      <el-table-column prop="updatedTime" label="更新时间" align="center" width="160" />
      <el-table-column
        label="操作"
        align="center"
        class-name="small-padding fixed-width"
      >
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:product:edit']"
          >修改</el-button
          >
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:product:remove']"
          >删除</el-button
          >
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

    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="产品名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入产品名称" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input v-model="form.price" placeholder="请输入价格"/>
        </el-form-item>
        <el-form-item label="库存" prop="stock">
          <el-input v-model="form.stock" placeholder="请输入库存"/>
        </el-form-item>
        <el-form-item label="产品类型" prop="category">
          <el-input v-model="form.category" placeholder="请输入产品类型"/>
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            placeholder="请输入描述"
          />
        </el-form-item>
        <el-form-item label="图片" prop="imageUrl">
          <el-input v-model="form.imageUrl" placeholder="请输入图片URL"/>
        </el-form-item>
        <el-form-item label="创建时间" >
          <el-input v-model="form.createdTime" disabled />
        </el-form-item>
        <el-form-item label="更新时间" >
          <el-input v-model="form.updatedTime" disabled />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import {listProduct, delProduct, addProduct, updateProduct, getProduct, deleteProduct} from "@/api/system/product";

export default {
  name: "Product",
  data() {
    return {
      loading: true,
      ids: [],
      multiple: true,
      total: 0,
      productList: [],
      open: false,
      title: "",
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        name: "",
      },
      form: {},
      rules: {
        name: [{ required: true, message: "产品名称不能为空", trigger: "blur" }],
        price: [{ required: true, message: "价格不能为空", trigger: "blur" }],
        stock: [{ required: true, message: "库存不能为空", trigger: "blur" }],
      },
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
    /** 查询列表 */
    getList() {
      this.loading = true;
      listProduct(this.queryParams)
        .then((response) => {
          this.productList = response.rows;
          this.total = response.total;
          this.loading = false;
        })
        .catch((err) => {
          console.error("获取电子产品列表失败:", err);
          this.loading = false;
        });
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map((item) => item.id);
      this.multiple = !selection.length;
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const productIds = row.id || this.ids;
      const ids = Array.isArray(productIds) ? productIds: [productIds]
      this.$modal
        .confirm("是否确认删除电子产品数据项?")
        .then(() => {
          return deleteProduct(ids); // 传递数组
        })
        .then(() => {
          this.getList();
          this.$modal.msgSuccess("删除成功");
        })
        .catch(() => {});
    },
    /** 添加按钮操作 */
    handleAdd() {
      this.open = true;
      this.title = "添加电子产品";
      this.form = {
        name: '',
        price: null,
        stock: null,
        description: '',
        imageUrl: '',
        category:''
      };
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.open = true;
      this.title = "修改电子产品";
      getProduct(row.id).then((response) => {
        this.form = response.data;
      });
    },
    submitForm() {
      this.$refs["form"].validate((valid) => {
        if (valid) {
          if(this.form.id) {
            updateProduct(this.form).then(res =>{
              this.$modal.msgSuccess("修改成功")
              this.open = false;
              this.getList();
            });
          }else{
            addProduct(this.form).then(res =>{
              this.$modal.msgSuccess("新增成功")
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 取消按钮 */
    cancel() {
      this.open = false;
    },
  },
};
</script>
