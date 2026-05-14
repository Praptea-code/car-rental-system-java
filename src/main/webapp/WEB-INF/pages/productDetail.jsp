<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    }
    request.setAttribute("currentUser", currentUser);
    request.setAttribute("activePage", "products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${product.name} — Spra.</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link rel="icon" type="image/svg+xml" href="<%= contextPath %>/assets/images/favicon.svg">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetail.css"/>
    

    <%-- ═══ DEFINE showReviewToast HERE in <head> so it is available
             before any inline DOMContentLoaded callbacks fire ═══ --%>
    <script>
    /* ── Rating state — must be global & early so star onclicks work ── */
    var currentRating = 0;
    var starLabels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

    function setRating(val) {
        currentRating = val;
        var ratingInput = document.getElementById('ratingInput');
        if (ratingInput) ratingInput.value = val;
        var starHint = document.getElementById('starHint');
        if (starHint) starHint.textContent = starLabels[val] || '';
        Array.from(document.querySelectorAll('.rv-star-btn')).forEach(function(btn) {
            var v = parseInt(btn.getAttribute('data-val'));
            btn.classList.toggle('selected', v <= val);
            btn.style.color = v <= val ? '#f5a623' : '#e0d8d8';
        });
    }

    function validateReview() {
        var ratingInput = document.getElementById('ratingInput');
        var rating = ratingInput ? parseInt(ratingInput.value) : 0;
        if (!rating || rating < 1) {
            showReviewToast('Rating Required', 'Please select a star rating before submitting.', 'error');
            return false;
        }
        return true;
    }

    function showReviewToast(title, message, type) {
        var toast        = document.getElementById('reviewToast');
        var toastTitle   = document.getElementById('reviewToastTitle');
        var toastMessage = document.getElementById('reviewToastMessage');
        var toastIcon    = document.getElementById('reviewToastIcon');

        if (!toast) return; /* guard: DOM not ready yet — should not happen after DOMContentLoaded */

        toastTitle.textContent   = title;
        toastMessage.textContent = message;

        toast.classList.remove('error');

        if (type === 'error') {
            toast.classList.add('error');
            toastIcon.textContent = '!';
        } else {
            toastIcon.textContent = '✓';
        }

        toast.classList.add('show');

        setTimeout(function () {
            toast.classList.remove('show');
        }, 4000);
    }
    </script>
</head>
<body>
<%-- ═══ CART TOAST POPUP TRIGGER ═══ --%>
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

<!-- ═══ NAVIGATION ═══ -->
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
        <li><a href="<%= contextPath %>/home">Home</a></li>
        <li><a href="<%= contextPath %>/products" class="active">Products</a></li>
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

<!-- ═══ MAIN CONTENT ═══ -->
<main class="pd-page">

    <!-- Breadcrumb -->
    <nav class="pd-breadcrumb">
        <a href="<%= contextPath %>/home">Home</a>
        <span class="pd-breadcrumb-sep">›</span>
        <a href="<%= contextPath %>/products">Products</a>
        <c:if test="${not empty product.categoryName}">
            <span class="pd-breadcrumb-sep">›</span>
            <a href="<%= contextPath %>/products?category=${product.categoryId}">${product.categoryName}</a>
        </c:if>
        <span class="pd-breadcrumb-sep">›</span>
        <span class="pd-breadcrumb-current">${product.name}</span>
    </nav>

    <c:if test="${not empty sessionScope.reviewSuccess}">
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        showReviewToast('Success', '${sessionScope.reviewSuccess}', 'success');
    });
    </script>
    <c:remove var="reviewSuccess" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.reviewError}">
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        showReviewToast('Error', '${sessionScope.reviewError}', 'error');
    });
    </script>
    <c:remove var="reviewError" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.successMessage}">
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        showReviewToast('Success', '${sessionScope.successMessage}', 'success');
    });
    </script>
    <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.wishlistToast}">
        <script>
        document.addEventListener('DOMContentLoaded', function () {
            showWishlistToast(
                '${sessionScope.wishlistToast}',
                '${sessionScope.wishlistToastName}',
                '${sessionScope.wishlistToastImage}',
                '${pageContext.request.contextPath}'
            );
        });
        </script>
        <c:remove var="wishlistToast"      scope="session"/>
        <c:remove var="wishlistToastName"  scope="session"/>
        <c:remove var="wishlistToastImage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        showReviewToast('Error', '${sessionScope.errorMessage}', 'error');
    });
    </script>
    <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- ── PRODUCT MAIN ── -->
    <div class="pd-main">

        <!-- Image Panel -->
        <div class="pd-image-panel" id="imagePanel">
            <c:choose>
                <c:when test="${not empty product.imagePath}">
                    <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}"
                         alt="${product.name}" class="pd-img-main" id="mainProductImg"/>
                </c:when>
                <c:otherwise>
                    <div class="pd-img-placeholder">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#e0c8c8" stroke-width="1">
                            <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/>
                            <polyline points="21 15 16 10 5 21"/>
                        </svg>
                        <span>No image available</span>
                    </div>
                </c:otherwise>
            </c:choose>
            <c:if test="${product.discountPercent > 0}">
                <div class="pd-discount-badge">−${product.discountPercent}%</div>
            </c:if>
            <c:if test="${product.outOfStock}">
                <div class="pd-stock-badge-oos">Out of Stock</div>
            </c:if>
        </div>

        <!-- Info Panel -->
        <div class="pd-info-panel">

            <c:if test="${not empty product.categoryName}">
                <span class="pd-category-tag">${product.categoryName}</span>
            </c:if>

            <h1 class="pd-title">${product.name}</h1>

            <!-- Star rating snapshot -->
            <c:if test="${reviewCount > 0}">
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;">
                    <div class="rv-stars-row" style="justify-content:flex-start;">
                        <c:forEach begin="1" end="5" var="s">
                            <span class="rv-star <c:if test="${s <= avgRating}">filled</c:if>">&#9733;</span>
                        </c:forEach>
                    </div>
                    <span style="font-size:13px;color:var(--muted);">
                        <fmt:formatNumber value="${avgRating}" pattern="#.#"/>
                        (${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if>)
                    </span>
                </div>
            </c:if>

            <!-- Price -->
            <div class="pd-price-row">
                <span class="pd-price">Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                <c:if test="${not empty product.oldPrice and product.oldPrice > 0 and product.oldPrice > product.price}">
                    <span class="pd-price-old">Rs. <fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                    <span class="pd-price-save">Save ${product.discountPercent}%</span>
                </c:if>
            </div>

            <!-- Trust badges -->
            <div class="pd-trust-row">
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <span>100% Authentic</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    <span>Fast Delivery</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                    <span>Easy Returns</span>
                </div>
            </div>

            <!-- Stock status -->
            <div class="pd-stock-row">
                <span class="pd-stock-dot ${product.outOfStock ? 'pd-stock-dot--out' : 'pd-stock-dot--in'}"></span>
                <c:choose>
                    <c:when test="${product.outOfStock}">
                        <span class="pd-stock-label--out">Out of stock</span>
                    </c:when>
                    <c:otherwise>
                        <span class="pd-stock-label--in">In stock</span>
                        <c:if test="${product.stock > 0 and product.stock <= 10}">
                            <span style="font-size:12px;color:#888;">— only ${product.stock} left</span>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Description -->
            <c:if test="${not empty product.description}">
                <p class="pd-description">${product.description}</p>
            </c:if>

            <div class="pd-divider"></div>

            <!-- Quantity stepper — always visible -->
            <div class="pd-qty-row">
                <label class="pd-qty-label">Quantity</label>
                <div class="pd-qty-wrap">
                    <button type="button" class="pd-qty-btn" onclick="changeQty(-1)"
                            <c:if test="${product.outOfStock}">disabled</c:if>>−</button>
                    <input type="number" id="qtyInput" value="1" min="1"
                           max="${product.stock > 0 ? product.stock : 1}"
                           class="pd-qty-val"
                           <c:if test="${product.outOfStock}">disabled</c:if>
                           oninput="syncQty()"/>
                    <button type="button" class="pd-qty-btn" onclick="changeQty(1)"
                            <c:if test="${product.outOfStock}">disabled</c:if>>+</button>
                </div>
            </div>

            <div class="pd-actions" style="display:flex; gap:10px; align-items:stretch; margin-bottom:20px;">

                <%-- ── Add to Cart — no login required ── --%>
                <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
                    <input type="hidden" name="productId" value="${product.productId}"/>
                    <input type="hidden" name="qty" id="qtyHidden" value="1"/>
                    <button type="submit" class="pd-btn-cart" style="width:100%;"
                            <c:if test="${product.outOfStock}">disabled</c:if>
                            onclick="syncQty()">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                            <line x1="3" y1="6" x2="21" y2="6"/>
                            <path d="M16 10a4 4 0 0 1-8 0"/>
                        </svg>
                        <c:choose>
                            <c:when test="${product.outOfStock}">Unavailable</c:when>
                            <c:otherwise>Add to Cart</c:otherwise>
                        </c:choose>
                    </button>
                </form>

                <%-- ── Buy Now — login required ── --%>
                <c:if test="${not product.outOfStock}">
                    <c:choose>
                        <c:when test="${not empty currentUser}">
                            <form action="${pageContext.request.contextPath}/buy-now" method="post" style="flex:1;">
                                <input type="hidden" name="productId" value="${product.productId}"/>
                                <input type="hidden" name="qty" id="qtyBuyNow" value="1"/>
                                <button type="submit" class="pd-btn-buy-now" style="width:100%;" onclick="syncQty()">
                                    ✦ Buy Now
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login"
                               class="pd-btn-buy-now"
                               style="flex:1; text-decoration:none;">
                                ✦ Buy Now
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <%-- ── Wishlist heart — login required ── --%>
                <c:choose>
                    <c:when test="${not empty currentUser}">
                        <form action="${pageContext.request.contextPath}/wishlist/${isWishlisted ? 'remove' : 'add'}"
                              method="post" style="flex-shrink:0;">
                            <input type="hidden" name="productId" value="${product.productId}"/>
                            <button type="submit"
                                    class="pd-btn-wishlist ${isWishlisted ? 'wishlisted' : ''}"
                                    title="${isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}"
                                    style="width:50px; height:100%;">
                                <svg width="20" height="20" viewBox="0 0 24 24"
                                     fill="${isWishlisted ? '#e8536a' : 'none'}"
                                     stroke="${isWishlisted ? '#e8536a' : 'currentColor'}"
                                     stroke-width="1.8">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                </svg>
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login"
                           class="pd-btn-wishlist"
                           title="Login to add to wishlist"
                           style="width:50px; height:50px; text-decoration:none; display:flex; align-items:center; justify-content:center;">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                            </svg>
                        </a>
                    </c:otherwise>
                </c:choose>

            </div>

            <%-- Small nudge shown only to guests --%>
            <c:if test="${empty currentUser}">
                <p style="font-size:12px; color:#aaa; margin-bottom:20px; line-height:1.6;">
                    <a href="${pageContext.request.contextPath}/login"
                       style="color:#e8536a; font-weight:600;">Sign in</a>
                    or
                    <a href="${pageContext.request.contextPath}/register"
                       style="color:#e8536a; font-weight:600;">create an account</a>
                    to use Buy Now, Wishlist &amp; track your orders.
                </p>
            </c:if>

            <div class="pd-divider"></div>

            <!-- Meta -->
            <div class="pd-meta">
                <c:if test="${not empty product.categoryName}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Category</span>
                        <span class="pd-meta-value">${product.categoryName}</span>
                    </div>
                </c:if>
                <c:if test="${product.featured}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Featured</span>
                        <span class="pd-meta-value" style="color:#e8536a;">✦ Featured Product</span>
                    </div>
                </c:if>
                <c:if test="${product.bestseller}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Status</span>
                        <span class="pd-meta-value" style="color:#e8536a;">✦ Bestseller</span>
                    </div>
                </c:if>
                <div class="pd-meta-row">
                    <span class="pd-meta-key">Product ID</span>
                    <span class="pd-meta-value" style="font-family:monospace;font-size:12px;">#SPR-${product.productId}</span>
                </div>
            </div>

        </div><%-- /pd-info-panel --%>
    </div><%-- /pd-main --%>

    <!-- ── TABS ── -->
    <div class="pd-tabs" id="pdTabs">
        <div class="pd-tab-nav">
            <button class="pd-tab-btn active" onclick="switchTab(event,'tab-desc')">Description</button>
            <button class="pd-tab-btn" onclick="switchTab(event,'tab-reviews')" id="reviewsTabBtn">
                Reviews
                <c:if test="${reviewCount > 0}">
                    <span style="background:#e8536a;color:#fff;font-size:10px;padding:1px 7px;border-radius:10px;margin-left:6px;font-family:'DM Sans',sans-serif;">${reviewCount}</span>
                </c:if>
            </button>
        </div>

        <!-- Description Tab -->
        <div id="tab-desc" class="pd-tab-pane active">
            <c:choose>
                <c:when test="${not empty product.description}">
                    <p class="pd-desc-text">${product.description}</p>
                </c:when>
                <c:otherwise>
                    <p class="pd-desc-text" style="color:#aaa;font-style:italic;">No detailed description available.</p>
                </c:otherwise>
            </c:choose>
            <div class="pd-features-title">Key Features</div>
            <div class="pd-features-list">
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Carefully curated and quality-tested by the Spra team</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Cruelty-free and ethically sourced ingredients where applicable</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Suitable for all skin types — gentle and effective formula</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Dermatologist approved and clinically tested</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Elegant, eco-conscious packaging that looks beautiful on your shelf</span>
                </div>
            </div>
        </div>

        <!-- Reviews Tab -->
        <div id="tab-reviews" class="pd-tab-pane">

            <c:if test="${reviewCount > 0}">
                <div class="rv-summary">
                    <div class="rv-big-score">
                        <div class="rv-big-num"><fmt:formatNumber value="${avgRating}" pattern="#.#"/></div>
                        <div class="rv-stars-row">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="rv-star <c:if test="${s <= avgRating}">filled</c:if>">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="rv-total-lbl">${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if></div>
                    </div>
                    <div class="rv-bars">
                        <c:forEach begin="0" end="4" var="i">
                            <c:set var="starNum" value="${5 - i}"/>
                            <c:set var="cnt" value="${ratingDist[starNum - 1]}"/>
                            <c:set var="pct" value="${reviewCount > 0 ? (cnt * 100 / reviewCount) : 0}"/>
                            <div class="rv-bar-row">
                                <span class="rv-bar-label">${starNum} &#9733;</span>
                                <div class="rv-bar-track">
                                    <div class="rv-bar-fill" style="width:${pct}%"></div>
                                </div>
                                <span class="rv-bar-count">${cnt}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty currentUser}">
                    <div class="rv-login-nudge">
                        <span>Sign in to leave a review for this product.</span>
                        <a href="${pageContext.request.contextPath}/login">Login to Review</a>
                    </div>
                </c:when>
                <c:when test="${alreadyReviewed}">
                    <div class="rv-already">
                        ✓ You've already reviewed this product. Thank you for your feedback!
                    </div>
                </c:when>
                <c:when test="${not canReview}">
                    <div class="rv-login-nudge" style="background:#fdf8f8;">
                        <span>Only customers who have received this product can leave a review.</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rv-form-card">
                        <div class="rv-form-title">Write a Review</div>
                        <form action="${pageContext.request.contextPath}/review/add" method="post" id="reviewForm"
                              onsubmit="return validateReview()">
                            <input type="hidden" name="productId" value="${product.productId}"/>
                            <input type="hidden" name="rating" id="ratingInput" value="0"/>
                            <div class="rv-star-picker" id="starPicker">
                                <c:forEach begin="1" end="5" var="s">
                                    <button type="button" class="rv-star-btn" data-val="${s}"
                                            onclick="setRating(${s})">&#9733;</button>
                                </c:forEach>
                            </div>
                            <div class="rv-star-hint" id="starHint">Click to rate this product</div>
                            <input type="text" name="title" class="rv-inp"
                                   placeholder="Review title (optional)" maxlength="120"/>
                            <textarea name="body" class="rv-inp"
                                      placeholder="Share your experience with this product..." required></textarea>
                            <button type="submit" class="rv-submit-btn">Post Review</button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="rv-empty">
                        <div class="rv-empty-icon">&#9733;</div>
                        <div class="rv-empty-title">No reviews yet</div>
                        <p style="font-size:13px;">Be the first to share your experience!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rv-list">
                        <c:forEach var="rv" items="${reviews}">
                            <div class="rv-card">
                                <div class="rv-card-head">
                                    <div class="rv-avatar">${rv.initials}</div>
                                    <div class="rv-meta">
                                        <div class="rv-name">${rv.fullName}</div>
                                        <div class="rv-date">
                                            <fmt:formatDate value="${rv.createdAt}" pattern="MMM dd, yyyy"/>
                                        </div>
                                    </div>
                                    <div class="rv-rating-stars">
                                        <c:forEach begin="1" end="5" var="s">
                                            <span class="rv-star ${s <= rv.rating ? 'filled' : ''}">&#9733;</span>
                                        </c:forEach>
                                    </div>
                                </div>
                                <c:if test="${not empty rv.title}">
                                    <div class="rv-card-title">${rv.title}</div>
                                </c:if>
                                <div class="rv-card-body"><c:out value="${rv.body}" /></div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div><%-- /tab-reviews --%>
    </div><%-- /pd-tabs --%>

    <!-- ── RELATED PRODUCTS ── -->
    <c:if test="${not empty relatedProducts}">
        <section class="pd-related">
            <h2 class="pd-related-title">You Might Also Like</h2>
            <p class="pd-related-sub">Discover more from the ${product.categoryName} collection</p>
            <div class="pd-related-grid">
                <c:forEach items="${relatedProducts}" var="rp">
                    <a href="${pageContext.request.contextPath}/productDetail?id=${rp.productId}"
                       class="product-card" style="text-decoration:none;display:block;">
                        <div class="product-img-area" style="position:relative;">
                            <c:choose>
                                <c:when test="${not empty rp.imagePath}">
                                    <img src="${pageContext.request.contextPath}/assets/images/products/${rp.imagePath}"
                                         alt="${rp.name}" class="product-img">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#fdf8f8;color:#ddd;font-size:12px;">No image</div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${rp.discountPercent > 0}">
                                <span class="discount-badge">−${rp.discountPercent}%</span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <p class="product-cat">${rp.categoryName}</p>
                            <h3 class="product-name">${rp.name}</h3>
                            <div class="product-price-row">
                                <span class="product-price">Rs. <fmt:formatNumber value="${rp.price}" pattern="#,##0.00"/></span>
                                <c:if test="${rp.oldPrice > 0 and rp.oldPrice > rp.price}">
                                    <span class="product-price-old">Rs. <fmt:formatNumber value="${rp.oldPrice}" pattern="#,##0"/></span>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <%-- ═══ TOAST ELEMENT — must exist in DOM before any toast call ═══ --%>
    <div id="reviewToast" class="review-toast">
        <div class="review-toast-icon" id="reviewToastIcon">✓</div>
        <div class="review-toast-content">
            <div class="review-toast-title" id="reviewToastTitle">Success</div>
            <div class="review-toast-message" id="reviewToastMessage">
                Your review was submitted successfully.
            </div>
        </div>
    </div>

</main>

<!-- ═══ FOOTER ═══ -->
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
                    <li><a href="<%= contextPath %>/products?category=4">Lips</a></li>
                    <li><a href="<%= contextPath %>/products?category=5">Eyes</a></li>
                    <li><a href="<%= contextPath %>/products?category=6">Tools</a></li>
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
            <p class="footer-copy">&copy; 2026 Spra. Made with <span class="footer-heart">&#9829;</span> All rights reserved.</p>
            <div class="footer-legal">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
            </div>
        </div>
    </div>
</footer>

<!-- ═══ SCRIPTS ═══ -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* Sync visible qty to both cart and buy-now hidden fields */
function syncQty() {
    var val = document.getElementById('qtyInput').value;
    var h = document.getElementById('qtyHidden');
    var b = document.getElementById('qtyBuyNow');
    if (h) h.value = val;
    if (b) b.value = val;
}

function changeQty(delta) {
    var input = document.getElementById('qtyInput');
    if (!input) return;
    var val = parseInt(input.value) || 1;
    var max = parseInt(input.max) || 999;
    input.value = Math.max(1, Math.min(max, val + delta));
    syncQty();
}

function switchTab(event, tabId) {
    document.querySelectorAll('.pd-tab-btn').forEach(function(b){ b.classList.remove('active'); });
    document.querySelectorAll('.pd-tab-pane').forEach(function(p){ p.classList.remove('active'); });
    event.currentTarget.classList.add('active');
    var pane = document.getElementById(tabId);
    if (pane) pane.classList.add('active');
}

if (window.location.hash === '#tab-reviews') {
    var btn = document.getElementById('reviewsTabBtn');
    if (btn) btn.click();
}

/* Star hover effects — wired up after DOM is ready */
Array.from(document.querySelectorAll('.rv-star-btn')).forEach(function(btn) {
    btn.addEventListener('mouseenter', function() {
        var hoverVal = parseInt(btn.getAttribute('data-val'));
        document.querySelectorAll('.rv-star-btn').forEach(function(b) {
            b.style.color = parseInt(b.getAttribute('data-val')) <= hoverVal ? '#f5a623' : '#e0d8d8';
        });
        document.getElementById('starHint').textContent = starLabels[hoverVal];
    });
    btn.addEventListener('mouseleave', function() {
        document.querySelectorAll('.rv-star-btn').forEach(function(b) {
            var v = parseInt(b.getAttribute('data-val'));
            b.style.color = v <= currentRating ? '#f5a623' : '#e0d8d8';
        });
        document.getElementById('starHint').textContent =
            currentRating > 0 ? starLabels[currentRating] : 'Click to rate this product';
    });
});

/* Image zoom on hover */
(function() {
    var panel = document.getElementById('imagePanel');
    var img   = document.getElementById('mainProductImg');
    if (!panel || !img) return;
    panel.addEventListener('mousemove', function(e) {
        var rect = panel.getBoundingClientRect();
        var x = ((e.clientX - rect.left) / rect.width  * 100).toFixed(1);
        var y = ((e.clientY - rect.top)  / rect.height * 100).toFixed(1);
        img.style.transformOrigin = x + '% ' + y + '%';
        img.style.transform = 'scale(1.55)';
    });
    panel.addEventListener('mouseleave', function() {
        img.style.transform = 'scale(1)';
        img.style.transformOrigin = 'center center';
    });
})();
</script>

</body>
</html>
