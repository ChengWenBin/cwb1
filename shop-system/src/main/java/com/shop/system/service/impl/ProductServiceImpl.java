package com.shop.system.service.impl;
import com.shop.system.domain.Product;
import com.shop.system.mapper.ProductMapper;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductServiceImpl implements IProductService {
    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<Product> selectProductList(Product product) {
        return productMapper.selectProductList(product);
    }

    @Override
    public int insertProduct(Product product) {
        return productMapper.insertProduct(product);
    }

    @Override
    public int updateProduct(Product product) {
        return productMapper.updateProduct(product);
    }

    @Override
    public int deleteProductByIds(Long[] ids) {
        return productMapper.deleteProductByIds(ids);
    }
    @Override
    public Product selectProductById(Long productId) {
        return productMapper.selectProductById(productId);
    }
    @Override
    public List<Product> selectProductListByCategory(Product product) {   // 确保这里有这个方法的实现
        return productMapper.selectProductListByCategory(product);
    }
}