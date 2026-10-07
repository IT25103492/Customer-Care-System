package servlet;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.validateUser(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

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
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}