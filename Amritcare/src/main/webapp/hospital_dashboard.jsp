<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.List" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"hospital_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    int hospitalId = user.getHospitalId();
    HospitalDAO hDao = new HospitalDAO();
    DoctorDAO   dDao = new DoctorDAO();
    BookingDAO  bDao = new BookingDAO();

    Hospital hospital = hDao.getHospitalById(hospitalId);
    List<Doctor>  doctors  = dDao.getDoctorsByHospital(hospitalId);
    List<Booking> bookings = bDao.getBookingsByHospital(hospitalId);

    long pendingCount = bookings.stream().filter(b->"pending".equals(b.getStatus())).count();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hospital Dashboard — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="hospital_dashboard.jsp" class="active">Dashboard</a></li>
    <li><a href="manage_resources.jsp">Resources</a></li>
    <li><a href="manage_doctors.jsp">Doctors</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">

  <!-- Sidebar -->
  <aside class="sidebar">
    <div class="sidebar-user">
      <div class="avatar">H</div>
      <div class="user-name"><%= hospital!=null?hospital.getName():"Hospital" %></div>
      <div class="user-role">Hospital Admin</div>
    </div>
    <ul class="sidebar-nav">
      <li><a href="hospital_dashboard.jsp" class="active"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_resources.jsp"><span class="nav-icon">🛏</span> Manage Resources</a></li>
      <li><a href="manage_doctors.jsp"><span class="nav-icon">👨‍⚕️</span> Manage Doctors</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">

    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;flex-wrap:wrap;gap:1rem">
      <div>
        <h1 style="font-family:'Playfair Display',serif;font-size:1.8rem">
          🏥 <%= hospital!=null?hospital.getName():"Hospital Dashboard" %>
        </h1>
        <p style="color:var(--muted)"><%= hospital!=null?hospital.getLocation():"" %></p>
      </div>
      <% if (pendingCount > 0) { %>
        <div class="badge badge-warning" style="font-size:0.9rem;padding:8px 16px">
          ⚠️ <%= pendingCount %> Pending Bookings
        </div>
      <% } %>
    </div>

    <!-- Stats -->
    <div class="grid-4" style="margin-bottom:2rem">
      <div class="stat-card">
        <div class="stat-icon blue">📅</div>
        <div>
          <div class="stat-value"><%= bookings.size() %></div>
          <div class="stat-label">Total Bookings</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon orange">⏳</div>
        <div>
          <div class="stat-value"><%= pendingCount %></div>
          <div class="stat-label">Pending</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">👨‍⚕️</div>
        <div>
          <div class="stat-value"><%= doctors.size() %></div>
          <div class="stat-label">Doctors</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon blue">⭐</div>
        <div>
          <div class="stat-value"><%= hospital!=null?hospital.getRating():"—" %></div>
          <div class="stat-label">Rating</div>
        </div>
      </div>
    </div>

    <!-- Doctors List -->
    <div class="table-wrapper mb-3" style="margin-bottom:1.5rem">
      <div class="card-header">
        <strong>👨‍⚕️ Doctors</strong>
        <a href="manage_doctors.jsp" class="btn btn-primary btn-sm">Manage</a>
      </div>
      <table>
        <thead>
          <tr><th>Name</th><th>Specialization</th><th>Experience</th><th>Availability</th><th>Schedule</th></tr>
        </thead>
        <tbody>
          <% for (Doctor d : doctors) {
               String cls = "available".equals(d.getAvailability())?"badge-success":"badge-danger";
          %>
          <tr>
            <td><strong>Dr. <%= d.getName() %></strong></td>
            <td><%= d.getSpecialization() %></td>
            <td><%= d.getExperience() %> yrs</td>
            <td><span class="badge <%= cls %>"><%= d.getAvailability().toUpperCase() %></span></td>
            <td style="font-size:0.82rem;color:var(--muted)"><%= d.getSchedule() %></td>
          </tr>
          <% } %>
          <% if (doctors.isEmpty()) { %>
          <tr><td colspan="5" style="text-align:center;color:var(--muted);padding:2rem">No doctors listed. <a href="manage_doctors.jsp">Add doctors</a></td></tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <!-- Bookings -->
    <div class="table-wrapper">
      <div class="card-header">
        <strong>📋 Patient Bookings</strong>
      </div>
      <table>
        <thead>
          <tr><th>#</th><th>Patient</th><th>Type</th><th>Date</th><th>Contact</th><th>Status</th><th>Action</th></tr>
        </thead>
        <tbody>
          <% for (Booking b : bookings) {
               String badgeCls = "badge-secondary";
               if ("confirmed".equals(b.getStatus())) badgeCls = "badge-success";
               else if ("pending".equals(b.getStatus())) badgeCls = "badge-warning";
               else if ("cancelled".equals(b.getStatus())) badgeCls = "badge-danger";
          %>
          <tr>
            <td>#<%= b.getBookingId() %></td>
            <td><strong><%= b.getPatientName() %></strong><br><small style="color:var(--muted)"><%= b.getPatientEmail() %></small></td>
            <td><%= b.getBookingType() %></td>
            <td><%= b.getBookingDate() %></td>
            <td><%= b.getContact() %></td>
            <td><span class="badge <%= badgeCls %>"><%= b.getStatus().toUpperCase() %></span></td>
            <td>
              <% if ("pending".equals(b.getStatus())) { %>
                <a href="BookingServlet?action=updateStatus&id=<%= b.getBookingId() %>&status=confirmed"
                   class="btn btn-success btn-sm">✓ Confirm</a>
                <a href="BookingServlet?action=updateStatus&id=<%= b.getBookingId() %>&status=cancelled"
                   class="btn btn-danger btn-sm">✗ Cancel</a>
              <% } else if ("confirmed".equals(b.getStatus())) { %>
                <a href="BookingServlet?action=updateStatus&id=<%= b.getBookingId() %>&status=completed"
                   class="btn btn-sm" style="background:var(--accent);color:#fff">✓ Complete</a>
              <% } %>
            </td>
          </tr>
          <% } %>
          <% if (bookings.isEmpty()) { %>
          <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:2rem">No bookings yet</td></tr>
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
