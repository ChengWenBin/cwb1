package com.shop.system.service.impl;
import com.shop.system.domain.Product;
import com.shop.system.mapper.ProductMapper;
import com.shop.system.service.IProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

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
    @Transactional // 添加事务注解，确保数据一致性
    public boolean reduceStock(Long productId, Integer quantity) {
        int rows = productMapper.reduceStock(productId, quantity);
        if (rows > 0) {
            return true; // 扣减成功
        }
        return false; // 扣减失败 (例如，库存不足)
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
    
    // 类型管理相关方法实现
    @Override
    public List<String> selectAllCategories() {
        return productMapper.selectAllCategories();
    }
    
    @Override
    public int insertCategory(String category) {
        // 检查类型是否已存在
        if (productMapper.checkCategoryExists(category) > 0) {
            return 0; // 类型已存在，插入失败
        }
        return productMapper.insertCategory(category);
    }
    
    @Override
    @Transactional
    public int updateCategory(String oldCategory, String newCategory) {
        // 检查新类型是否已存在
        if (productMapper.checkCategoryExists(newCategory) > 0) {
            return 0; // 新类型已存在，更新失败
        }
        // 更新所有使用旧类型的产品
        productMapper.updateProductCategory(oldCategory, newCategory);
        return 1; // 更新成功
    }
    
    @Override
    @Transactional
    public int deleteCategory(String category) {
        // 检查该类型是否被产品使用
        int count = productMapper.getCategoryCount(category);
        if (count > 0) {
            return 0; // 类型正在被使用，不能删除
        }
        return productMapper.deleteCategory(category);
    }
    
    @Override
    public int getCategoryCount(String category) {
        return productMapper.getCategoryCount(category);
    }
}