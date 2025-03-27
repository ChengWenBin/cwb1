<template>
  <div class="app-container">
    <!-- 查询表单 -->
    <el-form ref="queryForm" :inline="true" :model="queryParams" class="demo-form-inline" size="small">
      <el-form-item label="产品名称" prop="name">
        <el-input
          v-model="queryParams.name"
          placeholder="产品名称"
          clearable
          style="width: 240px"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="产品类型" prop="category">
        <el-select v-model="queryParams.category" placeholder="请选择产品类型" clearable style="width: 240px">
          <el-option label="电脑" value="电脑" />
          <el-option label="手机" value="手机" />
          <el-option label="平板" value="平板" />
          <el-option label="耳机" value="耳机" />
          <el-option label="其他" value="其他" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 新增/删除按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          icon="el-icon-plus"
          @click="handleAdd"
          v-hasPermi="['system:product:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          icon="el-icon-delete"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:product:remove']"
        >删除</el-button>
      </el-col>
    </el-row>

    <!-- 产品列表表格 -->
    <el-table
      v-loading="loading"
      :data="productList"
      @selection-change="handleSelectionChange"
      :cell-style="tableCellStyle"
      :header-cell-style="headerCellStyle"
    >
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column prop="name" label="产品名称" align="center" />
      <el-table-column prop="price" label="价格" align="center" />
      <el-table-column prop="stock" label="库存" align="center" />
      <el-table-column prop="description" label="产品描述" align="center"/>
      <el-table-column prop="category" label="产品类型" align="center"/>
      <el-table-column prop="imageUrl" label="产品图片" align="center" width="100">
        <template slot-scope="scope">
          <el-image
            style="width: 80px; height: 80px"
            :src="scope.row.imageUrl"
            :preview-src-list="[scope.row.imageUrl]"
          ></el-image>
        </template>
      </el-table-column>
      <el-table-column prop="createdTime" label="上架时间" align="center" width="160">
        <template #default="scope">
          {{ scope.row.createdTime | formatDate }}
        </template>
      </el-table-column>
      <el-table-column prop="updatedTime" label="更新时间" align="center" width="160">
        <template #default="scope">
          {{ scope.row.updatedTime | formatDate }}
        </template>
      </el-table-column>
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
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:product:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页组件 -->
    <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 新增/修改产品对话框 -->
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
          <el-select v-model="form.category" placeholder="请选择产品类型" style="width: 100%">
            <el-option label="电脑" value="电脑" />
            <el-option label="手机" value="手机" />
            <el-option label="平板" value="平板" />
            <el-option label="耳机" value="耳机" />
            <el-option label="其他" value="其他" />
          </el-select>
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
        <el-form-item label="创建时间">
          <el-input v-model="form.createdTime" disabled />
        </el-form-item>
        <el-form-item label="更新时间">
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
import { listProduct, delProduct, addProduct, updateProduct, getProduct, deleteProduct } from "@/api/system/product";

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
        category: "",
        orderByColumn: "updatedTime",
        isAsc: "desc"
      },
      // 新增/修改产品表单数据
      form: {
        name: '',
        price: null,
        stock: null,
        description: '',
        imageUrl: '',
        category: '',
        createdTime: '',
        updatedTime: ''
      },
      rules: {
        name: [{ required: true, message: "产品名称不能为空", trigger: "blur" }],
        price: [{ required: true, message: "价格不能为空", trigger: "blur" }],
        stock: [{ required: true, message: "库存不能为空", trigger: "blur" }],
      },
    };
  },
  created() {
    this.getList();
    // 检查URL查询参数，处理从其他页面传来的编辑请求
    this.checkQueryParams();
  },
  methods: {
    // 处理URL查询参数
    checkQueryParams() {
      const { id, action } = this.$route.query;
      if (id && action === 'edit') {
        // 如果有id和action=edit参数，则打开编辑对话框
        getProduct(id).then(response => {
          this.form = response.data;
          this.open = true;
          this.title = "修改产品";
        });
      }
    },
    /** 查询产品列表 */
    getList() {
      this.loading = true;
      this.queryParams.orderByColumn = "updatedTime";
      this.queryParams.isAsc = "desc";
      
      listProduct(this.queryParams).then(response => {
        this.productList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮：关闭对话框并重置产品表单
    cancel() {
      this.open = false;
      this.resetForm("form");
    },
    // 表单重置：手动重置 form 数据，再调用 Element UI 的 resetFields 方法
    reset() {
      this.form = {
        name: '',
        price: null,
        stock: null,
        description: '',
        imageUrl: '',
        category: '',
        createdTime: '',
        updatedTime: ''
      };
      if (this.$refs.form) {
        this.$refs.form.resetFields();
      }
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置查询表单 */
    resetQuery() {
      // 手动重置查询数据
      this.queryParams = {
        pageNum: 1,
        pageSize: 10,
        name: "",
        category: "",
        orderByColumn: "updatedTime",
        isAsc: "desc"
      };
      // 调用查询表单的 resetFields 方法（需在模板上设置 ref="queryForm"）
      if (this.$refs.queryForm) {
        this.$refs.queryForm.resetFields();
      }
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id);
      this.multiple = !selection.length;
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加产品";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      const id = row.id || this.ids;
      getProduct(id).then(response => {
        this.form = response.data;
        this.open = true;
        this.title = "修改产品";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs.form.validate(valid => {
        if (valid) {
          if (this.form.id !== undefined) {
            updateProduct(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
              
              // 处理从首页库存警告跳转来的情况
              const { action, 'return-to-alerts': returnToAlerts } = this.$route.query;
              if (action === 'edit' && returnToAlerts === 'true') {
                // 使用nextTick确保DOM更新后再跳转
                this.$nextTick(() => {
                  this.$router.push({
                    path: '/',
                    query: { refresh: 'alerts', timestamp: Date.now() }
                  });
                });
              }
            });
          } else {
            addProduct(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const productIds = row.id || this.ids;
      const ids = Array.isArray(productIds) ? productIds : [productIds];
      this.$modal.confirm('是否确认删除产品编号为"' + productIds + '"的数据项？').then(() => {
        return deleteProduct(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
    // 表格单元格样式
    tableCellStyle({ row, column, rowIndex, columnIndex }) {
      return 'padding: 8px 0;';
    },
    // 表格表头单元格样式
    headerCellStyle({ row, column, rowIndex, columnIndex }) {
      return 'background-color: #f5f7fa; color: #606266; font-weight: bold; padding: 8px 0;';
    },
    // 通用重置表单方法：调用 Element UI 的 resetFields
    resetForm(formName) {
      if (this.$refs[formName]) {
        this.$refs[formName].resetFields();
      }
    }
  },
  filters: {
    formatDate(time) {
      if (!time) {
        return '';
      }
      const date = new Date(time);
      const year = date.getFullYear();
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      const seconds = date.getSeconds().toString().padStart(2, '0');
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }
  },
};
</script>

<style scoped>
.el-form--inline .el-form-item {
  margin-right: 10px;
  margin-bottom: 10px;
}
</style>
