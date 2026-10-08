<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Feedback" %>
<%@ page import="dao.FeedbackDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    String ticketIdStr = request.getParameter("ticketId");

    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> userFeedbacks = feedbackDAO.getFeedbacksByCustomerId(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Feedback - CustomerCare</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <style>
        .star-picker i {
            font-size: 2rem;
            color: #cbd5e1;
            cursor: pointer;
            transition: color 0.2s;
        }
        .star-picker i.selected, .star-picker i:hover {
            color: #f59e0b;
        }
    </style>
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
                    <li><a href="new_enquiry.jsp"><i class="ri-question-line"></i> General Enquiries</a></li>
                    <li><a href="feedback.jsp" class="active"><i class="ri-star-smile-line"></i> My Feedback</a></li>
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
            <div class="top-bar">
                <div class="page-header">
                    <h1>Customer Feedback</h1>
                    <p>Rate your customer care experience and help us continuously improve our services.</p>
                </div>
            </div>

            <!-- Submit / Edit Feedback Card -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-star-smile-fill"></i> Submit Service Feedback</div>
                <form action="FeedbackServlet" method="post">
                    <% if (ticketIdStr != null && !ticketIdStr.isEmpty()) { %>
                        <input type="hidden" name="ticketId" value="<%= ticketIdStr %>">
                        <div style="background: #e0e7ff; color: #3730a3; padding: 10px 16px; border-radius: 8px; font-weight: 700; margin-bottom: 16px; font-size: 0.88rem;">
                            <i class="ri-ticket-line"></i> Submitting feedback for Ticket #<%= ticketIdStr %>
                        </div>
                    <% } %>

                    <div class="form-group">
                        <label>Satisfaction Rating (1 to 5 Stars)</label>
                        <input type="hidden" name="rating" id="ratingInput" value="5">
                        <div class="star-picker" id="starPicker">
                            <i class="ri-star-fill selected" onclick="setRating(1)"></i>
                            <i class="ri-star-fill selected" onclick="setRating(2)"></i>
                            <i class="ri-star-fill selected" onclick="setRating(3)"></i>
                            <i class="ri-star-fill selected" onclick="setRating(4)"></i>
                            <i class="ri-star-fill selected" onclick="setRating(5)"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="comments">Written Feedback & Comments</label>
                        <textarea id="comments" name="comments" class="form-control" rows="4" placeholder="How was your experience? Any suggestions for our team?" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-primary"><i class="ri-send-plane-fill"></i> Submit Feedback</button>
                </form>
            </div>

            <!-- Previous Feedback History -->
            <div class="card">
                <div class="card-title" style="margin-bottom: 20px;"><i class="ri-history-line"></i> Feedback History & Edits</div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Feedback ID</th>
                                <th>Rating</th>
                                <th>Comments</th>
                                <th>Submitted Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userFeedbacks != null && !userFeedbacks.isEmpty()) {
                                for (Feedback fb : userFeedbacks) {
                            %>
                                <tr>
                                    <td><strong>#FB-<%= fb.getFeedbackId() %></strong></td>
                                    <td>
                                        <div style="color: #f59e0b; font-size: 1.1rem; display: flex; gap: 2px;">
                                            <% for (int r = 1; r <= 5; r++) { %>
                                                <i class="ri-star-<%= r <= fb.getRating() ? "fill" : "line" %>"></i>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td><%= fb.getComments() %></td>
                                    <td><%= fb.getCreatedAt() != null ? fb.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                    <td>
                                        <button onclick="editFeedback(<%= fb.getFeedbackId() %>, <%= fb.getRating() %>, '<%= fb.getComments().replace("'", "\\'") %>')" class="btn btn-secondary btn-sm">
                                            <i class="ri-edit-line"></i> Edit
                                        </button>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="5" style="text-align:center; padding: 30px; color: #94a3b8;">No feedback submitted yet.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Edit Feedback Modal -->
            <div class="modal-backdrop" id="editFeedbackModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-edit-line" style="color:#4f46e5;"></i> Edit Your Feedback</h3>
                        <button onclick="document.getElementById('editFeedbackModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="FeedbackServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="feedbackId" id="editFeedbackId">
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="editRating">Rating (1 to 5)</label>
                                <select id="editRating" name="rating" class="form-control">
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Average</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Very Poor</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="editComments">Updated Comments</label>
                                <textarea id="editComments" name="comments" class="form-control" rows="4" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('editFeedbackModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary"><i class="ri-save-line"></i> Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function setRating(stars) {
            document.getElementById('ratingInput').value = stars;
            const icons = document.querySelectorAll('#starPicker i');
            icons.forEach((icon, idx) => {
                if (idx < stars) {
                    icon.classList.add('selected');
                } else {
                    icon.classList.remove('selected');
                }
            });
        }

        function editFeedback(id, rating, comments) {
            document.getElementById('editFeedbackId').value = id;
            document.getElementById('editRating').value = rating;
            document.getElementById('editComments').value = comments;
            document.getElementById('editFeedbackModal').classList.add('show');
        }
    </script>
</body>
</html>