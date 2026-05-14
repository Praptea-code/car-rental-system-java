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
    <link rel="icon" type="image/svg+xml" href="<%= contextPath %>/assets/images/favicon.svg">
    <link rel="stylesheet" href="<%= contextPath %>/css/<%= request.getAttribute("pageCSS") != null ? request.getAttribute("pageCSS") : "home" %>.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

</head>


<body>

<!-- ===== LOGIN WELCOME POPUP (only for guests) ===== -->
<c:if test="${empty currentUser}">
<div id="loginPopup" class="login-popup-overlay">
    <div class="login-popup-box">
        <div class="login-popup-glow"></div>
        <div class="login-popup-glow2"></div>

        <button class="login-popup-close" onclick="dismissPopup()" aria-label="Close">&times;</button>

        <div class="login-popup-brand">SΡRA<span>.</span></div>

        <div class="login-popup-divider-row">
            <span class="login-popup-eyebrow">Welcome to the ritual</span>
        </div>

        <h2 class="login-popup-title">
            Beauty begins<br><em>with you.</em>
        </h2>

        <p class="login-popup-sub">
            Sign in to unlock your wishlist, save your cart, and enjoy a
            personalised experience crafted just for you.
        </p>

        <div class="login-popup-actions">
            <a href="<%= contextPath %>/login" class="lp-btn-primary">Sign In</a>
            <a href="<%= contextPath %>/register" class="lp-btn-secondary">Create Account</a>
        </div>

        <div class="lp-badges">
            <div class="lp-badge">
                <div class="lp-badge-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.8">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                </div>
                Secure
            </div>
            <div class="lp-badge">
                <div class="lp-badge-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.8">
                        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                    </svg>
                </div>
                Free Returns
            </div>
            <div class="lp-badge">
                <div class="lp-badge-icon">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.8">
                        <rect x="1" y="3" width="15" height="13" rx="2"/>
                        <path d="M16 8h4l3 5v3h-7V8z"/>
                        <circle cx="5.5" cy="18.5" r="2.5"/>
                        <circle cx="18.5" cy="18.5" r="2.5"/>
                    </svg>
                </div>
                Free Ship
            </div>
        </div>

        <button class="lp-skip" onclick="dismissPopup()">Continue browsing &rarr;</button>
    </div>
</div>
</c:if>

<c:if test="${sessionScope.showLoader}">
  <div id="spra-loader">
  <div class="sl-ring"></div>
  <div class="sl-ring"></div>
  <div class="sl-ring"></div>
  <div class="sl-ring"></div>
  <div class="sl-drop-wrap">
    <svg class="sl-drop" width="48" height="72" viewBox="0 0 48 72" fill="none">
      <rect x="21" y="0" width="6" height="22" rx="3" fill="#e8536a" opacity=".7"/>
      <path d="M24 18 C10 30 4 44 4 52 C4 63 13 70 24 70 C35 70 44 63 44 52 C44 44 38 30 24 18Z" fill="url(#dropGrad)" opacity=".92"/>
      <ellipse cx="17" cy="44" rx="4" ry="7" fill="rgba(255,255,255,.25)" transform="rotate(-20,17,44)"/>
      <defs>
        <linearGradient id="dropGrad" x1="4" y1="18" x2="44" y2="70" gradientUnits="userSpaceOnUse">
          <stop offset="0%" stop-color="#f4a0b0"/>
          <stop offset="100%" stop-color="#c0424e"/>
        </linearGradient>
      </defs>
    </svg>
    <div class="sl-ripple"></div>
  </div>
  <div class="sl-logo">SΡRA<span>.</span></div>
  <div class="sl-tagline">beauty begins with you</div>
  <div class="sl-bar-wrap"><div class="sl-bar-fill"></div></div>
  <p class="sl-dismiss-line">crafting your ritual…</p>
