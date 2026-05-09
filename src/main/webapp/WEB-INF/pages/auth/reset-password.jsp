<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Reset Password — Spra</title>
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
            <div class="auth-panel-title">New<br/><em>password.</em></div>
            <p class="auth-panel-sub">Choose something strong<br/>and memorable.</p>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="auth-form-panel">
        <div class="auth-form-wrap">

            <h1 class="auth-form-title">Set New Password</h1>
            <p class="auth-form-sub">Must be 7+ characters with an uppercase letter, a number, and a special character.</p>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/reset-password">
                <!-- Hidden token -->
                <input type="hidden" name="token" value="${token}"/>

                <div class="form-group">
                    <label class="form-label" for="newPassword">New Password</label>
                    <div class="password-wrap">
                        <input class="form-input" type="password" id="newPassword" name="newPassword"
                               placeholder="••••••••" autocomplete="new-password" required/>
                        <button type="button" class="toggle-pass"
                                onclick="togglePassword('newPassword', this)">Show</button>
                    </div>
                </div>

                <!-- Password strength bar -->
                <div class="pwd-strength-wrap">
                    <div class="pwd-strength-bar">
                        <div class="pwd-strength-fill" id="pwdFill"></div>
                    </div>
                    <div class="pwd-strength-hint" id="pwdHint"></div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <div class="password-wrap">
                        <input class="form-input" type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="••••••••" autocomplete="new-password" required/>
                        <button type="button" class="toggle-pass"
                                onclick="togglePassword('confirmPassword', this)">Show</button>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">Reset Password</button>
            </form>

            <p class="auth-back" style="margin-top:1.5rem;">
                <a href="${pageContext.request.contextPath}/login">← Back to Sign In</a>
            </p>

        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    /* Password strength meter */
    document.getElementById('newPassword').addEventListener('input', function () {
        var val  = this.value;
        var fill = document.getElementById('pwdFill');
        var hint = document.getElementById('pwdHint');
        var score = 0;
        if (val.length > 6)                   score++;
        if (/[A-Z]/.test(val))                score++;
        if (/[0-9]/.test(val))                score++;
        if (/[^A-Za-z0-9]/.test(val))         score++;

        var colors = ['#e8536a','#f4a050','#f4d050','#7dc670'];
        var labels = ['Weak','Fair','Good','Strong'];
        var widths = ['25%','50%','75%','100%'];

        if (val.length === 0) {
            fill.style.width = '0';
            hint.textContent = '';
        } else {
            fill.style.width      = widths[score - 1] || '25%';
            fill.style.background = colors[score - 1] || '#e8536a';
            hint.textContent      = labels[score - 1] || 'Weak';
            hint.style.color      = colors[score - 1] || '#e8536a';
        }
    });
</script>
</body>
</html>
