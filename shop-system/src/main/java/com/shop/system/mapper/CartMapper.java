package com.shop.system.mapper;

import com.shop.system.domain.Cart;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CartMapper {
    List<Cart> selectCartList(Long userId);
    int insertCart(Cart cart);
    int updateCart(Cart cart);
    int deleteCartById(Long cartId);
    int deleteCartByProductIds(Map<String,Object> params);
}
