<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
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
    <title>Page Not Found — Spra.</title>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <style>
        .error-page {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #fdf8f8;
            text-align: center;
            padding: 2rem;
        }
        .error-code {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(80px, 20vw, 160px);
            font-weight: 300;
            color: #f0e0e0;
            line-height: 1;
            margin-bottom: 0;
        }
        .error-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(24px, 4vw, 36px);
            font-weight: 400;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        .error-title em { font-style: italic; color: #e8536a; }
        .error-sub {
            font-size: 15px;
            color: #888;
            line-height: 1.7;
            max-width: 420px;
            margin-bottom: 2.5rem;
        }
        .error-divider {
            width: 50px;
            height: 1px;
            background: #e8536a;
            margin: 0 auto 2rem;
        }
        .error-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: center;
        }
        .error-btn-primary {
            background: #e8536a;
            color: #fff;
            padding: 12px 28px;
            border-radius: 28px;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            transition: opacity .2s;
        }
        .error-btn-primary:hover { opacity: .88; color: #fff; }
        .error-btn-outline {
            background: #fff;
            color: #555;
            padding: 12px 28px;
            border-radius: 28px;
            font-size: 14px;
            border: 1.5px solid #e8d8da;
            text-decoration: none;
            transition: border-color .2s, color .2s;
        }
        .error-btn-outline:hover { border-color: #e8536a; color: #e8536a; }
        .error-logo {
            font-family: 'Cormorant Garamond', serif;
            font-size: 22px;
            font-weight: 600;
            color: #1a1a1a;
            letter-spacing: 3px;
            margin-bottom: 3rem;
            text-decoration: none;
        }
        .error-logo span { color: #e8536a; }
    </style>
</head>
<body>
<div class="error-page">
    <a href="<%= contextPath %>/home" class="error-logo">SPR<span>A</span>.</a>

    <div class="error-code">404</div>

    <h1 class="error-title">Page <em>Not Found</em></h1>
    <div class="error-divider"></div>
    <p class="error-sub">
        The page you're looking for doesn't exist or may have been moved.
        Let's get you back to something beautiful.
    </p>

    <div class="error-actions">
        <a href="<%= contextPath %>/home" class="error-btn-primary">Go to Home</a>
        <a href="<%= contextPath %>/products" class="error-btn-outline">Browse Products</a>
        <% if (currentUser != null) { %>
            <a href="<%= contextPath %>/user/profile" class="error-btn-outline">My Profile</a>
        <% } else { %>
            <a href="<%= contextPath %>/login" class="error-btn-outline">Sign In</a>
        <% } %>
    </div>
</div>
</body>
</html>