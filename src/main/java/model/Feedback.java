package model;

import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int userId; // CustomerID
    private String customerName;
    private Integer ticketId;
    private String ticketSubject;
    private int rating;
    private String comments;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Feedback() {}

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public Integer getTicketId() { return ticketId; }
    public void setTicketId(Integer ticketId) { this.ticketId = ticketId; }

    public String getTicketSubject() { return ticketSubject; }
    public void setTicketSubject(String ticketSubject) { this.ticketSubject = ticketSubject; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}