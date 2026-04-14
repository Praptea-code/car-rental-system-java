package com.spra.controller;

import com.spra.model.UserModel;
import com.spra.service.LoginService;
import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login"}, asyncSupported = true)
public class LoginController extends HttpServlet {

    private final LoginService loginService;

    public LoginController() {
        this.loginService = new LoginService();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = ValidationUtil.safeTrim(req.getParameter("username"));
        String password = ValidationUtil.safeTrim(req.getParameter("password"));

        if (!ValidationUtil.isNotEmpty(username) || !ValidationUtil.isNotEmpty(password)) {
            req.setAttribute("errorMessage", "Username and password are required.");
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward((ServletRequest) req, (ServletResponse) res);
            return;
        }

        int result = loginService.authenticate(username, password);
        if (result == 0) {
            UserModel user = loginService.getUserByUsername(username);
            SessionUtil.loginUser(req, user);
            CookieUtil.addCookie(res, "spra_user", user.getUsername(), 604800);
            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else {
                res.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            req.setAttribute("errorMessage", loginService.getErrorMessage(result));
            req.setAttribute("username", username);
            req.getRequestDispatcher("/WEB-INF/pages/auth/login.jsp").forward((ServletRequest) req, (ServletResponse) res);
        }
    }
}
