package util;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Singleton Pattern implementation for Database Connection Manager.
 * Follows Gang of Four (GoF) Creational Design Pattern:
 * 1. Private constructor to prevent direct instantiation
 * 2. Static instance variable holding the single object
 * 3. Static getInstance() method providing global access point
 */
public class DBConnection {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=CustomerCareDB;encrypt=true;trustServerCertificate=true;";
    private static final String USER = "sa"; // SSMS Login Username
    private static final String PASSWORD = "2002"; // SSMS Password

    // Step #2: Static instance variable
    private static DBConnection instance;

    // Step #1: Private constructor to prevent external instantiation
    private DBConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
        }
    }

    // Step #3: Static method to get the singleton instance
    public static synchronized DBConnection getInstance() {
        if (instance == null) {
            instance = new DBConnection();
        }
        return instance;
    }

    // Instance method to get a new database connection
    public Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (Exception e) {
            System.err.println("Database Connection Error: " + e.getMessage());
        }
        return conn;
    }

    // Testing / verification method
    public static void main(String[] args) {
        DBConnection db1 = DBConnection.getInstance();
        DBConnection db2 = DBConnection.getInstance();
        System.out.println("Singleton check (db1 == db2): " + (db1 == db2));
    }
}
