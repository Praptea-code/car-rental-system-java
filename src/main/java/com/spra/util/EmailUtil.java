package com.spra.util;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * EmailUtil
 * Sends emails via Gmail SMTP (TLS on port 587).
 *
 * ── SETUP ──────────────────────────────────────────────────
 * 1. Go to https://myaccount.google.com/security
 * 2. Enable 2-Step Verification (required for App Passwords)
 * 3. Go to https://myaccount.google.com/apppasswords
 * 4. Create an App Password → App: "Mail", Device: "Other" → name it "Spra"
 * 5. Copy the 16-character password (e.g. "abcd efgh ijkl mnop")
 * 6. Paste it (without spaces) into GMAIL_APP_PASSWORD below
 * 7. Replace GMAIL_ADDRESS with your Gmail address
 * ──────────────────────────────────────────────────────────
 *
 * NOTE: Add these two JARs to WEB-INF/lib (download from Maven Central):
 *   - jakarta.mail-2.0.1.jar  (or jakarta.mail-api + angus-mail)
 *   - activation-2.0.1.jar
 *
 * @author Spra Team
 */
public class EmailUtil {

    // ── CONFIGURE THESE TWO LINES ──────────────────────────
    private static final String GMAIL_ADDRESS      = "bhattarai.prapti00@gmail.com";   
    private static final String GMAIL_APP_PASSWORD = "eqzvgpisstthrsya";        
    // ──────────────────────────────────────────────────────

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int    SMTP_PORT = 587;

    private EmailUtil() {}

    /**
     * Sends a plain-text + HTML email.
     *
     * @param toEmail   recipient email address
     * @param subject   email subject
     * @param htmlBody  HTML content of the email
     * @throws MessagingException if sending fails
     */
    public static void sendHtml(String toEmail, String subject, String htmlBody)
            throws MessagingException {

        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust",       SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(GMAIL_ADDRESS, GMAIL_APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(GMAIL_ADDRESS, "Spra Beauty", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        Transport.send(message);
    }

    /**
     * Builds and sends a password-reset email.
     *
     * @param toEmail    recipient
     * @param firstName  used for personalisation
     * @param resetLink  full reset URL e.g. http://localhost:8080/spra/reset-password?token=abc123
     */
    public static void sendPasswordResetEmail(String toEmail, String firstName, String resetLink)
            throws MessagingException {

        String subject = "Reset your Spra password";

        String html = "<!DOCTYPE html><html><body style='margin:0;padding:0;background:#fff8f8;font-family:Arial,sans-serif;'>"
            + "<table width='100%' cellpadding='0' cellspacing='0'><tr><td align='center' style='padding:40px 20px;'>"
            + "<table width='520' cellpadding='0' cellspacing='0' style='background:#fff;border-radius:16px;"
            + "border:1px solid #f0e0e0;overflow:hidden;'>"

            // Header
            + "<tr><td style='background:#2a1215;padding:28px 32px;text-align:center;'>"
            + "<span style='font-family:Georgia,serif;font-size:28px;font-weight:600;"
            + "color:#f5c8d0;letter-spacing:4px;'>SPR<span style='color:#e8536a;'>A</span></span>"
            + "</td></tr>"

            // Body
            + "<tr><td style='padding:36px 32px;'>"
            + "<p style='font-size:16px;color:#1a1a1a;margin:0 0 12px;'>Hi <strong>" + firstName + "</strong>,</p>"
            + "<p style='font-size:14px;color:#555;line-height:1.7;margin:0 0 24px;'>"
            + "We received a request to reset the password for your Spra account. "
            + "Click the button below to choose a new password. "
            + "This link is valid for <strong>30 minutes</strong>.</p>"

            + "<div style='text-align:center;margin:28px 0;'>"
            + "<a href='" + resetLink + "' style='display:inline-block;background:#e8536a;color:#fff;"
            + "text-decoration:none;padding:14px 36px;border-radius:30px;font-size:15px;"
            + "font-weight:600;letter-spacing:.5px;'>Reset My Password</a></div>"

            + "<p style='font-size:12px;color:#aaa;line-height:1.6;margin:0 0 8px;'>"
            + "Or copy and paste this link into your browser:</p>"
            + "<p style='font-size:11px;color:#e8536a;word-break:break-all;margin:0 0 24px;'>"
            + resetLink + "</p>"

            + "<p style='font-size:12px;color:#aaa;'>"
            + "If you did not request a password reset, you can safely ignore this email.</p>"
            + "</td></tr>"

            // Footer
            + "<tr><td style='background:#fdf8f8;border-top:1px solid #f0e0e0;"
            + "padding:16px 32px;text-align:center;'>"
            + "<p style='font-size:11px;color:#bbb;margin:0;'>© 2025 Spra Beauty. All rights reserved.</p>"
            + "</td></tr>"

            + "</table></td></tr></table></body></html>";

        sendHtml(toEmail, subject, html);
    }
}