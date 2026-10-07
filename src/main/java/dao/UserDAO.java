package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public boolean registerUser(User user) {
        boolean isSuccess = false;
        String query = "INSERT INTO Users (FullName, Email, Password, Role, ContactNo, Status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole() != null ? user.getRole() : "Customer");
            ps.setString(5, user.getContactNo());
            ps.setString(6, user.getStatus() != null ? user.getStatus() : "Active");

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public User validateUser(String email, String password) {
        User user = null;
        String query = "SELECT * FROM Users WHERE Email = ? AND Password = ? AND Status = 'Active'";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, email.trim());
            ps.setString(2, password.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromRS(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT * FROM Users WHERE UserID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromRS(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users ORDER BY UserID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractUserFromRS(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<User> getUsersByRole(String role) {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE Role = ? AND Status = 'Active' ORDER BY FullName ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractUserFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateUserProfile(User user) {
        boolean isSuccess = false;
        String query = "UPDATE Users SET FullName = ?, Email = ?, ContactNo = ? WHERE UserID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getContactNo());
            ps.setInt(4, user.getUserId());

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public boolean updatePassword(int userId, String newPassword) {
        String query = "UPDATE Users SET Password = ? WHERE UserID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserRoleAndStatus(int userId, String role, String status) {
        String query = "UPDATE Users SET Role = ?, Status = ? WHERE UserID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, role);
            ps.setString(2, status);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deactivateAccount(int userId) {
        String query = "UPDATE Users SET Status = 'Deactivated' WHERE UserID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getActiveUsers() {
        List<User> list = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE Status = 'Active' ORDER BY UserID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractUserFromRS(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean deleteUser(int userId) {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Unassign references
            try (PreparedStatement ps = conn.prepareStatement("UPDATE Tickets SET AssignedTo = NULL WHERE AssignedTo = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("UPDATE Enquiries SET RespondedBy = NULL WHERE RespondedBy = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("UPDATE Escalations SET EscalatedTo = NULL WHERE EscalatedTo = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Delete messages
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Messages WHERE SenderID = ? OR ReceiverID = ?")) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }
            // Delete escalations created by user
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Escalations WHERE EscalatedBy = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Delete feedbacks
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Feedbacks WHERE CustomerID = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Delete notifications
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Notifications WHERE UserID = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Delete tickets
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Tickets WHERE CustomerID = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Delete enquiries
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Enquiries WHERE CustomerID = ?")) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            // Finally delete the user
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Users WHERE UserID = ?")) {
                ps.setInt(1, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private User extractUserFromRS(ResultSet rs) {
        User u = new User();
        try {
            u.setUserId(rs.getInt("UserID"));
        } catch (Exception ignored) {}
        try {
            u.setFullName(rs.getString("FullName"));
        } catch (Exception ignored) {}
        try {
            u.setEmail(rs.getString("Email"));
        } catch (Exception ignored) {}
        try {
            u.setPassword(rs.getString("Password"));
        } catch (Exception ignored) {}
        try {
            u.setRole(rs.getString("Role"));
        } catch (Exception ignored) {}
        try {
            u.setContactNo(rs.getString("ContactNo"));
        } catch (Exception ignored) {}
        try {
            u.setStatus(rs.getString("Status"));
        } catch (Exception ignored) {}
        try {
            u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        } catch (Exception ignored) {}
        return u;
    }
}