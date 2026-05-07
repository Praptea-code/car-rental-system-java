package com.spra.controller;

import com.spra.dao.WishlistDAO;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(urlPatterns = {
        "/wishlist/add",
        "/wishlist/remove"
})
public class WishlistController extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UserModel currentUser = SessionUtil.getLoggedInUser(req);

        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String productIdParam = req.getParameter("productId");

        if (productIdParam == null || productIdParam.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int productId;

        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        String path = req.getServletPath();

        if (path.equals("/wishlist/add")) {

            wishlistDAO.addToWishlist(
                    currentUser.getUserId(),
                    productId
            );

            req.getSession().setAttribute(
                    "wishlistToast",
                    "Product added to wishlist!"
            );

        } else if (path.equals("/wishlist/remove")) {

            wishlistDAO.removeFromWishlist(
                    currentUser.getUserId(),
                    productId
            );

            req.getSession().setAttribute(
                    "wishlistToast",
                    "Product removed from wishlist!"
            );
        }

        res.sendRedirect(
                req.getContextPath() +
                "/productDetail?id=" + productId
        );
    }
}