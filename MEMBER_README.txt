==================================================================
Member 02 - Customer Enquiry Management System
Assigned Major Function: Customer Enquiry Management and Support Response
==================================================================

[1] LIVE PRESENTATION STEPS (What to demonstrate in 3.5 minutes):
------------------------------------------------------------------
1. Open new_enquiry.jsp -> Customer submits an enquiry under Category (General, Billing, Technical).
2. View pending enquiry in Customer Dashboard.
3. Support Agent logs in and opens manage_enquiries.jsp.
4. Filter enquiries and submit staff reply -> Enquiry status changes to Answered.

[2] YOUR ASSIGNED CODE FILES IN THIS PACKAGE:
------------------------------------------------------------------
- Servlets (Controllers): EnquiryServlet.java
- DAO (Database Access):  EnquiryDAO.java
- Model (Data Bean):      Enquiry.java
- JSP Views:              new_enquiry.jsp, enquiry.jsp, manage_enquiries.jsp, customer_dashboard.jsp

[3] GIT COMMANDS TO PUSH YOUR MODULE TO GITHUB:
------------------------------------------------------------------
1. Create and switch to your feature branch:
   git checkout -b feature/enquiry-management

2. Add your files:
   git add src/main/java/servlet/ src/main/java/dao/ src/main/java/model/ src/main/webapp/

3. Commit with your GitHub name and email:
   git -c user.name="Your Name" -c user.email="your_email@gmail.com" commit -m "Implement Customer Enquiry submission, category filtering and staff response flow"

4. Push your branch to GitHub:
   git push origin feature/enquiry-management
==================================================================
