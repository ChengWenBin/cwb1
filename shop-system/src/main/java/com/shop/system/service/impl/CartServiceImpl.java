package com.shop.system.service.impl;

import com.shop.system.domain.Cart;
import com.shop.system.mapper.CartMapper;
import com.shop.system.service.ICartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CartServiceImpl implements ICartService {
    @Autowired
    private CartMapper cartMapper;
    @Override
    public List<Cart> selectCartList(Long userId) {
        return cartMapper.selectCartList(userId);
    }
    @Override
    public int insertCart(Cart cart) {
        List<Cart> carts = cartMapper.selectCartList(cart.getUserId());
        Cart historyCart = carts.stream().filter(item -> item.getProductId().equals(cart.getProductId()))
                .findFirst().orElse(new Cart());
        if (null == historyCart.getId()){
            return cartMapper.insertCart(cart);
        } else {
            historyCart.setQuantity(historyCart.getQuantity() + 1);
            return cartMapper.updateCart(historyCart);
        }

    }
    @Override
    public int updateCart(Cart cart) {
        return cartMapper.updateCart(cart);
    }
    @Override
    public int deleteCartById(Long cartId) {
        return cartMapper.deleteCartById(cartId);
    }

    @Override
    public int deleteCartByProductIds(Long[] ids, Long userId) {
        if(ids == null || ids.length == 0){
            return 0;
        }
        Map<String, Object> params = new HashMap<>();
        params.put("array", ids);
        params.put("userId", userId);
        return cartMapper.deleteCartByProductIds(params);
    }
}
