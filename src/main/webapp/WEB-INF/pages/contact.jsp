<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle",  "Contact Us");
    request.setAttribute("pageCSS",    "contact");
    request.setAttribute("activePage", "contact");
%>
<%@ include file="header.jsp" %>

<div class="contact-page">

    <!-- Hero banner -->
    <div class="contact-hero">
        <h1 class="ch-title">Get in <em>Touch</em></h1>
        <p class="ch-sub">We&apos;d love to hear from you &mdash; whether it&apos;s feedback, a question, or a collaboration idea.</p>
    </div>

    <div class="contact-body">

        <!-- Form side -->
        <div class="contact-form-side">
            <h2 class="cf-title">Send us a message</h2>

            <!-- Flash messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <form action="<%= contextPath %>/contact" method="post" class="contact-form" novalidate>

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-input"
                               placeholder="Aria"
                               value="<c:out value='${firstName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-input"
                               placeholder="Santos"
                               value="<c:out value='${lastName}'/>">
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input"
                           placeholder="hello@example.com"
                           value="<c:out value='${email}'/>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="subject">Subject</label>
                    <select id="subject" name="subject" class="form-input">
                        <option value="General Inquiry"   <c:if test='${subject == "General Inquiry"}'>selected</c:if>>General Inquiry</option>
                        <option value="Product Question"  <c:if test='${subject == "Product Question"}'>selected</c:if>>Product Question</option>
                        <option value="Order Support"     <c:if test='${subject == "Order Support"}'>selected</c:if>>Order Support</option>
                        <option value="Collaboration"     <c:if test='${subject == "Collaboration"}'>selected</c:if>>Collaboration</option>
                        <option value="Press and Media"   <c:if test='${subject == "Press and Media"}'>selected</c:if>>Press &amp; Media</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label" for="message">Message</label>
                    <textarea id="message" name="message" class="form-textarea"
                              placeholder="Tell us how we can help you..." required><c:out value="${message}"/></textarea>
                </div>

                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>

        <!-- Info side -->
        <div class="contact-info-side">
            <h2 class="ci-title">Contact Information</h2>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Address</p>
                    <p class="ci-value">123 Beauty Lane, Paris, France</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                        <polyline points="22,6 12,13 2,6"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Email</p>
                    <p class="ci-value">hello@spra.com</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.15 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.06 1.27h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 21 16.92z"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Phone</p>
                    <p class="ci-value">+1 (555) 123-4567</p>
                </div>
            </div>

            <div class="ci-item">
                <div class="ci-icon-wrap">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#e8536a" stroke-width="1.5">
                        <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                    </svg>
                </div>
                <div>
                    <p class="ci-label">Business Hours</p>
                    <p class="ci-value">Mon&ndash;Fri, 9am &ndash; 6pm CET</p>
                </div>
            </div>

            <div class="ci-map">Map &mdash; embed Google Maps iframe here</div>

            <div class="ci-social">
                <p class="ci-label">Follow us</p>
                <div class="social-row">
                    <a href="#" class="social-btn">IG</a>
                    <a href="#" class="social-btn">TK</a>
                    <a href="#" class="social-btn">YT</a>
                    <a href="#" class="social-btn">FB</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>
