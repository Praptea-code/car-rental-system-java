package com.spra.dao;

import com.spra.config.DbConfig;
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

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
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