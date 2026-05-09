package com.spra.filter;

import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"}, asyncSupported = true)
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletReq, ServletResponse servletRes,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  servletReq;
        HttpServletResponse res = (HttpServletResponse) servletRes;

        UserModel user = SessionUtil.getLoggedInUser(req);

        // Not logged in at all → send to login
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Logged in but not ADMIN → send to home
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // All good — proceed
        chain.doFilter(req, res);
    }
}