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

        /* ── Order row in dashboard ── */
        .dash-order-row {
            display: flex;
            align-items: center;
            padding: 14px 22px;
            border-bottom: 1px solid #f8f0f0;
            gap: 14px;
            transition: background .15s;
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

            <!-- ── Stat cards ── -->
            <div class="admin-stats-grid">
                <div class="admin-stat-card">
                    <div class="admin-stat-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                    </div>
                    <div class="admin-stat-label">Total Products</div>
                    <div class="admin-stat-num">${totalProducts}</div>
                </div>
                <div class="admin-stat-card">
                    <div class="admin-stat-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/></svg>
                    </div>
                    <div class="admin-stat-label">Total Orders</div>
                    <div class="admin-stat-num">${totalOrders != null ? totalOrders : 0}</div>
                </div>
                <div class="admin-stat-card">
                    <div class="admin-stat-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                    </div>
                    <div class="admin-stat-label">Categories</div>
                    <div class="admin-stat-num">${totalCategories}</div>
                </div>
                <div class="admin-stat-card">
                    <div class="admin-stat-icon">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                    </div>
                    <div class="admin-stat-label">Messages</div>
                    <div class="admin-stat-num">${recentMessages.size()}</div>
                </div>
            </div>

            <!-- ── Two-column section: Orders + Messages ── -->
            <div class="dashboard-two-col">

                <!-- Recent Orders -->
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
                                <div class="dash-order-row">
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

<!-- Message detail modal -->
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

<script>
function openMsg(name, email, subj, body, date) {
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalMeta').textContent = email + ' · ' + date;
    document.getElementById('modalSubj').textContent = subj;
    document.getElementById('modalBody').textContent = body;
    document.getElementById('msgModal').style.display = 'flex';
}
function closeMsg() { document.getElementById('msgModal').style.display = 'none'; }
document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeMsg(); });
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
