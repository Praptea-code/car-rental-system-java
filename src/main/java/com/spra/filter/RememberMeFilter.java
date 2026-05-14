package com.spra.filter;

import com.spra.dao.UserDAO;
import com.spra.model.UserModel;
import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * RememberMeFilter — runs on every request, restores session from cookie.
 *
 */
public class RememberMeFilter implements Filter {

    private final UserDAO userDAO = new UserDAO();

    @Override
    public void doFilter(ServletRequest servletReq,
                         ServletResponse servletRes,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  servletReq;
        HttpServletResponse res = (HttpServletResponse) servletRes;

        // Only attempt cookie restore when there is no active session
        if (SessionUtil.getLoggedInUser(req) == null) {
            String rememberedUsername = CookieUtil.getCookie(req, "spra_user");

            if (rememberedUsername != null && !rememberedUsername.isBlank()) {
                UserModel user = userDAO.getUserByUsername(rememberedUsername);
                // Only restore if account is active
                if (user != null && user.isActive()) {
                    SessionUtil.loginUser(req, user);
                }
            }
        }

        chain.doFilter(req, res);
    }
}