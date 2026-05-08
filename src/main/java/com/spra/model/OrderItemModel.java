package com.spra.model;

/**
 * OrderItemModel
 * Represents a single line item within an order, joined with product info.
 *
 * @author Spra Team
 */
public class OrderItemModel {

    private int    itemId;
    private int    orderId;
    private int    productId;
    private int    quantity;
    private double price;

    // Joined from products table
    private String productName;
    private String imagePath;
    private String categoryName;

    public OrderItemModel() {}

    public int    getItemId()                          { return itemId; }
    public void   setItemId(int itemId)                { this.itemId = itemId; }

    public int    getOrderId()                         { return orderId; }
    public void   setOrderId(int orderId)              { this.orderId = orderId; }

    public int    getProductId()                       { return productId; }
    public void   setProductId(int productId)          { this.productId = productId; }

    public int    getQuantity()                        { return quantity; }
    public void   setQuantity(int quantity)            { this.quantity = quantity; }

    public double getPrice()                           { return price; }
    public void   setPrice(double price)               { this.price = price; }

    public String getProductName()                     { return productName; }
    public void   setProductName(String productName)   { this.productName = productName; }

    public String getImagePath()                       { return imagePath; }
    public void   setImagePath(String imagePath)       { this.imagePath = imagePath; }

    public String getCategoryName()                    { return categoryName; }
    public void   setCategoryName(String categoryName) { this.categoryName = categoryName; }

    /** Line subtotal */
    public double getSubtotal() { return price * quantity; }
}