</div>
</c:if>
<c:remove var="showLoader" scope="session"/>
<!-- ===== NAVIGATION ===== -->
<nav class="nav">
    <a href="${pageContext.request.contextPath}/home" class="nav-logo">SPR<span class="nav-dot">A</span></a>
    <button class="hamburger-btn" onclick="toggleNav()" aria-label="Menu">
	    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" 
	         stroke="currentColor" stroke-width="1.8">
	        <line x1="3" y1="6" x2="21" y2="6"/>
	        <line x1="3" y1="12" x2="21" y2="12"/>
	        <line x1="3" y1="18" x2="21" y2="18"/>
	    </svg>
	</button>
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
         <a href="${pageContext.request.contextPath}/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
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
        <p class="hero-eyebrow">New Collection 2026</p>
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
            <div class="feat-card">
                <c:if test="${product.discountPercent > 0}">
                    <span class="discount-badge">-${product.discountPercent}%</span>
                </c:if>

                <%-- Clicking the image/name goes to the products page filtered by search --%>
                <a href="<%= contextPath %>/products?search=${product.name}" class="feat-card-link">
                    <div class="feat-img">
                        <c:choose>
                            <c:when test="${not empty product.imagePath}">
                                <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}"
                                     alt="${product.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="feat-img-ph">&#128138;</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="feat-card-body">
                        <p class="product-cat">${product.categoryName}</p>
                        <h3 class="product-name">${product.name}</h3>
                        <div class="product-price-row">
                            <span class="product-price">Rs<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                            <c:if test="${product.oldPrice > 0}">
                                <span class="product-price-old">Rs<fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                            </c:if>
                        </div>
                    </div>
                </a>

                <%-- Add to Cart — AJAX, no page refresh --%>
                <div style="padding: 0 16px 16px;">
				    <c:choose>
				        <c:when test="${product.outOfStock}">
				            <button class="feat-atc-btn" disabled>Out of Stock</button>
				        </c:when>
				        <c:otherwise>
						    <form action="${pageContext.request.contextPath}/cart/add" 
						          method="post" 
						          target="cart-frame"
						          onsubmit="handleHomeCartAdd(this, '${product.name}', '${product.categoryName}', ${product.price}, '${product.imagePath}', '${pageContext.request.contextPath}')">
						        <input type="hidden" name="productId" value="${product.productId}">
						        <input type="hidden" name="qty" value="1">
						        <button type="submit" class="feat-atc-btn">Add to Cart</button>
						    </form>
						</c:otherwise>
				    </c:choose>
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

		    <a href="<%= contextPath %>/productDetail?id=${bestseller.productId}"
		       class="buy-btn"
		       style="display:inline-block;text-decoration:none;">
		        Buy Now
		    </a>
		
		    <span class="buy-price">
		        Rs <fmt:formatNumber value="${bestseller.price}" pattern="#,##0.00"/>
		    </span>
		
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
		    <span class="quote-mark">"</span>
		    <p class="statement-text">Nature's <em>essence</em>, bottled for your skin.</p>
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
<!-- Hidden iframe absorbs the form POST redirect so main page never reloads -->
<iframe name="cart-frame" style="display:none;" aria-hidden="true"></iframe>

<script>
function handleHomeCartAdd(form, name, category, price, imagePath, contextPath) {
    var btn = form.querySelector('button');
    btn.disabled = true;
    btn.textContent = '✓ Added!';
    setTimeout(function() {
        btn.disabled = false;
        btn.textContent = 'Add to Cart';
    }, 1600);

    // Show toast
    showCartToast(name, category, price, imagePath, contextPath);

    // Update nav badge count after a short delay
    // (gives the iframe POST time to complete on the server)
    setTimeout(function() {
        fetch(contextPath + '/cart', { credentials: 'same-origin' })
        .then(function(r) { return r.text(); })
        .then(function(html) {
            var doc = new DOMParser().parseFromString(html, 'text/html');
            var badge = doc.querySelector('.cart-badge');
            var count = badge ? parseInt(badge.textContent) : 0;
            document.querySelectorAll('.cart-badge').forEach(function(b) { b.remove(); });
            if (count > 0) {
                document.querySelectorAll('.cart-icon-btn').forEach(function(btn) {
                    var b = document.createElement('span');
                    b.className = 'cart-badge';
                    b.textContent = count;
                    btn.appendChild(b);
                });
            }
        });
    }, 400);
}
</script>
<script>
    /* Login popup for guests */
    (function () {
        var popup = document.getElementById('loginPopup');
        if (!popup) return;
        try {
            if (sessionStorage.getItem('spra_popup_seen') === '1') {
                popup.style.display = 'none';
                return;
            }
        } catch (e) {}
        popup.style.opacity = '0';
        setTimeout(function () {
            popup.style.transition = 'opacity .4s ease';
            popup.style.opacity = '1';
        }, 600);
    }());
 
    function dismissPopup() {
        var popup = document.getElementById('loginPopup');
        if (!popup) return;
        popup.style.transition = 'opacity .3s ease';
        popup.style.opacity = '0';
        setTimeout(function () { popup.style.display = 'none'; }, 320);
        try { sessionStorage.setItem('spra_popup_seen', '1'); } catch (e) {}
    }
 
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') dismissPopup();
    });
 
    var popupOverlay = document.getElementById('loginPopup');
    if (popupOverlay) {
        popupOverlay.addEventListener('click', function (e) {
            if (e.target === popupOverlay) dismissPopup();
        });
    }
	 // Save scroll position before any cart form submits, restore after reload
	 document.querySelectorAll('form[action*="/cart/add"]').forEach(function(form) {
	     form.addEventListener('submit', function() {
	         sessionStorage.setItem('scrollPos', window.scrollY);
	     });
	 });
	
	 var savedPos = sessionStorage.getItem('scrollPos');
	 if (savedPos) {
	     window.scrollTo(0, parseInt(savedPos));
	     sessionStorage.removeItem('scrollPos');
	 }
</script>

</body>
</html>
<!-- ===== END FOOTER ===== -->
