package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.CategoryModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CategoryDAO
 * Data Access Object for product category operations.
 *
 * @author Spra Team
 */
public class CategoryDAO {

    /** Returns all categories ordered by name. */
    public List<CategoryModel> getAllCategories() {
        List<CategoryModel> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[CategoryDAO.getAllCategories] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /** Returns a single category by id. */
    public CategoryModel getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[CategoryDAO.getCategoryById] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return null;
    }

    /** Inserts a new category. */
    public boolean addCategory(CategoryModel category) {
        String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, category.getName());
            ps.setString(2, category.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CategoryDAO.addCategory] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /** Deletes a category by id. */
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[CategoryDAO.deleteCategory] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    private CategoryModel mapRow(ResultSet rs) throws SQLException {
        CategoryModel c = new CategoryModel();
        c.setCategoryId(rs.getInt("category_id"));
        c.setName(rs.getString("name"));
        c.setDescription(rs.getString("description"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
