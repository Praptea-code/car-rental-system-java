package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.ProductDAO;
import com.spra.dao.ReviewDAO;
import com.spra.model.CategoryModel;
import com.spra.model.ProductModel;
import com.spra.model.ReviewModel;
import com.spra.model.UserModel;
import com.spra.util.SessionUtil;
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

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO   reviewDAO   = new ReviewDAO();

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

        // Related products (same category, excluding current)
        List<ProductModel> relatedProducts = List.of();
        if (product.getCategoryId() > 0) {
            relatedProducts = productDAO.getByCategory(product.getCategoryId())
                    .stream()
                    .filter(p -> p.getProductId() != productId)
                    .limit(4)
                    .collect(Collectors.toList());
        }

        // Reviews
        List<ReviewModel> reviews    = reviewDAO.getReviewsByProduct(productId);
        double            avgRating  = reviewDAO.getAverageRating(productId);
        int               reviewCount = reviewDAO.getReviewCount(productId);
        int[]             ratingDist = reviewDAO.getRatingDistribution(productId);

        // Has the logged-in user already reviewed this product?
        UserModel currentUser = SessionUtil.getLoggedInUser(req);
        boolean   alreadyReviewed = false;
        if (currentUser != null) {
            alreadyReviewed = reviewDAO.hasUserReviewed(productId, currentUser.getUserId());
        }

        // Cart for nav badge
        com.spra.model.CartModel cart =
            (com.spra.model.CartModel) req.getSession(true).getAttribute("cart");
        if (cart == null) {
            cart = new com.spra.model.CartModel();
            req.getSession().setAttribute("cart", cart);
        }

        // Set attributes
        req.setAttribute("product",         product);
        req.setAttribute("relatedProducts", relatedProducts);
        req.setAttribute("categories",      categoryDAO.getAllCategories());
        req.setAttribute("reviews",         reviews);
        req.setAttribute("avgRating",       avgRating);
        req.setAttribute("reviewCount",     reviewCount);
        req.setAttribute("ratingDist",      ratingDist);
        req.setAttribute("alreadyReviewed", alreadyReviewed);
        req.setAttribute("currentUser",     currentUser);
        req.setAttribute("cart",            cart);

        req.getRequestDispatcher("/WEB-INF/pages/productDetail.jsp")
           .forward(req, res);
    }
}