package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.CartItem;
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
     * Call this right after placeOrder() succeeds.
     */
    public boolean saveOrderItems(int orderId, List<CartItem> items) {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            for (CartItem item : items) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getProductId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            System.err.println("[OrderDAO.saveOrderItems] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Decrements stock for all products in the given order.
     * Call this when status changes to SHIPPED.
     * Uses MAX(0, stock - qty) to avoid going negative.
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
     * Updates the order status. If changing to SHIPPED, also decrements product stock.
     */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            boolean updated = ps.executeUpdate() > 0;

            // Decrement stock when order ships
            if (updated && "SHIPPED".equalsIgnoreCase(status)) {
                decrementStockForOrder(orderId);
            }

            return updated;
        } catch (SQLException e) {
            System.err.println("[OrderDAO.updateStatus] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
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
}