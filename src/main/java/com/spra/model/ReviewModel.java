package com.spra.model;

import java.sql.Timestamp;

/**
 * ReviewModel
 * Represents a user review for a product.
 *
 * @author Spra Team
 */
public class ReviewModel {

    private int       reviewId;
    private int       productId;
    private int       userId;
    private String    username;
    private String    firstName;
    private String    lastName;
    private int       rating;       // 1–5
    private String    title;
    private String    body;
    private Timestamp createdAt;

    public ReviewModel() {}

    // ---- Getters & Setters ----

    public int getReviewId()                        { return reviewId; }
    public void setReviewId(int reviewId)           { this.reviewId = reviewId; }

    public int getProductId()                       { return productId; }
    public void setProductId(int productId)         { this.productId = productId; }

    public int getUserId()                          { return userId; }
    public void setUserId(int userId)               { this.userId = userId; }

    public String getUsername()                     { return username; }
    public void setUsername(String username)        { this.username = username; }

    public String getFirstName()                    { return firstName; }
    public void setFirstName(String firstName)      { this.firstName = firstName; }

    public String getLastName()                     { return lastName; }
    public void setLastName(String lastName)        { this.lastName = lastName; }

    public int getRating()                          { return rating; }
    public void setRating(int rating)               { this.rating = rating; }

    public String getTitle()                        { return title; }
    public void setTitle(String title)              { this.title = title; }

    public String getBody()                         { return body; }
    public void setBody(String body)                { this.body = body; }

    public Timestamp getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(Timestamp t)           { this.createdAt = t; }

    /** Convenience – returns "First Last". */
    public String getFullName() { return firstName + " " + lastName; }

    /** Returns initials for avatar display. */
    public String getInitials() {
        String f = (firstName != null && !firstName.isEmpty()) ? String.valueOf(firstName.charAt(0)) : "";
        String l = (lastName  != null && !lastName.isEmpty())  ? String.valueOf(lastName.charAt(0))  : "";
        return (f + l).toUpperCase();
    }
}