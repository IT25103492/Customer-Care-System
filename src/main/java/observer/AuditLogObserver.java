package observer;

import java.time.LocalDateTime;

/**
 * ConcreteObserver 3: AuditLogObserver
 * Logs system audit logs for administrative tracking.
 */
public class AuditLogObserver implements Observer {

    @Override
    public void update(String title, String message, int recipientUserId) {
        System.out.println("[Observer: AuditTrail] [" + LocalDateTime.now() + "] Recipient ID: " + recipientUserId + " - Event: " + title + " - Details: " + message);
    }
}
