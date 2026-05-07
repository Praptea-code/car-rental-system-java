package com.spra.controller;

import com.spra.dao.OrderDAO;
import com.spra.model.CartItem;
import com.spra.model.CartModel;
import com.spra.model.OrderModel;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/order/place", "/order/status"}, asyncSupported = true)
public class OrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/place")) {
            handlePlaceOrder(req, res);
        } else if (uri.endsWith("/status")) {
            handleUpdateStatus(req, res);
        }
    }

    private void handlePlaceOrder(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        CartModel cart = (CartModel) req.getSession().getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String fullName = ValidationUtil.safeTrim(req.getParameter("fullName"));
        String phone    = ValidationUtil.safeTrim(req.getParameter("phone"));
        String address  = ValidationUtil.safeTrim(req.getParameter("address"));
        String city     = ValidationUtil.safeTrim(req.getParameter("city"));

        if (fullName.isEmpty() || phone.isEmpty() || address.isEmpty() || city.isEmpty()) {
            req.getSession().setAttribute("errorMessage", "Please fill all delivery details.");
            res.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Snapshot the cart items BEFORE clearing the cart
        List<CartItem> itemsToSave = new java.util.ArrayList<>(cart.getItems());

        OrderModel order = new OrderModel();
        order.setUserId(user.getUserId());
        order.setFullName(fullName);
        order.setPhone(phone);
        order.setAddress(address);
        order.setCity(city);
        order.setTotalAmount(cart.getGrandTotal());

        int orderId = orderDAO.placeOrder(order);

        if (orderId > 0) {
            // Save order items using the snapshot — cart is still intact here
            boolean itemsSaved = orderDAO.saveOrderItems(orderId, itemsToSave);

            if (!itemsSaved) {
                // Log the failure — stock decrement won't work without items
                System.err.println("[OrderController] WARNING: saveOrderItems failed for orderId=" + orderId
                        + ". Stock decrement will not work when this order is shipped.");
            }

            // Now safe to clear the cart
            cart.clear();
            req.getSession().setAttribute("cart", cart);
            req.getSession().setAttribute("orderSuccess", true);
            req.getSession().setAttribute("orderId", orderId);
        } else {
            req.getSession().setAttribute("errorMessage", "Failed to place order. Please try again.");
        }

        res.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleUpdateStatus(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String idParam = ValidationUtil.safeTrim(req.getParameter("orderId"));
        String status  = ValidationUtil.safeTrim(req.getParameter("status"));

        try {
            int orderId = Integer.parseInt(idParam);
            boolean updated = orderDAO.updateStatus(orderId, status);
            req.getSession().setAttribute(
                updated ? "successMessage" : "errorMessage",
                updated ? "Order status updated." : "Failed to update status."
            );
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "Invalid order ID.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/orders");
    }
}