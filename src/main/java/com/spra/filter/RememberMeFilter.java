package com.spra.filter;

import com.spra.dao.UserDAO;
import com.spra.model.UserModel;
import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RememberMeFilter
 *
 * Runs on every request. If the user has no active session but has a
 * "spra_user" cookie (set at login with Remember Me checked), the filter
 * re-creates the session automatically — giving the "stay logged in" effect.
 *
 * Place this file at: src/main/java/com/spra/filter/RememberMeFilter.java
 *
 * @author Spra Team
 */
@WebFilter(urlPatterns = {"/*"}, asyncSupported = true)
public class RememberMeFilter implements Filter {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void doFilter(ServletRequest servletReq, ServletResponse servletRes,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  servletReq;
        HttpServletResponse res = (HttpServletResponse) servletRes;

        // Only act if the user is NOT already logged in
        if (SessionUtil.getLoggedInUser(req) == null) {

            String rememberedUsername = CookieUtil.getCookie(req, "spra_user");

            if (rememberedUsername != null && !rememberedUsername.isBlank()) {
                // Look up the user and silently log them in
                UserModel user = userDAO.getUserByUsername(rememberedUsername);
                if (user != null && user.isActive()) {
                    SessionUtil.loginUser(req, user);
                }
            }
        }

        chain.doFilter(req, res);
    }
}