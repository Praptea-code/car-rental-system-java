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

/* ============================================================
   CART TOAST POPUP
   showCartToast(name, category, price, imagePath, contextPath)
   ============================================================ */
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
   UPDATE NAV CART BADGE
   ============================================================ */
function updateNavCartBadge(count) {
    // Remove all existing badges
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

/* ============================================================
   AJAX ADD TO CART  (used on home.jsp featured products)
   THE FIX: use a hidden form submit instead of fetch so the
   browser handles the session cookie and redirect properly.
   We intercept the form, use fetch correctly, then update UI.
   ============================================================ */
function addToCart(btn, productId, name, category, price, imagePath, contextPath) {
    btn.disabled = true;
    var original = btn.textContent;
    btn.textContent = 'Adding…';

    var fd = new FormData();
    fd.append('productId', productId);
    fd.append('qty', 1);

    // KEY FIX: removed redirect:'manual' — let fetch follow the redirect
    // naturally so the session cookie is handled correctly by the browser.
    fetch(contextPath + '/cart/add', {
        method: 'POST',
        body: fd,
        credentials: 'same-origin'   // explicitly send session cookie
    })
    .then(function (response) {
        // response.ok will be true after following the redirect to home/cart
        btn.textContent = '✓ Added!';
        setTimeout(function () {
            btn.textContent = original;
            btn.disabled = false;
        }, 1600);

        // Show the toast popup
        showCartToast(name, category, price, imagePath, contextPath);

        // Fetch current cart count from server and update badge
        return fetch(contextPath + '/cart', {
            method: 'GET',
            credentials: 'same-origin'
        });
    })
    .then(function (response) {
        return response.text();
    })
    .then(function (html) {
        // Parse the returned cart page and extract the badge count
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

/* ============================================================
   DOM READY — runs on every page
   ============================================================ */
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

/* ---- Beauty Ritual Loader ---- */
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
document.addEventListener('DOMContentLoaded', function () { SprLoader.dismissAfter(2800); });