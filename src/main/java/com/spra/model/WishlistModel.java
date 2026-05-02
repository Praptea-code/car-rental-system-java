package com.spra.model;

import java.sql.Timestamp;

/**
 * WishlistModel
 * Represents a wishlist entry — a saved product for a user.
 * Joins product fields for display so JSP doesn't need a second lookup.
 *
 * @author Spra Team
 */
public class WishlistModel {

    private int       wishlistId;
    private int       userId;
    private int       productId;
    private Timestamp createdAt;

    // Joined from products table for display
    private String    productName;
    private double    productPrice;
    private double    productOldPrice;
    private String    productImagePath;
    private String    categoryName;
    private boolean   outOfStock;

    public WishlistModel() {}

    // Getters & Setters

    public int getWishlistId()                          { return wishlistId; }
    public void setWishlistId(int wishlistId)           { this.wishlistId = wishlistId; }

    public int getUserId()                              { return userId; }
    public void setUserId(int userId)                   { this.userId = userId; }

    public int getProductId()                           { return productId; }
    public void setProductId(int productId)             { this.productId = productId; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp t)               { this.createdAt = t; }

    public String getProductName()                      { return productName; }
    public void setProductName(String productName)      { this.productName = productName; }

    public double getProductPrice()                     { return productPrice; }
    public void setProductPrice(double productPrice)    { this.productPrice = productPrice; }

    public double getProductOldPrice()                  { return productOldPrice; }
    public void setProductOldPrice(double v)            { this.productOldPrice = v; }

    public String getProductImagePath()                           { return productImagePath; }
    public void setProductImagePath(String productImagePath)      { this.productImagePath = productImagePath; }

    public String getCategoryName()                     { return categoryName; }
    public void setCategoryName(String categoryName)    { this.categoryName = categoryName; }

    public boolean isOutOfStock()                       { return outOfStock; }
    public void setOutOfStock(boolean outOfStock)       { this.outOfStock = outOfStock; }

    /** Discount % helper, same logic as ProductModel. */
    public int getDiscountPercent() {
        if (productOldPrice <= 0 || productOldPrice <= productPrice) return 0;
        return (int) Math.round((1.0 - productPrice / productOldPrice) * 100);
    }
}