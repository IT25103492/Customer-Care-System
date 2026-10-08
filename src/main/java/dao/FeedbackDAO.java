package dao;

import model.Feedback;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean createFeedback(Feedback feedback) {
        boolean isSuccess = false;
        String query = "INSERT INTO Feedbacks (CustomerID, TicketID, Rating, Comments) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, feedback.getUserId());
            if (feedback.getTicketId() != null && feedback.getTicketId() > 0) {
                ps.setInt(2, feedback.getTicketId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComments());

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT f.*, u.FullName AS CustomerName, t.Subject AS TicketSubject " +
                       "FROM Feedbacks f " +
                       "LEFT JOIN Users u ON f.CustomerID = u.UserID " +
                       "LEFT JOIN Tickets t ON f.TicketID = t.TicketID " +
                       "ORDER BY f.FeedbackID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setFeedbackId(rs.getInt("FeedbackID"));
                fb.setUserId(rs.getInt("CustomerID"));
                fb.setCustomerName(rs.getString("CustomerName"));
                fb.setTicketId(rs.getObject("TicketID") != null ? rs.getInt("TicketID") : null);
                fb.setTicketSubject(rs.getString("TicketSubject"));
                fb.setRating(rs.getInt("Rating"));
                fb.setComments(rs.getString("Comments"));
                fb.setCreatedAt(rs.getTimestamp("CreatedAt"));
                fb.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Feedback> getFeedbacksByCustomerId(int customerId) {
        List<Feedback> list = new ArrayList<>();
        String query = "SELECT f.*, u.FullName AS CustomerName, t.Subject AS TicketSubject " +
                       "FROM Feedbacks f " +
                       "LEFT JOIN Users u ON f.CustomerID = u.UserID " +
                       "LEFT JOIN Tickets t ON f.TicketID = t.TicketID " +
                       "WHERE f.CustomerID = ? ORDER BY f.FeedbackID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setFeedbackId(rs.getInt("FeedbackID"));
                    fb.setUserId(rs.getInt("CustomerID"));
                    fb.setCustomerName(rs.getString("CustomerName"));
                    fb.setTicketId(rs.getObject("TicketID") != null ? rs.getInt("TicketID") : null);
                    fb.setTicketSubject(rs.getString("TicketSubject"));
                    fb.setRating(rs.getInt("Rating"));
                    fb.setComments(rs.getString("Comments"));
                    fb.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    fb.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    list.add(fb);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateFeedback(Feedback feedback) {
        String query = "UPDATE Feedbacks SET Rating = ?, Comments = ?, UpdatedAt = GETDATE() WHERE FeedbackID = ? AND CustomerID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, feedback.getRating());
            ps.setString(2, feedback.getComments());
            ps.setInt(3, feedback.getFeedbackId());
            ps.setInt(4, feedback.getUserId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateFeedbackByManager(int feedbackId, int rating, String comments) {
        String query = "UPDATE Feedbacks SET Rating = ?, Comments = ?, UpdatedAt = GETDATE() WHERE FeedbackID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, rating);
            ps.setString(2, comments);
            ps.setInt(3, feedbackId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteFeedback(int feedbackId) {
        String query = "DELETE FROM Feedbacks WHERE FeedbackID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, feedbackId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getAverageRating() {
        String query = "SELECT AVG(CAST(Rating AS FLOAT)) AS AvgRating FROM Feedbacks";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("AvgRating");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}