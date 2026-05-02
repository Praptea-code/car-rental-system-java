package com.spra.controller;

import com.spra.dao.ReviewDAO;
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

/**
 * ReviewController
 * Handles POST /review/add — submits a product review.
 * Redirects back to the product detail page with a session message.
 *
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/review/add"}, asyncSupported = true)
public class ReviewController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Must be logged in
        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String productIdParam = ValidationUtil.safeTrim(req.getParameter("productId"));
        String ratingParam    = ValidationUtil.safeTrim(req.getParameter("rating"));
        String title          = ValidationUtil.safeTrim(req.getParameter("title"));
        String body           = ValidationUtil.safeTrim(req.getParameter("body"));

        // Basic validation
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingParam);
            if (rating < 1 || rating > 5) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("reviewError", "Please select a rating between 1 and 5.");
            res.sendRedirect(req.getContextPath() + "/productDetail?id=" + productId);
            return;
        }

        if (!ValidationUtil.isNotEmpty(body)) {
            req.getSession().setAttribute("reviewError", "Review body cannot be empty.");
            res.sendRedirect(req.getContextPath() + "/productDetail?id=" + productId);
            return;
        }

        // Duplicate check — one review per user per product
        if (reviewDAO.hasUserReviewed(productId, user.getUserId())) {
            req.getSession().setAttribute("reviewError", "You have already reviewed this product.");
            res.sendRedirect(req.getContextPath() + "/productDetail?id=" + productId);
            return;
        }

        ReviewModel review = new ReviewModel();
        review.setProductId(productId);
        review.setUserId(user.getUserId());
        review.setRating(rating);
        review.setTitle(title.isEmpty() ? null : title);
        review.setBody(body);

        int newId = reviewDAO.addReview(review);
        if (newId > 0) {
            req.getSession().setAttribute("reviewSuccess", "Your review has been posted. Thank you!");
        } else {
            req.getSession().setAttribute("reviewError", "Could not save your review. Please try again.");
        }

        res.sendRedirect(req.getContextPath() + "/productDetail?id=" + productId + "#tab-reviews");
    }
}