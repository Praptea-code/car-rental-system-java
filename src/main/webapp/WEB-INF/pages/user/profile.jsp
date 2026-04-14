<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle",  "My Profile");
    request.setAttribute("pageCSS",    "profile");
    request.setAttribute("activePage", "");
    com.spra.model.UserModel currentUser =
        (com.spra.model.UserModel) session.getAttribute("loggedInUser");
    request.setAttribute("currentUser", currentUser);
%>
<%@ include file="../header.jsp" %>

<div class="profile-page">

    <!-- Profile header banner -->
    <div class="profile-banner">
        <div class="profile-avatar">${currentUser.firstName.charAt(0)}${currentUser.lastName.charAt(0)}</div>
        <div class="profile-banner-info">
            <h1 class="profile-name">${currentUser.fullName}</h1>
            <p class="profile-role">${currentUser.role}</p>
            <p class="profile-since">Member since ${currentUser.createdAt}</p>
        </div>
    </div>

    <!-- Flash messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-error">${errorMessage}</div>
    </c:if>

    <div class="profile-body">

        <!-- Update profile form -->
        <div class="profile-card">
            <h2 class="profile-card-title">Update Profile</h2>
            <form action="<%= contextPath %>/user/profile" method="post" class="profile-form">
                <input type="hidden" name="action" value="updateProfile">

                <div class="form-row-2">
                    <div class="form-group">
                        <label class="form-label" for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" class="form-input"
                               value="<c:out value='${currentUser.firstName}'/>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" class="form-input"
                               value="<c:out value='${currentUser.lastName}'/>" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-input"
                           value="<c:out value='${currentUser.email}'/>" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" class="form-input"
                           value="<c:out value='${currentUser.phone}'/>">
                </div>

                <button type="submit" class="profile-save-btn">Save Changes</button>
            </form>
        </div>

        <!-- Change password form -->
        <div class="profile-card">
            <h2 class="profile-card-title">Change Password</h2>
            <form action="<%= contextPath %>/user/profile" method="post" class="profile-form">
                <input type="hidden" name="action" value="changePassword">

                <div class="form-group">
                    <label class="form-label" for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-input"
                           placeholder="Enter current password" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-input"
                           placeholder="Min 7 chars, uppercase, digit, special char" required>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input"
                           placeholder="Re-enter new password" required>
                </div>

                <button type="submit" class="profile-save-btn">Update Password</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
