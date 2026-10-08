==================================================================
Member 06 - Customer Feedback and Design Pattern Lead
Assigned Major Function: Customer Feedback Rating System and Observer Design Pattern
==================================================================

[1] LIVE PRESENTATION STEPS (What to demonstrate in 3.5 minutes):
------------------------------------------------------------------
1. Customer submits 5-star rating and feedback review for a resolved ticket via feedback.jsp.
2. Admin / Manager dashboard displays aggregate satisfaction score and feedback list.
3. EXPLAIN DESIGN PATTERNS (5 MARKS): Show observer/TicketSubject.java, Subject.java, Observer.java, InAppNotificationObserver.java, EmailAlertObserver.java, AuditLogObserver.java, and DBConnection.java.
4. Demonstrate how Observers decouple notification delivery from core ticket operations.

[2] YOUR ASSIGNED CODE FILES IN THIS PACKAGE:
------------------------------------------------------------------
- Servlets (Controllers): FeedbackServlet.java, NotificationServlet.java
- DAO (Database Access):  FeedbackDAO.java, NotificationDAO.java
- Model (Data Bean):      Feedback.java, Notification.java
- JSP Views:              feedback.jsp, dashboard.jsp
- Design Pattern (5 Marks): src/main/java/observer/ (Subject.java, Observer.java, TicketSubject.java, InAppNotificationObserver.java, EmailAlertObserver.java, AuditLogObserver.java)

[3] GIT COMMANDS TO PUSH YOUR MODULE TO GITHUB:
------------------------------------------------------------------
1. Create and switch to your feature branch:
   git checkout -b feature/feedback-observer-pattern

2. Add your files:
   git add src/main/java/servlet/ src/main/java/dao/ src/main/java/model/ src/main/webapp/

3. Commit with your GitHub name and email:
   git -c user.name="Your Name" -c user.email="your_email@gmail.com" commit -m "Implement Customer Feedback ratings and Observer Design Pattern implementation"

4. Push your branch to GitHub:
   git push origin feature/feedback-observer-pattern
==================================================================
