package com.spra.model;

/**
 * CartItem
 * Represents a single line item inside the shopping cart session.
 *
 * @author Spra Team
 */
public class CartItem {

    private int    productId;
    private String name;
    private double price;
    private String imagePath;
    private String categoryName;
    private int    quantity;

    public CartItem() {}

    public CartItem(int productId, String name, double price,
                    String imagePath, String categoryName, int quantity) {
        this.productId    = productId;
        this.name         = name;
        this.price        = price;
        this.imagePath    = imagePath;
        this.categoryName = categoryName;
        this.quantity     = quantity;
    }

    // ---- Getters & Setters ----

    public int getProductId()                        { return productId; }
    public void setProductId(int productId)          { this.productId = productId; }

    public String getName()                          { return name; }
    public void setName(String name)                 { this.name = name; }

    public double getPrice()                         { return price; }
    public void setPrice(double price)               { this.price = price; }

    public String getImagePath()                     { return imagePath; }
    public void setImagePath(String imagePath)       { this.imagePath = imagePath; }

    public String getCategoryName()                  { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public int getQuantity()                         { return quantity; }
    public void setQuantity(int quantity)            { this.quantity = quantity; }

    /** Returns the subtotal for this line item. */
    public double getSubtotal() {
        return price * quantity;
    }
}