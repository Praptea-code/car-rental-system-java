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

        /* Highlight the input that has an error */
        .input-error {
            border-color: #e74c3c !important;
            background: #fffafa !important;
        }

        /* A small "ok" indicator when field is valid and has been touched */
        .field-ok {
            font-size: .68rem;
            color: #27ae60;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 4px 8px;
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

            <%-- 
                We no longer show a big top-level error banner.
                Field-level errors are shown inline below each field.
                The errorMessage from the server is parsed by JS to match the right field,
                but we also keep a fallback top alert for truly unexpected errors.
            --%>
            <c:if test="${not empty errorMessage}">
                <%-- Hidden span — JS will parse this and place it near the right field --%>
                <span id="serverErrorMsg" style="display:none"><c:out value="${errorMessage}"/></span>
            </c:if>

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
/* ============================================================
   Field-level error routing
   Maps server error messages → the correct field
   ============================================================ */
(function () {
    /* Map: substring in the server message → field id */
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

    function showFieldError(fieldId, message) {
        var errDiv  = document.getElementById('err-' + fieldId);
        var errText = document.getElementById('err-' + fieldId + '-text');
        var input   = document.getElementById(fieldId);
        if (!errDiv || !errText) return;
        errText.textContent = message;
        errDiv.style.display = 'flex';
        if (input) {
            input.classList.add('input-error');
            /* Scroll smoothly to the problematic field */
            input.scrollIntoView({ behavior: 'smooth', block: 'center' });
            input.focus();
        }
    }

    /* Read server error injected by JSP */
    var serverErrEl = document.getElementById('serverErrorMsg');
    if (serverErrEl) {
        var msg = serverErrEl.textContent.trim();
        if (msg) {
            var routed = false;
            for (var i = 0; i < errorRoutes.length; i++) {
                if (errorRoutes[i].match.test(msg)) {
                    showFieldError(errorRoutes[i].field, msg);
                    routed = true;
                    break;
                }
            }
            /* Fallback: show as a small top banner only if we couldn't route it */
            if (!routed) {
                var fallback = document.createElement('div');
                fallback.className = 'alert alert-error';
                fallback.textContent = msg;
                var form = document.getElementById('registerForm');
                if (form) form.parentNode.insertBefore(fallback, form);
            }
        }
    }

    /* ── Live client-side validation on blur ── */
    var form = document.getElementById('registerForm');
    if (!form) return;

    function clearFieldError(fieldId) {
        var errDiv = document.getElementById('err-' + fieldId);
        var input  = document.getElementById(fieldId);
        if (errDiv) errDiv.style.display = 'none';
        if (input)  input.classList.remove('input-error');
    }

    /* First Name */
    document.getElementById('firstName').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z\s]+$/.test(v)) {
            showFieldError('firstName', 'First name must contain only letters and spaces.');
        } else { clearFieldError('firstName'); }
    });

    /* Last Name */
    document.getElementById('lastName').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z\s]+$/.test(v)) {
            showFieldError('lastName', 'Last name must contain only letters and spaces.');
        } else { clearFieldError('lastName'); }
    });

    /* Username */
    document.getElementById('username').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || v.length <= 6 || !/^[A-Za-z0-9]+$/.test(v)) {
            showFieldError('username', 'Username must be more than 6 characters, letters and digits only.');
        } else { clearFieldError('username'); }
    });

    /* Email */
    document.getElementById('email').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(v)) {
            showFieldError('email', 'Please enter a valid email address.');
        } else { clearFieldError('email'); }
    });

    /* Phone */
    document.getElementById('phone').addEventListener('blur', function () {
        var v = this.value.trim();
        if (!v || !v.startsWith('+') || v.length !== 14) {
            showFieldError('phone', 'Phone must start with + and be exactly 14 characters.');
        } else { clearFieldError('phone'); }
    });

    /* Birthdate */
    document.getElementById('birthdate').addEventListener('blur', function () {
        var v = this.value;
        if (!v) {
            showFieldError('birthdate', 'Please enter your date of birth.');
        } else if (new Date(v) > new Date()) {
            showFieldError('birthdate', 'Birthdate cannot be in the future.');
        } else { clearFieldError('birthdate'); }
    });

    /* Password */
    document.getElementById('password').addEventListener('blur', function () {
        var v = this.value;
        if (!v || v.length <= 6) {
            showFieldError('password', 'Password must be more than 6 characters.');
        } else if (!/[A-Z]/.test(v) || !/[0-9]/.test(v) || !/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(v)) {
            showFieldError('password', 'Password must include at least one uppercase letter, one number, and one special character.');
        } else { clearFieldError('password'); }
    });

    /* Confirm Password */
    document.getElementById('retypePassword').addEventListener('blur', function () {
        var pw  = document.getElementById('password').value;
        var v   = this.value;
        if (!v) {
            showFieldError('retypePassword', 'Please confirm your password.');
        } else if (v !== pw) {
            showFieldError('retypePassword', 'Passwords do not match.');
        } else { clearFieldError('retypePassword'); }
    });

    /* Also recheck confirm on password change */
    document.getElementById('password').addEventListener('input', function () {
        var conf = document.getElementById('retypePassword');
        if (conf.value && conf.value !== this.value) {
            showFieldError('retypePassword', 'Passwords do not match.');
        } else if (conf.value) {
            clearFieldError('retypePassword');
        }
    });

}());
</script>
</body>
</html>
