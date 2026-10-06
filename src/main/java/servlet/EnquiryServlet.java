package servlet;

import dao.EnquiryDAO;
import dao.NotificationDAO;
import model.Enquiry;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/EnquiryServlet")
public class EnquiryServlet extends HttpServlet {

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
        EnquiryDAO enquiryDAO = new EnquiryDAO();
        NotificationDAO notificationDAO = new NotificationDAO();

        String redirectUrl = getDashboardByRole(user.getRole());

        if ("respond".equalsIgnoreCase(action)) {
            int enquiryId = Integer.parseInt(request.getParameter("enquiryId"));
            String replyText = request.getParameter("response");
            String status = request.getParameter("status");

            if (status == null || status.isEmpty()) {
                status = "Resolved";
            }

            if (enquiryDAO.updateEnquiryResponse(enquiryId, replyText, status, user.getUserId())) {
                Enquiry eq = enquiryDAO.getEnquiryById(enquiryId);
                int targetCustomerId = (eq != null) ? eq.getCustomerId() : 0;
                if (targetCustomerId > 0) {
                    notificationDAO.createNotification(targetCustomerId, "Enquiry Answered",
                            "Your general enquiry #" + enquiryId + " has been answered by " + user.getFullName() + ".");
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int enquiryId = Integer.parseInt(request.getParameter("enquiryId"));
            enquiryDAO.deleteEnquiry(enquiryId);
        } else {
            // Default Action: Create Enquiry (Allowed ONLY for Customers)
            if (!"Customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(getDashboardByRole(user.getRole()));
                return;
            }

            String subject = request.getParameter("subject");
            String message = request.getParameter("message");

            Enquiry enquiry = new Enquiry();
            enquiry.setCustomerId(user.getUserId());
            enquiry.setSubject(subject);
            enquiry.setMessage(message);
            enquiry.setStatus("Pending");

            enquiryDAO.createEnquiry(enquiry);

            String source = request.getParameter("source");
            if ("enquiry_page".equalsIgnoreCase(source)) {
                redirectUrl = "new_enquiry.jsp?success=enquiry_created";
            } else {
                redirectUrl = "customer_dashboard.jsp?success=enquiry_created";
            }
        }

        String customRedirect = request.getParameter("redirect");
        if (customRedirect != null && !customRedirect.trim().isEmpty()) {
            redirectUrl = customRedirect.trim();
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    private String getDashboardByRole(String role) {
        if ("Customer".equalsIgnoreCase(role)) return "customer_dashboard.jsp";
        if ("Customer Support Officer".equalsIgnoreCase(role)) return "support_dashboard.jsp";
        if ("Team Supervisor".equalsIgnoreCase(role)) return "supervisor_dashboard.jsp";
        if ("Technical Staff".equalsIgnoreCase(role)) return "technical_dashboard.jsp";
        if ("Customer Care Manager".equalsIgnoreCase(role)) return "manager_dashboard.jsp";
        if ("System Administrator".equalsIgnoreCase(role)) return "admin_dashboard.jsp";
        return "customer_dashboard.jsp";
    }
}