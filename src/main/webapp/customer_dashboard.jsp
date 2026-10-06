<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Ticket" %>
<%@ page import="model.Enquiry" %>
<%@ page import="model.Notification" %>
<%@ page import="dao.TicketDAO" %>
<%@ page import="dao.EnquiryDAO" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="dao.NotificationDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    TicketDAO ticketDAO = new TicketDAO();
    List<Ticket> userTickets = ticketDAO.getTicketsByUserId(user.getUserId());

    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> userEnquiries = enquiryDAO.getEnquiriesByCustomerId(user.getUserId());

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    int feedbackCount = feedbackDAO.getFeedbacksByCustomerId(user.getUserId()).size();

    NotificationDAO notificationDAO = new NotificationDAO();
    List<Notification> userNotifications = notificationDAO.getNotificationsByUserId(user.getUserId());

    int unreadNotifCount = 0;
    if (userNotifications != null) {
        for (Notification n : userNotifications) {
            if (!n.isRead()) {
                unreadNotifCount++;
            }
        }
    }

    int openTicketsCount = 0;
    if (userTickets != null) {
        for (Ticket t : userTickets) {
            if ("Open".equalsIgnoreCase(t.getStatus()) || "In Progress".equalsIgnoreCase(t.getStatus())) {
                openTicketsCount++;
            }
        }
    }

    int pendingEnqCount = 0;
    if (userEnquiries != null) {
        for (Enquiry e : userEnquiries) {
            if ("Pending".equalsIgnoreCase(e.getStatus())) {
                pendingEnqCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - CustomerCare</title>
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
                    <li><a href="customer_dashboard.jsp" class="active"><i class="ri-dashboard-line"></i> Dashboard</a></li>
                    <li><a href="tickets.jsp"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
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
                    <span>Your Support Ticket has been submitted successfully and saved to your dashboard!</span>
                </div>
            <%  } else if ("enquiry_created".equals(successParam)) { %>
                <div style="background: #dbeafe; border: 1px solid #93c5fd; color: #1e40af; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600;">
                    <i class="ri-information-fill" style="font-size: 1.3rem; color: #2563eb;"></i>
                    <span>Your General Enquiry has been submitted successfully! Our support officers will review and respond.</span>
                </div>
            <%  } %>

            <div class="top-bar">
                <div class="page-header">
                    <h1>Welcome back, <%= user.getFullName() %> 👋</h1>
                    <p>Track your support requests, enquiries, and real-time resolution updates.</p>
                </div>
                <div style="display: flex; gap: 12px;">
                    <button onclick="document.getElementById('quickTicketModal').classList.add('show')" class="btn btn-primary"><i class="ri-add-circle-line"></i> Submit Ticket</button>
                    <button onclick="document.getElementById('quickEnquiryModal').classList.add('show')" class="btn btn-secondary"><i class="ri-question-line"></i> Ask Question</button>
                </div>
            </div>

            <!-- Quick Stat Widgets -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-ticket-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= userTickets != null ? userTickets.size() : 0 %></div>
                        <div class="label">Total Support Tickets</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-time-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= openTicketsCount %></div>
                        <div class="label">Active / Open Tickets</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-question-answer-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= userEnquiries != null ? userEnquiries.size() : 0 %></div>
                        <div class="label">General Enquiries</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-star-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= feedbackCount %></div>
                        <div class="label">Feedbacks Submitted</div>
                    </div>
                </div>
            </div>

            <!-- Recent Notifications & Updates Card -->
            <div class="card" style="margin-bottom: 24px;">
                <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div class="card-title" style="margin: 0;">
                            <i class="ri-notification-3-fill" style="color: #4f46e5;"></i> Recent Notifications & Updates
                        </div>
                        <% if (unreadNotifCount > 0) { %>
                            <span class="badge" style="background: #e0e7ff; color: #4338ca; font-weight: 700; padding: 3px 8px; font-size: 0.75rem; border-radius: 20px;">
                                <%= unreadNotifCount %> Unread
                            </span>
                        <% } else { %>
                            <span class="badge" style="background: #f1f5f9; color: #64748b; font-weight: 600; padding: 3px 8px; font-size: 0.75rem; border-radius: 20px;">
                                All Caught Up
                            </span>
                        <% } %>
                    </div>
                    <% if (unreadNotifCount > 0) { %>
                        <form action="NotificationServlet" method="post" style="margin: 0;">
                            <input type="hidden" name="action" value="mark_all_read">
                            <input type="hidden" name="redirect" value="customer_dashboard.jsp">
                            <button type="submit" class="btn btn-secondary btn-sm" style="font-size: 0.8rem; padding: 4px 10px;">
                                <i class="ri-check-double-line"></i> Mark All as Read
                            </button>
                        </form>
                    <% } %>
                </div>

                <div style="padding: 16px;">
                    <% if (userNotifications != null && !userNotifications.isEmpty()) { %>
                        <div style="display: flex; flex-direction: column; gap: 10px;">
                            <%
                                int notifLimit = Math.min(6, userNotifications.size());
                                for (int i = 0; i < notifLimit; i++) {
                                    Notification notif = userNotifications.get(i);
                                    boolean isUnread = !notif.isRead();
                                    
                                    String iconClass = "ri-notification-3-line";
                                    String iconBg = "#e0e7ff";
                                    String iconColor = "#4f46e5";
                                    
                                    if (notif.getTitle() != null && notif.getTitle().toLowerCase().contains("message")) {
                                        iconClass = "ri-chat-check-line";
                                        iconBg = "#ecfdf5";
                                        iconColor = "#059669";
                                    } else if (notif.getTitle() != null && notif.getTitle().toLowerCase().contains("ticket")) {
                                        iconClass = "ri-ticket-2-line";
                                        iconBg = "#dbeafe";
                                        iconColor = "#2563eb";
                                    } else if (notif.getTitle() != null && notif.getTitle().toLowerCase().contains("enquiry")) {
                                        iconClass = "ri-question-answer-line";
                                        iconBg = "#f3e8ff";
                                        iconColor = "#9333ea";
                                    }
                            %>
                                <div style="display: flex; align-items: flex-start; justify-content: space-between; padding: 12px 14px; border-radius: 10px; border: 1px solid <%= isUnread ? "#c7d2fe" : "#e2e8f0" %>; background: <%= isUnread ? "#f8faff" : "#ffffff" %>; transition: all 0.2s; gap: 12px;">
                                    <div style="display: flex; align-items: flex-start; gap: 12px; flex: 1;">
                                        <div style="width: 38px; height: 38px; border-radius: 10px; background: <%= iconBg %>; color: <%= iconColor %>; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0;">
                                            <i class="<%= iconClass %>"></i>
                                        </div>
                                        <div style="flex: 1;">
                                            <div style="display: flex; align-items: center; gap: 8px;">
                                                <span style="font-weight: 700; font-size: 0.9rem; color: #1e293b;">
                                                    <%= notif.getTitle() %>
                                                </span>
                                                <% if (isUnread) { %>
                                                    <span style="width: 8px; height: 8px; border-radius: 50%; background: #4f46e5; display: inline-block;" title="Unread notification"></span>
                                                <% } %>
                                            </div>
                                            <p style="margin: 3px 0 6px 0; font-size: 0.85rem; color: #475569; line-height: 1.4;">
                                                <%= notif.getMessage() %>
                                            </p>
                                            <div style="font-size: 0.75rem; color: #94a3b8; display: flex; align-items: center; gap: 4px;">
                                                <i class="ri-time-line"></i>
                                                <span><%= notif.getCreatedAt() != null ? notif.getCreatedAt().toString().substring(0, 16) : "" %></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="display: flex; align-items: center; gap: 6px; flex-shrink: 0;">
                                        <% if (isUnread) { %>
                                            <form action="NotificationServlet" method="post" style="margin: 0;">
                                                <input type="hidden" name="action" value="mark_read">
                                                <input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>">
                                                <input type="hidden" name="redirect" value="customer_dashboard.jsp">
                                                <button type="submit" class="btn btn-sm" style="background: #f1f5f9; color: #334155; padding: 4px 8px; font-size: 0.75rem; border: 1px solid #cbd5e1;" title="Mark as read">
                                                    <i class="ri-check-line"></i> Mark Read
                                                </button>
                                            </form>
                                        <% } %>
                                        <form action="NotificationServlet" method="post" style="margin: 0;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>">
                                            <input type="hidden" name="redirect" value="customer_dashboard.jsp">
                                            <button type="submit" class="btn btn-sm" style="background: none; border: none; color: #94a3b8; cursor: pointer; padding: 4px;" title="Dismiss notification">
                                                <i class="ri-close-line" style="font-size: 1.1rem;"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div style="text-align: center; padding: 24px; color: #94a3b8;">
                            <i class="ri-notification-off-line" style="font-size: 2rem; display: block; margin-bottom: 6px; color: #cbd5e1;"></i>
                            <span style="font-size: 0.88rem;">No notifications yet. You will be notified when support answers your tickets or reads your messages.</span>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Recent Support Tickets -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="ri-ticket-2-fill"></i> Recent Support Tickets</div>
                    <a href="tickets.jsp" class="btn btn-secondary btn-sm">View All Tickets</a>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Ticket #</th>
                                <th>Subject</th>
                                <th>Category</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userTickets != null && !userTickets.isEmpty()) {
                                int limit = Math.min(5, userTickets.size());
                                for (int i = 0; i < limit; i++) {
                                    Ticket t = userTickets.get(i);
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
                                        <span class="badge <%= "High".equalsIgnoreCase(t.getPriority()) || "Urgent".equalsIgnoreCase(t.getPriority()) ? "badge-urgent" : "badge-medium" %>">
                                            <%= t.getPriority() %>
                                        </span>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <a href="tickets.jsp" class="btn btn-secondary btn-sm">
                                            <i class="ri-eye-line"></i> View
                                        </a>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="6" style="text-align:center; color: #94a3b8; padding: 30px;">No support tickets created yet. <a href="javascript:void(0)" onclick="document.getElementById('quickTicketModal').classList.add('show')">Create your first ticket</a>.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- General Enquiries -->
            <div class="card">
                <div class="card-header">
                    <div class="card-title"><i class="ri-question-answer-fill"></i> My General Enquiries</div>
                    <a href="new_enquiry.jsp" class="btn btn-secondary btn-sm">New Enquiry</a>
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Enquiry #</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Support Response</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userEnquiries != null && !userEnquiries.isEmpty()) {
                                int limit = Math.min(5, userEnquiries.size());
                                for (int i = 0; i < limit; i++) {
                                    Enquiry e = userEnquiries.get(i);
                                    String status = e.getStatus() != null ? e.getStatus() : "Pending";
                                    String badgeClass = "Resolved".equalsIgnoreCase(status) || "Answered".equalsIgnoreCase(status) ? "badge-resolved" : "badge-pending";
                            %>
                                <tr>
                                    <td><strong><%= e.getEnquiryNumber() != null ? e.getEnquiryNumber() : "#ENQ-" + e.getEnquiryId() %></strong></td>
                                    <td><%= e.getSubject() %></td>
                                    <td><%= e.getMessage() %></td>
                                    <td>
                                        <%= (e.getResponse() != null && !e.getResponse().isEmpty())
                                            ? "<div style='background:#f1f5f9; padding:8px 12px; border-radius:8px; font-weight:600; color:#334155;'><i class='ri-reply-fill' style='color:#4f46e5;'></i> " + e.getResponse() + "</div>"
                                            : "<span style='color:#94a3b8; font-style:italic;'>Awaiting support agent response...</span>" %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="5" style="text-align:center; color: #94a3b8; padding: 30px;">No general enquiries submitted yet. <a href="javascript:void(0)" onclick="document.getElementById('quickEnquiryModal').classList.add('show')">Ask a question</a>.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>

    <!-- Quick Submit Ticket Modal -->
    <div class="modal-backdrop" id="quickTicketModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-ticket-2-line" style="color:#4f46e5;"></i> Submit Support Ticket</h3>
                <button onclick="document.getElementById('quickTicketModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
            </div>
            <form action="TicketServlet" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="modal-subject">Issue Subject</label>
                        <input type="text" id="modal-subject" name="subject" class="form-control" placeholder="Brief title of the issue" required>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label for="modal-category">Category</label>
                            <select id="modal-category" name="category" class="form-control">
                                <option value="Technical Issue">Technical Issue</option>
                                <option value="Account & Login">Account & Login</option>
                                <option value="Billing & Service">Billing & Service</option>
                                <option value="General Inquiry">General Inquiry</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="modal-priority">Priority</label>
                            <select id="modal-priority" name="priority" class="form-control">
                                <option value="Low">Low Priority</option>
                                <option value="Medium" selected>Medium Priority</option>
                                <option value="High">High Priority</option>
                                <option value="Urgent">Urgent</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modal-description">Detailed Description</label>
                        <textarea id="modal-description" name="description" class="form-control" rows="4" placeholder="Please describe the issue in detail..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="document.getElementById('quickTicketModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Submit Ticket</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Quick Ask Question Modal -->
    <div class="modal-backdrop" id="quickEnquiryModal">
        <div class="modal-card">
            <div class="modal-header">
                <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-question-fill" style="color:#4f46e5;"></i> Submit General Enquiry</h3>
                <button onclick="document.getElementById('quickEnquiryModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
            </div>
            <form action="EnquiryServlet" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="enq-subject">Enquiry Subject</label>
                        <input type="text" id="enq-subject" name="subject" class="form-control" placeholder="What is your question regarding?" required>
                    </div>
                    <div class="form-group">
                        <label for="enq-message">Question / Enquiry Details</label>
                        <textarea id="enq-message" name="message" class="form-control" rows="4" placeholder="Type your full question here..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="document.getElementById('quickEnquiryModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                    <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Submit Question</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>