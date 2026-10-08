package observer;

/**
 * Subject Interface (Behavioral Design Pattern).
 * Outlines methods to attach, detach, and notify registered observers.
 */
public interface Subject {
    void addObserver(Observer observer);
    void removeObserver(Observer observer);
    void notifyObservers(String title, String message, int recipientUserId);
}
