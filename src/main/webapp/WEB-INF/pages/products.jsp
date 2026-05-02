<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle",  "Products");
    request.setAttribute("pageCSS",    "products");
    request.setAttribute("activePage", "products");

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
    <title>Spra. – Products</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/products.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body>

<!-- ===== NAVIGATION ===== -->
<nav class="nav">
    <div class="nav-logo">SΡRA<span class="nav-dot">.</span></div>
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

<%--
    Build base URLs that carry all currently-active filters forward.
    Each sidebar link only swaps its own dimension and keeps the others.
--%>
<c:set var="cp" value="${pageContext.request.contextPath}"/>

<%-- Active filter indicator shown in header --%>
<c:set var="hasFilter" value="${not empty categoryId or not empty priceRange or not empty keyword}"/>

<div class="products-page">

    <!-- Page header -->
    <div class="pp-header">
        <p class="pp-brand">Spra Beauty</p>
        <h1 class="pp-title">Our Products</h1>
        <p class="pp-sub">Explore our curated collection of premium beauty essentials</p>
    </div>

    <!-- Search + sort bar -->
    <div class="pp-search-row">
        <form action="<%= contextPath %>/products" method="get" class="pp-search-form">
            <%-- Keep category when searching --%>
            <c:if test="${not empty categoryId}">
                <input type="hidden" name="category" value="${categoryId}"/>
            </c:if>
            <input type="text" name="search" class="pp-search-input"
                   placeholder="Search products..."
                   value="<c:out value='${keyword}'/>"/>
            <button type="submit" class="pp-search-btn">Search</button>
        </form>

        <%-- Sort dropdown — submits via GET, keeping all current params --%>
        <form action="<%= contextPath %>/products" method="get" id="sortForm" style="display:inline">
            <c:if test="${not empty categoryId}"><input type="hidden" name="category"  value="${categoryId}"/></c:if>
            <c:if test="${not empty priceRange}"> <input type="hidden" name="price"     value="${priceRange}"/></c:if>
            <c:if test="${not empty keyword}">    <input type="hidden" name="search"    value="${keyword}"/></c:if>
            <select name="sort" class="pp-sort" onchange="document.getElementById('sortForm').submit()">
                <option value=""          ${empty sortBy              ? 'selected' : ''}>Default</option>
                <option value="price-asc" ${'price-asc'  == sortBy   ? 'selected' : ''}>Price: Low to High</option>
                <option value="price-desc"${'price-desc' == sortBy   ? 'selected' : ''}>Price: High to Low</option>
                <option value="name-asc"  ${'name-asc'   == sortBy   ? 'selected' : ''}>Name: A–Z</option>
            </select>
        </form>
    </div>

    <%-- Active filter chips --%>
    <c:if test="${hasFilter}">
        <div class="pp-chips">
            <c:if test="${not empty keyword}">
                <span class="pp-chip">
                    Search: "<c:out value='${keyword}'/>"
                    <a href="${cp}/products<c:if test='${not empty categoryId}'>?category=${categoryId}</c:if><c:if test='${not empty priceRange}'>${not empty categoryId ? '&amp;' : '?'}price=${priceRange}</c:if>" class="pp-chip-x">&times;</a>
                </span>
            </c:if>
            <c:if test="${not empty categoryId}">
                <c:forEach var="cat" items="${categories}">
                    <c:if test="${cat.categoryId == categoryId}">
                        <span class="pp-chip">
                            ${cat.name}
                            <a href="${cp}/products<c:if test='${not empty priceRange}'>?price=${priceRange}</c:if><c:if test='${not empty keyword}'>${not empty priceRange ? '&amp;' : '?'}search=${keyword}</c:if>" class="pp-chip-x">&times;</a>
                        </span>
                    </c:if>
                </c:forEach>
            </c:if>
            <c:if test="${not empty priceRange}">
                <span class="pp-chip">
                    <c:choose>
                        <c:when test="${priceRange == 'under2500'}">Under Rs 2,500</c:when>
                        <c:when test="${priceRange == '2500to4000'}">Rs 2,500 – 4,000</c:when>
                        <c:when test="${priceRange == '4000to6000'}">Rs 4,000 – 6,000</c:when>
                        <c:when test="${priceRange == 'over6000'}">Over Rs 6,000</c:when>
                    </c:choose>
                    <a href="${cp}/products<c:if test='${not empty categoryId}'>?category=${categoryId}</c:if><c:if test='${not empty keyword}'>${not empty categoryId ? '&amp;' : '?'}search=${keyword}</c:if>" class="pp-chip-x">&times;</a>
                </span>
            </c:if>
            <a href="${cp}/products" class="pp-clear-all">Clear all</a>
        </div>
    </c:if>

    <div class="pp-layout">

        <!-- ── SIDEBAR ── -->
        <aside class="pp-sidebar">

            <!-- Categories -->
            <h3 class="pp-sidebar-title">Categories</h3>
            <ul class="pp-cat-list">
                <%-- "All" clears the category but keeps price + sort --%>
                <li class="pp-cat-item ${empty categoryId ? 'active' : ''}">
                    <a href="${cp}/products<c:if test='${not empty priceRange}'>?price=${priceRange}</c:if><c:if test='${not empty sortBy}'>${not empty priceRange ? '&amp;' : '?'}sort=${sortBy}</c:if>">All</a>
                </li>
                <c:forEach var="cat" items="${categories}">
                    <%-- Each category link keeps the current price filter + sort --%>
                    <c:set var="catActive" value="${categoryId == cat.categoryId}"/>
                    <li class="pp-cat-item ${catActive ? 'active' : ''}">
                        <a href="${cp}/products?category=${cat.categoryId}<c:if test='${not empty priceRange}'>&amp;price=${priceRange}</c:if><c:if test='${not empty sortBy}'>&amp;sort=${sortBy}</c:if>">${cat.name}</a>
                    </li>
                </c:forEach>
            </ul>

            <!-- Price Range -->
            <h3 class="pp-sidebar-title">Price Range</h3>
            <ul class="pp-price-list">
                <%-- "All Prices" clears price but keeps category + sort --%>
                <li class="pp-price-item ${empty priceRange ? 'active' : ''}">
                    <a href="${cp}/products<c:if test='${not empty categoryId}'>?category=${categoryId}</c:if><c:if test='${not empty sortBy}'>${not empty categoryId ? '&amp;' : '?'}sort=${sortBy}</c:if>">All Prices</a>
                </li>
                <li class="pp-price-item ${'under2500'  == priceRange ? 'active' : ''}">
                    <a href="${cp}/products?price=under2500<c:if test='${not empty categoryId}'>&amp;category=${categoryId}</c:if><c:if test='${not empty sortBy}'>&amp;sort=${sortBy}</c:if>">Under Rs 2,500</a>
                </li>
                <li class="pp-price-item ${'2500to4000' == priceRange ? 'active' : ''}">
                    <a href="${cp}/products?price=2500to4000<c:if test='${not empty categoryId}'>&amp;category=${categoryId}</c:if><c:if test='${not empty sortBy}'>&amp;sort=${sortBy}</c:if>">Rs 2,500 – 4,000</a>
                </li>
                <li class="pp-price-item ${'4000to6000' == priceRange ? 'active' : ''}">
                    <a href="${cp}/products?price=4000to6000<c:if test='${not empty categoryId}'>&amp;category=${categoryId}</c:if><c:if test='${not empty sortBy}'>&amp;sort=${sortBy}</c:if>">Rs 4,000 – 6,000</a>
                </li>
                <li class="pp-price-item ${'over6000'   == priceRange ? 'active' : ''}">
                    <a href="${cp}/products?price=over6000<c:if test='${not empty categoryId}'>&amp;category=${categoryId}</c:if><c:if test='${not empty sortBy}'>&amp;sort=${sortBy}</c:if>">Over Rs 6,000</a>
                </li>
            </ul>

        </aside>

        <!-- ── MAIN GRID ── -->
        <main class="pp-main">
            <p class="pp-count">${totalCount} product<c:if test="${totalCount != 1}">s</c:if> found</p>

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="pp-grid" id="productGrid">
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="pp-empty-state">
                            <div class="pp-empty-icon">&#128128;</div>
                            <p class="pp-empty">No products match your filters.</p>
                            <a href="<%= contextPath %>/products" class="pp-empty-reset">Clear filters</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="product" items="${products}">
                            <a href="<%= contextPath %>/productDetail?id=${product.productId}"
                               style="text-decoration:none;color:inherit;">
                                <div class="pp-card" data-price="${product.price}" data-name="${product.name}">

                                    <c:if test="${product.discountPercent > 0}">
                                        <span class="discount-badge">-${product.discountPercent}%</span>
                                    </c:if>

                                    <div class="pp-img">
                                        <c:choose>
                                            <c:when test="${not empty product.imagePath}">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}"
                                                     alt="${product.name}" class="pp-product-img">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="pp-img-placeholder">&#128138;</div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${product.outOfStock}">
                                            <div class="out-of-stock-badge">Out of Stock</div>
                                        </c:if>
                                    </div>

                                    <div class="pp-card-body">
                                        <p class="product-cat">${product.categoryName}</p>
                                        <h3 class="product-name">${product.name}</h3>
                                        <div class="product-price-row">
                                            <span class="product-price">Rs <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                                            <c:if test="${product.oldPrice > 0}">
                                                <span class="product-price-old">Rs <fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                                            </c:if>
                                        </div>
                                        <form action="<%= contextPath %>/cart/add" method="post" style="margin-top:15px">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <input type="hidden" name="qty" value="1">
                                            <button type="submit" class="add-to-cart-btn"
                                                    onclick="event.stopPropagation();"
                                                    <c:if test="${product.outOfStock}">disabled</c:if>>
                                                <c:choose>
                                                    <c:when test="${product.outOfStock}">Out of Stock</c:when>
                                                    <c:otherwise>Add to Cart</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </a>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
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
