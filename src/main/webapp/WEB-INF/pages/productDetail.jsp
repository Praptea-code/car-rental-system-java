<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${product.name} — Spra</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>

    <!-- Global styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <!-- Page-specific styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetail.css"/>
</head>
<body>



<!-- ============================================================
     NAVIGATION
     ============================================================ -->
<nav class="nav">
    <a href="${pageContext.request.contextPath}/home" class="nav-logo">
        SPR<span class="nav-dot">A</span>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="${pageContext.request.contextPath}/products" class="active">Products</a>
        <a href="${pageContext.request.contextPath}/about">About</a>
        <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </div>

    <div class="nav-right">
        <!-- Cart icon -->
        <a href="${pageContext.request.contextPath}/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                <line x1="3" y1="6" x2="21" y2="6"/>
                <path d="M16 10a4 4 0 0 1-8 0"/>
            </svg>
            <c:if test="${not empty cart and cart.totalCount > 0}">
                <span class="cart-badge">${cart.totalCount}</span>
            </c:if>
        </a>

        <c:choose>
            <c:when test="${not empty loggedInUser}">
                <div class="nav-user-wrap">
                    <span class="nav-username">${loggedInUser.firstName}</span>
                    <c:if test="${userRole == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-admin-btn">Admin</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/user/profile" class="nav-profile-btn">Profile</a>
                    <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline;">
                        <button type="submit" class="nav-logout-btn">Logout</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login" class="nav-login-btn">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->
