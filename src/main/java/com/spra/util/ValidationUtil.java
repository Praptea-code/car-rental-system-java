package com.spra.util;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class ValidationUtil {

    private ValidationUtil() {}

    public static boolean isValidName(String name) {
        return name != null && !name.trim().isEmpty() && name.trim().matches("[A-Za-z\\s]+");
    }

    public static boolean isValidUsername(String username) {
        return username != null && username.length() > 6 && username.matches("[A-Za-z0-9]+");
    }

    public static boolean isValidEmail(String email) {
        return email != null && !email.trim().isEmpty()
                && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.startsWith("+") && phone.length() == 14;
    }

    public static boolean isValidPassword(String password) {
        if (password == null || password.length() <= 6) {
            return false;
        }
        boolean hasUpper   = password.matches(".*[A-Z].*");
        boolean hasDigit   = password.matches(".*[0-9].*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\\\"\\\\|,.<>/?].*");
        return hasUpper && hasDigit && hasSpecial;
    }

    public static boolean isValidBirthdate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return false;
        }
        try {
            LocalDate birth = LocalDate.parse(dateStr);
            return !birth.isAfter(LocalDate.now());
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static String safeTrim(String value) {
        return (value == null) ? "" : value.trim();
    }
}
