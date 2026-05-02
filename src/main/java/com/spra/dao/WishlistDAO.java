package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.WishlistModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * WishlistDAO
 * Data Access Object for wishlist operations.
 * Each user can save a product once (UNIQUE key enforced in DB).
 *
 * @author Spra Team
 */
public class WishlistDAO {

    /**
     * Adds a product to a user's wishlist.
     * Silently ignores duplicates (INSERT IGNORE).
     *
     * @return true if the row was actually inserted (not a duplicate)
     */
    public boolean addToWishlist(int userId, int productId) {
        String sql = "INSERT IGNORE INTO wishlists (user_id, product_id) VALUES (?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[WishlistDAO.addToWishlist] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Removes a product from a user's wishlist.
     *
     * @return true if a row was deleted
     */
    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlists WHERE user_id = ? AND product_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[WishlistDAO.removeFromWishlist] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Checks whether a specific product is already on a user's wishlist.
     */
    public boolean isWishlisted(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ? AND product_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("[WishlistDAO.isWishlisted] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return false;
    }

    /**
     * Returns all wishlisted products for a user, joined with product & category info,
     * newest first.
     */
    public List<WishlistModel> getWishlistByUser(int userId) {
        List<WishlistModel> list = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.user_id, w.product_id, w.created_at, "
                   + "p.name AS product_name, p.price, p.old_price, p.image_path, "
                   + "p.stock, c.name AS category_name "
                   + "FROM wishlists w "
                   + "JOIN products p ON w.product_id = p.product_id "
                   + "LEFT JOIN categories c ON p.category_id = c.category_id "
                   + "WHERE w.user_id = ? "
                   + "ORDER BY w.created_at DESC";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                WishlistModel wm = new WishlistModel();
                wm.setWishlistId(rs.getInt("wishlist_id"));
                wm.setUserId(rs.getInt("user_id"));
                wm.setProductId(rs.getInt("product_id"));
                wm.setCreatedAt(rs.getTimestamp("created_at"));
                wm.setProductName(rs.getString("product_name"));
                wm.setProductPrice(rs.getDouble("price"));
                wm.setProductOldPrice(rs.getDouble("old_price"));
                wm.setProductImagePath(rs.getString("image_path"));
                wm.setCategoryName(rs.getString("category_name"));
                wm.setOutOfStock(rs.getInt("stock") <= 0);
                list.add(wm);
            }
        } catch (SQLException e) {
            System.err.println("[WishlistDAO.getWishlistByUser] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /**
     * Returns the number of items on a user's wishlist.
     */
    public int getWishlistCount(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[WishlistDAO.getWishlistCount] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return 0;
    }
}