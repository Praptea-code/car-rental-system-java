package com.spra.util;

import com.spra.model.UserModel;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * SessionUtil
 * Centralised helper for reading and writing HTTP session attributes.
 * Used by controllers, filter, and JSPs.
 *
 * @author Spra Team
 */
public class SessionUtil {

    // Session attribute keys
    public static final String ATTR_USER    = "loggedInUser";
    public static final String ATTR_ROLE    = "userRole";
    public static final String ATTR_SUCCESS = "successMessage";
    public static final String ATTR_ERROR   = "errorMessage";

    private SessionUtil() {}

    /**
     * Stores the authenticated user in the session and sets a 30-min timeout.
     *
     * @param request  the current HTTP request
     * @param user     the authenticated UserModel
     */
    public static void loginUser(HttpServletRequest request, UserModel user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(ATTR_USER, user);
        session.setAttribute(ATTR_ROLE, user.getRole());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes
    }

    /**
     * Returns the logged-in UserModel from the session, or null if not logged in.
     */
    public static UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (UserModel) session.getAttribute(ATTR_USER);
    }

    /**
     * Returns true if a user is currently logged in.
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    /**
     * Returns true if the logged-in user has the ADMIN role.
     */
    public static boolean isAdmin(HttpServletRequest request) {
        UserModel user = getLoggedInUser(request);
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }

    /**
     * Invalidates the session (logout).
     */
    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Stores a one-time success message in the session.
     */
    public static void setSuccessMessage(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute(ATTR_SUCCESS, message);
    }

    /**
     * Stores a one-time error message in the session.
     */
    public static void setErrorMessage(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute(ATTR_ERROR, message);
    }

    /**
     * Removes success and error messages from the session after they have been shown.
     */
    public static void clearMessages(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(ATTR_SUCCESS);
            session.removeAttribute(ATTR_ERROR);
        }
    }
}
