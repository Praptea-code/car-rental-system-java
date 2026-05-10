package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.ProductDAO;
import com.spra.model.CategoryModel;
import com.spra.model.ProductModel;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/products"}, asyncSupported = true)
public class ProductController extends HttpServlet {

    private static final int PAGE_SIZE = 12;

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String keyword    = ValidationUtil.safeTrim(req.getParameter("search"));
        String categoryId = ValidationUtil.safeTrim(req.getParameter("category"));
        String priceRange = ValidationUtil.safeTrim(req.getParameter("price"));
        String sortBy     = ValidationUtil.safeTrim(req.getParameter("sort"));
        String pageParam  = ValidationUtil.safeTrim(req.getParameter("page"));

        // 1. BASE PRODUCT SELECTION 
        List<ProductModel> products;

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

        //  2. PRICE FILTER 
        if (!priceRange.isEmpty()) {
            switch (priceRange) {
                case "under2500":
                    products = products.stream()
                            .filter(p -> p.getPrice() < 2500).toList();
                    break;
                case "2500to4000":
                    products = products.stream()
                            .filter(p -> p.getPrice() >= 2500 && p.getPrice() <= 4000).toList();
                    break;
                case "4000to6000":
                    products = products.stream()
                            .filter(p -> p.getPrice() >= 4000 && p.getPrice() <= 6000).toList();
                    break;
                case "over6000":
                    products = products.stream()
                            .filter(p -> p.getPrice() > 6000).toList();
                    break;
                default:
                    break;
            }
        }

        //  3. SORT 
        if (!sortBy.isEmpty()) {
            switch (sortBy) {
                case "price-asc":
                    products = products.stream()
                            .sorted((a, b) -> Double.compare(a.getPrice(), b.getPrice())).toList();
                    break;
                case "price-desc":
                    products = products.stream()
                            .sorted((a, b) -> Double.compare(b.getPrice(), a.getPrice())).toList();
                    break;
                case "name-asc":
                    products = products.stream()
                            .sorted((a, b) -> a.getName().compareToIgnoreCase(b.getName())).toList();
                    break;
                default:
                    break;
            }
        }

        // 4. PAGINATION 
        int totalCount  = products.size();
        int totalPages  = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        int currentPage;
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages && totalPages > 0) currentPage = totalPages;
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        int fromIndex = (currentPage - 1) * PAGE_SIZE;
        int toIndex   = Math.min(fromIndex + PAGE_SIZE, totalCount);

        List<ProductModel> pagedProducts = (fromIndex < totalCount)
                ? products.subList(fromIndex, toIndex)
                : List.of();

        // 5. CATEGORIES LIST 
        List<CategoryModel> categories = categoryDAO.getAllCategories();

        // 6. SET ATTRIBUTES 
        req.setAttribute("products",     pagedProducts);
        req.setAttribute("categories",   categories);
        req.setAttribute("keyword",      keyword);
        req.setAttribute("categoryId",   categoryId);
        req.setAttribute("priceRange",   priceRange);
        req.setAttribute("sortBy",       sortBy);
        req.setAttribute("totalCount",   totalCount);
        req.setAttribute("totalPages",   totalPages);
        req.setAttribute("currentPage",  currentPage);

        req.getRequestDispatcher("/WEB-INF/pages/products.jsp").forward(req, res);
    }
}