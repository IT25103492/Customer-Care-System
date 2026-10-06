==================================================================
Member 04 - Ticket Escalation Management
Assigned Major Function: Ticket Escalation Workflow and Supervisor/Manager Dashboard
==================================================================

[1] LIVE PRESENTATION STEPS (What to demonstrate in 3.5 minutes):
------------------------------------------------------------------
1. Technical Agent opens escalation.jsp and escalates a critical unresolved ticket with justification.
2. Supervisor logs in (supervisor_dashboard.jsp) and views escalated queue.
3. Manager logs in (manager_dashboard.jsp) and overrides priority, assigns senior specialists.
4. View escalation resolution log and updated ticket state.

[2] YOUR ASSIGNED CODE FILES IN THIS PACKAGE:
------------------------------------------------------------------
- Servlets (Controllers): EscalationServlet.java
- DAO (Database Access):  EscalationDAO.java
- Model (Data Bean):      Escalation.java
- JSP Views:              escalation.jsp, supervisor_dashboard.jsp, manager_dashboard.jsp

[3] GIT COMMANDS TO PUSH YOUR MODULE TO GITHUB:
------------------------------------------------------------------
1. Create and switch to your feature branch:
   git checkout -b feature/escalation-system

2. Add your files:
   git add src/main/java/servlet/ src/main/java/dao/ src/main/java/model/ src/main/webapp/

3. Commit with your GitHub name and email:
   git -c user.name="Your Name" -c user.email="your_email@gmail.com" commit -m "Implement Multi-tier Ticket Escalation and Supervisor/Manager workflow"

4. Push your branch to GitHub:
   git push origin feature/escalation-system
==================================================================
