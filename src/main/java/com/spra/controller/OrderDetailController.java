package com.spra.controller;

import com.spra.dao.OrderDAO;
import com.spra.model.OrderItemModel;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * OrderDetailController
 * Returns the items of a specific order as JSON.
 * Used by the order detail popup on both the user profile page and admin orders page.
 *
 * GET /order/items?orderId=X
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/order/items"}, asyncSupported = true)
public class OrderDetailController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Must be logged in
        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String idParam = ValidationUtil.safeTrim(req.getParameter("orderId"));
        int orderId;
        try {
            orderId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        List<OrderItemModel> items = orderDAO.getOrderItems(orderId);

        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");

        PrintWriter out = res.getWriter();
        out.print("[");
        for (int i = 0; i < items.size(); i++) {
            OrderItemModel item = items.get(i);
            if (i > 0) out.print(",");
            out.print("{");
            out.print("\"productId\":"    + item.getProductId()                          + ",");
            out.print("\"productName\":\"" + escapeJson(item.getProductName())   + "\",");
            out.print("\"categoryName\":\"" + escapeJson(item.getCategoryName()) + "\",");
            out.print("\"imagePath\":\""  + escapeJson(item.getImagePath())      + "\",");
            out.print("\"quantity\":"     + item.getQuantity()                           + ",");
            out.print("\"price\":"        + item.getPrice()                              + ",");
            out.print("\"subtotal\":"     + item.getSubtotal());
            out.print("}");
        }
        out.print("]");
        out.flush();
    }

    /** Minimal JSON string escaping. */
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}