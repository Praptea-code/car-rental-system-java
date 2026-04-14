<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle", "Login");
    request.setAttribute("pageCSS",   "auth");
    request.setAttribute("activePage","");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login &ndash; Spra.</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/auth.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
</head>
<body class="auth-body">

<div class="auth-container">

    <!-- Left decorative panel -->
    <div class="auth-panel">
        <div class="auth-panel-content">
            <div class="auth-logo">SΡRA<span>.</span></div>
            <h2 class="auth-panel-title">Welcome<br><em>back</em></h2>
            <p class="auth-panel-sub">Premium cosmetics crafted with love, for your most radiant self.</p>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="auth-form-panel">
        <div class="auth-form-wrap">

            <h1 class="auth-form-title">Sign In</h1>
            <p class="auth-form-sub">Don&apos;t have an account? <a href="<%= contextPath %>/register" class="auth-link">Register</a></p>

            <!-- Success message (redirected from register) -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">${sessionScope.successMessage}</div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <!-- Error message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form action="<%= contextPath %>/login" method="post" class="auth-form" novalidate>

                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Enter your username"
                           value="<c:out value='${username}'/>" required autofocus>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Enter your password" required>
                        <button type="button" class="toggle-pass" onclick="togglePassword('password', this)">Show</button>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">Sign In</button>
            </form>

            <p class="auth-back"><a href="<%= contextPath %>/home">&larr; Back to Home</a></p>
        </div>
    </div>
</div>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
