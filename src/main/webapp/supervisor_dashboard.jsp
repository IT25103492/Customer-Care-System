<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Escalation" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.EscalationDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Team Supervisor".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    EscalationDAO escalationDAO = new EscalationDAO();
    List<Escalation> escalationList = escalationDAO.getAllEscalations();

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> allTickets = ticketDAO.getAllTickets();

    UserDAO userDAO = new UserDAO();
    List<User> supportOfficers = userDAO.getUsersByRole("Customer Support Officer");
    List<User> techStaff = userDAO.getUsersByRole("Technical Staff");

    int activeEscalations = 0;
    if (escalationList != null) {
        for (Escalation e : escalationList) {
            if ("Escalated".equalsIgnoreCase(e.getStatus()) || "Under Review".equalsIgnoreCase(e.getStatus())) {
                activeEscalations++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Team Supervisor Dashboard - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(168,85,247,0.2); color:#c084fc;">Supervisor</span>
                </div>
                <ul class="nav-links">
                    <li><a href="supervisor_dashboard.jsp" class="active"><i class="ri-dashboard-line"></i> Supervisor Dashboard</a></li>
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="#escalationsSection"><i class="ri-alarm-warning-line"></i> Escalated Tickets</a></li>
                    <li><a href="#workloadSection"><i class="ri-user-shared-line"></i> Workload & Reassign</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #a855f7, #ec4899);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role">Team Supervisor</div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Banner -->
            <div style="background: linear-gradient(135deg, #3b0764 0%, #7c3aed 60%, #a855f7 100%); border-radius: 18px; padding: 28px 32px; margin-bottom: 26px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-group-fill"></i></div>
                <div style="position:relative;">
                    <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                        <i class="ri-group-line"></i> Team Supervisor
                    </div>
                    <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Team Overview</h1>
                    <p style="color:rgba(255,255,255,0.65); font-size:0.87rem; margin-top:6px;">Monitor escalations, balance workloads &amp; manage team performance.</p>
                </div>
            </div>

            <!-- Metrics Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-rose"><i class="ri-alarm-warning-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= activeEscalations %></div>
                        <div class="label">Active Escalations</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-user-voice-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= supportOfficers != null ? supportOfficers.size() : 0 %></div>
                        <div class="label">Support Officers</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-tools-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= techStaff != null ? techStaff.size() : 0 %></div>
                        <div class="label">Technical Staff</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-ticket-2-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= allTickets != null ? allTickets.size() : 0 %></div>
                        <div class="label">Total System Tickets</div>
                    </div>
                </div>
            </div>

            <!-- Escalated Tickets Management Hub -->
            <div class="card" id="escalationsSection">
                <div class="card-header">
                    <div class="card-title" style="color:#e11d48;"><i class="ri-alarm-warning-fill"></i> Escalated Urgent Tickets Hub</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Escalation ID</th>
                                <th>Ticket #</th>
                                <th>Customer</th>
                                <th>Escalated By</th>
                                <th>Reason</th>
                                <th>Escalated Date</th>
                                <th>Status</th>
                                <th>Supervisor Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (escalationList != null && !escalationList.isEmpty()) {
                                for (Escalation e : escalationList) {
                                    String status = e.getStatus() != null ? e.getStatus() : "Escalated";
                                    String badgeClass = "Resolved".equalsIgnoreCase(status) ? "badge-resolved" : "badge-urgent";
                            %>
                                <tr>
                                    <td><strong>#ESC-<%= e.getEscalationId() %></strong></td>
                                    <td><strong><%= e.getTicketNumber() != null ? e.getTicketNumber() : "#TCK-" + e.getTicketId() %></strong></td>
                                    <td><%= e.getCustomerName() != null ? e.getCustomerName() : "Customer" %></td>
                                    <td><%= e.getEscalatorName() != null ? e.getEscalatorName() : "Officer #" + e.getEscalatedBy() %></td>
                                    <td><%= e.getReason() %></td>
                                    <td><%= e.getEscalatedAt() != null ? e.getEscalatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; flex-wrap:wrap;">
                                            <!-- Reassign Ticket / Resolve Form -->
                                            <form action="EscalationServlet" method="post" style="display:inline-flex;">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="escalationId" value="<%= e.getEscalationId() %>">
                                                <input type="hidden" name="ticketId" value="<%= e.getTicketId() %>">
                                                <select name="status" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px;">
                                                    <option value="Under Review" <%= "Under Review".equalsIgnoreCase(status) ? "selected" : "" %>>Under Review</option>
                                                    <option value="Resolved" <%= "Resolved".equalsIgnoreCase(status) ? "selected" : "" %>>Resolve</option>
                                                    <option value="Dismissed" <%= "Dismissed".equalsIgnoreCase(status) ? "selected" : "" %>>Dismiss</option>
                                                </select>

                                                <select name="reassignStaffId" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px; margin-left:4px;">
                                                    <option value="">Assign Staff...</option>
                                                    <% if (supportOfficers != null) { for (User o : supportOfficers) { %>
                                                        <option value="<%= o.getUserId() %>">Officer: <%= o.getFullName() %></option>
                                                    <% } } %>
                                                    <% if (techStaff != null) { for (User t : techStaff) { %>
                                                        <option value="<%= t.getUserId() %>">Tech: <%= t.getFullName() %></option>
                                                    <% } } %>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm" style="margin-left:4px;">Apply</button>
                                            </form>

                                            <!-- Delete Escalation -->
                                            <form action="EscalationServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Delete escalation?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="escalationId" value="<%= e.getEscalationId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Escalation"><i class="ri-delete-bin-line"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="8" style="text-align:center; padding: 30px; color: #94a3b8;">No active ticket escalations.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Team Workload & Ticket Reassignment -->
            <div class="card" id="workloadSection">
                <div class="card-header">
                    <div class="card-title"><i class="ri-user-shared-fill"></i> Team Workload & Ticket Reassignment</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Subject</th>
                                <th>Priority</th>
                                <th>Assigned Staff</th>
                                <th>Current Status</th>
                                <th>Reassign Officer / Tech</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allTickets != null && !allTickets.isEmpty()) {
                                for (Ticket t : allTickets) {
                            %>
                                <tr>
                                    <td><strong><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></strong></td>
                                    <td><%= t.getSubject() %></td>
                                    <td><span class="badge badge-medium"><%= t.getPriority() %></span></td>
                                    <td><%= t.getAssignedToName() != null ? t.getAssignedToName() : "<span style='color:#94a3b8;'>Unassigned</span>" %></td>
                                    <td><span class="badge badge-open"><%= t.getStatus() %></span></td>
                                    <td>
                                        <form action="TicketServlet" method="post" style="display:inline-flex;">
                                            <input type="hidden" name="action" value="assign">
                                            <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                            <select name="staffId" onchange="this.form.submit()" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px;">
                                                <option value="">Select Staff...</option>
                                                <% if (supportOfficers != null) { for (User o : supportOfficers) { %>
                                                    <option value="<%= o.getUserId() %>" <%= t.getAssignedTo() == o.getUserId() ? "selected" : "" %>>Officer: <%= o.getFullName() %></option>
                                                <% } } %>
                                                <% if (techStaff != null) { for (User ts : techStaff) { %>
                                                    <option value="<%= ts.getUserId() %>" <%= t.getAssignedTo() == ts.getUserId() ? "selected" : "" %>>Tech: <%= ts.getFullName() %></option>
                                                <% } } %>
                                            </select>
                                        </form>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="6" style="text-align:center; padding: 30px; color: #94a3b8;">No tickets available.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>
</body>
</html>