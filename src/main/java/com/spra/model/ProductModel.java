package com.spra.model;

import java.sql.Timestamp;

/**
 * ProductModel
 * Represents a cosmetics product in the Spra store.
 *
 * @author Spra Team
 */
public class ProductModel {

    private int       productId;
    private String    name;
    private String    description;
    private double    price;
    private double    oldPrice;
    private int       stock;
    private String    imagePath;
    private int       categoryId;
    private String    categoryName;   // joined from categories table
    private boolean   isFeatured;
    private boolean   isBestseller;
    private Timestamp createdAt;

    // ---- No-arg constructor ----
    public ProductModel() {}

    // ---- Full constructor ----
    public ProductModel(int productId, String name, String description,
                        double price, double oldPrice, int stock,
                        String imagePath, int categoryId, String categoryName,
                        boolean isFeatured, boolean isBestseller, Timestamp createdAt) {
        this.productId    = productId;
        this.name         = name;
        this.description  = description;
        this.price        = price;
        this.oldPrice     = oldPrice;
        this.stock        = stock;
        this.imagePath    = imagePath;
        this.categoryId   = categoryId;
        this.categoryName = categoryName;
        this.isFeatured   = isFeatured;
        this.isBestseller = isBestseller;
        this.createdAt    = createdAt;
    }

    // ---- Getters & Setters ----

    public int getProductId()                       { return productId; }
    public void setProductId(int productId)         { this.productId = productId; }

    public String getName()                         { return name; }
    public void setName(String name)                { this.name = name; }

    public String getDescription()                  { return description; }
    public void setDescription(String description)  { this.description = description; }

    public double getPrice()                        { return price; }
    public void setPrice(double price)              { this.price = price; }

    public double getOldPrice()                     { return oldPrice; }
    public void setOldPrice(double oldPrice)        { this.oldPrice = oldPrice; }

    public int getStock()                           { return stock; }
    public void setStock(int stock)                 { this.stock = stock; }

    public String getImagePath()                    { return imagePath; }
    public void setImagePath(String imagePath)      { this.imagePath = imagePath; }

    public int getCategoryId()                      { return categoryId; }
    public void setCategoryId(int categoryId)       { this.categoryId = categoryId; }

    public String getCategoryName()                 { return categoryName; }
    public void setCategoryName(String categoryName){ this.categoryName = categoryName; }

    public boolean isFeatured()                     { return isFeatured; }
    public void setFeatured(boolean featured)       { isFeatured = featured; }

    public boolean isBestseller()                   { return isBestseller; }
    public void setBestseller(boolean bestseller)   { isBestseller = bestseller; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp t)           { this.createdAt = t; }

    /** Returns true if product is out of stock. */
    public boolean isOutOfStock() {
        return stock <= 0;
    }

    /** Calculates discount percentage if oldPrice exists. */
    public int getDiscountPercent() {
        if (oldPrice <= 0 || oldPrice <= price) return 0;
        return (int) Math.round((1.0 - price / oldPrice) * 100);
    }
}
