<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Admin Dashboard &ndash; Spra.</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body class="admin-body">

<!-- ===== ADMIN SIDEBAR ===== -->
<div class="admin-layout">
    <aside class="admin-sidebar">
        <div class="admin-logo">SΡRA<span>.</span></div>
        <p class="admin-welcome">Hi, <%= currentUser != null ? currentUser.getFirstName() : "Admin" %></p>
        <nav class="admin-nav">
            <a href="<%= contextPath %>/admin/dashboard" class="admin-nav-link active">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>
                Dashboard
            </a>
            <a href="<%= contextPath %>/admin/products" class="admin-nav-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                Products
            </a>
            <a href="<%= contextPath %>/admin/messages" class="admin-nav-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                Messages
            </a>
            <a href="<%= contextPath %>/home" class="admin-nav-link">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                View Site
            </a>
            <form action="<%= contextPath %>/logout" method="post" style="margin-top:auto">
                <button type="submit" class="admin-logout-btn">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Logout
                </button>
            </form>
        </nav>
    </aside>

    <!-- ===== ADMIN MAIN ===== -->
    <main class="admin-main">
        <div class="admin-topbar">
            <h1 class="admin-page-title">Dashboard</h1>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-error">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- Stat cards -->
        <div class="admin-stats-grid">
            <div class="admin-stat-card">
                <p class="admin-stat-label">Total Products</p>
                <p class="admin-stat-num">${totalProducts}</p>
            </div>
            <div class="admin-stat-card">
                <p class="admin-stat-label">Categories</p>
                <p class="admin-stat-num">${totalCategories}</p>
            </div>
            <div class="admin-stat-card">
                <p class="admin-stat-label">Messages</p>
                <p class="admin-stat-num">${recentMessages.size()}</p>
            </div>
        </div>

        <!-- Recent messages preview -->
        <div class="admin-section">
            <div class="admin-section-head">
                <h2 class="admin-section-title">Recent Messages</h2>
                <a href="<%= contextPath %>/admin/messages" class="admin-view-all">View All</a>
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
                                    <td>${msg.email}</td>
                                    <td>${msg.subject}</td>
                                    <td>${msg.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        
    </main>
</div>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
