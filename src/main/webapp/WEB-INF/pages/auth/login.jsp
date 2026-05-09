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
    <style>
        /* ── Remember me row ── */
        .auth-extras-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 4px 0 20px;
        }
        .remember-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #666;
            cursor: pointer;
            user-select: none;
        }
        .remember-label input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: #e8536a;
            cursor: pointer;
            border-radius: 4px;
        }
        .forgot-link {
            font-size: 13px;
            color: #e8536a;
            font-weight: 500;
            position: relative;
            transition: color .18s;
        }
        .forgot-link::after {
            content: '';
            position: absolute;
            bottom: -1px;
            left: 0;
            width: 0;
            height: 1px;
            background: #e8536a;
            transition: width .22s ease;
        }
        .forgot-link:hover::after { width: 100%; }
        .forgot-link:hover { color: #c0424e; }

        /* ── Divider ── */
        .auth-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0;
        }
        .auth-divider-line {
            flex: 1;
            height: 1px;
            background: #e8e0e0;
        }
        .auth-divider-text {
            font-size: 12px;
            color: #bbb;
            letter-spacing: .04em;
            white-space: nowrap;
        }

        /* ── Google button ── */
        .google-btn {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 12px 20px;
            background: #fff;
            border: 1.5px solid #e0d8d8;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #1a1a1a;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            transition: border-color .18s, background .18s, box-shadow .18s;
        }
        .google-btn:hover {
            border-color: #e8536a;
            background: #fdf8f8;
            box-shadow: 0 2px 12px rgba(232,83,106,.08);
        }
        .google-btn svg {
            flex-shrink: 0;
        }
        .google-btn-text { font-size: 14px; }

        /* ── Register nudge ── */
        .auth-form-sub { margin-bottom: 1.5rem; }
    </style>
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

            <!-- Google Sign-In -->
            <button type="button" class="google-btn" onclick="handleGoogleSignIn()">
                <svg width="18" height="18" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M47.532 24.552c0-1.636-.145-3.2-.415-4.698H24.48v8.883h12.94c-.558 3.003-2.25 5.547-4.793 7.254v6.03h7.763c4.54-4.181 7.142-10.337 7.142-17.469z" fill="#4285F4"/>
                    <path d="M24.48 48c6.487 0 11.927-2.15 15.9-5.81l-7.763-6.03c-2.15 1.44-4.903 2.29-8.137 2.29-6.254 0-11.552-4.226-13.44-9.903H2.97v6.228C6.929 42.796 15.115 48 24.48 48z" fill="#34A853"/>
                    <path d="M11.04 28.547A14.37 14.37 0 0 1 10.263 24c0-1.585.274-3.126.777-4.547v-6.228H2.97A23.972 23.972 0 0 0 .48 24c0 3.874.927 7.54 2.49 10.775l8.07-6.228z" fill="#FBBC05"/>
                    <path d="M24.48 9.554c3.524 0 6.684 1.211 9.171 3.588l6.874-6.874C36.4 2.388 30.966 0 24.48 0 15.115 0 6.929 5.204 2.97 13.225l8.07 6.228c1.888-5.677 7.186-9.9 13.44-9.9z" fill="#EA4335"/>
                </svg>
                <span class="google-btn-text">Continue with Google</span>
            </button>

            <!-- OR divider -->
            <div class="auth-divider">
                <div class="auth-divider-line"></div>
                <span class="auth-divider-text">or sign in with email</span>
                <div class="auth-divider-line"></div>
            </div>

            <!-- Email / password form -->
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

                <!-- Remember me + Forgot password row -->
                <div class="auth-extras-row">
                    <label class="remember-label">
                        <input type="checkbox" name="rememberMe" value="true">
                        Remember me
                    </label>
                    <a href="<%= contextPath %>/forgot-password" class="forgot-link">Forgot password?</a>
                </div>

                <button type="submit" class="auth-submit-btn">Sign In</button>
            </form>

            <p class="auth-back"><a href="<%= contextPath %>/home">&larr; Back to Home</a></p>
        </div>
    </div>
</div>

<script src="<%= contextPath %>/js/main.js"></script>
<script>
function handleGoogleSignIn() {
    /*
     * TODO: Replace the alert below with your Google OAuth 2.0 implementation.
     *
     * Quick setup guide:
     * 1. Go to https://console.cloud.google.com → APIs & Services → Credentials
     * 2. Create an OAuth 2.0 Client ID (Web application)
     * 3. Add your redirect URI: http://localhost:8080/spra/oauth2/callback
     * 4. Drop the client ID into the URL below, then implement the
     *    /oauth2/callback servlet to exchange the auth code for user info.
     *
     * Example redirect (replace YOUR_CLIENT_ID):
     *
     *   var CLIENT_ID  = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
     *   var REDIRECT   = encodeURIComponent(window.location.origin + '<%= contextPath %>/oauth2/callback');
     *   var SCOPE      = encodeURIComponent('openid email profile');
     *   var STATE      = Math.random().toString(36).substring(2);
     *   sessionStorage.setItem('oauth_state', STATE);
     *   window.location.href =
     *       'https://accounts.google.com/o/oauth2/v2/auth'
     *       + '?client_id=' + CLIENT_ID
     *       + '&redirect_uri=' + REDIRECT
     *       + '&response_type=code'
     *       + '&scope=' + SCOPE
     *       + '&state=' + STATE;
     */
    alert('Google Sign-In is not configured yet.\n\nSee the code comment in login.jsp → handleGoogleSignIn() for setup instructions.');
}
</script>
</body>
</html>
