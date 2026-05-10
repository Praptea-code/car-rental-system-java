package com.spra.filter;

import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * AuthFilter — protects every URL under /admin/*
 *
 * REGISTERED IN web.xml ONLY.
 * The @WebFilter annotation has been intentionally removed.
 * If @WebFilter is present alongside a web.xml declaration, Tomcat
 * registers the filter twice with undefined ordering, which breaks
 * the RememberMeFilter → AuthFilter execution sequence.
 */
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest servletReq,
                         ServletResponse servletRes,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  servletReq;
        HttpServletResponse res = (HttpServletResponse) servletRes;

        // Prevent browser from serving cached admin pages after logout
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma",        "no-cache");
        res.setDateHeader("Expires",   0);

        UserModel user = SessionUtil.getLoggedInUser(req);

        // Case 1: no session at all
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Case 2: logged in but not an admin
        if (user.getRole() == null || !user.getRole().equalsIgnoreCase("ADMIN")) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Case 3: verified admin — allow through
        chain.doFilter(req, res);
    }
}