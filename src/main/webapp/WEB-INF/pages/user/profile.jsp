<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="openTab"
	value="${param.tab != null ? param.tab : 'account'}" />
<c:set var="currentUser" value="${sessionScope.loggedInUser}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Spra. – My Profile</title>
<link rel="stylesheet" href="${contextPath}/css/style.css">
<link rel="icon" type="image/svg+xml"
	href="${pageContext.request.contextPath}/assets/images/favicon.svg">
<link
	href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,400&family=DM+Sans:wght@300;400;500&display=swap"
	rel="stylesheet">

</head>
<body>

	<!-- NAV -->
	<nav class="nav">
		<button class="hamburger-btn" onclick="toggleNav()" aria-label="Menu">
			<svg width="22" height="22" viewBox="0 0 24 24" fill="none"
				stroke="currentColor" stroke-width="1.8">
	        <line x1="3" y1="6" x2="21" y2="6" />
	        <line x1="3" y1="12" x2="21" y2="12" />
	        <line x1="3" y1="18" x2="21" y2="18" />
	    </svg>
		</button>
		<a href="${pageContext.request.contextPath}/home" class="nav-logo">SPR<span
			class="nav-dot">A</span></a>
		<ul class="nav-links">
			<li><a href="${contextPath}/home">Home</a></li>
			<li><a href="${contextPath}/products">Products</a></li>
			<li><a href="${contextPath}/about">About</a></li>
			<li><a href="${contextPath}/contact">Contact</a></li>
		</ul>
		<div class="nav-right">
			<a href="${contextPath}/products" class="nav-icon-btn" title="Search">
				<svg width="20" height="20" viewBox="0 0 24 24" fill="none"
					stroke="currentColor" stroke-width="1.5">
					<circle cx="11" cy="11" r="8" />
					<path d="m21 21-4.35-4.35" /></svg>
			</a> <a href="${pageContext.request.contextPath}/cart"
				class="nav-icon-btn cart-icon-btn" title="Cart"> <svg width="20"
					height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
					stroke-width="1.5">
		        <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
		        <line x1="3" y1="6" x2="21" y2="6" />
		        <path d="M16 10a4 4 0 0 1-8 0" />
		    </svg> <c:if test="${not empty cart and cart.totalCount > 0}">
					<span class="cart-badge">${cart.totalCount}</span>
				</c:if>
			</a>
			<div class="nav-user-wrap">
				<span class="nav-username">Hi, ${currentUser.firstName}</span>
				<c:if test="${currentUser.role == 'ADMIN'}">
					<a href="${contextPath}/admin/dashboard" class="nav-admin-btn">Dashboard</a>
				</c:if>
				<a href="${contextPath}/user/profile" class="nav-profile-btn">Profile</a>
				<form action="${contextPath}/logout" method="post"
					style="display: inline">
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
					<div class="ph-name">
						Hey, <em>${currentUser.firstName}!</em>
					</div>
					<div class="ph-meta">${currentUser.email}&nbsp;&middot;&nbsp;${currentUser.role}</div>
				</div>
				<div class="ph-stats">
					<div class="ph-stat">
						<div class="ph-stat-num">
							<c:choose>
								<c:when test="${empty cart}">0</c:when>
								<c:otherwise>${cart.totalCount}</c:otherwise>
							</c:choose>
						</div>
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
						<div class="ph-stat-num"
							style="font-size: 1.1rem; color: #f4a0b0;">
							<c:choose>
								<c:when test="${currentUser.role == 'ADMIN'}">Admin</c:when>
								<c:otherwise>Member</c:otherwise>
							</c:choose>
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
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<circle cx="12" cy="8" r="4" />
						<path d="M4 20c0-4 3.6-7 8-7s8 3 8 7" /></svg>
					Account Info
				</button>
				<button class="pnav-btn" onclick="switchTab('orders',this)">
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<path
							d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2" />
						<rect x="9" y="3" width="6" height="4" rx="1" />
						<path d="m9 12 2 2 4-4" /></svg>
					My Orders
					<c:if test="${fn:length(orders) > 0}">
						<span class="pnav-badge">${fn:length(orders)}</span>
					</c:if>
				</button>
				<button class="pnav-btn" onclick="switchTab('cart',this)">
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
						<line x1="3" y1="6" x2="21" y2="6" />
						<path d="M16 10a4 4 0 0 1-8 0" /></svg>
					My Cart
					<c:if test="${not empty cart and cart.totalCount > 0}">
						<span class="pnav-badge">${cart.totalCount}</span>
					</c:if>
				</button>
				<button class="pnav-btn" onclick="switchTab('wishlist',this)">
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<path
							d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" /></svg>
					My Wishlist
					<c:if test="${wishlistCount > 0}">
						<span class="pnav-badge">${wishlistCount}</span>
					</c:if>
				</button>
				<button class="pnav-btn" onclick="switchTab('edit',this)">
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<path
							d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
						<path d="M18.5 2.5a2.12 2.12 0 0 1 3 3L12 15l-4 1 1-4Z" /></svg>
					Edit Profile
				</button>
				<button class="pnav-btn" onclick="switchTab('security',this)">
					<svg width="15" height="15" viewBox="0 0 24 24" fill="none"
						stroke="currentColor" stroke-width="1.5">
						<rect x="3" y="11" width="18" height="11" rx="2" />
						<path d="M7 11V7a5 5 0 0 1 10 0v4" /></svg>
					Security
				</button>
				<hr class="pnav-divider">
				<button class="pnav-link"
					onclick="location.href='${contextPath}/products'">&#8592;
					Continue Shopping</button>
				<button class="pnav-link"
					onclick="location.href='${contextPath}/contact'">&#9993;
					Contact Support</button>
			</aside>

			<!-- Main -->
			<main class="profile-main">

				<c:if test="${not empty successMessage}">
					<div class="p-alert p-alert-ok" id="flash-msg">${successMessage}</div>
				</c:if>
				<c:if test="${not empty errorMessage}">
					<div class="p-alert p-alert-err" id="flash-msg">${errorMessage}</div>
				</c:if>

				<!-- ═══ ACCOUNT INFO ═══ -->
				<div id="tab-account"
					class="ptab ${openTab == 'account' ? 'active' : ''}">
					<div class="pcard">
						<div class="pcard-head">
							<div class="pcard-title">Account Overview</div>
							<div class="pcard-sub">Your personal details at a glance</div>
						</div>
						<div class="pcard-body">
							<div class="info-grid">
								<div class="info-tile">
									<div class="info-lbl">Full Name</div>
									<div class="info-val">${currentUser.firstName}
										${currentUser.lastName}</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Username</div>
									<div class="info-val">@${currentUser.username}</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Email Address</div>
									<div class="info-val">${currentUser.email}</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Phone Number</div>
									<div class="info-val">
										<c:choose>
											<c:when test="${not empty currentUser.phone}">${currentUser.phone}</c:when>
											<c:otherwise>
												<span
													style="color: #bbb; font-style: italic; font-size: .82rem;">Not
													set</span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Date of Birth</div>
									<div class="info-val">
										<c:choose>
											<c:when test="${not empty currentUser.birthdate}">${currentUser.birthdate}</c:when>
											<c:otherwise>
												<span
													style="color: #bbb; font-style: italic; font-size: .82rem;">Not
													set</span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Account Role</div>
									<div class="info-val"
										style="color: var(--pink); font-weight: 700;">${currentUser.role}</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Account Status</div>
									<div class="info-val">
										<span class="status-dot">Active</span>
									</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Member Since</div>
									<div class="info-val" style="font-size: .82rem;">${currentUser.createdAt}</div>
								</div>
							</div>
							<div
								style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 8px;">
								<button class="p-btn p-btn-primary"
									onclick="switchTab('edit',document.querySelectorAll('.pnav-btn')[4])">Edit
									Profile →</button>
								<button class="p-btn p-btn-outline"
									onclick="switchTab('orders',document.querySelectorAll('.pnav-btn')[1])">
									My Orders <span class="btn-badge">${fn:length(orders)}</span>
								</button>
								<button class="p-btn p-btn-outline"
									onclick="switchTab('wishlist',document.querySelectorAll('.pnav-btn')[3])">
									♡ Wishlist
									<c:if test="${wishlistCount > 0}">
										<span class="btn-badge">${wishlistCount}</span>
									</c:if>
								</button>
							</div>
						</div>
					</div>
				</div>

				<!-- ═══ MY ORDERS ═══ -->
				<div id="tab-orders"
					class="ptab ${openTab == 'orders' ? 'active' : ''}">
					<c:choose>
						<c:when test="${empty orders}">
							<div class="pcard">
								<div class="pcard-head">
									<div class="pcard-title">My Orders</div>
									<div class="pcard-sub">Your order history</div>
								</div>
								<div class="pcard-body">
									<div class="cart-empty">
										<div class="cart-empty-icon">&#128666;</div>
										<div class="cart-empty-txt">No orders yet</div>
										<p
											style="font-size: .82rem; color: var(--muted); margin-bottom: 16px;">Looks
											like you haven't placed any orders. Start shopping!</p>
										<a href="${contextPath}/products" class="cart-empty-btn">Browse
											Products →</a>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="pcard">
								<div class="pcard-head">
									<div class="pcard-title">My Orders (${fn:length(orders)})</div>
									<div class="pcard-sub">Click "View Items" on any order to
										see what's inside</div>
								</div>
								<div class="pcard-body">
									<div class="orders-list">
										<c:forEach var="order" items="${orders}">
											<div class="order-card">
												<div class="order-card-head">
													<div>
														<div class="order-id">Order #SPR-${order.orderId}</div>
														<div class="order-date">
															<fmt:formatDate value="${order.createdAt}"
																pattern="MMM dd, yyyy · hh:mm a" />
														</div>
													</div>
													<span class="order-status-badge os-${order.status}">${order.status}</span>
												</div>
												<div class="order-card-body">
													<div class="order-delivery-info">
														<div>
															<div class="order-info-lbl">Deliver To</div>
															<div class="order-info-val">${order.fullName}</div>
														</div>
														<div>
															<div class="order-info-lbl">Phone</div>
															<div class="order-info-val">${order.phone}</div>
														</div>
														<div>
															<div class="order-info-lbl">Address</div>
															<div class="order-info-val">${order.address},
																${order.city}</div>
														</div>
														<div>
															<div class="order-info-lbl">Payment</div>
															<div class="order-info-val">Cash on Delivery</div>
														</div>
													</div>

													<div class="order-timeline">
														<c:set var="s" value="${order.status}" />
														<div class="tl-step">
															<div class="tl-dot done">
																<svg width="12" height="12" viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2.5">
																	<polyline points="20 6 9 17 4 12" /></svg>
															</div>
															<div class="tl-label done">Ordered</div>
														</div>
														<div class="tl-step">
															<div
																class="tl-dot ${s == 'SHIPPED' or s == 'DELIVERED' ? 'done' : ''}">
																<svg width="12" height="12" viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
																	<rect x="1" y="3" width="15" height="13" rx="1" />
																	<path d="M16 8h4l3 5v3h-7V8z" />
																	<circle cx="5.5" cy="18.5" r="2.5" />
																	<circle cx="18.5" cy="18.5" r="2.5" /></svg>
															</div>
															<div
																class="tl-label ${s == 'SHIPPED' or s == 'DELIVERED' ? 'done' : ''}">Shipped</div>
														</div>
														<div class="tl-step">
															<div class="tl-dot ${s == 'DELIVERED' ? 'done' : ''}">
																<svg width="12" height="12" viewBox="0 0 24 24"
																	fill="none" stroke="currentColor" stroke-width="2">
																	<path
																		d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /></svg>
															</div>
															<div class="tl-label ${s == 'DELIVERED' ? 'done' : ''}">Delivered</div>
														</div>
													</div>

													<div class="order-total-row">
														<span class="order-total-lbl">Total Amount (COD)</span> <span
															class="order-total-amt">Rs <fmt:formatNumber
																value="${order.totalAmount}" pattern="#,##0.00" /></span>
													</div>

													<button class="view-items-btn"
														onclick="openOrderDetail(
                                                        ${order.orderId},
                                                        '${order.fullName.replace("'", "\\'")}',
                                                        '${order.phone}',
                                                        '${order.address.replace("'", "\\'")}',
                                                        '${order.city}',
                                                        '${order.status}',
                                                        '<fmt:formatDate value="${order.createdAt}" pattern="MMM dd, yyyy"/>',
                                                        ${order.totalAmount}
                                                    )">
														<svg width="14" height="14" viewBox="0 0 24 24"
															fill="none" stroke="currentColor" stroke-width="2">
															<path
																d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2" />
															<rect x="9" y="3" width="6" height="4" rx="1" /></svg>
														View Items in this Order
													</button>

													<c:if test="${order.status == 'CANCELLED'}">
														<div
															style="background: #fef2f2; border: 1px solid #fecaca; border-radius: 8px; padding: 10px 14px; margin-top: 12px; font-size: .78rem; color: #dc2626;">
															✕ This order has been cancelled.</div>
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
								<div class="pcard-head">
									<div class="pcard-title">My Cart</div>
									<div class="pcard-sub">Items you've added</div>
								</div>
								<div class="pcard-body">
									<div class="cart-empty">
										<div class="cart-empty-icon">
											<svg width="56" height="56" viewBox="0 0 24 24" fill="none"
												stroke="#e8d8da" stroke-width="1">
												<path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z" />
												<line x1="3" y1="6" x2="21" y2="6" />
												<path d="M16 10a4 4 0 0 1-8 0" /></svg>
										</div>
										<div class="cart-empty-txt">Nothing in your cart yet</div>
										<a href="${contextPath}/products" class="cart-empty-btn">Browse
											Products →</a>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="cart-panel-grid">
								<div class="pcard" style="margin-bottom: 0;">
									<div class="pcard-head">
										<div class="pcard-title">
											My Cart <span
												style="font-family: 'DM Sans', sans-serif; font-size: .72rem; font-weight: 400; color: var(--muted); margin-left: 8px;">${cart.totalCount}
												item<c:if test="${cart.totalCount != 1}">s</c:if>
											</span>
										</div>
									</div>
									<div class="pcard-body">
										<div class="cart-rows">
											<c:forEach var="item" items="${cart.items}">
												<div class="cart-row">
													<div class="ci-img">
														<c:choose>
															<c:when test="${not empty item.imagePath}">
																<img
																	src="${pageContext.request.contextPath}/assets/images/products/${item.imagePath}"
																	alt="${item.name}">
															</c:when>
															<c:otherwise>
																<span class="ci-ph">&#128138;</span>
															</c:otherwise>
														</c:choose>
													</div>
													<div class="ci-info">
														<div class="ci-cat">${item.categoryName}</div>
														<div class="ci-name">${item.name}</div>
														<div class="ci-price">
															Rs
															<fmt:formatNumber value="${item.price}"
																pattern="#,##0.00" />
														</div>
													</div>
													<div style="text-align: center; min-width: 54px;">
														<div
															style="font-size: .58rem; color: var(--muted); text-transform: uppercase; letter-spacing: .08em; margin-bottom: 2px;">Qty</div>
														<div
															style="font-size: 1.1rem; font-weight: 700; color: var(--dark);">${item.quantity}</div>
													</div>
													<div class="ci-sub">
														Rs
														<fmt:formatNumber value="${item.subtotal}"
															pattern="#,##0.00" />
													</div>
												</div>
											</c:forEach>
										</div>
										<div style="margin-top: 16px; display: flex; gap: 10px;">
											<a href="${contextPath}/cart" class="p-btn p-btn-primary"
												style="flex: 1; justify-content: center;">Go to Cart →</a> <a
												href="${contextPath}/products" class="p-btn p-btn-outline">+
												Add More</a>
										</div>
									</div>
								</div>
								<div class="sum-card">
									<div class="sum-title">Order Summary</div>
									<c:forEach var="item" items="${cart.items}">
										<div class="sum-line">
											<span
												style="flex: 1; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; margin-right: 8px;">${item.name}
												&times;${item.quantity}</span><span
												style="font-weight: 600; color: var(--dark); flex-shrink: 0;">Rs
												<fmt:formatNumber value="${item.subtotal}"
													pattern="#,##0.00" />
											</span>
										</div>
									</c:forEach>
									<hr class="sum-div">
									<div class="sum-line">
										<span>Shipping</span><span
											style="color: #3B6D11; font-weight: 600;">Free</span>
									</div>
									<div class="sum-line sum-total">
										<span>Total</span><span
											style="font-family: 'Cormorant Garamond', serif; font-size: 1.3rem;">Rs
											<fmt:formatNumber value="${cart.grandTotal}"
												pattern="#,##0.00" />
										</span>
									</div>
									<a href="${contextPath}/cart" class="sum-cta">Proceed to
										Checkout</a>
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- ═══ WISHLIST ═══ -->
				<div id="tab-wishlist"
					class="ptab ${openTab == 'wishlist' ? 'active' : ''}">
					<c:choose>
						<c:when test="${empty wishlist}">
							<div class="pcard">
								<div class="pcard-head">
									<div class="pcard-title">My Wishlist</div>
								</div>
								<div class="pcard-body">
									<div class="cart-empty">
										<div class="cart-empty-icon">♡</div>
										<div class="cart-empty-txt">Nothing saved yet</div>
										<a href="${contextPath}/products" class="cart-empty-btn">Explore
											Products →</a>
									</div>
								</div>
							</div>
						</c:when>
						<c:otherwise>
							<div class="pcard">
								<div class="pcard-head">
									<div class="pcard-title">My Wishlist (${wishlistCount})</div>
								</div>
								<div class="pcard-body">
									<div
										style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px;">
										<c:forEach var="wItem" items="${wishlist}">
											<div
												style="border: 1px solid var(--border); border-radius: 10px; overflow: hidden; background: #fff;">
												<a href="${contextPath}/productDetail?id=${wItem.productId}">
													<img
													src="${contextPath}/assets/images/products/${wItem.productImagePath}"
													style="width: 100%; height: 150px; object-fit: cover;">
												</a>
												<div style="padding: 12px;">
													<div style="font-weight: 600; margin-bottom: 4px;">${wItem.productName}</div>
													<div
														style="font-size: .8rem; color: var(--pink); margin-bottom: 10px;">
														Rs
														<fmt:formatNumber value="${wItem.productPrice}"
															pattern="#,##0.00" />
													</div>
													<form action="${contextPath}/cart/add" method="post">
														<input type="hidden" name="productId"
															value="${wItem.productId}"> <input type="hidden"
															name="qty" value="1">
														<button type="submit"
															class="p-btn p-btn-primary p-btn-full">Add to
															Cart</button>
													</form>
													<form action="${contextPath}/wishlist/remove" method="post">
														<input type="hidden" name="productId"
															value="${wItem.productId}">
														<button type="submit"
															class="p-btn p-btn-outline p-btn-full">Remove</button>
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
						<div class="pcard-head">
							<div class="pcard-title">Edit Profile</div>
							<div class="pcard-sub">Update your personal information</div>
						</div>
						<div class="pcard-body">
							<form action="${contextPath}/user/profile" method="post">
								<input type="hidden" name="action" value="updateProfile">
								<div class="pf-row">
									<div>
										<label class="pf-lbl" for="ef-firstName">First Name</label><input
											type="text" id="ef-firstName" name="firstName" class="pf-inp"
											value="<c:out value='${currentUser.firstName}'/>" required>
									</div>
									<div>
										<label class="pf-lbl" for="ef-lastName">Last Name</label><input
											type="text" id="ef-lastName" name="lastName" class="pf-inp"
											value="<c:out value='${currentUser.lastName}'/>" required>
									</div>
								</div>
								<div class="pf-grp">
									<label class="pf-lbl">Username</label><input type="text"
										class="pf-inp"
										value="<c:out value='${currentUser.username}'/>" readonly><span
										class="pf-hint">Username cannot be changed</span>
								</div>
								<div class="pf-grp">
									<label class="pf-lbl" for="ef-email">Email Address</label><input
										type="email" id="ef-email" name="email" class="pf-inp"
										value="<c:out value='${currentUser.email}'/>" required>
								</div>
								<div class="pf-grp">
									<label class="pf-lbl" for="ef-phone">Phone Number</label><input
										type="text" id="ef-phone" name="phone" class="pf-inp"
										value="<c:out value='${currentUser.phone}'/>"><span
										class="pf-hint">Must start with + and be exactly 14
										characters</span>
								</div>
								<button type="submit" class="p-btn p-btn-primary p-btn-full">Save
									Changes</button>
							</form>
						</div>
					</div>
				</div>

				<!-- ═══ SECURITY ═══ -->
				<div id="tab-security"
					class="ptab ${openTab == 'security' ? 'active' : ''}">
					<div class="pcard">
						<div class="pcard-head">
							<div class="pcard-title">Change Password</div>
							<div class="pcard-sub">Keep your account safe</div>
						</div>
						<div class="pcard-body">
							<form action="${contextPath}/user/profile" method="post">
								<input type="hidden" name="action" value="changePassword">
								<div class="pf-grp">
									<label class="pf-lbl" for="sf-cur">Current Password</label>
									<div class="password-wrap">
										<input type="password" id="sf-cur" name="currentPassword"
											class="pf-inp" placeholder="Enter your current password"
											required>
										<button type="button" class="toggle-pass"
											onclick="togglePwd('sf-cur',this)">Show</button>
									</div>
								</div>
								<div class="pf-grp">
									<label class="pf-lbl" for="sf-new">New Password</label>
									<div class="password-wrap">
										<input type="password" id="sf-new" name="newPassword"
											class="pf-inp"
											placeholder="Min 7 chars, uppercase, digit, special char"
											oninput="checkStrength(this.value)" required>
										<button type="button" class="toggle-pass"
											onclick="togglePwd('sf-new',this)">Show</button>
									</div>
									<div class="pwd-bar-wrap">
										<div class="pwd-bar-track">
											<div class="pwd-bar-fill" id="strBar"
												style="width: 0%; background: #e8536a;"></div>
										</div>
										<div class="pwd-bar-hint" id="strHint">Enter a new
											password</div>
									</div>
								</div>
								<div class="pf-grp">
									<label class="pf-lbl" for="sf-conf">Confirm New
										Password</label>
									<div class="password-wrap">
										<input type="password" id="sf-conf" name="confirmPassword"
											class="pf-inp" placeholder="Re-enter your new password"
											required>
										<button type="button" class="toggle-pass"
											onclick="togglePwd('sf-conf',this)">Show</button>
									</div>
								</div>
								<div class="req-list">
									<div class="req-list-title">Password Requirements</div>
									<div class="req-item" id="req-len">&#9675; More than 6
										characters</div>
									<div class="req-item" id="req-upper">&#9675; At least one
										uppercase letter</div>
									<div class="req-item" id="req-digit">&#9675; At least one
										number</div>
									<div class="req-item" id="req-special">&#9675; At least
										one special character</div>
								</div>
								<button type="submit" class="p-btn p-btn-primary p-btn-full">Update
									Password</button>
							</form>
						</div>
					</div>
					<div class="pcard">
						<div class="pcard-head">
							<div class="pcard-title">Security Overview</div>
						</div>
						<div class="pcard-body">
							<div class="info-grid">
								<div class="info-tile">
									<div class="info-lbl">Account Status</div>
									<div class="info-val">
										<span class="status-dot">Active &amp; Secure</span>
									</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Failed Login Attempts</div>
									<div class="info-val">${currentUser.loginAttempts}</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Account Locked</div>
									<div class="info-val">
										<c:choose>
											<c:when test="${not empty currentUser.lockedUntil}">
												<span style="color: #e8536a;">Until
													${currentUser.lockedUntil}</span>
											</c:when>
											<c:otherwise>
												<span style="color: #3B9B3F;">No</span>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
								<div class="info-tile">
									<div class="info-lbl">Member Since</div>
									<div class="info-val" style="font-size: .82rem;">${currentUser.createdAt}</div>
								</div>
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
				<div class="footer-brand-col">
					<div class="footer-logo">
						SΡRA<span>.</span>
					</div>
					<p class="footer-tagline">Luxury cosmetics crafted with love.</p>
				</div>
				<div class="footer-col">
					<h4 class="footer-col-title">Quick Links</h4>
					<ul class="footer-links">
						<li><a href="${contextPath}/home">Home</a></li>
						<li><a href="${contextPath}/products">Products</a></li>
						<li><a href="${contextPath}/about">About</a></li>
						<li><a href="${contextPath}/contact">Contact</a></li>
					</ul>
				</div>
				<div class="footer-col">
					<h4 class="footer-col-title">Categories</h4>
					<ul class="footer-links">
						<li><a href="${contextPath}/products?category=1">Skincare</a></li>
						<li><a href="${contextPath}/products?category=2">Makeup</a></li>
						<li><a href="${contextPath}/products?category=3">Fragrance</a></li>
					</ul>
				</div>
				<div class="footer-col">
					<h4 class="footer-col-title">Contact Info</h4>
					<ul class="footer-links">
						<li>Sinamangal, Kathmandu</li>
						<li><a href="mailto:hello@spra.com">hello@spra.com</a></li>
						<li>+977 9878670678</li>
					</ul>
				</div>
			</div>
			<div class="footer-bottom">
				<p class="footer-copy">
					&copy; 2025 Spra. Made with <span class="footer-heart">&#9829;</span>
					All rights reserved.
				</p>
				<div class="footer-legal">
					<a href="#">Privacy Policy</a><a href="#">Terms of Service</a>
				</div>
			</div>
		</div>
	</footer>

	<!-- ═══ ORDER DETAIL POPUP ═══ -->
	<div id="orderDetailOverlay"
		style="display: none; position: fixed; inset: 0; background: rgba(10, 4, 6, .72); backdrop-filter: blur(8px); z-index: 9100; align-items: center; justify-content: center;">
		<div id="orderDetailBox"
			style="background: #fff; border-radius: 22px; width: 600px; max-width: 95vw; max-height: 88vh; overflow-y: auto; box-shadow: 0 40px 100px rgba(0, 0, 0, .28); position: relative; font-family: 'DM Sans', sans-serif;">
			<button onclick="closeOrderDetail()"
				style="position: absolute; top: 16px; right: 16px; background: #f8f0f2; border: none; border-radius: 50%; width: 34px; height: 34px; font-size: 20px; color: #999; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: background .2s, color .2s; z-index: 2;"
				onmouseover="this.style.background='#e8536a';this.style.color='#fff'"
				onmouseout="this.style.background='#f8f0f2';this.style.color='#999'">&times;</button>
			<div style="padding: 2rem 2rem 0;">
				<div id="odEyebrow"
					style="font-size: .6rem; font-weight: 700; letter-spacing: .2em; text-transform: uppercase; color: #e8536a; margin-bottom: 6px;"></div>
				<div id="odTitle"
					style="font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-weight: 600; color: #1a1a1a; margin-bottom: 4px;"></div>
				<div id="odMeta"
					style="font-size: .78rem; color: #aaa; margin-bottom: 1.4rem;"></div>
				<div id="odInfo"
					style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 1.4rem;"></div>
				<div
					style="font-size: .62rem; font-weight: 700; text-transform: uppercase; letter-spacing: .14em; color: #aaa; margin-bottom: 10px;">Items
					in this order</div>
			</div>
			<div id="odItems" style="padding: 0 2rem;"></div>
			<div id="odLoading"
				style="display: none; padding: 4rem 2rem; text-align: center; color: #aaa;">
				<div
					style="font-family: 'Cormorant Garamond', serif; font-size: 1.2rem; font-style: italic;">Loading
					order details…</div>
			</div>
			<div id="odEmpty"
				style="display: none; padding: 3rem 2rem; text-align: center; color: #aaa;">
				<div style="font-size: 2rem; margin-bottom: 10px; opacity: .25;">📦</div>
				<div
					style="font-family: 'Cormorant Garamond', serif; font-size: 1.1rem;">No
					item details recorded for this order</div>
				<div style="font-size: .75rem; margin-top: 6px;">Items are
					tracked for orders placed after the latest update.</div>
			</div>
			<div id="odFooter"
				style="padding: 1.2rem 2rem 2rem; border-top: 1px solid #f8f0f0; margin-top: 1.2rem; display: flex; justify-content: space-between; align-items: center;">
				<span style="font-size: .82rem; color: #aaa;">Total (Cash on
					Delivery)</span> <span id="odTotal"
					style="font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-weight: 600; color: #1a1a1a;"></span>
			</div>
		</div>
	</div>

	<style>
