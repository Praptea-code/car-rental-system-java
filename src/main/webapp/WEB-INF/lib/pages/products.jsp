<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("pageTitle",  "Products");
    request.setAttribute("pageCSS",    "products");
    request.setAttribute("activePage", "products");
%>
<%@ include file="header.jsp" %>

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
            <input type="text" name="search" class="pp-search-input"
                   placeholder="Search products..."
                   value="<c:out value='${keyword}'/>"/>
            <button type="submit" class="pp-search-btn">Search</button>
        </form>
        <select class="pp-sort" onchange="sortProducts(this.value)">
            <option value="">Default</option>
            <option value="price-asc">Price: Low to High</option>
            <option value="price-desc">Price: High to Low</option>
        </select>
    </div>

    <div class="pp-layout">

        <!-- Sidebar -->
        <aside class="pp-sidebar">
            <h3 class="pp-sidebar-title">Categories</h3>
            <ul class="pp-cat-list">
                <li class="pp-cat-item <c:if test='${empty categoryId}'>active</c:if>">
                    <a href="<%= contextPath %>/products">All</a>
                </li>
                <c:forEach var="cat" items="${categories}">
                    <li class="pp-cat-item <c:if test='${categoryId == cat.categoryId}'>active</c:if>">
                        <a href="<%= contextPath %>/products?category=${cat.categoryId}">${cat.name}</a>
                    </li>
                </c:forEach>
            </ul>

            <h3 class="pp-sidebar-title">Price Range</h3>
            <ul class="pp-price-list">
                <li class="pp-price-item <c:if test='${empty priceRange}'>active</c:if>">
                    <a href="<%= contextPath %>/products">All Prices</a></li>
                <li class="pp-price-item <c:if test='${priceRange == "under25"}'>active</c:if>">
                    <a href="<%= contextPath %>/products?price=under25">Under $25</a></li>
                <li class="pp-price-item <c:if test='${priceRange == "25to40"}'>active</c:if>">
                    <a href="<%= contextPath %>/products?price=25to40">$25 &#8211; $40</a></li>
                <li class="pp-price-item <c:if test='${priceRange == "40to60"}'>active</c:if>">
                    <a href="<%= contextPath %>/products?price=40to60">$40 &#8211; $60</a></li>
                <li class="pp-price-item <c:if test='${priceRange == "over60"}'>active</c:if>">
                    <a href="<%= contextPath %>/products?price=over60">Over $60</a></li>
            </ul>
        </aside>

        <!-- Main product grid -->
        <main class="pp-main">
            <p class="pp-count">${totalCount} products found</p>

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
                        <p class="pp-empty">No products found. <a href="<%= contextPath %>/products">View all</a></p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="product" items="${products}">
                            <div class="pp-card"
                                 data-price="${product.price}"
                                 data-name="${product.name}">

                                <c:if test="${product.discountPercent > 0}">
                                    <span class="discount-badge">-${product.discountPercent}%</span>
                                </c:if>

                                <div class="pp-img">
                                    <c:choose>
                                        <c:when test="${not empty product.imagePath}">
                                            <img src="${pageContext.request.contextPath}/images/products/${product.imagePath}"
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
                                        <span class="product-price">$<fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                                        <c:if test="${product.oldPrice > 0}">
                                            <span class="product-price-old">$<fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>

<script>
function sortProducts(value) {
    const grid = document.getElementById('productGrid');
    const cards = Array.from(grid.querySelectorAll('.pp-card'));
    cards.sort(function(a, b) {
        if (value === 'price-asc')  return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
        if (value === 'price-desc') return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
        return a.dataset.name.localeCompare(b.dataset.name);
    });
    cards.forEach(function(card) { grid.appendChild(card); });
}
</script>

<%@ include file="footer.jsp" %>
