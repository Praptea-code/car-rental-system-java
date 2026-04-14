package com.spra.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * CookieUtil
 * Helper methods for creating, reading, and deleting HTTP cookies.
 * Used by LoginController and LogoutController.
 *
 * @author Spra Team
 */
public class CookieUtil {

    private CookieUtil() {}

    /**
     * Creates and adds a new cookie to the response.
     *
     * @param response  the HTTP response
     * @param name      cookie name
     * @param value     cookie value
     * @param maxAge    lifetime in seconds (use -1 for session cookie)
     */
    public static void addCookie(HttpServletResponse response,
                                 String name, String value, int maxAge) {
        Cookie cookie = new Cookie(name, value);
        cookie.setMaxAge(maxAge);
        cookie.setPath("/");
        cookie.setHttpOnly(true); // Prevents JavaScript access for security
        response.addCookie(cookie);
    }

    /**
     * Retrieves the value of a cookie by name from the request.
     *
     * @param request  the HTTP request
     * @param name     the cookie name to look for
     * @return cookie value string, or null if not found
     */
    public static String getCookie(HttpServletRequest request, String name) {
        if (request.getCookies() == null) return null;
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals(name)) {
                return cookie.getValue();
            }
        }
        return null;
    }

    /**
     * Deletes a cookie by setting its max age to 0.
     *
     * @param response the HTTP response
     * @param name     cookie name to delete
     */
    public static void deleteCookie(HttpServletResponse response, String name) {
        Cookie cookie = new Cookie(name, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }
}
