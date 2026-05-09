<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Forgot Password — Spra</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css"/>
</head>
<body class="auth-body">
<div class="auth-container">

    <!-- Left panel -->
    <div class="auth-panel">
        <div class="auth-panel-content">
            <div class="auth-logo">SPR<span>A</span></div>
            <div class="auth-panel-title">Reset your<br/><em>password.</em></div>
            <p class="auth-panel-sub">We'll send a secure link<br/>straight to your inbox.</p>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="auth-form-panel">
        <div class="auth-form-wrap">

            <h1 class="auth-form-title">Forgot Password</h1>
            <p class="auth-form-sub">Enter your account email and we'll send you a reset link.</p>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <c:if test="${empty successMessage}">
                <form method="post" action="${pageContext.request.contextPath}/forgot-password">
                    <div class="form-group">
                        <label class="form-label" for="email">Email Address</label>
                        <input class="form-input" type="email" id="email" name="email"
                               placeholder="you@example.com" autocomplete="email" required/>
                    </div>
                    <button type="submit" class="auth-submit-btn">Send Reset Link</button>
                </form>
            </c:if>

            <p class="auth-back" style="margin-top:1.5rem;">
                <a href="${pageContext.request.contextPath}/login">← Back to Sign In</a>
            </p>

        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
