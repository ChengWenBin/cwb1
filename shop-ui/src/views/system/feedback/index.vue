<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="用户名称" prop="userName">
        <el-input
          v-model="queryParams.userName"
          placeholder="请输入用户名称"
          clearable
          size="small"
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="处理状态" prop="status">
        <el-select v-model="queryParams.status" placeholder="处理状态" clearable size="small">
          <el-option
            v-for="dict in statusOptions"
            :key="dict.dictValue"
            :label="dict.dictLabel"
            :value="dict.dictValue"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="阅读状态" prop="isRead">
        <el-select v-model="queryParams.isRead" placeholder="阅读状态" clearable size="small">
          <el-option
            v-for="dict in readOptions"
            :key="dict.dictValue"
            :label="dict.dictLabel"
            :value="dict.dictValue"
          />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['system:feedback:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="feedbackList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="反馈ID" align="center" prop="feedbackId" width="80" />
      <el-table-column label="用户名称" align="center" prop="userName" :show-overflow-tooltip="true" />
      <el-table-column label="反馈内容" align="center" prop="content" :show-overflow-tooltip="true" />
      <el-table-column label="处理状态" align="center" prop="status" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.status === '0' ? 'danger' : 'success'">
            {{ scope.row.status === '0' ? '未处理' : '已处理' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="阅读状态" align="center" prop="isRead" width="100">
        <template slot-scope="scope">
          <el-tag :type="scope.row.isRead === '0' ? 'warning' : 'info'">
            {{ scope.row.isRead === '0' ? '未读' : '已读' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" />
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width" width="180">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleView(scope.row)"
            v-hasPermi="['system:feedback:query']"
          >查看</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleReply(scope.row)"
            v-hasPermi="['system:feedback:reply']"
          >回复</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:feedback:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />

    <!-- 回复反馈对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body @closed="getList">
      <div class="feedback-detail">
        <div class="feedback-title">用户反馈:</div>
        <div class="feedback-content">{{ form.content }}</div>
      </div>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="回复内容" prop="reply">
          <el-input
            v-model="form.reply"
            type="textarea"
            placeholder="请输入回复内容"
            :autosize="{ minRows: 4, maxRows: 8 }"
          />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button type="primary" @click="submitForm">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { listFeedback, getFeedback, replyFeedback, delFeedback } from "@/api/system/feedback";

export default {
  name: "Feedback",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 反馈表格数据
      feedbackList: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        reply: [
          { required: true, message: "回复内容不能为空", trigger: "blur" },
          { min: 1, max: 500, message: "回复内容长度不能超过500个字符", trigger: "blur" }
        ]
      },
      // 状态选项
      statusOptions: [
        { dictLabel: "未处理", dictValue: "0" },
        { dictLabel: "已处理", dictValue: "1" }
      ],
      // 阅读状态选项
      readOptions: [
        { dictLabel: "未读", dictValue: "0" },
        { dictLabel: "已读", dictValue: "1" }
      ],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        userName: undefined,
        status: undefined,
        isRead: undefined
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询反馈列表 */
    getList() {
      this.loading = true;
      listFeedback(this.queryParams).then(response => {
        this.feedbackList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
      // 刷新列表，显示最新的状态
      this.getList();
    },
    // 表单重置
    reset() {
      this.form = {
        feedbackId: undefined,
        reply: undefined
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
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.feedbackId);
      this.single = selection.length !== 1;
      this.multiple = !selection.length;
    },
    /** 查看反馈详情 */
    handleView(row) {
      this.reset();
      getFeedback(row.feedbackId).then(response => {
        this.form = response.data;
        this.title = "查看反馈";
        this.open = true;
      });
    },
    /** 回复反馈操作 */
    handleReply(row) {
      this.reset();
      getFeedback(row.feedbackId).then(response => {
        this.form = response.data;
        this.title = "回复反馈";
        this.open = true;
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          // 确保设置状态为已处理
          this.form.status = '1';
          replyFeedback(this.form).then(response => {
            this.$modal.msgSuccess("回复成功");
            this.open = false;
            this.getList();
          });
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      const feedbackIds = row.feedbackId || this.ids;
      this.$modal.confirm('是否确认删除反馈编号为"' + feedbackIds + '"的数据项?').then(() => {
        return delFeedback(feedbackIds);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.feedback-detail {
  margin-bottom: 20px;
}
.feedback-title {
  font-weight: bold;
  margin-bottom: 10px;
}
.feedback-content {
  background-color: #f5f7fa;
  padding: 10px;
  border-radius: 4px;
  white-space: pre-wrap;
}
</style> 