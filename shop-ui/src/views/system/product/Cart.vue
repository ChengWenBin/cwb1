<template>
  <div class="app-container">
    <div class="cart-header">
      <div class="title-area">
        <i class="el-icon-shopping-cart-full"></i>
        <span>我的购物车</span>
      </div>
    </div>

    <el-card class="cart-card" shadow="hover">
      <div v-if="cartList.length > 0">
        <el-table 
          :data="cartList" 
          v-loading="loading" 
          border 
          style="width: 100%" 
          :cell-style="cellStyle"
          :header-cell-style="headerCellStyle"
          highlight-current-row
          stripe>
          <el-table-column label="商品图片" prop="imageUrl" align="center" width="120">
            <template slot-scope="scope">
              <el-image 
                style="width: 80px; height: 80px; border-radius: 6px;" 
                :src="scope.row.imageUrl" 
                :preview-src-list="[scope.row.imageUrl]"
                fit="cover">
                <div slot="error" class="image-error">
                  <i class="el-icon-picture-outline"></i>
                </div>
              </el-image>
            </template>
          </el-table-column>
          <el-table-column label="商品名称" prop="productName" align="center" min-width="180">
            <template slot-scope="scope">
              <div class="product-name">{{ scope.row.productName }}</div>
            </template>
          </el-table-column>
          <!-- 注释掉商品描述列 -->
          <!-- <el-table-column label="商品描述" prop="description" align="center" min-width="120">
            <template slot-scope="scope">
              <div class="product-desc">{{ scope.row.description || '暂无描述' }}</div>
            </template>
          </el-table-column> -->
          <el-table-column label="库存状态" prop="stock" align="center" width="100">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.stock > 0" type="success" size="mini" effect="dark">有库存</el-tag>
              <el-tag v-else type="danger" size="mini" effect="dark">暂时缺货</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="单价" prop="price" align="center" width="120">
            <template slot-scope="scope">
              <span class="price">¥{{ scope.row.price }}</span>
            </template>
          </el-table-column>
          <el-table-column label="数量" prop="quantity" align="center" width="140">
            <template slot-scope="scope">
              <el-input-number 
                v-model="scope.row.quantity" 
                @change="handleQuantityChange(scope.row)" 
                :min="1" 
                :max="100" 
                size="small"
                controls-position="right">
              </el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="小计" align="center" width="120">
            <template slot-scope="scope">
              <span class="subtotal">¥{{ (scope.row.price * scope.row.quantity).toFixed(2) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="80">
            <template slot-scope="scope">
              <el-button 
                size="mini" 
                type="danger" 
                icon="el-icon-delete" 
                circle
                @click="handleDelete(scope.row)">
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="cart-footer">
          <div class="cart-total">
            <span>合计金额: </span>
            <span class="total-price">¥{{ totalAmount }}</span>
          </div>
          <div class="cart-actions">
            <el-button size="medium" plain icon="el-icon-shopping-bag-1" @click="goToShopping">继续购物</el-button>
            <el-button size="medium" type="info" plain icon="el-icon-delete" @click="handleClearCart">清空购物车</el-button>
            <el-button size="medium" type="danger" icon="el-icon-wallet" @click="openOrderDialog">去结算</el-button>
          </div>
        </div>

        <pagination
          v-show="total > 0"
          :total="total"
          :page.sync="queryParams.pageNum"
          :limit.sync="queryParams.pageSize"
          @pagination="getList"
        />
      </div>

      <div v-else class="empty-cart">
        <div class="empty-cart-icon">
          <i class="el-icon-shopping-cart-2"></i>
        </div>
        <p>购物车还是空的，去挑选喜欢的商品吧~</p>
        <el-button type="primary" size="medium" icon="el-icon-shopping-bag-1" @click="goToShopping">去购物</el-button>
      </div>
    </el-card>

    <!-- 收货地址填写对话框 -->
    <el-dialog
      title="填写收货地址"
      :visible.sync="dialogVisible"
      width="500px"
      center
      :close-on-click-modal="false"
    >
      <div class="address-form">
        <div class="form-item">
          <div class="form-label">选择地区：</div>
          <el-cascader
            v-model="addressData.region"
            :options="regionOptions"
            placeholder="请选择省市区"
            clearable
            style="width: 100%;"
          ></el-cascader>
        </div>
        
        <div class="form-item" style="margin-top: 20px;">
          <div class="form-label">详细地址：</div>
          <el-input
            type="textarea"
            v-model="addressData.detail"
            placeholder="请输入详细地址，如街道名称、门牌号等"
            rows="3"
            style="width: 100%;"
          ></el-input>
        </div>
      </div>

      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="confirmOrder">确认下单</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { listCart, deleteCart, updateCart, deleteCartByProductIds } from "@/api/system/cart";
import { createOrder } from "@/api/system/order";
import request from '@/utils/request';
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
      // 省市区数据
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
        },
        {
          value: '北京市',
          label: '北京市',
          children: [
            {
              value: '北京市',
              label: '北京市',
              children: [
                { value: '东城区', label: '东城区' },
                { value: '西城区', label: '西城区' },
                { value: '朝阳区', label: '朝阳区' },
                { value: '海淀区', label: '海淀区' },
                { value: '丰台区', label: '丰台区' },
                { value: '石景山区', label: '石景山区' },
                { value: '门头沟区', label: '门头沟区' },
                { value: '房山区', label: '房山区' },
                { value: '通州区', label: '通州区' },
                { value: '顺义区', label: '顺义区' },
                { value: '昌平区', label: '昌平区' },
                { value: '大兴区', label: '大兴区' },
                { value: '怀柔区', label: '怀柔区' },
                { value: '平谷区', label: '平谷区' },
                { value: '密云区', label: '密云区' },
                { value: '延庆区', label: '延庆区' }
              ]
            }
          ]
        },
        {
          value: '上海市',
          label: '上海市',
          children: [
            {
              value: '上海市',
              label: '上海市',
              children: [
                { value: '黄浦区', label: '黄浦区' },
                { value: '徐汇区', label: '徐汇区' },
                { value: '长宁区', label: '长宁区' },
                { value: '静安区', label: '静安区' },
                { value: '普陀区', label: '普陀区' },
                { value: '虹口区', label: '虹口区' },
                { value: '杨浦区', label: '杨浦区' },
                { value: '浦东新区', label: '浦东新区' },
                { value: '闵行区', label: '闵行区' },
                { value: '宝山区', label: '宝山区' },
                { value: '嘉定区', label: '嘉定区' },
                { value: '金山区', label: '金山区' },
                { value: '松江区', label: '松江区' },
                { value: '青浦区', label: '青浦区' },
                { value: '奉贤区', label: '奉贤区' },
                { value: '崇明区', label: '崇明区' }
              ]
            }
          ]
        },
        {
          value: '广东省',
          label: '广东省',
          children: [
            {
              value: '广州市',
              label: '广州市',
              children: [
                { value: '荔湾区', label: '荔湾区' },
                { value: '越秀区', label: '越秀区' },
                { value: '海珠区', label: '海珠区' },
                { value: '天河区', label: '天河区' },
                { value: '白云区', label: '白云区' },
                { value: '黄埔区', label: '黄埔区' },
                { value: '番禺区', label: '番禺区' },
                { value: '花都区', label: '花都区' },
                { value: '南沙区', label: '南沙区' },
                { value: '从化区', label: '从化区' },
                { value: '增城区', label: '增城区' }
              ]
            },
            {
              value: '深圳市',
              label: '深圳市',
              children: [
                { value: '福田区', label: '福田区' },
                { value: '罗湖区', label: '罗湖区' },
                { value: '南山区', label: '南山区' },
                { value: '宝安区', label: '宝安区' },
                { value: '龙岗区', label: '龙岗区' },
                { value: '盐田区', label: '盐田区' },
                { value: '龙华区', label: '龙华区' },
                { value: '坪山区', label: '坪山区' },
                { value: '光明区', label: '光明区' }
              ]
            }
          ]
        },
        {
          value: '江苏省',
          label: '江苏省',
          children: [
            {
              value: '南京市',
              label: '南京市',
              children: [
                { value: '玄武区', label: '玄武区' },
                { value: '秦淮区', label: '秦淮区' },
                { value: '建邺区', label: '建邺区' },
                { value: '鼓楼区', label: '鼓楼区' },
                { value: '浦口区', label: '浦口区' },
                { value: '栖霞区', label: '栖霞区' },
                { value: '雨花台区', label: '雨花台区' },
                { value: '江宁区', label: '江宁区' },
                { value: '六合区', label: '六合区' }
              ]
            },
            {
              value: '苏州市',
              label: '苏州市',
              children: [
                { value: '姑苏区', label: '姑苏区' },
                { value: '虎丘区', label: '虎丘区' },
                { value: '吴中区', label: '吴中区' },
                { value: '相城区', label: '相城区' },
                { value: '吴江区', label: '吴江区' }
              ]
            }
          ]
        },
        {
          value: '浙江省',
          label: '浙江省',
          children: [
            {
              value: '杭州市',
              label: '杭州市',
              children: [
                { value: '上城区', label: '上城区' },
                { value: '下城区', label: '下城区' },
                { value: '江干区', label: '江干区' },
                { value: '拱墅区', label: '拱墅区' },
                { value: '西湖区', label: '西湖区' },
                { value: '滨江区', label: '滨江区' },
                { value: '萧山区', label: '萧山区' },
                { value: '余杭区', label: '余杭区' },
                { value: '富阳区', label: '富阳区' },
                { value: '临安区', label: '临安区' }
              ]
            },
            {
              value: '宁波市',
              label: '宁波市',
              children: [
                { value: '海曙区', label: '海曙区' },
                { value: '江北区', label: '江北区' },
                { value: '北仑区', label: '北仑区' },
                { value: '镇海区', label: '镇海区' },
                { value: '鄞州区', label: '鄞州区' },
                { value: '奉化区', label: '奉化区' }
              ]
            }
          ]
        },
        {
          value: '四川省',
          label: '四川省',
          children: [
            {
              value: '成都市',
              label: '成都市',
              children: [
                { value: '锦江区', label: '锦江区' },
                { value: '青羊区', label: '青羊区' },
                { value: '金牛区', label: '金牛区' },
                { value: '武侯区', label: '武侯区' },
                { value: '成华区', label: '成华区' },
                { value: '龙泉驿区', label: '龙泉驿区' },
                { value: '青白江区', label: '青白江区' },
                { value: '新都区', label: '新都区' },
                { value: '温江区', label: '温江区' },
                { value: '双流区', label: '双流区' },
                { value: '郫都区', label: '郫都区' }
              ]
            }
          ]
        }
      ]
    };
  },
  computed: {
    // 计算购物车总金额
    totalAmount() {
      if (!this.cartList.length) return '0.00';
      const total = this.cartList.reduce((sum, item) => {
        return sum + (item.price * item.quantity);
      }, 0);
      return total.toFixed(2);
    }
  },
  created() {
    this.getUserId();
    this.getList();
  },
  methods: {
    // 表格单元格样式
    cellStyle() {
      return {
        padding: '12px 0',
        fontSize: '14px'
      };
    },
    // 表格表头样式
    headerCellStyle() {
      return {
        background: '#f5f7fa',
        color: '#606266',
        fontWeight: 'bold',
        padding: '12px 0',
        fontSize: '15px'
      };
    },
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
        this.total = response.total;
        if (response && response.rows && Array.isArray(response.rows)) {
          this.cartList = response.rows.map(item => ({
            ...item,
            cartId: item.id,
            id: item.id,
            productName: '',
            imageUrl: '',
            price: 0,
            description: '',
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
                item.description = res.description || '';
                item.stock = res.stock || 0; // 添加库存信息
              } else {
                item.productName = '加载失败';
                item.imageUrl = '';
                item.price = 0;
                item.description = '';
                item.stock = 0; // 设置库存为0
                console.error("获取商品信息失败:", res);
              }
            } catch (e) {
              item.productName = '加载失败';
              item.imageUrl = '';
              item.price = 0;
              item.description = '';
              item.stock = 0; // 设置库存为0
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
            description: '',
          };
        }
      } catch (e) {
        console.error("获取商品信息失败:", e);
        return {
          name: '加载失败',
          imageUrl: '',
          price: 0,
          description: '',
          stock: 0, // 设置库存为0
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
    },
    goToShopping() {
      this.$router.push('/system/product-browse');
    }
  }
};
</script>

