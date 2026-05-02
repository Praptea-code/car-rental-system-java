package com.spra.controller;

import com.spra.dao.UserDAO;
import com.spra.dao.WishlistDAO;
import com.spra.model.CartModel;
import com.spra.model.UserModel;
import com.spra.model.WishlistModel;
import com.spra.util.PasswordUtil;
import com.spra.util.SessionUtil;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/user/profile"}, asyncSupported = true)
public class ProfileController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UserModel user = SessionUtil.getLoggedInUser(req);
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        HttpSession session = req.getSession(true);

        // Cart
        CartModel cart = (CartModel) session.getAttribute("cart");
        if (cart == null) {
            cart = new CartModel();
            session.setAttribute("cart", cart);
        }

        // Wishlist
        List<WishlistModel> wishlist = wishlistDAO.getWishlistByUser(user.getUserId());
        int wishlistCount = wishlist.size();

        req.setAttribute("currentUser",   user);
        req.setAttribute("cart",          cart);
        req.setAttribute("wishlist",      wishlist);
        req.setAttribute("wishlistCount", wishlistCount);

        req.getRequestDispatcher("/WEB-INF/pages/user/profile.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        UserModel currentUser = SessionUtil.getLoggedInUser(req);
        if (currentUser == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = ValidationUtil.safeTrim(req.getParameter("action"));

        if ("updateProfile".equals(action)) {
            handleProfileUpdate(req, res, currentUser);
        } else if ("changePassword".equals(action)) {
            handlePasswordChange(req, res, currentUser);
        } else {
            res.sendRedirect(req.getContextPath() + "/user/profile");
        }
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse res,
                                     UserModel currentUser)
            throws ServletException, IOException {

        String firstName = ValidationUtil.safeTrim(req.getParameter("firstName"));
        String lastName  = ValidationUtil.safeTrim(req.getParameter("lastName"));
        String email     = ValidationUtil.safeTrim(req.getParameter("email"));
        String phone     = ValidationUtil.safeTrim(req.getParameter("phone"));

        if (!ValidationUtil.isValidName(firstName) || !ValidationUtil.isValidName(lastName)) {
            req.setAttribute("errorMessage", "Names must contain only letters and spaces.");
            doGet(req, res);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid email address.");
            doGet(req, res);
            return;
        }

        currentUser.setFirstName(firstName);
        currentUser.setLastName(lastName);
        currentUser.setEmail(email);
        currentUser.setPhone(phone);

        boolean updated = userDAO.updateProfile(currentUser);
        if (updated) {
            req.getSession().setAttribute("loggedInUser", currentUser);
            req.setAttribute("successMessage", "Profile updated successfully.");
        } else {
            req.setAttribute("errorMessage", "Could not update profile. Please try again.");
        }
        doGet(req, res);
    }

    private void handlePasswordChange(HttpServletRequest req, HttpServletResponse res,
                                      UserModel currentUser)
            throws ServletException, IOException {

        String currentPass = ValidationUtil.safeTrim(req.getParameter("currentPassword"));
        String newPass     = ValidationUtil.safeTrim(req.getParameter("newPassword"));
        String confirmPass = ValidationUtil.safeTrim(req.getParameter("confirmPassword"));

        if (!PasswordUtil.verifyPassword(currentPass, currentUser.getPassword())) {
            req.setAttribute("errorMessage", "Current password is incorrect.");
            doGet(req, res);
            return;
        }
        if (!newPass.equals(confirmPass)) {
            req.setAttribute("errorMessage", "New passwords do not match.");
            doGet(req, res);
            return;
        }

        String hashed  = PasswordUtil.hashPassword(newPass);
        boolean changed = userDAO.updatePassword(currentUser.getUserId(), hashed);
        if (changed) {
            currentUser.setPassword(hashed);
            req.getSession().setAttribute("loggedInUser", currentUser);
            req.setAttribute("successMessage", "Password changed successfully.");
        } else {
            req.setAttribute("errorMessage", "Password change failed. Please try again.");
        }
        doGet(req, res);
    }
}