<template>
  <div :class="classObj" class="app-wrapper" :style="{'--current-color': theme}">
    <div v-if="device==='mobile'&&sidebar.opened" class="drawer-bg" @click="handleClickOutside"/>
    <sidebar v-if="!sidebar.hide" class="sidebar-container"/>
    <div :class="{hasTagsView:needTagsView,sidebarHide:sidebar.hide}" class="main-container">
      <div :class="{'fixed-header':fixedHeader}">
        <navbar @openFeedback="openFeedbackDialog"/>
        <tags-view v-if="needTagsView"/>
      </div>
      <app-main/>
      <right-panel v-if="showSettings">
        <settings/>
      </right-panel>
    </div>

    <!-- 客服反馈对话框 -->
    <el-dialog :title="'联系客服'" :visible.sync="feedbackDialogVisible" width="500px" append-to-body>
      <div v-if="feedbackHistoryVisible">
        <div class="feedback-history">
          <div v-if="feedbackList.length === 0" class="feedback-empty">
            <i class="el-icon-chat-dot-square" style="font-size: 48px; color: #909399;"></i>
            <p>暂无反馈历史，请点击"新增反馈"发送消息</p>
          </div>
          <el-timeline v-else>
            <el-timeline-item
              v-for="(item, index) in feedbackList"
              :key="index"
              :timestamp="item.createTime"
              :icon="item.reply ? 'el-icon-chat-dot-round' : 'el-icon-chat-line-round'"
              :type="item.reply ? 'primary' : 'info'">
              <el-card shadow="hover" :class="{'unread-feedback': item.reply && item.isRead === '0'}">
                <div class="feedback-item">
                  <div class="feedback-content">{{ item.content }}</div>
                  <div v-if="item.reply" class="feedback-reply">
                    <div class="reply-title">
                      <span>客服回复:</span>
                      <el-tag v-if="item.isRead === '0'" size="mini" type="danger" class="unread-tag">新消息</el-tag>
                    </div>
                    <div class="reply-content">{{ item.reply }}</div>
                  </div>
                  <div v-else class="feedback-status">
                    <el-tag size="mini" type="info">等待回复</el-tag>
                  </div>
                </div>
              </el-card>
            </el-timeline-item>
          </el-timeline>
        </div>
        <div slot="footer" class="dialog-footer">
          <el-button @click="showFeedbackForm">新增反馈</el-button>
          <el-button @click="feedbackDialogVisible = false">关 闭</el-button>
        </div>
      </div>
      <div v-else>
        <el-form ref="feedbackForm" :model="feedbackForm" :rules="feedbackRules" label-width="80px">
          <el-form-item label="反馈内容" prop="content">
            <el-input
              v-model="feedbackForm.content"
              type="textarea"
              placeholder="请输入您的问题或反馈"
              :autosize="{ minRows: 4, maxRows: 8 }">
            </el-input>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="showFeedbackHistory">查看历史</el-button>
          <el-button type="primary" @click="submitFeedback">提 交</el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import RightPanel from '@/components/RightPanel'
import { AppMain, Navbar, Settings, Sidebar, TagsView } from './components'
import ResizeMixin from './mixin/ResizeHandler'
import { mapState } from 'vuex'
import variables from '@/assets/styles/variables.scss'
import { listMyFeedback, addFeedback, getFeedbackDetail, userMarkAsRead } from '@/api/system/feedback'

export default {
  name: 'Layout',
  components: {
    AppMain,
    Navbar,
    RightPanel,
    Settings,
    Sidebar,
    TagsView
  },
  mixins: [ResizeMixin],
  data() {
    return {
      feedbackDialogVisible: false,
      feedbackHistoryVisible: false,
      feedbackList: [],
      feedbackForm: {
        content: ''
      },
      feedbackRules: {
        content: [
          { required: true, message: '请输入反馈内容', trigger: 'blur' },
          { min: 3, max: 500, message: '反馈内容长度应在2到500个字符之间', trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    ...mapState({
      theme: state => state.settings.theme,
      sideTheme: state => state.settings.sideTheme,
      sidebar: state => state.app.sidebar,
      device: state => state.app.device,
      needTagsView: state => state.settings.tagsView,
      fixedHeader: state => state.settings.fixedHeader,
      showSettings: state => state.settings.showSettings
    }),
    classObj() {
      return {
        hideSidebar: !this.sidebar.opened,
        openSidebar: this.sidebar.opened,
        withoutAnimation: this.sidebar.withoutAnimation,
        mobile: this.device === 'mobile'
      }
    },
    variables() {
      return variables;
    }
  },
  methods: {
    handleClickOutside() {
      this.$store.dispatch('app/closeSideBar', { withoutAnimation: false })
    },
    // 打开反馈对话框
    openFeedbackDialog() {
      this.feedbackDialogVisible = true;
      this.feedbackHistoryVisible = true;
      this.getFeedbackList();
    },
    // 获取用户反馈列表
    getFeedbackList() {
      listMyFeedback().then(response => {
        this.feedbackList = response.rows;
        // 将未读的回复标记为已读
        this.feedbackList.forEach(item => {
          if (item.reply && item.isRead === '0') {
            userMarkAsRead(item.feedbackId);
          }
        });
      });
    },
    // 显示反馈历史
    showFeedbackHistory() {
      this.feedbackHistoryVisible = true;
      this.getFeedbackList();
    },
    // 显示反馈表单
    showFeedbackForm() {
      this.feedbackHistoryVisible = false;
      // 重置表单
      if (this.$refs.feedbackForm) {
        this.$refs.feedbackForm.resetFields();
      }
    },
    // 提交反馈
    submitFeedback() {
      this.$refs.feedbackForm.validate(valid => {
        if (!valid) {
          return;
        }

        addFeedback(this.feedbackForm).then(response => {
          this.$message.success('反馈提交成功');
          this.showFeedbackHistory();
        });
      });
    }
  }
}
</script>

<style lang="scss" scoped>
  @import "~@/assets/styles/mixin.scss";
  @import "~@/assets/styles/variables.scss";

  .app-wrapper {
    @include clearfix;
    position: relative;
    height: 100%;
    width: 100%;

    &.mobile.openSidebar {
      position: fixed;
      top: 0;
    }
  }

  .drawer-bg {
    background: #000;
    opacity: 0.3;
    width: 100%;
    top: 0;
    height: 100%;
    position: absolute;
    z-index: 999;
  }

  .fixed-header {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 9;
    width: calc(100% - #{$base-sidebar-width});
    transition: width 0.28s;
  }

  .hideSidebar .fixed-header {
    width: calc(100% - 54px);
  }

  .sidebarHide .fixed-header {
    width: 100%;
  }

  .mobile .fixed-header {
    width: 100%;
  }

  .feedback-history {
    max-height: 400px;
    overflow-y: auto;
    padding-right: 5px;
  }

  .feedback-empty {
    text-align: center;
    padding: 30px 0;
    color: #909399;
  }

  .feedback-item {
    margin-bottom: 10px;
  }

  .feedback-content {
    margin-bottom: 10px;
    white-space: pre-wrap;
  }

  .feedback-reply {
    background-color: #f5f7fa;
    padding: 10px;
    border-radius: 4px;
  }

  .reply-title {
    font-weight: bold;
    margin-bottom: 5px;
    color: #409EFF;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .unread-tag {
    margin-left: 8px;
  }

  .unread-feedback {
    border-left: 3px solid #F56C6C;
  }

  .feedback-status {
    text-align: right;
    margin-top: 5px;
  }

  .reply-content {
    white-space: pre-wrap;
  }
</style>
