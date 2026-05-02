package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.ReviewModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ReviewDAO
 * Data Access Object for product review operations.
 *
 * @author Spra Team
 */
public class ReviewDAO {

    /**
     * Inserts a new review. Returns the generated review_id, or -1 on failure.
     */
    public int addReview(ReviewModel review) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, title, body) "
                   + "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getTitle());
            ps.setString(5, review.getBody());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.addReview] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return -1;
    }

    /**
     * Returns all reviews for a given product, newest first,
     * joined with user first/last name.
     */
    public List<ReviewModel> getReviewsByProduct(int productId) {
        List<ReviewModel> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username, u.first_name, u.last_name "
                   + "FROM reviews r "
                   + "JOIN users u ON r.user_id = u.user_id "
                   + "WHERE r.product_id = ? "
                   + "ORDER BY r.created_at DESC";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.getReviewsByProduct] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /**
     * Returns the average rating for a product (0.0 if no reviews).
     */
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.getAverageRating] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return 0.0;
    }

    /**
     * Returns the total number of reviews for a product.
     */
    public int getReviewCount(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.getReviewCount] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return 0;
    }

    /**
     * Checks whether a specific user has already reviewed a specific product.
     */
    public boolean hasUserReviewed(int productId, int userId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = ? AND user_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.hasUserReviewed] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return false;
    }

    /**
     * Returns rating distribution as an int[5] where index 0 = count of 1-star,
     * index 4 = count of 5-star.
     */
    public int[] getRatingDistribution(int productId) {
        int[] dist = new int[5];
        String sql = "SELECT rating, COUNT(*) AS cnt FROM reviews "
                   + "WHERE product_id = ? GROUP BY rating";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int r = rs.getInt("rating");
                if (r >= 1 && r <= 5) dist[r - 1] = rs.getInt("cnt");
            }
        } catch (SQLException e) {
            System.err.println("[ReviewDAO.getRatingDistribution] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return dist;
    }

    // ---- Private helper ----

    private ReviewModel mapRow(ResultSet rs) throws SQLException {
        ReviewModel r = new ReviewModel();
        r.setReviewId(rs.getInt("review_id"));
        r.setProductId(rs.getInt("product_id"));
        r.setUserId(rs.getInt("user_id"));
        r.setRating(rs.getInt("rating"));
        r.setTitle(rs.getString("title"));
        r.setBody(rs.getString("body"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        r.setUsername(rs.getString("username"));
        r.setFirstName(rs.getString("first_name"));
        r.setLastName(rs.getString("last_name"));
        return r;
    }
}