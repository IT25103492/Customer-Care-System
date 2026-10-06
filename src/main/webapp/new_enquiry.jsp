<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Enquiry" %>
<%@ page import="dao.EnquiryDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> userEnquiries = enquiryDAO.getEnquiriesByCustomerId(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>General Enquiries - CustomerCare</title>
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
                    <li><a href="tickets.jsp"><i class="ri-ticket-2-line"></i> Support Tickets</a></li>
                    <li><a href="new_enquiry.jsp" class="active"><i class="ri-question-line"></i> General Enquiries</a></li>
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
                if ("enquiry_created".equals(successParam)) {
            %>
                <div style="background: #dbeafe; border: 1px solid #93c5fd; color: #1e40af; padding: 14px 20px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 600;">
                    <i class="ri-information-fill" style="font-size: 1.3rem; color: #2563eb;"></i>
                    <span>Your General Enquiry has been submitted successfully!</span>
                </div>
            <%  } %>

            <div class="top-bar">
                <div class="page-header">
                    <h1>General Enquiries</h1>
                    <p>Ask quick questions to our support team and receive official responses.</p>
                </div>
            </div>

            <!-- Submit Enquiry Form Card -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-question-fill"></i> Submit a New Question / Enquiry</div>
                <form action="EnquiryServlet" method="post">
                    <input type="hidden" name="source" value="enquiry_page">
                    <div class="form-group">
                        <label for="subject">Enquiry Subject</label>
                        <input type="text" id="subject" name="subject" class="form-control" placeholder="What is your question regarding?" required>
                    </div>

                    <div class="form-group">
                        <label for="message">Question / Enquiry Details</label>
                        <textarea id="message" name="message" class="form-control" rows="4" placeholder="Type your full question here..." required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Submit Question</button>
                </form>
            </div>

            <!-- Previous Enquiries Table -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-history-line"></i> Your Enquiry History</div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Enquiry #</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Support Response</th>
                                <th>Status</th>
                                <th>Submitted Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userEnquiries != null && !userEnquiries.isEmpty()) {
                                for (Enquiry e : userEnquiries) {
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
                                            : "<span style='color:#94a3b8; font-style:italic;'>Awaiting response...</span>" %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td><%= e.getCreatedAt() != null ? e.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="6" style="text-align:center; padding: 30px; color: #94a3b8;">No general enquiries submitted yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </main>
    </div>
</body>
</html>