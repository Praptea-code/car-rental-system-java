package com.spra.controller;

import com.spra.model.UserModel;
import com.spra.service.LoginService;
import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * LoginController — updated with Remember Me support.
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/login"}, asyncSupported = true)
public class LoginController extends HttpServlet {

    private static final int REMEMBER_ME_SECONDS = 60 * 60 * 24 * 30; // 30 days
    private static final int SESSION_SECONDS     = 60 * 60 * 24 * 7;  // 7 days (existing)

    private final LoginService loginService = new LoginService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username   = ValidationUtil.safeTrim(req.getParameter("username"));
        String password   = ValidationUtil.safeTrim(req.getParameter("password"));
        boolean rememberMe = "on".equals(req.getParameter("rememberMe"));   // <-- new

        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            req.setAttribute("errorMessage", "Username and password are required.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(req, res);
            return;
        }

        int result = loginService.authenticate(username, password);

        if (result == 0) {
            UserModel user = loginService.getUserByUsername(username);
            SessionUtil.loginUser(req, user);
            req.getSession().setAttribute("showLoader", true);

            //  Remember Me logic 
            int cookieAge = rememberMe ? REMEMBER_ME_SECONDS : SESSION_SECONDS;
            CookieUtil.addCookie(res, "spra_user", user.getUsername(), cookieAge);
            
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                res.sendRedirect(req.getContextPath() + "/home");
            }

        } else {
            req.setAttribute("errorMessage", loginService.getErrorMessage(result));
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward(req, res);
        }
    }
}