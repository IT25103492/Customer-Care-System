<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Feedback" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer Care Manager".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> allFeedbacks = feedbackDAO.getAllFeedbacks();
    double avgRating = feedbackDAO.getAverageRating();

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> allTickets = ticketDAO.getAllTickets();

    UserDAO userDAO = new UserDAO();
    List<User> allStaff = userDAO.getAllUsers();

    int totalTickets = allTickets != null ? allTickets.size() : 0;
    int resolvedTickets = 0;
    if (allTickets != null) {
        for (Ticket t : allTickets) {
            if ("Resolved".equalsIgnoreCase(t.getStatus()) || "Closed".equalsIgnoreCase(t.getStatus())) {
                resolvedTickets++;
            }
        }
    }

    double resolutionRate = totalTickets > 0 ? (double) resolvedTickets / totalTickets * 100 : 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - CustomerCare</title>
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
                    <span class="role-tag" style="background:rgba(245,158,11,0.2); color:#fcd34d;">Manager</span>
                </div>
                <ul class="nav-links">
                    <li><a href="manager_dashboard.jsp" class="active"><i class="ri-line-chart-line"></i> Analytics & CSAT</a></li>
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp"><i class="ri-question-answer-line"></i> Enquiry Management</a></li>
                    <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                    <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <li><a href="#feedbackFeed"><i class="ri-star-smile-line"></i> Customer Feedback Feed</a></li>
                    <li><a href="#staffOverview"><i class="ri-team-line"></i> Staff Performance</a></li>
                    <li><a href="profile.jsp"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
                </ul>
            </div>
            <div class="sidebar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #f59e0b, #d97706);"><%= user.getFullName().substring(0, 1) %></div>
                <div class="user-info">
                    <div class="name"><%= user.getFullName() %></div>
                    <div class="role">Customer Care Manager</div>
                </div>
                <a href="LogoutServlet" style="margin-left: auto; color: #ef4444; font-size: 1.2rem;" title="Logout"><i class="ri-logout-box-r-line"></i></a>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="top-bar">
                <div class="page-header">
                    <h1>Service Quality & Performance Analytics</h1>
                    <p>Track customer satisfaction levels, resolution efficiency, and staff workload distribution.</p>
                </div>
            </div>

            <%
                String msg = request.getParameter("msg");
                if ("feedback_updated".equals(msg)) {
            %>
                <div style="background: #d1fae5; color: #065f46; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 10px; border: 1px solid #a7f3d0;">
                    <i class="ri-checkbox-circle-fill" style="font-size: 1.2rem;"></i> Feedback entry updated successfully!
                </div>
            <%  } else if ("feedback_deleted".equals(msg)) { %>
                <div style="background: #fee2e2; color: #991b1b; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 10px; border: 1px solid #fecaca;">
                    <i class="ri-delete-bin-fill" style="font-size: 1.2rem;"></i> Feedback entry deleted successfully!
                </div>
            <%  } %>

            <!-- Manager Performance Widgets -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-star-fill"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= String.format("%.1f", avgRating) %> / 5.0</div>
                        <div class="label">Average CSAT Rating</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-line-chart-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= String.format("%.0f", resolutionRate) %>%</div>
                        <div class="label">Resolution Success Rate</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-chat-smile-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= allFeedbacks != null ? allFeedbacks.size() : 0 %></div>
                        <div class="label">Total Feedback Submissions</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-ticket-2-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= totalTickets %></div>
                        <div class="label">Total Processed Tickets</div>
                    </div>
                </div>
            </div>

            <!-- Customer Satisfaction Feed -->
            <div class="card" id="feedbackFeed">
                <div class="card-header">
                    <div class="card-title"><i class="ri-star-smile-fill"></i> Customer Feedback Feed & Satisfaction Logs</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Feedback ID</th>
                                <th>Customer Name</th>
                                <th>Rating</th>
                                <th>Written Feedback</th>
                                <th>Ticket Ref</th>
                                <th>Submission Date</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allFeedbacks != null && !allFeedbacks.isEmpty()) {
                                for (Feedback fb : allFeedbacks) {
                                    String custName = fb.getCustomerName() != null ? fb.getCustomerName() : "Customer #" + fb.getUserId();
                                    String cleanComment = fb.getComments() != null ? fb.getComments().replace("'", "\\'").replace("\r", "").replace("\n", " ") : "";
                            %>
                                <tr>
                                    <td><strong>#FB-<%= fb.getFeedbackId() %></strong></td>
                                    <td><strong><%= custName %></strong></td>
                                    <td>
                                        <div style="color: #f59e0b; font-size: 1.1rem; display: flex; gap: 2px;">
                                            <% for (int r = 1; r <= 5; r++) { %>
                                                <i class="ri-star-<%= r <= fb.getRating() ? "fill" : "line" %>"></i>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td><%= fb.getComments() != null ? fb.getComments() : "" %></td>
                                    <td><%= fb.getTicketSubject() != null ? fb.getTicketSubject() : "<span style='color:#94a3b8;'>General Service</span>" %></td>
                                    <td><%= fb.getCreatedAt() != null ? fb.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td style="text-align: center;">
                                        <div style="display: inline-flex; gap: 6px;">
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="openEditFeedbackModal(<%= fb.getFeedbackId() %>, '<%= custName.replace("'", "\\'") %>', <%= fb.getRating() %>, '<%= cleanComment %>')" title="Edit Feedback">
                                                <i class="ri-edit-line"></i> Edit
                                            </button>
                                            <button type="button" class="btn btn-danger btn-sm" onclick="confirmDeleteFeedback(<%= fb.getFeedbackId() %>)" title="Delete Feedback">
                                                <i class="ri-delete-bin-line"></i> Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 30px; color: #94a3b8;">No customer feedback entries logged.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Support Staff Workload & Roster Overview -->
            <div class="card" id="staffOverview">
                <div class="card-header">
                    <div class="card-title"><i class="ri-team-fill"></i> Support & Technical Staff Overview</div>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Contact Number</th>
                                <th>Account Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allStaff != null && !allStaff.isEmpty()) {
                                for (User u : allStaff) {
                                    if ("Customer".equalsIgnoreCase(u.getRole())) continue;
                            %>
                                <tr>
                                    <td><strong>#USR-<%= u.getUserId() %></strong></td>
                                    <td><strong><%= u.getFullName() %></strong></td>
                                    <td><%= u.getEmail() %></td>
                                    <td><span class="badge badge-open"><%= u.getRole() %></span></td>
                                    <td><%= u.getContactNo() != null ? u.getContactNo() : "N/A" %></td>
                                    <td><span class="badge badge-resolved"><%= u.getStatus() %></span></td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="6" style="text-align:center; padding: 30px; color: #94a3b8;">No staff members logged.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- Manager Edit Feedback Modal -->
    <div class="modal-backdrop" id="managerEditFeedbackModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3 style="font-weight: 800; font-size: 1.1rem; display: flex; align-items: center; gap: 8px;">
                    <i class="ri-edit-line" style="color: #f59e0b;"></i> Edit Customer Feedback
                </h3>
                <button type="button" onclick="closeEditModal()" style="border:none; background:none; font-size:1.3rem; cursor:pointer; color:#64748b;"><i class="ri-close-line"></i></button>
            </div>
            <form action="FeedbackServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="feedbackId" id="mgrFeedbackId">
                <div class="modal-body" style="padding: 20px 24px;">
                    <div style="background: #f8fafc; padding: 12px; border-radius: 10px; margin-bottom: 16px; border: 1px solid #e2e8f0;">
                        <span style="font-size: 0.8rem; color: #64748b; font-weight: 600; display: block;">Customer</span>
                        <strong id="mgrCustomerName" style="color: #0f172a; font-size: 0.95rem;">-</strong>
                    </div>

                    <div class="form-group">
                        <label for="mgrEditRating">Rating (1 to 5 Stars)</label>
                        <select id="mgrEditRating" name="rating" class="form-control" required>
                            <option value="5">⭐⭐⭐⭐⭐ (5 - Excellent)</option>
                            <option value="4">⭐⭐⭐⭐ (4 - Good)</option>
                            <option value="3">⭐⭐⭐ (3 - Average)</option>
                            <option value="2">⭐⭐ (2 - Poor)</option>
                            <option value="1">⭐ (1 - Very Poor)</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="mgrEditComments">Customer Comments / Written Feedback</label>
                        <textarea id="mgrEditComments" name="comments" class="form-control" rows="4" placeholder="Enter feedback comments..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer" style="padding: 16px 24px; border-top: 1px solid #e4e8f0; display: flex; justify-content: flex-end; gap: 10px;">
                    <button type="button" onclick="closeEditModal()" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="background:#f59e0b; border-color:#f59e0b;"><i class="ri-save-line"></i> Save Changes</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Hidden Form for Feedback Deletion -->
    <form id="deleteFeedbackForm" action="FeedbackServlet" method="post" style="display: none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="feedbackId" id="deleteFeedbackId">
    </form>

    <script>
        function openEditFeedbackModal(id, customerName, rating, comments) {
            document.getElementById('mgrFeedbackId').value = id;
            document.getElementById('mgrCustomerName').innerText = customerName;
            document.getElementById('mgrEditRating').value = rating;
            document.getElementById('mgrEditComments').value = comments;
            document.getElementById('managerEditFeedbackModal').classList.add('show');
        }

        function closeEditModal() {
            document.getElementById('managerEditFeedbackModal').classList.remove('show');
        }

        function confirmDeleteFeedback(id) {
            if (confirm('Are you sure you want to delete Feedback #FB-' + id + '? This action cannot be undone.')) {
                document.getElementById('deleteFeedbackId').value = id;
                document.getElementById('deleteFeedbackForm').submit();
            }
        }

        // Close modal on outside click
        window.addEventListener('click', function(e) {
            const modal = document.getElementById('managerEditFeedbackModal');
            if (e.target === modal) {
                closeEditModal();
            }
        });
    </script>
</body>
</html>
