/* ---- Password toggle ---- */
function togglePassword(fieldId, btn) {
    var field = document.getElementById(fieldId);
    if (!field) return;
    if (field.type === 'password') {
        field.type = 'text';
        btn.textContent = 'Hide';
    } else {
        field.type = 'password';
        btn.textContent = 'Show';
    }
}

/* 
   CART TOAST POPUP
   showCartToast(name, category, price, imagePath, contextPath)
    */
var _ctpDismissTimer = null;

function showCartToast(name, category, price, imagePath, contextPath) {
    var old = document.getElementById('sprCartToast');
    if (old) { old.remove(); }
    if (_ctpDismissTimer) { clearTimeout(_ctpDismissTimer); }

    var thumbHtml;
    if (imagePath && imagePath.trim() !== '') {
        thumbHtml = '<img src="' + contextPath + '/assets/images/products/' + imagePath + '" '
                  + 'alt="" onerror="this.style.display=\'none\';this.parentNode.innerHTML=\'&#128138;\'">';
    } else {
        thumbHtml = '&#128138;';
    }

    var priceFormatted = 'Rs ' + parseFloat(price).toLocaleString('en-IN', { minimumFractionDigits: 2 });

    var div = document.createElement('div');
    div.className = 'cart-toast-popup';
    div.id = 'sprCartToast';
    div.innerHTML = ''
        + '<button class="ctp-close" onclick="dismissCartToast()" aria-label="Close">&times;</button>'
        + '<div class="ctp-head">'
        +   '<div class="ctp-check">'
        +     '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>'
        +   '</div>'
        +   '<div>'
        +     '<div class="ctp-title">Added to cart!</div>'
        +     '<div class="ctp-sub">Item added successfully</div>'
        +   '</div>'
        + '</div>'
        + '<div class="ctp-product">'
        +   '<div class="ctp-thumb">' + thumbHtml + '</div>'
        +   '<div>'
        +     '<div class="ctp-cat">' + (category || '') + '</div>'
        +     '<div class="ctp-name">' + name + '</div>'
        +     '<div class="ctp-price">' + priceFormatted + '</div>'
        +   '</div>'
        + '</div>'
        + '<div class="ctp-btns">'
        +   '<button class="ctp-btn-cart" onclick="location.href=\'' + contextPath + '/cart\'">View Cart &rarr;</button>'
        +   '<button class="ctp-btn-cont" onclick="dismissCartToast()">Keep Shopping</button>'
        + '</div>'
        + '<div class="ctp-bar"><div class="ctp-bar-fill"></div></div>';

    document.body.appendChild(div);
    _ctpDismissTimer = setTimeout(function () { dismissCartToast(); }, 4000);
}

function dismissCartToast() {
    var toast = document.getElementById('sprCartToast');
    if (!toast) return;
    toast.classList.add('ctp-hiding');
    setTimeout(function () {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
    }, 300);
    if (_ctpDismissTimer) { clearTimeout(_ctpDismissTimer); _ctpDismissTimer = null; }
}

/* ============================================================
   WISHLIST TOAST POPUP
   showWishlistToast(action, name, imagePath, contextPath)
   action = 'added' | 'removed'
   ============================================================ */
var _wtpDismissTimer = null;

function showWishlistToast(action, name, imagePath, contextPath) {
    var old = document.getElementById('sprWishlistToast');
    if (old) { old.remove(); }
    if (_wtpDismissTimer) { clearTimeout(_wtpDismissTimer); }

    var isAdded   = (action === 'added');
    var accentColor = '#e8536a';

    var thumbHtml;
    if (imagePath && imagePath.trim() !== '') {
        thumbHtml = '<img src="' + contextPath + '/assets/images/products/' + imagePath + '" '
                  + 'alt="" onerror="this.style.display=\'none\';this.parentNode.innerHTML=\'&#10084;\'">';
    } else {
        thumbHtml = '&#10084;';
    }

    var div = document.createElement('div');
    div.className = 'cart-toast-popup';   /* reuse the same styles */
    div.id = 'sprWishlistToast';
    div.innerHTML = ''
        + '<button class="ctp-close" onclick="dismissWishlistToast()" aria-label="Close">&times;</button>'
        + '<div class="ctp-head">'
        +   '<div class="ctp-check" style="background:' + accentColor + ';">'
        +     (isAdded
                ? '<svg width="16" height="16" viewBox="0 0 24 24" fill="#fff" stroke="none"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>'
                : '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14H6L5 6"/><path d="M9 6V4h6v2"/></svg>')
        +   '</div>'
        +   '<div>'
        +     '<div class="ctp-title">' + (isAdded ? 'Added to wishlist!' : 'Removed from wishlist') + '</div>'
        +     '<div class="ctp-sub">' + (isAdded ? 'Saved for later' : 'Item removed') + '</div>'
        +   '</div>'
        + '</div>'
        + '<div class="ctp-product">'
        +   '<div class="ctp-thumb">' + thumbHtml + '</div>'
        +   '<div style="min-width:0;">'
        +     '<div class="ctp-cat">Wishlist</div>'
        +     '<div class="ctp-name">' + name + '</div>'
        +   '</div>'
        + '</div>'
        + '<div class="ctp-btns">'
        +   (isAdded
              ? '<button class="ctp-btn-cart" onclick="location.href=\'' + contextPath + '/user/profile?tab=wishlist\'">View Wishlist &rarr;</button>'
              : '<button class="ctp-btn-cart" onclick="location.href=\'' + contextPath + '/products\'">Browse Products &rarr;</button>')
        +   '<button class="ctp-btn-cont" onclick="dismissWishlistToast()">Continue Browsing</button>'
        + '</div>'
        + '<div class="ctp-bar"><div class="ctp-bar-fill"></div></div>';

    document.body.appendChild(div);
    _wtpDismissTimer = setTimeout(function () { dismissWishlistToast(); }, 4000);
}

