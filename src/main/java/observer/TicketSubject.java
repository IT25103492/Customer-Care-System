package observer;

import java.util.ArrayList;
import java.util.List;

/**
 * ConcreteSubject implementing the Subject interface.
 * Maintains a collection of Observers and broadcasts ticket status/assignment changes.
 */
public class TicketSubject implements Subject {

    private List<Observer> observers = new ArrayList<>();

    @Override
    public void addObserver(Observer observer) {
        if (observer != null && !observers.contains(observer)) {
            observers.add(observer);
        }
    }

    @Override
    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers(String title, String message, int recipientUserId) {
        for (Observer observer : observers) {
            observer.update(title, message, recipientUserId);
        }
    }

    /**
     * Helper method to publish ticket events across all registered observers.
     */
    public void publishTicketEvent(String title, String message, int recipientUserId) {
        notifyObservers(title, message, recipientUserId);
    }
}
