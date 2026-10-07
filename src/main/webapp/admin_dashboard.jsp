<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Enquiry" %>
<%@ page import="model.Feedback" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.EnquiryDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"System Administrator".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    List<User> userList = userDAO.getAllUsers();

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> ticketList = ticketDAO.getAllTickets();

    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> enquiryList = enquiryDAO.getAllEnquiries();

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> feedbackList = feedbackDAO.getAllFeedbacks();

    int activeUsersCount = 0;
    if (userList != null) {
        for (User u : userList) {
            if ("Active".equalsIgnoreCase(u.getStatus())) {
                activeUsersCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Control Panel - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(239,68,68,0.2); color:#fca5a5;">Admin</span>
                </div>
                <ul class="nav-links">
                    <li><a href="admin_dashboard.jsp" class="active"><i class="ri-admin-line"></i> Admin Dashboard</a></li>
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="#usersSection"><i class="ri-user-settings-line"></i> User Accounts</a></li>
                    <li><a href="#ticketsSection"><i class="ri-ticket-line"></i> Customer Tickets</a></li>
                    <li><a href="#enquiriesSection"><i class="ri-question-line"></i> Customer Enquiries</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-3-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #ef4444, #dc2626);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role">System Administrator</div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Hero Banner -->
            <div style="background: linear-gradient(135deg, #1e1b4b 0%, #4f46e5 60%, #6d28d9 100%); border-radius: 18px; padding: 28px 32px; margin-bottom: 26px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-admin-fill"></i></div>
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px; position:relative;">
                    <div>
                        <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                            <i class="ri-shield-keyhole-fill"></i> System Administrator
                        </div>
                        <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">System Administration & Data Governance</h1>
                        <p style="color:rgba(255,255,255,0.65); font-size:0.87rem; margin-top:6px;">Monitor active users, manage user accounts & roles, inspect customer tickets and enquiries with full delete permissions.</p>
                    </div>
                    <div style="display:flex; gap:10px;">
                        <button onclick="document.getElementById('createUserModal').classList.add('show')" class="btn" style="background:rgba(255,255,255,0.2); color:#fff; border:1px solid rgba(255,255,255,0.3); backdrop-filter:blur(8px);">
                            <i class="ri-user-add-line"></i> Add New User / Staff
                        </button>
                    </div>
                </div>
            </div>

            <!-- Admin Stat Summary -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-user-follow-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= activeUsersCount %> <span style="font-size:0.8rem; font-weight:500; color:#64748b;">/ <%= userList != null ? userList.size() : 0 %></span></div>
                        <div class="label">Currently Active Users</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-ticket-2-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= ticketList != null ? ticketList.size() : 0 %></div>
                        <div class="label">Customer Tickets</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-question-answer-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= enquiryList != null ? enquiryList.size() : 0 %></div>
                        <div class="label">Customer Enquiries</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-star-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= feedbackList != null ? feedbackList.size() : 0 %></div>
                        <div class="label">Feedbacks Logged</div>
                    </div>
                </div>
            </div>

            <!-- User Accounts Management CRUD Table -->
            <div class="card" id="usersSection">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-shield-user-fill"></i> User Accounts Management (Active Users & Staff)</div>
                    <div style="display:flex; gap:8px;">
                        <input type="text" id="userSearchInput" onkeyup="filterUsers()" placeholder="Search users by name, email, role..." class="form-control" style="font-size:0.85rem; max-width:280px;">
                        <select id="userStatusFilter" onchange="filterUsers()" class="form-control" style="font-size:0.85rem; max-width:160px;">
                            <option value="">All Statuses</option>
                            <option value="Active">Active Only</option>
                            <option value="Deactivated">Deactivated</option>
                        </select>
                    </div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table" id="usersTable">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Full Name</th>
                                <th>Email Address</th>
                                <th>System Role</th>
                                <th>Contact Number</th>
                                <th>Account Status</th>
                                <th>Admin Actions (Edit / Delete)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userList != null && !userList.isEmpty()) {
                                for (User u : userList) {
                                    String status = u.getStatus() != null ? u.getStatus() : "Active";
                                    boolean isActive = "Active".equalsIgnoreCase(status);
                                    String badgeClass = isActive ? "badge-resolved" : "badge-closed";
                            %>
                                <tr>
                                    <td><strong>#USR-<%= u.getUserId() %></strong></td>
                                    <td>
                                        <div style="font-weight:700; color:#1e293b;"><%= u.getFullName() %></div>
                                    </td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="badge badge-open"><%= u.getRole() %></span></td>
                                    <td><%= u.getContactNo() != null ? u.getContactNo() : "N/A" %></td>
                                    <td>
                                        <span class="badge <%= badgeClass %>" style="display:inline-flex; align-items:center; gap:4px;">
                                            <i class="<%= isActive ? "ri-checkbox-circle-fill" : "ri-close-circle-fill" %>"></i> <%= status %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 6px; flex-wrap:wrap;">
                                            <!-- Edit Role & Status Modal Opener -->
                                            <button onclick="editUserRole(<%= u.getUserId() %>, '<%= u.getRole().replace("'", "\\'") %>', '<%= status %>')" class="btn btn-secondary btn-sm">
                                                <i class="ri-edit-line"></i> Edit Role
                                            </button>

                                            <!-- Delete User Form -->
                                            <% if (u.getUserId() != user.getUserId()) { %>
                                                <form action="UserManagementServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Permanently remove and delete user account: <%= u.getFullName() %>? All associated tickets, enquiries, and chats will be cleanly handled.');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Permanently Delete User"><i class="ri-delete-bin-line"></i> Delete</button>
                                                </form>
                                            <% } else { %>
                                                <span style="color:#94a3b8; font-size:0.75rem; font-style:italic; padding:4px;">Current Session</span>
                                            <% } %>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 30px; color: #94a3b8;">No registered users found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Customer Tickets Management Section -->
            <div class="card" id="ticketsSection">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-ticket-2-fill"></i> Customer Support Tickets (Inspection & Deletion)</div>
                    <a href="manage_tickets.jsp" class="btn btn-primary btn-sm"><i class="ri-external-link-line"></i> Open Ticket Hub</a>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Customer</th>
                                <th>Subject</th>
                                <th>Category</th>
                                <th>Priority</th>
                                <th>Assigned To</th>
                                <th>Status</th>
                                <th>Admin Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (ticketList != null && !ticketList.isEmpty()) {
                                for (Ticket t : ticketList) {
                                    String status = t.getStatus() != null ? t.getStatus() : "Open";
                                    String badgeClass = "badge-open";
                                    if ("In Progress".equalsIgnoreCase(status)) badgeClass = "badge-in-progress";
                                    else if ("Escalated".equalsIgnoreCase(status)) badgeClass = "badge-escalated";
                                    else if ("Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                                    else if ("Closed".equalsIgnoreCase(status)) badgeClass = "badge-closed";
                            %>
                                <tr>
                                    <td><strong><%= t.getTicketNumber() != null ? t.getTicketNumber() : "#TCK-" + t.getTicketId() %></strong></td>
                                    <td><%= t.getCustomerName() != null ? t.getCustomerName() : "Customer #" + t.getUserId() %></td>
                                    <td><strong><%= t.getSubject() %></strong></td>
                                    <td><%= t.getCategory() != null ? t.getCategory() : "General" %></td>
                                    <td>
                                        <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                            <%= t.getPriority() %>
                                        </span>
                                    </td>
                                    <td><%= t.getAssignedToName() != null ? t.getAssignedToName() : "<span style='color:#94a3b8;'>Unassigned</span>" %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; align-items:center;">
                                            <a href="communication.jsp?ticketId=<%= t.getTicketId() %>" class="btn btn-secondary btn-sm" title="View chat">
                                                <i class="ri-chat-3-line"></i>
                                            </a>
                                            <!-- Admin Delete Ticket Form -->
                                            <form action="TicketServlet" method="post" onsubmit="return confirm('Permanently delete ticket <%= t.getTicketNumber() %> and all its chat history?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="ticketId" value="<%= t.getTicketId() %>">
                                                <input type="hidden" name="redirect" value="admin_dashboard.jsp#ticketsSection">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Ticket"><i class="ri-delete-bin-line"></i> Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="8" style="text-align:center; padding: 30px; color: #94a3b8;">No customer tickets recorded.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Customer Enquiries Section -->
            <div class="card" id="enquiriesSection">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-question-answer-fill"></i> Customer Enquiries (Inspection & Deletion)</div>
                    <a href="manage_enquiries.jsp" class="btn btn-primary btn-sm"><i class="ri-external-link-line"></i> Open Enquiry Hub</a>
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
                                <th>Admin Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (enquiryList != null && !enquiryList.isEmpty()) {
                                for (Enquiry e : enquiryList) {
                                    String status = e.getStatus() != null ? e.getStatus() : "Pending";
                                    String badgeClass = "badge-pending";
                                    if ("Answered".equalsIgnoreCase(status) || "Resolved".equalsIgnoreCase(status)) badgeClass = "badge-resolved";
                            %>
                                <tr>
                                    <td><strong><%= e.getEnquiryNumber() != null ? e.getEnquiryNumber() : "#ENQ-" + e.getEnquiryId() %></strong></td>
                                    <td><%= e.getCustomerName() != null ? e.getCustomerName() : "User #" + e.getCustomerId() %></td>
                                    <td><strong><%= e.getSubject() %></strong></td>
                                    <td style="max-width:250px;"><%= e.getMessage() %></td>
                                    <td style="max-width:250px;"><%= e.getResponse() != null ? e.getResponse() : "<span style='color:#94a3b8; font-style:italic;'>Awaiting Response</span>" %></td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <!-- Admin Delete Enquiry Form -->
                                        <form action="EnquiryServlet" method="post" onsubmit="return confirm('Permanently delete enquiry <%= e.getEnquiryNumber() %>?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="enquiryId" value="<%= e.getEnquiryId() %>">
                                            <input type="hidden" name="redirect" value="admin_dashboard.jsp#enquiriesSection">
                                            <button type="submit" class="btn btn-danger btn-sm" title="Delete Enquiry"><i class="ri-delete-bin-line"></i> Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 30px; color: #94a3b8;">No customer enquiries recorded.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Customer Feedbacks Section -->
            <div class="card" id="cleanupFeedbackSection">
                <div class="card-header">
                    <div class="card-title"><i class="ri-star-smile-fill"></i> Customer Feedback Log & Governance</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Feedback ID</th>
                                <th>Customer</th>
                                <th>Rating</th>
                                <th>Comments</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (feedbackList != null && !feedbackList.isEmpty()) {
                                for (Feedback fb : feedbackList) {
                            %>
                                <tr>
                                    <td><strong>#FB-<%= fb.getFeedbackId() %></strong></td>
                                    <td><%= fb.getCustomerName() != null ? fb.getCustomerName() : "User #" + fb.getUserId() %></td>
                                    <td><span class="badge badge-medium"><%= fb.getRating() %> Stars</span></td>
                                    <td><%= fb.getComments() %></td>
                                    <td><%= fb.getCreatedAt() != null ? fb.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td>
                                        <form action="FeedbackServlet" method="post" onsubmit="return confirm('Remove feedback record?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="feedbackId" value="<%= fb.getFeedbackId() %>">
                                            <button type="submit" class="btn btn-danger btn-sm"><i class="ri-delete-bin-line"></i> Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="6" style="text-align:center; padding: 30px; color: #94a3b8;">No customer feedbacks recorded.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Create User / Staff Modal -->
            <div class="modal-backdrop" id="createUserModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-user-add-fill" style="color:#4f46e5;"></i> Create System User / Staff Account</h3>
                        <button onclick="document.getElementById('createUserModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="UserManagementServlet" method="post">
                        <input type="hidden" name="action" value="create_staff">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" name="fullName" class="form-control" placeholder="User / Staff Name" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="user@customercare.com" required>
                            </div>
                            <div class="form-group">
                                <label for="role">System Access Role</label>
                                <select name="role" class="form-control" required>
                                    <option value="Customer">Customer</option>
                                    <option value="Customer Support Officer" selected>Customer Support Officer</option>
                                    <option value="Team Supervisor">Team Supervisor</option>
                                    <option value="Technical Staff">Technical Staff</option>
                                    <option value="Customer Care Manager">Customer Care Manager</option>
                                    <option value="System Administrator">System Administrator</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="contactNo">Contact Number</label>
                                <input type="text" name="contactNo" class="form-control" placeholder="077 123 4567" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Initial Password</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required minlength="6">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('createUserModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-user-check-line"></i> Create Account</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Edit User Role Modal -->
            <div class="modal-backdrop" id="editUserRoleModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-edit-line" style="color:#4f46e5;"></i> Edit User Role & Status</h3>
                        <button onclick="document.getElementById('editUserRoleModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="UserManagementServlet" method="post">
                        <input type="hidden" name="action" value="update_role_status">
                        <input type="hidden" name="userId" id="editUserId">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="editRole">Access Role</label>
                                <select name="role" id="editRole" class="form-control" required>
                                    <option value="Customer">Customer</option>
                                    <option value="Customer Support Officer">Customer Support Officer</option>
                                    <option value="Team Supervisor">Team Supervisor</option>
                                    <option value="Technical Staff">Technical Staff</option>
                                    <option value="Customer Care Manager">Customer Care Manager</option>
                                    <option value="System Administrator">System Administrator</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="editStatus">Account Status</label>
                                <select name="status" id="editStatus" class="form-control" required>
                                    <option value="Active">Active</option>
                                    <option value="Deactivated">Deactivated</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('editUserRoleModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Role Changes</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function editUserRole(id, role, status) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editRole').value = role;
            document.getElementById('editStatus').value = status;
            document.getElementById('editUserRoleModal').classList.add('show');
        }

        function filterUsers() {
            var searchFilter = document.getElementById("userSearchInput").value.toUpperCase();
            var statusFilter = document.getElementById("userStatusFilter").value.toUpperCase();
            var table = document.getElementById("usersTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var text = tr[i].textContent || tr[i].innerText;
                var matchesSearch = (text.toUpperCase().indexOf(searchFilter) > -1);
                var matchesStatus = (statusFilter === "" || text.toUpperCase().indexOf(statusFilter) > -1);

                if (matchesSearch && matchesStatus) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>

