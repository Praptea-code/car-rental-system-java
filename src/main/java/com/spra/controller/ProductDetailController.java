package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.OrderDAO;
import com.spra.dao.ProductDAO;
import com.spra.dao.ReviewDAO;
import com.spra.dao.WishlistDAO;
import com.spra.model.CartModel;
import com.spra.model.CategoryModel;
import com.spra.model.ProductModel;
import com.spra.model.ReviewModel;
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
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/productDetail"}, asyncSupported = true)
public class ProductDetailController extends HttpServlet {

    private final ProductDAO  productDAO  = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewDAO   reviewDAO   = new ReviewDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final OrderDAO    orderDAO    = new OrderDAO();

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
        int[]             ratingDist  = reviewDAO.getRatingDistribution(productId);

        // Current user info
        UserModel currentUser    = SessionUtil.getLoggedInUser(req);
        boolean   alreadyReviewed = false;
        boolean   isWishlisted    = false;
        // canReview = user has a SHIPPED or DELIVERED order containing this product
        boolean   canReview       = false;

        if (currentUser != null) {
            alreadyReviewed = reviewDAO.hasUserReviewed(productId, currentUser.getUserId());
            isWishlisted    = wishlistDAO.isWishlisted(currentUser.getUserId(), productId);
            canReview       = orderDAO.hasUserReceivedProduct(currentUser.getUserId(), productId);
        }

        // Cart for nav badge
        CartModel cart = (CartModel) req.getSession(true).getAttribute("cart");
        if (cart == null) {
            cart = new CartModel();
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
        req.setAttribute("isWishlisted",    isWishlisted);
        req.setAttribute("currentUser",     currentUser);
        req.setAttribute("cart",            cart);
        req.setAttribute("canReview",       canReview);   // NEW

        req.getRequestDispatcher("/WEB-INF/pages/productDetail.jsp").forward(req, res);
    }
}