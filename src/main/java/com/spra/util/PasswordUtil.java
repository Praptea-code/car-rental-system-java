package com.spra.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * PasswordUtil
 * Secure password hashing and verification using SHA-256 + random salt.
 * Stored format: "BASE64(salt):BASE64(hash)"
 *
 * @author Spra Team
 */
public class PasswordUtil {

    private PasswordUtil() {}

    /**
     * Hashes a plain-text password with a random 16-byte salt.
     *
     * @param plainPassword raw password from the user
     * @return hashed value ready to store in the database
     */
    public static String hashPassword(String plainPassword) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);

            // SHA-256(salt + password)
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hash = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));

            return Base64.getEncoder().encodeToString(salt) + ":"
                 + Base64.getEncoder().encodeToString(hash);

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored hash.
     *
     * @param plainPassword user-supplied password to check
     * @param storedHash    value from the database
     * @return true if the password matches
     */
    public static boolean verifyPassword(String plainPassword, String storedHash) {
        if (plainPassword == null || storedHash == null) return false;

        String[] parts = storedHash.split(":");
        if (parts.length != 2) return false;

        try {
            byte[] salt   = Base64.getDecoder().decode(parts[0]);
            byte[] stored = Base64.getDecoder().decode(parts[1]);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] computed = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));

            // Constant-time comparison to prevent timing attacks
            if (computed.length != stored.length) return false;
            int diff = 0;
            for (int i = 0; i < computed.length; i++) {
                diff |= computed[i] ^ stored[i];
            }
            return diff == 0;

        } catch (NoSuchAlgorithmException | IllegalArgumentException e) {
            return false;
        }
    }
}
