<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String role = user.getRole() != null ? user.getRole().trim() : "";

    if ("Customer".equalsIgnoreCase(role)) {
        response.sendRedirect("customer_dashboard.jsp");
    } else if ("Customer Support Officer".equalsIgnoreCase(role)) {
        response.sendRedirect("support_dashboard.jsp");
    } else if ("Team Supervisor".equalsIgnoreCase(role)) {
        response.sendRedirect("supervisor_dashboard.jsp");
    } else if ("Technical Staff".equalsIgnoreCase(role)) {
        response.sendRedirect("technical_dashboard.jsp");
    } else if ("Customer Care Manager".equalsIgnoreCase(role)) {
        response.sendRedirect("manager_dashboard.jsp");
    } else if ("System Administrator".equalsIgnoreCase(role)) {
        response.sendRedirect("admin_dashboard.jsp");
    } else {
        response.sendRedirect("customer_dashboard.jsp");
    }
%>