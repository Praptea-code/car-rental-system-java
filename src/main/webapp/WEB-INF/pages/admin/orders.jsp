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
    <title>Orders — Spra Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
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

    <!-- ═══ MAIN ═══ -->
    <main class="admin-main">
        <div class="admin-topbar">
            <div>
                <div class="admin-page-title">Orders</div>
                <div class="admin-page-subtitle">Manage and track all customer orders — click any row to view items</div>
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
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty orders}">
                                <tr><td colspan="8" class="admin-empty">No orders placed yet.</td></tr>
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
                                        <td>
                                            <%-- View Details button triggers the popup --%>
                                            <button class="admin-edit-btn"
                                                onclick="openOrderDetail(
                                                    ${order.orderId},
                                                    '${order.fullName.replace("'", "\\'")}',
                                                    '${order.phone}',
                                                    '${order.address.replace("'", "\\'")}',
                                                    '${order.city}',
                                                    '${order.status}',
                                                    '<fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy"/>',
                                                    ${order.totalAmount}
                                                )">
                                                View Items
                                            </button>
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

<script>
function filterOrders(status, btn) {
    document.querySelectorAll('.filter-tab').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    document.querySelectorAll('#ordersTable tbody tr[data-status]').forEach(row => {
        row.style.display = (status === 'ALL' || row.dataset.status === status) ? '' : 'none';
    });
}
</script>

<%-- ── ORDER DETAIL POPUP (shared snippet) ── --%>
<div id="orderDetailOverlay"
     style="display:none;position:fixed;inset:0;background:rgba(10,4,6,.72);
            backdrop-filter:blur(8px);z-index:9100;
            align-items:center;justify-content:center;">
    <div id="orderDetailBox"
         style="background:#fff;border-radius:22px;width:600px;max-width:95vw;
                max-height:88vh;overflow-y:auto;
                box-shadow:0 40px 100px rgba(0,0,0,.28);
                animation:odSlide .38s cubic-bezier(.22,1,.36,1);
                position:relative;font-family:'DM Sans',sans-serif;">
        <button onclick="closeOrderDetail()"
                style="position:absolute;top:16px;right:16px;background:#f8f0f2;border:none;
                       border-radius:50%;width:34px;height:34px;font-size:20px;color:#999;
                       display:flex;align-items:center;justify-content:center;
                       cursor:pointer;transition:background .2s,color .2s;z-index:2;"
                onmouseover="this.style.background='#e8536a';this.style.color='#fff'"
                onmouseout="this.style.background='#f8f0f2';this.style.color='#999'">&times;</button>
        <div style="padding:2rem 2rem 0;">
            <div id="odEyebrow" style="font-size:.6rem;font-weight:700;letter-spacing:.2em;text-transform:uppercase;color:#e8536a;margin-bottom:6px;"></div>
            <div id="odTitle"   style="font-family:'Cormorant Garamond',serif;font-size:1.8rem;font-weight:600;color:#1a1a1a;margin-bottom:4px;"></div>
            <div id="odMeta"    style="font-size:.78rem;color:#aaa;margin-bottom:1.4rem;"></div>
            <div id="odInfo"    style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:1.4rem;"></div>
            <div style="font-size:.62rem;font-weight:700;text-transform:uppercase;letter-spacing:.14em;color:#aaa;margin-bottom:10px;">Items in this order</div>
        </div>
        <div id="odItems"   style="padding:0 2rem;"></div>
        <div id="odLoading" style="display:none;padding:4rem 2rem;text-align:center;color:#aaa;"><div style="font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-style:italic;">Loading…</div></div>
        <div id="odEmpty"   style="display:none;padding:3rem 2rem;text-align:center;color:#aaa;">
            <div style="font-size:2rem;margin-bottom:10px;opacity:.25;">📦</div>
            <div style="font-family:'Cormorant Garamond',serif;font-size:1.1rem;">No item details recorded for this order</div>
            <div style="font-size:.75rem;margin-top:6px;">Items are saved for orders placed after the system update.</div>
        </div>
        <div id="odFooter" style="padding:1.2rem 2rem 2rem;border-top:1px solid #f8f0f0;margin-top:1.2rem;display:flex;justify-content:space-between;align-items:center;">
            <span style="font-size:.82rem;color:#aaa;">Total (Cash on Delivery)</span>
            <span id="odTotal" style="font-family:'Cormorant Garamond',serif;font-size:1.8rem;font-weight:600;color:#1a1a1a;"></span>
        </div>
    </div>
