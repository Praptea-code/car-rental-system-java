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

@WebServlet(urlPatterns = {"/products"}, asyncSupported = true)
public class ProductController extends HttpServlet {

    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;

    public ProductController() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword = ValidationUtil.safeTrim(req.getParameter("search"));
        String categoryId = ValidationUtil.safeTrim(req.getParameter("category"));
        String priceRange = ValidationUtil.safeTrim(req.getParameter("price"));

        List<ProductModel> products;

        // 1. BASE PRODUCT SELECTION
        if (!keyword.isEmpty()) {
            products = productDAO.searchProducts(keyword);

        } else if (!categoryId.isEmpty()) {
            try {
                products = productDAO.getByCategory(Integer.parseInt(categoryId));
            } catch (NumberFormatException e) {
                products = productDAO.getAllProducts();
            }

        } else {
            products = productDAO.getAllProducts();
        }

        // 2. PRICE FILTER (THIS WAS MISSING)
        if (!priceRange.isEmpty()) {

            switch (priceRange) {

                case "under2500":
                    products = products.stream()
                            .filter(p -> p.getPrice() < 2500)
                            .toList();
                    break;

                case "2500to4000":
                    products = products.stream()
                            .filter(p -> p.getPrice() >= 2500 && p.getPrice() <= 4000)
                            .toList();
                    break;

                case "4000to6000":
                    products = products.stream()
                            .filter(p -> p.getPrice() >= 4000 && p.getPrice() <= 6000)
                            .toList();
                    break;

                case "over6000":
                    products = products.stream()
                            .filter(p -> p.getPrice() > 6000)
                            .toList();
                    break;
            }
        }

        // 3. CATEGORY LIST
        List<CategoryModel> categories = categoryDAO.getAllCategories();

        // 4. SET ATTRIBUTES
        req.setAttribute("products", products);
        req.setAttribute("categories", categories);
        req.setAttribute("keyword", keyword);
        req.setAttribute("categoryId", categoryId);
        req.setAttribute("priceRange", priceRange);
        req.setAttribute("totalCount", products.size());

        // 5. FORWARD
        req.getRequestDispatcher("/WEB-INF/pages/products.jsp")
           .forward(req, res);
    }
    
}
