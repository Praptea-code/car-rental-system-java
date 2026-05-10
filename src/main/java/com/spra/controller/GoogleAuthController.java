package com.spra.controller;

import com.spra.dao.UserDAO;
import com.spra.config.EnvConfig;

import com.spra.model.UserModel;
import com.spra.util.CookieUtil;
import com.spra.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import org.json.JSONObject;   // <-- needs json-20240303.jar in WEB-INF/lib

/**
 * @author Spra Team
 */
@WebServlet(urlPatterns = {"/auth/google", "/auth/google/callback"}, asyncSupported = true)
public class GoogleAuthController extends HttpServlet {

    
	private static final String GOOGLE_CLIENT_ID     = EnvConfig.get("GOOGLE_CLIENT_ID");
	private static final String GOOGLE_CLIENT_SECRET = EnvConfig.get("GOOGLE_CLIENT_SECRET");
	private static final String REDIRECT_URI         = "http://localhost:8080/spra/auth/google/callback";
   
    private static final String AUTH_URL  = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    private static final String USER_URL  = "https://www.googleapis.com/oauth2/v3/userinfo";

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/auth/google")) {
            startOAuthFlow(req, res);
        } else if (uri.endsWith("/auth/google/callback")) {
            handleCallback(req, res);
        }
    }

    //Step 1: Redirect to Google 
    private void startOAuthFlow(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        // CSRF protection: generate a random state token
        String state = UUID.randomUUID().toString();
        req.getSession(true).setAttribute("oauth_state", state);

        String authUrl = AUTH_URL
            + "?client_id="     + encode(GOOGLE_CLIENT_ID)
            + "&redirect_uri="  + encode(REDIRECT_URI)
            + "&response_type=code"
            + "&scope="         + encode("openid email profile")
            + "&state="         + encode(state)
            + "&access_type=online"
            + "&prompt=select_account";   // always show account picker

        res.sendRedirect(authUrl);
    }

    //Step 2: Google redirects back here 
    private void handleCallback(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String code  = req.getParameter("code");
        String state = req.getParameter("state");
        String error = req.getParameter("error");

        // User denied access
        if (error != null) {
            req.getSession(true).setAttribute("errorMessage", "Google sign-in was cancelled.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Validate CSRF state
        HttpSession session  = req.getSession(false);
        String savedState    = (session != null) ? (String) session.getAttribute("oauth_state") : null;
        if (savedState == null || !savedState.equals(state)) {
            req.getSession(true).setAttribute("errorMessage", "Invalid OAuth state. Please try again.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        session.removeAttribute("oauth_state");

        // Exchange code for access token
        String accessToken = exchangeCodeForToken(code);
        if (accessToken == null) {
            req.getSession(true).setAttribute("errorMessage", "Google authentication failed. Please try again.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Fetch user info from Google
        JSONObject googleUser = fetchUserInfo(accessToken);
        if (googleUser == null) {
            req.getSession(true).setAttribute("errorMessage", "Could not retrieve Google profile. Please try again.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String googleId  = googleUser.optString("sub");
        String email     = googleUser.optString("email");
        String firstName = googleUser.optString("given_name", "User");
        String lastName  = googleUser.optString("family_name", "");

        //Find or create user

        // 1. Look up by google_id first
        UserModel user = userDAO.getUserByGoogleId(googleId);

        if (user == null) {
            // 2. Maybe they registered with email+password — link accounts
            user = userDAO.getUserByEmail(email);
            if (user != null) {
                userDAO.linkGoogleId(user.getUserId(), googleId);
                // Reload to get fresh data
                user = userDAO.getUserByGoogleId(googleId);
            }
        }

        if (user == null) {
            // 3. Brand new user — register them
            UserModel newUser = new UserModel();
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setGoogleId(googleId);
            newUser.setUsername(generateUsername(firstName, lastName, email));
            newUser.setRole("USER");
            newUser.setActive(true);

            int newId = userDAO.registerGoogleUser(newUser);
            if (newId < 0) {
                req.getSession(true).setAttribute("errorMessage",
                    "Account creation failed. Please try again or register manually.");
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            user = userDAO.getUserByGoogleId(googleId);
        }

        // Check account is active
        if (user == null || !user.isActive()) {
            req.getSession(true).setAttribute("errorMessage", "Your account has been deactivated.");
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        //Log in the user
        SessionUtil.loginUser(req, user);
        req.getSession().setAttribute("showLoader", true);
        CookieUtil.addCookie(res, "spra_user", user.getUsername(), 604800);

        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/home");
        }
    }

    // OAuth helpers

    /** POSTs the authorisation code to Google and returns the access token. */
    private String exchangeCodeForToken(String code) {
        try {
            String params = "code="          + encode(code)
                          + "&client_id="    + encode(GOOGLE_CLIENT_ID)
                          + "&client_secret="+ encode(GOOGLE_CLIENT_SECRET)
                          + "&redirect_uri=" + encode(REDIRECT_URI)
                          + "&grant_type=authorization_code";

            URL url = new URL(TOKEN_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

            try (OutputStream os = conn.getOutputStream()) {
                os.write(params.getBytes(StandardCharsets.UTF_8));
            }

            String response = readResponse(conn);
            JSONObject json = new JSONObject(response);
            return json.optString("access_token", null);

        } catch (Exception e) {
            System.err.println("[GoogleAuthController.exchangeCodeForToken] " + e.getMessage());
            return null;
        }
    }

    /** GETs the user's profile info from Google using the access token. */
    private JSONObject fetchUserInfo(String accessToken) {
        try {
            URL url = new URL(USER_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);

            String response = readResponse(conn);
            return new JSONObject(response);

        } catch (Exception e) {
            System.err.println("[GoogleAuthController.fetchUserInfo] " + e.getMessage());
            return null;
        }
    }

    private String readResponse(HttpURLConnection conn) throws IOException {
        int code = conn.getResponseCode();
        InputStream is = (code >= 400) ? conn.getErrorStream() : conn.getInputStream();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
            return sb.toString();
        }
    }

    private String encode(String value) throws UnsupportedEncodingException {
        return URLEncoder.encode(value, "UTF-8");
    }

    /**
     * Generates a unique username from the Google profile.
     * e.g. "john.doe" → if taken → "john.doe2" etc.
     */
    private String generateUsername(String firstName, String lastName, String email) {
        // Base: first part of email before @
        String base = email.contains("@") ? email.split("@")[0] : firstName.toLowerCase();
        // Remove non-alphanumeric chars
        base = base.replaceAll("[^A-Za-z0-9]", "").toLowerCase();
        if (base.length() < 7) base = base + "user";

        String candidate = base;
        int suffix = 2;
        while (userDAO.usernameExists(candidate)) {
            candidate = base + suffix++;
        }
        return candidate;
    }
}