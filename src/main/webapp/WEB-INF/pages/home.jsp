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

    <style>
        /* ============================================================
           LOGIN WELCOME POPUP
           ============================================================ */
        .login-popup-overlay {
            position: fixed; inset: 0; z-index: 9000;
            background: rgba(10,4,6,.72);
            backdrop-filter: blur(6px);
            display: flex; align-items: center; justify-content: center;
            animation: lpFadeIn .4s ease;
        }
        @keyframes lpFadeIn { from { opacity:0; } to { opacity:1; } }

        .login-popup-box {
            background: #fff;
            border-radius: 24px;
            padding: 3rem 3.2rem 2.6rem;
            max-width: 500px;
            width: calc(100% - 2.4rem);
            position: relative;
            overflow: hidden;
            box-shadow: 0 32px 80px rgba(0,0,0,.28);
            animation: lpSlideUp .45s cubic-bezier(.22,1,.36,1);
            text-align: center;
        }
        @keyframes lpSlideUp {
            from { opacity:0; transform: translateY(40px) scale(.97); }
            to   { opacity:1; transform: translateY(0) scale(1); }
        }

        /* decorative pink glow blob top-right */
        .login-popup-glow {
            position: absolute;
            width: 360px; height: 360px; border-radius: 50%;
            background: radial-gradient(circle, #fdf0f2 0%, transparent 68%);
            top: -110px; right: -90px;
            pointer-events: none;
        }
        /* soft bottom accent */
        .login-popup-glow2 {
            position: absolute;
            width: 260px; height: 260px; border-radius: 50%;
            background: radial-gradient(circle, #fdf8e8 0%, transparent 70%);
            bottom: -80px; left: -60px;
            pointer-events: none;
        }

        .login-popup-close {
            position: absolute; top: 16px; right: 18px;
            background: #f8f0f2; border: none; border-radius: 50%;
            width: 34px; height: 34px; font-size: 20px; line-height: 1;
            color: #999; display: flex; align-items: center; justify-content: center;
            transition: background .2s, color .2s; cursor: pointer; z-index: 2;
        }
        .login-popup-close:hover { background: #e8536a; color: #fff; }

        .login-popup-brand {
            font-family: 'Cormorant Garamond', serif;
            font-size: 20px; letter-spacing: 6px; font-weight: 600;
            color: #1a1a1a; margin-bottom: 1.8rem; position: relative; z-index: 1;
        }
        .login-popup-brand span { color: #e8536a; }

        .login-popup-divider-row {
            display: flex; align-items: center; justify-content: center; gap: 10px;
            margin-bottom: 12px; position: relative; z-index: 1;
        }
        .login-popup-divider-row::before,
        .login-popup-divider-row::after {
            content: ''; flex: 1; max-width: 48px; height: 1px; background: #e8d8da;
        }
        .login-popup-eyebrow {
            font-size: .65rem; letter-spacing: .22em; text-transform: uppercase;
            color: #e8536a; font-weight: 700;
        }

        .login-popup-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(2.2rem, 5vw, 3rem); font-weight: 300;
            color: #1a1a1a; line-height: 1.1; margin-bottom: 16px; position: relative; z-index: 1;
        }
        .login-popup-title em { font-style: italic; color: #e8536a; font-weight: 400; }

        .login-popup-sub {
            font-size: .84rem; color: #888; line-height: 1.8;
            max-width: 360px; margin: 0 auto 2rem; position: relative; z-index: 1;
        }

        .login-popup-actions {
            display: flex; gap: 10px; margin-bottom: 1.2rem; position: relative; z-index: 1;
        }
        .lp-btn-primary {
            flex: 1; background: #1a1a1a; color: #fff;
            padding: 15px 20px; border-radius: 10px;
            font-size: .85rem; font-weight: 600; letter-spacing: .04em;
            transition: background .22s, transform .15s;
            display: flex; align-items: center; justify-content: center;
            font-family: 'DM Sans', sans-serif;
        }
        .lp-btn-primary:hover { background: #e8536a; color: #fff; transform: translateY(-2px); }

        .lp-btn-secondary {
            flex: 1; background: #fdf0f2; color: #e8536a;
            padding: 15px 20px; border-radius: 10px;
            font-size: .85rem; font-weight: 600;
            border: 1.5px solid #f4a0b0;
            transition: background .22s, border-color .22s, transform .15s;
            display: flex; align-items: center; justify-content: center;
            font-family: 'DM Sans', sans-serif;
        }
        .lp-btn-secondary:hover { background: #e8536a; color: #fff; border-color: #e8536a; transform: translateY(-2px); }

        .lp-skip {
            background: none; border: none; font-size: .72rem;
            color: #bbb; cursor: pointer; font-family: 'DM Sans', sans-serif;
            transition: color .2s; position: relative; z-index: 1;
            letter-spacing: .04em;
        }
        .lp-skip:hover { color: #888; }

        /* trust badges row */
        .lp-badges {
            display: flex; justify-content: center; gap: 20px;
            margin-top: 1.6rem; margin-bottom: .8rem;
            position: relative; z-index: 1;
        }
        .lp-badge {
            font-size: .6rem; color: #bbb; display: flex;
            flex-direction: column; align-items: center; gap: 4px;
        }
        .lp-badge-icon {
            width: 32px; height: 32px; border-radius: 50%;
            background: #f8f0f2; border: 1px solid #f0e0e0;
            display: flex; align-items: center; justify-content: center;
        }

        @media (max-width: 520px) {
            .login-popup-box { padding: 2.4rem 1.8rem 2rem; border-radius: 18px; }
            .login-popup-actions { flex-direction: column; }
        }

        /* ============================================================
           FEATURED PRODUCT CARD — matches products page style
           ============================================================ */
        .feat-card {
            background: #f8f8f8;
            border-radius: 12px;
            overflow: hidden;
            transition: transform .2s;
            position: relative;
            display: flex;
            flex-direction: column;
        }
        .feat-card:hover { transform: translateY(-3px); }
        .feat-card-link { display: block; text-decoration: none; color: inherit; cursor: pointer; }
        .feat-img {
            height: 300px;
            display: flex; align-items: center; justify-content: center;
            background: #f0f0f0; overflow: hidden;
        }
        .feat-img img { width: 100%; height: 100%; object-fit: cover; }
        .feat-img-ph  { font-size: 52px; }
        .feat-card-body { padding: 14px 16px 16px; flex: 1; display: flex; flex-direction: column; }
        .feat-atc-btn {
            width: 100%; padding: 12px; margin-top: 14px;
            background: #1a1a1a; color: #fff; border: none;
            border-radius: 6px; font-family: 'DM Sans', sans-serif;
            font-size: 13px; font-weight: 500; text-transform: uppercase;
            letter-spacing: 1px; cursor: pointer; transition: background .25s;
        }
        .feat-atc-btn:hover:not(:disabled) { background: #e8536a; }
        .feat-atc-btn:disabled { background: #e0e0e0; color: #999; cursor: not-allowed; }
        .feat-atc-btn.adding  { background: #3B9B3F !important; }

        /* bottom toast notification */
        .feat-toast {
            position: fixed; bottom: 28px; left: 50%; transform: translateX(-50%);
            background: #1a1a1a; color: #fff;
            padding: 12px 28px; border-radius: 30px;
            font-size: .82rem; font-weight: 500;
            box-shadow: 0 8px 28px rgba(0,0,0,.18);
            z-index: 9500; opacity: 0; pointer-events: none;
            transition: opacity .25s; white-space: nowrap;
            border-left: 4px solid #e8536a;
        }
        .feat-toast.show { opacity: 1; }
    </style>
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

    <%-- Invisible toast that pops up when item is added --%>
    <div class="feat-toast" id="featToast"></div>

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
                            <button class="feat-atc-btn"
                                    onclick="addToCart(this, ${product.productId}, '${product.name}')">
                                Add to Cart
                            </button>
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

<script>
/* ============================================================
   AJAX Add to Cart — no page refresh
   ============================================================ */
function addToCart(btn, productId, productName) {
    btn.disabled = true;
    btn.textContent = 'Adding…';
    btn.classList.add('adding');

    var formData = new FormData();
    formData.append('productId', productId);
    formData.append('qty', 1);

    fetch('<%= contextPath %>/cart/add', {
        method: 'POST',
        body: formData,
        redirect: 'manual'          // stop the server redirect from navigating away
    })
    .then(function () {
        // Update button momentarily
        btn.textContent = '✓ Added!';
        setTimeout(function () {
            btn.textContent = 'Add to Cart';
            btn.disabled = false;
            btn.classList.remove('adding');
        }, 1600);

        // Show bottom toast
        var toast = document.getElementById('featToast');
        if (toast) {
            toast.textContent = '✓ ' + productName + ' added to cart';
            toast.classList.add('show');
            setTimeout(function () { toast.classList.remove('show'); }, 2800);
        }

        // Bump the nav cart badge without a full reload
        updateCartBadge();
    })
    .catch(function () {
        btn.textContent = 'Add to Cart';
        btn.disabled = false;
        btn.classList.remove('adding');
    });
}

/* Fetch the cart page silently just to read the updated badge count */
function updateCartBadge() {
    fetch('<%= contextPath %>/cart', { method: 'GET' })
    .then(function(r){ return r.text(); })
    .then(function(html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var newBadge = doc.querySelector('.cart-badge');
        var allBadges = document.querySelectorAll('.cart-badge');

        allBadges.forEach(function(b){ b.remove(); });

        if (newBadge) {
            document.querySelectorAll('.cart-icon-btn').forEach(function(iconBtn) {
                var clone = newBadge.cloneNode(true);
                iconBtn.appendChild(clone);
            });
        }
    })
    .catch(function(){});   // silently ignore network errors
}


(function () {
    var popup = document.getElementById('loginPopup');
    if (!popup) return; // user is logged in, nothing to do

    // Show only once per browser session
    try {
        if (sessionStorage.getItem('spra_popup_seen') === '1') {
            popup.style.display = 'none';
            return;
        }
    } catch (e) {}

    // Slight delay so the page has a moment to render first
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

// Escape key closes popup
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') dismissPopup();
});

// Click outside the box closes popup
var popupOverlay = document.getElementById('loginPopup');
if (popupOverlay) {
    popupOverlay.addEventListener('click', function (e) {
        if (e.target === popupOverlay) dismissPopup();
    });
}
</script>

</body>
</html>
<!-- ===== END FOOTER ===== -->
