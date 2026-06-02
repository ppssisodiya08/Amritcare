<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.List" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"city_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    HospitalDAO hDao = new HospitalDAO();
    BookingDAO  bDao = new BookingDAO();
    UserDAO     uDao = new UserDAO();

    List<Hospital> hospitals = hDao.getAllHospitals();
    List<Booking>  bookings  = bDao.getAllBookings();

    int totalHospitals = hDao.getTotalHospitals();
    int totalBookings  = bDao.getTotalBookings();
    int totalPatients  = uDao.getTotalPatients();

    int totalAvailBeds  = hospitals.stream().mapToInt(Hospital::getAvailableBeds).sum();
    int totalAvailIcu   = hospitals.stream().mapToInt(Hospital::getAvailableIcu).sum();
    int totalAvailDocs  = hospitals.stream().mapToInt(Hospital::getAvailableDoctors).sum();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>City Admin Dashboard — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="admin_dashboard.jsp" class="active">Dashboard</a></li>
    <li><a href="manage_hospitals.jsp">Hospitals</a></li>
    <li><a href="reports.jsp">Reports</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">

  <aside class="sidebar">
    <div class="sidebar-user">
      <div class="avatar">A</div>
      <div class="user-name">City Administrator</div>
      <div class="user-role">Super Admin</div>
    </div>
    <ul class="sidebar-nav">
      <li><a href="admin_dashboard.jsp" class="active"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_hospitals.jsp"><span class="nav-icon">🏥</span> Manage Hospitals</a></li>
      <li><a href="reports.jsp"><span class="nav-icon">📈</span> Reports</a></li>
      <li><a href="ambulance.jsp"><span class="nav-icon">🚑</span> Ambulance</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">

    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;flex-wrap:wrap;gap:1rem">
      <div>
        <h1 style="font-family:'Playfair Display',serif;font-size:1.8rem">🌆 City Health Overview</h1>
        <p style="color:var(--muted)">Real-time resource status across Bhopal</p>
      </div>
      <a href="manage_hospitals.jsp" class="btn btn-primary">+ Add Hospital</a>
    </div>

    <!-- KPI Row -->
    <div class="grid-4" style="margin-bottom:2rem">
      <div class="stat-card">
        <div class="stat-icon blue">🏥</div>
        <div><div class="stat-value"><%= totalHospitals %></div><div class="stat-label">Active Hospitals</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">👥</div>
        <div><div class="stat-value"><%= totalPatients %></div><div class="stat-label">Registered Patients</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon orange">📅</div>
        <div><div class="stat-value"><%= totalBookings %></div><div class="stat-label">Total Bookings</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon red">🚑</div>
        <div><div class="stat-value">5</div><div class="stat-label">Ambulances</div></div>
      </div>
    </div>

    <!-- Resource Summary -->
    <div class="grid-3" style="margin-bottom:2rem">
      <div class="stat-card">
        <div class="stat-icon green">🛏</div>
        <div><div class="stat-value"><%= totalAvailBeds %></div><div class="stat-label">Available Beds (City)</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon blue">🏥</div>
        <div><div class="stat-value"><%= totalAvailIcu %></div><div class="stat-label">Available ICU (City)</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">👨‍⚕️</div>
        <div><div class="stat-value"><%= totalAvailDocs %></div><div class="stat-label">Available Doctors</div></div>
      </div>
    </div>

    <!-- Hospital Overview Table -->
    <div class="table-wrapper mb-3" style="margin-bottom:1.5rem">
      <div class="card-header">
        <strong>🏥 Hospital Status</strong>
        <a href="manage_hospitals.jsp" class="btn btn-primary btn-sm">Manage</a>
      </div>
      <table>
        <thead>
          <tr><th>Hospital</th><th>Location</th><th>Beds Available</th><th>ICU Available</th><th>Doctors</th><th>Rating</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% for (Hospital h : hospitals) { %>
          <tr>
            <td><strong><%= h.getName() %></strong></td>
            <td style="font-size:0.85rem"><%= h.getLocation() %></td>
            <td>
              <span style="color:<%= h.getAvailableBeds()>5?"var(--success)":h.getAvailableBeds()>0?"var(--warning)":"var(--danger)" %>;font-weight:700">
                <%= h.getAvailableBeds() %>
              </span>
            </td>
            <td>
              <span style="color:<%= h.getAvailableIcu()>2?"var(--success)":h.getAvailableIcu()>0?"var(--warning)":"var(--danger)" %>;font-weight:700">
                <%= h.getAvailableIcu() %>
              </span>
            </td>
            <td><%= h.getAvailableDoctors() %></td>
            <td>⭐ <%= h.getRating() %></td>
            <td><span class="badge badge-success">ACTIVE</span></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <!-- Recent Bookings -->
    <div class="table-wrapper">
      <div class="card-header">
        <strong>📋 Recent Bookings</strong>
        <a href="reports.jsp" class="btn btn-outline btn-sm">View All</a>
      </div>
      <table>
        <thead>
          <tr><th>#</th><th>Patient</th><th>Hospital</th><th>Type</th><th>Date</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% List<Booking> recent = bookings.subList(0, Math.min(10, bookings.size())); %>
          <% for (Booking b : recent) {
               String bc = "badge-secondary";
               if ("confirmed".equals(b.getStatus())) bc="badge-success";
               else if ("pending".equals(b.getStatus())) bc="badge-warning";
               else if ("cancelled".equals(b.getStatus())) bc="badge-danger";
          %>
          <tr>
            <td>#<%= b.getBookingId() %></td>
            <td><%= b.getPatientName() %></td>
            <td><%= b.getHospitalName() %></td>
            <td><%= b.getBookingType() %></td>
            <td><%= b.getBookingDate() %></td>
            <td><span class="badge <%= bc %>"><%= b.getStatus().toUpperCase() %></span></td>
          </tr>
          <% } %>
          <% if (bookings.isEmpty()) { %>
          <tr><td colspan="6" style="text-align:center;color:var(--muted);padding:2rem">No bookings yet</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </main>
</div>

<button class="voice-btn" id="voiceBtn">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>
<script src="js/main.js"></script>
</body>
</html>
