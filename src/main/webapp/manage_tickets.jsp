<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || "Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> allTickets = ticketDAO.getAllTickets();

    UserDAO userDAO = new UserDAO();
    List<User> techStaffList = userDAO.getUsersByRole("Technical Staff");
    List<User> supportStaffList = userDAO.getUsersByRole("Customer Support Officer");

    int totalTickets = allTickets != null ? allTickets.size() : 0;
    int openCount = 0;
    int inProgressCount = 0;
    int escalatedCount = 0;
    int resolvedCount = 0;

    if (allTickets != null) {
        for (Ticket t : allTickets) {
            String s = t.getStatus();
            if ("Open".equalsIgnoreCase(s)) openCount++;
            else if ("In Progress".equalsIgnoreCase(s)) inProgressCount++;
            else if ("Escalated".equalsIgnoreCase(s)) escalatedCount++;
            else if ("Resolved".equalsIgnoreCase(s) || "Closed".equalsIgnoreCase(s)) resolvedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ticket Management Dashboard - CustomerCare</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="app-container">
        <!-- Universal Sidebar -->
        <aside class="sidebar">
            <div>
                <div class="brand-title">
                    <i class="ri-customer-service-2-fill"></i>
                    <span>CustomerCare</span>
                    <span class="role-tag" style="background:rgba(59,130,246,0.2); color:#93c5fd;"><%= user.getRole() %></span>
                </div>
                <ul class="nav-links">
                    <% if ("Customer Support Officer".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="support_dashboard.jsp"><i class="ri-dashboard-line"></i> Officer Dashboard</a></li>
                    <% } else if ("Team Supervisor".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="supervisor_dashboard.jsp"><i class="ri-dashboard-line"></i> Supervisor Dashboard</a></li>
                    <% } else if ("Technical Staff".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="technical_dashboard.jsp"><i class="ri-dashboard-line"></i> Tech Dashboard</a></li>
                    <% } else if ("Customer Care Manager".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="manager_dashboard.jsp"><i class="ri-dashboard-line"></i> Manager Dashboard</a></li>
                    <% } else if ("System Administrator".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="admin_dashboard.jsp"><i class="ri-dashboard-line"></i> Admin Dashboard</a></li>
                    <% } %>
                    <li><a href="manage_tickets.jsp" class="active"><i class="ri-ticket-2-fill"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #3b82f6, #06b6d4);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role"><%= user.getRole() %></div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Banner -->
            <div style="background: linear-gradient(135deg, #1e3a5f 0%, #1d4ed8 60%, #2563eb 100%); border-radius: 18px; padding: 26px 30px; margin-bottom: 24px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-ticket-2-fill"></i></div>
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px; position:relative;">
                    <div>
                        <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                            <i class="ri-ticket-2-line"></i> Ticket Management Hub
                        </div>
                        <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Customer Support Tickets Management</h1>
                        <p style="color:rgba(255,255,255,0.7); font-size:0.87rem; margin-top:6px;">Assign, update status, resolve, communicate, and manage tickets across the system.</p>
                    </div>
                </div>
            </div>

            <!-- Stats Metric Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-ticket-2-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= totalTickets %></div>
                        <div class="label">Total Tickets</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-time-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= openCount %></div>
                        <div class="label">Open Tickets</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-loader-4-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= inProgressCount %></div>
                        <div class="label">In Progress</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-rose"><i class="ri-alarm-warning-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= escalatedCount %></div>
                        <div class="label">Escalated</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= resolvedCount %></div>
                        <div class="label">Resolved / Closed</div>
                    </div>
                </div>
            </div>

            <!-- Ticket Management Table Card -->
            <div class="card">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-table-line"></i> All Support Tickets Queue & Actions</div>
                    <input type="text" id="ticketSearchInput" onkeyup="filterTickets()" placeholder="Search by Ticket #, Customer, Subject..." class="form-control" style="max-width:320px; font-size:0.85rem;">
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table" id="ticketsTable">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Customer</th>
                                <th>Subject & Category</th>
                                <th>Priority</th>
                                <th>Assigned Staff</th>
                                <th>Status</th>
                                <th>Actions (Status / Assign / Delete)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allTickets != null && !allTickets.isEmpty()) {
                                for (Ticket t : allTickets) {
                                    String status = t.getStatus() != null ? t.getStatus() : "Open";
                                    String badgeClass = "badge-open";
                                    if ("In Progress".equalsIgnoreCase(status)) badgeClass = "badge-in-progress";
                                    else if ("Escalated".equalsIgnoreCase(status)) badgeClass = "badge-escalated";
                                    else if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                                    else if ("Closed".equalsIgnoreCase(status)) badgeClass = "badge-closed";
                            %>
                                <tr>
                                    <td><strong><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></strong></td>
                                    <td>
                                        <div style="font-weight:700; color:#1e293b;"><%= t.getCustomerName() != null ? t.getCustomerName() : "Customer #" + t.getUserId() %></div>
                                        <div style="font-size:0.75rem; color:#64748b;">ID: <%= t.getUserId() %></div>
                                    </td>
                                    <td>
                                        <div style="font-weight:600; color:#0f172a;"><%= t.getSubject() %></div>
                                        <div style="font-size:0.75rem; color:#64748b;"><i class="ri-folder-line"></i> <%= t.getCategory() != null ? t.getCategory() : "General" %></div>
                                    </td>
                                    <td>
                                        <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                            <%= t.getPriority() %>
                                        </span>
                                    </td>
                                    <td>
                                        <%= t.getAssignedToName() != null ? "<span style='font-weight:600; color:#1e293b;'><i class='ri-user-line'></i> " + t.getAssignedToName() + "</span>" : "<span style='color:#94a3b8; font-style:italic;'>Unassigned</span>" %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
                                            <!-- Update Status Form -->
                                            <form action="TicketServlet" method="post" style="display:inline-flex;">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <input type="hidden" name="redirect" value="manage_tickets.jsp">
                                                <select name="status" onchange="this.form.submit()" class="form-control" style="padding:4px 26px 4px 8px; font-size:0.76rem; border-radius:6px; font-weight:600;">
                                                    <option value="Open" <%= "Open".equalsIgnoreCase(status) ? "selected" : "" %>>Open</option>
                                                    <option value="In Progress" <%= "In Progress".equalsIgnoreCase(status) ? "selected" : "" %>>In Progress</option>
                                                    <option value="Resolved" <%= "Resolved".equalsIgnoreCase(status) ? "selected" : "" %>>Resolved</option>
                                                    <option value="Closed" <%= "Closed".equalsIgnoreCase(status) ? "selected" : "" %>>Closed</option>
                                                </select>
                                            </form>

                                            <!-- Assign Staff Dropdown -->
                                            <form action="TicketServlet" method="post" style="display:inline-flex;">
                                                <input type="hidden" name="action" value="assign">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <input type="hidden" name="redirect" value="manage_tickets.jsp">
                                                <select name="staffId" onchange="this.form.submit()" class="form-control" style="padding:4px 26px 4px 8px; font-size:0.76rem; border-radius:6px; background:#f0fdf4; border-color:#86efac; font-weight:600;">
                                                    <option value="">Assign To...</option>
                                                    <% if (techStaffList != null) {
                                                        for (User tech : techStaffList) { %>
                                                            <option value="<%= tech.getUserId() %>" <%= t.getAssignedTo() == tech.getUserId() ? "selected" : "" %>>[Tech] <%= tech.getFullName() %></option>
                                                    <%  }
                                                       } %>
                                                    <% if (supportStaffList != null) {
                                                        for (User officer : supportStaffList) { %>
                                                            <option value="<%= officer.getUserId() %>" <%= t.getAssignedTo() == officer.getUserId() ? "selected" : "" %>>[Officer] <%= officer.getFullName() %></option>
                                                    <%  }
                                                       } %>
                                                </select>
                                            </form>

                                            <!-- Direct Chat Shortcut -->
                                            <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-primary btn-sm" title="Open Communication Chat">
                                                <i class="ri-chat-3-line"></i>
                                            </a>

                                            <!-- Escalate Button -->
                                            <button onclick="openEscalateModal(<%= t.getTicketId() %>, '<%= t.getTicketNumber() %>')" class="btn btn-warning btn-sm" title="Escalate Ticket">
                                                <i class="ri-alarm-warning-line"></i>
                                            </button>

                                            <!-- DELETE TICKET ACTION -->
                                            <form action="TicketServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Are you sure you want to permanently delete Ticket <%= t.getTicketNumber() %>? All related chat messages will also be removed.');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <input type="hidden" name="redirect" value="manage_tickets.jsp">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Ticket">
                                                    <i class="ri-delete-bin-line"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 40px; color: #94a3b8;">No customer tickets found in the system.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Escalate Ticket Modal -->
            <div class="modal-backdrop" id="escalateTicketModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem; color:#e11d48;"><i class="ri-alarm-warning-fill"></i> Escalate Ticket to Supervisor</h3>
                        <button onclick="document.getElementById('escalateTicketModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EscalationServlet" method="post">
                        <input type="hidden" name="ticketId" id="escalateTicketId">
                        <input type="hidden" name="redirect" value="manage_tickets.jsp">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Ticket Reference</label>
                                <input type="text" id="escalateTicketNumber" class="form-control" readonly style="background:#f8fafc; font-weight:700;">
                            </div>
                            <div class="form-group">
                                <label for="reason">Reason for Escalation</label>
                                <textarea name="reason" class="form-control" rows="3" placeholder="Explain why this requires supervisor or senior tech escalation..." required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="priority">Escalation Priority</label>
                                <select name="priority" class="form-control">
                                    <option value="High">High Priority</option>
                                    <option value="Urgent">Urgent</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('escalateTicketModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-danger"><i class="ri-alarm-warning-fill"></i> Confirm Escalation</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function openEscalateModal(id, num) {
            document.getElementById('escalateTicketId').value = id;
            document.getElementById('escalateTicketNumber').value = num;
            document.getElementById('escalateTicketModal').classList.add('show');
        }

        function filterTickets() {
            var input = document.getElementById("ticketSearchInput");
            var filter = input.value.toUpperCase();
            var table = document.getElementById("ticketsTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var text = tr[i].textContent || tr[i].innerText;
                if (text.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>