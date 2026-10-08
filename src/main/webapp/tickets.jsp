<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> userTickets = ticketDAO.getTicketsByUserId(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Support Tickets - CustomerCare</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="app-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div>
                <div class="brand-title">
                    <i class="ri-customer-service-2-fill"></i>
                    <span>CustomerCare</span>
                    <span class="role-tag">Customer</span>
                </div>
                <ul class="nav-links">
                    <li><a href="customer_dashboard.jsp"><i class="ri-dashboard-line"></i> Dashboard</a></li>
                    <li><a href="tickets.jsp" class="active"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
                    <li><a href="new_enquiry.jsp"><i class="ri-question-line"></i> General Enquiries</a></li>
                    <li><a href="feedback.jsp"><i class="ri-star-smile-line"></i> My Feedback</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role"><%= user.getEmail() %></div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <%
                String successParam = request.getParameter("success");
                if ("ticket_created".equals(successParam)) {
            %>
                <div style="background: #dcfce7; border: 1px solid #86efac; color: #166534; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600;">
                    <i class="ri-checkbox-circle-fill" style="font-size: 1.3rem; color: #16a34a;"></i>
                    <span>Your Support Ticket has been created and saved successfully!</span>
                </div>
            <%  } %>

            <div class="top-bar">
                <div class="page-header">
                    <h1>Support Tickets</h1>
                    <p>Report issues, track progress, and communicate directly with technical support officers.</p>
                </div>
                <button onclick="document.getElementById('createTicketModal').classList.add('show')" class="btn btn-primary">
                    <i class="ri-add-line"></i> Create New Ticket
                </button>
            </div>

            <!-- Create Ticket Modal -->
            <div class="modal-backdrop" id="createTicketModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-ticket-2-line" style="color:#4f46e5;"></i> Submit Support Ticket</h3>
                        <button onclick="document.getElementById('createTicketModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="TicketServlet" method="post">
                        <input type="hidden" name="source" value="tickets">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="subject">Issue Subject</label>
                                <input type="text" id="subject" name="subject" class="form-control" placeholder="Brief title of the issue" required>
                            </div>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                                <div class="form-group">
                                    <label for="category">Category</label>
                                    <select id="category" name="category" class="form-control">
                                        <option value="Technical Issue">Technical Issue</option>
                                        <option value="Account & Login">Account & Login</option>
                                        <option value="Billing & Service">Billing & Service</option>
                                        <option value="General Inquiry">General Inquiry</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="priority">Priority</label>
                                    <select id="priority" name="priority" class="form-control">
                                        <option value="Low">Low Priority</option>
                                        <option value="Medium" selected>Medium Priority</option>
                                        <option value="High">High Priority</option>
                                        <option value="Urgent">Urgent</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="description">Detailed Description</label>
                                <textarea id="description" name="description" class="form-control" rows="4" placeholder="Please describe the issue in detail..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('createTicketModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Submit Ticket</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tickets Table Card -->
            <div class="table-container">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Ticket #</th>
                            <th>Subject</th>
                            <th>Category</th>
                            <th>Assigned Officer</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (userTickets != null && !userTickets.isEmpty()) {
                            for (Ticket t : userTickets) {
                                String status = t.getStatus() != null ? t.getStatus() : "Open";
                                String badgeClass = "badge-open";
                                if ("In Progress".equalsIgnoreCase(status)) badgeClass = "badge-in-progress";
                                else if ("Escalated".equalsIgnoreCase(status)) badgeClass = "badge-escalated";
                                else if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                                else if ("Closed".equalsIgnoreCase(status)) badgeClass = "badge-closed";
                        %>
                            <tr>
                                <td><strong><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></strong></td>
                                <td><%= t.getSubject() %></td>
                                <td><%= t.getCategory() != null ? t.getCategory() : "General Support" %></td>
                                <td>
                                    <%= t.getAssignedToName() != null ? t.getAssignedToName() : "<span style='color:#94a3b8;'>Unassigned</span>" %>
                                </td>
                                <td>
                                    <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                        <%= t.getPriority() %>
                                    </span>
                                </td>
                                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                <td><%= t.getCreatedAt() != null ? t.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                <td>
                                    <div style="display: flex; gap: 6px;">
                                        <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-primary btn-sm" title="Chat with support">
                                            <i class="ri-chat-3-line"></i> Chat
                                        </a>
                                        <% if ("Resolved".equalsIgnoreCase(status)) { %>
                                            <a href="feedback.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-success btn-sm" title="Provide feedback">
                                                <i class="ri-star-line"></i> Feedback
                                            </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <%  }
                           } else { %>
                            <tr>
                                <td colspan="8" style="text-align:center; padding: 40px; color: #94a3b8;">
                                    <i class="ri-ticket-2-line" style="font-size: 2.5rem; display: block; margin-bottom: 10px;"></i>
                                    No support tickets found. Click "Create New Ticket" to report an issue.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

        </main>
    </div>
</body>
</html>