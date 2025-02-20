package com.shop.system.service;
import com.shop.system.domain.Product;
import java.util.List;

public interface IProductService {
    List<Product> selectProductList(Product product);
    int insertProduct(Product product);
    int updateProduct(Product product);
    int deleteProductByIds(Long[] ids);
    Product selectProductById(Long productId);
    List<Product> selectProductListByCategory(Product product);

    // 添加 reduceStock 方法
    boolean reduceStock(Long productId, Integer quantity);
}