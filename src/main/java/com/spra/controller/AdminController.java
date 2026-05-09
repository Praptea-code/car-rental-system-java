package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.ContactDAO;
import com.spra.dao.OrderDAO;
import com.spra.dao.ProductDAO;
import com.spra.dao.UserDAO;
import com.spra.model.CategoryModel;
import com.spra.model.ContactModel;
import com.spra.model.OrderModel;
import com.spra.model.ProductModel;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/admin/dashboard",
        "/admin/products",
        "/admin/products/add",
        "/admin/products/edit",
        "/admin/products/delete",
        "/admin/users",
        "/admin/messages",
        "/admin/orders"
}, asyncSupported = true)
public class AdminController extends HttpServlet {

    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;
    private final UserDAO userDAO;
    private final ContactDAO contactDAO;
    private final OrderDAO orderDAO;

    public AdminController() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
        this.userDAO = new UserDAO();
        this.contactDAO = new ContactDAO();
        this.orderDAO = new OrderDAO();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/dashboard")) {
            showDashboard(req, res);
        } else if (uri.endsWith("/products")) {
            showProducts(req, res);
        } else if (uri.endsWith("/users")) {
            showUsers(req, res);
        } else if (uri.endsWith("/messages")) {
            showMessages(req, res);
        } else if (uri.endsWith("/orders")) {
            showOrders(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/add")) {
            handleAddProduct(req, res);
        } else if (uri.endsWith("/edit")) {
            handleEditProduct(req, res);
        } else if (uri.endsWith("/delete")) {
            handleDeleteProduct(req, res);
        } else {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<OrderModel> allOrders = orderDAO.getAllOrders();
        req.setAttribute("totalProducts", productDAO.getAllProducts().size());
        req.setAttribute("totalCategories", categoryDAO.getAllCategories().size());
        req.setAttribute("recentMessages", contactDAO.getAllMessages());
        req.setAttribute("totalOrders", allOrders.size());
        // Pass the full list — dashboard JSP slices to first 5 with begin="0" end="4"
        req.setAttribute("recentOrders", allOrders);
        req.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void showProducts(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ProductModel> products = productDAO.getAllProducts();
        List<CategoryModel> categories = categoryDAO.getAllCategories();
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/pages/admin/products.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void showUsers(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/admin/users.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void showMessages(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ContactModel> messages = contactDAO.getAllMessages();
        req.setAttribute("messages", messages);
        req.getRequestDispatcher("/WEB-INF/pages/admin/messages.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void showOrders(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<OrderModel> orders = orderDAO.getAllOrders();
        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/WEB-INF/pages/admin/orders.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void handleAddProduct(HttpServletRequest req, HttpServletResponse res) throws IOException {
        ProductModel p = extractProductFromRequest(req);
        int newId = productDAO.addProduct(p);
        if (newId > 0) {
            req.getSession().setAttribute("successMessage", "Product added successfully.");
        } else {
            req.getSession().setAttribute("errorMessage", "Failed to add product.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void handleEditProduct(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String idParam = ValidationUtil.safeTrim(req.getParameter("productId"));
        try {
            int productId = Integer.parseInt(idParam);
            ProductModel p = extractProductFromRequest(req);
            p.setProductId(productId);
            boolean updated = productDAO.updateProduct(p);
            req.getSession().setAttribute(
                    updated ? "successMessage" : "errorMessage",
                    updated ? "Product updated successfully." : "Failed to update product."
            );
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "Invalid product ID.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void handleDeleteProduct(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String idParam = ValidationUtil.safeTrim(req.getParameter("productId"));
        try {
            int productId = Integer.parseInt(idParam);
            boolean deleted = productDAO.deleteProduct(productId);
            req.getSession().setAttribute(deleted ? "successMessage" : "errorMessage",
            		deleted ? "Product deleted." : "Failed to delete product."
            );
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("errorMessage", "Invalid product ID.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private ProductModel extractProductFromRequest(HttpServletRequest req) {
        ProductModel p = new ProductModel();
        p.setName(ValidationUtil.safeTrim(req.getParameter("name")));
        p.setDescription(ValidationUtil.safeTrim(req.getParameter("description")));
        p.setImagePath(ValidationUtil.safeTrim(req.getParameter("imagePath")));
        try { p.setPrice(Double.parseDouble(req.getParameter("price"))); } catch (NumberFormatException e) { p.setPrice(0.0); }
        try { p.setOldPrice(Double.parseDouble(req.getParameter("oldPrice"))); } catch (NumberFormatException e) { p.setOldPrice(0.0); }
        try { p.setStock(Integer.parseInt(req.getParameter("stock"))); } catch (NumberFormatException e) { p.setStock(0); }
        try { p.setCategoryId(Integer.parseInt(req.getParameter("categoryId"))); } catch (NumberFormatException e) { p.setCategoryId(0); }
        p.setFeatured("on".equals(req.getParameter("isFeatured")));
        p.setBestseller("on".equals(req.getParameter("isBestseller")));
        return p;
    }
}
