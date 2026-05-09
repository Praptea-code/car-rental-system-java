package com.spra.controller;

import com.spra.dao.CategoryDAO;
import com.spra.dao.ProductDAO;
import com.spra.model.CategoryModel;
import com.spra.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/home"} )
public class HomeController extends HttpServlet {

    private final ProductDAO productDAO;
    private final CategoryDAO categoryDAO;

    public HomeController() {
        this.productDAO = new ProductDAO();
        this.categoryDAO = new CategoryDAO();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<ProductModel> featuredProducts = productDAO.getFeaturedProducts();
        ProductModel bestseller = productDAO.getBestseller();
        List<CategoryModel> categories = categoryDAO.getAllCategories();

        req.setAttribute("featuredProducts", featuredProducts);
        req.setAttribute("bestseller", bestseller);
        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/WEB-INF/pages/home.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }
}
