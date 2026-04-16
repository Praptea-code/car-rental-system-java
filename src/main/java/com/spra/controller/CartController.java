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
 * CartController
 * Handles all cart actions: add, remove, update, view, clear.
 *
 * URL patterns:
 *   GET  /cart          — view cart page
 *   POST /cart/add      — add product (productId, qty)
 *   POST /cart/remove   — remove product (productId)
 *   POST /cart/update   — update quantity (productId, qty)
 *   POST /cart/clear    — empty the cart
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {
        "/cart",
        "/cart/add",
        "/cart/remove",
        "/cart/update",
        "/cart/clear"
}, asyncSupported = true)
public class CartController extends HttpServlet {

    private static final String SESSION_CART = "cart";
    private final ProductDAO productDAO = new ProductDAO();

    // ---- GET: show cart page ----

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/cart.jsp").forward(req, res);
    }

    // ---- POST: dispatch to action ----

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/add"))    { handleAdd(req, res);    return; }
        if (uri.endsWith("/remove")) { handleRemove(req, res); return; }
        if (uri.endsWith("/update")) { handleUpdate(req, res); return; }
        if (uri.endsWith("/clear"))  { handleClear(req, res);  return; }

        res.sendRedirect(req.getContextPath() + "/cart");
    }

    // ---- Private helpers ----

    private void handleAdd(HttpServletRequest req, HttpServletResponse res) throws IOException {
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

        // Redirect back to where the user came from, or to cart
        String referer = req.getHeader("Referer");
        res.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int productId = parseInt(req.getParameter("productId"), -1);
        if (productId > 0) getOrCreateCart(req).removeItem(productId);
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse res) throws IOException {
        int productId = parseInt(req.getParameter("productId"), -1);
        int qty       = parseInt(req.getParameter("qty"), 0);
        if (productId > 0) getOrCreateCart(req).updateQuantity(productId, qty);
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleClear(HttpServletRequest req, HttpServletResponse res) throws IOException {
        getOrCreateCart(req).clear();
        res.sendRedirect(req.getContextPath() + "/cart");
    }

    /** Returns the cart from session, creating it if absent. */
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
        try { return Integer.parseInt(ValidationUtil.safeTrim(value)); }
        catch (NumberFormatException e) { return fallback; }
    }
}