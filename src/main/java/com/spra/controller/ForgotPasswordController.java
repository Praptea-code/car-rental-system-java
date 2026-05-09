package com.spra.controller;

import com.spra.dao.PasswordResetDAO;
import com.spra.dao.UserDAO;
import com.spra.model.UserModel;
import com.spra.util.EmailUtil;
import com.spra.util.PasswordUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * ForgotPasswordController
 *
 * GET  /forgot-password          → show "enter your email" form
 * POST /forgot-password          → send reset email
 * GET  /reset-password?token=X   → show "enter new password" form
 * POST /reset-password           → save new password
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/forgot-password", "/reset-password"}, asyncSupported = true)
public class ForgotPasswordController extends HttpServlet {

    private final UserDAO            userDAO  = new UserDAO();
    private final PasswordResetDAO   tokenDAO = new PasswordResetDAO();

    // ── GET ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/forgot-password")) {
            // Show the "forgot password" email form
            req.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp")
               .forward(req, res);

        } else if (uri.endsWith("/reset-password")) {
            // Validate the token before showing the reset form
            String token = ValidationUtil.safeTrim(req.getParameter("token"));

            if (token.isEmpty() || tokenDAO.validateToken(token) < 0) {
                req.setAttribute("errorMessage",
                    "This password reset link is invalid or has expired. Please request a new one.");
                req.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp")
                   .forward(req, res);
                return;
            }

            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp")
               .forward(req, res);
        }
    }

    // ── POST ──────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/forgot-password")) {
            handleForgotPassword(req, res);
        } else if (uri.endsWith("/reset-password")) {
            handleResetPassword(req, res);
        }
    }

    // ── Forgot password: send email ───────────────────────────
    private void handleForgotPassword(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = ValidationUtil.safeTrim(req.getParameter("email"));

        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid email address.");
            req.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp")
               .forward(req, res);
            return;
        }

        // Always show success message — never reveal whether the email exists
        req.setAttribute("successMessage",
            "If an account with that email exists, a reset link has been sent. Check your inbox (and spam folder).");

        UserModel user = userDAO.getUserByEmail(email);
        if (user != null) {
            String token = tokenDAO.createToken(user.getUserId());
            if (token != null) {
                // Build the full reset URL
                String baseUrl   = req.getScheme() + "://" + req.getServerName()
                                 + ":" + req.getServerPort()
                                 + req.getContextPath();
                String resetLink = baseUrl + "/reset-password?token=" + token;

                try {
                    EmailUtil.sendPasswordResetEmail(email, user.getFirstName(), resetLink);
                } catch (Exception e) {
                    // Log but don't expose to user
                    System.err.println("[ForgotPasswordController] Email send failed: " + e.getMessage());
                }
            }
        }

        req.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp")
           .forward(req, res);
    }

    // ── Reset password: save new password ────────────────────
    private void handleResetPassword(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String token       = ValidationUtil.safeTrim(req.getParameter("token"));
        String newPass     = ValidationUtil.safeTrim(req.getParameter("newPassword"));
        String confirmPass = ValidationUtil.safeTrim(req.getParameter("confirmPassword"));

        // Re-validate token on POST (prevents tampered requests)
        int userId = tokenDAO.validateToken(token);
        if (userId < 0) {
            req.setAttribute("errorMessage",
                "This reset link is invalid or has expired. Please request a new one.");
            req.getRequestDispatcher("/WEB-INF/pages/auth/forgot-password.jsp")
               .forward(req, res);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPass)) {
            req.setAttribute("errorMessage",
                "Password must be more than 6 characters and include at least one uppercase letter, one digit, and one special character.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp")
               .forward(req, res);
            return;
        }

        if (!newPass.equals(confirmPass)) {
            req.setAttribute("errorMessage", "Passwords do not match.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp")
               .forward(req, res);
            return;
        }

        // Save hashed password
        String hashed  = PasswordUtil.hashPassword(newPass);
        boolean updated = userDAO.updatePassword(userId, hashed);

        if (updated) {
            tokenDAO.markUsed(token);
            req.getSession(true).setAttribute("successMessage",
                "Your password has been reset successfully. Please log in.");
            res.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("errorMessage", "Password reset failed. Please try again.");
            req.setAttribute("token", token);
            req.getRequestDispatcher("/WEB-INF/pages/auth/reset-password.jsp")
               .forward(req, res);
        }
    }
}