package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.UserModel;

import java.sql.*;

/**
 * UserDAO
 * Data Access Object for all user-related database operations.
 *
 * @author Spra Team
 */
public class UserDAO {

    /**
     * Inserts a new user record into the users table.
     *
     * @param user  populated UserModel (password should already be hashed)
     * @return true if insert was successful
     */
    public boolean registerUser(UserModel user) {
        String sql = "INSERT INTO users (first_name, last_name, username, email, phone, password, birthdate, role) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getUsername());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getPassword());
            ps.setString(7, user.getBirthdate());
            ps.setString(8, user.getRole() != null ? user.getRole() : "USER");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO.registerUser] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Retrieves a user by username (used during login).
     *
     * @param username  the username to look up
     * @return UserModel if found, null otherwise
     */
    public UserModel getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[UserDAO.getUserByUsername] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return null;
    }

    /**
     * Retrieves a user by user_id.
     */
    public UserModel getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[UserDAO.getUserById] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return null;
    }

    /**
     * Checks if a username already exists in the database.
     */
    public boolean usernameExists(String username) {
        return countByField("username", username) > 0;
    }

    /**
     * Checks if an email already exists in the database.
     */
    public boolean emailExists(String email) {
        return countByField("email", email) > 0;
    }

    /**
     * Checks if a phone number already exists in the database.
     */
    public boolean phoneExists(String phone) {
        return countByField("phone", phone) > 0;
    }

    /**
     * Updates a user's first name, last name, email, and phone.
     */
    public boolean updateProfile(UserModel user) {
        String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone=? WHERE user_id=?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO.updateProfile] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Updates the user's hashed password.
     */
    public boolean updatePassword(int userId, String newHashedPassword) {
        String sql = "UPDATE users SET password=? WHERE user_id=?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO.updatePassword] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Increments login_attempts counter. Locks account after 5 failed attempts
     * for 15 minutes.
     */
    public void incrementLoginAttempts(String username) {
        String sql = "UPDATE users SET login_attempts = login_attempts + 1, "
                   + "locked_until = CASE WHEN login_attempts + 1 >= 5 "
                   + "THEN DATE_ADD(NOW(), INTERVAL 15 MINUTE) ELSE locked_until END "
                   + "WHERE username = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[UserDAO.incrementLoginAttempts] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Resets login_attempts to 0 and clears locked_until on successful login.
     */
    public void resetLoginAttempts(String username) {
        String sql = "UPDATE users SET login_attempts=0, locked_until=NULL WHERE username=?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("[UserDAO.resetLoginAttempts] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    // ---- Private helpers ----

    /** Generic count-by-field helper to check duplicates. */
    private int countByField(String field, String value) {
        String sql = "SELECT COUNT(*) FROM users WHERE " + field + " = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, value);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[UserDAO.countByField] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return 0;
    }

    /** Maps a ResultSet row to a UserModel object. */
    private UserModel mapRow(ResultSet rs) throws SQLException {
        UserModel u = new UserModel();
        u.setUserId(rs.getInt("user_id"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setPassword(rs.getString("password"));
        u.setBirthdate(rs.getString("birthdate"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("is_active"));
        u.setLoginAttempts(rs.getInt("login_attempts"));
        u.setLockedUntil(rs.getTimestamp("locked_until"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
