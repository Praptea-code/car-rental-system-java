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

@WebServlet(urlPatterns = {"/productDetail"}, asyncSupported = true)
public class ProductDetailController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String idParam = ValidationUtil.safeTrim(req.getParameter("id"));

        if (idParam == null || idParam.isEmpty()) {
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

        List<ProductModel> relatedProducts = List.of();

        if (product.getCategoryId() > 0) {
            relatedProducts = productDAO.getByCategory(product.getCategoryId())
                    .stream()
                    .filter(p -> p.getProductId() != productId)
                    .limit(4)
                    .collect(Collectors.toList());
        }

        req.setAttribute("product", product);
        req.setAttribute("relatedProducts", relatedProducts);
        req.setAttribute("categories", categoryDAO.getAllCategories());

        req.getRequestDispatcher("/WEB-INF/pages/productDetail.jsp")
           .forward(req, res);
    }
}