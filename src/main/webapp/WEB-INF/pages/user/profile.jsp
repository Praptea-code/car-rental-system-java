<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="openTab" value="${param.tab != null ? param.tab : 'account'}"/>
<c:set var="currentUser" value="${sessionScope.loggedInUser}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Spra. – My Profile</title>
    <link rel="stylesheet" href="${contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --pink: #e8536a; --pink-light: #fdf2f4; --pink-mid: #f4a0b0;
            --dark: #1a1a1a; --mid: #555; --muted: #888;
            --border: #e8d8da; --bg-soft: #fdf8f8;
        }
        .profile-page-wrap { min-height: 100vh; background: #fdf8f8; }
        /* ── Hero ── */
        .profile-hero { background: linear-gradient(135deg, #2a1215 0%, #1a1a1a 50%, #3a1820 100%); padding: 52px 48px 40px; position: relative; overflow: hidden; }
        .profile-hero::before { content:''; position:absolute; top:-80px; right:-80px; width:320px; height:320px; border-radius:50%; background:rgba(232,83,106,.1); pointer-events:none; }
        .profile-hero-inner { position:relative; z-index:2; max-width:1100px; margin:0 auto; display:flex; align-items:center; gap:28px; }
        .ph-avatar-wrap { width:84px; height:84px; border-radius:50%; background:linear-gradient(135deg,#e8536a 0%,#c0424e 100%); display:flex; align-items:center; justify-content:center; flex-shrink:0; box-shadow:0 4px 24px rgba(232,83,106,.35); border:3px solid rgba(255,255,255,.12); }
        .ph-initials { font-family:'Cormorant Garamond',serif; font-size:2rem; font-weight:600; color:#fff; text-transform:uppercase; letter-spacing:2px; }
        .ph-info { flex:1; }
        .ph-eyebrow { font-size:.58rem; font-weight:700; letter-spacing:.22em; color:var(--pink); text-transform:uppercase; margin-bottom:6px; display:flex; align-items:center; gap:8px; }
        .ph-eyebrow::before { content:''; width:20px; height:1.5px; background:var(--pink); flex-shrink:0; }
        .ph-name { font-family:'Cormorant Garamond',serif; font-size:clamp(1.8rem,3vw,2.4rem); font-weight:400; color:#fff; line-height:1.1; margin-bottom:6px; }
        .ph-name em { font-style:italic; color:#f4a0b0; }
        .ph-meta { font-size:.78rem; color:rgba(255,255,255,.42); }
        .ph-stats { display:flex; gap:0; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1); border-radius:10px; overflow:hidden; margin-left:auto; flex-shrink:0; }
        .ph-stat { padding:14px 26px; text-align:center; border-right:1px solid rgba(255,255,255,.08); }
        .ph-stat:last-child { border-right:none; }
        .ph-stat-num { font-family:'Cormorant Garamond',serif; font-size:1.5rem; font-weight:700; color:#fff; line-height:1; }
        .ph-stat-lbl { font-size:.58rem; color:rgba(255,255,255,.35); text-transform:uppercase; letter-spacing:.1em; margin-top:4px; }
        /* ── Layout ── */
        .profile-layout { max-width:1100px; margin:0 auto; padding:40px 48px 80px; display:grid; grid-template-columns:220px 1fr; gap:22px; align-items:start; }
        /* ── Sidebar ── */
        .profile-sidebar { position:sticky; top:80px; display:flex; flex-direction:column; gap:6px; }
        .pnav-btn { display:flex; align-items:center; gap:10px; padding:13px 16px; border-radius:10px; cursor:pointer; border:1.5px solid var(--border); background:#fff; color:var(--mid); font-weight:500; font-size:.82rem; transition:all .18s; text-align:left; width:100%; font-family:'DM Sans',sans-serif; }
        .pnav-btn:hover { border-color:#f4a0b0; color:var(--dark); }
        .pnav-btn.active { border-color:var(--pink); background:#fff8f8; color:var(--dark); font-weight:600; }
        .pnav-btn.active svg { color:var(--pink); }
        .pnav-badge { margin-left:auto; font-size:.58rem; font-weight:700; background:var(--pink); color:#fff; padding:2px 8px; border-radius:10px; }
        .pnav-btn:not(.active) .pnav-badge { background:var(--border); color:var(--mid); }
        .pnav-divider { border:none; border-top:1px solid var(--border); margin:8px 0; }
        .pnav-link { display:flex; align-items:center; gap:8px; padding:10px 14px; font-size:.75rem; color:var(--muted); cursor:pointer; background:none; border:none; width:100%; text-align:left; transition:color .15s; font-family:'DM Sans',sans-serif; }
        .pnav-link:hover { color:var(--pink); }
        /* ── Main ── */
        .profile-main { min-width:0; }
        .p-alert { padding:12px 16px; border-radius:8px; font-size:.82rem; margin-bottom:18px; }
        .p-alert-ok  { background:#eaf3de; color:#3B6D11; border:1px solid #c0dd97; }
        .p-alert-err { background:#fceaea; color:#a32d2d; border:1px solid #f09595; }
        .ptab { display:none; }
        .ptab.active { display:block; }
        /* ── Cards ── */
        .pcard { background:#fff; border:1px solid var(--border); border-radius:16px; overflow:hidden; margin-bottom:18px; }
        .pcard-head { padding:20px 28px; border-bottom:1px solid #f8f0f0; background:#fdf8f8; }
        .pcard-title { font-family:'Cormorant Garamond',serif; font-size:1.3rem; font-weight:600; color:var(--dark); }
        .pcard-sub { font-size:.72rem; color:var(--muted); margin-top:2px; }
        .pcard-body { padding:24px 28px; }
        /* ── Forms ── */
        .pf-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px; }
        .pf-grp { margin-bottom:16px; }
        .pf-lbl { display:block; font-size:.7rem; font-weight:600; letter-spacing:.08em; text-transform:uppercase; color:var(--muted); margin-bottom:6px; }
        .pf-inp { width:100%; padding:11px 14px; border:1.5px solid var(--border); border-radius:8px; font-family:'DM Sans',sans-serif; font-size:.88rem; color:var(--dark); background:#fff; outline:none; transition:border-color .18s; }
        .pf-inp:focus { border-color:var(--pink); }
        .pf-inp[readonly] { background:#f8f8f8; color:#aaa; cursor:not-allowed; }
        .pf-hint { font-size:.65rem; color:var(--muted); margin-top:4px; display:block; }
        .p-btn { display:inline-flex; align-items:center; gap:8px; padding:11px 22px; border-radius:8px; font-size:.82rem; font-weight:600; font-family:'DM Sans',sans-serif; cursor:pointer; transition:all .18s; text-decoration:none; white-space:nowrap; border:1.5px solid transparent; }
        .p-btn-primary { background:var(--pink); color:#fff; border-color:var(--pink); }
        .p-btn-primary:hover { opacity:.88; color:#fff; }
        .p-btn-outline { background:#fff; color:var(--dark); border-color:var(--border); }
        .p-btn-outline:hover { border-color:var(--pink); color:var(--pink); }
        .p-btn-full { width:100%; justify-content:center; margin-top:8px; }
        .password-wrap { position:relative; }
        .password-wrap .pf-inp { padding-right:56px; }
        .toggle-pass { position:absolute; right:10px; top:50%; transform:translateY(-50%); background:none; border:none; font-size:.72rem; color:#aaa; cursor:pointer; font-family:'DM Sans',sans-serif; }
        .toggle-pass:hover { color:var(--pink); }
        /* ── Info tiles ── */
        .info-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; margin-bottom:18px; }
        .info-tile { background:#fdf8f8; border:1px solid var(--border); border-radius:10px; padding:16px 18px; }
        .info-lbl { font-size:.58rem; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--muted); margin-bottom:5px; }
        .info-val { font-size:.9rem; font-weight:600; color:var(--dark); }
        .status-dot { display:inline-flex; align-items:center; gap:6px; }
        .status-dot::before { content:''; width:8px; height:8px; border-radius:50%; background:#3B9B3F; display:inline-block; }
        /* ── Cart items ── */
        .cart-panel-grid { display:grid; grid-template-columns:1fr 290px; gap:16px; align-items:start; }
        .cart-rows { display:flex; flex-direction:column; gap:8px; }
        .cart-row { display:flex; align-items:center; gap:14px; padding:12px 14px; background:#fdf8f8; border:1px solid var(--border); border-radius:10px; }
        .ci-img { width:56px; height:56px; border-radius:8px; background:#f0e8e8; flex-shrink:0; overflow:hidden; display:flex; align-items:center; justify-content:center; }
        .ci-img img { width:100%; height:100%; object-fit:cover; }
        .ci-ph { font-size:1.4rem; }
        .ci-info { flex:1; min-width:0; }
        .ci-cat { font-size:.6rem; color:var(--muted); text-transform:uppercase; letter-spacing:1px; }
        .ci-name { font-family:'Cormorant Garamond',serif; font-size:1rem; font-weight:600; color:var(--dark); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .ci-price { font-size:.8rem; font-weight:600; color:var(--pink); }
        .ci-sub { font-size:.88rem; font-weight:700; color:var(--dark); flex-shrink:0; }
        /* Summary */
        .sum-card { background:#fdf8f8; border:1px solid var(--border); border-radius:14px; padding:22px; position:sticky; top:80px; }
        .sum-title { font-family:'Cormorant Garamond',serif; font-size:1.2rem; font-weight:600; color:var(--dark); margin-bottom:16px; }
        .sum-line { display:flex; justify-content:space-between; font-size:.8rem; color:var(--mid); margin-bottom:10px; }
        .sum-div { border:none; border-top:1px solid var(--border); margin:12px 0; }
        .sum-total { font-size:1rem; font-weight:700; color:var(--dark); }
        .sum-cta { width:100%; background:var(--pink); color:#fff; border:none; padding:13px; border-radius:8px; font-size:.82rem; font-weight:600; cursor:pointer; margin-top:14px; transition:opacity .2s; font-family:'DM Sans',sans-serif; display:block; text-align:center; }
        .sum-cta:hover { opacity:.88; color:#fff; }
        /* Empty */
        .cart-empty { text-align:center; padding:48px 20px; }
        .cart-empty-icon { font-size:3rem; margin-bottom:12px; opacity:.25; }
        .cart-empty-txt { font-family:'Cormorant Garamond',serif; font-style:italic; color:var(--muted); margin-bottom:16px; }
        .cart-empty-btn { display:inline-block; background:var(--pink); color:#fff; padding:11px 24px; border-radius:22px; font-size:.8rem; font-weight:600; transition:opacity .2s; }
        .cart-empty-btn:hover { opacity:.88; color:#fff; }
        /* Password strength */
        .pwd-bar-wrap { margin:8px 0 14px; }
        .pwd-bar-track { height:4px; background:var(--border); border-radius:2px; overflow:hidden; }
        .pwd-bar-fill { height:100%; border-radius:2px; transition:width .3s,background .3s; }
        .pwd-bar-hint { font-size:.68rem; color:var(--muted); margin-top:5px; }
        .req-list { background:#fdf8f8; border:1px solid var(--border); border-radius:8px; padding:14px 16px; margin-bottom:16px; }
        .req-list-title { font-size:.7rem; font-weight:700; color:var(--muted); text-transform:uppercase; letter-spacing:.08em; margin-bottom:8px; }
        .req-item { font-size:.72rem; color:#bbb; display:flex; align-items:center; gap:6px; margin-bottom:5px; transition:color .2s; }
        .req-item.ok { color:#3B9B3F; }
        .btn-badge { background:rgba(255,255,255,.25); color:#fff; font-size:.58rem; padding:2px 7px; border-radius:10px; }
        .p-btn-outline .btn-badge { background:var(--pink); color:#fff; }
        /* ── ORDERS TAB ── */
        .orders-list { display:flex; flex-direction:column; gap:14px; }
        .order-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
        .order-card-head { display:flex; align-items:center; justify-content:space-between; padding:14px 20px; background:#fdf8f8; border-bottom:1px solid #f8f0f0; flex-wrap:wrap; gap:10px; }
        .order-id { font-size:.7rem; font-weight:700; letter-spacing:.12em; text-transform:uppercase; color:var(--muted); }
        .order-date { font-size:.72rem; color:var(--muted); }
        .order-status-badge { font-size:.68rem; font-weight:700; padding:4px 12px; border-radius:20px; text-transform:uppercase; letter-spacing:.08em; }
        .os-ORDERED   { background:#eff6ff; color:#3b82f6; border:1px solid #bfdbfe; }
        .os-SHIPPED   { background:#fffbeb; color:#d97706; border:1px solid #fde68a; }
        .os-DELIVERED { background:#f0fdf4; color:#16a34a; border:1px solid #bbf7d0; }
        .os-CANCELLED { background:#fef2f2; color:#dc2626; border:1px solid #fecaca; }
        .order-card-body { padding:16px 20px; }
        .order-delivery-info { display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:14px; }
        .order-info-tile { }
        .order-info-lbl { font-size:.58rem; font-weight:700; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); margin-bottom:3px; }
        .order-info-val { font-size:.84rem; color:var(--dark); font-weight:500; }
        .order-total-row { display:flex; justify-content:space-between; align-items:center; padding-top:12px; border-top:1px solid #f8f0f0; }
        .order-total-lbl { font-size:.78rem; color:var(--muted); }
        .order-total-amt { font-family:'Cormorant Garamond',serif; font-size:1.4rem; font-weight:600; color:var(--dark); }
        /* Timeline */
        .order-timeline { display:flex; align-items:center; gap:0; margin-top:14px; padding-top:14px; border-top:1px solid #f8f0f0; }
        .tl-step { display:flex; flex-direction:column; align-items:center; flex:1; position:relative; }
        .tl-step::after { content:''; position:absolute; top:12px; left:50%; width:100%; height:2px; background:#f0e0e0; z-index:0; }
        .tl-step:last-child::after { display:none; }
        .tl-dot { width:24px; height:24px; border-radius:50%; background:#f0e0e0; display:flex; align-items:center; justify-content:center; z-index:1; position:relative; border:2px solid #fff; }
        .tl-dot.done { background:var(--pink); }
        .tl-dot.done svg { color:#fff; }
        .tl-dot svg { color:#ccc; }
        .tl-label { font-size:.58rem; color:var(--muted); margin-top:6px; text-align:center; text-transform:uppercase; letter-spacing:.05em; }
        .tl-label.done { color:var(--pink); font-weight:600; }
        /* cart badge nav */
        .cart-icon-btn { position:relative; }
        .cart-badge { position:absolute; top:-6px; right:-6px; background:var(--pink); color:#fff; font-size:10px; font-weight:600; width:18px; height:18px; border-radius:50%; display:flex; align-items:center; justify-content:center; line-height:1; }
        /* Responsive */
        @media (max-width:900px) { .profile-layout { grid-template-columns:1fr; padding:24px; } .profile-sidebar { position:static; flex-direction:row; flex-wrap:wrap; } .ph-stats { display:none; } .cart-panel-grid { grid-template-columns:1fr; } .info-grid { grid-template-columns:1fr; } .order-delivery-info { grid-template-columns:1fr; } }
        @media (max-width:600px) { .profile-hero { padding:36px 24px; } .profile-hero-inner { flex-direction:column; text-align:center; align-items:center; } .ph-eyebrow::before { display:none; } .pf-row { grid-template-columns:1fr; } }
    </style>
</head>
<body>

<!-- NAV -->
<nav class="nav">
    <div class="nav-logo">SΡRA<span class="nav-dot">.</span></div>
    <ul class="nav-links">
        <li><a href="${contextPath}/home">Home</a></li>
        <li><a href="${contextPath}/products">Products</a></li>
        <li><a href="${contextPath}/about">About</a></li>
        <li><a href="${contextPath}/contact">Contact</a></li>
    </ul>
    <div class="nav-right">
        <a href="${contextPath}/products" class="nav-icon-btn" title="Search">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        </a>
        <a href="${contextPath}/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
            <c:if test="${not empty cart and cart.totalCount > 0}">
                <span class="cart-badge">${cart.totalCount}</span>
            </c:if>
        </a>
        <div class="nav-user-wrap">
            <span class="nav-username">Hi, ${currentUser.firstName}</span>
            <c:if test="${currentUser.role == 'ADMIN'}">
                <a href="${contextPath}/admin/dashboard" class="nav-admin-btn">Dashboard</a>
            </c:if>
            <a href="${contextPath}/user/profile" class="nav-profile-btn">Profile</a>
            <form action="${contextPath}/logout" method="post" style="display:inline">
                <button type="submit" class="nav-logout-btn">Logout</button>
            </form>
        </div>
    </div>
</nav>

<div class="profile-page-wrap">

    <!-- HERO -->
    <div class="profile-hero">
        <div class="profile-hero-inner">
            <div class="ph-avatar-wrap">
                <span class="ph-initials">
                    ${fn:substring(currentUser.firstName,0,1)}${fn:substring(currentUser.lastName,0,1)}
                </span>
            </div>
            <div class="ph-info">
                <div class="ph-eyebrow">My Account</div>
                <div class="ph-name">Hey, <em>${currentUser.firstName}!</em></div>
                <div class="ph-meta">${currentUser.email}&nbsp;&middot;&nbsp;${currentUser.role}</div>
            </div>
            <div class="ph-stats">
                <div class="ph-stat">
                    <div class="ph-stat-num"><c:choose><c:when test="${empty cart}">0</c:when><c:otherwise>${cart.totalCount}</c:otherwise></c:choose></div>
                    <div class="ph-stat-lbl">Cart</div>
                </div>
                <div class="ph-stat">
                    <div class="ph-stat-num">${wishlistCount}</div>
                    <div class="ph-stat-lbl">Wishlist</div>
                </div>
                <div class="ph-stat">
                    <div class="ph-stat-num">${fn:length(orders)}</div>
                    <div class="ph-stat-lbl">Orders</div>
                </div>
                <div class="ph-stat">
                    <div class="ph-stat-num" style="font-size:1.1rem;color:#f4a0b0;">
                        <c:choose><c:when test="${currentUser.role == 'ADMIN'}">Admin</c:when><c:otherwise>Member</c:otherwise></c:choose>
                    </div>
                    <div class="ph-stat-lbl">Status</div>
                </div>
            </div>
        </div>
    </div>

    <!-- LAYOUT -->
    <div class="profile-layout">

        <!-- Sidebar -->
        <aside class="profile-sidebar">
            <button class="pnav-btn active" onclick="switchTab('account',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/></svg>
                Account Info
            </button>
            <button class="pnav-btn" onclick="switchTab('orders',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="m9 12 2 2 4-4"/></svg>
                My Orders
                <c:if test="${fn:length(orders) > 0}">
                    <span class="pnav-badge">${fn:length(orders)}</span>
                </c:if>
            </button>
            <button class="pnav-btn" onclick="switchTab('cart',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg>
                My Cart
                <c:if test="${not empty cart and cart.totalCount > 0}">
                    <span class="pnav-badge">${cart.totalCount}</span>
                </c:if>
            </button>
            <button class="pnav-btn" onclick="switchTab('wishlist',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>
                My Wishlist
                <c:if test="${wishlistCount > 0}"><span class="pnav-badge">${wishlistCount}</span></c:if>
            </button>
            <button class="pnav-btn" onclick="switchTab('edit',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4Z"/></svg>
                Edit Profile
            </button>
            <button class="pnav-btn" onclick="switchTab('security',this)">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                Security
            </button>
            <hr class="pnav-divider">
            <button class="pnav-link" onclick="location.href='${contextPath}/products'">&#8592; Continue Shopping</button>
            <button class="pnav-link" onclick="location.href='${contextPath}/contact'">&#9993; Contact Support</button>
        </aside>

        <!-- Main -->
        <main class="profile-main">

            <c:if test="${not empty successMessage}"><div class="p-alert p-alert-ok" id="flash-msg">${successMessage}</div></c:if>
            <c:if test="${not empty errorMessage}"><div class="p-alert p-alert-err" id="flash-msg">${errorMessage}</div></c:if>

            <!-- ═══ ACCOUNT INFO ═══ -->
            <div id="tab-account" class="ptab ${openTab == 'account' ? 'active' : ''}">
                <div class="pcard">
                    <div class="pcard-head"><div class="pcard-title">Account Overview</div><div class="pcard-sub">Your personal details at a glance</div></div>
                    <div class="pcard-body">
                        <div class="info-grid">
                            <div class="info-tile"><div class="info-lbl">Full Name</div><div class="info-val">${currentUser.firstName} ${currentUser.lastName}</div></div>
                            <div class="info-tile"><div class="info-lbl">Username</div><div class="info-val">@${currentUser.username}</div></div>
                            <div class="info-tile"><div class="info-lbl">Email Address</div><div class="info-val">${currentUser.email}</div></div>
                            <div class="info-tile"><div class="info-lbl">Phone Number</div><div class="info-val"><c:choose><c:when test="${not empty currentUser.phone}">${currentUser.phone}</c:when><c:otherwise><span style="color:#bbb;font-style:italic;font-size:.82rem;">Not set</span></c:otherwise></c:choose></div></div>
                            <div class="info-tile"><div class="info-lbl">Date of Birth</div><div class="info-val"><c:choose><c:when test="${not empty currentUser.birthdate}">${currentUser.birthdate}</c:when><c:otherwise><span style="color:#bbb;font-style:italic;font-size:.82rem;">Not set</span></c:otherwise></c:choose></div></div>
                            <div class="info-tile"><div class="info-lbl">Account Role</div><div class="info-val" style="color:var(--pink);font-weight:700;">${currentUser.role}</div></div>
                            <div class="info-tile"><div class="info-lbl">Account Status</div><div class="info-val"><span class="status-dot">Active</span></div></div>
                            <div class="info-tile"><div class="info-lbl">Member Since</div><div class="info-val" style="font-size:.82rem;">${currentUser.createdAt}</div></div>
                        </div>
                        <div style="display:flex;gap:10px;flex-wrap:wrap;margin-top:8px;">
                            <button class="p-btn p-btn-primary" onclick="switchTab('edit',document.querySelectorAll('.pnav-btn')[4])">Edit Profile →</button>
                            <button class="p-btn p-btn-outline" onclick="switchTab('orders',document.querySelectorAll('.pnav-btn')[1])">My Orders <span class="btn-badge">${fn:length(orders)}</span></button>
                            <button class="p-btn p-btn-outline" onclick="switchTab('wishlist',document.querySelectorAll('.pnav-btn')[3])">♡ Wishlist <c:if test="${wishlistCount > 0}"><span class="btn-badge">${wishlistCount}</span></c:if></button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ═══ MY ORDERS ═══ -->
            <div id="tab-orders" class="ptab ${openTab == 'orders' ? 'active' : ''}">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="pcard">
                            <div class="pcard-head"><div class="pcard-title">My Orders</div><div class="pcard-sub">Your order history</div></div>
                            <div class="pcard-body">
                                <div class="cart-empty">
                                    <div class="cart-empty-icon">&#128666;</div>
                                    <div class="cart-empty-txt">No orders yet</div>
                                    <p style="font-size:.82rem;color:var(--muted);margin-bottom:16px;">Looks like you haven't placed any orders. Start shopping!</p>
                                    <a href="${contextPath}/products" class="cart-empty-btn">Browse Products →</a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="pcard">
                            <div class="pcard-head">
                                <div class="pcard-title">My Orders (${fn:length(orders)})</div>
                                <div class="pcard-sub">Track your delivery status below</div>
                            </div>
                            <div class="pcard-body">
                                <div class="orders-list">
                                    <c:forEach var="order" items="${orders}">
                                        <div class="order-card">
                                            <div class="order-card-head">
                                                <div>
                                                    <div class="order-id">Order #SPR-${order.orderId}</div>
                                                    <div class="order-date"><fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy · hh:mm a"/></div>
                                                </div>
                                                <span class="order-status-badge os-${order.status}">${order.status}</span>
                                            </div>
                                            <div class="order-card-body">
                                                <div class="order-delivery-info">
                                                    <div class="order-info-tile">
                                                        <div class="order-info-lbl">Deliver To</div>
                                                        <div class="order-info-val">${order.fullName}</div>
                                                    </div>
                                                    <div class="order-info-tile">
                                                        <div class="order-info-lbl">Phone</div>
                                                        <div class="order-info-val">${order.phone}</div>
                                                    </div>
                                                    <div class="order-info-tile">
                                                        <div class="order-info-lbl">Address</div>
                                                        <div class="order-info-val">${order.address}, ${order.city}</div>
                                                    </div>
                                                    <div class="order-info-tile">
                                                        <div class="order-info-lbl">Payment</div>
                                                        <div class="order-info-val">Cash on Delivery</div>
                                                    </div>
                                                </div>

                                                <!-- Progress timeline -->
                                                <div class="order-timeline">
                                                    <%-- Step 1: Ordered --%>
                                                    <c:set var="s" value="${order.status}"/>
                                                    <div class="tl-step">
                                                        <div class="tl-dot done">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                                                        </div>
                                                        <div class="tl-label done">Ordered</div>
                                                    </div>
                                                    <%-- Step 2: Shipped --%>
                                                    <div class="tl-step">
                                                        <div class="tl-dot ${s == 'SHIPPED' or s == 'DELIVERED' ? 'done' : ''}">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="1" y="3" width="15" height="13" rx="1"/><path d="M16 8h4l3 5v3h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/></svg>
                                                        </div>
                                                        <div class="tl-label ${s == 'SHIPPED' or s == 'DELIVERED' ? 'done' : ''}">Shipped</div>
                                                    </div>
                                                    <%-- Step 3: Delivered --%>
                                                    <div class="tl-step">
                                                        <div class="tl-dot ${s == 'DELIVERED' ? 'done' : ''}">
                                                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                                                        </div>
                                                        <div class="tl-label ${s == 'DELIVERED' ? 'done' : ''}">Delivered</div>
                                                    </div>
                                                </div>

                                                <div class="order-total-row">
                                                    <span class="order-total-lbl">Total Amount (COD)</span>
                                                    <span class="order-total-amt">Rs <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></span>
                                                </div>

                                                <c:if test="${order.status == 'CANCELLED'}">
                                                    <div style="background:#fef2f2;border:1px solid #fecaca;border-radius:8px;padding:10px 14px;margin-top:12px;font-size:.78rem;color:#dc2626;">
                                                        ✕ This order has been cancelled.
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ═══ CART ═══ -->
            <div id="tab-cart" class="ptab">
                <c:choose>
                    <c:when test="${empty cart or empty cart.items}">
                        <div class="pcard">
                            <div class="pcard-head"><div class="pcard-title">My Cart</div><div class="pcard-sub">Items you've added</div></div>
                            <div class="pcard-body">
                                <div class="cart-empty">
                                    <div class="cart-empty-icon"><svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#e8d8da" stroke-width="1"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 0 1-8 0"/></svg></div>
                                    <div class="cart-empty-txt">Nothing in your cart yet</div>
                                    <a href="${contextPath}/products" class="cart-empty-btn">Browse Products →</a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="cart-panel-grid">
                            <div class="pcard" style="margin-bottom:0;">
                                <div class="pcard-head"><div class="pcard-title">My Cart <span style="font-family:'DM Sans',sans-serif;font-size:.72rem;font-weight:400;color:var(--muted);margin-left:8px;">${cart.totalCount} item<c:if test="${cart.totalCount != 1}">s</c:if></span></div></div>
                                <div class="pcard-body">
                                    <div class="cart-rows">
                                        <c:forEach var="item" items="${cart.items}">
                                            <div class="cart-row">
                                                <div class="ci-img"><c:choose><c:when test="${not empty item.imagePath}"><img src="${pageContext.request.contextPath}/assets/images/products/${item.imagePath}" alt="${item.name}"></c:when><c:otherwise><span class="ci-ph">&#128138;</span></c:otherwise></c:choose></div>
                                                <div class="ci-info"><div class="ci-cat">${item.categoryName}</div><div class="ci-name">${item.name}</div><div class="ci-price">Rs <fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></div></div>
                                                <div style="text-align:center;min-width:54px;"><div style="font-size:.58rem;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;margin-bottom:2px;">Qty</div><div style="font-size:1.1rem;font-weight:700;color:var(--dark);">${item.quantity}</div></div>
                                                <div class="ci-sub">Rs <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div style="margin-top:16px;display:flex;gap:10px;">
                                        <a href="${contextPath}/cart" class="p-btn p-btn-primary" style="flex:1;justify-content:center;">Go to Cart →</a>
                                        <a href="${contextPath}/products" class="p-btn p-btn-outline">+ Add More</a>
                                    </div>
                                </div>
                            </div>
                            <div class="sum-card">
                                <div class="sum-title">Order Summary</div>
                                <c:forEach var="item" items="${cart.items}">
                                    <div class="sum-line"><span style="flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;margin-right:8px;">${item.name} &times;${item.quantity}</span><span style="font-weight:600;color:var(--dark);flex-shrink:0;">Rs <fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/></span></div>
                                </c:forEach>
                                <hr class="sum-div">
                                <div class="sum-line"><span>Shipping</span><span style="color:#3B6D11;font-weight:600;">Free</span></div>
                                <div class="sum-line sum-total"><span>Total</span><span style="font-family:'Cormorant Garamond',serif;font-size:1.3rem;">Rs <fmt:formatNumber value="${cart.grandTotal}" pattern="#,##0.00"/></span></div>
                                <a href="${contextPath}/cart" class="sum-cta">Proceed to Checkout</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ═══ WISHLIST ═══ -->
            <div id="tab-wishlist" class="ptab ${openTab == 'wishlist' ? 'active' : ''}">
                <c:choose>
                    <c:when test="${empty wishlist}">
                        <div class="pcard">
                            <div class="pcard-head"><div class="pcard-title">My Wishlist</div></div>
                            <div class="pcard-body">
                                <div class="cart-empty"><div class="cart-empty-icon">♡</div><div class="cart-empty-txt">Nothing saved yet</div><a href="${contextPath}/products" class="cart-empty-btn">Explore Products →</a></div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="pcard">
                            <div class="pcard-head"><div class="pcard-title">My Wishlist (${wishlistCount})</div></div>
                            <div class="pcard-body">
                                <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;">
                                    <c:forEach var="wItem" items="${wishlist}">
                                        <div style="border:1px solid var(--border);border-radius:10px;overflow:hidden;background:#fff;">
                                            <a href="${contextPath}/productDetail?id=${wItem.productId}">
                                                <img src="${contextPath}/assets/images/products/${wItem.productImagePath}" style="width:100%;height:150px;object-fit:cover;">
                                            </a>
                                            <div style="padding:12px;">
                                                <div style="font-weight:600;margin-bottom:4px;">${wItem.productName}</div>
                                                <div style="font-size:.8rem;color:var(--pink);margin-bottom:10px;">Rs <fmt:formatNumber value="${wItem.productPrice}" pattern="#,##0.00"/></div>
                                                <form action="${contextPath}/cart/add" method="post">
                                                    <input type="hidden" name="productId" value="${wItem.productId}">
                                                    <input type="hidden" name="qty" value="1">
                                                    <button type="submit" class="p-btn p-btn-primary p-btn-full">Add to Cart</button>
                                                </form>
                                                <form action="${contextPath}/wishlist/remove" method="post">
                                                    <input type="hidden" name="productId" value="${wItem.productId}">
                                                    <button type="submit" class="p-btn p-btn-outline p-btn-full">Remove</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ═══ EDIT PROFILE ═══ -->
            <div id="tab-edit" class="ptab ${openTab == 'edit' ? 'active' : ''}">
                <div class="pcard">
                    <div class="pcard-head"><div class="pcard-title">Edit Profile</div><div class="pcard-sub">Update your personal information</div></div>
                    <div class="pcard-body">
                        <form action="${contextPath}/user/profile" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="pf-row">
                                <div><label class="pf-lbl" for="ef-firstName">First Name</label><input type="text" id="ef-firstName" name="firstName" class="pf-inp" value="<c:out value='${currentUser.firstName}'/>" required></div>
                                <div><label class="pf-lbl" for="ef-lastName">Last Name</label><input type="text" id="ef-lastName" name="lastName" class="pf-inp" value="<c:out value='${currentUser.lastName}'/>" required></div>
                            </div>
                            <div class="pf-grp"><label class="pf-lbl">Username</label><input type="text" class="pf-inp" value="<c:out value='${currentUser.username}'/>" readonly><span class="pf-hint">Username cannot be changed</span></div>
                            <div class="pf-grp"><label class="pf-lbl" for="ef-email">Email Address</label><input type="email" id="ef-email" name="email" class="pf-inp" value="<c:out value='${currentUser.email}'/>" required></div>
                            <div class="pf-grp"><label class="pf-lbl" for="ef-phone">Phone Number</label><input type="text" id="ef-phone" name="phone" class="pf-inp" value="<c:out value='${currentUser.phone}'/>"><span class="pf-hint">Must start with + and be exactly 14 characters</span></div>
                            <button type="submit" class="p-btn p-btn-primary p-btn-full">Save Changes</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- ═══ SECURITY ═══ -->
            <div id="tab-security" class="ptab ${openTab == 'security' ? 'active' : ''}">
                <div class="pcard">
                    <div class="pcard-head"><div class="pcard-title">Change Password</div><div class="pcard-sub">Keep your account safe</div></div>
                    <div class="pcard-body">
                        <form action="${contextPath}/user/profile" method="post">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="pf-grp"><label class="pf-lbl" for="sf-cur">Current Password</label><div class="password-wrap"><input type="password" id="sf-cur" name="currentPassword" class="pf-inp" placeholder="Enter your current password" required><button type="button" class="toggle-pass" onclick="togglePwd('sf-cur',this)">Show</button></div></div>
                            <div class="pf-grp"><label class="pf-lbl" for="sf-new">New Password</label><div class="password-wrap"><input type="password" id="sf-new" name="newPassword" class="pf-inp" placeholder="Min 7 chars, uppercase, digit, special char" oninput="checkStrength(this.value)" required><button type="button" class="toggle-pass" onclick="togglePwd('sf-new',this)">Show</button></div><div class="pwd-bar-wrap"><div class="pwd-bar-track"><div class="pwd-bar-fill" id="strBar" style="width:0%;background:#e8536a;"></div></div><div class="pwd-bar-hint" id="strHint">Enter a new password</div></div></div>
                            <div class="pf-grp"><label class="pf-lbl" for="sf-conf">Confirm New Password</label><div class="password-wrap"><input type="password" id="sf-conf" name="confirmPassword" class="pf-inp" placeholder="Re-enter your new password" required><button type="button" class="toggle-pass" onclick="togglePwd('sf-conf',this)">Show</button></div></div>
                            <div class="req-list">
                                <div class="req-list-title">Password Requirements</div>
                                <div class="req-item" id="req-len">&#9675; More than 6 characters</div>
                                <div class="req-item" id="req-upper">&#9675; At least one uppercase letter</div>
                                <div class="req-item" id="req-digit">&#9675; At least one number</div>
                                <div class="req-item" id="req-special">&#9675; At least one special character</div>
                            </div>
                            <button type="submit" class="p-btn p-btn-primary p-btn-full">Update Password</button>
                        </form>
                    </div>
                </div>
                <div class="pcard">
                    <div class="pcard-head"><div class="pcard-title">Security Overview</div></div>
                    <div class="pcard-body">
                        <div class="info-grid">
                            <div class="info-tile"><div class="info-lbl">Account Status</div><div class="info-val"><span class="status-dot">Active &amp; Secure</span></div></div>
                            <div class="info-tile"><div class="info-lbl">Failed Login Attempts</div><div class="info-val">${currentUser.loginAttempts}</div></div>
                            <div class="info-tile"><div class="info-lbl">Account Locked</div><div class="info-val"><c:choose><c:when test="${not empty currentUser.lockedUntil}"><span style="color:#e8536a;">Until ${currentUser.lockedUntil}</span></c:when><c:otherwise><span style="color:#3B9B3F;">No</span></c:otherwise></c:choose></div></div>
                            <div class="info-tile"><div class="info-lbl">Member Since</div><div class="info-val" style="font-size:.82rem;">${currentUser.createdAt}</div></div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div class="footer-brand-col"><div class="footer-logo">SΡRA<span>.</span></div><p class="footer-tagline">Luxury cosmetics crafted with love.</p></div>
            <div class="footer-col"><h4 class="footer-col-title">Quick Links</h4><ul class="footer-links"><li><a href="${contextPath}/home">Home</a></li><li><a href="${contextPath}/products">Products</a></li><li><a href="${contextPath}/about">About</a></li><li><a href="${contextPath}/contact">Contact</a></li></ul></div>
            <div class="footer-col"><h4 class="footer-col-title">Categories</h4><ul class="footer-links"><li><a href="${contextPath}/products?category=1">Skincare</a></li><li><a href="${contextPath}/products?category=2">Makeup</a></li><li><a href="${contextPath}/products?category=3">Fragrance</a></li></ul></div>
            <div class="footer-col"><h4 class="footer-col-title">Contact Info</h4><ul class="footer-links"><li>Sinamangal, Kathmandu</li><li><a href="mailto:hello@spra.com">hello@spra.com</a></li><li>+977 9878670678</li></ul></div>
        </div>
        <div class="footer-bottom"><p class="footer-copy">&copy; 2025 Spra. Made with <span class="footer-heart">&#9829;</span> All rights reserved.</p><div class="footer-legal"><a href="#">Privacy Policy</a><a href="#">Terms of Service</a></div></div>
    </div>
</footer>

<script>
function switchTab(id, btn) {
    document.querySelectorAll('.ptab').forEach(function(p){ p.classList.remove('active'); });
    document.querySelectorAll('.pnav-btn').forEach(function(b){ b.classList.remove('active'); });
    var panel = document.getElementById('tab-' + id);
    if (panel) panel.classList.add('active');
    if (btn) btn.classList.add('active');
}
function togglePwd(id, btn) {
    var f = document.getElementById(id);
    if (!f) return;
    f.type = f.type === 'password' ? 'text' : 'password';
    btn.textContent = f.type === 'password' ? 'Show' : 'Hide';
}
function checkStrength(v) {
    var bar = document.getElementById('strBar');
    var hint = document.getElementById('strHint');
    if (!bar) return;
    var checks = { len: v.length > 6, upper: /[A-Z]/.test(v), digit: /[0-9]/.test(v), special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(v) };
    var keys = ['len','upper','digit','special'];
    var labels = { len:'More than 6 characters', upper:'At least one uppercase letter', digit:'At least one number', special:'At least one special character' };
    var score = 0;
    keys.forEach(function(k) {
        var el = document.getElementById('req-' + k);
        if (checks[k]) { score++; if (el) { el.classList.add('ok'); el.innerHTML = '✓ ' + labels[k]; } }
        else { if (el) { el.classList.remove('ok'); el.innerHTML = '○ ' + labels[k]; } }
    });
    var colors = ['#e8536a','#f0a830','#c0dd05','#3B9B3F'];
    var txts   = ['Weak','Fair','Good','Strong'];
    bar.style.width = (score/4*100) + '%';
    bar.style.background = score > 0 ? colors[score-1] : '#e0e0e0';
    hint.textContent = score === 0 ? 'Enter a new password' : txts[score-1];
    hint.style.color  = score > 0 ? colors[score-1] : '#888';
}
document.addEventListener('DOMContentLoaded', function() {
    var msg = document.getElementById('flash-msg');
    if (msg) { setTimeout(function() { msg.style.transition='opacity .5s'; msg.style.opacity='0'; setTimeout(function(){ if(msg.parentNode) msg.parentNode.removeChild(msg); },500); },5000); }
    var openTab = '${openTab}';
    var btns = document.querySelectorAll('.pnav-btn');
    var map = { account:0, orders:1, cart:2, wishlist:3, edit:4, security:5 };
    if (map[openTab] !== undefined) switchTab(openTab, btns[map[openTab]]);
});
</script>
</body>
</html>
