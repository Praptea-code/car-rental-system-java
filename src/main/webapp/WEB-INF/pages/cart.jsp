<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    com.spra.model.CartModel cart =
        (com.spra.model.CartModel) session.getAttribute("cart");
    String contextPath = request.getContextPath();
    request.setAttribute("currentUser", currentUser);
    request.setAttribute("cart", cart);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart — Spra.</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --pink: #e8536a; --pink-light: #fdf2f4; --pink-mid: #f4a0b0;
            --dark: #1a1a1a; --mid: #555; --muted: #888;
            --border: #e8d8da; --bg-soft: #fdf8f8;
        }
        .cart-page { max-width: 1200px; margin: 0 auto; padding: 3rem 3rem 5rem; min-height: 60vh; }
        .cart-header { margin-bottom: 2.5rem; }
        .cart-title { font-family: 'Cormorant Garamond', serif; font-size: clamp(2.2rem, 5vw, 3rem); font-weight: 300; color: var(--dark); margin-bottom: 6px; }
        .cart-title em { font-style: italic; color: var(--pink); font-weight: 400; }
        .cart-subtitle { font-size: .82rem; color: #aaa; }
        .cart-empty { text-align: center; padding: 6rem 2rem; display: flex; flex-direction: column; align-items: center; gap: 18px; }
        .cart-empty-ring { width: 100px; height: 100px; border-radius: 50%; background: var(--pink-light); border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; }
        .cart-empty-title { font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; color: var(--dark); font-weight: 400; }
        .cart-empty-sub { font-size: .85rem; color: var(--muted); max-width: 300px; line-height: 1.7; }
        .cart-empty-btn { display: inline-block; background: var(--pink); color: #fff; padding: 13px 32px; border-radius: 30px; font-size: .82rem; font-weight: 600; transition: opacity .2s; }
        .cart-empty-btn:hover { opacity: .88; color: #fff; }
        .cart-layout { display: flex; gap: 2.5rem; align-items: flex-start; }
        .cart-items-col { flex: 1; min-width: 0; }
        .cart-summary-col { width: 340px; flex-shrink: 0; }
        .cart-col-head { display: grid; grid-template-columns: 2.2fr 1fr 1.2fr 1fr 42px; gap: 12px; padding: 0 14px 12px; border-bottom: 1.5px solid var(--border); margin-bottom: 6px; }
        .cch-label { font-size: .62rem; font-weight: 700; text-transform: uppercase; letter-spacing: .1em; color: #bbb; }
        .cart-item { display: grid; grid-template-columns: 2.2fr 1fr 1.2fr 1fr 42px; gap: 12px; align-items: center; padding: 16px 14px; border-bottom: 1px solid #f8f0f0; transition: background .15s; border-radius: 10px; }
        .cart-item:hover { background: #fdf8f8; }
        .ci-product { display: flex; align-items: center; gap: 14px; }
        .ci-img { width: 72px; height: 72px; border-radius: 10px; overflow: hidden; background: #f0e8e8; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
        .ci-img img { width: 100%; height: 100%; object-fit: cover; }
        .ci-img-ph { font-size: 1.8rem; }
        .ci-cat { font-size: .58rem; color: #aaa; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 2px; }
        .ci-name { font-family: 'Cormorant Garamond', serif; font-size: 1rem; font-weight: 600; color: var(--dark); line-height: 1.3; }
        .ci-unit-price { font-size: .88rem; color: var(--mid); }
        .ci-qty-wrap { display: flex; align-items: center; border: 1.5px solid var(--border); border-radius: 8px; overflow: hidden; width: fit-content; background: #fff; }
        .qty-btn { width: 32px; height: 36px; background: none; border: none; font-size: 1.1rem; color: var(--mid); cursor: pointer; transition: background .15s, color .15s; display: flex; align-items: center; justify-content: center; }
        .qty-btn:hover { background: #fdf0f2; color: var(--pink); }
        .qty-input { width: 42px; height: 36px; border: none; border-left: 1px solid #f0e0e0; border-right: 1px solid #f0e0e0; text-align: center; font-size: .88rem; font-family: 'DM Sans', sans-serif; outline: none; color: var(--dark); -moz-appearance: textfield; }
        .qty-input::-webkit-outer-spin-button, .qty-input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
        .ci-subtotal { font-size: .95rem; font-weight: 600; color: var(--dark); }
        .ci-remove { background: none; border: none; color: #ddd; padding: 7px; border-radius: 6px; transition: color .15s, background .15s; display: flex; align-items: center; justify-content: center; cursor: pointer; }
        .ci-remove:hover { color: var(--pink); background: #fdf0f2; }
        .cart-bottom-row { display: flex; justify-content: space-between; align-items: center; margin-top: 1.2rem; padding-top: .8rem; }
        .cart-continue-btn { font-size: .82rem; color: var(--mid); border: 1.5px solid var(--border); padding: 10px 22px; border-radius: 8px; transition: border-color .2s, color .2s; background: #fff; cursor: pointer; font-family: 'DM Sans', sans-serif; }
        .cart-continue-btn:hover { border-color: var(--pink); color: var(--pink); }
        .cart-clear-btn { font-size: .78rem; color: #bbb; background: none; border: none; cursor: pointer; font-family: 'DM Sans', sans-serif; transition: color .2s; }
        .cart-clear-btn:hover { color: var(--pink); }
        /* Summary card */
        .cart-summary { background: var(--bg-soft); border: 1px solid var(--border); border-radius: 18px; padding: 1.8rem; position: sticky; top: 84px; }
        .cs-title { font-family: 'Cormorant Garamond', serif; font-size: 1.4rem; font-weight: 600; color: var(--dark); margin-bottom: 1.4rem; }
        .cs-row { display: flex; justify-content: space-between; font-size: .82rem; color: var(--mid); margin-bottom: 10px; }
        .cs-free { color: #3B6D11; font-weight: 600; }
        .cs-divider { border: none; border-top: 1px solid var(--border); margin: 14px 0; }
        .cs-total-row { display: flex; justify-content: space-between; align-items: baseline; }
        .cs-total-label { font-size: .95rem; font-weight: 600; color: var(--dark); }
        .cs-total-amount { font-family: 'Cormorant Garamond', serif; font-size: 1.6rem; font-weight: 600; color: var(--dark); }
        /* Delivery form inside summary */
        .delivery-section { margin-top: 1.2rem; }
        .delivery-title { font-size: .78rem; font-weight: 700; text-transform: uppercase; letter-spacing: .1em; color: var(--muted); margin-bottom: 10px; }
        .delivery-inp { width: 100%; padding: 10px 12px; border: 1.5px solid var(--border); border-radius: 8px; font-size: .82rem; font-family: 'DM Sans', sans-serif; color: var(--dark); background: #fff; outline: none; transition: border-color .18s; margin-bottom: 8px; display: block; }
        .delivery-inp:focus { border-color: var(--pink); }
        .delivery-inp::placeholder { color: #bbb; }
        .delivery-row { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .cs-place-btn { width: 100%; background: var(--pink); color: #fff; border: none; padding: 15px; border-radius: 12px; font-size: .9rem; font-weight: 700; margin-top: 14px; cursor: pointer; transition: opacity .2s; font-family: 'DM Sans', sans-serif; letter-spacing: .04em; }
        .cs-place-btn:hover { opacity: .88; }
        .cs-login-note { font-size: .72rem; color: var(--muted); text-align: center; margin-top: 10px; line-height: 1.6; }
        .cs-login-note a { color: var(--pink); font-weight: 600; }
        .cs-badges { display: flex; gap: 8px; margin-top: 1rem; flex-wrap: wrap; justify-content: center; }
        .cs-badge { font-size: .62rem; color: var(--muted); background: #fff; border: 1px solid var(--border); padding: 4px 10px; border-radius: 20px; display: flex; align-items: center; gap: 4px; }
        /* Cart badge */
        .cart-icon-btn { position: relative; }
        .cart-badge { position: absolute; top: -6px; right: -6px; background: var(--pink); color: #fff; font-size: 10px; font-weight: 600; width: 18px; height: 18px; border-radius: 50%; display: flex; align-items: center; justify-content: center; line-height: 1; }
        /* Cart toast */
        .cart-toast { position: fixed; top: 80px; right: 24px; z-index: 9999; background: #fff; border: 1px solid var(--border); border-radius: 12px; padding: 14px 18px; box-shadow: 0 8px 32px rgba(0,0,0,.12); display: flex; align-items: center; gap: 12px; animation: slideInRight .3s ease; max-width: 320px; border-left: 4px solid var(--pink); }
        @keyframes slideInRight { from { opacity:0; transform:translateX(40px); } to { opacity:1; transform:translateX(0); } }
        .toast-icon { width:36px;height:36px;border-radius:8px;background:#fdf0f2;display:flex;align-items:center;justify-content:center;flex-shrink:0; }
        .toast-label { font-size:.7rem;font-weight:700;color:var(--dark);margin-bottom:2px; }
        .toast-sub { font-size:.65rem;color:var(--muted); }
        /* ═══ ORDER SUCCESS POPUP ═══ */
        .order-popup-overlay { position: fixed; inset: 0; background: rgba(10,4,6,.75); backdrop-filter: blur(8px); z-index: 9000; display: flex; align-items: center; justify-content: center; animation: fadeIn .35s ease; }
        @keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
        .order-popup-box { background: #fff; border-radius: 24px; padding: 3.5rem 3rem 2.8rem; max-width: 480px; width: calc(100% - 2rem); text-align: center; position: relative; overflow: hidden; box-shadow: 0 40px 100px rgba(0,0,0,.3); animation: popSlide .45s cubic-bezier(.22,1,.36,1); }
        @keyframes popSlide { from { opacity:0; transform: translateY(40px) scale(.96); } to { opacity:1; transform: translateY(0) scale(1); } }
        .order-popup-glow { position: absolute; width: 400px; height: 400px; border-radius: 50%; background: radial-gradient(circle, #fdf0f2 0%, transparent 65%); top: -130px; right: -100px; pointer-events: none; }
        .order-popup-check { width: 80px; height: 80px; background: linear-gradient(135deg, #e8536a, #c0424e); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 8px 30px rgba(232,83,106,.4); animation: checkBounce .6s .3s both; }
        @keyframes checkBounce { 0% { transform: scale(0); } 70% { transform: scale(1.15); } 100% { transform: scale(1); } }
        .order-popup-id { font-size: .68rem; font-weight: 700; letter-spacing: .2em; text-transform: uppercase; color: var(--pink); margin-bottom: 8px; }
        .order-popup-title { font-family: 'Cormorant Garamond', serif; font-size: 2.2rem; font-weight: 400; color: var(--dark); line-height: 1.15; margin-bottom: 12px; }
        .order-popup-title em { font-style: italic; color: var(--pink); }
        .order-popup-sub { font-size: .84rem; color: var(--muted); line-height: 1.75; margin-bottom: 2rem; max-width: 340px; margin-left: auto; margin-right: auto; }
        .order-popup-actions { display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; }
        .op-btn-primary { background: var(--dark); color: #fff; padding: 13px 26px; border-radius: 10px; font-size: .84rem; font-weight: 600; font-family: 'DM Sans', sans-serif; transition: background .2s; }
        .op-btn-primary:hover { background: var(--pink); color: #fff; }
        .op-btn-secondary { background: var(--pink-light); color: var(--pink); border: 1.5px solid var(--pink-mid); padding: 13px 26px; border-radius: 10px; font-size: .84rem; font-weight: 600; font-family: 'DM Sans', sans-serif; transition: background .2s; }
        .op-btn-secondary:hover { background: var(--pink); color: #fff; border-color: var(--pink); }
        .order-popup-note { font-size: .68rem; color: #bbb; margin-top: 14px; }
        /* Responsive */
        @media (max-width: 900px) { .cart-layout { flex-direction: column; } .cart-summary-col { width: 100%; } .cart-summary { position: static; } .cart-col-head { display: none; } .cart-item { grid-template-columns: 1fr auto; grid-template-rows: auto auto; } .ci-product { grid-column: 1 / -1; } .ci-unit-price { display: none; } }
        @media (max-width: 600px) { .cart-page { padding: 2rem 1.2rem 4rem; } }
    </style>
</head>
<body>

<!-- ═══ ORDER SUCCESS POPUP ═══ -->
<c:if test="${not empty sessionScope.orderSuccess}">
<div class="order-popup-overlay" id="orderPopup">
    <div class="order-popup-box">
        <div class="order-popup-glow"></div>
        <div class="order-popup-check">
            <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"/>
            </svg>
        </div>
        <div class="order-popup-id">Order #SPR-${sessionScope.orderId} confirmed</div>
        <h2 class="order-popup-title">You're all set,<br><em>beautiful!</em> 🎉</h2>
        <p class="order-popup-sub">
            Your order has been placed successfully. We'll prepare your goodies and deliver them 
            to your doorstep. Payment is Cash on Delivery — no worries!
        </p>
        <div class="order-popup-actions">
            <a href="<%= contextPath %>/products" class="op-btn-primary">Keep Shopping ✦</a>
            <a href="<%= contextPath %>/user/profile?tab=orders" class="op-btn-secondary">Track Order →</a>
        </div>
        <p class="order-popup-note">A confirmation has been noted in your profile under "My Orders"</p>
    </div>
</div>
<c:remove var="orderSuccess" scope="session"/>
<c:remove var="orderId" scope="session"/>
</c:if>

<%-- ═══ CART TOAST POPUP TRIGGER ═══
     Fires when the user is redirected back after adding to cart.
     CartController stores the product details in session.
     This block reads them, shows the popup, then clears the session. --%>
<c:if test="${not empty sessionScope.cartToast}">
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        showCartToast(
            '${sessionScope.cartToast}',
            '${sessionScope.cartToastCategory}',
            ${not empty sessionScope.cartToastPrice ? sessionScope.cartToastPrice : 0},
            '${sessionScope.cartToastImage}',
            '${pageContext.request.contextPath}'
        );
    });
    </script>
    <c:remove var="cartToast"         scope="session"/>
    <c:remove var="cartToastCategory" scope="session"/>
    <c:remove var="cartToastPrice"    scope="session"/>
    <c:remove var="cartToastImage"    scope="session"/>
</c:if>

<!-- ═══ NAV ═══ -->
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
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        </a>
        <a href="<%= contextPath %>/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            <c:if test="${not empty cart and cart.totalCount > 0}">
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

<!-- Add-to-cart toast -->
<c:if test="${not empty sessionScope.cartToast}">
    <div class="cart-toast" id="cartToast">
        <div class="toast-icon"><svg width="16" height="16" viewBox="0 0 24 24" fill="var(--pink)"><path d="M9 16.17 4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg></div>
        <div><div class="toast-label">Added to cart!</div><div class="toast-sub">${sessionScope.cartToast}</div></div>
    </div>
    <c:remove var="cartToast" scope="session"/>
</c:if>

<!-- ═══ CART PAGE ═══ -->
<div class="cart-page">

    <div class="cart-header">
        <h1 class="cart-title">Your <em>Cart</em></h1>
        <p class="cart-subtitle">
            <c:choose>
                <c:when test="${empty cart or empty cart.items}">Your cart is empty</c:when>
                <c:otherwise>${cart.totalCount} item<c:if test="${cart.totalCount != 1}">s</c:if> waiting for you</c:otherwise>
            </c:choose>
        </p>
    </div>

    <!-- Error message -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty cart or empty cart.items}">
            <div class="cart-empty">
                <div class="cart-empty-ring">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#e8d8da" stroke-width="1.2">
                        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 0 1-8 0"/>
                    </svg>
                </div>
                <h2 class="cart-empty-title">Nothing here yet</h2>
                <p class="cart-empty-sub">Discover our collection and add something beautiful.</p>
                <a href="<%= contextPath %>/products" class="cart-empty-btn">Browse Products &rarr;</a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="cart-layout">

                <!-- LEFT: items -->
                <div class="cart-items-col">
                    <div class="cart-col-head">
                        <span class="cch-label">Product</span>
                        <span class="cch-label">Price</span>
                        <span class="cch-label">Quantity</span>
                        <span class="cch-label">Subtotal</span>
                        <span></span>
                    </div>

                    <c:forEach var="item" items="${cart.items}">
                        <div class="cart-item">
                            <div class="ci-product">
                                <div class="ci-img">
                                    <c:choose>
                                        <c:when test="${not empty item.imagePath}">
                                            <img src="${pageContext.request.contextPath}/assets/images/products/${item.imagePath}" alt="${item.name}">
                                        </c:when>
                                        <c:otherwise><span class="ci-img-ph">&#128138;</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <p class="ci-cat">${item.categoryName}</p>
                                    <p class="ci-name">${item.name}</p>
                                </div>
                            </div>
                            <p class="ci-unit-price">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></p>
                            <form action="<%= contextPath %>/cart/update" method="post">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <div class="ci-qty-wrap">
                                    <button type="button" class="qty-btn" onclick="adjustQty(this,-1)">&#8722;</button>
                                    <input type="number" name="qty" class="qty-input" value="${item.quantity}" min="0" max="99" onchange="this.form.submit()">
                                    <button type="button" class="qty-btn" onclick="adjustQty(this,1)">&#43;</button>
                                </div>
                            </form>
                            <p class="ci-subtotal">Rs <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></p>
                            <form action="<%= contextPath %>/cart/remove" method="post">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <button type="submit" class="ci-remove" title="Remove">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                                </button>
                            </form>
                        </div>
                    </c:forEach>

                    <div class="cart-bottom-row">
                        <a href="<%= contextPath %>/products" class="cart-continue-btn">&larr; Continue Shopping</a>
                        <form action="<%= contextPath %>/cart/clear" method="post">
                            <button type="submit" class="cart-clear-btn" onclick="return confirm('Clear entire cart?')">Clear Cart</button>
                        </form>
                    </div>
                </div>

                <!-- RIGHT: summary + delivery form -->
                <div class="cart-summary-col">
                    <div class="cart-summary">
                        <h2 class="cs-title">Order Summary</h2>

                        <div class="cs-row"><span>Subtotal (${cart.totalCount} items)</span><span>Rs <fmt:formatNumber value="${cart.grandTotal}" pattern="#,##0.00"/></span></div>
                        <div class="cs-row"><span>Shipping</span><span class="cs-free">Free</span></div>
                        <div class="cs-row"><span>Payment</span><span>Cash on Delivery</span></div>

                        <hr class="cs-divider">
                        <div class="cs-total-row">
                            <span class="cs-total-label">Total</span>
                            <span class="cs-total-amount">Rs <fmt:formatNumber value="${cart.grandTotal}" pattern="#,##0.00"/></span>
                        </div>
                        <hr class="cs-divider">

                        <c:choose>
                            <c:when test="${not empty currentUser}">
                                <form action="<%= contextPath %>/order/place" method="post" id="orderForm" onsubmit="return validateOrder()">
                                    <input type="hidden" name="totalAmount" value="${cart.grandTotal}">

                                    <div class="delivery-section">
                                        <div class="delivery-title">Delivery Details</div>
                                        <input type="text" name="fullName" class="delivery-inp" placeholder="Full Name *" required>
                                        <input type="text" name="phone" class="delivery-inp" placeholder="Phone Number *" required>
                                        <input type="text" name="address" class="delivery-inp" placeholder="Street Address *" required>
                                        <input type="text" name="city" class="delivery-inp" placeholder="City *" required>
                                    </div>

                                    <button type="submit" class="cs-place-btn">
                                        ✦ Place Order (COD)
                                    </button>
                                </form>
                            </c:when>
                            <c:otherwise>
                                <div style="margin-top:1rem;">
                                    <button type="button" class="cs-place-btn" onclick="location.href='<%= contextPath %>/login'">
                                        Login to Place Order
                                    </button>
                                    <p class="cs-login-note">
                                        <a href="<%= contextPath %>/login">Sign in</a> or
                                        <a href="<%= contextPath %>/register">create an account</a> to checkout.
                                    </p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="cs-badges">
                            <span class="cs-badge">&#128274; Secure</span>
                            <span class="cs-badge">&#9989; Free returns</span>
                            <span class="cs-badge">&#128666; Free ship</span>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div class="footer-brand-col">
                <div class="footer-logo">SΡRA<span>.</span></div>
                <p class="footer-tagline">Luxury cosmetics crafted with love.</p>
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
function adjustQty(btn, delta) {
    var form  = btn.closest('form');
    var input = form.querySelector('.qty-input');
    var val   = Math.max(1, parseInt(input.value || 1) + delta);
    input.value = val;
    form.submit();
}
function validateOrder() {
    var inputs = document.querySelectorAll('#orderForm input[required]');
    for (var i = 0; i < inputs.length; i++) {
        if (!inputs[i].value.trim()) {
            alert('Please fill in all delivery details before placing your order.');
            inputs[i].focus();
            return false;
        }
    }
    return true;
}
document.addEventListener('DOMContentLoaded', function () {
    // Close popup on overlay click
    var popup = document.getElementById('orderPopup');
    if (popup) {
        popup.addEventListener('click', function(e) {
            if (e.target === popup) popup.remove();
        });
    }
    // Auto-dismiss cart toast
    var toast = document.getElementById('cartToast');
    if (toast) {
        setTimeout(function() {
            toast.style.transition = 'opacity .5s';
            toast.style.opacity = '0';
            setTimeout(function() { if(toast.parentNode) toast.parentNode.removeChild(toast); }, 500);
        }, 3500);
    }
});
</script>
</body>
</html>
