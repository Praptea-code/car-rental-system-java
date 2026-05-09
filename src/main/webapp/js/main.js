

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
   - name        : product name string
   - category    : category name string (can be empty)
   - price       : number e.g. 2499
   - imagePath   : filename only e.g. "rose-serum.jpg" (can be empty)
   - contextPath : the servlet context path e.g. "/spra"
   ============================================================ */
var _ctpDismissTimer = null;

function showCartToast(name, category, price, imagePath, contextPath) {
    /* remove any existing toast first */
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
   Call this after an AJAX add-to-cart to refresh the
   pink number badge on the cart icon WITHOUT reloading.
   ============================================================ */
function updateNavCartBadge(contextPath) {
    fetch(contextPath + '/cart', { method: 'GET', redirect: 'follow' })
    .then(function (r) { return r.text(); })
    .then(function (html) {
        var parser = new DOMParser();
        var doc    = parser.parseFromString(html, 'text/html');
        var fresh  = doc.querySelector('.cart-badge');

        /* remove all existing badges on this page */
        document.querySelectorAll('.cart-badge').forEach(function (b) { b.remove(); });

        /* if the cart now has items, add the badge to every cart icon */
        if (fresh) {
            document.querySelectorAll('.cart-icon-btn').forEach(function (iconBtn) {
                iconBtn.appendChild(fresh.cloneNode(true));
            });
        }
    })
    .catch(function () { /* silently ignore network errors */ });
}

/* ============================================================
   AJAX ADD TO CART  (used on home.jsp featured products)
   onclick="addToCart(this, productId, name, category, price, imagePath, contextPath)"
   ============================================================ */
function addToCart(btn, productId, name, category, price, imagePath, contextPath) {
    btn.disabled = true;
    var original = btn.textContent;
    btn.textContent = 'Adding…';

    var fd = new FormData();
    fd.append('productId', productId);
    fd.append('qty', 1);

    fetch(contextPath + '/cart/add', { method: 'POST', body: fd, redirect: 'manual' })
    .then(function () {
        /* restore button after short delay */
        btn.textContent = '✓ Added!';
        setTimeout(function () {
            btn.textContent = original;
            btn.disabled = false;
        }, 1600);

        /* show the proper popup toast */
        showCartToast(name, category, price, imagePath, contextPath);

        /* refresh the nav badge number */
        updateNavCartBadge(contextPath);
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

    /* auto-dismiss server-rendered alert banners after 5 s */
    document.querySelectorAll('.alert').forEach(function (el) {
        setTimeout(function () {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(function () { if (el.parentNode) el.remove(); }, 500);
        }, 5000);
    });

    /* close modal overlays when clicking the backdrop */
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) overlay.style.display = 'none';
        });
    });

    /* active nav link highlight (fallback for pages without controller-set activePage) */
    var path = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(function (link) {
        var href = link.getAttribute('href');
        if (href && path.indexOf(href.replace(/^.*\//, '')) !== -1) {
            link.classList.add('active');
        }
    });

    /* admin sidebar active highlight */
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