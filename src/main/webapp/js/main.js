/* ============================================================
   main.js — Spra Global JavaScript
   Used by all pages. No frameworks, pure vanilla JS.
   ============================================================ */

/**
 * Toggles a password field between visible and hidden.
 * Called from inline onclick on the Show/Hide button.
 *
 * @param {string} fieldId  - id of the <input type="password"> element
 * @param {HTMLElement} btn - the toggle button element
 */
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

/**
 * Auto-dismiss alert messages after 5 seconds.
 */
document.addEventListener('DOMContentLoaded', function () {
	
	

    // Auto-hide alerts
    var alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity .5s';
            alert.style.opacity = '0';
            setTimeout(function () { alert.remove(); }, 500);
        }, 5000);
    });

    // Close modal when clicking outside modal box
    document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) {
                overlay.style.display = 'none';  
            }
        });
    });

    // Active nav link highlight (for pages without controller-set activePage)
    var currentPath = window.location.pathname;
    document.querySelectorAll('.nav-links a').forEach(function (link) {
        if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href').replace(/^.*\//, ''))) {
            link.classList.add('active');
        }
    });

    // Admin sidebar active link highlight
    document.querySelectorAll('.admin-nav-link').forEach(function (link) {
        if (link.href && window.location.href.indexOf(link.href) !== -1) {
            link.classList.add('active');
        }
    });
	
	

});
// ---- Beauty Ritual Loader ----
	const SprLoader = {
	  _el: document.getElementById('spra-loader'),
	  dismiss() {
	    if (!this._el) return;
	    this._el.classList.add('dismissed');
	    setTimeout(() => { if (this._el) this._el.remove(); }, 800);
	  },
	  dismissAfter(ms) { setTimeout(() => this.dismiss(), ms); }
	};

	// Dismiss after 2.8s, or replace with SprLoader.dismiss() inside window.onload
	// if you want it to wait for your hero video/images to fully load first
	document.addEventListener('DOMContentLoaded', () => SprLoader.dismissAfter(2800));
