package com.spra.controller;

import com.spra.dao.WishlistDAO;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * WishlistController
 * Handles POST /wishlist/add and /wishlist/remove.
 * Always requires the user to be logged in — redirects to /login otherwise.
 * After the action, redirects back to the referring page (product detail, profile, etc.)
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {
        "/wishlist/add",
        "/wishlist/remove"
}, asyncSupported = true)
public class WishlistController extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Must be logged in
        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String productIdParam = ValidationUtil.safeTrim(req.getParameter("productId"));
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        String uri = req.getRequestURI();

        if (uri.endsWith("/add")) {
            boolean added = wishlistDAO.addToWishlist(user.getUserId(), productId);
            req.getSession().setAttribute("wishlistToast",
                    added ? "Added to your wishlist!" : "Already in your wishlist.");
        } else if (uri.endsWith("/remove")) {
            wishlistDAO.removeFromWishlist(user.getUserId(), productId);
        }

        // Redirect back to wherever the user came from
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            res.sendRedirect(referer);
        } else {
            res.sendRedirect(req.getContextPath() + "/user/profile");
        }
    }

    // Support GET as well (e.g. someone types the URL directly) — just redirect
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/user/profile");
    }
}