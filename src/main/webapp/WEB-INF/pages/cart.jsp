<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    request.setAttribute("currentUser", currentUser);
    com.spra.model.CartModel cart =
        (com.spra.model.CartModel) session.getAttribute("cart");
    if (cart == null) {
        cart = new com.spra.model.CartModel();
        session.setAttribute("cart", cart);
    }
    request.setAttribute("cart", cart);
    String contextPath = request.getContextPath();
    
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart &ndash; Spra.</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/cart.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>

<!-- ===== NAVIGATION ===== -->
<nav class="nav">
    <div class="nav-logo">SΡRA<span class="nav-dot">.</span></div>
    <ul class="nav-links">
        <li><a href="<%= contextPath %>/home">Home</a></li>
        <li><a href="<%= contextPath %>/products">Products</a></li>
        <li><a href="<%= contextPath %>/about">About</a></li>
        <li><a href="<%= contextPath %>/contact">Contact</a></li>
    </ul>
    <div class="nav-right">
        <a href="<%= contextPath %>/products" class="nav-icon-btn" title="Search">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
        </a>
        <a href="<%= contextPath %>/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                <line x1="3" y1="6" x2="21" y2="6"/>
                <path d="M16 10a4 4 0 0 1-8 0"/>
            </svg>
            <c:if test="${cart.totalCount > 0}">
                <span class="cart-badge">${cart.totalCount}</span>
            </c:if>
        </a>
        <c:choose>
            <c:when test="${not empty currentUser}">
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
                <a href="<%= contextPath %>/login" class="nav-login-btn">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- ===== CART PAGE ===== -->
<div class="cart-page">

    <div class="cart-header">
        <h1 class="cart-title">Your Cart</h1>
        <p class="cart-subtitle">
            <c:choose>
                <c:when test="${cart.totalCount == 0}">Your cart is empty</c:when>
                <c:otherwise>${cart.totalCount} item<c:if test="${cart.totalCount != 1}">s</c:if> waiting for you</c:otherwise>
            </c:choose>
        </p>
    </div>

    <c:choose>
        <c:when test="${cart.isEmpty}">
            <!-- Empty state -->
            <div class="cart-empty">
                <div class="cart-empty-icon">
                    <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#e8d8da" stroke-width="1">
                        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                </div>
                <h2 class="cart-empty-title">Nothing here yet</h2>
                <p class="cart-empty-sub">Discover our collection and add something you love.</p>
                <a href="<%= contextPath %>/products" class="cart-shop-btn">Browse Products</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-layout">

                <!-- LEFT: items list -->
                <div class="cart-items-col">
                    <div class="cart-items-head">
                        <span class="chi-label">Product</span>
                        <span class="chi-label">Price</span>
                        <span class="chi-label">Qty</span>
                        <span class="chi-label">Subtotal</span>
                        <span></span>
                    </div>

                    <c:forEach var="item" items="${cart.items}">
                        <div class="cart-item">
                            <!-- Product image + name -->
                            <div class="ci-product">
                                <div class="ci-img">
                                    <c:choose>
                                        <c:when test="${not empty item.imagePath}">
                                            <img src="${pageContext.request.contextPath}/assets/images/products/${item.imagePath}"
                                                 alt="${item.name}">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="ci-img-placeholder">&#128138;</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="ci-cat">${item.categoryName}</p>
                                    <p class="ci-name">${item.name}</p>
                                </div>
                            </div>

                            <!-- Unit price -->
                            <p class="ci-price">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>

                            <!-- Qty stepper -->
                            <form action="<%= contextPath %>/cart/update" method="post" class="ci-qty-form">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <div class="ci-qty-wrap">
                                    <button type="button" class="qty-btn" onclick="stepQty(this,-1)">&#8722;</button>
                                    <input type="number" name="qty" class="qty-input"
                                           value="${item.quantity}" min="0" max="99"
                                           onchange="this.form.submit()">
                                    <button type="button" class="qty-btn" onclick="stepQty(this,1)">&#43;</button>
                                </div>
                            </form>

                            <!-- Subtotal -->
                            <p class="ci-subtotal">Rs <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></p>

                            <!-- Remove -->
                            <form action="<%= contextPath %>/cart/remove" method="post">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <button type="submit" class="ci-remove" title="Remove">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                        <polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/>
                                        <path d="M10 11v6M14 11v6M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/>
                                    </svg>
                                </button>
                            </form>
                        </div>
                    </c:forEach>

                    <!-- Actions row -->
                    <div class="cart-actions-row">
                        <a href="<%= contextPath %>/products" class="cart-continue-btn">&larr; Continue Shopping</a>
                        <form action="<%= contextPath %>/cart/clear" method="post">
                            <button type="submit" class="cart-clear-btn">Clear Cart</button>
                        </form>
                    </div>
                </div>

                <!-- RIGHT: order summary -->
                <div class="cart-summary-col">
                    <div class="cart-summary">
                        <h2 class="cs-title">Order Summary</h2>

                        <div class="cs-row">
                            <span>Subtotal (${cart.totalCount} items)</span>
                            <span>Rs <fmt:formatNumber value="${cart.grandTotal}" pattern="#,##0.00"/></span>
                        </div>
                        <div class="cs-row">
                            <span>Shipping</span>
                            <span class="cs-free">Free</span>
                        </div>
                        <div class="cs-divider"></div>
                        <div class="cs-row cs-total">
                            <span>Total</span>
                            <span>Rs <fmt:formatNumber value="${cart.grandTotal}" pattern="#,##0.00"/></span>
                        </div>

                        <button class="cs-checkout-btn" onclick="handleCheckout('<%= contextPath %>')">
                            Proceed to Checkout
                        </button>

                        <div class="cs-badges">
                            <span class="cs-badge">&#128274; Secure checkout</span>
                            <span class="cs-badge">&#9989; Free returns</span>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div class="footer-brand-col">
                <div class="footer-logo">SΡRA<span>.</span></div>
                <p class="footer-tagline">Luxury cosmetics crafted with love. Discover beauty products that make you feel confident and radiant every day.</p>
            </div>
            <div class="footer-col">
                <h4 class="footer-col-title">Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/home">Home</a></li>
                    <li><a href="<%= contextPath %>/products">Products</a></li>
                    <li><a href="<%= contextPath %>/about">About</a></li>
                    <li><a href="<%= contextPath %>/contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-col-title">Categories</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/products?category=1">Skincare</a></li>
                    <li><a href="<%= contextPath %>/products?category=2">Makeup</a></li>
                    <li><a href="<%= contextPath %>/products?category=3">Fragrance</a></li>
                </ul>
            </div>
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
            <div class="footer-legal"><a href="#">Privacy Policy</a><a href="#">Terms of Service</a></div>
        </div>
    </div>
</footer>

<script>
function stepQty(btn, delta) {
    var form  = btn.closest('.ci-qty-form');
    var input = form.querySelector('.qty-input');
    var val   = Math.max(0, parseInt(input.value) + delta);
    input.value = val;
    form.submit();
}

function handleCheckout(ctx) {
    var loggedIn = '<%= currentUser != null ? "true" : "false" %>';
    if (loggedIn !== 'true') {
        window.location.href = ctx + '/login';
    } else {
        alert('Checkout coming soon! Your order has been noted.');
    }
}
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