<main class="pd-page">

    <!-- Breadcrumb -->
    <nav class="pd-breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <span class="pd-breadcrumb-sep">›</span>
        <a href="${pageContext.request.contextPath}/products">Products</a>
        <c:if test="${not empty product.categoryName}">
            <span class="pd-breadcrumb-sep">›</span>
            <a href="${pageContext.request.contextPath}/products?category=${product.categoryId}">${product.categoryName}</a>
        </c:if>
        <span class="pd-breadcrumb-sep">›</span>
        <span class="pd-breadcrumb-current">${product.name}</span>
    </nav>

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- ── PRODUCT MAIN ── -->
    <div class="pd-main">

        <!-- Image Panel -->
        <div class="pd-image-panel" id="imagePanel">
            <c:choose>
                <c:when test="${not empty product.imagePath}">
                    <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}" alt="${product.name}"
     					class="pd-img-main"/>
                    <div class="pd-img-placeholder" id="imgFallback" style="display:none;">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#e0c8c8" stroke-width="1">
                            <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/>
                            <polyline points="21 15 16 10 5 21"/>
                        </svg>
                        <span>No image</span>
                    </div>
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

            <!-- Price -->
            <div class="pd-price-row">
                <span class="pd-price">
                    Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/>
                </span>
                <c:if test="${product.oldPrice > 0 and product.oldPrice > product.price}">
                    <span class="pd-price-old">
                        Rs. <fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/>
                    </span>
                    <span class="pd-price-save">Save ${product.discountPercent}%</span>
                </c:if>
            </div>

            <!-- Trust badges -->
            <div class="pd-trust-row">
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                    </svg>
                    <span>100% Authentic</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                    </svg>
                    <span>Fast Delivery</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>
                    </svg>
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
                            <span style="font-size:12px; color:#888;">— only ${product.stock} left</span>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Description excerpt -->
            <c:if test="${not empty product.description}">
                <p class="pd-description">${product.description}</p>
            </c:if>

            <div class="pd-divider"></div>

            <!-- Add to cart form -->
            <c:choose>
                <c:when test="${not empty loggedInUser}">
                    <form action="${pageContext.request.contextPath}/cart/add" method="post" id="addToCartForm">
                        <input type="hidden" name="productId" value="${product.productId}"/>

                        <!-- Quantity -->
                        <div class="pd-qty-row">
                            <label class="pd-qty-label">Quantity</label>
                            <div class="pd-qty-wrap">
                                <button type="button" class="pd-qty-btn" onclick="changeQty(-1)" ${product.outOfStock ? 'disabled' : ''}>−</button>
                                <input type="number" name="qty" id="qtyInput" value="1" min="1"
                                       max="${product.stock > 0 ? product.stock : 1}"
                                       class="pd-qty-val"
                                       ${product.outOfStock ? 'disabled' : ''}/>
                                <button type="button" class="pd-qty-btn" onclick="changeQty(1)" ${product.outOfStock ? 'disabled' : ''}>+</button>
                            </div>
                        </div>

                        <!-- Action buttons -->
                        <div class="pd-actions">
                            <button type="submit" class="pd-btn-cart" ${product.outOfStock ? 'disabled' : ''}>
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
                            <button type="button" class="pd-btn-wishlist" title="Wishlist" onclick="toggleWishlist(this)">
                                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
                                </svg>
                            </button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <!-- Not logged in -->
                    <div style="margin-bottom: 20px;">
                        <a href="${pageContext.request.contextPath}/login"
                           style="display:flex; align-items:center; justify-content:center; gap:8px; width:100%; background:#1a1a1a; color:#fff; border:none; padding:14px 20px; border-radius:10px; font-size:14px; font-weight:500; font-family:'DM Sans',sans-serif; text-decoration:none; transition:background .2s;"
                           onmouseover="this.style.background='#e8536a'"
                           onmouseout="this.style.background='#1a1a1a'">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                                <polyline points="10 17 15 12 10 7"/>
                                <line x1="15" y1="12" x2="3" y2="12"/>
                            </svg>
                            Login to Add to Cart
                        </a>
                        <p style="font-size:12px; color:#aaa; text-align:center; margin-top:8px;">
                            <a href="${pageContext.request.contextPath}/register" style="color:#e8536a;">Create an account</a> to start shopping
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="pd-divider"></div>

            <!-- Meta info -->
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
                        <span class="pd-meta-value" style="color:#e8536a;"> Featured Product</span>
                    </div>
                </c:if>
                <c:if test="${product.bestseller}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Status</span>
                        <span class="pd-meta-value" style="color:#e8536a;"> Bestseller</span>
                    </div>
                </c:if>
                <div class="pd-meta-row">
                    <span class="pd-meta-key">Product ID</span>
                    <span class="pd-meta-value" style="font-family:monospace; font-size:12px;">#SPR-${product.productId}</span>
                </div>
            </div>

        </div><!-- /pd-info-panel -->
    </div><!-- /pd-main -->

    <!-- ── TABS ── -->
    <div class="pd-tabs">
        <div class="pd-tab-nav">
        	<button class="pd-tab-btn active" onclick="switchTab(event, 'tab-desc')">Description</button>
        	<button class="pd-tab-btn" onclick="switchTab(event, 'tab-reviews')">Reviews</button>
            
            
        </div>

        <!-- Description Tab -->
        <div id="tab-desc" class="pd-tab-pane active">
            <c:choose>
                <c:when test="${not empty product.description}">
                    <p class="pd-desc-text">${product.description}</p>
                </c:when>
                <c:otherwise>
                    <p class="pd-desc-text" style="color:#aaa; font-style:italic;">No detailed description available for this product.</p>
                </c:otherwise>
            </c:choose>

            <div class="pd-features-title">Key Features</div>
            <div class="pd-features-list">
                <div class="pd-feature-item">
                    <div class="pd-feature-check">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span>Carefully curated and quality-tested by the Spra team</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span>Cruelty-free and ethically sourced ingredients where applicable</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span>Suitable for all skin types — gentle and effective formula</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span>Dermatologist approved and clinically tested</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check">
                        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                    </div>
                    <span>Elegant, eco-conscious packaging that looks beautiful on your shelf</span>
                </div>
            </div>
        </div>


        <!-- Reviews Tab -->
        <div id="tab-reviews" class="pd-tab-pane">
            <div style="text-align:center; padding:3rem 2rem; color:#aaa;">
                <div style="font-family:'Cormorant Garamond',serif; font-size:22px; color:#1a1a1a; margin-bottom:8px;">
                    No reviews yet
                </div>
                <p style="font-size:14px; margin-bottom:20px;">Be the first to share your experience with this product.</p>
                <c:if test="${not empty loggedInUser}">
                    <button style="background:#e8536a; color:#fff; border:none; padding:10px 24px; border-radius:8px; font-size:13px; cursor:pointer; font-family:'DM Sans',sans-serif;">
                        Write a Review
                    </button>
                </c:if>
            </div>
        </div>
    </div><!-- /pd-tabs -->

    <!-- ── RELATED PRODUCTS ── -->
    <c:if test="${not empty relatedProducts}">
        <section class="pd-related">
            <h2 class="pd-related-title">You Might Also Like</h2>
            <p class="pd-related-sub">Discover more from the ${product.categoryName} collection</p>

            <div class="pd-related-grid">
                <c:forEach items="${relatedProducts}" var="rp" varStatus="status">
                    <a href="${pageContext.request.contextPath}/product?id=${rp.productId}"
                       class="product-card" style="text-decoration:none; display:block;">
                        <div class="product-img-area" style="position:relative;">
                            <c:choose>
                                <c:when test="${not empty rp.imagePath}">
                                    <img src="${pageContext.request.contextPath}/assets/images/products/${rp.imagePath}"
     									alt="${rp.name}" class="product-img">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#fdf8f8;color:#ddd;font-size:12px;">
                                        No image
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${rp.discountPercent > 0}">
                                <span class="discount-badge">−${rp.discountPercent}%</span>
                            </c:if>
                            <c:if test="${rp.outOfStock}">
                                <div style="position:absolute;inset:0;background:rgba(255,255,255,0.6);display:flex;align-items:center;justify-content:center;">
                                    <span style="font-size:11px;font-weight:600;color:#888;background:#fff;padding:5px 10px;border-radius:4px;">Out of Stock</span>
                                </div>
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

