<template>
  <div class="app-container">
    <el-card>
      <el-table :data="cartList" v-loading="loading" border style="width: 100%" v-if="cartList.length > 0">
        <el-table-column label="产品名称" prop="productName" align="center" />
        <el-table-column label="价格" prop="price" align="center" />
        <el-table-column label="图片" prop="imageUrl" align="center" width="100">
          <template slot-scope="scope">
            <el-image style="width: 80px;height:80px" :src="scope.row.imageUrl" :preview-src-list="[scope.row.imageUrl]"></el-image>
          </template>
        </el-table-column>
        <el-table-column label="数量" prop="quantity" align="center">
          <template slot-scope="scope">
            <el-input-number v-model="scope.row.quantity" @change="handleQuantityChange(scope.row)" :min="1" :max="100" size="mini"></el-input-number>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <el-button size="mini" type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div v-else class="no-data">
        暂无数据
      </div>
      <pagination
        v-show="total > 0"
        :total="total"
        :page.sync="queryParams.pageNum"
        :limit.sync="queryParams.pageSize"
        @pagination="getList"
      />
      <el-button type="danger" @click="handleClearCart">清空购物车</el-button>
      <el-button type="primary" @click="openOrderDialog">生成订单</el-button>
    </el-card>

    <!-- 收货地址填写对话框，内含省市区联动和详细地址输入 -->
    <el-dialog
      title="填写收货地址"
      :visible.sync="dialogVisible"
      width="500px"
    >
      <!-- 省市区联动 -->
      <el-cascader
        v-model="addressData.region"
        :options="regionOptions"
        placeholder="请选择省市区"
        clearable
        style="width: 100%; margin-bottom: 20px;"
      ></el-cascader>

      <!-- 详细地址输入框 -->
      <el-input
        type="textarea"
        v-model="addressData.detail"
        placeholder="请输入详细地址"
        rows="3"
        style="width: 100%;"
      ></el-input>

      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmOrder">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { listCart, deleteCart, updateCart, deleteCartByProductIds } from "@/api/system/cart";
import { createOrder } from "@/api/system/order";
import request from '@/utils/request'; // 若依封装的 request
import { getToken } from "@/utils/auth";

