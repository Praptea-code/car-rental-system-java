package com.spra.controller;

import com.spra.dao.ContactDAO;
import com.spra.model.ContactModel;
import com.spra.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/contact"}, asyncSupported = true)
public class ContactController extends HttpServlet {

    private final ContactDAO contactDAO;

    public ContactController() {
        this.contactDAO = new ContactDAO();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String firstName = ValidationUtil.safeTrim(req.getParameter("firstName"));
        String lastName  = ValidationUtil.safeTrim(req.getParameter("lastName"));
        String email     = ValidationUtil.safeTrim(req.getParameter("email"));
        String subject   = ValidationUtil.safeTrim(req.getParameter("subject"));
        String message   = ValidationUtil.safeTrim(req.getParameter("message"));

        if (!ValidationUtil.isValidName(firstName)) {
            req.setAttribute("errorMessage", "Please enter a valid first name.");
            repopulate(req, firstName, lastName, email, subject, message);
            req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward((ServletRequest) req, (ServletResponse) res);
            return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("errorMessage", "Please enter a valid email address.");
            repopulate(req, firstName, lastName, email, subject, message);
            req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward((ServletRequest) req, (ServletResponse) res);
            return;
        }
        if (!ValidationUtil.isNotEmpty(message)) {
            req.setAttribute("errorMessage", "Message cannot be empty.");
            repopulate(req, firstName, lastName, email, subject, message);
            req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward((ServletRequest) req, (ServletResponse) res);
            return;
        }

        ContactModel msg = new ContactModel();
        msg.setFirstName(firstName);
        msg.setLastName(lastName);
        msg.setEmail(email);
        msg.setSubject(subject);
        msg.setMessage(message);

        boolean saved = contactDAO.saveMessage(msg);
        if (saved) {
            req.setAttribute("successMessage", "Thank you! Your message has been sent. We will get back to you soon.");
        } else {
            req.setAttribute("errorMessage", "Sorry, your message could not be sent. Please try again later.");
        }
        req.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward((ServletRequest) req, (ServletResponse) res);
    }

    private void repopulate(HttpServletRequest req, String firstName, String lastName,
                            String email, String subject, String message) {
        req.setAttribute("firstName", firstName);
        req.setAttribute("lastName", lastName);
        req.setAttribute("email", email);
        req.setAttribute("subject", subject);
        req.setAttribute("message", message);
    }
}
