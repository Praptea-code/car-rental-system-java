<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String contextPath = request.getContextPath();
    String currentUri = request.getRequestURI();
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages — Spra Admin</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/admin.css">
    <link rel="icon" type="image/svg+xml" href="<%= contextPath %>/assets/images/favicon.svg">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        /* ── Message cards layout ── */
        /* ── Inbox two-panel layout ── */
.inbox-layout {
    display: grid;
    grid-template-columns: 320px 1fr;
    height: calc(100vh - 80px);  /* fills below topbar */
    overflow: hidden;
}
.inbox-list {
    border-right: 1px solid var(--a-border);
    overflow-y: auto;
    background: #fff;
}
.inbox-list-head {
    padding: 18px 20px;
    border-bottom: 1px solid var(--a-border);
    display: flex; align-items: center; gap: 10px;
    position: sticky; top: 0; background: #fff; z-index: 2;
}
.inbox-list-title {
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.2rem; font-weight: 600; color: var(--a-text);
}
.inbox-count {
    background: var(--a-pink); color: #fff;
    font-size: 11px; font-weight: 600; padding: 2px 8px; border-radius: 10px;
}
.inbox-empty { padding: 3rem 20px; color: var(--a-muted); font-style: italic; text-align: center; }
.inbox-row {
    display: flex; align-items: flex-start; gap: 12px;
    padding: 14px 20px; cursor: pointer;
    border-bottom: 1px solid #f8f0f0; transition: background .15s;
}
.inbox-row:hover { background: #fff8f8; }
.inbox-row.active { background: var(--a-pink-light); border-left: 3px solid var(--a-pink); }
.inbox-avatar {
    width: 36px; height: 36px; border-radius: 50%; flex-shrink: 0;
    background: linear-gradient(135deg, #f4a0b0, #e8536a);
    display: flex; align-items: center; justify-content: center;
    font-family: 'Cormorant Garamond', serif; font-size: 13px;
    font-weight: 600; color: #fff; text-transform: uppercase;
}
.inbox-row-body { flex: 1; min-width: 0; }
.inbox-row-top { display: flex; justify-content: space-between; align-items: baseline; gap: 6px; margin-bottom: 2px; }
.inbox-row-name { font-size: 13px; font-weight: 600; color: var(--a-text); }
.inbox-row-date { font-size: 10px; color: var(--a-muted); flex-shrink: 0; }
.inbox-row-subj { font-size: 12px; color: var(--a-pink); font-weight: 500; margin-bottom: 2px; }
.inbox-row-preview {
    font-size: 11px; color: #888; white-space: nowrap;
    overflow: hidden; text-overflow: ellipsis;
}

/* ── Reader pane ── */
.inbox-reader {
    overflow-y: auto; background: var(--a-bg);
    display: flex; align-items: flex-start;
}
.inbox-reader-empty {
    width: 100%; padding: 5rem 2rem; text-align: center; color: var(--a-muted);
    display: flex; flex-direction: column; align-items: center; justify-content: center;
}
.inbox-reader-inner { padding: 3rem; max-width: 680px; width: 100%; }
.reader-eyebrow {
    font-size: .6rem; font-weight: 700; letter-spacing: .2em;
    text-transform: uppercase; color: var(--a-pink); margin-bottom: 6px;
}
.reader-name {
    font-family: 'Cormorant Garamond', serif;
    font-size: 2rem; font-weight: 600; color: var(--a-text); margin-bottom: 4px;
}
.reader-meta { font-size: 12px; color: var(--a-muted); margin-bottom: 1.6rem; }
.reader-subj-label {
    font-size: .6rem; font-weight: 700; text-transform: uppercase;
    letter-spacing: .12em; color: var(--a-muted); margin-bottom: 6px;
}
.reader-subj {
    font-size: 15px; font-weight: 600; color: var(--a-text);
    padding: 10px 14px; background: #fff;
    border: 1px solid var(--a-border); border-radius: 8px; margin-bottom: 4px;
}
.reader-body {
    font-size: 14px; color: #333; line-height: 1.9;
    white-space: pre-wrap; padding: 16px;
    background: #fff; border: 1px solid var(--a-border); border-radius: 8px;
    margin-top: 6px;
}

@media (max-width: 800px) {
    .inbox-layout { grid-template-columns: 1fr; }
    .inbox-reader { display: none; }
}
        .msg-card-row {
            display: grid;
            grid-template-columns: 48px 200px 180px 140px 1fr 140px;
            gap: 0;
            align-items: stretch;
            border-bottom: 1px solid #f8f0f0;
            transition: background .15s;
        }
        .msg-card-row:last-child { border-bottom: none; }
        .msg-card-row:hover { background: #fff8f8; }

        .msg-cell {
            padding: 16px 18px;
            display: flex;
            align-items: center;
            font-size: 13px;
            color: var(--a-text);
        }
        .msg-cell-id    { color: var(--a-muted); font-family: monospace; font-size: 11px; }
        .msg-cell-name  { font-weight: 600; color: var(--a-text); }
        .msg-cell-email { color: var(--a-muted); font-size: 12px; }
        .msg-cell-subj  {}
        .msg-cell-body  {
            font-size: 13px;
            color: #333;
            line-height: 1.55;
            /* Allow full text to show on hover */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: block;
            align-items: unset;
            padding: 16px 18px;
            cursor: pointer;
            transition: color .15s;
        }
        .msg-cell-body:hover { color: var(--a-pink); white-space: normal; overflow: visible; }
        .msg-cell-date  { color: var(--a-muted); font-size: 11px; }

        /* expanded message modal */
        .msg-modal-overlay {
            position: fixed; inset: 0;
            background: rgba(20,4,8,.6);
            backdrop-filter: blur(6px);
            z-index: 300;
            display: flex; align-items: center; justify-content: center;
            animation: fadeIn .2s ease;
        }
        @keyframes fadeIn { from{opacity:0} to{opacity:1} }
        .msg-modal-box {
            background: #fff;
            border-radius: 18px;
            width: 560px; max-width: 95vw;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 24px 60px rgba(232,83,106,.14);
            padding: 2rem 2.2rem;
            position: relative;
        }
        .msg-modal-close {
            position: absolute; top: 14px; right: 16px;
            background: #fdf0f2; border: none; border-radius: 50%;
            width: 32px; height: 32px; font-size: 18px;
            color: #999; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            transition: background .15s, color .15s;
        }
        .msg-modal-close:hover { background: var(--a-pink); color: #fff; }
        .msg-modal-from {
            font-size: .62rem; font-weight: 700; letter-spacing: .14em;
            text-transform: uppercase; color: var(--a-pink); margin-bottom: 4px;
        }
        .msg-modal-name { font-family: 'Cormorant Garamond', serif; font-size: 1.5rem; font-weight: 600; color: var(--a-text); margin-bottom: 2px; }
        .msg-modal-meta { font-size: 12px; color: var(--a-muted); margin-bottom: 1.2rem; }
        .msg-modal-subj-label { font-size: .62rem; font-weight: 700; text-transform: uppercase; letter-spacing: .12em; color: var(--a-muted); margin-bottom: 4px; }
        .msg-modal-subj { font-size: 14px; font-weight: 600; color: var(--a-text); margin-bottom: 1rem; padding: 8px 12px; background: #fdf8f8; border: 1px solid #f0e0e0; border-radius: 8px; }
        .msg-modal-body-label { font-size: .62rem; font-weight: 700; text-transform: uppercase; letter-spacing: .12em; color: var(--a-muted); margin-bottom: 6px; }
        .msg-modal-body { font-size: 14px; color: #333; line-height: 1.8; white-space: pre-wrap; }

        /* table header */
        .msg-head-row {
            display: grid;
            grid-template-columns: 48px 200px 180px 140px 1fr 140px;
            gap: 0;
            border-bottom: 1.5px solid var(--a-border);
            background: var(--a-bg);
        }
        .msg-head-cell {
            padding: 10px 18px;
            font-size: 10px; font-weight: 600;
            text-transform: uppercase; letter-spacing: .1em;
            color: var(--a-muted);
        }
    </style>
</head>
<body class="admin-body">
<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="admin-sidebar">
        <div class="admin-sidebar-top">
            <span class="admin-logo">SΡRA<span>.</span></span>
            <p class="admin-welcome">Hi, <%= currentUser != null ? currentUser.getFirstName() : "Admin" %> &middot; Admin Panel</p>
        </div>
        <nav class="admin-nav">
            <div class="admin-nav-section">Main</div>

            <a href="<%= contextPath %>/admin/dashboard" class="admin-nav-link <%= currentUri.endsWith("/dashboard") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
                <span class="nav-label">Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/products" class="admin-nav-link <%= currentUri.endsWith("/products") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/></svg>
                <span class="nav-label">Products</span>
            </a>

            <a href="<%= contextPath %>/admin/orders" class="admin-nav-link <%= currentUri.endsWith("/orders") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><path d="m9 12 2 2 4-4"/></svg>
                <span class="nav-label">Orders</span>
            </a>

            <a href="<%= contextPath %>/admin/messages" class="admin-nav-link <%= currentUri.endsWith("/messages") ? "active" : "" %>">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
                <span class="nav-label">Messages</span>
            </a>

            <div class="admin-nav-section">Store</div>

            <a href="<%= contextPath %>/home" class="admin-nav-link">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/></svg>
                <span class="nav-label">View Site</span>
            </a>
        </nav>
        <div class="admin-sidebar-bottom">
            <form action="<%= contextPath %>/logout" method="post">
                <button type="submit" class="admin-logout-btn">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
                    Sign Out
                </button>
            </form>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="admin-main">
        <div class="admin-topbar">
            <div>
                <div class="admin-page-title">Contact Messages</div>
                <div class="admin-page-subtitle">Messages submitted through the contact form — click any message to read in full</div>
            </div>
        </div>
        <div class="admin-content">
            <div class="admin-section">
                <c:choose>
                    <c:when test="${empty messages}">
                        <div class="admin-empty" style="padding:3rem;">No messages received yet.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="msg-cards-grid">
                            <!-- Header -->
                            <div class="msg-head-row">
                                <div class="msg-head-cell">#</div>
                                <div class="msg-head-cell">Name</div>
                                <div class="msg-head-cell">Email</div>
                                <div class="msg-head-cell">Subject</div>
                                <div class="msg-head-cell">Message</div>
                                <div class="msg-head-cell">Date</div>
                            </div>
                            <c:forEach var="msg" items="${messages}" varStatus="loop">
                                <div class="msg-card-row">
                                    <div class="msg-cell msg-cell-id">#${msg.messageId}</div>
                                    <div class="msg-cell msg-cell-name">${msg.fullName}</div>
                                    <div class="msg-cell msg-cell-email">${msg.email}</div>
                                    <div class="msg-cell msg-cell-subj">
                                        <span class="badge badge-info">${msg.subject}</span>
                                    </div>
                                    <div class="msg-cell-body" onclick="openMsg('${msg.fullName}','${msg.email}','${msg.subject}',`${msg.message}`,'${msg.createdAt}')" title="Click to read full message">
                                        ${msg.message}
                                    </div>
                                    <div class="msg-cell msg-cell-date">${msg.createdAt}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<!-- Message detail modal -->
<div id="msgModal" class="msg-modal-overlay" style="display:none" onclick="if(event.target===this)closeMsg()">
    <div class="msg-modal-box">
        <button class="msg-modal-close" onclick="closeMsg()">&times;</button>
        <div class="msg-modal-from">Message from</div>
        <div class="msg-modal-name" id="modalName"></div>
        <div class="msg-modal-meta" id="modalMeta"></div>
        <div class="msg-modal-subj-label">Subject</div>
        <div class="msg-modal-subj" id="modalSubj"></div>
        <div class="msg-modal-body-label">Message</div>
        <div class="msg-modal-body" id="modalBody"></div>
    </div>
</div>

<script>
function openMsg(name, email, subj, body, date) {
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalMeta').textContent = email + ' · ' + date;
    document.getElementById('modalSubj').textContent = subj;
    document.getElementById('modalBody').textContent = body;
    document.getElementById('msgModal').style.display = 'flex';
}
function closeMsg() {
    document.getElementById('msgModal').style.display = 'none';
}
document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeMsg(); });
</script>
<script src="<%= contextPath %>/js/main.js"></script>
</body>
</html>
