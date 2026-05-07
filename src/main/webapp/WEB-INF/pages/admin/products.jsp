<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    String currentUri = request.getRequestURI();
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products — Spra Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body class="admin-body">
<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="admin-sidebar">
        <div class="admin-sidebar-top">
            <span class="admin-logo">SΡRA<span>.</span></span>
            <p class="admin-welcome">Hi, <%= currentUser != null ? currentUser.getFirstName() : "Admin" %> &middot; Admin Panel</p>
        </div>
        <nav class="admin-nav">
            <div class="admin-nav-section">Main</div>

            <a href="<%= contextPath %>/admin/dashboard" class="admin-nav-link <%= currentUri.endsWith("/dashboard") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/products" class="admin-nav-link <%= currentUri.endsWith("/products") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                <span class="nav-label">Products</span>
            </a>

            <a href="<%= contextPath %>/admin/orders" class="admin-nav-link <%= currentUri.endsWith("/orders") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="m9 12 2 2 4-4"/></svg>
                <span class="nav-label">Orders</span>
            </a>

            <a href="<%= contextPath %>/admin/messages" class="admin-nav-link <%= currentUri.endsWith("/messages") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                <span class="nav-label">Messages</span>
            </a>

            <div class="admin-nav-section">Store</div>

            <a href="<%= contextPath %>/home" class="admin-nav-link">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                <span class="nav-label">View Site</span>
            </a>
        </nav>
        <div class="admin-sidebar-bottom">
            <form action="<%= contextPath %>/logout" method="post">
                <button type="submit" class="admin-logout-btn">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Sign Out
                </button>
            </form>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="admin-main">
        <div class="admin-topbar">
            <div>
                <div class="admin-page-title">Manage Products</div>
                <div class="admin-page-subtitle">Add, edit, and remove products from your store</div>
            </div>
            <button class="admin-add-btn" onclick="document.getElementById('addProductModal').style.display='flex'">
                + Add Product
            </button>
        </div>

        <div class="admin-content">
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">✓ ${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">✕ ${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <div class="admin-section">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Featured</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty products}">
                                <tr><td colspan="7" class="admin-empty">No products found.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="p" items="${products}">
                                    <tr>
                                        <td style="font-family:monospace;font-size:11px;color:var(--a-muted)">#${p.productId}</td>
                                        <td style="font-weight:500">${p.name}</td>
                                        <td><span class="badge badge-muted">${p.categoryName}</span></td>
                                        <td>Rs <fmt:formatNumber value="${p.price}" pattern="#,##0.00"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.stock == 0}"><span class="badge badge-danger">Out</span></c:when>
                                                <c:otherwise><span style="color:var(--a-green)">${p.stock}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><c:if test="${p.featured}"><span class="badge badge-success">Yes</span></c:if></td>
                                        <td>
                                            <div class="admin-actions">
                                                <button class="admin-edit-btn"
                                                    onclick="openEditModal(${p.productId},'${p.name}',${p.price},${p.oldPrice},${p.stock},${p.categoryId},'${p.imagePath}',${p.featured},${p.bestseller},'${p.description}')">
                                                    Edit
                                                </button>
                                                <form action="<%= contextPath %>/admin/products/delete" method="post" style="display:inline" onsubmit="return confirm('Delete this product?')">
                                                    <input type="hidden" name="productId" value="${p.productId}">
                                                    <button type="submit" class="admin-delete-btn">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- ADD MODAL -->
