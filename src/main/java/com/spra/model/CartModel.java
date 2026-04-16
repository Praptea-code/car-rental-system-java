package com.spra.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * CartModel
 * Session-scoped shopping cart. Stored as a session attribute.
 *
 * @author Spra Team
 */
public class CartModel implements Serializable {

    private static final long serialVersionUID = 1L;

    private List<CartItem> items = new ArrayList<>();

    // ---- Operations ----

    /**
     * Adds a product or increments its quantity if already present.
     */
    public void addItem(CartItem newItem) {
        for (CartItem item : items) {
            if (item.getProductId() == newItem.getProductId()) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }

    /**
     * Removes a product by its id.
     */
    public void removeItem(int productId) {
        items.removeIf(item -> item.getProductId() == productId);
    }

    /**
     * Updates the quantity of a specific item. Removes it if qty <= 0.
     */
    public void updateQuantity(int productId, int quantity) {
        if (quantity <= 0) {
            removeItem(productId);
            return;
        }
        for (CartItem item : items) {
            if (item.getProductId() == productId) {
                item.setQuantity(quantity);
                return;
            }
        }
    }

    /** Clears all items. */
    public void clear() {
        items.clear();
    }

    /** Returns the total number of individual units. */
    public int getTotalCount() {
        int count = 0;
        for (CartItem item : items) count += item.getQuantity();
        return count;
    }

    /** Returns the grand total price. */
    public double getGrandTotal() {
        double total = 0;
        for (CartItem item : items) total += item.getSubtotal();
        return total;
    }

    public List<CartItem> getItems()         { return items; }
    public boolean isEmpty()                 { return items.isEmpty(); }
}