export default {
  data() {
    return {
      loading: true,
      cartList: [],
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      total: 0,
      userId: "",
      dialogVisible: false,
      // 存放地址数据
      addressData: {
        region: [], // 数组形式，如 ["山西省", "太原市", "小店区"]
        detail: ''  // 详细地址
      },
      // 山西省的市和县数据
      regionOptions: [
        {
          value: '山西省',
          label: '山西省',
          children: [
            {
              value: '太原市',
              label: '太原市',
              children: [
                { value: '小店区', label: '小店区' },
                { value: '迎泽区', label: '迎泽区' },
                { value: '杏花岭区', label: '杏花岭区' },
                { value: '尖草坪区', label: '尖草坪区' },
                { value: '万柏林区', label: '万柏林区' },
                { value: '晋源区', label: '晋源区' },
                { value: '清徐县', label: '清徐县' },
                { value: '阳曲县', label: '阳曲县' },
                { value: '娄烦县', label: '娄烦县' }
              ]
            },
            {
              value: '大同市',
              label: '大同市',
              children: [
                { value: '城区', label: '城区' },
                { value: '矿区', label: '矿区' },
                { value: '南郊区', label: '南郊区' },
                { value: '新荣区', label: '新荣区' },
                { value: '阳高县', label: '阳高县' },
                { value: '天镇县', label: '天镇县' },
                { value: '广灵县', label: '广灵县' },
                { value: '灵丘县', label: '灵丘县' },
                { value: '浑源县', label: '浑源县' },
                { value: '左云县', label: '左云县' }
              ]
            },
            {
              value: '阳泉市',
              label: '阳泉市',
              children: [
                { value: '城区', label: '城区' },
                { value: '矿区', label: '矿区' },
                { value: '郊区', label: '郊区' },
                { value: '平定县', label: '平定县' },
                { value: '盂县', label: '盂县' }
              ]
            },
            {
              value: '长治市',
              label: '长治市',
              children: [
                { value: '城区', label: '城区' },
                { value: '郊区', label: '郊区' },
                { value: '长治县', label: '长治县' },
                { value: '襄垣县', label: '襄垣县' },
                { value: '屯留县', label: '屯留县' },
                { value: '平顺县', label: '平顺县' },
                { value: '黎城县', label: '黎城县' },
                { value: '壶关县', label: '壶关县' },
                { value: '长子县', label: '长子县' },
                { value: '武乡县', label: '武乡县' },
                { value: '沁县', label: '沁县' },
                { value: '沁源县', label: '沁源县' }
              ]
            },
            {
              value: '晋城市',
              label: '晋城市',
              children: [
                { value: '城区', label: '城区' },
                { value: '沁水县', label: '沁水县' },
                { value: '阳城县', label: '阳城县' },
                { value: '陵川县', label: '陵川县' },
                { value: '泽州县', label: '泽州县' }
              ]
            },
            {
              value: '朔州市',
              label: '朔州市',
              children: [
                { value: '朔城区', label: '朔城区' },
                { value: '平鲁区', label: '平鲁区' },
                { value: '山阴县', label: '山阴县' },
                { value: '应县', label: '应县' },
                { value: '右玉县', label: '右玉县' }
              ]
            },
            {
              value: '忻州市',
              label: '忻州市',
              children: [
                { value: '忻府区', label: '忻府区' },
                { value: '定襄县', label: '定襄县' },
                { value: '五台县', label: '五台县' },
                { value: '代县', label: '代县' },
                { value: '繁峙县', label: '繁峙县' },
                { value: '宁武县', label: '宁武县' },
                { value: '静乐县', label: '静乐县' },
                { value: '神池县', label: '神池县' },
                { value: '五寨县', label: '五寨县' },
                { value: '岢岚县', label: '岢岚县' },
                { value: '河曲县', label: '河曲县' },
                { value: '保德县', label: '保德县' },
                { value: '偏关县', label: '偏关县' }
              ]
            },
            {
              value: '临汾市',
              label: '临汾市',
              children: [
                { value: '尧都区', label: '尧都区' },
                { value: '曲沃县', label: '曲沃县' },
                { value: '翼城县', label: '翼城县' },
                { value: '襄汾县', label: '襄汾县' },
                { value: '洪洞县', label: '洪洞县' },
                { value: '古县', label: '古县' },
                { value: '安泽县', label: '安泽县' },
                { value: '浮山县', label: '浮山县' },
                { value: '吉县', label: '吉县' },
                { value: '乡宁县', label: '乡宁县' },
                { value: '大宁县', label: '大宁县' },
                { value: '隰县', label: '隰县' },
                { value: '永和县', label: '永和县' },
                { value: '蒲县', label: '蒲县' },
                { value: '汾西县', label: '汾西县' }
              ]
            },
            {
              value: '吕梁市',
              label: '吕梁市',
              children: [
                { value: '离石区', label: '离石区' },
                { value: '文水县', label: '文水县' },
                { value: '交城县', label: '交城县' },
                { value: '兴县', label: '兴县' },
                { value: '临县', label: '临县' },
                { value: '柳林县', label: '柳林县' },
                { value: '石楼县', label: '石楼县' },
                { value: '岚县', label: '岚县' },
                { value: '方山县', label: '方山县' },
                { value: '中阳县', label: '中阳县' },
                { value: '交口县', label: '交口县' }
              ]
            },
            {
              value: '运城市',
              label: '运城市',
              children: [
                { value: '盐湖区', label: '盐湖区' },
                { value: '河津市', label: '河津市' },
                { value: '永济市', label: '永济市' },
                { value: '夏县', label: '夏县' },
                { value: '临猗县', label: '临猗县' },
                { value: '万荣县', label: '万荣县' },
              ]
            }
          ]
        }
      ]
    };
  },
  created() {
    this.getUserId();
    this.getList();
  },
  methods: {
    getUserId() {
      const token = getToken();
      if (token) {
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          this.userId = payload.userId;
        } catch (e) {
          console.error("解析token失败", e);
        }
      }
    },
    handleClearCart() {
      this.$modal.confirm('是否确认清空购物车？').then(() => {
        const productIds = this.cartList.map(item => item.productId);
        if (productIds.length === 0) {
          this.$modal.msgWarning('当前无商品');
          return Promise.reject();
        }
        return deleteCartByProductIds(productIds);
      }).then(() => {
        this.$modal.msgSuccess('清空购物车成功');
        this.getList();
      }).catch(() => {
        // 用户取消操作或无商品时的处理
      });
    },
    async getList() {
      this.loading = true;
      try {
        const response = await listCart(this.queryParams);
        console.log("listCart response:", response);
        this.total = response.total;
        if (response && response.rows && Array.isArray(response.rows)) {
          this.cartList = response.rows.map(item => ({
            ...item,
            cartId: item.id,
            id: item.id,
            productName: '',
            imageUrl: '',
            price: 0,
          }));
          await this.getProductInfo();
        } else {
          this.cartList = [];
          this.loading = false;
          this.$modal.msgError("购物车数据加载失败");
        }
      } catch (e) {
        console.error("获取购物车列表失败:", e);
        this.$modal.msgError("购物车数据加载失败");
        this.cartList = [];
        this.loading = false;
      }
    },
    async getProductInfo() {
      this.loading = true;
      try {
        const productInfoPromises = this.cartList.map(async item => {
          if (item && item.productId) {
            try {
              const res = await this.getProduct(item.productId);
              if (res && res.name && res.imageUrl && res.price) {
                item.productName = res.name;
                item.imageUrl = res.imageUrl;
                item.price = res.price;
              } else {
                item.productName = '加载失败';
                item.imageUrl = '';
                item.price = 0;
                console.error("获取商品信息失败:", res);
              }
            } catch (e) {
              item.productName = '加载失败';
              item.imageUrl = '';
              item.price = 0;
              console.error("获取商品信息失败:", e);
            }
          } else {
            console.error("cartList中存在无效item：", item);
          }
          return item;
        });
        this.cartList = await Promise.all(productInfoPromises);
      } catch (e) {
        console.error('获取商品详情失败', e);
        this.$modal.msgError('获取商品详情失败');
      } finally {
        this.loading = false;
      }
    },
    async getProduct(productId) {
      try {
        const response = await request({ url: `/system/product/${productId}`, method: 'get' });
        if (response && response.data) {
          return response.data;
        } else {
          console.error("获取商品信息失败:", response);
          return {
            name: '加载失败',
            imageUrl: '',
            price: 0,
          };
        }
      } catch (e) {
        console.error("获取商品信息失败:", e);
        return {
          name: '加载失败',
          imageUrl: '',
          price: 0,
        };
      }
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除该商品？').then(() => {
        return deleteCart(row.cartId);
      }).then(() => {
        this.$modal.msgSuccess('删除成功');
        this.getList();
      });
    },
    handleQuantityChange(row) {
      updateCart(row).then(() => {
        this.$modal.msgSuccess('修改成功');
      });
    },
    openOrderDialog() {
      if (this.cartList.length === 0) {
        this.$modal.msgWarning('当前购物车为空');
        return;
      }
      // 重置地址数据
      this.addressData.region = [];
      this.addressData.detail = '';
      this.dialogVisible = true;
    },
    confirmOrder() {
      if (!this.addressData.region.length) {
        this.$modal.msgWarning('请选择省市区');
        return;
      }
      if (!this.addressData.detail.trim()) {
        this.$modal.msgWarning('请输入详细地址');
        return;
      }
      const regionStr = this.addressData.region.join(' ');
      const fullAddress = regionStr + ' ' + this.addressData.detail;
      const orderItems = this.cartList.map(item => ({
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.price,
        totalPrice: item.quantity * item.price
      }));
      const order = {
        address: fullAddress,
        orderItems: orderItems
      };
      createOrder(order).then(response => {
        if (response.code === 200) {
          this.$modal.msgSuccess('生成订单成功');
          const productIds = this.cartList.map(item => item.productId);
          if (productIds.length) {
            deleteCartByProductIds(productIds).then(() => {
              this.$modal.msgSuccess('购物车已清空');
              this.getList();
            });
          }
        } else {
          this.$modal.msgError("生成订单失败");
        }
      });
      this.dialogVisible = false;
    }
  }
};
</script>

<style scoped>
.no-data {
  text-align: center;
  padding: 20px;
  font-size: 16px;
  color: #999;
}
</style>
