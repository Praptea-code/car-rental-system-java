<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle",  "Contact Us");
    request.setAttribute("pageCSS",    "contact");
    request.setAttribute("activePage", "contact");
%>
<%
    // Retrieve logged-in user from session for nav display
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    request.setAttribute("currentUser", currentUser);
    String contextPath = request.getContextPath();
    
    com.spra.model.CartModel cart =
    	      (com.spra.model.CartModel) session.getAttribute("cart");
    	  request.setAttribute("cart", cart);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spra. – <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Premium Cosmetics" %></title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/<%= request.getAttribute("pageCSS") != null ? request.getAttribute("pageCSS") : "home" %>.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>

<!-- ===== NAVIGATION ===== -->
<nav class="nav">
    <div class="nav-logo">SΡRA<span class="nav-dot">.</span></div>

    <ul class="nav-links">
        <li><a href="<%= contextPath %>/home"     class="<%= request.getAttribute("activePage") != null && request.getAttribute("activePage").equals("home")     ? "active" : "" %>">Home</a></li>
        <li><a href="<%= contextPath %>/products" class="<%= request.getAttribute("activePage") != null && request.getAttribute("activePage").equals("products") ? "active" : "" %>">Products</a></li>
        <li><a href="<%= contextPath %>/about"    class="<%= request.getAttribute("activePage") != null && request.getAttribute("activePage").equals("about")    ? "active" : "" %>">About</a></li>
        <li><a href="<%= contextPath %>/contact"  class="<%= request.getAttribute("activePage") != null && request.getAttribute("activePage").equals("contact")  ? "active" : "" %>">Contact</a></li>
    </ul>

    <div class="nav-right">
        <!-- Search icon -->
        <a href="<%= contextPath %>/products" class="nav-icon-btn" title="Search">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
        </a>

        <!-- Cart icon -->
        <a href="<%= contextPath %>/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
		    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
		        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
		        <line x1="3" y1="6" x2="21" y2="6"/>
		        <path d="M16 10a4 4 0 0 1-8 0"/>
		    </svg>
		    <c:if test="${not empty cart and cart.totalCount > 0}">
		        <span class="cart-badge">${cart.totalCount}</span>
		    </c:if>
		</a>

        <c:choose>
            <c:when test="${not empty currentUser}">
                <!-- Logged-in: show name + dropdown -->
                <div class="nav-user-wrap">
                    <span class="nav-username">Hi, ${currentUser.firstName}</span>
                    <c:if test="${currentUser.role == 'ADMIN'}">
                        <a href="<%= contextPath %>/admin/dashboard" class="nav-admin-btn">Dashboard</a>
                    </c:if>
                    <a href="<%= contextPath %>/user/profile" class="nav-profile-btn">Profile</a>
                    <form action="<%= contextPath %>/logout" method="post" style="display:inline">
                        <button type="submit" class="nav-logout-btn">Logout</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Not logged in: Login button -->
                <a href="<%= contextPath %>/login" class="nav-login-btn">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<div class="contact-page">

    <!-- Hero banner -->
    <div class="contact-hero">
        <h1 class="ch-title">Get in <em>Touch</em></h1>
        <p class="ch-sub">We&apos;d love to hear from you whether it&apos;s feedback, a question or a collaboration idea.</p>
    </div>

    <div class="contact-body">

        <!-- Form side -->
        <div class="contact-form-side">
            <h2 class="cf-title">Send us a message</h2>

            <!-- Flash messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form action="<%= contextPath %>/contact" method="post" class="contact-form" novalidate>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-input"
                               placeholder="Enter your first name"
                               value="<c:out value='${firstName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-input"
                               placeholder="Enter your last name"
                               value="<c:out value='${lastName}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="hello@example.com"
                           value="<c:out value='${email}'/>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="subject">Subject</label>
                    <select id="subject" name="subject" class="form-input">
                        <option value="General Inquiry"   <c:if test='${subject == "General Inquiry"}'>selected</c:if>>General Inquiry</option>
                        <option value="Product Question"  <c:if test='${subject == "Product Question"}'>selected</c:if>>Product Question</option>
                        <option value="Order Support"     <c:if test='${subject == "Order Support"}'>selected</c:if>>Order Support</option>
                        <option value="Collaboration"     <c:if test='${subject == "Collaboration"}'>selected</c:if>>Collaboration</option>
                        <option value="Press and Media"   <c:if test='${subject == "Press and Media"}'>selected</c:if>>Press &amp; Media</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="message">Message</label>
                    <textarea id="message" name="message" class="form-textarea"
                              placeholder="Tell us how we can help you..." required><c:out value="${message}"/></textarea>
                </div>

                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>

        <!-- Info side -->
        <div class="contact-info-side">
            <h2 class="ci-title">Contact Information</h2>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Address</p>
                    <p class="ci-value">Sinamangal, Kathmandu</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                        <polyline points="22,6 12,13 2,6"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Email</p>
                    <p class="ci-value">hello@spra.com</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.15 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.06 1.27h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 21 16.92z"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Phone</p>
                    <p class="ci-value">+977 9878670678</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Business Hours</p>
                    <p class="ci-value">Sun&ndash;Fri, 9am &ndash; 6pm </p>
                </div>
            </div>

            <div class="ci-map"><img src="${pageContext.request.contextPath}/assets/images/map.png"></div>

        </div>
    </div>
</div>


<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">

            <!-- Brand -->
            <div class="footer-brand-col">
                <div class="footer-logo">SΡRA<span>.</span></div>
                <p class="footer-tagline">Luxury cosmetics crafted with love. Discover beauty products that make you feel confident and radiant every day.</p>
            </div>

            <!-- Quick Links -->
            <div class="footer-col">
                <h4 class="footer-col-title">Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/home">Home</a></li>
                    <li><a href="<%= contextPath %>/products">Products</a></li>
                    <li><a href="<%= contextPath %>/about">About</a></li>
                    <li><a href="<%= contextPath %>/contact">Contact</a></li>
                </ul>
            </div>

            <!-- Categories -->
            <div class="footer-col">
                <h4 class="footer-col-title">Categories</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/products?category=1">Skincare</a></li>
                    <li><a href="<%= contextPath %>/products?category=2">Makeup</a></li>
                    <li><a href="<%= contextPath %>/products?category=3">Fragrance</a></li>
                    <li><a href="<%= contextPath %>/products?category=4">Lips</a></li>
                    <li><a href="<%= contextPath %>/products?category=5">Eyes</a></li>
                    <li><a href="<%= contextPath %>/products?category=6">Tools</a></li>
                </ul>
            </div>

            <!-- Contact Info -->
            <div class="footer-col">
                 <h4 class="footer-col-title">Contact Info</h4>
                	<ul class="footer-links">
                    <li>Sinamangal, Kathmandu</li>
                    <li><a href="mailto:hello@spra.com">hello@spra.com</a></li>
                    <li>+977 9878670678</li>
                    </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <p class="footer-copy">&copy; 2025 Spra. Made with <span class="footer-heart">&#9829;</span> All rights reserved.</p>
            <div class="footer-legal">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
            </div>
        </div>
    </div>
</footer>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
<!-- ===== END FOOTER ===== -->

