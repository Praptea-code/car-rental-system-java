<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Login — Spra</title>
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="icon" type="image/svg+xml"
	href="${pageContext.request.contextPath}/assets/images/favicon.svg">
<link
	href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/auth.css" />

</head>
<body class="auth-body">
	<div class="auth-container">

		<!-- ── Left decorative panel ── -->
		<div class="auth-panel">
			<div class="auth-panel-content">
				<div class="auth-logo">
					SPR<span>A</span>
				</div>
				<div class="auth-panel-title">
					Welcome<br /> <em>back.</em>
				</div>
				<p class="auth-panel-sub">
					Your beauty ritual<br />is waiting for you.
				</p>
			</div>
		</div>

		<!-- ── Right form panel ── -->
		<div class="auth-form-panel">
			<div class="auth-form-wrap">

				<h1 class="auth-form-title">Sign in</h1>
				<p class="auth-form-sub">
					Don't have an account? <a class="auth-link"
						href="${pageContext.request.contextPath}/register">Create one</a>
				</p>

				<!-- Flash messages -->
				<c:if test="${not empty successMessage}">
					<div class="alert alert-success">${successMessage}</div>
					<c:remove var="successMessage" scope="session" />
				</c:if>
				<c:if test="${not empty errorMessage}">
					<div class="alert alert-error">${errorMessage}</div>
				</c:if>

				<!-- Google Sign-In button -->
				<a href="${pageContext.request.contextPath}/auth/google"
					class="auth-google-btn"> <!-- Official Google "G" SVG --> <svg
						class="auth-google-icon" viewBox="0 0 24 24"
						xmlns="http://www.w3.org/2000/svg">
                    <path
							d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
							fill="#4285F4" />
                    <path
							d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
							fill="#34A853" />
                    <path
							d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"
							fill="#FBBC05" />
                    <path
							d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
							fill="#EA4335" />
                </svg> Continue with Google
				</a>

				<div class="auth-divider">or sign in with username</div>

				<!-- Email/password form -->
				<form method="post"
					action="${pageContext.request.contextPath}/login">

					<div class="form-group">
						<label class="form-label" for="username">Username</label> <input
							class="form-input" type="text" id="username" name="username"
							value="${username}" placeholder="your_username"
							autocomplete="username" required />
					</div>

					<div class="form-group">
						<label class="form-label" for="password">Password</label>
						<div class="password-wrap">
							<input class="form-input" type="password" id="password"
								name="password" placeholder="••••••••"
								autocomplete="current-password" required />
							<button type="button" class="toggle-pass"
								onclick="togglePassword('password', this)">Show</button>
						</div>
					</div>

					<!-- ── Remember Me + Forgot Password row ── -->
					<div class="auth-options-row">
						<label class="auth-remember"> <input type="checkbox"
							name="rememberMe" id="rememberMe" /> Remember me for 30 days
						</label> <a class="auth-forgot-link"
							href="${pageContext.request.contextPath}/forgot-password">
							Forgot password? </a>
					</div>

					<button type="submit" class="auth-submit-btn">Sign In</button>
				</form>

				<p class="auth-back">
					<a href="${pageContext.request.contextPath}/home">← Back to
						store</a>
				</p>

			</div>
		</div>
	</div>

	<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
