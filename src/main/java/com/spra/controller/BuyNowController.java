package com.spra.controller;

import com.spra.dao.ProductDAO;
import com.spra.model.CartItem;
import com.spra.model.CartModel;
import com.spra.model.ProductModel;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * BuyNowController
 * Adds an item to the cart (same as CartController /cart/add)
 * then immediately redirects to /cart so the user can checkout.
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/buy-now"}, asyncSupported = true)
public class BuyNowController extends HttpServlet {

    private static final String SESSION_CART = "cart";
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int productId = parseInt(req.getParameter("productId"), -1);
        int qty       = Math.max(1, parseInt(req.getParameter("qty"), 1));

        if (productId > 0) {
            ProductModel product = productDAO.getProductById(productId);
            if (product != null && !product.isOutOfStock()) {
                CartItem item = new CartItem(
                        product.getProductId(),
                        product.getName(),
                        product.getPrice(),
                        product.getImagePath(),
                        product.getCategoryName(),
                        qty
                );
                getOrCreateCart(req).addItem(item);
            }
        }

        // Always redirect to cart (checkout) page
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private CartModel getOrCreateCart(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        CartModel cart = (CartModel) session.getAttribute(SESSION_CART);
        if (cart == null) {
            cart = new CartModel();
            session.setAttribute(SESSION_CART, cart);
        }
        return cart;
    }

    private int parseInt(String value, int fallback) {
        try {
            return Integer.parseInt(ValidationUtil.safeTrim(value));
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}