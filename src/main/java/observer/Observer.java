package observer;

/**
 * Observer Interface (Behavioral Design Pattern).
 * Defines the contract for objects that receive updates from a Subject.
 */
public interface Observer {
    void update(String title, String message, int recipientUserId);
}
