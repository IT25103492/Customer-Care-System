package observer;

import dao.NotificationDAO;

/**
 * ConcreteObserver 1: InAppNotificationObserver
 * Automatically persists notifications into the database via NotificationDAO.
 */
public class InAppNotificationObserver implements Observer {

    private NotificationDAO notificationDAO;

    public InAppNotificationObserver() {
        this.notificationDAO = new NotificationDAO();
    }

    @Override
    public void update(String title, String message, int recipientUserId) {
        if (recipientUserId > 0) {
            notificationDAO.createNotification(recipientUserId, title, message);
            System.out.println("[Observer: InAppNotification] Saved notification for User ID: " + recipientUserId);
        }
    }
}
