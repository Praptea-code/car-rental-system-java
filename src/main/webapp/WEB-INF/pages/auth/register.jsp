<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register &ndash; Spra.</title>
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
            <h2 class="auth-panel-title">Join the<br><em>Spra</em><br>family</h2>
            <p class="auth-panel-sub">Create your account and discover premium beauty curated just for you.</p>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="auth-form-panel auth-form-panel--wide">
        <div class="auth-form-wrap">

            <h1 class="auth-form-title">Create Account</h1>
            <p class="auth-form-sub">Already have an account? <a href="<%= contextPath %>/login" class="auth-link">Login</a></p>

            <!-- Error / success messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form action="<%= contextPath %>/register" method="post" class="auth-form" novalidate>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-input"
                               placeholder="Aria"
                               value="<c:out value='${firstName}'/>" required>
                        <span class="field-hint">Letters only</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-input"
                               placeholder="Santos"
                               value="<c:out value='${lastName}'/>" required>
                        <span class="field-hint">Letters only</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Must be more than 6 characters"
                           value="<c:out value='${username}'/>" required>
                    <span class="field-hint">Letters and digits only, min 7 characters</span>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="hello@example.com"
                           value="<c:out value='${email}'/>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" class="form-input"
                           placeholder="+97798123456789"
                           value="<c:out value='${phone}'/>" required>
                    <span class="field-hint">Start with + and be exactly 14 characters</span>
                </div>

                <div class="form-group">
                    <label class="form-label" for="birthdate">Date of Birth</label>
                    <input type="date" id="birthdate" name="birthdate" class="form-input"
                           value="<c:out value='${birthdate}'/>" required>
                    <span class="field-hint">Must not be a future date</span>
                </div>

                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Min 7 chars, uppercase, digit, special char" required>
                        <button type="button" class="toggle-pass" onclick="togglePassword('password', this)">Show</button>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="retypePassword">Confirm Password</label>
                    <div class="password-wrap">
                        <input type="password" id="retypePassword" name="retypePassword" class="form-input"
                               placeholder="Re-enter your password" required>
                        <button type="button" class="toggle-pass" onclick="togglePassword('retypePassword', this)">Show</button>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">Create Account</button>
            </form>

            <p class="auth-back"><a href="<%= contextPath %>/home">&larr; Back to Home</a></p>
        </div>
    </div>
</div>

<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
