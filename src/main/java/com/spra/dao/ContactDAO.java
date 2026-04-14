package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.ContactModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ContactDAO
 * Data Access Object for contact message operations.
 *
 * @author Spra Team
 */
public class ContactDAO {

    /** Saves a new contact message to the database. */
    public boolean saveMessage(ContactModel msg) {
        String sql = "INSERT INTO contact_messages (first_name, last_name, email, subject, message) "
                   + "VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, msg.getFirstName());
            ps.setString(2, msg.getLastName());
            ps.setString(3, msg.getEmail());
            ps.setString(4, msg.getSubject());
            ps.setString(5, msg.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ContactDAO.saveMessage] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /** Returns all contact messages ordered by newest first (admin view). */
    public List<ContactModel> getAllMessages() {
        List<ContactModel> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_messages ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                ContactModel m = new ContactModel();
                m.setMessageId(rs.getInt("message_id"));
                m.setFirstName(rs.getString("first_name"));
                m.setLastName(rs.getString("last_name"));
                m.setEmail(rs.getString("email"));
                m.setSubject(rs.getString("subject"));
                m.setMessage(rs.getString("message"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(m);
            }
        } catch (SQLException e) {
            System.err.println("[ContactDAO.getAllMessages] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }
}
