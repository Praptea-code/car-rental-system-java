<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle",  "Beauty that Begins with You");
    request.setAttribute("pageCSS",    "home");
    request.setAttribute("activePage", "home");
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

<!-- ===== HERO SECTION ===== -->
<section class="hero">
    <div class="hero-video-bg">
        <video autoplay muted loop playsinline class="hero-video">
		    <source src="<%= request.getContextPath() %>/assets/videos/hero-bg.mp4" type="video/mp4">
		    Your browser does not support the video tag.
		</video>
        <div class="video-overlay"></div>
    </div>

    <div class="hero-content">
        <p class="hero-eyebrow">New Collection 2025</p>
        <h1 class="hero-title">Beauty that<br><em>Begins</em> with You</h1>
        <p class="hero-sub">Premium skincare designed to bring out your most luminous self.</p>
        <a href="<%= contextPath %>/products" class="hero-btn">Shop the Collection</a>
    </div>

</section>

<!-- ===== FEATURED PRODUCTS ===== -->
<section class="featured">
    <div class="section-head">
        <h2 class="section-title">Featured Products</h2>
        <p class="section-sub">Discover our most loved beauty essentials, curated just for you.</p>
    </div>

    <div class="products-grid">
        <c:forEach var="product" items="${featuredProducts}">
            <div class="product-card">
                <c:if test="${product.discountPercent > 0}">
                    <span class="discount-badge">-${product.discountPercent}%</span>
                </c:if>
                <div class="product-img-area">
                    <c:choose>
                        <c:when test="${not empty product.imagePath}">
                            <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}"
                                 alt="${product.name}" class="product-img">
                        </c:when>
                        <c:otherwise>
                            <div class="product-img-placeholder">&#128138;</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="product-info">
                    <p class="product-cat">${product.categoryName}</p>
                    <h3 class="product-name">${product.name}</h3>
                    <div class="product-price-row">
                        <span class="product-price">Rs<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                        <c:if test="${product.oldPrice > 0}">
                            <span class="product-price-old">Rs<fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <div class="view-all-wrap">
        <a href="<%= contextPath %>/products" class="view-all-btn">View All Products &#8594;</a>
    </div>
</section>

<!-- ===== BESTSELLER SPOTLIGHT ===== -->
<c:if test="${not empty bestseller}">
<section class="spotlight">
    <div class="spotlight-img">
        <div class="spotlight-glow"></div>
        <div class="spotlight-product">
            <c:choose>
                <c:when test="${not empty bestseller.imagePath}">
                    <img src="${pageContext.request.contextPath}/assets/images/bestSelling.png"
                         alt="${bestseller.name}" class="spotlight-product-img">
                </c:when>
                <c:otherwise>&#10024;</c:otherwise>
            </c:choose>
        </div>
        <div class="spotlight-side-labels">
            <span>100% natural</span>
            <span>no side effects</span>
            <span>healthy</span>
        </div>
    </div>
    <div class="spotlight-body">
        <p class="spotlight-tag">&#10022; Best Seller</p>
        <h2 class="spotlight-title">${bestseller.name}</h2>
        <p class="spotlight-desc">${bestseller.description}</p>
        <div class="spotlight-actions">
            <button class="buy-btn">Buy Now</button>
            <span class="buy-price">RS <fmt:formatNumber value="${bestseller.price}" pattern="#,##0.00"/></span>
            <a href="#" class="follow-link">Follow Instagram</a>
        </div>
    </div>
</section>
</c:if>	

<!-- ===== COLLECTION BAND (image placeholder) ===== -->
<section class="collection-band" 
         style="background-image: url('${pageContext.request.contextPath}/assets/images/collectionBand.jpg');">
    <div class="collection-overlay">
        
    </div>
</section>

<!-- ===== BENEFITS + ABOUT US ===== -->
<section class="benefits">
    <div class="section-head">
        <p class="section-eyebrow">Our Promise</p>
        <h2 class="section-title">Our Benefits</h2>
    </div>

    <div class="benefits-grid">
        <div class="benefit-card">
            <div class="benefit-icon-wrap">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                    <path d="M9 12l2 2 4-4m6 2a9 9 0 1 1-18 0 9 9 0 0 1 18 0z"/>
                </svg>
            </div>
            <h3 class="benefit-title">Best Product</h3>
            <p class="benefit-desc">Our serum is crafted with the highest quality ingredients and backed by cutting-edge science.</p>
        </div>
        <div class="benefit-card">
            <div class="benefit-icon-wrap">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                    <rect x="1" y="3" width="15" height="13" rx="2"/>
                    <path d="M16 8h4l3 5v3h-7V8z"/>
                    <circle cx="5.5" cy="18.5" r="2.5"/>
                    <circle cx="18.5" cy="18.5" r="2.5"/>
                </svg>
            </div>
            <h3 class="benefit-title">Free Shipping</h3>
            <p class="benefit-desc">Enjoy free shipping on all orders, no matter the size or destination.</p>
        </div>
        <div class="benefit-card">
            <div class="benefit-icon-wrap">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
            </div>
            <h3 class="benefit-title">Guarantee</h3>
            <p class="benefit-desc">We offer a 100% satisfaction guarantee on every single purchase.</p>
        </div>
    </div>

    <!-- About Us split -->
    <div class="about-split">
        <div class="about-img-wrap statement-box">
		    <span class="quote-mark">“</span>
		    <p class="statement-text">Nature’s <em>essence</em>, bottled for your skin.</p>
		</div>
        <div class="about-body">
            <p class="about-eyebrow">&#10022; About Us</p>
            <h2 class="about-title">Crafted with the highest quality natural ingredients</h2>
            <p class="about-desc">Each formula is carefully developed with dermatologists and scientists to ensure the best results for all skin types.</p>
            <ul class="ingredient-list">
                <li class="ingredient-item">
                    <div class="ingr-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5"><path d="M12 2v20M2 12h20"/></svg>
                    </div>
                    <div>
                        <strong class="ingr-name">Hyaluronic Acid</strong>
                        <span class="ingr-desc">Boosts hydration and plumps the skin</span>
                    </div>
                </li>
                <li class="ingredient-item">
                    <div class="ingr-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5"><circle cx="12" cy="12" r="10"/></svg>
                    </div>
                    <div>
                        <strong class="ingr-name">Vitamin C</strong>
                        <span class="ingr-desc">Brightens and evens out skin tone</span>
                    </div>
                </li>
                <li class="ingredient-item">
                    <div class="ingr-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5"><path d="M12 2C6 2 2 8 2 12s4 10 10 10 10-4.5 10-10S18 2 12 2z"/></svg>
                    </div>
                    <div>
                        <strong class="ingr-name">Aloe Vera</strong>
                        <span class="ingr-desc">Soothes and calms irritated skin</span>
                    </div>
                </li>
            </ul>
        </div>
    </div>
</section>


<!-- ===== NEWSLETTER ===== -->
<section class="newsletter">
    <div class="newsletter-inner">
        <div class="newsletter-left">
            <h3 class="nl-title">Stay Updated</h3>
            <p class="nl-sub">Sign up for our newsletter to receive exclusive deals, skincare tips, and updates on new products.</p>
            <div class="nl-form">
                <input type="email" class="nl-input" placeholder="Enter your email" />
                <button class="nl-btn">Subscribe</button>
            </div>
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
                    <li>+977 9868706776</li>
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

