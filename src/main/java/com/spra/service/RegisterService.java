package com.spra.service;

import com.spra.dao.UserDAO;
import com.spra.model.UserModel;
import com.spra.util.PasswordUtil;
import com.spra.util.ValidationUtil;

/**
 * RegisterService
 * Encapsulates all business logic for user registration.
 * Performs validation, duplicate checks, password hashing, and DB insert.
 *
 * @author Spra Team
 */
public class RegisterService {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Validates all registration fields. Returns an error message string
     * if validation fails, or null if all checks pass.
     *
     * @param firstName   user's first name
     * @param lastName    user's last name
     * @param username    chosen username
     * @param email       email address
     * @param phone       phone number (must start with '+', 14 chars)
     * @param birthdate   date string yyyy-MM-dd
     * @param password    plain-text password
     * @param retypePass  re-entered password
     * @return error message, or null if valid
     */
    public String validate(String firstName, String lastName, String username,
                           String email, String phone, String birthdate,
                           String password, String retypePass) {

        if (!ValidationUtil.isValidName(firstName))
            return "First name must contain only letters and spaces.";

        if (!ValidationUtil.isValidName(lastName))
            return "Last name must contain only letters and spaces.";

        if (!ValidationUtil.isValidUsername(username))
            return "Username must be more than 6 characters and contain only letters/digits.";

        if (!ValidationUtil.isValidEmail(email))
            return "Please enter a valid email address.";

        if (!ValidationUtil.isValidPhone(phone))
            return "Phone must start with '+' and be exactly 14 characters.";

        if (!ValidationUtil.isValidBirthdate(birthdate))
            return "Birthdate cannot be in the future.";

        if (!ValidationUtil.isValidPassword(password))
            return "Password must be more than 6 characters and include at least one uppercase letter, one digit, and one special character.";

        if (!password.equals(retypePass))
            return "Passwords do not match.";

        // Duplicate checks against the database
        if (userDAO.usernameExists(username))
            return "Username already exists. Please choose a different one.";

        if (userDAO.emailExists(email))
            return "An account with this email already exists.";

        if (userDAO.phoneExists(phone))
            return "An account with this phone number already exists.";

        return null; // all validations passed
    }

    /**
     * Registers a new user after validation passes.
     * Hashes the password before saving to the database.
     *
     * @param firstName   user's first name
     * @param lastName    user's last name
     * @param username    chosen username
     * @param email       email address
     * @param phone       phone number
     * @param birthdate   date string yyyy-MM-dd
     * @param password    plain-text password (will be hashed)
     * @return true if registration succeeded
     */
    public boolean registerUser(String firstName, String lastName, String username,
                                String email, String phone, String birthdate,
                                String password) {
        UserModel user = new UserModel();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setBirthdate(birthdate);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("USER");
        user.setActive(true);

        return userDAO.registerUser(user);
    }
}
