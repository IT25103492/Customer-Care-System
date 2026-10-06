package dao;

import model.Enquiry;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class EnquiryDAO {

    public boolean createEnquiry(Enquiry enquiry) {
        String query = "INSERT INTO Enquiries (EnquiryNumber, CustomerID, Subject, Message, Status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            String enqNum = "ENQ-2026-" + (1000 + new Random().nextInt(9000));
            enquiry.setEnquiryNumber(enqNum);

            ps.setString(1, enqNum);
            ps.setInt(2, enquiry.getCustomerId());
            ps.setString(3, enquiry.getSubject());
            ps.setString(4, enquiry.getMessage());
            ps.setString(5, enquiry.getStatus() != null ? enquiry.getStatus() : "Pending");

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Enquiry> getAllEnquiries() {
        List<Enquiry> list = new ArrayList<>();
        String query = "SELECT e.*, c.FullName AS CustomerName, r.FullName AS RespondedByName " +
                       "FROM Enquiries e " +
                       "LEFT JOIN Users c ON e.CustomerID = c.UserID " +
                       "LEFT JOIN Users r ON e.RespondedBy = r.UserID " +
                       "ORDER BY e.EnquiryID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractEnquiryFromRS(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Enquiry> getEnquiriesByCustomerId(int customerId) {
        List<Enquiry> list = new ArrayList<>();
        String query = "SELECT e.*, c.FullName AS CustomerName, r.FullName AS RespondedByName " +
                       "FROM Enquiries e " +
                       "LEFT JOIN Users c ON e.CustomerID = c.UserID " +
                       "LEFT JOIN Users r ON e.RespondedBy = r.UserID " +
                       "WHERE e.CustomerID = ? ORDER BY e.EnquiryID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractEnquiryFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateEnquiryResponse(int enquiryId, String response, String status, int respondedBy) {
        String query = "UPDATE Enquiries SET Response = ?, Status = ?, RespondedBy = ? WHERE EnquiryID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, response);
            ps.setString(2, status);
            ps.setInt(3, respondedBy);
            ps.setInt(4, enquiryId);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Enquiry getEnquiryById(int enquiryId) {
        Enquiry e = null;
        String query = "SELECT e.*, c.FullName AS CustomerName, r.FullName AS RespondedByName " +
                       "FROM Enquiries e " +
                       "LEFT JOIN Users c ON e.CustomerID = c.UserID " +
                       "LEFT JOIN Users r ON e.RespondedBy = r.UserID " +
                       "WHERE e.EnquiryID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, enquiryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    e = extractEnquiryFromRS(rs);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return e;
    }

    public boolean deleteEnquiry(int enquiryId) {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Delete dependent messages first
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Messages WHERE EnquiryID = ?")) {
                ps.setInt(1, enquiryId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Enquiries WHERE EnquiryID = ?")) {
                ps.setInt(1, enquiryId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Enquiry extractEnquiryFromRS(ResultSet rs) throws Exception {
        Enquiry e = new Enquiry();
        e.setEnquiryId(rs.getInt("EnquiryID"));
        e.setEnquiryNumber(rs.getString("EnquiryNumber"));
        e.setCustomerId(rs.getInt("CustomerID"));
        e.setCustomerName(rs.getString("CustomerName"));
        e.setSubject(rs.getString("Subject"));
        e.setMessage(rs.getString("Message"));
        e.setResponse(rs.getString("Response"));
        e.setRespondedBy(rs.getInt("RespondedBy"));
        e.setRespondedByName(rs.getString("RespondedByName"));
        e.setStatus(rs.getString("Status"));
        e.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return e;
    }
}