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

@WebServlet("/UserManagementServlet")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"System Administrator".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("create_staff".equalsIgnoreCase(action)) {
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String role = request.getParameter("role");
            String contactNo = request.getParameter("contactNo");

            User newStaff = new User(0, fullName, email, password, role, contactNo);
            userDAO.registerUser(newStaff);
        } else if ("update_role_status".equalsIgnoreCase(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String role = request.getParameter("role");
            String status = request.getParameter("status");

            userDAO.updateUserRoleAndStatus(userId, role, status);
        } else if ("delete".equalsIgnoreCase(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deleteUser(userId);
        } else if ("deactivate".equalsIgnoreCase(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            userDAO.deactivateAccount(userId);
        }

        response.sendRedirect("admin_dashboard.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