function dismissWishlistToast() {
    var toast = document.getElementById('sprWishlistToast');
    if (!toast) return;
    toast.classList.add('ctp-hiding');
    setTimeout(function () {
        if (toast.parentNode) toast.parentNode.removeChild(toast);
    }, 300);
    if (_wtpDismissTimer) { clearTimeout(_wtpDismissTimer); _wtpDismissTimer = null; }
}

/* ============================================================
   UPDATE NAV CART BADGE
   ============================================================ */
function updateNavCartBadge(count) {
    document.querySelectorAll('.cart-badge').forEach(function (b) { b.remove(); });

    if (count > 0) {
        var badge = document.createElement('span');
        badge.className = 'cart-badge';
        badge.textContent = count;
        document.querySelectorAll('.cart-icon-btn').forEach(function (iconBtn) {
            iconBtn.appendChild(badge.cloneNode(true));
        });
    }
}

/* 
   AJAX ADD TO CART  (used on home.jsp featured products)
   */
function addToCart(btn, productId, name, category, price, imagePath, contextPath) {
    btn.disabled = true;
    var original = btn.textContent;
    btn.textContent = 'Adding…';

    var fd = new FormData();
    fd.append('productId', productId);
    fd.append('qty', 1);

    fetch(contextPath + '/cart/add', {
        method: 'POST',
        body: fd,
        credentials: 'same-origin'
    })
    .then(function (response) {
        btn.textContent = '✓ Added!';
        setTimeout(function () {
            btn.textContent = original;
            btn.disabled = false;
        }, 1600);

        showCartToast(name, category, price, imagePath, contextPath);

        return fetch(contextPath + '/cart', {
            method: 'GET',
            credentials: 'same-origin'
        });
    })
    .then(function (response) {
        return response.text();
    })
    .then(function (html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var badge = doc.querySelector('.cart-badge');
        var count = badge ? parseInt(badge.textContent) : 0;
        updateNavCartBadge(count);
    })
    .catch(function () {
        btn.textContent = original;
        btn.disabled = false;
    });
}

/* 
   DOM READY — runs on every page
    */
document.addEventListener('DOMContentLoaded', function () {

    // Auto-dismiss server-rendered alert banners after 5s
    document.querySelectorAll('.alert').forEach(function (el) {
        setTimeout(function () {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(function () { if (el.parentNode) el.remove(); }, 500);
        }, 5000);
    });

    // Close modal overlays on backdrop click
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) overlay.style.display = 'none';
        });
    });

    // Active nav link highlight
    var path = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(function (link) {
        var href = link.getAttribute('href');
        if (href && path.indexOf(href.replace(/^.*\//, '')) !== -1) {
            link.classList.add('active');
        }
    });

    // Admin sidebar active highlight
    document.querySelectorAll('.admin-nav-link').forEach(function (link) {
        if (link.href && window.location.href.indexOf(link.href) !== -1) {
            link.classList.add('active');
        }
    });
});

/* Beauty Ritual Loader  */
var SprLoader = {
    _el: document.getElementById('spra-loader'),
    dismiss: function () {
        if (!this._el) return;
        this._el.classList.add('dismissed');
        var el = this._el;
        setTimeout(function () { if (el && el.parentNode) el.remove(); }, 800);
    },
    dismissAfter: function (ms) {
        var self = this;
        setTimeout(function () { self.dismiss(); }, ms);
    }
};
function toggleNav() {
    var links = document.querySelector('.nav-links');
    if (links) links.classList.toggle('open');
}

// Change the close handler to stop propagation
document.addEventListener('click', function(e) {
    var nav = document.querySelector('.nav');
    var links = document.querySelector('.nav-links');
    var hamburger = document.querySelector('.hamburger-btn');
    
    // Don't close if clicking the hamburger button
    if (hamburger && hamburger.contains(e.target)) return;
    
    if (links && nav && !nav.contains(e.target)) {
        links.classList.remove('open');
    }
});