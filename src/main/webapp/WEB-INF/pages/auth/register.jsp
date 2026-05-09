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
    <style>
        /* ── Field-level error styles ── */
        .field-error {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: .72rem;
            color: #c0392b;
            margin-top: 5px;
            padding: 6px 10px;
            background: #fdf0f0;
            border-left: 3px solid #e74c3c;
            border-radius: 0 6px 6px 0;
            animation: errSlide .2s ease;
        }
        @keyframes errSlide {
            from { opacity: 0; transform: translateX(-6px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        .field-error svg { flex-shrink: 0; }
        .input-error { border-color: #e74c3c !important; background: #fffafa !important; }
        .field-ok {
            font-size: .68rem; color: #27ae60; margin-top: 4px;
            display: flex; align-items: center; gap: 5px; padding: 4px 8px;
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
            margin-bottom: 0;
        }
        .google-btn:hover {
            border-color: #e8536a;
            background: #fdf8f8;
            box-shadow: 0 2px 12px rgba(232,83,106,.08);
        }

        /* ── Divider ── */
        .auth-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 18px 0;
        }
        .auth-divider-line { flex: 1; height: 1px; background: #e8e0e0; }
        .auth-divider-text {
            font-size: 12px; color: #bbb;
            letter-spacing: .04em; white-space: nowrap;
        }
    </style>
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

            <c:if test="${not empty errorMessage}">
                <span id="serverErrorMsg" style="display:none"><c:out value="${errorMessage}"/></span>
            </c:if>

            <!-- Google Sign-Up -->
            <button type="button" class="google-btn" onclick="handleGoogleSignUp()">
                <svg width="18" height="18" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M47.532 24.552c0-1.636-.145-3.2-.415-4.698H24.48v8.883h12.94c-.558 3.003-2.25 5.547-4.793 7.254v6.03h7.763c4.54-4.181 7.142-10.337 7.142-17.469z" fill="#4285F4"/>
                    <path d="M24.48 48c6.487 0 11.927-2.15 15.9-5.81l-7.763-6.03c-2.15 1.44-4.903 2.29-8.137 2.29-6.254 0-11.552-4.226-13.44-9.903H2.97v6.228C6.929 42.796 15.115 48 24.48 48z" fill="#34A853"/>
                    <path d="M11.04 28.547A14.37 14.37 0 0 1 10.263 24c0-1.585.274-3.126.777-4.547v-6.228H2.97A23.972 23.972 0 0 0 .48 24c0 3.874.927 7.54 2.49 10.775l8.07-6.228z" fill="#FBBC05"/>
                    <path d="M24.48 9.554c3.524 0 6.684 1.211 9.171 3.588l6.874-6.874C36.4 2.388 30.966 0 24.48 0 15.115 0 6.929 5.204 2.97 13.225l8.07 6.228c1.888-5.677 7.186-9.9 13.44-9.9z" fill="#EA4335"/>
                </svg>
                Continue with Google
            </button>

            <!-- OR divider -->
            <div class="auth-divider">
                <div class="auth-divider-line"></div>
                <span class="auth-divider-text">or register with email</span>
                <div class="auth-divider-line"></div>
            </div>

            <!-- Registration form -->
            <form action="<%= contextPath %>/register" method="post" class="auth-form" novalidate id="registerForm">

                <div class="form-row-2">
                    <div class="form-group" id="grp-firstName">
                        <label class="form-label" for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-input"
                               placeholder="First name"
                               value="<c:out value='${firstName}'/>" required>
                        <span class="field-hint">Letters only</span>
                        <div class="field-error" id="err-firstName" style="display:none">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <span id="err-firstName-text"></span>
                        </div>
                    </div>
                    <div class="form-group" id="grp-lastName">
                        <label class="form-label" for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-input"
                               placeholder="Last name"
                               value="<c:out value='${lastName}'/>" required>
                        <span class="field-hint">Letters only</span>
                        <div class="field-error" id="err-lastName" style="display:none">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                            <span id="err-lastName-text"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="grp-username">
                    <label class="form-label" for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="Must be more than 6 characters"
                           value="<c:out value='${username}'/>" required>
                    <span class="field-hint">Letters and digits only, min 7 characters</span>
                    <div class="field-error" id="err-username" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-username-text"></span>
                    </div>
                </div>

                <div class="form-group" id="grp-email">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="hello@example.com"
                           value="<c:out value='${email}'/>" required>
                    <div class="field-error" id="err-email" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-email-text"></span>
                    </div>
                </div>

                <div class="form-group" id="grp-phone">
                    <label class="form-label" for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" class="form-input"
                           placeholder="+97798123456789"
                           value="<c:out value='${phone}'/>" required>
                    <span class="field-hint">Start with + and be exactly 14 characters</span>
                    <div class="field-error" id="err-phone" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-phone-text"></span>
                    </div>
                </div>

                <div class="form-group" id="grp-birthdate">
                    <label class="form-label" for="birthdate">Date of Birth</label>
                    <input type="date" id="birthdate" name="birthdate" class="form-input"
                           value="<c:out value='${birthdate}'/>" required>
                    <span class="field-hint">Must not be a future date</span>
                    <div class="field-error" id="err-birthdate" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-birthdate-text"></span>
                    </div>
                </div>

                <div class="form-group" id="grp-password">
                    <label class="form-label" for="password">Password</label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="Min 7 chars, uppercase, digit, special char" required>
                        <button type="button" class="toggle-pass" onclick="togglePassword('password', this)">Show</button>
                    </div>
                    <div class="field-error" id="err-password" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-password-text"></span>
                    </div>
                </div>

                <div class="form-group" id="grp-retypePassword">
                    <label class="form-label" for="retypePassword">Confirm Password</label>
                    <div class="password-wrap">
                        <input type="password" id="retypePassword" name="retypePassword" class="form-input"
                               placeholder="Re-enter your password" required>
                        <button type="button" class="toggle-pass" onclick="togglePassword('retypePassword', this)">Show</button>
                    </div>
                    <div class="field-error" id="err-retypePassword" style="display:none">
                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        <span id="err-retypePassword-text"></span>
                    </div>
                </div>

                <button type="submit" class="auth-submit-btn">Create Account</button>
            </form>

            <p class="auth-back"><a href="<%= contextPath %>/home">&larr; Back to Home</a></p>
        </div>
    </div>
</div>

<script src="<%= contextPath %>/js/main.js"></script>
<script>
function handleGoogleSignUp() {
    /*
     * TODO: Same Google OAuth setup as login.jsp.
     * The same /oauth2/callback servlet handles both sign-in and sign-up —
     * if the Google email isn't in your DB yet, auto-create the account there.
     */
    alert('Google Sign-Up is not configured yet.\n\nSee the code comment in register.jsp → handleGoogleSignUp() for setup instructions.');
}

(function () {
    var errorRoutes = [
        { match: /first name/i,            field: 'firstName' },
        { match: /last name/i,             field: 'lastName' },
        { match: /username.*more than 6/i, field: 'username' },
        { match: /username.*already/i,     field: 'username' },
        { match: /username/i,              field: 'username' },
        { match: /email.*already/i,        field: 'email' },
        { match: /valid email/i,           field: 'email' },
        { match: /phone.*already/i,        field: 'phone' },
        { match: /phone/i,                 field: 'phone' },
        { match: /birthdate/i,             field: 'birthdate' },
        { match: /password.*more than 6/i, field: 'password' },
        { match: /password.*match/i,       field: 'retypePassword' },
        { match: /passwords do not/i,      field: 'retypePassword' },
        { match: /password/i,              field: 'password' }
    ];

    function showFieldError(fieldId, message, autoFocus) {
        var errDiv  = document.getElementById('err-' + fieldId);
        var errText = document.getElementById('err-' + fieldId + '-text');
        var input   = document.getElementById(fieldId);
        if (!errDiv || !errText) return;
        errText.textContent = message;
        errDiv.style.display = 'flex';
        if (input) input.classList.add('input-error');
        if (autoFocus && input) {
            input.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    function clearFieldError(fieldId) {
        var errDiv = document.getElementById('err-' + fieldId);
        var input  = document.getElementById(fieldId);
        if (errDiv) errDiv.style.display = 'none';
        if (input)  input.classList.remove('input-error');
    }

    var serverErrEl = document.getElementById('serverErrorMsg');
    if (serverErrEl) {
        var msg = serverErrEl.textContent.trim();
        if (msg) {
            var routed = false;
            for (var i = 0; i < errorRoutes.length; i++) {
                if (errorRoutes[i].match.test(msg)) {
                    showFieldError(errorRoutes[i].field, msg, true);
                    routed = true;
                    break;
                }
            }
            if (!routed) {
                var fallback = document.createElement('div');
                fallback.className = 'alert alert-error';
                fallback.textContent = msg;
                var form = document.getElementById('registerForm');
                if (form) form.parentNode.insertBefore(fallback, form);
            }
        }
    }

    var form = document.getElementById('registerForm');
    if (!form) return;

    document.getElementById('firstName').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z\s]+$/.test(v)) showFieldError('firstName', 'First name must contain only letters and spaces.');
        else clearFieldError('firstName');
    });

    document.getElementById('lastName').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z\s]+$/.test(v)) showFieldError('lastName', 'Last name must contain only letters and spaces.');
        else clearFieldError('lastName');
    });

    document.getElementById('username').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || v.length <= 6 || !/^[A-Za-z0-9]+$/.test(v)) showFieldError('username', 'Username must be more than 6 characters, letters and digits only.');
        else clearFieldError('username');
    });

    document.getElementById('email').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(v)) showFieldError('email', 'Please enter a valid email address.');
        else clearFieldError('email');
    });

    document.getElementById('phone').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !v.startsWith('+') || v.length !== 14) showFieldError('phone', 'Phone must start with + and be exactly 14 characters.');
        else clearFieldError('phone');
    });

    document.getElementById('birthdate').addEventListener('blur', function () {
        var v = this.value;
        if (!v) showFieldError('birthdate', 'Please enter your date of birth.');
        else if (new Date(v) > new Date()) showFieldError('birthdate', 'Birthdate cannot be in the future.');
        else clearFieldError('birthdate');
    });

    document.getElementById('password').addEventListener('blur', function () {
        var v = this.value;
        if (!v || v.length <= 6) showFieldError('password', 'Password must be more than 6 characters.');
        else if (!/[A-Z]/.test(v) || !/[0-9]/.test(v) || !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(v))
            showFieldError('password', 'Password must include at least one uppercase letter, one number, and one special character.');
        else clearFieldError('password');
    });

    document.getElementById('retypePassword').addEventListener('blur', function () {
        var pw = document.getElementById('password').value;
        var v  = this.value;
        if (!v) showFieldError('retypePassword', 'Please confirm your password.');
        else if (v !== pw) showFieldError('retypePassword', 'Passwords do not match.');
        else clearFieldError('retypePassword');
    });

    document.getElementById('password').addEventListener('input', function () {
        var conf = document.getElementById('retypePassword');
        if (conf.value && conf.value !== this.value) showFieldError('retypePassword', 'Passwords do not match.');
        else if (conf.value) clearFieldError('retypePassword');
    });
}());
</script>
</body>
</html>
