<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle",  "About Us");
    request.setAttribute("pageCSS",    "about");
    request.setAttribute("activePage", "about");
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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

<!-- ===== ABOUT HERO ===== -->
<section class="about-hero">
    <div class="ah-content">
        <p class="ah-eyebrow">Established 2020</p>
        <h1 class="ah-title">
            This is <em>Spra</em>. <br>
            Beauty, Reimagined.
        </h1>
        <div class="ah-divider"></div>
        <p class="ah-sub">
            Tiny, curious, and destined for the beauty world. 
            We didn't just launch a brand; we started a conversation.
        </p>
        <p class="ah-manifesto">
            "We believe beauty is a ritual of self-love a delicate 
            balance between scientific efficacy and soulful aesthetics."
        </p>
    </div>
</section>
<!-- ===== STORY SECTION ===== -->
<section class="about-story">
    <div class="as-grid">
        <div class="as-body">
            <h2 class="as-title">It&apos;s not just beauty,<br>it&apos;s vibing with your skin.</h2>
            <p class="as-text">After realizing our products earned more trust with a little aesthetic flair, we hit 10,000 customers — and probably thought we were famous. That&apos;s when it clicked: people are drawn to products that actually work.</p>
            <p class="as-text">We love crafting formulas that reflect intentional living, self-growth, and an eye for aesthetics.</p>
            <div class="as-stats">
                <div class="as-stat"><span class="as-stat-num">10K+</span><span class="as-stat-lbl">Happy customers</span></div>
                <div class="as-stat"><span class="as-stat-num">50+</span><span class="as-stat-lbl">Products</span></div>
                <div class="as-stat"><span class="as-stat-num">100%</span><span class="as-stat-lbl">Natural ingredients</span></div>
                <div class="as-stat"><span class="as-stat-num">5&#9733;</span><span class="as-stat-lbl">Average rating</span></div>
            </div>
        </div>
        <div class="as-image-wrap"> <img src="${pageContext.request.contextPath}/assets/images/about.jpg" alt="Description of image" class="inner-img"> </div>
    </div>
</section>


<!-- ===== TEAM SECTION ===== -->
<section class="about-team">
    <div class="section-head">
        <h2 class="section-title">Our CEO</h2>
        <p class="section-sub">The person behind your favourite products</p>
    </div>
    <div class="team-grid">

        <div class="team-card">
            <div class="team-avatar"><img src="${pageContext.request.contextPath}/assets/images/prapti.png" alt="Prapti"></div>
            <h3 class="team-name">Prapti Bhattarai</h3>
            <p class="team-role">CEO</p>
            <p class="team-bio">CEO with 7 years in luxury beauty. Every Spra campaign is her canvas.</p>
            <div class="skill-bars">
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Leadership</span><span>98%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:98%"></div></div>
                </div>
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span></span>Commitment<span>98%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:88%"></div></div>
                </div>
            </div>
        </div>

    </div>
    <p class="team-wrap-line">and that&apos;s a wrap.</p>
</section>

<!-- ===== VALUES SECTION ===== -->
<section class="about-values">
    <div class="section-head">
        <h2 class="section-title">What We Stand For</h2>
        <p class="section-sub">Our values shape every product we make</p>
    </div>
    <div class="values-grid">
        <div class="value-card">
            <span class="value-num">01</span>
            <h3 class="value-title">Clean Beauty</h3>
            <p class="value-desc">No harmful chemicals. Ever. Beauty should never come at the cost of your health.</p>
        </div>
        <div class="value-card">
            <span class="value-num">02</span>
            <h3 class="value-title">Sustainability</h3>
            <p class="value-desc">From sourcing to packaging, every decision is made with the planet in mind.</p>
        </div>
        <div class="value-card">
            <span class="value-num">03</span>
            <h3 class="value-title">Inclusivity</h3>
            <p class="value-desc">Beauty is for everyone. Our products are formulated for all skin tones and types.</p>
        </div>
    </div>
</section>


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
                    <li>123 Beauty Lane, Paris</li>
                    <li><a href="mailto:hello@spra.com">hello@spra.com</a></li>
                    <li>+1 (555) 123-4567</li>
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

