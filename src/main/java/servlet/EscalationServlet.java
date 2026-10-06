package servlet;

import dao.EscalationDAO;
import dao.TicketDAO;
import model.Escalation;
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

@WebServlet("/EscalationServlet")
public class EscalationServlet extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        EscalationDAO dao = new EscalationDAO();
        TicketDAO ticketDAO = new TicketDAO();

        String redirectUrl = getDashboardByRole(user.getRole());

        if ("update_status".equalsIgnoreCase(action)) {
            int escalationId = Integer.parseInt(request.getParameter("escalationId"));
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String status = request.getParameter("status");
            String reassignStaffStr = request.getParameter("reassignStaffId");

            Integer reassignStaffId = (reassignStaffStr != null && !reassignStaffStr.isEmpty()) ? Integer.parseInt(reassignStaffStr) : null;

            dao.updateEscalationStatus(escalationId, status, reassignStaffId);

            Ticket t = ticketDAO.getTicketById(ticketId);

            if (reassignStaffId != null && reassignStaffId > 0) {
                ticketDAO.assignTicket(ticketId, reassignStaffId);
                if (t != null) {
                    ticketSubject.publishTicketEvent(
                            "Escalated Ticket Assigned",
                            "Escalated ticket #" + t.getTicketNumber() + " was assigned to you.",
                            reassignStaffId
                    );
                }
            }
            if ("Resolved".equalsIgnoreCase(status)) {
                ticketDAO.updateTicketStatus(ticketId, "Resolved");
                if (t != null) {
                    ticketSubject.publishTicketEvent(
                            "Escalation Resolved",
                            "Your escalated ticket #" + t.getTicketNumber() + " has been marked as Resolved.",
                            t.getUserId()
                    );
                }
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            int escalationId = Integer.parseInt(request.getParameter("escalationId"));
            dao.deleteEscalation(escalationId);
        } else {
            // Default Action: Create Escalation
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            String reason = request.getParameter("reason");
            String priority = request.getParameter("priority");

            Escalation esc = new Escalation();
            esc.setTicketId(ticketId);
            esc.setEscalatedBy(user.getUserId());
            esc.setReason(reason);
            esc.setPriority(priority != null ? priority : "High");
            esc.setStatus("Escalated");

            dao.createEscalation(esc);

            Ticket t = ticketDAO.getTicketById(ticketId);
            if (t != null) {
                ticketSubject.publishTicketEvent(
                        "Ticket Escalated",
                        "Ticket #" + t.getTicketNumber() + " has been escalated for priority handling.",
                        t.getUserId()
                );
            }
        }

        response.sendRedirect(redirectUrl);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    private String getDashboardByRole(String role) {
        if ("Customer Support Officer".equalsIgnoreCase(role)) return "support_dashboard.jsp";
        if ("Team Supervisor".equalsIgnoreCase(role)) return "supervisor_dashboard.jsp";
        if ("Technical Staff".equalsIgnoreCase(role)) return "technical_dashboard.jsp";
        if ("Customer Care Manager".equalsIgnoreCase(role)) return "manager_dashboard.jsp";
        if ("System Administrator".equalsIgnoreCase(role)) return "admin_dashboard.jsp";
        return "customer_dashboard.jsp";
    }
}