@
keyframes odSlide {from { opacity:0;
	transform: translateY(30px) scale(.97);
}

to {
	opacity: 1;
	transform: translateY(0) scale(1);
}

}
#orderDetailBox {
	animation: odSlide .38s cubic-bezier(.22, 1, .36, 1);
}
</style>

	<script>
var _odCtx = '${contextPath}';

/**
 * Merges order items that share the same productId,
 * summing quantities and subtotals so the same product
 * never appears twice — just shows ×2, ×3 etc.
 */
function mergeOrderItems(items) {
    var map = {};
    var merged = [];
    items.forEach(function(it) {
        var key = it.productId;
        if (map[key] !== undefined) {
            merged[map[key]].quantity += it.quantity;
            merged[map[key]].subtotal += it.subtotal;
        } else {
            map[key] = merged.length;
            merged.push(Object.assign({}, it));
        }
    });
    return merged;
}

function openOrderDetail(orderId, fullName, phone, address, city, status, createdAt, total) {
    var ov = document.getElementById('orderDetailOverlay');
    ov.style.display = 'flex';
    document.getElementById('odEyebrow').textContent = 'Order #SPR-' + orderId;
    document.getElementById('odTitle').textContent   = fullName;
    document.getElementById('odMeta').textContent    = createdAt + '  ·  ' + status;
    document.getElementById('odInfo').innerHTML =
        odTile('Phone',   phone)   +
        odTile('Address', address) +
        odTile('City',    city)    +
        odTile('Payment', 'Cash on Delivery');
    document.getElementById('odTotal').textContent =
        'Rs ' + parseFloat(total).toLocaleString('en-IN', {minimumFractionDigits:2});
    odShow('odLoading'); odHide('odItems'); odHide('odEmpty');

    fetch(_odCtx + '/order/items?orderId=' + orderId)
        .then(function(r){ return r.json(); })
        .then(function(rawItems){
            odHide('odLoading');
            if (!rawItems || rawItems.length === 0) { odShow('odEmpty'); return; }

            /* ── Merge duplicate products ── */
            var items = mergeOrderItems(rawItems);

            var html = '';
            items.forEach(function(it){
                var src = it.imagePath
                    ? _odCtx + '/assets/images/products/' + it.imagePath
                    : null;

                html += '<div style="display:flex;align-items:center;gap:14px;padding:14px 0;border-bottom:1px solid #f8f0f0;">';

                /* Thumbnail */
                html += '<div style="width:64px;height:64px;border-radius:10px;overflow:hidden;background:#f8f0f2;flex-shrink:0;display:flex;align-items:center;justify-content:center;">';
                html += src
                    ? '<img src="' + src + '" style="width:100%;height:100%;object-fit:cover;" onerror="this.parentNode.innerHTML=\'<span style=font-size:1.6rem>💄</span>\'">'
                    : '<span style="font-size:1.6rem;">💄</span>';
                html += '</div>';

                /* Name + quantity pill + price */
                html += '<div style="flex:1;min-width:0;">';
                html += '<div style="font-size:.58rem;color:#aaa;text-transform:uppercase;letter-spacing:1px;margin-bottom:2px;">' + odEsc(it.categoryName) + '</div>';

                /* Product name row — qty pill appears after the name when > 1 */
                html += '<div style="font-family:\'Cormorant Garamond\',serif;font-size:1rem;font-weight:600;color:#1a1a1a;display:flex;align-items:center;gap:4px;flex-wrap:wrap;">';
                html += odEsc(it.productName);
                if (it.quantity > 1) {
                    html += '<span style="display:inline-flex;align-items:center;justify-content:center;background:#e8536a;color:#fff;font-size:.62rem;font-weight:700;min-width:22px;height:22px;border-radius:11px;padding:0 6px;margin-left:6px;letter-spacing:.02em;flex-shrink:0;">×' + it.quantity + '</span>';
                }
                html += '</div>';

                html += '<div style="font-size:.78rem;color:#888;margin-top:2px;">Rs '
                      + parseFloat(it.price).toLocaleString('en-IN', {minimumFractionDigits:2})
                      + ' each</div>';
                html += '</div>';

                /* Line subtotal */
                html += '<div style="font-size:.95rem;font-weight:600;color:#1a1a1a;flex-shrink:0;">Rs '
                      + parseFloat(it.subtotal).toLocaleString('en-IN', {minimumFractionDigits:2})
                      + '</div>';

                html += '</div>';
            });
            document.getElementById('odItems').innerHTML =
                '<div style="padding-bottom:.4rem;">' + html + '</div>';
            odShow('odItems');
        })
        .catch(function(){ odHide('odLoading'); odShow('odEmpty'); });
}

function closeOrderDetail() {
    document.getElementById('orderDetailOverlay').style.display = 'none';
    document.getElementById('odItems').innerHTML = '';
}

function odTile(label, value) {
    return '<div style="background:#fdf8f8;border:1px solid #f0e0e0;border-radius:8px;padding:10px 14px;">'
         + '<div style="font-size:.58rem;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:#aaa;margin-bottom:3px;">' + label + '</div>'
         + '<div style="font-size:.84rem;font-weight:500;color:#1a1a1a;">' + odEsc(value) + '</div>'
         + '</div>';
}
function odEsc(s) {
    if (!s) return '—';
    var d = document.createElement('div'); d.textContent = s; return d.innerHTML;
}
function odShow(id){ document.getElementById(id).style.display = 'block'; }
function odHide(id){ document.getElementById(id).style.display = 'none';  }

document.getElementById('orderDetailOverlay').addEventListener('click', function(e){
    if (e.target === this) closeOrderDetail();
});
document.addEventListener('keydown', function(e){
    if (e.key === 'Escape') closeOrderDetail();
});

/* ── Tab switching ── */
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
    hint.style.color = score > 0 ? colors[score-1] : '#888';
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
