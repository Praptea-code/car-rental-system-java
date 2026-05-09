package com.spra.dao;

import com.spra.config.DbConfig;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * PasswordResetDAO
 * Manages password-reset tokens in the password_reset_tokens table.
 *
 * @author Spra Team
 */
public class PasswordResetDAO {

    /**
     * Creates a new reset token for the given user, valid for 30 minutes.
     * Any old unused tokens for the same user are deleted first.
     *
     * @param userId the user's id
     * @return the generated token string, or null on failure
     */
    public String createToken(int userId) {
        // Delete any existing tokens for this user
        deleteTokensByUser(userId);

        String token  = UUID.randomUUID().toString().replace("-", "");   // 32-hex chars
        String sql    = "INSERT INTO password_reset_tokens (user_id, token, expires_at) VALUES (?, ?, ?)";
        Timestamp expires = Timestamp.valueOf(LocalDateTime.now().plusMinutes(30));

        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, expires);
            if (ps.executeUpdate() > 0) return token;
        } catch (SQLException e) {
            System.err.println("[PasswordResetDAO.createToken] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return null;
    }

    /**
     * Looks up a token record.
     * Returns the userId if the token exists, is unused, and has not expired.
     * Returns -1 otherwise.
     *
     * @param token the raw token string from the URL
     * @return userId on success, -1 on failure
     */
    public int validateToken(String token) {
        String sql = "SELECT user_id, expires_at, used FROM password_reset_tokens WHERE token = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean used    = rs.getBoolean("used");
                Timestamp exp   = rs.getTimestamp("expires_at");
                boolean expired = exp.before(Timestamp.valueOf(LocalDateTime.now()));
                if (!used && !expired) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("[PasswordResetDAO.validateToken] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return -1;
    }

    /**
     * Marks a token as used so it cannot be reused.
     */
    public boolean markUsed(String token) {
        String sql = "UPDATE password_reset_tokens SET used = 1 WHERE token = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[PasswordResetDAO.markUsed] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /** Deletes all tokens belonging to a user (cleanup before issuing a new one). */
    private void deleteTokensByUser(int userId) {
        String sql = "DELETE FROM password_reset_tokens WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[PasswordResetDAO.deleteTokensByUser] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
    }
}