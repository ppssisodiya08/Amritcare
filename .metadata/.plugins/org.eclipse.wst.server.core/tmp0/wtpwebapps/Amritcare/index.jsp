<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.HospitalDAO, com.amritcare.dao.BookingDAO, com.amritcare.dao.UserDAO" %>
<%
    HospitalDAO hDao = new HospitalDAO();
    BookingDAO  bDao = new BookingDAO();
    UserDAO     uDao = new UserDAO();
    int totalHospitals = hDao.getTotalHospitals();
    int totalBookings  = bDao.getTotalBookings();
    int totalPatients  = uDao.getTotalPatients();
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AmritCare — Smart Healthcare Management</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand">
    <span class="logo-icon">🏥</span> AmritCare
  </a>
  <ul class="nav-links">
    <li><a href="index.jsp" class="active">Home</a></li>
    <li><a href="HospitalServlet">Hospitals</a></li>
    <li><a href="ambulance.jsp">🚑 Ambulance</a></li>
    <% if (userName != null) { %>
      <% if ("city_admin".equals(userRole)) { %>
        <li><a href="admin_dashboard.jsp">Dashboard</a></li>
      <% } else if ("hospital_admin".equals(userRole)) { %>
        <li><a href="hospital_dashboard.jsp">Dashboard</a></li>
      <% } else { %>
        <li><a href="dashboard.jsp">Dashboard</a></li>
      <% } %>
      <li><a href="LogoutServlet">Logout</a></li>
    <% } else { %>
      <li><a href="login.jsp">Login</a></li>
      <li><a href="register.jsp" class="btn-nav">Register</a></li>
    <% } %>
  </ul>
</nav>

<!-- HERO -->
<section class="hero">
  <h1 class="hero-title">City-Wide Smart<br>Healthcare, Unified</h1>
  <p class="hero-subtitle">Real-time hospital availability, instant bookings, ambulance tracking — all in one platform for Bhopal.</p>
  <div class="hero-actions">
    <a href="HospitalServlet" class="btn btn-white">🏥 Find Hospitals</a>
    <a href="register.jsp"    class="btn btn-white btn-outline" style="border-color:#fff;color:#fff">Get Started Free</a>
    <a href="ambulance.jsp"   class="btn" style="background:var(--warning);color:#1a1a2e">🚑 Track Ambulance</a>
  </div>
</section>

<!-- STATS -->
<section class="section" style="background:#fff; padding: 2.5rem 0;">
  <div class="container">
    <div class="grid-4">
      <div class="stat-card fade-in delay-1">
        <div class="stat-icon blue">🏥</div>
        <div>
          <div class="stat-value" data-target="<%= totalHospitals %>"><%= totalHospitals %></div>
          <div class="stat-label">Partner Hospitals</div>
        </div>
      </div>
      <div class="stat-card fade-in delay-2">
        <div class="stat-icon green">✅</div>
        <div>
          <div class="stat-value" data-target="<%= totalBookings %>"><%= totalBookings %></div>
          <div class="stat-label">Bookings Made</div>
        </div>
      </div>
      <div class="stat-card fade-in delay-3">
        <div class="stat-icon orange">👨‍⚕️</div>
        <div>
          <div class="stat-value" data-target="<%= totalPatients %>"><%= totalPatients %></div>
          <div class="stat-label">Registered Patients</div>
        </div>
      </div>
      <div class="stat-card fade-in">
        <div class="stat-icon red">🚑</div>
        <div>
          <div class="stat-value">5</div>
          <div class="stat-label">Active Ambulances</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- FEATURES -->
<section class="section">
  <div class="container">
    <h2 class="section-title text-center">Why AmritCare?</h2>
    <p class="section-subtitle text-center">Everything a patient needs, at a glance</p>
    <div class="grid-3">
      <div class="card fade-in">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">📊</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Real-Time Availability</h3>
          <p style="color:var(--muted);font-size:0.9rem">See live bed, ICU and doctor availability across all city hospitals before you travel.</p>
        </div>
      </div>
      <div class="card fade-in delay-1">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">📅</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Instant Booking</h3>
          <p style="color:var(--muted);font-size:0.9rem">Book a bed, ICU slot or doctor appointment in under 60 seconds with full confirmation.</p>
        </div>
      </div>
      <div class="card fade-in delay-2">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">🚑</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Ambulance Tracking</h3>
          <p style="color:var(--muted);font-size:0.9rem">Live map tracking of all city ambulances with nearest hospital routing.</p>
        </div>
      </div>
      <div class="card fade-in">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">🎤</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Voice Assistant</h3>
          <p style="color:var(--muted);font-size:0.9rem">Use voice commands like "book bed" or "show hospitals" to navigate hands-free.</p>
        </div>
      </div>
      <div class="card fade-in delay-1">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">🔐</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Role-Based Access</h3>
          <p style="color:var(--muted);font-size:0.9rem">Separate dashboards for patients, hospital admins and city authorities.</p>
        </div>
      </div>
      <div class="card fade-in delay-2">
        <div class="card-body" style="text-align:center; padding:2.5rem 1.5rem;">
          <div style="font-size:3rem;margin-bottom:1rem">📈</div>
          <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.75rem">Analytics & Reports</h3>
          <p style="color:var(--muted);font-size:0.9rem">City admins get full analytics on utilization, bookings and resource distribution.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- CTA -->
<section style="background:linear-gradient(135deg,var(--primary-dark),var(--primary));color:#fff;padding:4rem 2rem;text-align:center;">
  <h2 style="font-family:'Playfair Display',serif;font-size:2rem;margin-bottom:1rem">Ready to experience smarter healthcare?</h2>
  <p style="opacity:0.85;margin-bottom:2rem;max-width:500px;margin-left:auto;margin-right:auto">Join thousands of patients and hospitals already using AmritCare.</p>
  <a href="register.jsp" class="btn btn-white btn-lg">Create Free Account →</a>
</section>

<!-- FOOTER -->
<footer>
  <p>© 2026 AmritCare — Intelligent City-Wide Healthcare System | Bhopal, Madhya Pradesh</p>
  <p style="margin-top:0.5rem"><a href="index.jsp">Home</a> · <a href="HospitalServlet">Hospitals</a> · <a href="ambulance.jsp">Ambulance</a> · <a href="login.jsp">Login</a></p>
</footer>

<!-- VOICE ASSISTANT -->
<button class="voice-btn" id="voiceBtn" title="Voice Assistant">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>

<script src="js/main.js"></script>
</body>
</html>
