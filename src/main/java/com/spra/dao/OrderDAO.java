package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.CartItem;
import com.spra.model.OrderItemModel;
import com.spra.model.OrderModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(OrderModel order) {
        String sql = "INSERT INTO orders (user_id, full_name, phone, address, city, total_amount, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'ORDERED')";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getFullName());
            ps.setString(3, order.getPhone());
            ps.setString(4, order.getAddress());
            ps.setString(5, order.getCity());
            ps.setDouble(6, order.getTotalAmount());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            System.err.println("[OrderDAO.placeOrder] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return -1;
    }

    /**
     * Saves cart items into order_items for a given order.
     */
    public boolean saveOrderItems(int orderId, List<CartItem> items) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        int savedCount = 0;
        try {
            conn = DbConfig.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement ps = conn.prepareStatement(sql);
            for (CartItem item : items) {
                try {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.setDouble(4, item.getPrice());
                    ps.executeUpdate();
                    savedCount++;
                } catch (SQLException itemEx) {
                    System.err.println("[OrderDAO.saveOrderItems] Failed to save item productId="
                        + item.getProductId() + " for orderId=" + orderId
                        + " — " + itemEx.getMessage());
                    // continue saving other items even if one fails
                }
            }
            conn.commit();
            System.out.println("[OrderDAO.saveOrderItems] Saved " + savedCount + "/" + items.size()
                + " items for orderId=" + orderId);
            return savedCount > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO.saveOrderItems] " + e.getMessage());
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException rb) {
                    System.err.println("[OrderDAO.saveOrderItems] Rollback failed: " + rb.getMessage());
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); } catch (SQLException e) { /* ignore */ }
            }
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Returns all line items for a given order, joined with product name,
     * image, and category — used by the order detail popup on both user and admin pages.
     */
    public List<OrderItemModel> getOrderItems(int orderId) {
        List<OrderItemModel> list = new ArrayList<>();
        String sql = "SELECT oi.item_id, oi.order_id, oi.product_id, oi.quantity, oi.price, " +
                     "p.name AS product_name, p.image_path, c.name AS category_name " +
                     "FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.product_id " +
                     "LEFT JOIN categories c ON p.category_id = c.category_id " +
                     "WHERE oi.order_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItemModel item = new OrderItemModel();
                item.setItemId(rs.getInt("item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                item.setProductName(rs.getString("product_name"));
                item.setImagePath(rs.getString("image_path"));
                item.setCategoryName(rs.getString("category_name"));
                list.add(item);
            }
        } catch (SQLException e) {
            System.err.println("[OrderDAO.getOrderItems] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /**
     * Decrements stock for all products in the given order.
     */
    public boolean decrementStockForOrder(int orderId) {
        String sql = "UPDATE products p " +
                     "JOIN order_items oi ON p.product_id = oi.product_id " +
                     "SET p.stock = GREATEST(0, p.stock - oi.quantity) " +
                     "WHERE oi.order_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO.decrementStockForOrder] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    public List<OrderModel> getAllOrders() {
        List<OrderModel> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username, u.email AS user_email FROM orders o " +
                     "LEFT JOIN users u ON o.user_id = u.user_id ORDER BY o.created_at DESC";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs, true));
        } catch (SQLException e) {
            System.err.println("[OrderDAO.getAllOrders] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    public List<OrderModel> getOrdersByUser(int userId) {
        List<OrderModel> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs, false));
        } catch (SQLException e) {
            System.err.println("[OrderDAO.getOrdersByUser] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /**
     * Updates order status. Decrements stock only on first transition to SHIPPED.
     */
    public boolean updateStatus(int orderId, String newStatus) {
        String currentStatus = getCurrentStatus(orderId);

        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        Connection conn = null;
        boolean updated = false;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            updated = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrderDAO.updateStatus] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }

        if (updated
                && "SHIPPED".equalsIgnoreCase(newStatus)
                && !"SHIPPED".equalsIgnoreCase(currentStatus)) {
            decrementStockForOrder(orderId);
        }

        return updated;
    }

    private String getCurrentStatus(int orderId) {
        String sql = "SELECT status FROM orders WHERE order_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("status");
        } catch (SQLException e) {
            System.err.println("[OrderDAO.getCurrentStatus] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return null;
    }

    private OrderModel mapRow(ResultSet rs, boolean withUser) throws SQLException {
        OrderModel o = new OrderModel();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setFullName(rs.getString("full_name"));
        o.setPhone(rs.getString("phone"));
        o.setAddress(rs.getString("address"));
        o.setCity(rs.getString("city"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        if (withUser) {
            try { o.setUsername(rs.getString("username")); } catch (Exception ignored) {}
            try { o.setUserEmail(rs.getString("user_email")); } catch (Exception ignored) {}
        }
        return o;
    }

        public boolean hasUserReceivedProduct(int userId, int productId) {
            String sql = "SELECT COUNT(*) FROM orders o " +
                         "JOIN order_items oi ON o.order_id = oi.order_id " +
                         "WHERE o.user_id = ? AND oi.product_id = ? " +
                         "AND o.status IN ('SHIPPED', 'DELIVERED')";
            Connection conn = null;
            try {
                conn = DbConfig.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) return rs.getInt(1) > 0;
            } catch (SQLException e) {
                System.err.println("[OrderDAO.hasUserReceivedProduct] " + e.getMessage());
            } finally {
                DbConfig.closeConnection(conn);
            }
            return false;
        }
     
}