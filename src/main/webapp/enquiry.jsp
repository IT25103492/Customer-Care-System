<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.EnquiryDAO, model.Enquiry, model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = user.getRole(); // "Customer", "Staff", "Admin"
    EnquiryDAO enquiryDAO = new EnquiryDAO();
    List<Enquiry> enquiryList;

    if ("Admin".equalsIgnoreCase(role) || "Staff".equalsIgnoreCase(role)) {
        enquiryList = enquiryDAO.getAllEnquiries(); // සියලුම Enquiries Fetch වේ
    } else {
        enquiryList = enquiryDAO.getEnquiriesByCustomerId(user.getUserId());
    }
%>

<!-- Enquiries Table Structure -->
<table class="table">
    <thead>
        <tr>
            <th>ID</th>
            <th>Subject</th>
            <th>Message</th>
            <th>Status</th>
            <% if ("Admin".equalsIgnoreCase(role) || "Staff".equalsIgnoreCase(role)) { %>
                <th>Action</th>
            <% } %>
        </tr>
    </thead>
    <tbody>
        <%
        if (enquiryList != null && !enquiryList.isEmpty()) {
            for (Enquiry eq : enquiryList) {
        %>
            <tr>
                <td>#<%= eq.getEnquiryId() %></td>
                <td><%= eq.getSubject() %></td>
                <td><%= eq.getMessage() %></td>
                <td><span class="badge"><%= eq.getStatus() %></span></td>

                <%-- Admin / Staff ට පමණක් "Reply to Customer" Button එක පෙන්වීම --%>
                <% if ("Admin".equalsIgnoreCase(role) || "Staff".equalsIgnoreCase(role)) { %>
                    <td>
                        <a href="reply_enquiry.jsp?id=<%= eq.getEnquiryId() %>" class="btn btn-sm btn-primary">
                            Reply to Customer
                        </a>
                    </td>
                <% } %>
            </tr>
        <%
            }
        } else {
        %>
            <tr>
                <td colspan="5">No enquiries found.</td>
            </tr>
        <% } %>
    </tbody>
</table>