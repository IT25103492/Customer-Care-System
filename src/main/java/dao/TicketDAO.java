package dao;

import model.Ticket;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class TicketDAO {

    public boolean createTicket(Ticket ticket) {
        boolean isSuccess = false;
        String query = "INSERT INTO Tickets (TicketNumber, CustomerID, Subject, Category, Priority, Description, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            String ticketNum = "TCK-2026-" + (1000 + new Random().nextInt(9000));
            ticket.setTicketNumber(ticketNum);

            ps.setString(1, ticketNum);
            ps.setInt(2, ticket.getUserId());
            ps.setString(3, ticket.getSubject());
            ps.setString(4, ticket.getCategory() != null ? ticket.getCategory() : "General Support");
            ps.setString(5, ticket.getPriority() != null ? ticket.getPriority() : "Medium");
            ps.setString(6, ticket.getDescription());
            ps.setString(7, ticket.getStatus() != null ? ticket.getStatus() : "Open");

            isSuccess = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Ticket> getTicketsByUserId(int userId) {
        List<Ticket> list = new ArrayList<>();
        String query = "SELECT t.*, u.FullName AS CustomerName, a.FullName AS AssignedToName " +
                       "FROM Tickets t " +
                       "LEFT JOIN Users u ON t.CustomerID = u.UserID " +
                       "LEFT JOIN Users a ON t.AssignedTo = a.UserID " +
                       "WHERE t.CustomerID = ? ORDER BY t.TicketID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractTicketFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Ticket> getAllTickets() {
        List<Ticket> list = new ArrayList<>();
        String query = "SELECT t.*, u.FullName AS CustomerName, a.FullName AS AssignedToName " +
                       "FROM Tickets t " +
                       "LEFT JOIN Users u ON t.CustomerID = u.UserID " +
                       "LEFT JOIN Users a ON t.AssignedTo = a.UserID " +
                       "ORDER BY t.TicketID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractTicketFromRS(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Ticket> getTicketsByAssignedUser(int staffId) {
        List<Ticket> list = new ArrayList<>();
        String query = "SELECT t.*, u.FullName AS CustomerName, a.FullName AS AssignedToName " +
                       "FROM Tickets t " +
                       "LEFT JOIN Users u ON t.CustomerID = u.UserID " +
                       "LEFT JOIN Users a ON t.AssignedTo = a.UserID " +
                       "WHERE t.AssignedTo = ? ORDER BY t.TicketID DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, staffId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractTicketFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Ticket getTicketById(int ticketId) {
        Ticket t = null;
        String query = "SELECT t.*, u.FullName AS CustomerName, a.FullName AS AssignedToName " +
                       "FROM Tickets t " +
                       "LEFT JOIN Users u ON t.CustomerID = u.UserID " +
                       "LEFT JOIN Users a ON t.AssignedTo = a.UserID " +
                       "WHERE t.TicketID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    t = extractTicketFromRS(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return t;
    }

    public boolean updateTicketStatus(int ticketId, String status) {
        String query = "UPDATE Tickets SET Status = ?, UpdatedAt = GETDATE() WHERE TicketID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, status);
            ps.setInt(2, ticketId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean assignTicket(int ticketId, int staffId) {
        String query = "UPDATE Tickets SET AssignedTo = ?, Status = CASE WHEN Status = 'Open' THEN 'In Progress' ELSE Status END, UpdatedAt = GETDATE() WHERE TicketID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, staffId);
            ps.setInt(2, ticketId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteTicket(int ticketId) {
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Delete dependent records first to avoid foreign key violations
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Messages WHERE TicketID = ?")) {
                ps.setInt(1, ticketId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Feedbacks WHERE TicketID = ?")) {
                ps.setInt(1, ticketId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Escalations WHERE TicketID = ?")) {
                ps.setInt(1, ticketId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM Tickets WHERE TicketID = ?")) {
                ps.setInt(1, ticketId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Ticket extractTicketFromRS(ResultSet rs) throws Exception {
        Ticket t = new Ticket();
        t.setTicketId(rs.getInt("TicketID"));
        t.setTicketNumber(rs.getString("TicketNumber"));
        t.setUserId(rs.getInt("CustomerID"));
        t.setCustomerName(rs.getString("CustomerName"));
        t.setAssignedTo(rs.getInt("AssignedTo"));
        t.setAssignedToName(rs.getString("AssignedToName"));
        t.setSubject(rs.getString("Subject"));
        t.setCategory(rs.getString("Category"));
        t.setPriority(rs.getString("Priority"));
        t.setDescription(rs.getString("Description"));
        t.setStatus(rs.getString("Status"));
        t.setCreatedAt(rs.getTimestamp("CreatedAt"));
        t.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
        return t;
    }
}