package servlet;

import dao.TicketDAO;
import model.Ticket;
import model.User;
import observer.AuditLogObserver;
import observer.EmailAlertObserver;
import observer.InAppNotificationObserver;
import observer.TicketSubject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/TicketServlet")
public class TicketServlet extends HttpServlet {

    private TicketSubject ticketSubject;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize Observer Pattern Subject and register Concrete Observers
        ticketSubject = new TicketSubject();
        ticketSubject.addObserver(new InAppNotificationObserver());
        ticketSubject.addObserver(new EmailAlertObserver());
        ticketSubject.addObserver(new AuditLogObserver());
    }

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
        TicketDAO ticketDAO = new TicketDAO();

        String redirectUrl = getDashboardByRole(user.getRole());

        if ("update_status".equalsIgnoreCase(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String status = request.getParameter("status");

            if (ticketDAO.updateTicketStatus(ticketId, status)) {
                Ticket t = ticketDAO.getTicketById(ticketId);
                if (t != null) {
                    // Trigger Observer notifications to notify the customer across all channels
                    ticketSubject.publishTicketEvent(
                            "Ticket Status Updated",
                            "Your ticket #" + t.getTicketNumber() + " status is now: " + status,
                            t.getUserId()
                    );
                }
            }
        } else if ("assign".equalsIgnoreCase(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            int staffId = Integer.parseInt(request.getParameter("staffId"));

            if (ticketDAO.assignTicket(ticketId, staffId)) {
                Ticket t = ticketDAO.getTicketById(ticketId);
                if (t != null) {
                    // Trigger Observer notifications to notify the assigned staff
                    ticketSubject.publishTicketEvent(
                            "New Ticket Assigned",
                            "You have been assigned ticket #" + t.getTicketNumber(),
                            staffId
                    );
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            ticketDAO.deleteTicket(ticketId);
        } else {
            // Default Action: Create Ticket (Allowed ONLY for Customers)
            if (!"Customer".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(getDashboardByRole(user.getRole()));
                return;
            }

            String subject = request.getParameter("subject");
            String category = request.getParameter("category");
            String priority = request.getParameter("priority");
            String description = request.getParameter("description");

            Ticket ticket = new Ticket();
            ticket.setUserId(user.getUserId());
            ticket.setSubject(subject);
            ticket.setCategory(category != null ? category : "General Support");
            ticket.setPriority(priority != null ? priority : "Medium");
            ticket.setDescription(description);
            ticket.setStatus("Open");

            ticketDAO.createTicket(ticket);

            String source = request.getParameter("source");
            if ("tickets".equalsIgnoreCase(source)) {
                redirectUrl = "tickets.jsp?success=ticket_created";
            } else {
                redirectUrl = "customer_dashboard.jsp?success=ticket_created";
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