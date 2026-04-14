<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle",  "Beauty that Begins with You");
    request.setAttribute("pageCSS",    "home");
    request.setAttribute("activePage", "home");
%>
<%@ include file="header.jsp" %>

<!-- ===== HERO SECTION ===== -->
<section class="hero">
    <div class="hero-video-bg">
        <%-- Replace this div with <video autoplay muted loop> when ready --%>
        <div class="hero-video-placeholder">
            <span class="video-label">&#x25B6; Video background</span>
        </div>
    </div>

    <div class="hero-content">
        <p class="hero-eyebrow">New Collection 2025</p>
        <h1 class="hero-title">Beauty that<br><em>Begins</em> with You</h1>
        <p class="hero-sub">Premium skincare designed to bring out your most luminous self.</p>
        <a href="<%= contextPath %>/products" class="hero-btn">Shop the Collection</a>
    </div>

    <div class="hero-products">
        <div class="hero-product-img sm">&#128138;</div>
        <div class="hero-product-img tall">&#128138;</div>
        <div class="hero-product-img">&#128138;</div>
        <div class="hero-product-img sm">&#128138;</div>
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
                            <img src="${pageContext.request.contextPath}/images/products/${product.imagePath}"
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
                        <span class="product-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                        <c:if test="${product.oldPrice > 0}">
                            <span class="product-price-old">$<fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
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
                    <img src="${pageContext.request.contextPath}/images/products/${bestseller.imagePath}"
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
            <span class="buy-price">$<fmt:formatNumber value="${bestseller.price}" pattern="#,##0.00"/></span>
            <a href="#" class="follow-link">Follow Instagram</a>
        </div>
    </div>
</section>
</c:if>

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
        <div class="about-img-wrap">
            <div class="about-splash-icon">&#127807;</div>
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

<!-- ===== FEATURES (GRAY) ===== -->
<section class="features-section">
    <div class="features-word">Features</div>
    <div class="features-center">
        <div class="feature-point fp-tl">Brightening</div>
        <div class="feature-point fp-tr">Soothing</div>
        <div class="feature-point fp-tr2">Deep Hydration</div>
        <div class="feature-point fp-bl">Anti-Aging</div>
        <div class="features-oval"><div class="features-product">&#129511;</div></div>
        <div class="features-badge">Up to 15% early beauty discount</div>
    </div>
    <div class="features-right">
        <h3 class="features-right-title">Expertly formulated for every skin type</h3>
        <p class="features-right-desc">Laboratory-tested, dermatologist approved. Each Spra product delivers visible results within 4 weeks of consistent use.</p>
    </div>
</section>

<!-- ===== COLLECTION BAND (image placeholder) ===== -->
<section class="collection-band">
    <div class="collection-overlay">
        <h2 class="collection-title">The Spra Collection</h2>
        <p class="collection-sub">Luxury skincare crafted with nature&apos;s finest</p>
        <a href="<%= contextPath %>/products" class="collection-btn">Explore Now</a>
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
        <div class="newsletter-right">&#10024;</div>
    </div>
</section>

<%@ include file="footer.jsp" %>
