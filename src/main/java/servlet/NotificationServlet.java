package servlet;

import dao.NotificationDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {

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
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.trim().isEmpty()) {
            redirect = "customer_dashboard.jsp";
        }

        NotificationDAO dao = new NotificationDAO();

        if ("mark_read".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("notificationId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int notificationId = Integer.parseInt(idStr.trim());
                dao.markAsRead(notificationId);
            }
        } else if ("mark_all_read".equalsIgnoreCase(action)) {
            dao.markAllAsRead(user.getUserId());
        } else if ("delete".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("notificationId");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int notificationId = Integer.parseInt(idStr.trim());
                dao.deleteNotification(notificationId);
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
