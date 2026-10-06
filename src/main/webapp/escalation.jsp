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
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    boolean isCustomer = "Customer".equalsIgnoreCase(user.getRole());

    EscalationDAO escalationDAO = new EscalationDAO();
    List<Escalation> escalationList = escalationDAO.getAllEscalations();

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> userTickets = isCustomer ? ticketDAO.getTicketsByUserId(user.getUserId()) : ticketDAO.getAllTickets();

    UserDAO userDAO = new UserDAO();
    List<User> techStaff = userDAO.getUsersByRole("Technical Staff");
    List<User> supportOfficers = userDAO.getUsersByRole("Customer Support Officer");

    int totalEscalations = escalationList != null ? escalationList.size() : 0;
    int activeEscalations = 0;
    int underReview = 0;
    int resolvedEscalations = 0;

    if (escalationList != null) {
        for (Escalation e : escalationList) {
            String s = e.getStatus();
            if ("Escalated".equalsIgnoreCase(s)) activeEscalations++;
            else if ("Under Review".equalsIgnoreCase(s)) underReview++;
            else if ("Resolved".equalsIgnoreCase(s) || "Dismissed".equalsIgnoreCase(s)) resolvedEscalations++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Escalation Management Hub - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(225,29,72,0.2); color:#fda4af;"><%= user.getRole() %></span>
                </div>
                <ul class="nav-links">
                    <% if (isCustomer) { %>
                        <li><a href="customer_dashboard.jsp"><i class="ri-dashboard-line"></i> Dashboard</a></li>
                        <li><a href="tickets.jsp"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
                        <li><a href="new_enquiry.jsp"><i class="ri-question-line"></i> General Enquiries</a></li>
                        <li><a href="escalation.jsp" class="active"><i class="ri-alarm-warning-line"></i> Issue Escalations</a></li>
                        <li><a href="feedback.jsp"><i class="ri-star-smile-line"></i> My Feedback</a></li>
                    <% } else { %>
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
                        <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                        <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                        <li><a href="escalation.jsp" class="active"><i class="ri-alarm-warning-fill"></i> Escalation Hub</a></li>
                    <% } %>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #e11d48, #be123c);"><%= user.getFullName().substring(0, 1) %></div>
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
            <div style="background: linear-gradient(135deg, #4c0519 0%, #be123c 60%, #e11d48 100%); border-radius: 18px; padding: 26px 30px; margin-bottom: 24px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-alarm-warning-fill"></i></div>
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px; position:relative;">
                    <div>
                        <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                            <i class="ri-alarm-warning-line"></i> Escalations Control Center
                        </div>
                        <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Issue Escalations & Critical Ticket Handling</h1>
                        <p style="color:rgba(255,255,255,0.7); font-size:0.87rem; margin-top:6px;">High priority ticket resolution, supervisor review, and staff reassignment.</p>
                    </div>
                    <button onclick="document.getElementById('newEscalationModal').classList.add('show')" class="btn" style="background:rgba(255,255,255,0.2); color:#fff; border:1px solid rgba(255,255,255,0.3); backdrop-filter:blur(8px);">
                        <i class="ri-alarm-warning-line"></i> Escalate a Ticket
                    </button>
                </div>
            </div>

            <!-- Stats Metric Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-rose"><i class="ri-alarm-warning-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= totalEscalations %></div>
                        <div class="label">Total Escalations</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-time-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= activeEscalations %></div>
                        <div class="label">Urgent / Active</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-eye-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= underReview %></div>
                        <div class="label">Under Review</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= resolvedEscalations %></div>
                        <div class="label">Resolved / Dismissed</div>
                    </div>
                </div>
            </div>

            <!-- Escalations Queue Table -->
            <div class="card">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-table-line"></i> Escalated Tickets Queue</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Escalation #</th>
                                <th>Ticket Details</th>
                                <th>Customer</th>
                                <th>Escalated By</th>
                                <th>Reason</th>
                                <th>Assigned Handler</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (escalationList != null && !escalationList.isEmpty()) {
                                for (Escalation esc : escalationList) {
                                    String status = esc.getStatus() != null ? esc.getStatus() : "Escalated";
                                    String badgeClass = "badge-urgent";
                                    if ("Under Review".equalsIgnoreCase(status)) badgeClass = "badge-pending";
                                    else if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                                    else if ("Dismissed".equalsIgnoreCase(status)) badgeClass = "badge-closed";
                            %>
                                <tr>
                                    <td><strong>#ESC-<%= esc.getEscalationId() %></strong></td>
                                    <td>
                                        <div style="font-weight:700; color:#1e293b;"><%= esc.getTicketNumber() != null ? esc.getTicketNumber() : "Ticket #" + esc.getTicketId() %></div>
                                        <div style="font-size:0.75rem; color:#64748b;"><%= esc.getTicketSubject() %></div>
                                    </td>
                                    <td><%= esc.getCustomerName() %></td>
                                    <td><span style="font-weight:600; color:#4338ca;"><%= esc.getEscalatorName() %></span></td>
                                    <td style="max-width:250px;"><%= esc.getReason() %></td>
                                    <td>
                                        <%= esc.getEscalatedToName() != null ? "<span style='font-weight:600; color:#059669;'><i class='ri-user-follow-line'></i> " + esc.getEscalatedToName() + "</span>" : "<span style='color:#94a3b8; font-style:italic;'>Unassigned</span>" %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
                                            <% if (!isCustomer) { %>
                                                <!-- Review & Reassign Modal Button -->
                                                <button onclick="openReviewModal(<%= esc.getEscalationId() %>, <%= esc.getTicketId() %>, '<%= esc.getTicketNumber() %>', '<%= status %>', <%= esc.getEscalatedTo() %>)" class="btn btn-primary btn-sm">
                                                    <i class="ri-edit-line"></i> Manage
                                                </button>
                                            <% } %>

                                            <!-- Chat Shortcut -->
                                            <a href="communication.jsp?ticketId=<%= esc.getTicketId() %>" class="btn btn-secondary btn-sm" title="Communication Thread">
                                                <i class="ri-chat-3-line"></i>
                                            </a>

                                            <% if (!isCustomer) { %>
                                                <!-- Delete Escalation -->
                                                <form action="EscalationServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Remove escalation record?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="escalationId" value="<%= esc.getEscalationId() %>">
                                                    <input type="hidden" name="redirect" value="escalation.jsp">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Delete Escalation">
                                                        <i class="ri-delete-bin-line"></i>
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="8" style="text-align:center; padding: 40px; color: #94a3b8;">No escalations currently in the queue.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- New Escalation Modal -->
            <div class="modal-backdrop" id="newEscalationModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem; color:#e11d48;"><i class="ri-alarm-warning-fill"></i> Escalate Support Ticket</h3>
                        <button onclick="document.getElementById('newEscalationModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EscalationServlet" method="post">
                        <input type="hidden" name="redirect" value="escalation.jsp">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="ticketIdSelect">Select Ticket to Escalate</label>
                                <select name="ticketId" id="ticketIdSelect" class="form-control" required>
                                    <% if (userTickets != null && !userTickets.isEmpty()) {
                                        for (Ticket t : userTickets) { %>
                                            <option value="<%= t.getTicketId() %>">
                                                <%= t.getTicketNumber() %> - <%= t.getSubject() %> (<%= t.getStatus() %>)
                                            </option>
                                    <%  }
                                       } else { %>
                                        <option value="">No available tickets</option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="escalateReason">Reason for Urgent Escalation</label>
                                <textarea name="reason" id="escalateReason" class="form-control" rows="4" placeholder="Describe the unresolved blockers or why higher management attention is needed..." required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="escalatePriority">Priority Level</label>
                                <select name="priority" id="escalatePriority" class="form-control">
                                    <option value="High" selected>High</option>
                                    <option value="Urgent">Urgent</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('newEscalationModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-danger"><i class="ri-alarm-warning-fill"></i> Submit Escalation</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Review & Reassign Escalation Modal -->
            <div class="modal-backdrop" id="reviewModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-shield-flash-fill" style="color:#e11d48;"></i> Manage Escalation Status</h3>
                        <button onclick="document.getElementById('reviewModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EscalationServlet" method="post">
                        <input type="hidden" name="action" value="update_status">
                        <input type="hidden" name="escalationId" id="modalEscalationId">
                        <input type="hidden" name="ticketId" id="modalTicketId">
                        <input type="hidden" name="redirect" value="escalation.jsp">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Ticket Reference</label>
                                <input type="text" id="modalTicketNumber" class="form-control" readonly style="background:#f8fafc; font-weight:700;">
                            </div>
                            <div class="form-group">
                                <label for="modalEscStatus">Escalation Status</label>
                                <select name="status" id="modalEscStatus" class="form-control" required>
                                    <option value="Escalated">Escalated (Pending Action)</option>
                                    <option value="Under Review">Under Review</option>
                                    <option value="Resolved">Resolved</option>
                                    <option value="Dismissed">Dismissed</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="modalReassignStaff">Assign / Reassign Staff Specialist</label>
                                <select name="reassignStaffId" id="modalReassignStaff" class="form-control">
                                    <option value="">Keep Current Assignment</option>
                                    <% if (techStaff != null) {
                                        for (User tech : techStaff) { %>
                                            <option value="<%= tech.getUserId() %>">[Tech Specialist] <%= tech.getFullName() %></option>
                                    <%  }
                                       } %>
                                    <% if (supportOfficers != null) {
                                        for (User off : supportOfficers) { %>
                                            <option value="<%= off.getUserId() %>">[Senior Officer] <%= off.getFullName() %></option>
                                    <%  }
                                       } %>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('reviewModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function openReviewModal(escId, tId, tNum, status, assignedTo) {
            document.getElementById('modalEscalationId').value = escId;
            document.getElementById('modalTicketId').value = tId;
            document.getElementById('modalTicketNumber').value = tNum;
            document.getElementById('modalEscStatus').value = status;
            if (assignedTo && assignedTo > 0) {
                document.getElementById('modalReassignStaff').value = assignedTo;
            }
            document.getElementById('reviewModal').classList.add('show');
        }
    </script>
</body>
</html>