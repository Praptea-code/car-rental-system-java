package com.spra.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DbConfig
 * Manages the JDBC connection to the spra_db MySQL database.
 * Uses XAMPP MySQL running on localhost:3306.
 *
 * @author Spra Team
 */
public class DbConfig {

    private static final String DB_URL      = "jdbc:mysql://localhost:3306/spra_db?useSSL=false&serverTimezone=UTC";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "";
    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // Utility class — no instantiation
    private DbConfig() {}

    /**
     * Opens and returns a Connection to spra_db.
     * Caller must close the connection when done.
     *
     * @return live Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER_CLASS);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found. "
                    + "Add mysql-connector-j.jar to WEB-INF/lib", e);
        }
    }

    /**
     * Silently closes a Connection — avoids try/catch boilerplate in callers.
     *
     * @param conn the Connection to close (may be null)
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); }
            catch (SQLException e) {
                System.err.println("[DbConfig] Could not close connection: " + e.getMessage());
            }
        }
    }
}
