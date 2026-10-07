package dao;

import model.Message;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public boolean sendMessage(Message message) {
        String query = "INSERT INTO Messages (TicketID, EnquiryID, SenderID, ReceiverID, MessageText, IsRead, IsEdited) VALUES (?, ?, ?, ?, ?, 0, 0)";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            if (message.getTicketId() != null && message.getTicketId() > 0) {
                ps.setInt(1, message.getTicketId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }

            if (message.getEnquiryId() != null && message.getEnquiryId() > 0) {
                ps.setInt(2, message.getEnquiryId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            ps.setInt(3, message.getSenderId());
            if (message.getReceiverId() > 0) {
                ps.setInt(4, message.getReceiverId());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            ps.setString(5, message.getMessageText());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Fallback for older schema without IsRead/IsEdited columns
            try (Connection conn = DBConnection.getInstance().getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                         "INSERT INTO Messages (TicketID, EnquiryID, SenderID, ReceiverID, MessageText) VALUES (?, ?, ?, ?, ?)")) {
                if (message.getTicketId() != null && message.getTicketId() > 0) {
                    ps.setInt(1, message.getTicketId());
                } else {
                    ps.setNull(1, java.sql.Types.INTEGER);
                }
                if (message.getEnquiryId() != null && message.getEnquiryId() > 0) {
                    ps.setInt(2, message.getEnquiryId());
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                ps.setInt(3, message.getSenderId());
                if (message.getReceiverId() > 0) {
                    ps.setInt(4, message.getReceiverId());
                } else {
                    ps.setNull(4, java.sql.Types.INTEGER);
                }
                ps.setString(5, message.getMessageText());
                return ps.executeUpdate() > 0;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    public List<Message> getMessagesByTicketId(int ticketId) {
        List<Message> list = new ArrayList<>();
        String query = "SELECT m.*, u.FullName AS SenderName, u.Role AS SenderRole, r.FullName AS ReceiverName " +
                       "FROM Messages m " +
                       "LEFT JOIN Users u ON m.SenderID = u.UserID " +
                       "LEFT JOIN Users r ON m.ReceiverID = r.UserID " +
                       "WHERE m.TicketID = ? ORDER BY m.SentAt ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMessageFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Message> getMessagesByEnquiryId(int enquiryId) {
        List<Message> list = new ArrayList<>();
        String query = "SELECT m.*, u.FullName AS SenderName, u.Role AS SenderRole, r.FullName AS ReceiverName " +
                       "FROM Messages m " +
                       "LEFT JOIN Users u ON m.SenderID = u.UserID " +
                       "LEFT JOIN Users r ON m.ReceiverID = r.UserID " +
                       "WHERE m.EnquiryID = ? ORDER BY m.SentAt ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, enquiryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMessageFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Message getMessageById(int messageId) {
        Message msg = null;
        String query = "SELECT m.*, u.FullName AS SenderName, u.Role AS SenderRole, r.FullName AS ReceiverName " +
                       "FROM Messages m " +
                       "LEFT JOIN Users u ON m.SenderID = u.UserID " +
                       "LEFT JOIN Users r ON m.ReceiverID = r.UserID " +
                       "WHERE m.MessageID = ?";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    msg = extractMessageFromRS(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return msg;
    }

    public boolean editMessage(int messageId, String newText) {
        String query = "UPDATE Messages SET MessageText = ?, IsEdited = 1 WHERE MessageID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, newText);
            ps.setInt(2, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Fallback if IsEdited column doesn't exist
            try (Connection conn = DBConnection.getInstance().getConnection();
                 PreparedStatement ps = conn.prepareStatement("UPDATE Messages SET MessageText = ? WHERE MessageID = ?")) {
                ps.setString(1, newText);
                ps.setInt(2, messageId);
                return ps.executeUpdate() > 0;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    public boolean deleteMessage(int messageId) {
        String query = "DELETE FROM Messages WHERE MessageID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteChatByTicketId(int ticketId) {
        String query = "DELETE FROM Messages WHERE TicketID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteChatByEnquiryId(int enquiryId) {
        String query = "DELETE FROM Messages WHERE EnquiryID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, enquiryId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markSingleMessageAsRead(int messageId) {
        String query = "UPDATE Messages SET IsRead = 1 WHERE MessageID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, messageId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean markMessagesAsRead(int ticketId, int readerUserId) {
        String query = "UPDATE Messages SET IsRead = 1 WHERE TicketID = ? AND SenderID != ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);
            ps.setInt(2, readerUserId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Message> getDirectMessages(int user1Id, int user2Id) {
        List<Message> list = new ArrayList<>();
        String query = "SELECT m.*, u.FullName AS SenderName, u.Role AS SenderRole, r.FullName AS ReceiverName " +
                       "FROM Messages m " +
                       "LEFT JOIN Users u ON m.SenderID = u.UserID " +
                       "LEFT JOIN Users r ON m.ReceiverID = r.UserID " +
                       "WHERE (m.SenderID = ? AND m.ReceiverID = ?) OR (m.SenderID = ? AND m.ReceiverID = ?) " +
                       "ORDER BY m.SentAt ASC";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, user1Id);
            ps.setInt(2, user2Id);
            ps.setInt(3, user2Id);
            ps.setInt(4, user1Id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMessageFromRS(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getDirectChatUserIds(int currentUserId) {
        List<Integer> list = new ArrayList<>();
        String query = "SELECT DISTINCT CASE WHEN SenderID = ? THEN ReceiverID ELSE SenderID END AS ChatPartnerID " +
                       "FROM Messages " +
                       "WHERE (SenderID = ? OR ReceiverID = ?) AND ReceiverID IS NOT NULL AND ReceiverID > 0 AND TicketID IS NULL";

        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, currentUserId);
            ps.setInt(2, currentUserId);
            ps.setInt(3, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int partnerId = rs.getInt("ChatPartnerID");
                    if (partnerId > 0 && partnerId != currentUserId && !list.contains(partnerId)) {
                        list.add(partnerId);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markDirectMessagesAsRead(int senderId, int currentUserId) {
        String query = "UPDATE Messages SET IsRead = 1 WHERE SenderID = ? AND ReceiverID = ?";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, senderId);
            ps.setInt(2, currentUserId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDirectChat(int user1Id, int user2Id) {
        String query = "DELETE FROM Messages WHERE (SenderID = ? AND ReceiverID = ?) OR (SenderID = ? AND ReceiverID = ?)";
        try (Connection conn = DBConnection.getInstance().getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, user1Id);
            ps.setInt(2, user2Id);
            ps.setInt(3, user2Id);
            ps.setInt(4, user1Id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Message extractMessageFromRS(ResultSet rs) throws Exception {
        Message m = new Message();
        m.setMessageId(rs.getInt("MessageID"));
        
        int tId = rs.getInt("TicketID");
        if (!rs.wasNull()) m.setTicketId(tId);

        int eId = rs.getInt("EnquiryID");
        if (!rs.wasNull()) m.setEnquiryId(eId);

        m.setSenderId(rs.getInt("SenderID"));
        m.setSenderName(rs.getString("SenderName"));
        m.setSenderRole(rs.getString("SenderRole"));
        m.setReceiverId(rs.getInt("ReceiverID"));
        m.setReceiverName(rs.getString("ReceiverName"));
        m.setMessageText(rs.getString("MessageText"));
        m.setSentAt(rs.getTimestamp("SentAt"));

        // Safely check for IsRead and IsEdited columns
        try {
            ResultSetMetaData meta = rs.getMetaData();
            int colCount = meta.getColumnCount();
            for (int i = 1; i <= colCount; i++) {
                String colName = meta.getColumnLabel(i);
                if ("IsRead".equalsIgnoreCase(colName)) {
                    m.setRead(rs.getBoolean("IsRead"));
                } else if ("IsEdited".equalsIgnoreCase(colName)) {
                    m.setEdited(rs.getBoolean("IsEdited"));
                }
            }
        } catch (Exception ignored) {}
        return m;
    }
}