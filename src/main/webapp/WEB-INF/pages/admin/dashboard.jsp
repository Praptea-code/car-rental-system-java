<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <rect x="3" y="3" width="7" height="7" rx="1"/>
                    <rect x="14" y="3" width="7" height="7" rx="1"/>
                    <rect x="3" y="14" width="7" height="7" rx="1"/>
                    <rect x="14" y="14" width="7" height="7" rx="1"/>
                </svg>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/products" class="admin-nav-link <%= currentUri.endsWith("/products") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                </svg>
                <span class="nav-label">Products</span>
            </a>

            <a href="<%= contextPath %>/admin/orders" class="admin-nav-link <%= currentUri.endsWith("/orders") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/>
                    <rect x="9" y="3" width="6" height="4" rx="1"/>
                    <path d="m9 12 2 2 4-4"/>
                </svg>
                <span class="nav-label">Orders</span>
            </a>

            <a href="<%= contextPath %>/admin/messages" class="admin-nav-link <%= currentUri.endsWith("/messages") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                    <polyline points="22,6 12,13 2,6"/>
                </svg>
                <span class="nav-label">Messages</span>
            </a>

            <div class="admin-nav-section">Store</div>

            <a href="<%= contextPath %>/home" class="admin-nav-link">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                </svg>
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

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">✓ ${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-error">✕ ${sessionScope.errorMessage}</div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <!-- Stat cards -->
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

            <!-- Recent messages -->
            <div class="admin-section">
                <div class="admin-section-head">
                    <span class="admin-section-title">Recent Messages</span>
                    <a href="<%= contextPath %>/admin/messages" class="admin-view-all">View All →</a>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Subject</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty recentMessages}">
                                <tr><td colspan="4" class="admin-empty">No messages yet.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="msg" items="${recentMessages}" begin="0" end="4">
                                    <tr>
                                        <td>${msg.fullName}</td>
                                        <td style="color:var(--a-muted)">${msg.email}</td>
                                        <td>${msg.subject}</td>
                                        <td style="color:var(--a-muted);font-size:12px">${msg.createdAt}</td>
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

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
