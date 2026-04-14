package com.spra.util;

import com.spra.model.UserModel;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static final String ATTR_USER    = "loggedInUser";
    public static final String ATTR_ROLE    = "userRole";
    public static final String ATTR_SUCCESS = "successMessage";
    public static final String ATTR_ERROR   = "errorMessage";

    private SessionUtil() {}

    public static void loginUser(HttpServletRequest request, UserModel user) {
        HttpSession session = request.getSession(true);
        session.setAttribute("loggedInUser", user);
        session.setAttribute("userRole", user.getRole());
        session.setMaxInactiveInterval(1800);
    }

    public static UserModel getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (UserModel) session.getAttribute("loggedInUser");
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoggedInUser(request) != null;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        UserModel user = getLoggedInUser(request);
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }

    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static void setSuccessMessage(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("successMessage", message);
    }

    public static void setErrorMessage(HttpServletRequest request, String message) {
        request.getSession(true).setAttribute("errorMessage", message);
    }

    public static void clearMessages(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");
        }
    }
}
