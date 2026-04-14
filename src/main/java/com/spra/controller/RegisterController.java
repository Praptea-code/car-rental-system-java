package com.spra.controller;

import com.spra.service.RegisterService;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/register"}, asyncSupported = true)
public class RegisterController extends HttpServlet {

    private final RegisterService registerService;

    public RegisterController() {
        this.registerService = new RegisterService();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/auth/register.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String firstName  = ValidationUtil.safeTrim(req.getParameter("firstName"));
        String lastName   = ValidationUtil.safeTrim(req.getParameter("lastName"));
        String username   = ValidationUtil.safeTrim(req.getParameter("username"));
        String email      = ValidationUtil.safeTrim(req.getParameter("email"));
        String phone      = ValidationUtil.safeTrim(req.getParameter("phone"));
        String birthdate  = ValidationUtil.safeTrim(req.getParameter("birthdate"));
        String password   = ValidationUtil.safeTrim(req.getParameter("password"));
        String retypePass = ValidationUtil.safeTrim(req.getParameter("retypePassword"));

        String errorMsg = registerService.validate(firstName, lastName, username, email, phone, birthdate, password, retypePass);
        if (errorMsg != null) {
            req.setAttribute("errorMessage", errorMsg);
            req.setAttribute("firstName", firstName);
            req.setAttribute("lastName", lastName);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.setAttribute("phone", phone);
            req.setAttribute("birthdate", birthdate);
            req.getRequestDispatcher("/WEB-INF/pages/auth/register.jsp").forward((ServletRequest) req, (ServletResponse) res);
            return;
        }

        boolean success = registerService.registerUser(firstName, lastName, username, email, phone, birthdate, password);
        if (success) {
            req.getSession(true).setAttribute("successMessage", "Account created successfully! Please log in.");
            res.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("errorMessage", "Registration failed due to a server error. Please try again.");
            req.getRequestDispatcher("/WEB-INF/pages/auth/register.jsp").forward((ServletRequest) req, (ServletResponse) res);
        }
    }
}
