package com.shop.system.service;

import com.shop.system.domain.Cart;
import java.util.List;

public interface ICartService {
    List<Cart> selectCartList(Long userId);
    int insertCart(Cart cart);
    int updateCart(Cart cart);
    int deleteCartById(Long cartId);
    int deleteCartByProductIds(Long[] ids, Long userId);
}
