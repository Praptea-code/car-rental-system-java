package com.spra.model;

import java.sql.Timestamp;

/**
 * ContactModel
 * Represents a message submitted through the Contact Us page.
 *
 * @author Spra Team
 */
public class ContactModel {

    private int       messageId;
    private String    firstName;
    private String    lastName;
    private String    email;
    private String    subject;
    private String    message;
    private Timestamp createdAt;

    // ---- No-arg constructor ----
    public ContactModel() {}

    // ---- Full constructor ----
    public ContactModel(int messageId, String firstName, String lastName,
                        String email, String subject, String message, Timestamp createdAt) {
        this.messageId = messageId;
        this.firstName = firstName;
        this.lastName  = lastName;
        this.email     = email;
        this.subject   = subject;
        this.message   = message;
        this.createdAt = createdAt;
    }

    // ---- Getters & Setters ----

    public int getMessageId()                    { return messageId; }
    public void setMessageId(int messageId)      { this.messageId = messageId; }

    public String getFirstName()                 { return firstName; }
    public void setFirstName(String firstName)   { this.firstName = firstName; }

    public String getLastName()                  { return lastName; }
    public void setLastName(String lastName)     { this.lastName = lastName; }

    public String getEmail()                     { return email; }
    public void setEmail(String email)           { this.email = email; }

    public String getSubject()                   { return subject; }
    public void setSubject(String subject)       { this.subject = subject; }

    public String getMessage()                   { return message; }
    public void setMessage(String message)       { this.message = message; }

    public Timestamp getCreatedAt()              { return createdAt; }
    public void setCreatedAt(Timestamp t)        { this.createdAt = t; }

    public String getFullName() { return firstName + " " + lastName; }
}
