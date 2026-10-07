<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Profile Settings - CustomerCare</title>
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
                    <span class="role-tag"><%= user.getRole() %></span>
                </div>
                <ul class="nav-links">
                    <% if ("Customer".equalsIgnoreCase(user.getRole())) { %>
                        <li><a href="customer_dashboard.jsp"><i class="ri-dashboard-line"></i> Dashboard</a></li>
                        <li><a href="tickets.jsp"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
                        <li><a href="new_enquiry.jsp"><i class="ri-question-line"></i> General Enquiries</a></li>
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
                        <li><a href="escalation.jsp"><i class="ri-alarm-warning-line"></i> Escalation Hub</a></li>
                        <li><a href="communication.jsp"><i class="ri-chat-3-line"></i> Communication Hub</a></li>
                    <% } %>
                    <li><a href="profile.jsp" class="active"><i class="ri-user-settings-line"></i> Profile Settings</a></li>
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
            <div class="top-bar">
                <div class="page-header">
                    <h1>Profile Settings</h1>
                    <p>Manage your account details, security credentials, and preferences.</p>
                </div>
            </div>

            <%
                String status = request.getParameter("status");
                if ("success".equals(status)) {
            %>
                <div style="background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                    <i class="ri-checkbox-circle-line"></i> Profile details updated successfully!
                </div>
            <%  } else if ("pwd_success".equals(status)) { %>
                <div style="background: #d1fae5; color: #065f46; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                    <i class="ri-checkbox-circle-line"></i> Password changed successfully!
                </div>
            <%  } else if (status != null && status.contains("error")) { %>
                <div style="background: #fee2e2; color: #991b1b; padding: 12px 16px; border-radius: 10px; font-size: 0.88rem; margin-bottom: 20px; font-weight: 600;">
                    <i class="ri-error-warning-line"></i> Operation failed. Please try again.
                </div>
            <%  } %>

            <!-- Profile Info Form -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-user-3-fill"></i> Personal Information</div>
                <form action="UpdateProfileServlet" method="post">
                    <input type="hidden" name="action" value="update_info">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" value="<%= user.getFullName() %>" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" value="<%= user.getEmail() %>" required>
                        </div>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                        <div class="form-group">
                            <label for="contactNo">Contact Number</label>
                            <input type="text" id="contactNo" name="contactNo" class="form-control" value="<%= user.getContactNo() != null ? user.getContactNo() : "" %>" required>
                        </div>

                        <div class="form-group">
                            <label>System Role</label>
                            <input type="text" class="form-control" value="<%= user.getRole() %>" disabled style="background:#f1f5f9;">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Profile Details</button>
                </form>
            </div>

            <!-- Password Reset Form -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-lock-password-fill"></i> Security & Password</div>
                <form action="UpdateProfileServlet" method="post">
                    <input type="hidden" name="action" value="change_password">
                    <div class="form-group" style="max-width: 400px;">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="Enter new password" required minlength="6">
                    </div>
                    <button type="submit" class="btn btn-secondary"><i class="ri-key-2-line"></i> Update Password</button>
                </form>
            </div>

            <!-- Account Deactivation Card -->
            <div class="card" style="border-color: #fca5a5;">
                <div class="card-title" style="color: #dc2626; margin-bottom: 14px;"><i class="ri-alert-line"></i> Danger Zone</div>
                <p style="color: #64748b; font-size: 0.88rem; margin-bottom: 16px;">
                    Deactivating your account will temporarily disable your portal access. You can request an administrator to reactivate it at any time.
                </p>
                <form action="UpdateProfileServlet" method="post" onsubmit="return confirm('Are you sure you want to deactivate your account?');">
                    <input type="hidden" name="action" value="deactivate">
                    <button type="submit" class="btn btn-danger"><i class="ri-user-unfollow-line"></i> Deactivate My Account</button>
                </form>
            </div>

        </main>
    </div>
</body>
</html>