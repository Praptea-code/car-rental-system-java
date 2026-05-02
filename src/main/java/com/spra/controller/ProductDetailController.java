package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.ProductDAO;
import com.spra.model.CategoryModel;
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
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/product"}, asyncSupported = true)
public class ProductDetailController extends HttpServlet {

    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;

    public ProductDetailController() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = ValidationUtil.safeTrim(req.getParameter("id"));

        if (idParam.isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        ProductModel product = productDAO.getProductById(productId);

        if (product == null) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        // Fetch related products: same category, excluding current product, limit 4
        List<ProductModel> allProducts = product.getCategoryId() > 0
                ? productDAO.getByCategory(product.getCategoryId())
                : productDAO.getAllProducts();

        List<ProductModel> relatedProducts = allProducts.stream()
                .filter(p -> p.getProductId() != productId)
                .limit(4)
                .collect(Collectors.toList());

        // Fetch all categories for potential sidebar/navigation use
        List<CategoryModel> categories = categoryDAO.getAllCategories();

        req.setAttribute("product", product);
        req.setAttribute("relatedProducts", relatedProducts);
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("/WEB-INF/pages/product-detail.jsp")
           .forward((ServletRequest) req, (ServletResponse) res);
    }
}