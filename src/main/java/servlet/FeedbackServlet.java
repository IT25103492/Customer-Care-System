package servlet;

import dao.FeedbackDAO;
import model.Feedback;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        FeedbackDAO dao = new FeedbackDAO();

        String redirectUrl = getDashboardByRole(user.getRole());

        if ("update".equalsIgnoreCase(action)) {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");

            if ("Customer Care Manager".equalsIgnoreCase(user.getRole()) || "System Administrator".equalsIgnoreCase(user.getRole())) {
                dao.updateFeedbackByManager(feedbackId, rating, comments);
                redirectUrl = "manager_dashboard.jsp?msg=feedback_updated#feedbackFeed";
            } else {
                Feedback fb = new Feedback();
                fb.setFeedbackId(feedbackId);
                fb.setUserId(user.getUserId());
                fb.setRating(rating);
                fb.setComments(comments);
                dao.updateFeedback(fb);
                redirectUrl = "feedback.jsp?msg=feedback_updated";
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            dao.deleteFeedback(feedbackId);
            if ("Customer Care Manager".equalsIgnoreCase(user.getRole())) {
                redirectUrl = "manager_dashboard.jsp?msg=feedback_deleted#feedbackFeed";
            } else if ("System Administrator".equalsIgnoreCase(user.getRole())) {
                redirectUrl = "admin_dashboard.jsp?msg=feedback_deleted";
            } else {
                redirectUrl = "feedback.jsp?msg=feedback_deleted";
            }
        } else {
            // Default Action: Create Feedback
            int rating = Integer.parseInt(request.getParameter("rating"));
            String comments = request.getParameter("comments");
            String ticketIdStr = request.getParameter("ticketId");

            Integer ticketId = (ticketIdStr != null && !ticketIdStr.trim().isEmpty()) ? Integer.parseInt(ticketIdStr.trim()) : null;

            Feedback fb = new Feedback();
            fb.setUserId(user.getUserId());
            fb.setTicketId(ticketId);
            fb.setRating(rating);
            fb.setComments(comments);

            dao.createFeedback(fb);
            redirectUrl = "feedback.jsp";
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    private String getDashboardByRole(String role) {
        if ("Customer".equalsIgnoreCase(role)) return "feedback.jsp";
        if ("Customer Care Manager".equalsIgnoreCase(role)) return "manager_dashboard.jsp";
        if ("System Administrator".equalsIgnoreCase(role)) return "admin_dashboard.jsp";
        return "customer_dashboard.jsp";
    }
}