<style scoped>
.cart-header {
  background-color: #fff;
  padding: 15px 20px;
  margin-bottom: 20px;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
}

.title-area {
  font-size: 18px;
  font-weight: 600;
  color: #303133;
  display: flex;
  align-items: center;
}

.title-area i {
  font-size: 24px;
  margin-right: 10px;
  color: #409EFF;
}

.cart-card {
  margin-bottom: 20px;
  border-radius: 8px;
}

.empty-cart {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 0;
  color: #909399;
}

.empty-cart-icon {
  background-color: #f5f7fa;
  border-radius: 50%;
  width: 100px;
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.empty-cart i {
  font-size: 50px;
  color: #DCDFE6;
}

.empty-cart p {
  font-size: 16px;
  margin-bottom: 30px;
}

.cart-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 25px;
  padding: 15px 20px;
  background-color: #f5f7fa;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.cart-total {
  font-size: 16px;
  display: flex;
  align-items: center;
}

.total-price {
  font-size: 24px;
  font-weight: 700;
  color: #F56C6C;
  margin-left: 10px;
}

.cart-actions {
  display: flex;
  gap: 12px;
}

.price {
  color: #F56C6C;
  font-weight: 500;
  font-size: 15px;
}

.subtotal {
  color: #F56C6C;
  font-weight: bold;
  font-size: 16px;
}

.image-error {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background-color: #f5f7fa;
  color: #909399;
  font-size: 20px;
}

.product-name {
  font-size: 14px;
  font-weight: 500;
  color: #303133;
  line-height: 1.4;
  padding: 0 5px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-desc {
  font-size: 13px;
  color: #606266;
  line-height: 1.4;
  margin: 0 3px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-align: center;
}

.price, .subtotal {
  font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
  white-space: nowrap;
}

.el-input-number.el-input-number--small {
  width: 120px !important;
}

.el-table th.is-leaf {
  border-bottom: 1px solid #EBEEF5;
}

.address-form {
  padding: 10px;
}

.form-item {
  margin-bottom: 15px;
}

.form-label {
  font-size: 14px;
  color: #606266;
  margin-bottom: 8px;
  font-weight: 500;
}
</style>
