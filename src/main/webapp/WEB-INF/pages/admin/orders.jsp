<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders — Spra Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Crimson+Pro:ital,wght@0,300;0,400;0,600;1,300;1,400&display=swap" rel="stylesheet">
</head>
<body class="admin-body">

<div class="admin-layout">

    <!-- ═══ SIDEBAR ═══ -->
    <aside class="admin-sidebar">
        <div class="admin-sidebar-top">
            <span class="admin-logo">SΡRA<span>.</span></span>
            <p class="admin-welcome">Hi, <%= currentUser != null ? currentUser.getFirstName() : "Admin" %> &middot; Admin Panel</p>
        </div>
        <nav class="admin-nav">
		    <!-- MAIN SECTION -->
		    <div class="admin-nav-section">Main</div>
		    
		    <a href="<%= contextPath %>/admin/dashboard" class="admin-nav-link active">
		        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
		        <span class="nav-label">Dashboard</span>
		    </a>
		
		    <a href="<%= contextPath %>/admin/products" class="admin-nav-link">
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
		        <c:if test="${not empty recentMessages and recentMessages.size() > 0}">
		            <span class="nav-badge">${recentMessages.size()}</span>
		        </c:if>
		    </a>
		
		    <!-- STORE SECTION -->
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

    <!-- ═══ MAIN ═══ -->
    <main class="admin-main">
        <div class="admin-topbar">
            <div>
                <div class="admin-page-title">Orders</div>
                <div class="admin-page-subtitle">Manage and track all customer orders</div>
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

            <!-- Filter tabs -->
            <div style="display:flex;gap:8px;margin-bottom:20px;flex-wrap:wrap;">
                <button class="filter-tab active" onclick="filterOrders('ALL',this)">All</button>
                <button class="filter-tab" onclick="filterOrders('ORDERED',this)">Ordered</button>
                <button class="filter-tab" onclick="filterOrders('SHIPPED',this)">Shipped</button>
                <button class="filter-tab" onclick="filterOrders('DELIVERED',this)">Delivered</button>
                <button class="filter-tab" onclick="filterOrders('CANCELLED',this)">Cancelled</button>
            </div>

            <div class="admin-section">
                <table class="admin-table" id="ordersTable">
                    <thead>
                        <tr>
                            <th>Order #</th>
                            <th>Customer</th>
                            <th>Delivery To</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Update Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr><td colspan="7" class="admin-empty">No orders placed yet.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="order" items="${orders}">
                                    <tr data-status="${order.status}">
                                        <td style="font-family:monospace;font-size:12px;color:var(--a-muted)">#SPR-${order.orderId}</td>
                                        <td>
                                            <div style="font-weight:500">${order.fullName}</div>
                                            <div style="font-size:11px;color:var(--a-muted)">${order.phone}</div>
                                        </td>
                                        <td>
                                            <div>${order.address}</div>
                                            <div style="font-size:11px;color:var(--a-muted)">${order.city}</div>
                                        </td>
                                        <td style="font-weight:600">Rs <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                        <td>
                                            <span class="badge status-${order.status}">${order.status}</span>
                                        </td>
                                        <td style="font-size:11px;color:var(--a-muted)">
                                            <fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                        </td>
                                        <td>
                                            <form action="<%= contextPath %>/order/status" method="post" style="display:flex;gap:6px;align-items:center;">
                                                <input type="hidden" name="orderId" value="${order.orderId}">
                                                <select name="status" class="status-select">
                                                    <option value="ORDERED"   ${order.status == 'ORDERED'   ? 'selected' : ''}>Ordered</option>
                                                    <option value="SHIPPED"   ${order.status == 'SHIPPED'   ? 'selected' : ''}>Shipped</option>
                                                    <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                                    <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                                <button type="submit" class="admin-edit-btn">Save</button>
                                            </form>
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

<style>
.filter-tab {
    background: var(--a-surface);
    border: 1px solid var(--a-border);
    color: var(--a-muted);
    padding: 7px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
    font-family: 'Space Grotesk', sans-serif;
    cursor: pointer;
    transition: all .15s;
}
.filter-tab:hover { border-color: var(--a-border2); color: var(--a-text); }
.filter-tab.active { background: var(--a-pink); color: #fff; border-color: var(--a-pink); }
</style>

<script>
function filterOrders(status, btn) {
    document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#ordersTable tbody tr[data-status]').forEach(row => {
        row.style.display = (status === 'ALL' || row.dataset.status === status) ? '' : 'none';
    });
}
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