</div>

<style>
@keyframes odSlide {
    from { opacity:0; transform:translateY(30px) scale(.97); }
    to   { opacity:1; transform:translateY(0) scale(1); }
}
</style>

<script>
var _odCtx = '<%= contextPath %>';

function openOrderDetail(orderId, fullName, phone, address, city, status, createdAt, total) {
    var ov = document.getElementById('orderDetailOverlay');
    ov.style.display = 'flex';
    document.getElementById('odEyebrow').textContent = 'Order #SPR-' + orderId;
    document.getElementById('odTitle').textContent   = fullName;
    document.getElementById('odMeta').textContent    = createdAt + '  ·  ' + status;
    document.getElementById('odInfo').innerHTML =
        tile('Phone', phone) + tile('Address', address) +
        tile('City',  city)  + tile('Payment', 'Cash on Delivery');
    document.getElementById('odTotal').textContent =
        'Rs ' + parseFloat(total).toLocaleString('en-IN', {minimumFractionDigits:2});
    odShow('odLoading'); odHide('odItems'); odHide('odEmpty');

    fetch(_odCtx + '/order/items?orderId=' + orderId)
        .then(function(r){ return r.json(); })
        .then(function(items){
            odHide('odLoading');
            if (!items || items.length === 0) { odShow('odEmpty'); return; }
            var html = '';
            items.forEach(function(it){
                var src = it.imagePath ? _odCtx + '/assets/images/products/' + it.imagePath : null;
                html += '<div style="display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px solid #f8f0f0;">';
                html += '<div style="width:64px;height:64px;border-radius:10px;overflow:hidden;background:#f8f0f2;flex-shrink:0;display:flex;align-items:center;justify-content:center;">';
                html += src ? '<img src="'+src+'" style="width:100%;height:100%;object-fit:cover;" onerror="this.parentNode.innerHTML=\'<span style=font-size:1.6rem>💄</span>\'">'
                            : '<span style="font-size:1.6rem;">💄</span>';
                html += '</div>';
                html += '<div style="flex:1;min-width:0;">';
                html += '<div style="font-size:.58rem;color:#aaa;text-transform:uppercase;letter-spacing:1px;margin-bottom:2px;">'+odEsc(it.categoryName)+'</div>';
                html += '<div style="font-family:\'Cormorant Garamond\',serif;font-size:1rem;font-weight:600;color:#1a1a1a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">'+odEsc(it.productName)+'</div>';
                html += '<div style="font-size:.78rem;color:#888;margin-top:2px;">Rs '+parseFloat(it.price).toLocaleString('en-IN',{minimumFractionDigits:2})+' × '+it.quantity+'</div>';
                html += '</div>';
                html += '<div style="font-size:.95rem;font-weight:600;color:#1a1a1a;flex-shrink:0;">Rs '+parseFloat(it.subtotal).toLocaleString('en-IN',{minimumFractionDigits:2})+'</div>';
                html += '</div>';
            });
            document.getElementById('odItems').innerHTML = '<div style="padding-bottom:.4rem;">'+html+'</div>';
            odShow('odItems');
        })
        .catch(function(){ odHide('odLoading'); odShow('odEmpty'); });
}

function closeOrderDetail() {
    document.getElementById('orderDetailOverlay').style.display = 'none';
    document.getElementById('odItems').innerHTML = '';
}

function tile(label, value) {
    return '<div style="background:#fdf8f8;border:1px solid #f0e0e0;border-radius:8px;padding:10px 14px;">' +
           '<div style="font-size:.58rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:#aaa;margin-bottom:3px;">'+label+'</div>' +
           '<div style="font-size:.84rem;font-weight:500;color:#1a1a1a;">'+odEsc(value)+'</div></div>';
}
function odEsc(s) {
    if (!s) return '—';
    var d = document.createElement('div'); d.textContent = s; return d.innerHTML;
}
function odShow(id){ document.getElementById(id).style.display='block'; }
function odHide(id){ document.getElementById(id).style.display='none'; }

document.getElementById('orderDetailOverlay').addEventListener('click', function(e){
    if (e.target===this) closeOrderDetail();
});
document.addEventListener('keydown', function(e){
    if (e.key==='Escape') closeOrderDetail();
});
</script>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
