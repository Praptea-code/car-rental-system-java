<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String contextPath = request.getContextPath();
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    }
    request.setAttribute("currentUser", currentUser);
    request.setAttribute("activePage", "products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${product.name} — Spra.</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/productDetail.css"/>
    <style>
        :root {
            --pink: #e8536a;
            --pink-light: #fdf2f4;
            --dark: #1a1a1a;
            --mid: #555;
            --muted: #888;
            --border: #e8d8da;
        }

        /* ── Review styles ── */
        .rv-summary {
            display: flex;
            gap: 2.5rem;
            align-items: center;
            background: var(--pink-light);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.8rem 2rem;
            margin-bottom: 2rem;
        }
        .rv-big-score { text-align: center; flex-shrink: 0; }
        .rv-big-num {
            font-family: 'Cormorant Garamond', serif;
            font-size: 4rem; font-weight: 600; color: var(--dark); line-height: 1;
        }
        .rv-stars-row { display: flex; gap: 3px; justify-content: center; margin: 6px 0 4px; }
        .rv-star { font-size: 16px; color: #e0d8d8; }
        .rv-star.filled { color: #f5a623; }
        .rv-total-lbl { font-size: 12px; color: var(--muted); }
        .rv-bars { flex: 1; display: flex; flex-direction: column; gap: 7px; }
        .rv-bar-row { display: flex; align-items: center; gap: 10px; font-size: 12px; color: var(--muted); }
        .rv-bar-label { min-width: 38px; text-align: right; }
        .rv-bar-track { flex: 1; height: 6px; background: #f0e0e0; border-radius: 3px; overflow: hidden; }
        .rv-bar-fill { height: 100%; background: #f5a623; border-radius: 3px; transition: width .4s ease; }
        .rv-bar-count { min-width: 24px; }

        .rv-form-card {
            background: #fff; border: 1px solid var(--border);
            border-radius: 14px; padding: 1.8rem 2rem; margin-bottom: 2rem;
        }
        .rv-form-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.4rem; font-weight: 600; color: var(--dark); margin-bottom: 1.2rem;
        }
        .rv-star-picker { display: flex; gap: 6px; margin-bottom: 14px; }
        .rv-star-btn {
            font-size: 28px; color: #e0d8d8; background: none; border: none;
            cursor: pointer; transition: color .15s, transform .15s; padding: 2px; line-height: 1;
        }
        .rv-star-btn:hover, .rv-star-btn.selected { color: #f5a623; transform: scale(1.15); }
        .rv-star-hint { font-size: 12px; color: var(--muted); margin-bottom: 14px; }
        .rv-inp {
            width: 100%; padding: 10px 14px; border: 1.5px solid var(--border);
            border-radius: 8px; font-family: 'DM Sans', sans-serif; font-size: 14px;
            color: var(--dark); outline: none; transition: border-color .18s;
            margin-bottom: 12px; display: block;
        }
        .rv-inp:focus { border-color: var(--pink); }
        textarea.rv-inp { min-height: 110px; resize: vertical; }
        .rv-submit-btn {
            background: var(--pink); color: #fff; border: none;
            padding: 12px 28px; border-radius: 8px; font-size: 14px;
            font-weight: 600; font-family: 'DM Sans', sans-serif; transition: opacity .2s;
        }
        .rv-submit-btn:hover { opacity: .88; }

        .rv-list { display: flex; flex-direction: column; gap: 16px; }
        .rv-card { background: #fff; border: 1px solid var(--border); border-radius: 12px; padding: 1.4rem 1.6rem; }
        .rv-card-head { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 10px; }
        .rv-avatar {
            width: 42px; height: 42px; border-radius: 50%;
            background: linear-gradient(135deg, #e8536a, #c0424e);
            display: flex; align-items: center; justify-content: center;
            font-family: 'Cormorant Garamond', serif; font-size: 15px;
            font-weight: 600; color: #fff; flex-shrink: 0; letter-spacing: 1px;
        }
        .rv-meta { flex: 1; }
        .rv-name { font-size: 14px; font-weight: 600; color: var(--dark); }
        .rv-date { font-size: 11px; color: var(--muted); margin-top: 1px; }
        .rv-rating-stars { display: flex; gap: 2px; margin-left: auto; flex-shrink: 0; }
        .rv-rating-stars .rv-star { font-size: 13px; }
        .rv-card-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1rem; font-weight: 600; color: var(--dark); margin-bottom: 5px;
        }
        .rv-card-body { font-size: 13.5px; color: var(--mid); line-height: 1.75; }
        .rv-empty { text-align: center; padding: 3rem 2rem; color: var(--muted); }
        .rv-empty-icon { font-size: 2.5rem; margin-bottom: 10px; opacity: .3; }
        .rv-empty-title {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.4rem; color: var(--dark); margin-bottom: 6px;
        }
        .rv-login-nudge {
            background: var(--pink-light); border: 1px solid var(--border);
            border-radius: 10px; padding: 1rem 1.4rem; font-size: 13px;
            color: var(--mid); margin-bottom: 2rem;
            display: flex; align-items: center; justify-content: space-between; gap: 12px;
        }
        .rv-login-nudge a {
            background: var(--pink); color: #fff; padding: 8px 18px;
            border-radius: 6px; font-size: 13px; font-weight: 600;
            white-space: nowrap; transition: opacity .2s;
        }
        .rv-login-nudge a:hover { opacity: .88; }
        .rv-already {
            background: #eaf3de; border: 1px solid #c0dd97; color: #3B6D11;
            border-radius: 10px; padding: 1rem 1.4rem; font-size: 13px; margin-bottom: 2rem;
        }

        /* ── Cart badge ── */
        .cart-icon-btn { position: relative; }
        .cart-badge {
            position: absolute; top: -6px; right: -6px;
            background: var(--pink); color: #fff; font-size: 10px; font-weight: 600;
            width: 18px; height: 18px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center; line-height: 1;
        }

        .pd-btn-cart {
		    flex: 1; background: #1a1a1a; color: #fff; border: none;
		    padding: 14px 16px; border-radius: 10px; font-size: 14px;
		    font-weight: 500; font-family: 'DM Sans', sans-serif; cursor: pointer;
		    transition: background .2s; display: flex; align-items: center;
		    justify-content: center; gap: 8px;
		}
		.pd-btn-cart:hover:not(:disabled) { background: #e8536a; }
		.pd-btn-cart:disabled { background: #e0e0e0; color: #999; cursor: not-allowed; }
		
		.pd-btn-buy-now {
		    flex: 1; background: #e8536a; color: #fff; border: none;
		    padding: 14px 16px; border-radius: 10px; font-size: 14px;
		    font-weight: 700; font-family: 'DM Sans', sans-serif; cursor: pointer;
		    transition: opacity .2s; display: flex; align-items: center;
		    justify-content: center; gap: 8px; letter-spacing: .04em;
		}
		.pd-btn-buy-now:hover { opacity: .88; }
		
		.pd-btn-wishlist {
		    width: 50px; border: 1.5px solid #e8d8da; background: #fff;
		    border-radius: 10px; display: flex; align-items: center;
		    justify-content: center; cursor: pointer; transition: border-color .2s,
		    background .2s; color: #aaa;
		}
		.pd-btn-wishlist:hover { border-color: #e8536a; background: #fdf0f2; color: #e8536a; }
		.pd-btn-wishlist.wishlisted { border-color: #e8536a; background: #fdf0f2; }
    </style>
</head>
<body>

<!-- ═══ NAVIGATION ═══ -->
<nav class="nav">
    <div class="nav-logo">SΡRA<span class="nav-dot">.</span></div>
    <ul class="nav-links">
        <li><a href="<%= contextPath %>/home">Home</a></li>
        <li><a href="<%= contextPath %>/products" class="active">Products</a></li>
        <li><a href="<%= contextPath %>/about">About</a></li>
        <li><a href="<%= contextPath %>/contact">Contact</a></li>
    </ul>
    <div class="nav-right">
        <a href="<%= contextPath %>/products" class="nav-icon-btn" title="Search">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
            </svg>
        </a>
        <a href="<%= contextPath %>/cart" class="nav-icon-btn cart-icon-btn" title="Cart">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                <line x1="3" y1="6" x2="21" y2="6"/>
                <path d="M16 10a4 4 0 0 1-8 0"/>
            </svg>
            <c:if test="${not empty cart and cart.totalCount > 0}">
                <span class="cart-badge">${cart.totalCount}</span>
            </c:if>
        </a>
        <c:choose>
            <c:when test="${not empty currentUser}">
                <div class="nav-user-wrap">
                    <span class="nav-username">Hi, ${currentUser.firstName}</span>
                    <c:if test="${currentUser.role == 'ADMIN'}">
                        <a href="<%= contextPath %>/admin/dashboard" class="nav-admin-btn">Dashboard</a>
                    </c:if>
                    <a href="<%= contextPath %>/user/profile" class="nav-profile-btn">Profile</a>
                    <form action="<%= contextPath %>/logout" method="post" style="display:inline">
                        <button type="submit" class="nav-logout-btn">Logout</button>
                    </form>
                </div>
            </c:when>
            <c:otherwise>
                <a href="<%= contextPath %>/login" class="nav-login-btn">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- ═══ MAIN CONTENT ═══ -->
<main class="pd-page">

    <!-- Breadcrumb -->
    <nav class="pd-breadcrumb">
        <a href="<%= contextPath %>/home">Home</a>
        <span class="pd-breadcrumb-sep">›</span>
        <a href="<%= contextPath %>/products">Products</a>
        <c:if test="${not empty product.categoryName}">
            <span class="pd-breadcrumb-sep">›</span>
            <a href="<%= contextPath %>/products?category=${product.categoryId}">${product.categoryName}</a>
        </c:if>
        <span class="pd-breadcrumb-sep">›</span>
        <span class="pd-breadcrumb-current">${product.name}</span>
    </nav>

    <!-- Flash messages -->
    <c:if test="${not empty sessionScope.reviewSuccess}">
        <div class="alert alert-success">${sessionScope.reviewSuccess}</div>
        <c:remove var="reviewSuccess" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.reviewError}">
        <div class="alert alert-error">${sessionScope.reviewError}</div>
        <c:remove var="reviewError" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.wishlistToast}">
        <div class="alert alert-success">${sessionScope.wishlistToast}</div>
        <c:remove var="wishlistToast" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-error">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.cartToast}">
        <div class="alert alert-success">${sessionScope.cartToast} was added to your cart!</div>
        <c:remove var="cartToast" scope="session"/>
    </c:if>

    <!-- ── PRODUCT MAIN ── -->
    <div class="pd-main">

        <!-- Image Panel -->
        <div class="pd-image-panel" id="imagePanel">
            <c:choose>
                <c:when test="${not empty product.imagePath}">
                    <img src="${pageContext.request.contextPath}/assets/images/products/${product.imagePath}"
                         alt="${product.name}" class="pd-img-main" id="mainProductImg"/>
                </c:when>
                <c:otherwise>
                    <div class="pd-img-placeholder">
                        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#e0c8c8" stroke-width="1">
                            <rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/>
                            <polyline points="21 15 16 10 5 21"/>
                        </svg>
                        <span>No image available</span>
                    </div>
                </c:otherwise>
            </c:choose>
            <c:if test="${product.discountPercent > 0}">
                <div class="pd-discount-badge">−${product.discountPercent}%</div>
            </c:if>
            <c:if test="${product.outOfStock}">
                <div class="pd-stock-badge-oos">Out of Stock</div>
            </c:if>
        </div>

        <!-- Info Panel -->
        <div class="pd-info-panel">

            <c:if test="${not empty product.categoryName}">
                <span class="pd-category-tag">${product.categoryName}</span>
            </c:if>

            <h1 class="pd-title">${product.name}</h1>

            <!-- Star rating snapshot -->
            <c:if test="${reviewCount > 0}">
                <div style="display:flex;align-items:center;gap:8px;margin-bottom:12px;">
                    <div class="rv-stars-row" style="justify-content:flex-start;">
                        <c:forEach begin="1" end="5" var="s">
                            <span class="rv-star <c:if test="${s <= avgRating}">filled</c:if>">&#9733;</span>
                        </c:forEach>
                    </div>
                    <span style="font-size:13px;color:var(--muted);">
                        <fmt:formatNumber value="${avgRating}" pattern="#.#"/>
                        (${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if>)
                    </span>
                </div>
            </c:if>

            <!-- Price -->
            <div class="pd-price-row">
                <span class="pd-price">Rs. <fmt:formatNumber value="${product.price}" pattern="#,##0.00"/></span>
                <c:if test="${not empty product.oldPrice and product.oldPrice > 0 and product.oldPrice > product.price}">
                    <span class="pd-price-old">Rs. <fmt:formatNumber value="${product.oldPrice}" pattern="#,##0.00"/></span>
                    <span class="pd-price-save">Save ${product.discountPercent}%</span>
                </c:if>
            </div>

            <!-- Trust badges -->
            <div class="pd-trust-row">
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                    <span>100% Authentic</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    <span>Fast Delivery</span>
                </div>
                <div class="pd-trust-item">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                    <span>Easy Returns</span>
                </div>
            </div>

            <!-- Stock status -->
            <div class="pd-stock-row">
                <span class="pd-stock-dot ${product.outOfStock ? 'pd-stock-dot--out' : 'pd-stock-dot--in'}"></span>
                <c:choose>
                    <c:when test="${product.outOfStock}">
                        <span class="pd-stock-label--out">Out of stock</span>
                    </c:when>
                    <c:otherwise>
                        <span class="pd-stock-label--in">In stock</span>
                        <c:if test="${product.stock > 0 and product.stock <= 10}">
                            <span style="font-size:12px;color:#888;">— only ${product.stock} left</span>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Description -->
            <c:if test="${not empty product.description}">
                <p class="pd-description">${product.description}</p>
            </c:if>

            <div class="pd-divider"></div>

            <!-- ══════════════════════════════════════════
                 ACTION BUTTONS — logged in user
                 ══════════════════════════════════════════ -->
            <c:choose>
                <c:when test="${not empty currentUser}">

                    <!-- Quantity stepper -->
                    <div class="pd-qty-row">
                        <label class="pd-qty-label">Quantity</label>
                        <div class="pd-qty-wrap">
                            <button type="button" class="pd-qty-btn" onclick="changeQty(-1)" <c:if test="${product.outOfStock}">disabled</c:if>>−</button>
                            <input type="number" id="qtyInput" value="1" min="1"
                                   max="${product.stock > 0 ? product.stock : 1}"
                                   class="pd-qty-val" <c:if test="${product.outOfStock}">disabled</c:if>
                                   oninput="syncQty()"/>
                            <button type="button" class="pd-qty-btn" onclick="changeQty(1)" <c:if test="${product.outOfStock}">disabled</c:if>">+</button>
                        </div>
                    </div>

                    <%--
                        THREE separate forms, laid out with a wrapper div.
                        Row 1: [Add to Cart] [♡ Wishlist]
                        Row 2: [Buy Now — full width]
                        Using display:contents on each <form> so flex layout
                        flows through them without extra boxes.
                    --%>
                    
                    <div class="pd-actions" style="display:flex; gap:10px; align-items:stretch; margin-bottom:20px;">

					    <%-- Add to Cart --%>
					    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
					        <input type="hidden" name="productId" value="${product.productId}"/>
					        <input type="hidden" name="qty" id="qtyHidden" value="1"/>
					        <button type="submit" class="pd-btn-cart" style="width:100%;"
					                <c:if test="${product.outOfStock}">disabled</c:if>
					                onclick="syncQty()">
					            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
					                <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
					                <line x1="3" y1="6" x2="21" y2="6"/>
					                <path d="M16 10a4 4 0 0 1-8 0"/>
					            </svg>
					            <c:choose>
					                <c:when test="${product.outOfStock}">Unavailable</c:when>
					                <c:otherwise>Add to Cart</c:otherwise>
					            </c:choose>
					        </button>
					    </form>
					
					    <%-- Buy Now --%>
					    <c:if test="${not product.outOfStock}">
					        <form action="${pageContext.request.contextPath}/buy-now" method="post" style="flex:1;">
					            <input type="hidden" name="productId" value="${product.productId}"/>
					            <input type="hidden" name="qty" id="qtyBuyNow" value="1"/>
					            <button type="submit" class="pd-btn-buy-now" style="width:100%;" onclick="syncQty()">
					                ✦ Buy Now
					            </button>
					        </form>
					    </c:if>
					
					    <%-- Wishlist heart --%>
					    <form action="${pageContext.request.contextPath}/wishlist/${isWishlisted ? 'remove' : 'add'}"
					          method="post" style="flex-shrink:0;">
					        <input type="hidden" name="productId" value="${product.productId}"/>
					        <button type="submit"
					                class="pd-btn-wishlist ${isWishlisted ? 'wishlisted' : ''}"
					                title="${isWishlisted ? 'Remove from wishlist' : 'Add to wishlist'}"
					                style="width:50px; height:100%;">
					            <svg width="20" height="20" viewBox="0 0 24 24"
					                 fill="${isWishlisted ? '#e8536a' : 'none'}"
					                 stroke="${isWishlisted ? '#e8536a' : 'currentColor'}"
					                 stroke-width="1.8">
					                <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
					            </svg>
					        </button>
					    </form>
					
					</div>
                    
                </c:when>
                <c:otherwise>
                    <%-- Not logged in — show login prompt --%>
                    <div style="margin-bottom:20px;">
                        <a href="${pageContext.request.contextPath}/login"
                           style="display:flex;align-items:center;justify-content:center;gap:8px;
                                  width:100%;background:#1a1a1a;color:#fff;border:none;
                                  padding:14px 20px;border-radius:10px;font-size:14px;font-weight:500;
                                  font-family:'DM Sans',sans-serif;transition:background .2s;
                                  text-decoration:none;margin-bottom:10px;"
                           onmouseover="this.style.background='#e8536a'"
                           onmouseout="this.style.background='#1a1a1a'">
                            Login to Add to Cart
                        </a>
                        <a href="${pageContext.request.contextPath}/login"
                           style="display:flex;align-items:center;justify-content:center;gap:8px;
                                  width:100%;background:#e8536a;color:#fff;border:none;
                                  padding:14px 20px;border-radius:10px;font-size:14px;font-weight:700;
                                  font-family:'DM Sans',sans-serif;transition:opacity .2s;
                                  text-decoration:none;letter-spacing:.04em;"
                           onmouseover="this.style.opacity='.88'"
                           onmouseout="this.style.opacity='1'">
                            ✦ Login to Buy Now
                        </a>
                        <p style="font-size:12px;color:#aaa;text-align:center;margin-top:8px;">
                            <a href="${pageContext.request.contextPath}/register" style="color:#e8536a;">Create an account</a> to start shopping
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="pd-divider"></div>

            <!-- Meta -->
            <div class="pd-meta">
                <c:if test="${not empty product.categoryName}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Category</span>
                        <span class="pd-meta-value">${product.categoryName}</span>
                    </div>
                </c:if>
                <c:if test="${product.featured}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Featured</span>
                        <span class="pd-meta-value" style="color:#e8536a;">✦ Featured Product</span>
                    </div>
                </c:if>
                <c:if test="${product.bestseller}">
                    <div class="pd-meta-row">
                        <span class="pd-meta-key">Status</span>
                        <span class="pd-meta-value" style="color:#e8536a;">✦ Bestseller</span>
                    </div>
                </c:if>
                <div class="pd-meta-row">
                    <span class="pd-meta-key">Product ID</span>
                    <span class="pd-meta-value" style="font-family:monospace;font-size:12px;">#SPR-${product.productId}</span>
                </div>
            </div>

        </div><%-- /pd-info-panel --%>
    </div><%-- /pd-main --%>

    <!-- ── TABS ── -->
    <div class="pd-tabs" id="pdTabs">
        <div class="pd-tab-nav">
            <button class="pd-tab-btn active" onclick="switchTab(event,'tab-desc')">Description</button>
            <button class="pd-tab-btn" onclick="switchTab(event,'tab-reviews')" id="reviewsTabBtn">
                Reviews
                <c:if test="${reviewCount > 0}">
                    <span style="background:#e8536a;color:#fff;font-size:10px;padding:1px 7px;border-radius:10px;margin-left:6px;font-family:'DM Sans',sans-serif;">${reviewCount}</span>
                </c:if>
            </button>
        </div>

        <!-- Description Tab -->
        <div id="tab-desc" class="pd-tab-pane active">
            <c:choose>
                <c:when test="${not empty product.description}">
                    <p class="pd-desc-text">${product.description}</p>
                </c:when>
                <c:otherwise>
                    <p class="pd-desc-text" style="color:#aaa;font-style:italic;">No detailed description available.</p>
                </c:otherwise>
            </c:choose>
            <div class="pd-features-title">Key Features</div>
            <div class="pd-features-list">
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Carefully curated and quality-tested by the Spra team</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Cruelty-free and ethically sourced ingredients where applicable</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Suitable for all skin types — gentle and effective formula</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Dermatologist approved and clinically tested</span>
                </div>
                <div class="pd-feature-item">
                    <div class="pd-feature-check"><svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg></div>
                    <span>Elegant, eco-conscious packaging that looks beautiful on your shelf</span>
                </div>
            </div>
        </div>

        <!-- Reviews Tab -->
        <div id="tab-reviews" class="pd-tab-pane">

            <c:if test="${reviewCount > 0}">
                <div class="rv-summary">
                    <div class="rv-big-score">
                        <div class="rv-big-num"><fmt:formatNumber value="${avgRating}" pattern="#.#"/></div>
                        <div class="rv-stars-row">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="rv-star <c:if test="${s <= avgRating}">filled</c:if>">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="rv-total-lbl">${reviewCount} review<c:if test="${reviewCount != 1}">s</c:if></div>
                    </div>
                    <div class="rv-bars">
                        <c:forEach begin="0" end="4" var="i">
                            <c:set var="starNum" value="${5 - i}"/>
                            <c:set var="cnt" value="${ratingDist[starNum - 1]}"/>
                            <c:set var="pct" value="${reviewCount > 0 ? (cnt * 100 / reviewCount) : 0}"/>
                            <div class="rv-bar-row">
                                <span class="rv-bar-label">${starNum} &#9733;</span>
                                <div class="rv-bar-track">
                                    <div class="rv-bar-fill" style="width:${pct}%"></div>
                                </div>
                                <span class="rv-bar-count">${cnt}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${empty currentUser}">
                    <div class="rv-login-nudge">
                        <span>Sign in to leave a review for this product.</span>
                        <a href="${pageContext.request.contextPath}/login">Login to Review</a>
                    </div>
                </c:when>
                <c:when test="${alreadyReviewed}">
                    <div class="rv-already">
                        ✓ You've already reviewed this product. Thank you for your feedback!
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rv-form-card">
                        <div class="rv-form-title">Write a Review</div>
                        <form action="${pageContext.request.contextPath}/review/add" method="post" id="reviewForm">
                            <input type="hidden" name="productId" value="${product.productId}"/>
                            <input type="hidden" name="rating" id="ratingInput" value="0"/>
                            <div class="rv-star-picker" id="starPicker">
                                <c:forEach begin="1" end="5" var="s">
                                    <button type="button" class="rv-star-btn" data-val="${s}"
                                            onclick="setRating(${s})">&#9733;</button>
                                </c:forEach>
                            </div>
                            <div class="rv-star-hint" id="starHint">Click to rate this product</div>
                            <input type="text" name="title" class="rv-inp"
                                   placeholder="Review title (optional)" maxlength="120"/>
                            <textarea name="body" class="rv-inp"
                                      placeholder="Share your experience with this product..." required></textarea>
                            <button type="submit" class="rv-submit-btn"
                                    onclick="return validateReview()">Post Review</button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${empty reviews}">
                    <div class="rv-empty">
                        <div class="rv-empty-icon">&#9733;</div>
                        <div class="rv-empty-title">No reviews yet</div>
                        <p style="font-size:13px;">Be the first to share your experience!</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rv-list">
                        <c:forEach var="rv" items="${reviews}">
                            <div class="rv-card">
                                <div class="rv-card-head">
                                    <div class="rv-avatar">${rv.initials}</div>
                                    <div class="rv-meta">
                                        <div class="rv-name">${rv.fullName}</div>
                                        <div class="rv-date">
                                            <fmt:formatDate value="${rv.createdAt}" pattern="MMM dd, yyyy"/>
                                        </div>
                                    </div>
                                    <div class="rv-rating-stars">
                                        <c:forEach begin="1" end="5" var="s">
                                            <span class="rv-star ${s <= rv.rating ? 'filled' : ''}">&#9733;</span>
                                        </c:forEach>
                                    </div>
                                </div>
                                <c:if test="${not empty rv.title}">
                                    <div class="rv-card-title">${rv.title}</div>
                                </c:if>
                                <div class="rv-card-body"><c:out value="${rv.body}" /></div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

        </div><%-- /tab-reviews --%>
    </div><%-- /pd-tabs --%>

    <!-- ── RELATED PRODUCTS ── -->
    <c:if test="${not empty relatedProducts}">
        <section class="pd-related">
            <h2 class="pd-related-title">You Might Also Like</h2>
            <p class="pd-related-sub">Discover more from the ${product.categoryName} collection</p>
            <div class="pd-related-grid">
                <c:forEach items="${relatedProducts}" var="rp">
                    <a href="${pageContext.request.contextPath}/productDetail?id=${rp.productId}"
                       class="product-card" style="text-decoration:none;display:block;">
                        <div class="product-img-area" style="position:relative;">
                            <c:choose>
                                <c:when test="${not empty rp.imagePath}">
                                    <img src="${pageContext.request.contextPath}/assets/images/products/${rp.imagePath}"
                                         alt="${rp.name}" class="product-img">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;background:#fdf8f8;color:#ddd;font-size:12px;">No image</div>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${rp.discountPercent > 0}">
                                <span class="discount-badge">−${rp.discountPercent}%</span>
                            </c:if>
                        </div>
                        <div class="product-info">
                            <p class="product-cat">${rp.categoryName}</p>
                            <h3 class="product-name">${rp.name}</h3>
                            <div class="product-price-row">
                                <span class="product-price">Rs. <fmt:formatNumber value="${rp.price}" pattern="#,##0.00"/></span>
                                <c:if test="${rp.oldPrice > 0 and rp.oldPrice > rp.price}">
                                    <span class="product-price-old">Rs. <fmt:formatNumber value="${rp.oldPrice}" pattern="#,##0"/></span>
                                </c:if>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </section>
    </c:if>

</main>

<!-- ═══ FOOTER ═══ -->
<footer class="footer">
    <div class="footer-inner">
        <div class="footer-grid">
            <div class="footer-brand-col">
                <div class="footer-logo">SΡRA<span>.</span></div>
                <p class="footer-tagline">Luxury cosmetics crafted with love. Discover beauty products that make you feel confident and radiant every day.</p>
            </div>
            <div class="footer-col">
                <h4 class="footer-col-title">Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/home">Home</a></li>
                    <li><a href="<%= contextPath %>/products">Products</a></li>
                    <li><a href="<%= contextPath %>/about">About</a></li>
                    <li><a href="<%= contextPath %>/contact">Contact</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4 class="footer-col-title">Categories</h4>
                <ul class="footer-links">
                    <li><a href="<%= contextPath %>/products?category=1">Skincare</a></li>
                    <li><a href="<%= contextPath %>/products?category=2">Makeup</a></li>
                    <li><a href="<%= contextPath %>/products?category=3">Fragrance</a></li>
                    <li><a href="<%= contextPath %>/products?category=4">Lips</a></li>
                    <li><a href="<%= contextPath %>/products?category=5">Eyes</a></li>
                    <li><a href="<%= contextPath %>/products?category=6">Tools</a></li>
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
            <p class="footer-copy">&copy; 2026 Spra. Made with <span class="footer-heart">&#9829;</span> All rights reserved.</p>
            <div class="footer-legal">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
            </div>
        </div>
    </div>
</footer>

<!-- ═══ SCRIPTS ═══ -->
<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
/* Sync visible qty to both cart and buy-now hidden fields */
function syncQty() {
    var val = document.getElementById('qtyInput').value;
    var h = document.getElementById('qtyHidden');
    var b = document.getElementById('qtyBuyNow');
    if (h) h.value = val;
    if (b) b.value = val;
}

function changeQty(delta) {
    var input = document.getElementById('qtyInput');
    if (!input) return;
    var val = parseInt(input.value) || 1;
    var max = parseInt(input.max) || 999;
    input.value = Math.max(1, Math.min(max, val + delta));
    syncQty();
}

function switchTab(event, tabId) {
    document.querySelectorAll('.pd-tab-btn').forEach(function(b){ b.classList.remove('active'); });
    document.querySelectorAll('.pd-tab-pane').forEach(function(p){ p.classList.remove('active'); });
    event.currentTarget.classList.add('active');
    var pane = document.getElementById(tabId);
    if (pane) pane.classList.add('active');
}

if (window.location.hash === '#tab-reviews') {
    var btn = document.getElementById('reviewsTabBtn');
    if (btn) btn.click();
}

var currentRating = 0;
var starLabels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

function setRating(val) {
    currentRating = val;
    document.getElementById('ratingInput').value = val;
    document.getElementById('starHint').textContent = starLabels[val] || '';
    Array.from(document.querySelectorAll('.rv-star-btn')).forEach(function(btn) {
        var v = parseInt(btn.getAttribute('data-val'));
        btn.classList.toggle('selected', v <= val);
    });
}

Array.from(document.querySelectorAll('.rv-star-btn')).forEach(function(btn) {
    btn.addEventListener('mouseenter', function() {
        var hoverVal = parseInt(btn.getAttribute('data-val'));
        document.querySelectorAll('.rv-star-btn').forEach(function(b) {
            b.style.color = parseInt(b.getAttribute('data-val')) <= hoverVal ? '#f5a623' : '#e0d8d8';
        });
        document.getElementById('starHint').textContent = starLabels[hoverVal];
    });
    btn.addEventListener('mouseleave', function() {
        document.querySelectorAll('.rv-star-btn').forEach(function(b) {
            var v = parseInt(b.getAttribute('data-val'));
            b.style.color = v <= currentRating ? '#f5a623' : '#e0d8d8';
        });
        document.getElementById('starHint').textContent =
            currentRating > 0 ? starLabels[currentRating] : 'Click to rate this product';
    });
});

function validateReview() {
    if (currentRating === 0) {
        alert('Please select a star rating before submitting.');
        return false;
    }
    return true;
}

/* Image zoom on hover */
(function() {
    var panel = document.getElementById('imagePanel');
    var img   = document.getElementById('mainProductImg');
    if (!panel || !img) return;
    panel.addEventListener('mousemove', function(e) {
        var rect = panel.getBoundingClientRect();
        var x = ((e.clientX - rect.left) / rect.width  * 100).toFixed(1);
        var y = ((e.clientY - rect.top)  / rect.height * 100).toFixed(1);
        img.style.transformOrigin = x + '% ' + y + '%';
        img.style.transform = 'scale(1.55)';
    });
    panel.addEventListener('mouseleave', function() {
        img.style.transform = 'scale(1)';
        img.style.transformOrigin = 'center center';
    });
})();
</script>

</body>
</html>
