package com.spra.service;

import com.spra.dao.UserDAO;
import com.spra.model.UserModel;
import com.spra.util.PasswordUtil;

import java.sql.Timestamp;
import java.time.Instant;

/**
 * LoginService
 * Handles the authentication logic for user login.
 * Includes account lock detection and login attempt tracking.
 *
 * @author Spra Team
 */
public class LoginService {

    private final UserDAO userDAO = new UserDAO();

    // Return codes for login result
    public static final int RESULT_SUCCESS       = 0;
    public static final int RESULT_NOT_FOUND     = 1;
    public static final int RESULT_WRONG_PASS    = 2;
    public static final int RESULT_ACCOUNT_LOCK  = 3;
    public static final int RESULT_INACTIVE      = 4;

    /**
     * Attempts to authenticate a user.
     *
     * @param username  username submitted via form
     * @param password  plain-text password submitted via form
     * @return one of the RESULT_ constants defined above
     */
    public int authenticate(String username, String password) {

        UserModel user = userDAO.getUserByUsername(username);

        // User not found
        if (user == null) return RESULT_NOT_FOUND;

        // Account inactive
        if (!user.isActive()) return RESULT_INACTIVE;

        // Account locked
        Timestamp locked = user.getLockedUntil();
        if (locked != null && locked.after(Timestamp.from(Instant.now()))) {
            return RESULT_ACCOUNT_LOCK;
        }

        // Password check
        boolean passwordMatches = PasswordUtil.verifyPassword(password, user.getPassword());

        if (!passwordMatches) {
            userDAO.incrementLoginAttempts(username);
            return RESULT_WRONG_PASS;
        }

        // Success — reset attempts counter
        userDAO.resetLoginAttempts(username);
        return RESULT_SUCCESS;
    }

    /**
     * Returns the UserModel for a username (called after successful authentication).
     *
     * @param username  authenticated username
     * @return UserModel object
     */
    public UserModel getUserByUsername(String username) {
        return userDAO.getUserByUsername(username);
    }

    /**
     * Returns a human-readable error message for a given result code.
     */
    public String getErrorMessage(int resultCode) {
        switch (resultCode) {
            case RESULT_NOT_FOUND:    return "No account found with that username.";
            case RESULT_WRONG_PASS:   return "Incorrect password. Please try again.";
            case RESULT_ACCOUNT_LOCK: return "Your account is temporarily locked due to too many failed attempts. Try again in 15 minutes.";
            case RESULT_INACTIVE:     return "Your account has been deactivated. Please contact support.";
            default:                  return "Login failed. Please try again.";
        }
    }
}
