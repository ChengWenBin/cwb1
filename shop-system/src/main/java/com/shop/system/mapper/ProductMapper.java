package com.shop.system.mapper;
import com.shop.system.domain.Product;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import org.apache.ibatis.annotations.Param;
@Mapper
public interface ProductMapper {
    List<Product> selectProductList(Product product);
    int insertProduct(Product product);
    int updateProduct(Product product);
    int deleteProductByIds(Long[] ids);
    Product selectProductById(Long productId);
    List<Product> selectProductListByCategory(Product product);
    int reduceStock(@Param("productId") Long productId, @Param("quantity") Integer quantity);
}