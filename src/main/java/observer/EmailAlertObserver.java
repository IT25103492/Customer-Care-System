package observer;

/**
 * ConcreteObserver 2: EmailAlertObserver
 * Handles dispatching simulated email alerts when ticket events occur.
 */
public class EmailAlertObserver implements Observer {

    @Override
    public void update(String title, String message, int recipientUserId) {
        System.out.println("[Observer: EmailAlert] Dispatching Email Alert -> To UserID: " + recipientUserId + " | Subject: " + title + " | Body: " + message);
    }
}
