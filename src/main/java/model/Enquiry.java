package model;

import java.sql.Timestamp;

public class Enquiry {
    private int enquiryId;
    private String enquiryNumber;
    private int customerId;
    private String customerName;
    private String subject;
    private String message;
    private String response;
    private int respondedBy;
    private String respondedByName;
    private String status;
    private Timestamp createdAt;

    public Enquiry() {}

    public Enquiry(int enquiryId, String enquiryNumber, int customerId, String subject,
                   String message, String response, String status, Timestamp createdAt) {
        this.enquiryId = enquiryId;
        this.enquiryNumber = enquiryNumber;
        this.customerId = customerId;
        this.subject = subject;
        this.message = message;
        this.response = response;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getEnquiryId() { return enquiryId; }
    public void setEnquiryId(int enquiryId) { this.enquiryId = enquiryId; }

    public String getEnquiryNumber() { return enquiryNumber; }
    public void setEnquiryNumber(String enquiryNumber) { this.enquiryNumber = enquiryNumber; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }

    public int getRespondedBy() { return respondedBy; }
    public void setRespondedBy(int respondedBy) { this.respondedBy = respondedBy; }

    public String getRespondedByName() { return respondedByName; }
    public void setRespondedByName(String respondedByName) { this.respondedByName = respondedByName; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
