<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Enquiry" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.EnquiryDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer Support Officer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> allTickets = ticketDAO.getAllTickets();

    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> allEnquiries = enquiryDAO.getAllEnquiries();

    UserDAO userDAO = new UserDAO();
    List<User> techStaffList = userDAO.getUsersByRole("Technical Staff");

    int openCount = 0;
    int inProgressCount = 0;
    int resolvedCount = 0;

    if (allTickets != null) {
        for (Ticket t : allTickets) {
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
    <title>Support Officer Dashboard - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(59,130,246,0.2); color:#93c5fd;">Officer</span>
                </div>
                <ul class="nav-links">
                    <li><a href="support_dashboard.jsp" class="active"><i class="ri-dashboard-line"></i> Officer Dashboard</a></li>
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="#ticketsSection"><i class="ri-ticket-line"></i> Ticket Queue</a></li>
                    <li><a href="#enquiriesSection"><i class="ri-question-line"></i> General Enquiries</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #3b82f6, #06b6d4);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role">Support Officer</div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Banner -->
            <div style="background: linear-gradient(135deg, #1e3a5f 0%, #1d4ed8 60%, #2563eb 100%); border-radius: 18px; padding: 28px 32px; margin-bottom: 26px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-headphone-fill"></i></div>
                <div style="position:relative;">
                    <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                        <i class="ri-headphone-line"></i> Customer Support Officer
                    </div>
                    <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Support Officer Hub</h1>
                    <p style="color:rgba(255,255,255,0.65); font-size:0.87rem; margin-top:6px;">Manage customer tickets, respond to enquiries &amp; escalate urgent issues.</p>
                </div>
            </div>

            <!-- Officer Quick Metrics -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-inbox-archive-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= allTickets != null ? allTickets.size() : 0 %></div>
                        <div class="label">Total System Tickets</div>
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
                    <div class="stat-icon icon-emerald"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= resolvedCount %></div>
                        <div class="label">Resolved / Closed</div>
                    </div>
                </div>
            </div>

            <!-- Customer Support Tickets Queue -->
            <div class="card" id="ticketsSection">
                <div class="card-header">
                    <div class="card-title"><i class="ri-ticket-2-fill"></i> Support Tickets Management Queue</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Customer</th>
                                <th>Subject</th>
                                <th>Priority</th>
                                <th>Assigned To</th>
                                <th>Status</th>
                                <th>Actions & CRUD Operations</th>
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
                                    <td><strong><%= t.getCustomerName() != null ? t.getCustomerName() : "Customer #" + t.getUserId() %></strong></td>
                                    <td><%= t.getSubject() %></td>
                                    <td>
                                        <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                            <%= t.getPriority() %>
                                        </span>
                                    </td>
                                    <td><%= t.getAssignedToName() != null ? t.getAssignedToName() : "<span style='color:#94a3b8;'>Unassigned</span>" %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                            <!-- Update Status Form -->
                                            <form action="TicketServlet" method="post" style="display:inline-flex;">
                                                <input type="hidden" name="action" value="update_status">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <select name="status" onchange="this.form.submit()" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px;">
                                                    <option value="Open" <%= "Open".equalsIgnoreCase(status) ? "selected" : "" %>>Set Open</option>
                                                    <option value="In Progress" <%= "In Progress".equalsIgnoreCase(status) ? "selected" : "" %>>In Progress</option>
                                                    <option value="Resolved" <%= "Resolved".equalsIgnoreCase(status) ? "selected" : "" %>>Resolved</option>
                                                    <option value="Closed" <%= "Closed".equalsIgnoreCase(status) ? "selected" : "" %>>Closed</option>
                                                </select>
                                            </form>

                                            <!-- Assign Tech Staff Form -->
                                            <% if (techStaffList != null && !techStaffList.isEmpty()) { %>
                                                <form action="TicketServlet" method="post" style="display:inline-flex;">
                                                    <input type="hidden" name="action" value="assign">
                                                    <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                    <select name="staffId" onchange="this.form.submit()" class="form-control" style="padding:4px 28px 4px 8px; font-size:0.78rem; border-radius:6px; background:#eff6ff;">
                                                        <option value="">Assign Tech...</option>
                                                        <% for (User tech : techStaffList) { %>
                                                            <option value="<%= tech.getUserId() %>" <%= t.getAssignedTo() == tech.getUserId() ? "selected" : "" %>><%= tech.getFullName() %></option>
                                                        <% } %>
                                                    </select>
                                                </form>
                                            <% } %>

                                            <!-- Chat with Customer -->
                                            <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-primary btn-sm" title="Chat with Customer">
                                                <i class="ri-chat-3-line"></i> Chat
                                            </a>

                                            <!-- Escalate Button -->
                                            <button onclick="openEscalateModal(<%= t.getTicketId() %>, '<%= t.getTicketNumber() %>')" class="btn btn-warning btn-sm" title="Escalate to Supervisor">
                                                <i class="ri-alarm-warning-line"></i> Escalate
                                            </button>

                                            <!-- Delete Ticket Form -->
                                            <form action="TicketServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Permanently delete ticket <%= t.getTicketNumber() %> and its chat history?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <input type="hidden" name="redirect" value="support_dashboard.jsp#ticketsSection">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Ticket">
                                                    <i class="ri-delete-bin-line"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 30px; color: #94a3b8;">No customer tickets found in the queue.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- General Enquiries Management -->
            <div class="card" id="enquiriesSection">
                <div class="card-header">
                    <div class="card-title"><i class="ri-question-answer-fill"></i> General Customer Enquiries Queue</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Enquiry #</th>
                                <th>Customer</th>
                                <th>Subject</th>
                                <th>Customer Question</th>
                                <th>Official Response</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allEnquiries != null && !allEnquiries.isEmpty()) {
                                for (Enquiry e : allEnquiries) {
                                    String status = e.getStatus() != null ? e.getStatus() : "Pending";
                                    String badgeClass = "Resolved".equalsIgnoreCase(status) || "Answered".equalsIgnoreCase(status) ? "badge-resolved" : "badge-pending";
                            %>
                                <tr>
                                    <td><strong><%= e.getEnquiryNumber() != null ? e.getEnquiryNumber() : "#ENQ-" + e.getEnquiryId() %></strong></td>
                                    <td><strong><%= e.getCustomerName() != null ? e.getCustomerName() : "Customer #" + e.getCustomerId() %></strong></td>
                                    <td><%= e.getSubject() %></td>
                                    <td><%= e.getMessage() %></td>
                                    <td>
                                        <%= (e.getResponse() != null && !e.getResponse().isEmpty())
                                             ? "<span style='color:#059669; font-weight:600;'>" + e.getResponse() + "</span>"
                                            : "<span style='color:#94a3b8; font-style:italic;'>Needs response</span>" %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; align-items:center;">
                                            <button onclick="openEnquiryReplyModal(<%= e.getEnquiryId() %>, '<%= e.getSubject().replace("'", "\\'") %>', '<%= e.getMessage().replace("'", "\\'") %>')" class="btn btn-primary btn-sm">
                                                <i class="ri-reply-fill"></i> Reply
                                            </button>

                                            <!-- Delete Enquiry Form -->
                                            <form action="EnquiryServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Permanently delete enquiry <%= e.getEnquiryNumber() %>?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="enquiryId" value="<%= e.getEnquiryId() %>">
                                                <input type="hidden" name="redirect" value="support_dashboard.jsp#enquiriesSection">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Enquiry">
                                                    <i class="ri-delete-bin-line"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 30px; color: #94a3b8;">No pending enquiries found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Escalation Modal -->
            <div class="modal-backdrop" id="escalateModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem; color:#dc2626;"><i class="ri-alarm-warning-fill"></i> Escalate Ticket to Team Supervisor</h3>
                        <button onclick="document.getElementById('escalateModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EscalationServlet" method="post">
                        <input type="hidden" name="ticketId" id="escalateTicketId">
                        <div class="modal-body">
                            <p style="margin-bottom:16px; color:#475569; font-weight:600;">Escalating Ticket: <span id="escalateTicketNum" style="color:#0f172a; font-weight:800;"></span></p>
                            <div class="form-group">
                                <label for="priority">Escalation Priority</label>
                                <select name="priority" class="form-control">
                                    <option value="High" selected>High Priority</option>
                                    <option value="Urgent">Urgent - Requires Immediate Action</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="reason">Reason for Escalation</label>
                                <textarea name="reason" class="form-control" rows="4" placeholder="Explain why this ticket is being escalated to the supervisor (e.g., complex issue, delayed resolution, customer urgency)..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('escalateModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-danger"><i class="ri-send-plane-fill"></i> Confirm Escalation</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Reply Enquiry Modal -->
            <div class="modal-backdrop" id="replyEnquiryModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-reply-fill" style="color:#4f46e5;"></i> Respond to Customer Enquiry</h3>
                        <button onclick="document.getElementById('replyEnquiryModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EnquiryServlet" method="post">
                        <input type="hidden" name="action" value="respond">
                        <input type="hidden" name="enquiryId" id="replyEnquiryId">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Subject</label>
                                <input type="text" id="enquirySubject" class="form-control" disabled style="background:#f1f5f9;">
                            </div>
                            <div class="form-group">
                                <label>Customer Question</label>
                                <textarea id="enquiryQuestion" class="form-control" rows="2" disabled style="background:#f1f5f9;"></textarea>
                            </div>
                            <div class="form-group">
                                <label for="response">Official Support Response</label>
                                <textarea name="response" class="form-control" rows="4" placeholder="Type official response to customer..." required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="status">Mark Status</label>
                                <select name="status" class="form-control">
                                    <option value="Resolved" selected>Resolved</option>
                                    <option value="Answered">Answered</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('replyEnquiryModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Send Response</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function openEscalateModal(id, num) {
            document.getElementById('escalateTicketId').value = id;
            document.getElementById('escalateTicketNum').innerText = num;
            document.getElementById('escalateModal').classList.add('show');
        }

        function openEnquiryReplyModal(id, subject, question) {
            document.getElementById('replyEnquiryId').value = id;
            document.getElementById('enquirySubject').value = subject;
            document.getElementById('enquiryQuestion').value = question;
            document.getElementById('replyEnquiryModal').classList.add('show');
        }
    </script>
</body>
</html>
