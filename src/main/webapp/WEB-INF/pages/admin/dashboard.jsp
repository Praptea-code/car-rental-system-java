<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Dashboard — Spra Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link rel="icon" type="image/svg+xml" href="<%= contextPath %>/assets/images/favicon.svg">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        /* ── Message preview cards ── */
        .msg-preview-list { display:flex; flex-direction:column; }
        .msg-preview-card {
            display:flex; align-items:flex-start; gap:14px;
            padding:16px 22px; border-bottom:1px solid #f8f0f0;
            transition:background .15s; cursor:pointer;
        }
        .msg-preview-card:last-child { border-bottom:none; }
        .msg-preview-card:hover { background:#fff8f8; }
        .mpc-avatar {
            width:38px; height:38px; border-radius:50%; flex-shrink:0;
            background:linear-gradient(135deg,#f4a0b0,#e8536a);
            display:flex; align-items:center; justify-content:center;
            font-family:'Cormorant Garamond',serif;
            font-size:14px; font-weight:600; color:#fff; text-transform:uppercase;
        }
        .mpc-body { flex:1; min-width:0; }
        .mpc-top  { display:flex; justify-content:space-between; align-items:baseline; gap:8px; margin-bottom:3px; }
        .mpc-name { font-size:13px; font-weight:600; color:var(--a-text); }
        .mpc-date { font-size:11px; color:var(--a-muted); flex-shrink:0; }
        .mpc-subj { font-size:12px; color:var(--a-pink); font-weight:500; margin-bottom:3px; }
        .mpc-excerpt { font-size:12px; color:#555; line-height:1.5; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

        /* ── Two-column dashboard grid ── */
        .dashboard-two-col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-top: 20px;
        }
        @media (max-width: 900px) {
            .dashboard-two-col { grid-template-columns: 1fr; }
        }

        /* ── Clickable stat cards ── */
        .stat-card-link {
            text-decoration: none;
            display: block;
        }
        .stat-card-link .admin-stat-card {
            cursor: pointer;
            transition: border-color .2s, transform .2s, box-shadow .2s;
        }
        .stat-card-link:hover .admin-stat-card {
            border-color: var(--a-pink-mid);
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(232, 83, 106, 0.14);
        }
        .stat-card-link:hover .admin-stat-num {
            color: var(--a-pink);
        }

        /* ── Order row in dashboard ── */
        .dash-order-row {
            display: flex;
            align-items: center;
            padding: 14px 22px;
            border-bottom: 1px solid #f8f0f0;
            gap: 14px;
            transition: background .15s;
            cursor: pointer;
        }
        .dash-order-row:last-child { border-bottom: none; }
        .dash-order-row:hover { background: #fff8f8; }
        .dash-order-id {
            font-family: monospace;
            font-size: 11px;
            color: var(--a-muted);
            min-width: 80px;
        }
        .dash-order-customer { flex: 1; min-width: 0; }
        .dash-order-name { font-size: 13px; font-weight: 600; color: var(--a-text); }
        .dash-order-phone { font-size: 11px; color: var(--a-muted); }
        .dash-order-amount {
            font-size: 13px; font-weight: 700;
            color: var(--a-text); min-width: 90px; text-align: right;
        }
        .dash-order-date {
            font-size: 11px; color: var(--a-muted);
            min-width: 80px; text-align: right;
        }

        /* ── Message modal ── */
        .msg-modal-overlay {
            position:fixed; inset:0; background:rgba(20,4,8,.6);
            backdrop-filter:blur(6px); z-index:300;
            display:flex; align-items:center; justify-content:center;
        }
        .msg-modal-box {
            background:#fff; border-radius:18px; width:560px;
            max-width:95vw; max-height:80vh; overflow-y:auto;
            box-shadow:0 24px 60px rgba(232,83,106,.14);
            padding:2rem 2.2rem; position:relative;
        }
        .msg-modal-close {
            position:absolute; top:14px; right:16px;
            background:#fdf0f2; border:none; border-radius:50%;
            width:32px; height:32px; font-size:18px; color:#999;
            cursor:pointer; display:flex; align-items:center; justify-content:center;
            transition:background .15s,color .15s;
        }
        .msg-modal-close:hover { background:var(--a-pink); color:#fff; }
        .msg-modal-from { font-size:.62rem; font-weight:700; letter-spacing:.14em; text-transform:uppercase; color:var(--a-pink); margin-bottom:4px; }
        .msg-modal-name { font-family:'Cormorant Garamond',serif; font-size:1.5rem; font-weight:600; color:var(--a-text); margin-bottom:2px; }
        .msg-modal-meta { font-size:12px; color:var(--a-muted); margin-bottom:1.2rem; }
        .msg-modal-label { font-size:.62rem; font-weight:700; text-transform:uppercase; letter-spacing:.12em; color:var(--a-muted); margin-bottom:4px; }
        .msg-modal-subj { font-size:14px; font-weight:600; color:var(--a-text); margin-bottom:1rem; padding:8px 12px; background:#fdf8f8; border:1px solid #f0e0e0; border-radius:8px; }
        .msg-modal-body { font-size:14px; color:#333; line-height:1.8; white-space:pre-wrap; }

        /* ── Order detail popup ── */
        @keyframes odSlide {
            from { opacity:0; transform:translateY(30px) scale(.97); }
            to   { opacity:1; transform:translateY(0) scale(1); }
        }
        .od-qty-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #e8536a;
            color: #fff;
            font-size: .62rem;
            font-weight: 700;
            min-width: 22px;
            height: 22px;
            border-radius: 11px;
            padding: 0 6px;
            margin-left: 6px;
            letter-spacing: .02em;
            flex-shrink: 0;
        }
    </style>
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
                <div class="admin-page-title">Dashboard</div>
                <div class="admin-page-subtitle">Welcome back, <%= currentUser != null ? currentUser.getFirstName() : "Admin" %>. Here's what's happening.</div>
            </div>
        </div>

        <div class="admin-content">

            <!-- Flash messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">✓ ${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">✕ ${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <!-- ── Stat cards (all clickable) ── -->
            <div class="admin-stats-grid">

                <a href="<%= contextPath %>/admin/products" class="stat-card-link">
                    <div class="admin-stat-card">
                        <div class="admin-stat-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                        </div>
                        <div class="admin-stat-label">Total Products</div>
                        <div class="admin-stat-num">${totalProducts}</div>
                    </div>
                </a>

                <a href="<%= contextPath %>/admin/orders" class="stat-card-link">
                    <div class="admin-stat-card">
                        <div class="admin-stat-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg>
                        </div>
                        <div class="admin-stat-label">Total Orders</div>
                        <div class="admin-stat-num">${totalOrders != null ? totalOrders : 0}</div>
                    </div>
                </a>

                <a href="<%= contextPath %>/admin/products" class="stat-card-link">
                    <div class="admin-stat-card">
                        <div class="admin-stat-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                        </div>
                        <div class="admin-stat-label">Categories</div>
                        <div class="admin-stat-num">${totalCategories}</div>
                    </div>
                </a>

                <a href="<%= contextPath %>/admin/messages" class="stat-card-link">
                    <div class="admin-stat-card">
                        <div class="admin-stat-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                        </div>
                        <div class="admin-stat-label">Messages</div>
                        <div class="admin-stat-num">${recentMessages.size()}</div>
                    </div>
                </a>

            </div>

            <!-- ── Two-column section: Orders + Messages ── -->
            <div class="dashboard-two-col">

                <!-- Recent Orders — each row opens the detail popup on click -->
                <div class="admin-section">
                    <div class="admin-section-head">
                        <span class="admin-section-title">Recent Orders</span>
                        <a href="<%= contextPath %>/admin/orders" class="admin-view-all">View All →</a>
                    </div>
                    <c:choose>
                        <c:when test="${empty recentOrders}">
                            <div class="admin-empty">No orders yet.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${recentOrders}" begin="0" end="4">
                                <div class="dash-order-row"
                                     title="Click to view order items"
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
                                    <div class="dash-order-id">#SPR-${order.orderId}</div>
                                    <div class="dash-order-customer">
                                        <div class="dash-order-name">${order.fullName}</div>
                                        <div class="dash-order-phone">${order.city}</div>
                                    </div>
                                    <span class="badge status-${order.status}">${order.status}</span>
                                    <div class="dash-order-amount">
                                        Rs <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/>
                                    </div>
                                    <div class="dash-order-date">
                                        <fmt:formatDate value="${order.createdAt}" pattern="MMM dd"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Recent Messages -->
                <div class="admin-section">
                    <div class="admin-section-head">
                        <span class="admin-section-title">Recent Messages</span>
                        <a href="<%= contextPath %>/admin/messages" class="admin-view-all">View All →</a>
                    </div>
                    <c:choose>
                        <c:when test="${empty recentMessages}">
                            <div class="admin-empty">No messages yet.</div>
                        </c:when>
                        <c:otherwise>
                            <div class="msg-preview-list">
                                <c:forEach var="msg" items="${recentMessages}" begin="0" end="4">
                                    <div class="msg-preview-card"
                                         onclick="openMsg('${msg.fullName}','${msg.email}','${msg.subject}',`${msg.message}`,'${msg.createdAt}')">
                                        <div class="mpc-avatar">
                                            ${fn:toUpperCase(fn:substring(msg.firstName,0,1))}${fn:toUpperCase(fn:substring(msg.lastName,0,1))}
                                        </div>
                                        <div class="mpc-body">
                                            <div class="mpc-top">
                                                <span class="mpc-name">${msg.fullName}</span>
                                                <span class="mpc-date">${msg.createdAt}</span>
                                            </div>
                                            <div class="mpc-subj">${msg.subject}</div>
                                            <div class="mpc-excerpt">${msg.message}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div><%-- /dashboard-two-col --%>

        </div><%-- /admin-content --%>
    </main>
</div>

<!-- ═══ MESSAGE DETAIL MODAL ═══ -->
<div id="msgModal" class="msg-modal-overlay" style="display:none" onclick="if(event.target===this)closeMsg()">
    <div class="msg-modal-box">
        <button class="msg-modal-close" onclick="closeMsg()">&times;</button>
        <div class="msg-modal-from">Message from</div>
        <div class="msg-modal-name" id="modalName"></div>
        <div class="msg-modal-meta" id="modalMeta"></div>
        <div class="msg-modal-label">Subject</div>
        <div class="msg-modal-subj" id="modalSubj"></div>
        <div class="msg-modal-label" style="margin-top:.2rem;">Message</div>
        <div class="msg-modal-body" id="modalBody"></div>
    </div>
</div>

<!-- ═══ ORDER DETAIL POPUP ═══ -->
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

        <div id="odLoading" style="display:none;padding:4rem 2rem;text-align:center;color:#aaa;">
            <div style="font-family:'Cormorant Garamond',serif;font-size:1.2rem;font-style:italic;">Loading…</div>
        </div>

        <div id="odEmpty" style="display:none;padding:3rem 2rem;text-align:center;color:#aaa;">
            <div style="font-size:2rem;margin-bottom:10px;opacity:.25;">📦</div>
            <div style="font-family:'Cormorant Garamond',serif;font-size:1.1rem;">No item details recorded for this order</div>
            <div style="font-size:.75rem;margin-top:6px;">Items are saved for orders placed after the system update.</div>
        </div>

        <div style="padding:1.2rem 2rem 2rem;border-top:1px solid #f8f0f0;margin-top:1.2rem;
                    display:flex;justify-content:space-between;align-items:center;">
            <span style="font-size:.82rem;color:#aaa;">Total (Cash on Delivery)</span>
            <span id="odTotal" style="font-family:'Cormorant Garamond',serif;font-size:1.8rem;font-weight:600;color:#1a1a1a;"></span>
        </div>
    </div>
</div>

<!-- ═══ SCRIPTS ═══ -->
<script>
/* ── Message modal ── */
function openMsg(name, email, subj, body, date) {
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalMeta').textContent = email + ' · ' + date;
    document.getElementById('modalSubj').textContent = subj;
    document.getElementById('modalBody').textContent = body;
    document.getElementById('msgModal').style.display = 'flex';
}
function closeMsg() { document.getElementById('msgModal').style.display = 'none'; }

/* ── Order detail popup ── */
var _odCtx = '<%= contextPath %>';

function mergeOrderItems(items) {
    var map = {}, merged = [];
    items.forEach(function(it) {
        var key = it.productId;
        if (map[key] !== undefined) {
            merged[map[key]].quantity += it.quantity;
            merged[map[key]].subtotal += it.subtotal;
        } else {
            map[key] = merged.length;
            merged.push(Object.assign({}, it));
        }
    });
    return merged;
}

function openOrderDetail(orderId, fullName, phone, address, city, status, createdAt, total) {
    var ov = document.getElementById('orderDetailOverlay');
    ov.style.display = 'flex';

    document.getElementById('odEyebrow').textContent = 'Order #SPR-' + orderId;
    document.getElementById('odTitle').textContent   = fullName;
    document.getElementById('odMeta').textContent    = createdAt + '  ·  ' + status;
    document.getElementById('odInfo').innerHTML =
        odTile('Phone', phone)   +
        odTile('Address', address) +
        odTile('City',  city)    +
        odTile('Payment', 'Cash on Delivery');
    document.getElementById('odTotal').textContent =
        'Rs ' + parseFloat(total).toLocaleString('en-IN', { minimumFractionDigits: 2 });

    odShow('odLoading');
    odHide('odItems');
    odHide('odEmpty');

    fetch(_odCtx + '/order/items?orderId=' + orderId)
        .then(function(r) { return r.json(); })
        .then(function(rawItems) {
            odHide('odLoading');
            if (!rawItems || rawItems.length === 0) { odShow('odEmpty'); return; }

            var items = mergeOrderItems(rawItems);
            var html  = '';

            items.forEach(function(it) {
                var src = it.imagePath
                    ? _odCtx + '/assets/images/products/' + it.imagePath
                    : null;

                html += '<div style="display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px solid #f8f0f0;">';

                /* Thumbnail */
                html += '<div style="width:64px;height:64px;border-radius:10px;overflow:hidden;background:#f8f0f2;flex-shrink:0;display:flex;align-items:center;justify-content:center;">';
                html += src
                    ? '<img src="' + src + '" style="width:100%;height:100%;object-fit:cover;" onerror="this.parentNode.innerHTML=\'<span style=font-size:1.6rem>&#128138;</span>\'">'
                    : '<span style="font-size:1.6rem;">&#128138;</span>';
                html += '</div>';

                /* Info */
                html += '<div style="flex:1;min-width:0;">';
                html += '<div style="font-size:.58rem;color:#aaa;text-transform:uppercase;letter-spacing:1px;margin-bottom:2px;">' + odEsc(it.categoryName) + '</div>';
                html += '<div style="font-family:\'Cormorant Garamond\',serif;font-size:1rem;font-weight:600;color:#1a1a1a;display:flex;align-items:center;gap:4px;flex-wrap:wrap;">';
                html += odEsc(it.productName);
                if (it.quantity > 1) {
                    html += '<span class="od-qty-pill">\u00d7' + it.quantity + '</span>';
                }
                html += '</div>';
                html += '<div style="font-size:.78rem;color:#888;margin-top:2px;">Rs '
                      + parseFloat(it.price).toLocaleString('en-IN', { minimumFractionDigits: 2 })
                      + ' each</div>';
                html += '</div>';

                /* Subtotal */
                html += '<div style="font-size:.95rem;font-weight:600;color:#1a1a1a;flex-shrink:0;">Rs '
                      + parseFloat(it.subtotal).toLocaleString('en-IN', { minimumFractionDigits: 2 })
                      + '</div>';

                html += '</div>';
            });

            document.getElementById('odItems').innerHTML = '<div style="padding-bottom:.4rem;">' + html + '</div>';
            odShow('odItems');
        })
        .catch(function() { odHide('odLoading'); odShow('odEmpty'); });
}

function closeOrderDetail() {
    document.getElementById('orderDetailOverlay').style.display = 'none';
    document.getElementById('odItems').innerHTML = '';
}

function odTile(label, value) {
    return '<div style="background:#fdf8f8;border:1px solid #f0e0e0;border-radius:8px;padding:10px 14px;">'
         + '<div style="font-size:.58rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:#aaa;margin-bottom:3px;">' + label + '</div>'
         + '<div style="font-size:.84rem;font-weight:500;color:#1a1a1a;">' + odEsc(value) + '</div>'
         + '</div>';
}

function odEsc(s) {
    if (!s) return '—';
    var d = document.createElement('div');
    d.textContent = s;
    return d.innerHTML;
}

function odShow(id) { document.getElementById(id).style.display = 'block'; }
function odHide(id) { document.getElementById(id).style.display = 'none';  }

/* Close overlays on backdrop click or Escape */
document.getElementById('orderDetailOverlay').addEventListener('click', function(e) {
    if (e.target === this) closeOrderDetail();
});
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        closeOrderDetail();
        closeMsg();
    }
});
</script>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
