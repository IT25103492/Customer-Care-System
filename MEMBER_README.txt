==================================================================
Member 01 - User Authentication and Profile Management
Assigned Major Function: User Authentication, Role Routing and Profile Management
==================================================================

[1] LIVE PRESENTATION STEPS (What to demonstrate in 3.5 minutes):
------------------------------------------------------------------
1. Open login.jsp and register.jsp -> Register a new customer.
2. Login as Customer -> redirected to customer_dashboard.jsp.
3. Open profile.jsp -> Update contact details and change password.
4. Login as Admin -> open admin_dashboard.jsp to manage users and toggle active status.

[2] YOUR ASSIGNED CODE FILES IN THIS PACKAGE:
------------------------------------------------------------------
- Servlets (Controllers): LoginServlet.java, LogoutServlet.java, RegisterServlet.java, UpdateProfileServlet.java, UserManagementServlet.java
- DAO (Database Access):  UserDAO.java
- Model (Data Bean):      User.java
- JSP Views:              login.jsp, register.jsp, profile.jsp, admin_dashboard.jsp

[3] GIT COMMANDS TO PUSH YOUR MODULE TO GITHUB:
------------------------------------------------------------------
1. Create and switch to your feature branch:
   git checkout -b feature/user-auth-profile

2. Add your files:
   git add src/main/java/servlet/ src/main/java/dao/ src/main/java/model/ src/main/webapp/

3. Commit with your GitHub name and email:
   git -c user.name="Your Name" -c user.email="your_email@gmail.com" commit -m "Implement User Authentication, Role-based Routing and Profile Management"

4. Push your branch to GitHub:
   git push origin feature/user-auth-profile
==================================================================
