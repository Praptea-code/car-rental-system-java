package com.spra.dao;

import com.spra.config.DbConfig;
import com.spra.model.ProductModel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO
 * Data Access Object for all product-related database operations.
 *
 * @author Spra Team
 */
public class ProductDAO {

    /**
     * Returns all products joined with their category name.
     */
    public List<ProductModel> getAllProducts() {
        return queryProducts("SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "ORDER BY p.created_at DESC");
    }

    /**
     * Returns only featured products for the home page section.
     */
    public List<ProductModel> getFeaturedProducts() {
        return queryProducts("SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.is_featured = 1 ORDER BY p.created_at DESC");
    }

    /**
     * Returns the top bestseller product for the spotlight section.
     */
    public ProductModel getBestseller() {
        List<ProductModel> list = queryProducts(
                "SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.is_bestseller = 1 LIMIT 1");
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Returns products filtered by category id.
     */
    public List<ProductModel> getByCategory(int categoryId) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ? ORDER BY p.created_at DESC";
        return queryProductsParam(sql, String.valueOf(categoryId));
    }

    /**
     * Searches products by name keyword (LIKE search).
     */
    public List<ProductModel> searchProducts(String keyword) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.name LIKE ? ORDER BY p.name";
        return queryProductsParam(sql, "%" + keyword + "%");
    }

    /**
     * Retrieves a single product by its id.
     */
    public ProductModel getProductById(int productId) {
        String sql = "SELECT p.*, c.name AS category_name "
                + "FROM products p LEFT JOIN categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?";
        List<ProductModel> list = queryProductsParam(sql, String.valueOf(productId));
        return list.isEmpty() ? null : list.get(0);
    }

    /**
     * Inserts a new product. Returns the generated product_id, or -1 on failure.
     */
    public int addProduct(ProductModel product) {
        String sql = "INSERT INTO products (name, description, price, old_price, stock, "
                + "image_path, category_id, is_featured, is_bestseller) VALUES (?,?,?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setDouble(4, product.getOldPrice());
            ps.setInt(5, product.getStock());
            ps.setString(6, product.getImagePath());
            ps.setInt(7, product.getCategoryId());
            ps.setBoolean(8, product.isFeatured());
            ps.setBoolean(9, product.isBestseller());
            ps.executeUpdate();
            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ProductDAO.addProduct] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return -1;
    }

    /**
     * Updates an existing product record.
     */
    public boolean updateProduct(ProductModel product) {
        String sql = "UPDATE products SET name=?, description=?, price=?, old_price=?, stock=?, "
                + "image_path=?, category_id=?, is_featured=?, is_bestseller=? WHERE product_id=?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setDouble(3, product.getPrice());
            ps.setDouble(4, product.getOldPrice());
            ps.setInt(5, product.getStock());
            ps.setString(6, product.getImagePath());
            ps.setInt(7, product.getCategoryId());
            ps.setBoolean(8, product.isFeatured());
            ps.setBoolean(9, product.isBestseller());
            ps.setInt(10, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ProductDAO.updateProduct] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    /**
     * Deletes a product by id.
     */
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id = ?";
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ProductDAO.deleteProduct] " + e.getMessage());
            return false;
        } finally {
            DbConfig.closeConnection(conn);
        }
    }

    // ---- Private helpers ----

    /** Runs a no-parameter query and returns a list of ProductModel. */
    private List<ProductModel> queryProducts(String sql) {
        List<ProductModel> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ProductDAO.queryProducts] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /** Runs a single-parameter query and returns a list of ProductModel. */
    private List<ProductModel> queryProductsParam(String sql, String param) {
        List<ProductModel> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DbConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, param);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[ProductDAO.queryProductsParam] " + e.getMessage());
        } finally {
            DbConfig.closeConnection(conn);
        }
        return list;
    }

    /** Maps a ResultSet row to a ProductModel. */
    private ProductModel mapRow(ResultSet rs) throws SQLException {
        ProductModel p = new ProductModel();
        p.setProductId(rs.getInt("product_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setOldPrice(rs.getDouble("old_price"));
        p.setStock(rs.getInt("stock"));
        p.setImagePath(rs.getString("image_path"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setCategoryName(rs.getString("category_name"));
        p.setFeatured(rs.getBoolean("is_featured"));
        p.setBestseller(rs.getBoolean("is_bestseller"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
