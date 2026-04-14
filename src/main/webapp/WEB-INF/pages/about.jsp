<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    request.setAttribute("pageTitle",  "About Us");
    request.setAttribute("pageCSS",    "about");
    request.setAttribute("activePage", "about");
%>
<%@ include file="header.jsp" %>

<!-- ===== ABOUT HERO ===== -->
<section class="about-hero">
    <div class="ah-text">
        <p class="ah-eyebrow">Since 2020</p>
        <h1 class="ah-title">This is<br><em>Spra</em></h1>
        <p class="ah-sub">Tiny, curious, and destined for the beauty world. By the time we launched, we had a whole vision running — and people noticed.</p>
    </div>
    <div class="ah-photo-grid">
        <div class="ah-photo" style="background:#e8c0c8">&#127800;</div>
        <div class="ah-photo short" style="background:#d8a8b0">&#10024;</div>
        <div class="ah-photo short" style="background:#f0d0d4">&#127807;</div>
        <div class="ah-photo" style="background:#e8b8c0">&#128132;</div>
    </div>
    <div class="ah-scribble">Hi. Since you&apos;re new here,<br>let me be your guide.<br><br>&mdash; The Spra Team</div>
</section>

<!-- ===== STORY SECTION ===== -->
<section class="about-story">
    <div class="as-grid">
        <div class="as-body">
            <h2 class="as-title">It&apos;s not just beauty,<br>it&apos;s vibing with your skin.</h2>
            <p class="as-text">After realizing our products earned more trust with a little aesthetic flair, we hit 10,000 customers — and probably thought we were famous. That&apos;s when it clicked: people are drawn to products that actually work.</p>
            <p class="as-text">We love crafting formulas that reflect intentional living, self-growth, and an eye for aesthetics.</p>
            <div class="as-stats">
                <div class="as-stat"><span class="as-stat-num">10K+</span><span class="as-stat-lbl">Happy customers</span></div>
                <div class="as-stat"><span class="as-stat-num">50+</span><span class="as-stat-lbl">Products</span></div>
                <div class="as-stat"><span class="as-stat-num">100%</span><span class="as-stat-lbl">Natural ingredients</span></div>
                <div class="as-stat"><span class="as-stat-num">5&#9733;</span><span class="as-stat-lbl">Average rating</span></div>
            </div>
        </div>
        <div class="as-image-wrap">&#129511;</div>
    </div>
</section>

<!-- ===== TEAM SECTION ===== -->
<section class="about-team">
    <div class="section-head">
        <h2 class="section-title">Skills &amp; Team</h2>
        <p class="section-sub">The people behind your favourite products</p>
    </div>
    <div class="team-grid">

        <div class="team-card">
            <div class="team-avatar">&#127800;</div>
            <h3 class="team-name">Aria Santos</h3>
            <p class="team-role">Founder &amp; Formulator</p>
            <p class="team-bio">Passionate chemist turned entrepreneur. Creates every formula from scratch with love and science.</p>
            <div class="skill-bars">
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Formulation</span><span>95%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:95%"></div></div>
                </div>
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Branding</span><span>80%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:80%"></div></div>
                </div>
            </div>
        </div>

        <div class="team-card">
            <div class="team-avatar">&#10024;</div>
            <h3 class="team-name">Mei Lin</h3>
            <p class="team-role">Creative Director</p>
            <p class="team-bio">Visual storyteller with 7 years in luxury beauty. Every Spra campaign is her canvas.</p>
            <div class="skill-bars">
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Art Direction</span><span>98%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:98%"></div></div>
                </div>
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Video Editing</span><span>88%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:88%"></div></div>
                </div>
            </div>
        </div>

        <div class="team-card">
            <div class="team-avatar">&#127807;</div>
            <h3 class="team-name">Sofia Reyes</h3>
            <p class="team-role">Social &amp; Growth</p>
            <p class="team-bio">Grew Spra&apos;s community from zero. Connects real people to real skincare results every day.</p>
            <div class="skill-bars">
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Social Media</span><span>92%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:92%"></div></div>
                </div>
                <div class="skill-bar-wrap">
                    <div class="skill-bar-label"><span>Copywriting</span><span>85%</span></div>
                    <div class="skill-bar-track"><div class="skill-bar-fill" style="width:85%"></div></div>
                </div>
            </div>
        </div>
    </div>
    <p class="team-wrap-line">and that&apos;s a wrap.</p>
</section>

<!-- ===== VALUES SECTION ===== -->
<section class="about-values">
    <div class="section-head">
        <h2 class="section-title">What We Stand For</h2>
        <p class="section-sub">Our values shape every product we make</p>
    </div>
    <div class="values-grid">
        <div class="value-card">
            <span class="value-num">01</span>
            <h3 class="value-title">Clean Beauty</h3>
            <p class="value-desc">No harmful chemicals. Ever. Beauty should never come at the cost of your health.</p>
        </div>
        <div class="value-card">
            <span class="value-num">02</span>
            <h3 class="value-title">Sustainability</h3>
            <p class="value-desc">From sourcing to packaging, every decision is made with the planet in mind.</p>
        </div>
        <div class="value-card">
            <span class="value-num">03</span>
            <h3 class="value-title">Inclusivity</h3>
            <p class="value-desc">Beauty is for everyone. Our products are formulated for all skin tones and types.</p>
        </div>
    </div>
</section>

<%@ include file="footer.jsp" %>
