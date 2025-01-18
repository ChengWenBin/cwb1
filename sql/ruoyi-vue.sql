/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80013
 Source Host           : localhost:3306
 Source Schema         : ruoyi-vue

 Target Server Type    : MySQL
 Target Server Version : 80013
 File Encoding         : 65001

 Date: 18/01/2025 20:10:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cart
-- ----------------------------
DROP TABLE IF EXISTS `cart`;
CREATE TABLE `cart`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `quantity` int(11) NOT NULL COMMENT '商品数量',
  `created_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `updated_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_product_id`(`product_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '购物车表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart
-- ----------------------------
INSERT INTO `cart` VALUES (40, 100, 5, 1, '2025-01-07 14:41:13', '2025-01-07 14:41:13');
INSERT INTO `cart` VALUES (41, 100, 4, 1, '2025-01-07 14:41:13', '2025-01-07 14:41:13');
INSERT INTO `cart` VALUES (42, 100, 1, 1, '2025-01-07 14:41:18', '2025-01-07 14:41:18');
INSERT INTO `cart` VALUES (43, 100, 9, 1, '2025-01-07 16:07:17', '2025-01-07 16:07:17');
INSERT INTO `cart` VALUES (52, 101, 10, 1, '2025-01-09 12:18:24', '2025-01-09 12:18:24');

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (9, 'order', '订单表', 'order_item', 'order_id', 'Order', 'sub', 'element-plus', 'com.ruoyi.system', 'order', 'order', '订单', 'ruoyi', '0', '/', '{\"parentMenuId\":1}', 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20', NULL);
INSERT INTO `gen_table` VALUES (10, 'order_item', '订单明细表', NULL, NULL, 'OrderItem', 'crud', '', 'com.ruoyi.system', 'system', 'item', '订单明细', 'ruoyi', '0', '/', NULL, 'admin', '2025-01-11 10:29:08', '', NULL, NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint(20) NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int(11) NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 72 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (56, 9, 'id', '订单主键', 'bigint(20)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (57, 9, 'order_number', '订单编号', 'varchar(50)', 'String', 'orderNumber', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (58, 9, 'user_id', '用户ID', 'bigint(20)', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (59, 9, 'status', '订单状态（0-待支付，1-已支付，2-已完成，3-已取消）', 'tinyint(3)', 'Integer', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', '', 4, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (60, 9, 'total_price', '订单总金额', 'decimal(10,2)', 'BigDecimal', 'totalPrice', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (61, 9, 'create_time', '订单创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 6, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (62, 9, 'update_time', '订单更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (63, 9, 'remark', '备注信息', 'varchar(255)', 'String', 'remark', '0', '0', '0', '1', '1', '1', NULL, 'EQ', 'input', '', 8, 'admin', '2025-01-11 10:29:08', '', '2025-01-11 10:31:20');
INSERT INTO `gen_table_column` VALUES (64, 10, 'id', '明细主键', 'bigint(20)', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (65, 10, 'order_id', '对应订单ID', 'bigint(20)', 'Long', 'orderId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (66, 10, 'product_id', '商品ID', 'bigint(20)', 'Long', 'productId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (67, 10, 'product_name', '商品名称', 'varchar(100)', 'String', 'productName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (68, 10, 'product_price', '商品单价', 'decimal(10,2)', 'BigDecimal', 'productPrice', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 10, 'quantity', '商品数量', 'int(11)', 'Long', 'quantity', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 10, 'total_price', '商品总价（单价×数量）', 'decimal(10,2)', 'BigDecimal', 'totalPrice', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 10, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '1', '1', NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2025-01-11 10:29:08', '', NULL);
INSERT INTO `gen_table_column` VALUES (72, 10, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '1', '1', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2025-01-11 10:29:08', '', NULL);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单主键',
  `order_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `status` tinyint(3) NOT NULL DEFAULT 0 COMMENT '订单状态（0-待支付，1-已支付，2-已完成，3-已取消）',
  `total_price` decimal(10, 2) NOT NULL COMMENT '订单总金额',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '订单创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '订单更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------

-- ----------------------------
-- Table structure for order_item
-- ----------------------------
DROP TABLE IF EXISTS `order_item`;
CREATE TABLE `order_item`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '明细主键',
  `order_id` bigint(20) NOT NULL COMMENT '对应订单ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `product_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商品名称',
  `product_price` decimal(10, 2) NOT NULL COMMENT '商品单价',
  `quantity` int(11) NOT NULL COMMENT '商品数量',
  `total_price` decimal(10, 2) NOT NULL COMMENT '商品总价（单价×数量）',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `update_time` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_order_id`(`order_id`) USING BTREE,
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '订单明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_item
-- ----------------------------

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '产品ID',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '产品名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '产品描述',
  `category` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产品分类',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `stock` int(11) NULL DEFAULT 0 COMMENT '库存',
  `image_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图片地址',
  `created_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '创建时间',
  `updated_time` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '电子产品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
INSERT INTO `product` VALUES (1, '笔记本电脑', '最强游戏本', '电脑', 6999.00, 10, 'https://s2.loli.net/2025/01/03/Z5rStXWemVDqOui.jpg', '2025-01-02 11:26:00', '2025-01-07 15:03:14');
INSERT INTO `product` VALUES (4, 'iPhone16promax', '全新iPhone', '手机', 8999.00, 5, 'https://s2.loli.net/2025/01/04/eKYPxFVqJnSdBQp.jpg', '2025-01-04 11:35:48', '2025-01-07 15:03:27');
INSERT INTO `product` VALUES (5, 'iPadPro2024', '地表最强pad', '平板', 7999.00, 3, 'https://s2.loli.net/2025/01/04/qxDQYiAdbvsFyCE.jpg', '2025-01-04 11:37:02', '2025-01-04 11:37:02');
INSERT INTO `product` VALUES (8, '一加13', '理想型手机', '手机', 4299.00, 10, 'https://s2.loli.net/2025/01/04/HSaxBUmGY9gnL1t.jpg', '2025-01-07 14:45:18', '2025-01-07 14:45:18');
INSERT INTO `product` VALUES (9, 'AirPods4', '最强降噪', '耳机', 1299.00, 2, 'https://s2.loli.net/2025/01/07/hCWtuU96SPr7yjG.jpg', '2025-01-07 14:52:30', '2025-01-07 14:52:30');
INSERT INTO `product` VALUES (10, '本人', '最帅的', '学生', 8888.00, 1, 'https://s2.loli.net/2025/01/07/kBlHfKDjVqhRNCZ.jpg', '2025-01-07 19:59:50', '2025-01-07 19:59:50');

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `blob_data` blob NULL COMMENT '存放持久化Trigger对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Blob类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '日历名称',
  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
  PRIMARY KEY (`sched_name`, `calendar_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '日历信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `cron_expression` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'cron表达式',
  `time_zone_id` varchar(80) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '时区',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = 'Cron类型的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `entry_id` varchar(95) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例id',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度器实例名',
  `fired_time` bigint(13) NOT NULL COMMENT '触发的时间',
  `sched_time` bigint(13) NOT NULL COMMENT '定时器制定的时间',
  `priority` int(11) NOT NULL COMMENT '优先级',
  `state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '任务组名',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否并发',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '是否接受恢复执行',
  PRIMARY KEY (`sched_name`, `entry_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '已触发的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `job_class_name` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '执行任务类名称',
  `is_durable` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否持久化',
  `is_nonconcurrent` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否并发',
  `is_update_data` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否更新数据',
  `requests_recovery` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '是否接受恢复执行',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `lock_name` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '悲观锁名称',
  PRIMARY KEY (`sched_name`, `lock_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '存储的悲观锁信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  PRIMARY KEY (`sched_name`, `trigger_group`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '暂停的触发器表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `instance_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '实例名称',
  `last_checkin_time` bigint(13) NOT NULL COMMENT '上次检查时间',
  `checkin_interval` bigint(13) NOT NULL COMMENT '检查间隔时间',
  PRIMARY KEY (`sched_name`, `instance_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '调度器状态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `repeat_count` bigint(7) NOT NULL COMMENT '重复的次数统计',
  `repeat_interval` bigint(12) NOT NULL COMMENT '重复的间隔时间',
  `times_triggered` bigint(10) NOT NULL COMMENT '已经触发的次数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '简单触发器的信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
  `str_prop_1` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
  `str_prop_2` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
  `str_prop_3` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
  `int_prop_1` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
  `int_prop_2` int(11) NULL DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
  `long_prop_1` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
  `long_prop_2` bigint(20) NULL DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
  `dec_prop_1` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
  `dec_prop_2` decimal(13, 4) NULL DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
  `bool_prop_1` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
  `bool_prop_2` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '同步机制的行锁表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers`  (
  `sched_name` varchar(120) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调度名称',
  `trigger_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的名字',
  `trigger_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器所属组的名字',
  `job_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
  `job_group` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
  `description` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '相关介绍',
  `next_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
  `prev_fire_time` bigint(13) NULL DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
  `priority` int(11) NULL DEFAULT NULL COMMENT '优先级',
  `trigger_state` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器状态',
  `trigger_type` varchar(8) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '触发器的类型',
  `start_time` bigint(13) NOT NULL COMMENT '开始时间',
  `end_time` bigint(13) NULL DEFAULT NULL COMMENT '结束时间',
  `calendar_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日程表名称',
  `misfire_instr` smallint(2) NULL DEFAULT NULL COMMENT '补偿执行的策略',
  `job_data` blob NULL COMMENT '存放持久化job对象',
  PRIMARY KEY (`sched_name`, `trigger_name`, `trigger_group`) USING BTREE,
  INDEX `sched_name`(`sched_name`, `job_name`, `job_group`) USING BTREE,
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '触发器详细信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int(5) NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2024-12-31 21:09:46', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2024-12-31 21:09:46', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2024-12-31 21:09:46', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2024-12-31 21:09:46', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2024-12-31 21:09:46', 'admin', '2025-01-02 09:22:34', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2024-12-31 21:09:46', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '若依科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int(4) NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '停用状态');

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '登录状态列表');

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`, `job_name`, `job_group`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams', '0/10 * * * * ?', '3', '1', '1', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_job` VALUES (2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(\'ry\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_job` VALUES (3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2024-12-31 21:09:46', '', NULL, '');

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log`  (
  `job_log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志信息',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '异常信息',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '定时任务调度日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime(0) NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status`) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 278 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------
INSERT INTO `sys_logininfor` VALUES (100, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2024-12-31 23:04:19');
INSERT INTO `sys_logininfor` VALUES (101, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 09:22:03');
INSERT INTO `sys_logininfor` VALUES (102, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-02 09:22:41');
INSERT INTO `sys_logininfor` VALUES (103, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-01-02 09:22:52');
INSERT INTO `sys_logininfor` VALUES (104, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 09:23:02');
INSERT INTO `sys_logininfor` VALUES (105, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-02 09:23:24');
INSERT INTO `sys_logininfor` VALUES (106, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-01-02 09:23:36');
INSERT INTO `sys_logininfor` VALUES (107, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 09:23:56');
INSERT INTO `sys_logininfor` VALUES (108, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 10:00:11');
INSERT INTO `sys_logininfor` VALUES (109, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 11:01:04');
INSERT INTO `sys_logininfor` VALUES (110, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 15:35:15');
INSERT INTO `sys_logininfor` VALUES (111, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-02 17:31:08');
INSERT INTO `sys_logininfor` VALUES (112, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-02 17:31:11');
INSERT INTO `sys_logininfor` VALUES (113, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 09:15:35');
INSERT INTO `sys_logininfor` VALUES (114, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:25:34');
INSERT INTO `sys_logininfor` VALUES (115, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 10:52:26');
INSERT INTO `sys_logininfor` VALUES (116, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:52:33');
INSERT INTO `sys_logininfor` VALUES (117, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 10:54:49');
INSERT INTO `sys_logininfor` VALUES (118, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:54:57');
INSERT INTO `sys_logininfor` VALUES (119, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 10:55:40');
INSERT INTO `sys_logininfor` VALUES (120, 'ry', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-01-03 10:55:49');
INSERT INTO `sys_logininfor` VALUES (121, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:55:58');
INSERT INTO `sys_logininfor` VALUES (122, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 10:56:29');
INSERT INTO `sys_logininfor` VALUES (123, 'ry', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:56:36');
INSERT INTO `sys_logininfor` VALUES (124, 'ry', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 10:56:59');
INSERT INTO `sys_logininfor` VALUES (125, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 10:57:11');
INSERT INTO `sys_logininfor` VALUES (126, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 11:06:56');
INSERT INTO `sys_logininfor` VALUES (127, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 11:07:21');
INSERT INTO `sys_logininfor` VALUES (128, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 11:08:20');
INSERT INTO `sys_logininfor` VALUES (129, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 11:08:29');
INSERT INTO `sys_logininfor` VALUES (130, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 11:09:27');
INSERT INTO `sys_logininfor` VALUES (131, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-01-03 11:09:37');
INSERT INTO `sys_logininfor` VALUES (132, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-03 11:09:41');
INSERT INTO `sys_logininfor` VALUES (133, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-03 11:09:44');
INSERT INTO `sys_logininfor` VALUES (134, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 11:09:47');
INSERT INTO `sys_logininfor` VALUES (135, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 19:53:35');
INSERT INTO `sys_logininfor` VALUES (136, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 20:34:16');
INSERT INTO `sys_logininfor` VALUES (137, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 20:35:23');
INSERT INTO `sys_logininfor` VALUES (138, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 20:35:33');
INSERT INTO `sys_logininfor` VALUES (139, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 20:35:38');
INSERT INTO `sys_logininfor` VALUES (140, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 20:35:45');
INSERT INTO `sys_logininfor` VALUES (141, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 20:51:28');
INSERT INTO `sys_logininfor` VALUES (142, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 20:51:38');
INSERT INTO `sys_logininfor` VALUES (143, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 21:42:14');
INSERT INTO `sys_logininfor` VALUES (144, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 21:42:23');
INSERT INTO `sys_logininfor` VALUES (145, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 22:19:54');
INSERT INTO `sys_logininfor` VALUES (146, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 22:20:01');
INSERT INTO `sys_logininfor` VALUES (147, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-03 22:23:43');
INSERT INTO `sys_logininfor` VALUES (148, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-03 22:23:54');
INSERT INTO `sys_logininfor` VALUES (149, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:23:16');
INSERT INTO `sys_logininfor` VALUES (150, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-04 11:38:36');
INSERT INTO `sys_logininfor` VALUES (151, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:38:45');
INSERT INTO `sys_logininfor` VALUES (152, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-04 11:39:10');
INSERT INTO `sys_logininfor` VALUES (153, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:39:17');
INSERT INTO `sys_logininfor` VALUES (154, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-04 11:41:29');
INSERT INTO `sys_logininfor` VALUES (155, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:41:37');
INSERT INTO `sys_logininfor` VALUES (156, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:51:53');
INSERT INTO `sys_logininfor` VALUES (157, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-04 11:52:10');
INSERT INTO `sys_logininfor` VALUES (158, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-04 11:52:20');
INSERT INTO `sys_logininfor` VALUES (159, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 09:05:03');
INSERT INTO `sys_logininfor` VALUES (160, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 11:11:52');
INSERT INTO `sys_logininfor` VALUES (161, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-05 11:30:56');
INSERT INTO `sys_logininfor` VALUES (162, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 11:31:02');
INSERT INTO `sys_logininfor` VALUES (163, 'admin', '192.168.230.248', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 11:41:18');
INSERT INTO `sys_logininfor` VALUES (164, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 13:05:53');
INSERT INTO `sys_logininfor` VALUES (165, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 15:10:43');
INSERT INTO `sys_logininfor` VALUES (166, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 18:42:12');
INSERT INTO `sys_logininfor` VALUES (167, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-05 19:16:58');
INSERT INTO `sys_logininfor` VALUES (168, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 19:17:06');
INSERT INTO `sys_logininfor` VALUES (169, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-05 19:17:57');
INSERT INTO `sys_logininfor` VALUES (170, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 19:18:08');
INSERT INTO `sys_logininfor` VALUES (171, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-05 19:18:44');
INSERT INTO `sys_logininfor` VALUES (172, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 19:18:52');
INSERT INTO `sys_logininfor` VALUES (173, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-05 19:19:07');
INSERT INTO `sys_logininfor` VALUES (174, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-05 19:19:14');
INSERT INTO `sys_logininfor` VALUES (175, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-06 13:55:51');
INSERT INTO `sys_logininfor` VALUES (176, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-06 13:56:34');
INSERT INTO `sys_logininfor` VALUES (177, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-06 13:56:41');
INSERT INTO `sys_logininfor` VALUES (178, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-06 13:57:06');
INSERT INTO `sys_logininfor` VALUES (179, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-06 13:57:17');
INSERT INTO `sys_logininfor` VALUES (180, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-06 13:59:17');
INSERT INTO `sys_logininfor` VALUES (181, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-06 14:00:55');
INSERT INTO `sys_logininfor` VALUES (182, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 13:54:32');
INSERT INTO `sys_logininfor` VALUES (183, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 14:40:35');
INSERT INTO `sys_logininfor` VALUES (184, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 14:40:42');
INSERT INTO `sys_logininfor` VALUES (185, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 14:41:25');
INSERT INTO `sys_logininfor` VALUES (186, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-01-07 14:41:32');
INSERT INTO `sys_logininfor` VALUES (187, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 14:41:38');
INSERT INTO `sys_logininfor` VALUES (188, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:05:07');
INSERT INTO `sys_logininfor` VALUES (189, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '注册成功', '2025-01-07 15:05:23');
INSERT INTO `sys_logininfor` VALUES (190, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:05:33');
INSERT INTO `sys_logininfor` VALUES (191, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:05:37');
INSERT INTO `sys_logininfor` VALUES (192, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:05:47');
INSERT INTO `sys_logininfor` VALUES (193, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:17:20');
INSERT INTO `sys_logininfor` VALUES (194, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:17:28');
INSERT INTO `sys_logininfor` VALUES (195, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:20:17');
INSERT INTO `sys_logininfor` VALUES (196, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:20:29');
INSERT INTO `sys_logininfor` VALUES (197, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:36:30');
INSERT INTO `sys_logininfor` VALUES (198, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:36:38');
INSERT INTO `sys_logininfor` VALUES (199, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:53:35');
INSERT INTO `sys_logininfor` VALUES (200, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:53:44');
INSERT INTO `sys_logininfor` VALUES (201, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:56:08');
INSERT INTO `sys_logininfor` VALUES (202, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '用户不存在/密码错误', '2025-01-07 15:56:18');
INSERT INTO `sys_logininfor` VALUES (203, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:56:24');
INSERT INTO `sys_logininfor` VALUES (204, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:56:44');
INSERT INTO `sys_logininfor` VALUES (205, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:56:57');
INSERT INTO `sys_logininfor` VALUES (206, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 15:58:32');
INSERT INTO `sys_logininfor` VALUES (207, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 15:58:45');
INSERT INTO `sys_logininfor` VALUES (208, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:06:17');
INSERT INTO `sys_logininfor` VALUES (209, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:06:26');
INSERT INTO `sys_logininfor` VALUES (210, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:06:58');
INSERT INTO `sys_logininfor` VALUES (211, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:07:04');
INSERT INTO `sys_logininfor` VALUES (212, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:07:21');
INSERT INTO `sys_logininfor` VALUES (213, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:07:28');
INSERT INTO `sys_logininfor` VALUES (214, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:07:36');
INSERT INTO `sys_logininfor` VALUES (215, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:07:43');
INSERT INTO `sys_logininfor` VALUES (216, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:08:27');
INSERT INTO `sys_logininfor` VALUES (217, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:08:36');
INSERT INTO `sys_logininfor` VALUES (218, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:08:44');
INSERT INTO `sys_logininfor` VALUES (219, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:08:51');
INSERT INTO `sys_logininfor` VALUES (220, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:09:17');
INSERT INTO `sys_logininfor` VALUES (221, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:09:21');
INSERT INTO `sys_logininfor` VALUES (222, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:15:05');
INSERT INTO `sys_logininfor` VALUES (223, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:15:18');
INSERT INTO `sys_logininfor` VALUES (224, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:17:35');
INSERT INTO `sys_logininfor` VALUES (225, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:17:42');
INSERT INTO `sys_logininfor` VALUES (226, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:31:40');
INSERT INTO `sys_logininfor` VALUES (227, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:31:47');
INSERT INTO `sys_logininfor` VALUES (228, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:32:51');
INSERT INTO `sys_logininfor` VALUES (229, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:32:59');
INSERT INTO `sys_logininfor` VALUES (230, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:36:01');
INSERT INTO `sys_logininfor` VALUES (231, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-07 16:36:07');
INSERT INTO `sys_logininfor` VALUES (232, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:36:12');
INSERT INTO `sys_logininfor` VALUES (233, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 16:39:51');
INSERT INTO `sys_logininfor` VALUES (234, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 16:40:07');
INSERT INTO `sys_logininfor` VALUES (235, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 19:34:51');
INSERT INTO `sys_logininfor` VALUES (236, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 19:35:12');
INSERT INTO `sys_logininfor` VALUES (237, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 19:35:18');
INSERT INTO `sys_logininfor` VALUES (238, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 19:45:50');
INSERT INTO `sys_logininfor` VALUES (239, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 19:45:54');
INSERT INTO `sys_logininfor` VALUES (240, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 19:56:16');
INSERT INTO `sys_logininfor` VALUES (241, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 19:56:21');
INSERT INTO `sys_logininfor` VALUES (242, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 19:58:18');
INSERT INTO `sys_logininfor` VALUES (243, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 19:58:27');
INSERT INTO `sys_logininfor` VALUES (244, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-07 20:30:45');
INSERT INTO `sys_logininfor` VALUES (245, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-07 20:30:53');
INSERT INTO `sys_logininfor` VALUES (246, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 13:39:43');
INSERT INTO `sys_logininfor` VALUES (247, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 15:10:51');
INSERT INTO `sys_logininfor` VALUES (248, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 15:32:18');
INSERT INTO `sys_logininfor` VALUES (249, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-08 16:02:11');
INSERT INTO `sys_logininfor` VALUES (250, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 16:02:19');
INSERT INTO `sys_logininfor` VALUES (251, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 17:35:43');
INSERT INTO `sys_logininfor` VALUES (252, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 18:22:42');
INSERT INTO `sys_logininfor` VALUES (253, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 19:22:26');
INSERT INTO `sys_logininfor` VALUES (254, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 22:28:57');
INSERT INTO `sys_logininfor` VALUES (255, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-08 23:22:01');
INSERT INTO `sys_logininfor` VALUES (256, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 11:04:17');
INSERT INTO `sys_logininfor` VALUES (257, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 12:17:14');
INSERT INTO `sys_logininfor` VALUES (258, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 15:21:09');
INSERT INTO `sys_logininfor` VALUES (259, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-09 15:38:27');
INSERT INTO `sys_logininfor` VALUES (260, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 15:38:35');
INSERT INTO `sys_logininfor` VALUES (261, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-09 15:45:12');
INSERT INTO `sys_logininfor` VALUES (262, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 15:45:19');
INSERT INTO `sys_logininfor` VALUES (263, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-09 15:46:26');
INSERT INTO `sys_logininfor` VALUES (264, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 15:46:32');
INSERT INTO `sys_logininfor` VALUES (265, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-09 16:05:44');
INSERT INTO `sys_logininfor` VALUES (266, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 16:05:51');
INSERT INTO `sys_logininfor` VALUES (267, 'cwb', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-09 16:07:30');
INSERT INTO `sys_logininfor` VALUES (268, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 16:07:36');
INSERT INTO `sys_logininfor` VALUES (269, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-09 20:08:22');
INSERT INTO `sys_logininfor` VALUES (270, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-09 20:08:25');
INSERT INTO `sys_logininfor` VALUES (271, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 20:08:31');
INSERT INTO `sys_logininfor` VALUES (272, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-09 23:22:27');
INSERT INTO `sys_logininfor` VALUES (273, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-11 09:30:07');
INSERT INTO `sys_logininfor` VALUES (274, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-11 11:14:02');
INSERT INTO `sys_logininfor` VALUES (275, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '退出成功', '2025-01-11 11:14:14');
INSERT INTO `sys_logininfor` VALUES (276, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '1', '验证码错误', '2025-01-11 11:14:20');
INSERT INTO `sys_logininfor` VALUES (277, '程文斌', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-11 11:14:23');
INSERT INTO `sys_logininfor` VALUES (278, 'admin', '127.0.0.1', '内网IP', 'Chrome 13', 'Windows 10', '0', '登录成功', '2025-01-11 16:27:42');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int(4) NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int(1) NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int(1) NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2027 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-12-31 21:09:46', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-12-31 21:09:46', 'admin', '2025-01-02 10:00:46', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-12-31 21:09:46', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-12-31 21:09:46', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-12-31 21:09:46', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-12-31 21:09:46', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-12-31 21:09:46', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-12-31 21:09:46', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-12-31 21:09:46', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-12-31 21:09:46', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-12-31 21:09:46', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-12-31 21:09:46', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-12-31 21:09:46', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-12-31 21:09:46', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-12-31 21:09:46', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-12-31 21:09:46', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-12-31 21:09:46', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-12-31 21:09:46', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-12-31 21:09:46', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-12-31 21:09:46', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-12-31 21:09:46', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-12-31 21:09:46', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-12-31 21:09:46', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-12-31 21:09:46', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1061, '电子产品管理', 1, 10, '/system/product', 'system/product/index', NULL, '', 1, 0, 'C', '0', '0', 'system:product:list', 'table', '', '2025-01-02 11:18:53', 'admin', '2025-01-07 15:30:53', '');
INSERT INTO `sys_menu` VALUES (2000, '电子产品浏览', 1, 11, '/system/product-browse', 'system/product/ProductBrowse', NULL, '', 1, 0, 'C', '0', '0', 'system:product-browse:list', 'example', 'admin', '2025-01-03 22:57:19', 'admin', '2025-01-05 10:02:59', '');
INSERT INTO `sys_menu` VALUES (2001, '购物车', 1, 12, '/system/cart', 'system/product/Cart', NULL, '', 1, 0, 'C', '0', '0', '', 'shopping', 'admin', '2025-01-05 09:26:12', 'admin', '2025-01-05 10:16:43', '');
INSERT INTO `sys_menu` VALUES (2002, '产品新增', 1061, 1, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:product:add', '#', 'admin', '2025-01-07 15:34:32', '程文斌', '2025-01-07 19:43:49', '');
INSERT INTO `sys_menu` VALUES (2006, '产品修改', 1061, 2, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:product:edit', '#', '程文斌', '2025-01-07 19:56:05', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '产品删除', 1061, 3, '', NULL, NULL, '', 1, 0, 'F', '0', '0', 'system:product:remove', '#', 'admin', '2025-01-07 19:57:55', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int(4) NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 若依新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 若依系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int(2) NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int(1) NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int(1) NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime(0) NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint(20) NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type`) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status`) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 245 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_oper_log
-- ----------------------------
INSERT INTO `sys_oper_log` VALUES (100, '参数管理', 2, 'com.ruoyi.web.controller.system.SysConfigController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/config', '127.0.0.1', '内网IP', '{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\",\"createBy\":\"admin\",\"createTime\":\"2024-12-31 21:09:46\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-02 09:22:34', 29);
INSERT INTO `sys_oper_log` VALUES (101, '用户管理', 4, 'com.ruoyi.web.controller.system.SysUserController.insertAuthRole()', 'PUT', 1, 'admin', '研发部门', '/system/user/authRole', '127.0.0.1', '内网IP', '{\"roleIds\":\"2\",\"userId\":\"100\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-02 09:25:11', 21);
INSERT INTO `sys_oper_log` VALUES (102, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2024-12-31 21:09:46\",\"icon\":\"monitor\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2,\"menuName\":\"系统监控\",\"menuType\":\"M\",\"orderNum\":2,\"params\":{},\"parentId\":0,\"path\":\"monitor\",\"perms\":\"\",\"query\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"1\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-02 10:00:46', 48);
INSERT INTO `sys_oper_log` VALUES (103, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"description\":\"最帅的\",\"name\":\"程文斌\",\"price\":200,\"stock\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-02 17:07:48', 149);
INSERT INTO `sys_oper_log` VALUES (104, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:41:30', 10);
INSERT INTO `sys_oper_log` VALUES (105, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"tree-table\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:45:34', 3);
INSERT INTO `sys_oper_log` VALUES (106, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:46:03', 3);
INSERT INTO `sys_oper_log` VALUES (107, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"404\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:46:11', 3);
INSERT INTO `sys_oper_log` VALUES (108, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:46:25', 2);
INSERT INTO `sys_oper_log` VALUES (109, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"0\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"修改菜单\'电子产品管理\'失败，地址必须以http(s)://开头\",\"code\":500}', 0, NULL, '2025-01-03 09:46:43', 2);
INSERT INTO `sys_oper_log` VALUES (110, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"appstore\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 09:49:44', 74);
INSERT INTO `sys_oper_log` VALUES (111, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 09:49:55', 27);
INSERT INTO `sys_oper_log` VALUES (112, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":200,\"stock\":10,\"updatedTime\":\"2025-01-02 17:07:48\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:33:14', 54);
INSERT INTO `sys_oper_log` VALUES (113, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 11:26:00\",\"description\":\"必须的\",\"id\":1,\"imageUrl\":\"https://s2.loli.net/2025/01/03/Z5rStXWemVDqOui.jpg\",\"name\":\"笔记本电脑\",\"price\":4000,\"stock\":10,\"updatedTime\":\"2025-01-02 17:01:20\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:37:21', 76);
INSERT INTO `sys_oper_log` VALUES (114, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 11:26:00\",\"description\":\"必须的\",\"id\":1,\"imageUrl\":\"https://s2.loli.net/2025/01/03/Z5rStXWemVDqOui.jpg\",\"name\":\"笔记本电脑\",\"price\":4001,\"stock\":10,\"updatedTime\":\"2025-01-03 10:37:21\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:39:27', 8);
INSERT INTO `sys_oper_log` VALUES (115, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":888888888,\"stock\":1,\"updatedTime\":\"2025-01-03 10:33:14\"}', NULL, 1, '\r\n### Error updating database.  Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'price\' at row 1\r\n### The error may exist in file [D:\\java-learn\\RuoYi-Vue-master\\ruoyi-system\\target\\classes\\mapper\\system\\ProductMapper.xml]\r\n### The error may involve defaultParameterMap\r\n### The error occurred while setting parameters\r\n### SQL: UPDATE product         SET name = ?, description = ?,             price = ?, stock = ?, image_url = ?,             updated_time = NOW()         WHERE id = ?\r\n### Cause: com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'price\' at row 1\n; Data truncation: Out of range value for column \'price\' at row 1; nested exception is com.mysql.cj.jdbc.exceptions.MysqlDataTruncation: Data truncation: Out of range value for column \'price\' at row 1', '2025-01-03 10:39:46', 35);
INSERT INTO `sys_oper_log` VALUES (116, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":888888,\"stock\":1,\"updatedTime\":\"2025-01-03 10:33:14\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:39:49', 17);
INSERT INTO `sys_oper_log` VALUES (117, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'cwb', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/01/03/微信图片_20250103102904_20250103105335A001.jpg\",\"code\":200}', 0, NULL, '2025-01-03 10:53:35', 85);
INSERT INTO `sys_oper_log` VALUES (118, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, 'cwb', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/01/03/微信图片_20250103102904_20250103105407A002.jpg\",\"code\":200}', 0, NULL, '2025-01-03 10:54:07', 44);
INSERT INTO `sys_oper_log` VALUES (119, '个人信息', 2, 'com.ruoyi.web.controller.system.SysProfileController.updateProfile()', 'PUT', 1, 'cwb', NULL, '/system/user/profile', '127.0.0.1', '内网IP', '{\"admin\":false,\"email\":\"2317552732@qq.com\",\"nickName\":\"cwb\",\"params\":{},\"phonenumber\":\"18935110156\",\"sex\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:54:40', 24);
INSERT INTO `sys_oper_log` VALUES (120, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/avatar/2025/01/03/微信图片_20250103102904_20250103105407A002.jpg\",\"createBy\":\"\",\"createTime\":\"2025-01-02 09:22:52\",\"delFlag\":\"0\",\"deptId\":100,\"email\":\"2317552732@qq.com\",\"loginDate\":\"2025-01-02 09:23:02\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"cwb\",\"params\":{},\"phonenumber\":\"18935110156\",\"postIds\":[1],\"remark\":\"本人\",\"roleIds\":[2],\"roles\":[{\"admin\":false,\"dataScope\":\"2\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":100,\"userName\":\"cwb\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:55:27', 21);
INSERT INTO `sys_oper_log` VALUES (121, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.resetPwd()', 'PUT', 1, 'cwb', '若依科技', '/system/user/resetPwd', '127.0.0.1', '内网IP', '{\"admin\":false,\"params\":{},\"updateBy\":\"cwb\",\"userId\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 10:56:24', 180);
INSERT INTO `sys_oper_log` VALUES (122, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.dataScope()', 'PUT', 1, 'admin', '研发部门', '/system/role/dataScope', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 11:08:17', 59);
INSERT INTO `sys_oper_log` VALUES (123, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":888888,\"stock\":1,\"updatedTime\":\"2025-01-03 10:39:49\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 11:31:21', 73);
INSERT INTO `sys_oper_log` VALUES (124, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"人\",\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":888888,\"stock\":1,\"updatedTime\":\"2025-01-03 11:31:21\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 11:36:12', 98);
INSERT INTO `sys_oper_log` VALUES (125, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"情侣\",\"description\":\"美\",\"imageUrl\":\"梁华阳\",\"name\":\"恩爱组\",\"price\":99999999,\"stock\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 22:30:05', 80);
INSERT INTO `sys_oper_log` VALUES (126, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"情侣\",\"createdTime\":\"2025-01-03 22:30:04\",\"description\":\"美\",\"id\":3,\"imageUrl\":\"https://s2.loli.net/2025/01/03/OjmyCSDvq8PTBeK.jpg\",\"name\":\"恩爱组\",\"price\":99999999,\"stock\":1,\"updatedTime\":\"2025-01-03 22:30:04\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 22:30:44', 58);
INSERT INTO `sys_oper_log` VALUES (127, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"电子产品浏览\",\"menuType\":\"M\",\"orderNum\":7,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse/index\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-03 22:57:19', 86);
INSERT INTO `sys_oper_log` VALUES (128, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-01-03 22:57:19\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"电子产品浏览\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:26:43', 51);
INSERT INTO `sys_oper_log` VALUES (129, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/ProductBrowse\",\"createTime\":\"2025-01-03 22:57:19\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"电子产品浏览\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:27:44', 77);
INSERT INTO `sys_oper_log` VALUES (130, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/ProductBrowse\",\"createTime\":\"2025-01-03 22:57:19\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"电子产品浏览\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse\",\"perms\":\"system:product-browse:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:31:28', 16);
INSERT INTO `sys_oper_log` VALUES (131, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"其他\",\"createdTime\":\"2025-01-03 22:30:04\",\"description\":\"美\",\"id\":3,\"imageUrl\":\"https://s2.loli.net/2025/01/03/OjmyCSDvq8PTBeK.jpg\",\"name\":\"恩爱组\",\"price\":99999999,\"stock\":1,\"updatedTime\":\"2025-01-03 22:30:44\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:34:03', 86);
INSERT INTO `sys_oper_log` VALUES (132, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"其他\",\"createdTime\":\"2025-01-02 17:07:48\",\"description\":\"最帅的\",\"id\":2,\"imageUrl\":\"https://s2.loli.net/2025/01/03/DzbJdEaHC5lUsvG.jpg\",\"name\":\"程文斌\",\"price\":888888,\"stock\":1,\"updatedTime\":\"2025-01-03 11:36:12\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:34:08', 12);
INSERT INTO `sys_oper_log` VALUES (133, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"手机\",\"description\":\"全新一代iPhone\",\"imageUrl\":\"https://s2.loli.net/2025/01/04/eKYPxFVqJnSdBQp.jpg\",\"name\":\"iPhone16promax\",\"price\":8999,\"stock\":5}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:35:48', 44);
INSERT INTO `sys_oper_log` VALUES (134, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"平板\",\"description\":\"地表最强pad\",\"imageUrl\":\"https://s2.loli.net/2025/01/04/qxDQYiAdbvsFyCE.jpg\",\"name\":\"iPadPro2024\",\"price\":7999,\"stock\":3}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:37:02', 90);
INSERT INTO `sys_oper_log` VALUES (135, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"手机\",\"description\":\"理想型手机\",\"imageUrl\":\"https://s2.loli.net/2025/01/04/HSaxBUmGY9gnL1t.jpg\",\"name\":\"一加13\",\"price\":4299,\"stock\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:37:43', 59);
INSERT INTO `sys_oper_log` VALUES (136, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/ProductBrowse\",\"createTime\":\"2025-01-03 22:57:19\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"电子产品浏览\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse\",\"perms\":\"system:product-browse:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:38:16', 103);
INSERT INTO `sys_oper_log` VALUES (137, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,1061,2000,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-04 11:41:26', 80);
INSERT INTO `sys_oper_log` VALUES (138, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":8,\"params\":{},\"parentId\":1,\"path\":\"/cart/index\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 09:26:12', 46);
INSERT INTO `sys_oper_log` VALUES (139, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":6,\"params\":{},\"parentId\":1,\"path\":\"/cart/index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 09:26:33', 30);
INSERT INTO `sys_oper_log` VALUES (140, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/cart/index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 09:26:51', 37);
INSERT INTO `sys_oper_log` VALUES (141, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/Cart\",\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/cart/index\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 09:47:09', 38);
INSERT INTO `sys_oper_log` VALUES (142, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/Cart\",\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/cart\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:00:37', 74);
INSERT INTO `sys_oper_log` VALUES (143, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/Cart\",\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":5,\"params\":{},\"parentId\":1,\"path\":\"/system/cart\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:01:35', 28);
INSERT INTO `sys_oper_log` VALUES (144, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:02:53', 106);
INSERT INTO `sys_oper_log` VALUES (145, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/ProductBrowse\",\"createTime\":\"2025-01-03 22:57:19\",\"icon\":\"example\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2000,\"menuName\":\"电子产品浏览\",\"menuType\":\"C\",\"orderNum\":11,\"params\":{},\"parentId\":1,\"path\":\"/system/product-browse\",\"perms\":\"system:product-browse:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:02:59', 11);
INSERT INTO `sys_oper_log` VALUES (146, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/Cart\",\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":12,\"params\":{},\"parentId\":1,\"path\":\"/system/cart\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:03:04', 14);
INSERT INTO `sys_oper_log` VALUES (147, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/Cart\",\"createTime\":\"2025-01-05 09:26:12\",\"icon\":\"shopping\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2001,\"menuName\":\"购物车\",\"menuType\":\"C\",\"orderNum\":12,\"params\":{},\"parentId\":1,\"path\":\"/system/cart\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 10:16:43', 114);
INSERT INTO `sys_oper_log` VALUES (148, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,1061,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-05 19:16:55', 73);
INSERT INTO `sys_oper_log` VALUES (149, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"其他\",\"createdTime\":\"2025-01-03 22:30:04\",\"description\":\"美\",\"id\":3,\"imageUrl\":\"https://s2.loli.net/2025/01/03/OjmyCSDvq8PTBeK.jpg\",\"name\":\"恩爱组\",\"price\":99999990,\"stock\":1,\"updatedTime\":\"2025-01-04 11:34:03\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 13:57:33', 76);
INSERT INTO `sys_oper_log` VALUES (150, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"其他\",\"createdTime\":\"2025-01-03 22:30:04\",\"description\":\"美\",\"id\":3,\"imageUrl\":\"https://s2.loli.net/2025/01/03/OjmyCSDvq8PTBeK.jpg\",\"name\":\"恩爱组\",\"price\":99999900,\"stock\":1,\"updatedTime\":\"2025-01-07 13:57:33\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:06:50', 32);
INSERT INTO `sys_oper_log` VALUES (151, '电子产品管理', 3, 'com.ruoyi.web.controller.system.ProductController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:40:10', 45);
INSERT INTO `sys_oper_log` VALUES (152, '电子产品管理', 3, 'com.ruoyi.web.controller.system.ProductController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '[6]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:43:48', 87);
INSERT INTO `sys_oper_log` VALUES (153, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"手机\",\"description\":\"理想型手机\",\"imageUrl\":\"https://s2.loli.net/2025/01/04/HSaxBUmGY9gnL1t.jpg\",\"name\":\"一加13\",\"price\":4299,\"stock\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:44:08', 27);
INSERT INTO `sys_oper_log` VALUES (154, '电子产品管理', 3, 'com.ruoyi.web.controller.system.ProductController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '[7]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:44:55', 89);
INSERT INTO `sys_oper_log` VALUES (155, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"手机\",\"description\":\"理想型手机\",\"imageUrl\":\"https://s2.loli.net/2025/01/04/HSaxBUmGY9gnL1t.jpg\",\"name\":\"一加13\",\"price\":4299,\"stock\":10}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:45:18', 38);
INSERT INTO `sys_oper_log` VALUES (156, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"耳机\",\"description\":\"最强降噪\",\"imageUrl\":\"https://s2.loli.net/2025/01/07/hCWtuU96SPr7yjG.jpg\",\"name\":\"AirPods4\",\"price\":1299,\"stock\":2}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 14:52:30', 81);
INSERT INTO `sys_oper_log` VALUES (157, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"电脑\",\"createdTime\":\"2025-01-02 11:26:00\",\"description\":\"最强游戏本\",\"id\":1,\"imageUrl\":\"https://s2.loli.net/2025/01/03/Z5rStXWemVDqOui.jpg\",\"name\":\"笔记本电脑\",\"price\":6999,\"stock\":10,\"updatedTime\":\"2025-01-03 10:39:27\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:03:14', 68);
INSERT INTO `sys_oper_log` VALUES (158, '电子产品管理', 2, 'com.ruoyi.web.controller.system.ProductController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"手机\",\"createdTime\":\"2025-01-04 11:35:48\",\"description\":\"全新iPhone\",\"id\":4,\"imageUrl\":\"https://s2.loli.net/2025/01/04/eKYPxFVqJnSdBQp.jpg\",\"name\":\"iPhone16promax\",\"price\":8999,\"stock\":5,\"updatedTime\":\"2025-01-04 11:35:48\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:03:27', 58);
INSERT INTO `sys_oper_log` VALUES (159, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"\",\"createBy\":\"\",\"createTime\":\"2025-01-07 15:05:23\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-01-07 15:05:33\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"程文斌\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"roleIds\":[2],\"roles\":[],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"程文斌\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:06:07', 30);
INSERT INTO `sys_oper_log` VALUES (160, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:08:22', 29);
INSERT INTO `sys_oper_log` VALUES (161, '用户管理', 4, 'com.ruoyi.web.controller.system.SysUserController.insertAuthRole()', 'PUT', 1, 'admin', '研发部门', '/system/user/authRole', '127.0.0.1', '内网IP', '{\"roleIds\":\"100\",\"userId\":\"101\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:16:03', 58);
INSERT INTO `sys_oper_log` VALUES (162, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:17:13', 88);
INSERT INTO `sys_oper_log` VALUES (163, '用户头像', 2, 'com.ruoyi.web.controller.system.SysProfileController.avatar()', 'POST', 1, '程文斌', NULL, '/system/user/profile/avatar', '127.0.0.1', '内网IP', '', '{\"msg\":\"操作成功\",\"imgUrl\":\"/profile/avatar/2025/01/07/微信图片_20250107151857_20250107151914A001.jpg\",\"code\":200}', 0, NULL, '2025-01-07 15:19:14', 120);
INSERT INTO `sys_oper_log` VALUES (164, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:22:07', 91);
INSERT INTO `sys_oper_log` VALUES (165, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"M\",\"orderNum\":10,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:30:03', 72);
INSERT INTO `sys_oper_log` VALUES (166, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/product/index\",\"createTime\":\"2025-01-02 11:18:53\",\"icon\":\"table\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":1061,\"menuName\":\"电子产品管理\",\"menuType\":\"C\",\"orderNum\":10,\"params\":{},\"parentId\":1,\"path\":\"/system/product\",\"perms\":\"system:product:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:30:53', 14);
INSERT INTO `sys_oper_log` VALUES (167, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品操作\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:operation\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:34:32', 29);
INSERT INTO `sys_oper_log` VALUES (168, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-01-07 15:34:32\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"产品操作\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"path\":\"\",\"perms\":\"system:product:operation\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:35:13', 59);
INSERT INTO `sys_oper_log` VALUES (169, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:36:08', 42);
INSERT INTO `sys_oper_log` VALUES (170, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, '程文斌', NULL, '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"程文斌\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:37:12', 110);
INSERT INTO `sys_oper_log` VALUES (171, '用户管理', 5, 'com.ruoyi.web.controller.system.SysUserController.export()', 'POST', 1, '程文斌', NULL, '/system/user/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-01-07 15:37:39', 498);
INSERT INTO `sys_oper_log` VALUES (172, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, '程文斌', NULL, '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"程文斌\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:55:30', 44);
INSERT INTO `sys_oper_log` VALUES (173, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:56:41', 108);
INSERT INTO `sys_oper_log` VALUES (174, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:59:18', 37);
INSERT INTO `sys_oper_log` VALUES (175, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:59:44', 110);
INSERT INTO `sys_oper_log` VALUES (176, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2000,2001],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 15:59:57', 13);
INSERT INTO `sys_oper_log` VALUES (177, '角色管理', 5, 'com.ruoyi.web.controller.system.SysRoleController.export()', 'POST', 1, 'admin', '研发部门', '/system/role/export', '127.0.0.1', '内网IP', '{\"pageSize\":\"10\",\"pageNum\":\"1\"}', NULL, 0, NULL, '2025-01-07 16:00:12', 25);
INSERT INTO `sys_oper_log` VALUES (178, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":true,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114,3,115,116,1055,1056,1057,1058,1059,1060,117],\"params\":{},\"remark\":\"超级管理员\",\"roleId\":1,\"roleKey\":\"admin\",\"roleName\":\"超级管理员\",\"roleSort\":1,\"status\":\"0\"}', NULL, 1, '不允许操作超级管理员角色', '2025-01-07 16:01:22', 1);
INSERT INTO `sys_oper_log` VALUES (179, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2025-01-07 16:01:47', 3);
INSERT INTO `sys_oper_log` VALUES (180, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2025-01-07 16:02:07', 2);
INSERT INTO `sys_oper_log` VALUES (181, '角色管理', 1, 'com.ruoyi.web.controller.system.SysRoleController.add()', 'POST', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createBy\":\"admin\",\"deptCheckStrictly\":true,\"deptIds\":[],\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,103,1016,1017,1018,1019,104,1020,1021,1022,1023,1024,105,1025,1026,1027,1028,1029,106,1030,1031,1032,1033,1034,107,1035,1036,1037,1038,108,500,1039,1040,1041,501,1042,1043,1044,1045,1061,2002,2000,2001],\"params\":{},\"roleId\":101,\"roleKey\":\"AAdmin\",\"roleName\":\"管理员\",\"roleSort\":4,\"status\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:05:55', 36);
INSERT INTO `sys_oper_log` VALUES (182, '用户管理', 2, 'com.ruoyi.web.controller.system.SysUserController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/user', '127.0.0.1', '内网IP', '{\"admin\":false,\"avatar\":\"/profile/avatar/2025/01/07/微信图片_20250107151857_20250107151914A001.jpg\",\"createBy\":\"\",\"createTime\":\"2025-01-07 15:05:23\",\"delFlag\":\"0\",\"email\":\"\",\"loginDate\":\"2025-01-07 15:56:57\",\"loginIp\":\"127.0.0.1\",\"nickName\":\"程文斌\",\"params\":{},\"phonenumber\":\"\",\"postIds\":[],\"roleIds\":[100,101],\"roles\":[{\"admin\":false,\"dataScope\":\"1\",\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\"}],\"sex\":\"0\",\"status\":\"0\",\"updateBy\":\"admin\",\"userId\":101,\"userName\":\"程文斌\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:06:09', 10);
INSERT INTO `sys_oper_log` VALUES (183, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/101', '127.0.0.1', '内网IP', '[101]', NULL, 1, '管理员已分配,不能删除', '2025-01-07 16:09:30', 4);
INSERT INTO `sys_oper_log` VALUES (184, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/101', '127.0.0.1', '内网IP', '[101]', NULL, 1, '管理员已分配,不能删除', '2025-01-07 16:09:34', 2);
INSERT INTO `sys_oper_log` VALUES (185, '用户管理', 4, 'com.ruoyi.web.controller.system.SysUserController.insertAuthRole()', 'PUT', 1, 'admin', '研发部门', '/system/user/authRole', '127.0.0.1', '内网IP', '{\"roleIds\":\"100\",\"userId\":\"101\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:09:56', 107);
INSERT INTO `sys_oper_log` VALUES (186, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.changeStatus()', 'PUT', 1, 'admin', '研发部门', '/system/role/changeStatus', '127.0.0.1', '内网IP', '{\"admin\":false,\"deptCheckStrictly\":false,\"flag\":false,\"menuCheckStrictly\":false,\"params\":{},\"roleId\":101,\"status\":\"1\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:10:05', 19);
INSERT INTO `sys_oper_log` VALUES (187, '角色管理', 3, 'com.ruoyi.web.controller.system.SysRoleController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/role/101', '127.0.0.1', '内网IP', '[101]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:10:07', 12);
INSERT INTO `sys_oper_log` VALUES (188, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2002', '127.0.0.1', '内网IP', '2002', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2025-01-07 16:10:34', 2);
INSERT INTO `sys_oper_log` VALUES (189, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":false,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 16:13:39', 89);
INSERT INTO `sys_oper_log` VALUES (190, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createTime\":\"2025-01-07 15:34:32\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2002,\"menuName\":\"产品新增\",\"menuType\":\"F\",\"orderNum\":1,\"params\":{},\"parentId\":1061,\"path\":\"\",\"perms\":\"system:product:add\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"程文斌\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:43:49', 33);
INSERT INTO `sys_oper_log` VALUES (191, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"程文斌\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品编辑\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:44:50', 89);
INSERT INTO `sys_oper_log` VALUES (192, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品编辑\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"新增菜单\'产品编辑\'失败，菜单名称已存在\",\"code\":500}', 0, NULL, '2025-01-07 19:45:40', 3);
INSERT INTO `sys_oper_log` VALUES (193, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品编辑\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"新增菜单\'产品编辑\'失败，菜单名称已存在\",\"code\":500}', 0, NULL, '2025-01-07 19:49:16', 3);
INSERT INTO `sys_oper_log` VALUES (194, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"程文斌\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品操作\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:51:35', 169);
INSERT INTO `sys_oper_log` VALUES (195, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"程文斌\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品操作\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:53:58', 15);
INSERT INTO `sys_oper_log` VALUES (196, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, '程文斌', NULL, '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"程文斌\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品修改\",\"menuType\":\"F\",\"orderNum\":2,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:edit\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:56:05', 14);
INSERT INTO `sys_oper_log` VALUES (197, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"产品删除\",\"menuType\":\"F\",\"orderNum\":3,\"params\":{},\"parentId\":1061,\"perms\":\"system:product:remove\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:57:55', 75);
INSERT INTO `sys_oper_log` VALUES (198, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2006,2007,2000,2001,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:58:14', 59);
INSERT INTO `sys_oper_log` VALUES (199, '电子产品管理', 3, 'com.ruoyi.web.controller.system.ProductController.remove()', 'DELETE', 1, '程文斌', NULL, '/system/product', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:58:41', 66);
INSERT INTO `sys_oper_log` VALUES (200, '电子产品管理', 1, 'com.ruoyi.web.controller.system.ProductController.add()', 'POST', 1, '程文斌', NULL, '/system/product', '127.0.0.1', '内网IP', '{\"category\":\"学生\",\"description\":\"最帅的\",\"imageUrl\":\"https://s2.loli.net/2025/01/07/kBlHfKDjVqhRNCZ.jpg\",\"name\":\"本人\",\"price\":8888,\"stock\":1}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 19:59:50', 89);
INSERT INTO `sys_oper_log` VALUES (201, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"我的订单\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":1,\"path\":\"/system/order/myorder\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:34:04', 37);
INSERT INTO `sys_oper_log` VALUES (202, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/myorder/index\",\"createTime\":\"2025-01-07 20:34:04\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"我的订单\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":1,\"path\":\"/system/order/myorder\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:37:44', 44);
INSERT INTO `sys_oper_log` VALUES (203, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/myorder/index\",\"createTime\":\"2025-01-07 20:34:04\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"我的订单\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":1,\"path\":\"/system/order/myorder\",\"perms\":\"system:order:myorder:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:38:53', 29);
INSERT INTO `sys_oper_log` VALUES (204, '菜单管理', 1, 'com.ruoyi.web.controller.system.SysMenuController.add()', 'POST', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"createBy\":\"admin\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"/system/order/list\",\"status\":\"0\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:50:12', 55);
INSERT INTO `sys_oper_log` VALUES (205, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/list/index\",\"createTime\":\"2025-01-07 20:50:12\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"/system/order/list\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:50:39', 112);
INSERT INTO `sys_oper_log` VALUES (206, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/list/index\",\"createTime\":\"2025-01-07 20:50:12\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"/system/order/list\",\"perms\":\"system:order:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:52:15', 9);
INSERT INTO `sys_oper_log` VALUES (207, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/list/index\",\"createTime\":\"2025-01-07 20:50:12\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"/system/order/list\",\"perms\":\"system:order:list:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:52:59', 82);
INSERT INTO `sys_oper_log` VALUES (208, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/order/list/index\",\"createTime\":\"2025-01-07 20:50:12\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"/system/order/list\",\"perms\":\"system:order:list:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-07 20:55:43', 102);
INSERT INTO `sys_oper_log` VALUES (209, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2006,2007,2000,2001,2008,2009,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-08 16:01:54', 122);
INSERT INTO `sys_oper_log` VALUES (210, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2000,2001,2008],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-08 16:02:02', 58);
INSERT INTO `sys_oper_log` VALUES (211, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, '程文斌', NULL, '/system/menu/2008', '127.0.0.1', '内网IP', '2008', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2025-01-09 12:17:55', 9);
INSERT INTO `sys_oper_log` VALUES (212, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2025-01-07 15:08:22\",\"dataScope\":\"1\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,100,1000,1001,1002,1003,1004,1005,1006,101,1007,1008,1009,1010,1011,102,1012,1013,1014,1015,1061,2002,2006,2007,2000,2001,2008,2009,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"roleId\":100,\"roleKey\":\"normal_admin\",\"roleName\":\"普通管理员\",\"roleSort\":3,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 15:45:09', 122);
INSERT INTO `sys_oper_log` VALUES (213, '角色管理', 2, 'com.ruoyi.web.controller.system.SysRoleController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/role', '127.0.0.1', '内网IP', '{\"admin\":false,\"createTime\":\"2024-12-31 21:09:46\",\"dataScope\":\"5\",\"delFlag\":\"0\",\"deptCheckStrictly\":true,\"flag\":false,\"menuCheckStrictly\":true,\"menuIds\":[1,2000,2001,2008,2,109,1046,1047,1048,110,1049,1050,1051,1052,1053,1054,111,112,113,114],\"params\":{},\"remark\":\"普通角色\",\"roleId\":2,\"roleKey\":\"common\",\"roleName\":\"普通角色\",\"roleSort\":2,\"status\":\"0\",\"updateBy\":\"admin\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:05:40', 47);
INSERT INTO `sys_oper_log` VALUES (214, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"product\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:28:37', 55);
INSERT INTO `sys_oper_log` VALUES (215, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"product\"}', NULL, 0, NULL, '2025-01-09 16:28:46', 274);
INSERT INTO `sys_oper_log` VALUES (216, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/1', '127.0.0.1', '内网IP', '[1]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:29:31', 75);
INSERT INTO `sys_oper_log` VALUES (217, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"sys_order_item,sys_order\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:29:47', 37);
INSERT INTO `sys_oper_log` VALUES (218, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/2', '127.0.0.1', '内网IP', '[2]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:35:41', 58);
INSERT INTO `sys_oper_log` VALUES (219, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/3', '127.0.0.1', '内网IP', '[3]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 16:35:42', 16);
INSERT INTO `sys_oper_log` VALUES (220, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 20:09:13', 69);
INSERT INTO `sys_oper_log` VALUES (221, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"order\",\"className\":\"Order\",\"columns\":[{\"capJavaField\":\"OrderId\",\"columnComment\":\"订单ID（主键）\",\"columnId\":26,\"columnName\":\"order_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID（关联sys_user表）\",\"columnId\":27,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderStatus\",\"columnComment\":\"订单状态（0:待支付，1:已支付，2:已发货，3:已完成，4:已取消）\",\"columnId\":28,\"columnName\":\"order_status\",\"columnType\":\"tinyint(4)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"orderStatus\",\"javaType\":\"Integer\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TotalAmount\",\"columnComment\":\"订单总金额\",\"columnId\":29,\"columnName\":\"total_amount\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInse', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 20:29:37', 110);
INSERT INTO `sys_oper_log` VALUES (222, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-09 20:31:44', 81);
INSERT INTO `sys_oper_log` VALUES (223, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"order\",\"className\":\"Order\",\"columns\":[{\"capJavaField\":\"OrderId\",\"columnComment\":\"订单ID（主键）\",\"columnId\":26,\"columnName\":\"order_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:29:37\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID（关联sys_user表）\",\"columnId\":27,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:29:37\",\"usableColumn\":false},{\"capJavaField\":\"OrderStatus\",\"columnComment\":\"订单状态（0:待支付，1:已支付，2:已发货，3:已完成，4:已取消）\",\"columnId\":28,\"columnName\":\"order_status\",\"columnType\":\"tinyint(4)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"orderStatus\",\"javaType\":\"Integer\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:29:37\",\"usableColumn\":false},{\"capJavaField\":\"TotalAmount\",\"columnComment\":\"订单总金额\",\"columnId\":29,\"columnName\":\"total_amount\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 20:35:08', 44);
INSERT INTO `sys_oper_log` VALUES (224, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-09 20:36:15', 27);
INSERT INTO `sys_oper_log` VALUES (225, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-09 20:58:11', 28);
INSERT INTO `sys_oper_log` VALUES (226, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-09 21:13:06', 24);
INSERT INTO `sys_oper_log` VALUES (227, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"order\",\"className\":\"Order\",\"columns\":[{\"capJavaField\":\"OrderId\",\"columnComment\":\"订单ID（主键）\",\"columnId\":26,\"columnName\":\"order_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:35:08\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID（关联sys_user表）\",\"columnId\":27,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:35:08\",\"usableColumn\":false},{\"capJavaField\":\"OrderStatus\",\"columnComment\":\"订单状态（0:待支付，1:已支付，2:已发货，3:已完成，4:已取消）\",\"columnId\":28,\"columnName\":\"order_status\",\"columnType\":\"tinyint(4)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"orderStatus\",\"javaType\":\"Integer\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":4,\"updateBy\":\"\",\"updateTime\":\"2025-01-09 20:35:08\",\"usableColumn\":false},{\"capJavaField\":\"TotalAmount\",\"columnComment\":\"订单总金额\",\"columnId\":29,\"columnName\":\"total_amount\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-09 20:09:13\",\"dictType\"', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-09 23:23:03', 176);
INSERT INTO `sys_oper_log` VALUES (228, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-09 23:23:06', 288);
INSERT INTO `sys_oper_log` VALUES (229, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2025-01-07 20:34:04\",\"icon\":\"post\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2008,\"menuName\":\"我的订单\",\"menuType\":\"C\",\"orderNum\":13,\"params\":{},\"parentId\":1,\"path\":\"myorder\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 09:31:05', 25);
INSERT INTO `sys_oper_log` VALUES (230, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"\",\"createTime\":\"2025-01-07 20:50:12\",\"icon\":\"druid\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2009,\"menuName\":\"订单管理\",\"menuType\":\"C\",\"orderNum\":14,\"params\":{},\"parentId\":1,\"path\":\"order\",\"perms\":\"\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 09:31:15', 11);
INSERT INTO `sys_oper_log` VALUES (231, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-11 09:32:33', 293);
INSERT INTO `sys_oper_log` VALUES (232, '菜单管理', 2, 'com.ruoyi.web.controller.system.SysMenuController.edit()', 'PUT', 1, 'admin', '研发部门', '/system/menu', '127.0.0.1', '内网IP', '{\"children\":[],\"component\":\"system/ruoyi-order/order/index\",\"createTime\":\"2025-01-11 09:39:38\",\"icon\":\"#\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuId\":2010,\"menuName\":\"订单\",\"menuType\":\"C\",\"orderNum\":1,\"params\":{},\"parentId\":1,\"path\":\"order\",\"perms\":\"ruoyi-order:order:list\",\"routeName\":\"\",\"status\":\"0\",\"updateBy\":\"admin\",\"visible\":\"0\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 09:44:05', 15);
INSERT INTO `sys_oper_log` VALUES (233, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/4', '127.0.0.1', '内网IP', '[4]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:03:48', 44);
INSERT INTO `sys_oper_log` VALUES (234, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"order,order_item\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:03:54', 87);
INSERT INTO `sys_oper_log` VALUES (235, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"order\",\"className\":\"Order\",\"columns\":[{\"capJavaField\":\"OrderId\",\"columnComment\":\"订单ID（主键）\",\"columnId\":32,\"columnName\":\"order_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:03:54\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"orderId\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID（关联sys_user表）\",\"columnId\":33,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:03:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderStatus\",\"columnComment\":\"订单状态（0:待支付，1:已支付，2:已发货，3:已完成，4:已取消）\",\"columnId\":34,\"columnName\":\"order_status\",\"columnType\":\"tinyint(4)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:03:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"orderStatus\",\"javaType\":\"Integer\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":5,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"TotalAmount\",\"columnComment\":\"订单总金额\",\"columnId\":35,\"columnName\":\"total_amount\",\"columnType\":\"decimal(10,2)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:03:54\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInse', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:08:34', 73);
INSERT INTO `sys_oper_log` VALUES (236, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-11 10:08:41', 177);
INSERT INTO `sys_oper_log` VALUES (237, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/6', '127.0.0.1', '内网IP', '[6]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:24:58', 39);
INSERT INTO `sys_oper_log` VALUES (238, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/5', '127.0.0.1', '内网IP', '[5]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:24:59', 10);
INSERT INTO `sys_oper_log` VALUES (239, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"order,order_item\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:25:04', 81);
INSERT INTO `sys_oper_log` VALUES (240, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/7', '127.0.0.1', '内网IP', '[7]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:27:09', 44);
INSERT INTO `sys_oper_log` VALUES (241, '代码生成', 3, 'com.ruoyi.generator.controller.GenController.remove()', 'DELETE', 1, 'admin', '研发部门', '/tool/gen/8', '127.0.0.1', '内网IP', '[8]', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:27:10', 14);
INSERT INTO `sys_oper_log` VALUES (242, '代码生成', 6, 'com.ruoyi.generator.controller.GenController.importTableSave()', 'POST', 1, 'admin', '研发部门', '/tool/gen/importTable', '127.0.0.1', '内网IP', '{\"tables\":\"order,order_item\"}', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:29:08', 62);
INSERT INTO `sys_oper_log` VALUES (243, '代码生成', 2, 'com.ruoyi.generator.controller.GenController.editSave()', 'PUT', 1, 'admin', '研发部门', '/tool/gen', '127.0.0.1', '内网IP', '{\"businessName\":\"order\",\"className\":\"Order\",\"columns\":[{\"capJavaField\":\"Id\",\"columnComment\":\"订单主键\",\"columnId\":56,\"columnName\":\"id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:29:08\",\"dictType\":\"\",\"edit\":false,\"htmlType\":\"input\",\"increment\":true,\"insert\":true,\"isIncrement\":\"1\",\"isInsert\":\"1\",\"isPk\":\"1\",\"isRequired\":\"0\",\"javaField\":\"id\",\"javaType\":\"Long\",\"list\":false,\"params\":{},\"pk\":true,\"query\":false,\"queryType\":\"EQ\",\"required\":false,\"sort\":1,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"OrderNumber\",\"columnComment\":\"订单编号\",\"columnId\":57,\"columnName\":\"order_number\",\"columnType\":\"varchar(50)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:29:08\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"orderNumber\",\"javaType\":\"String\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":2,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"UserId\",\"columnComment\":\"用户ID\",\"columnId\":58,\"columnName\":\"user_id\",\"columnType\":\"bigint(20)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:29:08\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"input\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequired\":\"1\",\"javaField\":\"userId\",\"javaType\":\"Long\",\"list\":true,\"params\":{},\"pk\":false,\"query\":true,\"queryType\":\"EQ\",\"required\":true,\"sort\":3,\"superColumn\":false,\"tableId\":9,\"updateBy\":\"\",\"usableColumn\":false},{\"capJavaField\":\"Status\",\"columnComment\":\"订单状态（0-待支付，1-已支付，2-已完成，3-已取消）\",\"columnId\":59,\"columnName\":\"status\",\"columnType\":\"tinyint(3)\",\"createBy\":\"admin\",\"createTime\":\"2025-01-11 10:29:08\",\"dictType\":\"\",\"edit\":true,\"htmlType\":\"radio\",\"increment\":false,\"insert\":true,\"isEdit\":\"1\",\"isIncrement\":\"0\",\"isInsert\":\"1\",\"isList\":\"1\",\"isPk\":\"0\",\"isQuery\":\"1\",\"isRequi', '{\"msg\":\"操作成功\",\"code\":200}', 0, NULL, '2025-01-11 10:31:21', 70);
INSERT INTO `sys_oper_log` VALUES (244, '代码生成', 8, 'com.ruoyi.generator.controller.GenController.batchGenCode()', 'GET', 1, 'admin', '研发部门', '/tool/gen/batchGenCode', '127.0.0.1', '内网IP', '{\"tables\":\"order\"}', NULL, 0, NULL, '2025-01-11 10:31:46', 162);
INSERT INTO `sys_oper_log` VALUES (245, '菜单管理', 3, 'com.ruoyi.web.controller.system.SysMenuController.remove()', 'DELETE', 1, 'admin', '研发部门', '/system/menu/2008', '127.0.0.1', '内网IP', '2008', '{\"msg\":\"菜单已分配,不允许删除\",\"code\":601}', 0, NULL, '2025-01-11 10:50:07', 12);

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int(4) NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2024-12-31 21:09:46', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int(4) NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-12-31 21:09:46', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '5', 1, 1, '0', '0', 'admin', '2024-12-31 21:09:46', 'admin', '2025-01-09 16:05:39', '普通角色');
INSERT INTO `sys_role` VALUES (100, '普通管理员', 'normal_admin', 3, '1', 1, 1, '0', '0', 'admin', '2025-01-07 15:08:22', 'admin', '2025-01-09 15:45:09', NULL);
INSERT INTO `sys_role` VALUES (101, '管理员', 'AAdmin', 4, '1', 0, 0, '1', '2', 'admin', '2025-01-07 16:05:55', 'admin', '2025-01-07 16:10:05', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `dept_id` bigint(20) NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `menu_id` bigint(20) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 2000);
INSERT INTO `sys_role_menu` VALUES (2, 2001);
INSERT INTO `sys_role_menu` VALUES (2, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 1);
INSERT INTO `sys_role_menu` VALUES (100, 2);
INSERT INTO `sys_role_menu` VALUES (100, 100);
INSERT INTO `sys_role_menu` VALUES (100, 101);
INSERT INTO `sys_role_menu` VALUES (100, 102);
INSERT INTO `sys_role_menu` VALUES (100, 109);
INSERT INTO `sys_role_menu` VALUES (100, 110);
INSERT INTO `sys_role_menu` VALUES (100, 111);
INSERT INTO `sys_role_menu` VALUES (100, 112);
INSERT INTO `sys_role_menu` VALUES (100, 113);
INSERT INTO `sys_role_menu` VALUES (100, 114);
INSERT INTO `sys_role_menu` VALUES (100, 1000);
INSERT INTO `sys_role_menu` VALUES (100, 1001);
INSERT INTO `sys_role_menu` VALUES (100, 1002);
INSERT INTO `sys_role_menu` VALUES (100, 1003);
INSERT INTO `sys_role_menu` VALUES (100, 1004);
INSERT INTO `sys_role_menu` VALUES (100, 1005);
INSERT INTO `sys_role_menu` VALUES (100, 1006);
INSERT INTO `sys_role_menu` VALUES (100, 1007);
INSERT INTO `sys_role_menu` VALUES (100, 1008);
INSERT INTO `sys_role_menu` VALUES (100, 1009);
INSERT INTO `sys_role_menu` VALUES (100, 1010);
INSERT INTO `sys_role_menu` VALUES (100, 1011);
INSERT INTO `sys_role_menu` VALUES (100, 1012);
INSERT INTO `sys_role_menu` VALUES (100, 1013);
INSERT INTO `sys_role_menu` VALUES (100, 1014);
INSERT INTO `sys_role_menu` VALUES (100, 1015);
INSERT INTO `sys_role_menu` VALUES (100, 1046);
INSERT INTO `sys_role_menu` VALUES (100, 1047);
INSERT INTO `sys_role_menu` VALUES (100, 1048);
INSERT INTO `sys_role_menu` VALUES (100, 1049);
INSERT INTO `sys_role_menu` VALUES (100, 1050);
INSERT INTO `sys_role_menu` VALUES (100, 1051);
INSERT INTO `sys_role_menu` VALUES (100, 1052);
INSERT INTO `sys_role_menu` VALUES (100, 1053);
INSERT INTO `sys_role_menu` VALUES (100, 1054);
INSERT INTO `sys_role_menu` VALUES (100, 1061);
INSERT INTO `sys_role_menu` VALUES (100, 2000);
INSERT INTO `sys_role_menu` VALUES (100, 2001);
INSERT INTO `sys_role_menu` VALUES (100, 2002);
INSERT INTO `sys_role_menu` VALUES (100, 2006);
INSERT INTO `sys_role_menu` VALUES (100, 2007);
INSERT INTO `sys_role_menu` VALUES (100, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 2009);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint(20) NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2025-01-11 16:27:43', 'admin', '2024-12-31 21:09:46', '', '2025-01-11 16:27:42', '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'ry', '若依', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$LmTqytR2K3ztKMonYpasMuwJZjLCX9sV.g9llNEwFd2QBZSiL7hkS', '0', '0', '127.0.0.1', '2025-01-03 10:56:36', 'admin', '2024-12-31 21:09:46', 'cwb', '2025-01-03 10:56:36', '测试员');
INSERT INTO `sys_user` VALUES (100, 100, 'cwb', 'cwb', '00', '2317552732@qq.com', '18935110156', '0', '/profile/avatar/2025/01/03/微信图片_20250103102904_20250103105407A002.jpg', '$2a$10$y0exNHZf64hKhG2ZkiRAFO2RMVZe8cFtGkWPEdvqwWDDs31eFQXWO', '0', '0', '127.0.0.1', '2025-01-09 16:05:52', '', '2025-01-02 09:22:52', 'admin', '2025-01-09 16:05:51', '本人');
INSERT INTO `sys_user` VALUES (101, NULL, '程文斌', '程文斌', '00', '', '', '0', '/profile/avatar/2025/01/07/微信图片_20250107151857_20250107151914A001.jpg', '$2a$10$rh5Ud9l8lzmaFQ3.B/oOcOcwspKyU313rP6zVAmEGsTbE0DJTWM9C', '0', '0', '127.0.0.1', '2025-01-11 11:14:23', '', '2025-01-07 15:05:23', 'admin', '2025-01-11 11:14:23', NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `post_id` bigint(20) NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);
INSERT INTO `sys_user_post` VALUES (100, 1);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 2);
INSERT INTO `sys_user_role` VALUES (101, 100);

SET FOREIGN_KEY_CHECKS = 1;
