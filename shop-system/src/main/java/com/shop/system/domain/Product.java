package com.shop.system.domain;
import java.math.BigDecimal;
import java.util.Date;
public class Product {
    private Long id;
    private String name;
    private String description;
    private String category;
    private BigDecimal price;
    private Integer stock;
    private String imageUrl;
    private Date createdTime;
    private Date updatedTime;

    private BigDecimal minPrice;  // 最小价格
    private BigDecimal maxPrice;  // 最大价格
    private Integer minStock;     // 最小库存
    private Integer maxStock;     // 最大库存
    private String descriptionImagesJson; // 描述图片JSON字符串

    // 无参构造函数
    public Product() {
    }

    // 接受类别参数的构造函数
    public Product(String category) {
        this.category = category;
    }

    // ... 其他字段的 getter 和 setter ...

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getStock() {
        return stock;
    }

    public void setStock(Integer stock) {
        this.stock = stock;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Date getCreatedTime() {
        return createdTime;
    }

    public void setCreatedTime(Date createdTime) {
        this.createdTime = createdTime;
    }

    public Date getUpdatedTime() {
        return updatedTime;
    }

    public void setUpdatedTime(Date updatedTime) {
        this.updatedTime = updatedTime;
    }
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    // 新增字段的 getter 和 setter 方法
    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }

    public Integer getMinStock() {
        return minStock;
    }

    public void setMinStock(Integer minStock) {
        this.minStock = minStock;
    }

    public Integer getMaxStock() {
        return maxStock;
    }

    public void setMaxStock(Integer maxStock) {
        this.maxStock = maxStock;
    }

    public String getDescriptionImagesJson() {
        return descriptionImagesJson;
    }

    public void setDescriptionImagesJson(String descriptionImagesJson) {
        this.descriptionImagesJson = descriptionImagesJson;
    }
}