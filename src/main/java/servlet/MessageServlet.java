package servlet;

import dao.MessageDAO;
import dao.NotificationDAO;
import dao.TicketDAO;
import model.Message;
import model.Ticket;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/MessageServlet")
public class MessageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        String ticketIdStr = request.getParameter("ticketId");
        String enquiryIdStr = request.getParameter("enquiryId");
        String messageIdStr = request.getParameter("messageId");
        String messageText = request.getParameter("messageText");
        String receiverIdStr = request.getParameter("receiverId");

        Integer ticketId = (ticketIdStr != null && !ticketIdStr.trim().isEmpty()) ? Integer.parseInt(ticketIdStr.trim()) : null;
        Integer enquiryId = (enquiryIdStr != null && !enquiryIdStr.trim().isEmpty()) ? Integer.parseInt(enquiryIdStr.trim()) : null;
        Integer messageId = (messageIdStr != null && !messageIdStr.trim().isEmpty()) ? Integer.parseInt(messageIdStr.trim()) : null;
        int receiverId = (receiverIdStr != null && !receiverIdStr.trim().isEmpty()) ? Integer.parseInt(receiverIdStr.trim()) : 0;

        MessageDAO dao = new MessageDAO();
        NotificationDAO notificationDAO = new NotificationDAO();
        TicketDAO ticketDAO = new TicketDAO();

        String chatUserIdStr = request.getParameter("chatUserId");
        if (chatUserIdStr == null || chatUserIdStr.trim().isEmpty()) {
            chatUserIdStr = request.getParameter("userId");
        }
        Integer chatUserId = (chatUserIdStr != null && !chatUserIdStr.trim().isEmpty()) ? Integer.parseInt(chatUserIdStr.trim()) : null;

        if ("mark_read".equalsIgnoreCase(action)) {
            if (ticketId != null && ticketId > 0) {
                dao.markMessagesAsRead(ticketId, user.getUserId());
                Ticket t = ticketDAO.getTicketById(ticketId);
                if (t != null && t.getUserId() != user.getUserId()) {
                    // Send notification to customer that support has read the message
                    notificationDAO.createNotification(
                            t.getUserId(),
                            "Message Read",
                            "Your message on Ticket " + t.getTicketNumber() + " has been marked as read by " + user.getFullName() + " (" + user.getRole() + ")."
                    );
                }
            } else if (chatUserId != null && chatUserId > 0) {
                dao.markDirectMessagesAsRead(chatUserId, user.getUserId());
                notificationDAO.createNotification(
                        chatUserId,
                        "Message Read",
                        "Your message has been marked as read by " + user.getFullName() + "."
                );
            } else if (messageId != null && messageId > 0) {
                dao.markSingleMessageAsRead(messageId);
                Message msg = dao.getMessageById(messageId);
                if (msg != null && msg.getSenderId() != user.getUserId()) {
                    notificationDAO.createNotification(
                            msg.getSenderId(),
                            "Message Read",
                            "Your message has been marked as read by " + user.getFullName() + "."
                    );
                }
            }
        } else if ("edit".equalsIgnoreCase(action)) {
            if (messageId != null && messageId > 0 && messageText != null && !messageText.trim().isEmpty()) {
                dao.editMessage(messageId, messageText.trim());
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            if (messageId != null && messageId > 0) {
                dao.deleteMessage(messageId);
            }
        } else if ("delete_chat".equalsIgnoreCase(action)) {
            // Customers cannot clear/delete chat history
            if (!"Customer".equalsIgnoreCase(user.getRole())) {
                if (ticketId != null && ticketId > 0) {
                    dao.deleteChatByTicketId(ticketId);
                } else if (enquiryId != null && enquiryId > 0) {
                    dao.deleteChatByEnquiryId(enquiryId);
                } else if (chatUserId != null && chatUserId > 0) {
                    dao.deleteDirectChat(user.getUserId(), chatUserId);
                }
            }
        } else {
            // Default Action: Send message
            if (messageText != null && !messageText.trim().isEmpty()) {
                Message msg = new Message();
                msg.setTicketId(ticketId);
                msg.setEnquiryId(enquiryId);
                msg.setSenderId(user.getUserId());
                msg.setReceiverId(receiverId);
                msg.setMessageText(messageText.trim());

                dao.sendMessage(msg);

                // Notify receiver if specified
                if (receiverId > 0 && receiverId != user.getUserId()) {
                    notificationDAO.createNotification(
                            receiverId,
                            "New Support Message",
                            "New message from " + user.getFullName() + ": " + (messageText.length() > 60 ? messageText.substring(0, 57) + "..." : messageText)
                    );
                }
            }
        }

        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.trim().isEmpty()) {
            redirect = "communication.jsp";
            if (ticketId != null && ticketId > 0) {
                redirect += "?ticketId=" + ticketId;
            } else if (enquiryId != null && enquiryId > 0) {
                redirect += "?enquiryId=" + enquiryId;
            } else if (receiverId > 0) {
                redirect += "?userId=" + receiverId;
            } else if (chatUserId != null && chatUserId > 0) {
                redirect += "?userId=" + chatUserId;
            }
        }
        response.sendRedirect(redirect);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}