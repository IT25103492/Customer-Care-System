==================================================================
Member 03 - Ticket Lifecycle and Helpdesk Operations
Assigned Major Function: Support Ticket Lifecycle, Agent Assignment and Status Management
==================================================================

[1] LIVE PRESENTATION STEPS (What to demonstrate in 3.5 minutes):
------------------------------------------------------------------
1. Customer raises a new ticket via tickets.jsp with Priority and Category.
2. Support Agent reviews ticket in support_dashboard.jsp / manage_tickets.jsp and assigns to Technical Staff.
3. Technical Officer logs in (technical_dashboard.jsp), updates status to 'In Progress' and then 'Resolved'.
4. Ticket history updates seamlessly across support views.

[2] YOUR ASSIGNED CODE FILES IN THIS PACKAGE:
------------------------------------------------------------------
- Servlets (Controllers): TicketServlet.java
- DAO (Database Access):  TicketDAO.java
- Model (Data Bean):      Ticket.java
- JSP Views:              tickets.jsp, manage_tickets.jsp, support_dashboard.jsp, technical_dashboard.jsp

[3] GIT COMMANDS TO PUSH YOUR MODULE TO GITHUB:
------------------------------------------------------------------
1. Create and switch to your feature branch:
   git checkout -b feature/ticket-lifecycle

2. Add your files:
   git add src/main/java/servlet/ src/main/java/dao/ src/main/java/model/ src/main/webapp/

3. Commit with your GitHub name and email:
   git -c user.name="Your Name" -c user.email="your_email@gmail.com" commit -m "Implement Ticket Lifecycle, Priority Queues and Technical Dashboard processing"

4. Push your branch to GitHub:
   git push origin feature/ticket-lifecycle
==================================================================
