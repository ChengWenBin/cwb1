<template>
  <div class="app-container">
    <!-- 搜索表单 -->
    <el-form :inline="true" :model="queryParams" class="demo-form-inline" size="small">
      <el-form-item>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd">新增类型</el-button>
      </el-form-item>
    </el-form>

    <!-- 类型列表表格 -->
    <el-table
      v-loading="loading"
      :data="categoryList"
      :cell-style="tableCellStyle"
      :header-cell-style="headerCellStyle"
    >
      <el-table-column label="序号" type="index" width="50" align="center" />
      <el-table-column prop="category" label="产品类型" align="center" />
      <el-table-column prop="count" label="使用数量" align="center" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
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

    <!-- 添加或修改类型对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="类型名称" prop="category">
          <el-input v-model="form.category" placeholder="请输入类型名称" />
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
import { listCategory, addCategory, updateCategory, delCategory, getCategoryCount } from "@/api/system/category";

export default {
  name: "Category",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 总条数
      total: 0,
      // 类型表格数据
      categoryList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      // 表单参数
      form: {
        category: "",
        oldCategory: ""
      },
      // 表单校验
      rules: {
        category: [
          { required: true, message: "类型名称不能为空", trigger: "blur" },
          { min: 1, max: 50, message: "类型名称长度不能超过50个字符", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询类型列表 */
    getList() {
      this.loading = true;
      listCategory().then(response => {
        // 获取类型列表
        const categories = response.rows || [];
        
        // 为每个类型获取使用数量
        const promises = categories.map(category => {
          return getCategoryCount(category).then(res => {
            return {
              category: category,
              count: res.data.count || 0
            };
          });
        });
        
        // 等待所有请求完成
        Promise.all(promises).then(results => {
          this.categoryList = results;
          this.total = results.length;
          this.loading = false;
        });
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        category: "",
        oldCategory: ""
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.reset();
      this.open = true;
      this.title = "添加产品类型";
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      this.form.category = row.category;
      this.form.oldCategory = row.category;
      this.open = true;
      this.title = "修改产品类型";
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.oldCategory) {
            // 修改
            const data = {
              oldCategory: this.form.oldCategory,
              newCategory: this.form.category
            };
            updateCategory(data).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            // 新增
            const data = {
              category: this.form.category
            };
            addCategory(data).then(response => {
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
      const category = row.category;
      this.$modal.confirm('是否确认删除类型名称为"' + category + '"的数据项?').then(function() {
        return delCategory(category);
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
      return 'background-color: #f5f7fa; color: #606266; font-weight: bold; padding: 10px 0;';
    },
    // 重置表单
    resetForm(formName) {
      if (this.$refs[formName]) {
        this.$refs[formName].resetFields();
      }
    }
  }
};
</script>

<style scoped>
.el-table {
  margin-top: 15px;
}
.el-table .warning-row {
  background: oldlace;
}
.el-table .success-row {
  background: #f0f9eb;
}
.el-table .el-button {
  margin: 2px;
}
.el-table .el-button--text {
  padding: 2px 0;
}
.el-form-item {
  margin-bottom: 20px;
}
.dialog-footer {
  text-align: center;
}
</style>
