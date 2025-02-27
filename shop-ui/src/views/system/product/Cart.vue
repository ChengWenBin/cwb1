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
            <el-input-number v-model="scope.row.quantity" @change="handleQuantityChange(scope.row)" :min="1" :max="100"  size="mini"></el-input-number>
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
      <el-button type="primary" @click="handleCreateOrder">生成订单</el-button>
    </el-card>
  </div>
</template>
<script>
import { listCart, deleteCart, updateCart, deleteCartByProductIds} from "@/api/system/cart";
import {createOrder} from "@/api/system/order";
import request from '@/utils/request'; // 引入若依的request
import { getToken } from "@/utils/auth";

export default {
  data() {
    return {
      loading:true,
      cartList:[],
      queryParams: {
        pageNum: 1,
        pageSize: 10
      },
      total: 0,
      userId: ""
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
        const productIds = this.cartList.map(item=> item.productId);
        if (productIds.length === 0) {
          this.$modal.msgWarning('当前无商品');
          return Promise.reject(); // 使用 Promise.reject() 终止后续操作
        }
        return deleteCartByProductIds(productIds);
      }).then(() => {
        this.$modal.msgSuccess('清空购物车成功')
        this.getList();
      }).catch(() => {
        // Promise.reject() 触发的 catch，这里可以不做任何操作
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
            cartId: item.id, //  确保 cartId 存储的是 item.id
            id: item.id,  // 保留原有的 id
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
        console.error("获取购物车列表失败:",e);
        this.$modal.msgError("购物车数据加载失败");
        this.cartList= [];
        this.loading = false;
      }
    },
    async getProductInfo() {
      this.loading=true;
      try {
        const productInfoPromises = this.cartList.map(async item => {
          if(item && item.productId) {
            try{
              const res = await this.getProduct(item.productId);
              if(res && res.name && res.imageUrl && res.price){
                item.productName = res.name;
                item.imageUrl = res.imageUrl;
                item.price = res.price;
              } else{
                item.productName = '加载失败';
                item.imageUrl = '';
                item.price = 0;
                console.error("获取商品信息失败:",res);
              }
            }catch(e){
              item.productName = '加载失败';
              item.imageUrl = '';
              item.price = 0;
              console.error("获取商品信息失败:",e);
            }
          }else{
            console.error("cartList中存在无效item：",item);
          }
          return item;
        });

        this.cartList = await Promise.all(productInfoPromises);
      } catch (e) {
        console.error('获取商品详情失败',e);
        this.$modal.msgError('获取商品详情失败');
      }finally{
        this.loading = false;
      }
    },
    async getProduct(productId) {
      try {
        const response = await request({ url: `/system/product/${productId}`, method: 'get' });
        if (response && response.data) {
          return response.data;
        } else{
          console.error("获取商品信息失败:",response)
          return {
            name: '加载失败',
            imageUrl: '',
            price: 0,
          };
        }

      } catch (e) {
        console.error("获取商品信息失败:",e);
        return {
          name: '加载失败',
          imageUrl: '',
          price: 0,
        };
      }
    },
    handleDelete(row) {
      this.$modal.confirm('是否确认删除该商品？').then(()=>{
        return deleteCart(row.cartId); // 使用 row.cartId
      }).then(() => {
        this.$modal.msgSuccess('删除成功');
        this.getList();
      });
    },
    handleQuantityChange(row) {
      updateCart(row).then(() => {
        this.$modal.msgSuccess('修改成功')
      });
    },
    handleCreateOrder() {
      if(this.cartList.length === 0) {
        this.$modal.msgWarning('当前购物车为空')
        return;
      }

      const orderItems = this.cartList.map(item => ({
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        unitPrice: item.price,
        totalPrice: item.quantity * item.price
      }));

      this.$prompt('请输入收货地址', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPlaceholder: '请输入收货地址'
      }).then(({ value }) => {
        const order = {
          address:value,
          orderItems: orderItems,
        }
        createOrder(order).then(response => {
          if (response.code === 200) {
            this.$modal.msgSuccess('生成订单成功');
            //this.$router.push({ name: 'UserOrder' });
          } else {
            this.$modal.msgError("生成订单失败");
          }
        })
      }).catch(() =>{

      });
    },
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