</main><!-- /pd-page -->

<!-- ============================================================
     FOOTER
     ============================================================ -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div>
                <div class="footer-logo">SPR<span>A</span></div>
                <p class="footer-tagline">Beauty rituals for the modern soul. Curated cosmetics that celebrate your uniqueness.</p>
            </div>
            <div>
                <div class="footer-col-title">Shop</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/products">All Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?featured=true">Featured</a></li>
                    <li><a href="${pageContext.request.contextPath}/home#bestseller">Bestsellers</a></li>
                </ul>
            </div>
            <div>
                <div class="footer-col-title">Company</div>
                <ul class="footer-links">
                    <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                </ul>
            </div>
            <div>
                <div class="footer-col-title">Account</div>
                <ul class="footer-links">
                    <c:choose>
                        <c:when test="${not empty loggedInUser}">
                            <li><a href="${pageContext.request.contextPath}/user/profile">My Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">My Cart</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                            <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <span class="footer-copy">© 2025 Spra. Made with <span class="footer-heart">♥</span> for beauty lovers.</span>
            <div class="footer-legal">
                <a href="#">Privacy</a>
                <a href="#">Terms</a>
            </div>
        </div>
    </div>
</footer>

<!-- ============================================================
     SCRIPTS
     ============================================================ -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* ---- Qty stepper ---- */
function changeQty(delta) {
    var input = document.getElementById('qtyInput');
    if (!input) return;
    var val = parseInt(input.value) || 1;
    var max = parseInt(input.max) || 999;
    var newVal = Math.max(1, Math.min(max, val + delta));
    input.value = newVal;
}

/* ---- Tab switcher ---- */
function switchTab(event, tabId) {
    // Deactivate all
    document.querySelectorAll('.pd-tab-btn').forEach(function(btn) {
        btn.classList.remove('active');
    });
    document.querySelectorAll('.pd-tab-pane').forEach(function(pane) {
        pane.classList.remove('active');
    });
    // Activate selected
    event.currentTarget.classList.add('active');
    var pane = document.getElementById(tabId);
    if (pane) pane.classList.add('active');
}

/* ---- Wishlist toggle (UI only) ---- */
function toggleWishlist(btn) {
    var svg = btn.querySelector('svg');
    if (svg.getAttribute('fill') === 'none') {
        svg.setAttribute('fill', '#e8536a');
        svg.setAttribute('stroke', '#e8536a');
        btn.title = 'Remove from wishlist';
    } else {
        svg.setAttribute('fill', 'none');
        svg.setAttribute('stroke', 'currentColor');
        btn.title = 'Add to wishlist';
    }
}

/* ---- Image zoom on mouse move ---- */
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

/* ---- Cart toast from session ---- */
<c:if test="${not empty sessionScope.cartToast}">
(function() {
    var toast = document.createElement('div');
    toast.style.cssText = 'position:fixed;top:80px;right:24px;z-index:9999;background:#1a1a1a;color:#fff;border-radius:10px;padding:14px 18px;font-size:14px;font-family:DM Sans,sans-serif;box-shadow:0 8px 32px rgba(0,0,0,0.2);display:flex;align-items:center;gap:10px;animation:slideInRight .3s ease;';
    toast.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg><span><strong>${sessionScope.cartToast}</strong> added to cart!</span>';
    document.body.appendChild(toast);
    setTimeout(function() { toast.style.opacity='0'; toast.style.transition='opacity .5s'; setTimeout(function(){ toast.remove(); }, 500); }, 3000);
})();
<c:remove var="cartToast" scope="session"/>
</c:if>
</script>

<style>
@keyframes slideInRight {
    from { opacity: 0; transform: translateX(40px); }
    to   { opacity: 1; transform: translateX(0); }
}
</style>

</body>
</html>