<div id="addProductModal" class="modal-overlay" style="display:none">
    <div class="modal-box">
        <div class="modal-head">
            <h2 class="modal-title">Add New Product</h2>
            <button class="modal-close" onclick="document.getElementById('addProductModal').style.display='none'">&times;</button>
        </div>
        <form action="<%= contextPath %>/admin/products/add" method="post" class="admin-form">
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Product Name</label><input type="text" name="name" class="form-input" required></div>
                <div class="form-group"><label class="form-label">Category</label><select name="categoryId" class="form-input"><c:forEach var="cat" items="${categories}"><option value="${cat.categoryId}">${cat.name}</option></c:forEach></select></div>
            </div>
            <div class="form-group"><label class="form-label">Description</label><textarea name="description" class="form-input" rows="3"></textarea></div>
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Price (Rs)</label><input type="number" name="price" class="form-input" step="0.01" min="0" required></div>
                <div class="form-group"><label class="form-label">Old Price (Rs)</label><input type="number" name="oldPrice" class="form-input" step="0.01" min="0"></div>
            </div>
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Stock</label><input type="number" name="stock" class="form-input" min="0" value="0"></div>
                <div class="form-group"><label class="form-label">Image Filename</label><input type="text" name="imagePath" class="form-input" placeholder="product.jpg"></div>
            </div>
            <div class="form-row-2">
                <label class="form-check"><input type="checkbox" name="isFeatured"> Featured on home</label>
                <label class="form-check"><input type="checkbox" name="isBestseller"> Bestseller spotlight</label>
            </div>
            <div class="modal-footer">
                <button type="button" class="admin-cancel-btn" onclick="document.getElementById('addProductModal').style.display='none'">Cancel</button>
                <button type="submit" class="admin-save-btn">Add Product</button>
            </div>
        </form>
    </div>
</div>

<!-- EDIT MODAL -->
<div id="editProductModal" class="modal-overlay" style="display:none">
    <div class="modal-box">
        <div class="modal-head">
            <h2 class="modal-title">Edit Product</h2>
            <button class="modal-close" onclick="document.getElementById('editProductModal').style.display='none'">&times;</button>
        </div>
        <form action="<%= contextPath %>/admin/products/edit" method="post" class="admin-form">
            <input type="hidden" name="productId" id="editProductId">
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Product Name</label><input type="text" name="name" id="editName" class="form-input" required></div>
                <div class="form-group"><label class="form-label">Category</label><select name="categoryId" id="editCategory" class="form-input"><c:forEach var="cat" items="${categories}"><option value="${cat.categoryId}">${cat.name}</option></c:forEach></select></div>
            </div>
            <div class="form-group"><label class="form-label">Description</label><textarea name="description" id="editDescription" class="form-input" rows="3"></textarea></div>
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Price (Rs)</label><input type="number" name="price" id="editPrice" class="form-input" step="0.01" min="0"></div>
                <div class="form-group"><label class="form-label">Old Price (Rs)</label><input type="number" name="oldPrice" id="editOldPrice" class="form-input" step="0.01" min="0"></div>
            </div>
            <div class="form-row-2">
                <div class="form-group"><label class="form-label">Stock</label><input type="number" name="stock" id="editStock" class="form-input" min="0"></div>
                <div class="form-group"><label class="form-label">Image Filename</label><input type="text" name="imagePath" id="editImage" class="form-input"></div>
            </div>
            <div class="form-row-2">
                <label class="form-check"><input type="checkbox" name="isFeatured" id="editFeatured"> Featured</label>
                <label class="form-check"><input type="checkbox" name="isBestseller" id="editBestseller"> Bestseller</label>
            </div>
            <div class="modal-footer">
                <button type="button" class="admin-cancel-btn" onclick="document.getElementById('editProductModal').style.display='none'">Cancel</button>
                <button type="submit" class="admin-save-btn">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script> 
function openEditModal(id,name,price,oldPrice,stock,catId,image,featured,bestseller,desc){
    document.getElementById('editProductId').value   = id;
    document.getElementById('editName').value        = name;
    document.getElementById('editPrice').value       = price;
    document.getElementById('editOldPrice').value    = oldPrice;
    document.getElementById('editStock').value       = stock;
    document.getElementById('editCategory').value    = catId;
    document.getElementById('editImage').value       = image;
    document.getElementById('editDescription').value = desc;
    document.getElementById('editFeatured').checked   = featured;
    document.getElementById('editBestseller').checked = bestseller;
    document.getElementById('editProductModal').style.display = 'flex';
}
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
