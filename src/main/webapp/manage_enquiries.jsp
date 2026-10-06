<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Enquiry" %>
<%@ page import="dao.EnquiryDAO" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || "Customer".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> allEnquiries = enquiryDAO.getAllEnquiries();

    int totalEnquiries = allEnquiries != null ? allEnquiries.size() : 0;
    int pendingCount = 0;
    int answeredCount = 0;
    int resolvedCount = 0;

    if (allEnquiries != null) {
        for (Enquiry eq : allEnquiries) {
            String s = eq.getStatus();
            if ("Pending".equalsIgnoreCase(s)) pendingCount++;
            else if ("Answered".equalsIgnoreCase(s)) answeredCount++;
            else if ("Resolved".equalsIgnoreCase(s)) resolvedCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enquiry Management Dashboard - CustomerCare</title>
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
                    <li><a href="manage_tickets.jsp"><i class="ri-ticket-2-line"></i> Ticket Management</a></li>
                    <li><a href="manage_enquiries.jsp" class="active"><i class="ri-question-answer-fill"></i> Enquiry Management</a></li>
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
            <div style="background: linear-gradient(135deg, #0f766e 0%, #0d9488 60%, #14b8a6 100%); border-radius: 18px; padding: 26px 30px; margin-bottom: 24px; position: relative; overflow: hidden;">
                <div style="position:absolute; right:24px; top:50%; transform:translateY(-50%); font-size:5rem; opacity:0.12;"><i class="ri-question-answer-fill"></i></div>
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px; position:relative;">
                    <div>
                        <div style="display:inline-flex; align-items:center; gap:8px; background:rgba(255,255,255,0.15); border-radius:20px; padding:4px 12px; font-size:0.75rem; font-weight:700; color:rgba(255,255,255,0.9); margin-bottom:10px;">
                            <i class="ri-question-answer-line"></i> Enquiry Management Hub
                        </div>
                        <h1 style="font-size:1.55rem; font-weight:800; color:#fff; letter-spacing:-0.5px; margin:0;">Customer General Enquiries Management</h1>
                        <p style="color:rgba(255,255,255,0.7); font-size:0.87rem; margin-top:6px;">Review questions, send official responses, update enquiry status, and delete records.</p>
                    </div>
                </div>
            </div>

            <!-- Stats Metric Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon icon-blue"><i class="ri-inbox-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= totalEnquiries %></div>
                        <div class="label">Total Enquiries</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-amber"><i class="ri-time-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= pendingCount %></div>
                        <div class="label">Pending Responses</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-purple"><i class="ri-reply-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= answeredCount %></div>
                        <div class="label">Answered</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon icon-emerald"><i class="ri-checkbox-circle-line"></i></div>
                    <div class="stat-data">
                        <div class="value"><%= resolvedCount %></div>
                        <div class="label">Resolved</div>
                    </div>
                </div>
            </div>

            <!-- Enquiry Management Table Card -->
            <div class="card">
                <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                    <div class="card-title"><i class="ri-table-line"></i> Customer Enquiries Queue</div>
                    <input type="text" id="enquirySearchInput" onkeyup="filterEnquiries()" placeholder="Search by Enquiry #, Customer, Subject..." class="form-control" style="max-width:320px; font-size:0.85rem;">
                </div>
                <div class="table-container" style="box-shadow: none; border: none; margin: 0;">
                    <table class="data-table" id="enquiriesTable">
                        <thead>
                            <tr>
                                <th>Enquiry #</th>
                                <th>Customer</th>
                                <th>Subject</th>
                                <th>Customer Question</th>
                                <th>Official Response</th>
                                <th>Status</th>
                                <th>Actions (Respond / Delete)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (allEnquiries != null && !allEnquiries.isEmpty()) {
                                for (Enquiry eq : allEnquiries) {
                                    String status = eq.getStatus() != null ? eq.getStatus() : "Pending";
                                    String badgeClass = "badge-pending";
                                    if ("Answered".equalsIgnoreCase(status) || "Resolved".equalsIgnoreCase(status)) {
                                        badgeClass = "badge-resolved";
                                    }
                            %>
                                <tr>
                                    <td><strong><%= eq.getEnquiryNumber() != null ? eq.getEnquiryNumber() : "#ENQ-" + eq.getEnquiryId() %></strong></td>
                                    <td>
                                        <div style="font-weight:700; color:#1e293b;"><%= eq.getCustomerName() != null ? eq.getCustomerName() : "Customer #" + eq.getCustomerId() %></div>
                                        <div style="font-size:0.75rem; color:#64748b;">ID: <%= eq.getCustomerId() %></div>
                                    </td>
                                    <td><strong><%= eq.getSubject() %></strong></td>
                                    <td style="max-width:280px;"><%= eq.getMessage() %></td>
                                    <td style="max-width:280px;">
                                        <% if (eq.getResponse() != null && !eq.getResponse().trim().isEmpty()) { %>
                                            <div style="color:#059669; font-weight:600;"><%= eq.getResponse() %></div>
                                            <% if (eq.getRespondedByName() != null) { %>
                                                <div style="font-size:0.72rem; color:#64748b;">By: <%= eq.getRespondedByName() %></div>
                                            <% } %>
                                        <% } else { %>
                                            <span style="color:#94a3b8; font-style:italic;">Awaiting Response</span>
                                        <% } %>
                                    </td>
                                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                                    <td>
                                        <div style="display:flex; gap:6px; flex-wrap:wrap; align-items:center;">
                                            <!-- Respond / Update Modal Button -->
                                            <button onclick="openResponseModal(<%= eq.getEnquiryId() %>, '<%= eq.getEnquiryNumber() %>', '<%= eq.getSubject().replace("'", "\\'") %>', '<%= eq.getResponse() != null ? eq.getResponse().replace("'", "\\'").replace("\n", " ") : "" %>', '<%= status %>')" class="btn btn-primary btn-sm">
                                                <i class="ri-reply-line"></i> <%= (eq.getResponse() != null && !eq.getResponse().isEmpty()) ? "Edit Reply" : "Respond" %>
                                            </button>

                                            <!-- DELETE ENQUIRY ACTION -->
                                            <form action="EnquiryServlet" method="post" style="display:inline-flex;" onsubmit="return confirm('Are you sure you want to permanently delete Enquiry <%= eq.getEnquiryNumber() %>?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="enquiryId" value="<%= eq.getEnquiryId() %>">
                                                <input type="hidden" name="redirect" value="manage_enquiries.jsp">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Delete Enquiry">
                                                    <i class="ri-delete-bin-line"></i> Delete
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <%  }
                               } else { %>
                                <tr><td colspan="7" style="text-align:center; padding: 40px; color: #94a3b8;">No customer enquiries found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Respond to Enquiry Modal -->
            <div class="modal-backdrop" id="responseModal">
                <div class="modal-card">
                    <div class="modal-header">
                        <h3 style="font-weight: 800; font-size: 1.1rem;"><i class="ri-reply-fill" style="color:#0d9488;"></i> Official Enquiry Response</h3>
                        <button onclick="document.getElementById('responseModal').classList.remove('show')" style="border:none; background:none; font-size:1.2rem; cursor:pointer;"><i class="ri-close-line"></i></button>
                    </div>
                    <form action="EnquiryServlet" method="post">
                        <input type="hidden" name="action" value="respond">
                        <input type="hidden" name="enquiryId" id="modalEnquiryId">
                        <input type="hidden" name="redirect" value="manage_enquiries.jsp">
                        <div class="modal-body">
                            <div class="form-group">
                                <label>Enquiry Reference & Subject</label>
                                <input type="text" id="modalEnquirySubject" class="form-control" readonly style="background:#f8fafc; font-weight:700;">
                            </div>
                            <div class="form-group">
                                <label for="modalResponseText">Official Response</label>
                                <textarea name="response" id="modalResponseText" class="form-control" rows="5" placeholder="Type your clear official response to the customer..." required></textarea>
                            </div>
                            <div class="form-group">
                                <label for="modalStatus">Enquiry Status</label>
                                <select name="status" id="modalStatus" class="form-control">
                                    <option value="Answered">Answered</option>
                                    <option value="Resolved">Resolved</option>
                                    <option value="Pending">Keep Pending</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" onclick="document.getElementById('responseModal').classList.remove('show')" class="btn btn-secondary">Cancel</button>
                            <button type="submit" class="btn btn-primary" style="background:#0d9488;"><i class="ri-send-plane-fill"></i> Send Response</button>
                        </div>
                    </form>
                </div>
            </div>

        </main>
    </div>

    <script>
        function openResponseModal(id, num, subject, currentResponse, status) {
            document.getElementById('modalEnquiryId').value = id;
            document.getElementById('modalEnquirySubject').value = num + " - " + subject;
            document.getElementById('modalResponseText').value = currentResponse || '';
            document.getElementById('modalStatus').value = status || 'Answered';
            document.getElementById('responseModal').classList.add('show');
        }

        function filterEnquiries() {
            var input = document.getElementById("enquirySearchInput");
            var filter = input.value.toUpperCase();
            var table = document.getElementById("enquiriesTable");
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