package com.spra.controller;

import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/logout"}, asyncSupported = true)
public class LogoutController extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        SessionUtil.logout(req);
        CookieUtil.deleteCookie(res, "spra_user");
        res.sendRedirect(req.getContextPath() + "/home");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        doPost(req, res);
    }
}
