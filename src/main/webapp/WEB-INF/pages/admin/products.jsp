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
    <style>
        /* ── View toggle ── */
        .view-toggle {
            display: flex; gap: 4px;
            background: var(--a-bg); border: 1px solid var(--a-border);
            border-radius: 8px; padding: 3px;
        }
        .view-toggle-btn {
            width: 32px; height: 32px; background: none; border: none;
            border-radius: 6px; display: flex; align-items: center; justify-content: center;
            color: var(--a-muted); cursor: pointer; transition: all .15s;
        }
        .view-toggle-btn.active {
            background: #fff; color: var(--a-pink);
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
        }

        /* ── Product card grid ── */
        .product-card-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 16px; padding: 20px;
        }
        .pc-card {
            background: var(--a-bg); border: 1px solid var(--a-border);
            border-radius: 14px; overflow: hidden;
            transition: transform .2s, box-shadow .2s;
        }
        .pc-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(232,83,106,.1);
        }
        .pc-card-img {
            width: 100%; height: 160px; object-fit: cover;
            background: #f0e8e8; display: block;
        }
        .pc-card-img-ph {
            width: 100%; height: 160px; background: #fdf0f2;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.5rem;
        }
        .pc-card-body { padding: 14px; }
        .pc-card-cat {
            font-size: 10px; color: var(--a-muted);
            text-transform: uppercase; letter-spacing: 1px; margin-bottom: 3px;
        }
        .pc-card-name {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1rem; font-weight: 600; color: var(--a-text);
            margin-bottom: 8px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis;
        }
        .pc-card-row {
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 12px;
        }
        .pc-card-price { font-size: 13px; font-weight: 600; color: var(--a-text); }
        .pc-card-stock-ok  { font-size: 11px; color: #3B6D11; background: #eaf3de; padding: 2px 8px; border-radius: 10px; }
        .pc-card-stock-out { font-size: 11px; color: #a32d2d; background: #fceaea; padding: 2px 8px; border-radius: 10px; }
        .pc-card-actions { display: flex; gap: 6px; }
        .pc-card-actions button { flex: 1; text-align: center; font-size: 11px; padding: 6px 8px; }
        .pc-card-featured {
            position: absolute; top: 10px; left: 10px;
            background: #e8536a; color: #fff; font-size: 9px;
            font-weight: 700; padding: 2px 8px; border-radius: 10px;
            text-transform: uppercase; letter-spacing: .5px;
        }
        .pc-card-wrap { position: relative; }
    </style>
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
            <a href="<%= contextPath %>/admin/dashboard" class="admin-nav-link">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                <span class="nav-label">Dashboard</span>
            </a>
            <a href="<%= contextPath %>/admin/products" class="admin-nav-link active">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                <span class="nav-label">Products</span>
            </a>
            <a href="<%= contextPath %>/admin/orders" class="admin-nav-link">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="m9 12 2 2 4-4"/></svg>
                <span class="nav-label">Orders</span>
            </a>
            <a href="<%= contextPath %>/admin/messages" class="admin-nav-link">
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
            <div style="display:flex;gap:10px;align-items:center;">
                <!-- View toggle -->
                <div class="view-toggle">
                    <button class="view-toggle-btn active" id="btnTable" onclick="setView('table')" title="Table view">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/>
                        </svg>
                    </button>
                    <button class="view-toggle-btn" id="btnGrid" onclick="setView('grid')" title="Grid view">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                            <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                        </svg>
                    </button>
                </div>
                <button class="admin-add-btn" onclick="document.getElementById('addProductModal').style.display='flex'">
                    + Add Product
                </button>
            </div>
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

                <!-- TABLE VIEW -->
                <table class="admin-table" id="productTable">
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

                <!-- CARD GRID VIEW -->
                <div class="product-card-grid" id="productCardGrid" style="display:none;">
                    <c:choose>
                        <c:when test="${empty products}">
                            <div class="admin-empty" style="grid-column:1/-1;padding:3rem;">No products found.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${products}">
                                <div class="pc-card">
                                    <div class="pc-card-wrap">
                                        <c:choose>
                                            <c:when test="${not empty p.imagePath}">
                                                <img class="pc-card-img"
                                                     src="${pageContext.request.contextPath}/assets/images/products/${p.imagePath}"
                                                     alt="${p.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="pc-card-img-ph">&#128138;</div>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${p.featured}">
                                            <span class="pc-card-featured">Featured</span>
                                        </c:if>
                                    </div>
                                    <div class="pc-card-body">
                                        <div class="pc-card-cat">${p.categoryName}</div>
                                        <div class="pc-card-name">${p.name}</div>
                                        <div class="pc-card-row">
                                            <span class="pc-card-price">Rs <fmt:formatNumber value="${p.price}" pattern="#,##0"/></span>
                                            <c:choose>
                                                <c:when test="${p.stock == 0}">
                                                    <span class="pc-card-stock-out">Out of stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="pc-card-stock-ok">${p.stock} left</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="pc-card-actions">
                                            <button class="admin-edit-btn"
                                                onclick="openEditModal(${p.productId},'${p.name}',${p.price},${p.oldPrice},${p.stock},${p.categoryId},'${p.imagePath}',${p.featured},${p.bestseller},'${p.description}')">
                                                Edit
                                            </button>
                                            <form action="<%= contextPath %>/admin/products/delete" method="post"
                                                  style="flex:1;" onsubmit="return confirm('Delete this product?')">
                                                <input type="hidden" name="productId" value="${p.productId}">
                                                <button type="submit" class="admin-delete-btn" style="width:100%;">Delete</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

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

function setView(mode) {
    var table = document.getElementById('productTable');
    var grid  = document.getElementById('productCardGrid');
    var btnT  = document.getElementById('btnTable');
    var btnG  = document.getElementById('btnGrid');
    if (mode === 'grid') {
        table.style.display = 'none';
        grid.style.display  = 'grid';
        btnT.classList.remove('active');
        btnG.classList.add('active');
        localStorage.setItem('spra_prod_view','grid');
    } else {
        table.style.display = '';
        grid.style.display  = 'none';
        btnT.classList.add('active');
        btnG.classList.remove('active');
        localStorage.setItem('spra_prod_view','table');
    }
}

document.addEventListener('DOMContentLoaded', function(){
    if (localStorage.getItem('spra_prod_view') === 'grid') setView('grid');
});
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>