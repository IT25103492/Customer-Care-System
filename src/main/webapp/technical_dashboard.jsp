<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Technical Staff".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> techTickets = ticketDAO.getTicketsByAssignedUser(user.getUserId());

    int openCount = 0;
    int inProgressCount = 0;
    int resolvedCount = 0;

    if (techTickets != null) {
        for (Ticket t : techTickets) {
            String s = t.getStatus();
            if ("Open".equalsIgnoreCase(s)) openCount++;
            else if ("In Progress".equalsIgnoreCase(s)) inProgressCount++;
            else if ("Resolved".equalsIgnoreCase(s) || "Closed".equalsIgnoreCase(s)) resolvedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Technical Staff Dashboard - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(16,185,129,0.2); color:#6ee7b7;">Technical</span>
                </div>
                <ul class="nav-links">
                    <li><a href="technical_dashboard.jsp" class="active"><i class="ri-dashboard-line"></i> Tech Dashboard</a></li>
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #10b981, #059669);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role">Technical Staff</div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Banner -->
            <div style="background: linear-gradient(135deg, #064e3b 0%, #059669 60%, #10b981 100%); border-radius: 18px; padding: 28px 32px; margin-bottom: 26px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-tools-fill"></i></div>
                <div style="position:relative;">
                    <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                        <i class="ri-tools-line"></i> Technical Staff
                    </div>
                    <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Technical Support Hub</h1>
                    <p style="color:rgba(255,255,255,0.65); font-size:0.87rem; margin-top:6px;">View &amp; update your assigned technical tickets and task progress.</p>
                </div>
            </div>

            <!-- Tech Metrics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-tools-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= techTickets != null ? techTickets.size() : 0 %></div>
                        <div class="label">Assigned Technical Tasks</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-time-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= inProgressCount %></div>
                        <div class="label">Under Investigation</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= resolvedCount %></div>
                        <div class="label">Completed Tasks</div>
                    </div>
                </div>
            </div>

            <!-- Technical Issues Table -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="ri-cpu-line"></i> Assigned Technical Issues & Tasks</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Customer</th>
                                <th>Issue Subject</th>
                                <th>Description</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Update Task Progress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (techTickets != null && !techTickets.isEmpty()) {
                                for (Ticket t : techTickets) {
                                    String status = t.getStatus() != null ? t.getStatus() : "Open";
                                    String badgeClass = "badge-open";
                                    if ("In Progress".equalsIgnoreCase(status)) badgeClass = "badge-in-progress";
                                    else if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                                    else if ("Closed".equalsIgnoreCase(status)) badgeClass = "badge-closed";
                            %>
                                <tr>
                                    <td><strong><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></strong></td>
                                    <td><%= t.getCustomerName() != null ? t.getCustomerName() : "Customer #" + t.getUserId() %></td>
                                    <td><strong><%= t.getSubject() %></strong></td>
                                    <td><%= t.getDescription() %></td>
                                    <td>
                                        <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                            <%= t.getPriority() %>
                                        </span>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:8px; align-items:center;">
                                            <form action="TicketServlet" method="post" style="display:inline-flex;">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <select name="status" onchange="this.form.submit()" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px;">
                                                    <option value="Open" <%= "Open".equalsIgnoreCase(status) ? "selected" : "" %>>Open</option>
                                                    <option value="In Progress" <%= "In Progress".equalsIgnoreCase(status) ? "selected" : "" %>>Investigating / In Progress</option>
                                                    <option value="Resolved" <%= "Resolved".equalsIgnoreCase(status) ? "selected" : "" %>>Mark Resolved</option>
                                                </select>
                                            </form>
                                            <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-primary btn-sm">
                                                <i class="ri-chat-3-line"></i> Technical Chat
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 40px; color: #94a3b8;">No technical tickets assigned to you currently.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>
</body>
</html>
