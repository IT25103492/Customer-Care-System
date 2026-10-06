package dao;

import model.Escalation;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class EscalationDAO {

    public boolean createEscalation(Escalation escalation) {
        boolean isSuccess = false;
        String query = "INSERT INTO Escalations (TicketID, EscalatedBy, EscalatedTo, Reason, Priority, Status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, escalation.getTicketId());
            stmt.setInt(2, escalation.getEscalatedBy());
            if (escalation.getEscalatedTo() > 0) {
                stmt.setInt(3, escalation.getEscalatedTo());
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            stmt.setString(4, escalation.getReason());
            stmt.setString(5, escalation.getPriority() != null ? escalation.getPriority() : "High");
            stmt.setString(6, escalation.getStatus() != null ? escalation.getStatus() : "Escalated");

            isSuccess = stmt.executeUpdate() > 0;

            if (isSuccess) {
                // Also update ticket status to 'Escalated'
                TicketDAO ticketDAO = new TicketDAO();
                ticketDAO.updateTicketStatus(escalation.getTicketId(), "Escalated");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public List<Escalation> getAllEscalations() {
        List<Escalation> list = new ArrayList<>();
        String query = "SELECT e.*, t.TicketNumber, t.Subject AS TicketSubject, " +
                       "cust.FullName AS CustomerName, esc.FullName AS EscalatorName, toUser.FullName AS EscalatedToName " +
                       "FROM Escalations e " +
                       "INNER JOIN Tickets t ON e.TicketID = t.TicketID " +
                       "INNER JOIN Users cust ON t.CustomerID = cust.UserID " +
                       "INNER JOIN Users esc ON e.EscalatedBy = esc.UserID " +
                       "LEFT JOIN Users toUser ON e.EscalatedTo = toUser.UserID " +
                       "ORDER BY e.EscalatedAt DESC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Escalation escalation = new Escalation();
                escalation.setEscalationId(rs.getInt("EscalationID"));
                escalation.setTicketId(rs.getInt("TicketID"));
                escalation.setTicketNumber(rs.getString("TicketNumber"));
                escalation.setTicketSubject(rs.getString("TicketSubject"));
                escalation.setCustomerName(rs.getString("CustomerName"));
                escalation.setEscalatedBy(rs.getInt("EscalatedBy"));
                escalation.setEscalatorName(rs.getString("EscalatorName"));
                escalation.setEscalatedTo(rs.getInt("EscalatedTo"));
                escalation.setEscalatedToName(rs.getString("EscalatedToName"));
                escalation.setReason(rs.getString("Reason"));
                escalation.setPriority(rs.getString("Priority"));
                escalation.setStatus(rs.getString("Status"));
                escalation.setEscalatedAt(rs.getTimestamp("EscalatedAt"));
                list.add(escalation);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateEscalationStatus(int escalationId, String status, Integer reassignStaffId) {
        boolean isSuccess = false;
        String query = "UPDATE Escalations SET Status = ?, EscalatedTo = ISNULL(?, EscalatedTo) WHERE EscalationID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);
            if (reassignStaffId != null && reassignStaffId > 0) {
                stmt.setInt(2, reassignStaffId);
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setInt(3, escalationId);

            isSuccess = stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }

    public boolean deleteEscalation(int escalationId) {
        boolean isSuccess = false;
        String query = "DELETE FROM Escalations WHERE EscalationID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, escalationId);
            isSuccess = stmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return isSuccess;
    }
}
