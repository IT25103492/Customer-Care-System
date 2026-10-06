package model;

import java.sql.Timestamp;

public class Escalation {
    private int escalationId;
    private int ticketId;
    private String ticketNumber;
    private String ticketSubject;
    private String customerName;
    private int escalatedBy;
    private String escalatorName;
    private int escalatedTo;
    private String escalatedToName;
    private String reason;
    private String priority;
    private String status;
    private Timestamp escalatedAt;

    public Escalation() {}

    public Escalation(int escalationId, int ticketId, int escalatedBy, String reason, String status, Timestamp escalatedAt) {
        this.escalationId = escalationId;
        this.ticketId = ticketId;
        this.escalatedBy = escalatedBy;
        this.reason = reason;
        this.status = status;
        this.escalatedAt = escalatedAt;
    }

    public int getEscalationId() { return escalationId; }
    public void setEscalationId(int escalationId) { this.escalationId = escalationId; }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }

    public String getTicketNumber() { return ticketNumber; }
    public void setTicketNumber(String ticketNumber) { this.ticketNumber = ticketNumber; }

    public String getTicketSubject() { return ticketSubject; }
    public void setTicketSubject(String ticketSubject) { this.ticketSubject = ticketSubject; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public int getEscalatedBy() { return escalatedBy; }
    public void setEscalatedBy(int escalatedBy) { this.escalatedBy = escalatedBy; }

    public String getEscalatorName() { return escalatorName; }
    public void setEscalatorName(String escalatorName) { this.escalatorName = escalatorName; }

    public int getEscalatedTo() { return escalatedTo; }
    public void setEscalatedTo(int escalatedTo) { this.escalatedTo = escalatedTo; }

    public String getEscalatedToName() { return escalatedToName; }
    public void setEscalatedToName(String escalatedToName) { this.escalatedToName = escalatedToName; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getEscalatedAt() { return escalatedAt; }
    public void setEscalatedAt(Timestamp escalatedAt) { this.escalatedAt = escalatedAt; }
}
