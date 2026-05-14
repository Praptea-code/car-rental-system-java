package com.spra.controller;

import com.spra.dao.ProductDAO;
import com.spra.dao.WishlistDAO;
import com.spra.model.ProductModel;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/wishlist/add", "/wishlist/remove"})
public class WishlistController extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final ProductDAO  productDAO  = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
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
            productId = Integer.parseInt(productIdParam.trim());
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        String uri = req.getRequestURI();

        // Fetch product details for the toast
        ProductModel product = productDAO.getProductById(productId);
        String productName  = (product != null) ? product.getName()      : "";
        String productImage = (product != null) ? product.getImagePath() : "";

        if (uri.endsWith("/add")) {
            wishlistDAO.addToWishlist(user.getUserId(), productId);
            req.getSession().setAttribute("wishlistToast",       "added");
            req.getSession().setAttribute("wishlistToastName",   productName);
            req.getSession().setAttribute("wishlistToastImage",  productImage);
        } else if (uri.endsWith("/remove")) {
            wishlistDAO.removeFromWishlist(user.getUserId(), productId);
            req.getSession().setAttribute("wishlistToast",       "removed");
            req.getSession().setAttribute("wishlistToastName",   productName);
            req.getSession().setAttribute("wishlistToastImage",  productImage);
        }

        String referer = req.getHeader("Referer");
        res.sendRedirect(referer != null && !referer.isEmpty()
                ? referer
                : req.getContextPath() + "/productDetail?id=" + productId);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/user/profile");
    }
}