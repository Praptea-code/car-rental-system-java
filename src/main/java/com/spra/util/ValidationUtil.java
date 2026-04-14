package com.spra.util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * ValidationUtil
 * Reusable input validation methods for all Spra controllers and services.
 * Rules match the Week 3 lab specification exactly.
 *
 * @author Spra Team
 */
public class ValidationUtil {

    private ValidationUtil() {}

    /**
     * Name must contain only letters and spaces (no numbers or special chars).
     */
    public static boolean isValidName(String name) {
        if (name == null || name.trim().isEmpty()) return false;
        return name.trim().matches("[A-Za-z\\s]+");
    }

    /**
     * Username: more than 6 characters, letters and digits only.
     */
    public static boolean isValidUsername(String username) {
        if (username == null) return false;
        return username.length() > 6 && username.matches("[A-Za-z0-9]+");
    }

    /**
     * Standard email format check.
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    /**
     * Phone: must start with '+' and be exactly 14 characters.
     * Example valid: +97798123456789
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        return phone.startsWith("+") && phone.length() == 14;
    }

    /**
     * Password complexity:
     *   - Longer than 6 characters
     *   - At least one uppercase letter
     *   - At least one digit
     *   - At least one special character
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() <= 6) return false;
        boolean hasUpper   = password.matches(".*[A-Z].*");
        boolean hasDigit   = password.matches(".*[0-9].*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*");
        return hasUpper && hasDigit && hasSpecial;
    }

    /**
     * Birthdate must not be in the future. Expected format: yyyy-MM-dd.
     */
    public static boolean isValidBirthdate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return false;
        try {
            LocalDate birth = LocalDate.parse(dateStr);
            return !birth.isAfter(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    /**
     * Non-empty string check (null-safe).
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Returns trimmed string, never null.
     */
    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
