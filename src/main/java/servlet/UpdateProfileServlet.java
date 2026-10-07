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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("change_password".equalsIgnoreCase(action)) {
            String newPassword = request.getParameter("newPassword");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (userDAO.updatePassword(user.getUserId(), newPassword)) {
                    user.setPassword(newPassword);
                    session.setAttribute("user", user);
                    response.sendRedirect("profile.jsp?status=pwd_success");
                } else {
                    response.sendRedirect("profile.jsp?status=pwd_error");
                }
            } else {
                response.sendRedirect("profile.jsp?status=invalid_pwd");
            }
        } else if ("deactivate".equalsIgnoreCase(action)) {
            if (userDAO.deactivateAccount(user.getUserId())) {
                session.invalidate();
                response.sendRedirect("login.jsp?msg=account_deactivated");
            } else {
                response.sendRedirect("profile.jsp?status=deactivate_error");
            }
        } else {
            // Update Profile details
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String contactNo = request.getParameter("contactNo");

            user.setFullName(fullName);
            user.setEmail(email);
            user.setContactNo(contactNo);

            if (userDAO.updateUserProfile(user)) {
                session.setAttribute("user", user);
                response.sendRedirect("profile.jsp?status=success");
            } else {
                response.sendRedirect("profile.jsp?status=error");
            }
        }
    }
}