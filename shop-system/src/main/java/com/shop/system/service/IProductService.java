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
    
    // 类型管理相关方法
    List<String> selectAllCategories();
    int insertCategory(String category);
    int updateCategory(String oldCategory, String newCategory);
    int deleteCategory(String category);
    int getCategoryCount(String category);
}