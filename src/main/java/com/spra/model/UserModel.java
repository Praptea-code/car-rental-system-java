package com.spra.model;

import java.sql.Timestamp;

/**
 * UserModel
 * Represents a registered user of the Spra cosmetics platform.
 * Roles: "ADMIN" or "USER"
 *
 * @author Spra Team
 */
public class UserModel {

    private int       userId;
    private String    firstName;
    private String    lastName;
    private String    username;
    private String    email;
    private String    phone;
    private String    password;        // stored as BASE64salt:BASE64hash
    private String    birthdate;
    private String    role;            // ADMIN | USER
    private boolean   isActive;
    private int       loginAttempts;
    private Timestamp lockedUntil;
    private Timestamp createdAt;

    // ---- No-arg constructor ----
    public UserModel() {}

    // ---- Full constructor ----
    public UserModel(int userId, String firstName, String lastName,
                     String username, String email, String phone,
                     String password, String birthdate, String role,
                     boolean isActive, int loginAttempts,
                     Timestamp lockedUntil, Timestamp createdAt) {
        this.userId        = userId;
        this.firstName     = firstName;
        this.lastName      = lastName;
        this.username      = username;
        this.email         = email;
        this.phone         = phone;
        this.password      = password;
        this.birthdate     = birthdate;
        this.role          = role;
        this.isActive      = isActive;
        this.loginAttempts = loginAttempts;
        this.lockedUntil   = lockedUntil;
        this.createdAt     = createdAt;
    }

    // ---- Getters & Setters ----

    public int getUserId() { return userId; }
    public void setUserId(int userId){ this.userId = userId; }

    public String getFirstName()                   { return firstName; }
    public void setFirstName(String firstName)     { this.firstName = firstName; }

    public String getLastName()                    { return lastName; }
    public void setLastName(String lastName)       { this.lastName = lastName; }

    public String getUsername()                    { return username; }
    public void setUsername(String username)       { this.username = username; }

    public String getEmail()                       { return email; }
    public void setEmail(String email)             { this.email = email; }

    public String getPhone()                       { return phone; }
    public void setPhone(String phone)             { this.phone = phone; }

    public String getPassword()                    { return password; }
    public void setPassword(String password)       { this.password = password; }

    public String getBirthdate()                   { return birthdate; }
    public void setBirthdate(String birthdate)     { this.birthdate = birthdate; }

    public String getRole()                        { return role; }
    public void setRole(String role)               { this.role = role; }

    public boolean isActive()                      { return isActive; }
    public void setActive(boolean active)          { isActive = active; }

    public int getLoginAttempts()                  { return loginAttempts; }
    public void setLoginAttempts(int attempts)     { this.loginAttempts = attempts; }

    public Timestamp getLockedUntil()              { return lockedUntil; }
    public void setLockedUntil(Timestamp t)        { this.lockedUntil = t; }

    public Timestamp getCreatedAt()                { return createdAt; }
    public void setCreatedAt(Timestamp t)          { this.createdAt = t; }

    private String googleId;
    
    public String getGoogleId()              { return googleId; }
    public void setGoogleId(String googleId) { this.googleId = googleId; }
    /** Convenience — returns "First Last". */
    public String getFullName() {
        return firstName + " " + lastName;
    }
}
