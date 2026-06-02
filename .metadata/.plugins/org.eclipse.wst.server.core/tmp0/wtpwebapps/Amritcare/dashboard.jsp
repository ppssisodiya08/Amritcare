<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.BookingDAO, com.amritcare.model.*,java.util.List" %>
<%
    if (session.getAttribute("loggedUser") == null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if ("city_admin".equals(user.getRole()))     { response.sendRedirect("admin_dashboard.jsp"); return; }
    if ("hospital_admin".equals(user.getRole())) { response.sendRedirect("hospital_dashboard.jsp"); return; }

    BookingDAO dao = new BookingDAO();
    List<Booking> bookings = dao.getBookingsByEmail(user.getEmail());

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");

    
    long pending   = bookings.stream().filter(b->"pending".equals(b.getStatus())).count();
    long confirmed = bookings.stream().filter(b->"confirmed".equals(b.getStatus())).count();
    long completed = bookings.stream().filter(b->"completed".equals(b.getStatus())).count();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Dashboard — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="HospitalServlet">Hospitals</a></li>
    <li><a href="booking.jsp">Book</a></li>
    <li><a href="ambulance.jsp">🚑</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">

 
  <aside class="sidebar">
    <div class="sidebar-user">
      <div class="avatar"><%= user.getName().substring(0,1).toUpperCase() %></div>
      <div class="user-name"><%= user.getName() %></div>
      <div class="user-role">Patient</div>
    </div>
    <ul class="sidebar-nav">
      <li><a href="dashboard.jsp" class="active"><span class="nav-icon">📊</span> My Dashboard</a></li>
      <li><a href="HospitalServlet"><span class="nav-icon">🏥</span> Find Hospitals</a></li>
      <li><a href="booking.jsp?type=Bed"><span class="nav-icon">🛏</span> Book Bed</a></li>
      <li><a href="booking.jsp?type=ICU"><span class="nav-icon">🏥</span> Book ICU</a></li>
      <li><a href="booking.jsp?type=Doctor"><span class="nav-icon">👨‍⚕️</span> Book Doctor</a></li>
      <li><a href="ambulance.jsp"><span class="nav-icon">🚑</span> Ambulance</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>


  <main class="dashboard-content">

    <div class="alert-container">
      <% if (success!=null) { %><div class="alert alert-success">✅ <%= success %></div><% } %>
      <% if (error!=null)   { %><div class="alert alert-danger">❌ <%= error %></div><% } %>
    </div>

    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:1.5rem;flex-wrap:wrap;gap:1rem">
      <div>
        <h1 style="font-family:'Playfair Display',serif;font-size:1.8rem">Welcome, <%= user.getName() %>! 👋</h1>
        <p style="color:var(--muted)">Manage your healthcare bookings</p>
      </div>
      <a href="booking.jsp" class="btn btn-primary">+ New Booking</a>
    </div>

 
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
          <div class="stat-value"><%= pending %></div>
          <div class="stat-label">Pending</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">✅</div>
        <div>
          <div class="stat-value"><%= confirmed %></div>
          <div class="stat-label">Confirmed</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon blue">🏁</div>
        <div>
          <div class="stat-value"><%= completed %></div>
          <div class="stat-label">Completed</div>
        </div>
      </div>
    </div>

    
    <div class="card mb-3">
      <div class="card-header">
        <strong>⚡ Quick Actions</strong>
      </div>
      <div class="card-body" style="display:flex;gap:1rem;flex-wrap:wrap">
        <a href="booking.jsp?type=Bed"    class="btn btn-primary">🛏 Book Bed</a>
        <a href="booking.jsp?type=ICU"    class="btn btn-outline">🏥 Book ICU</a>
        <a href="booking.jsp?type=Doctor" class="btn btn-success">👨‍⚕️ Doctor Appointment</a>
        <a href="ambulance.jsp"           class="btn" style="background:var(--warning);color:var(--text)">🚑 Ambulance</a>
        <a href="HospitalServlet"         class="btn btn-outline">🏥 Find Hospitals</a>
      </div>
    </div>

   
    <div class="table-wrapper">
      <div class="card-header" style="padding:1rem 1.5rem">
        <strong>📋 My Bookings</strong>
        <span style="font-size:0.82rem;color:var(--muted)"><%= bookings.size() %> total</span>
      </div>
      <% if (bookings.isEmpty()) { %>
        <div style="padding:3rem;text-align:center;color:var(--muted)">
          <div style="font-size:3rem;margin-bottom:1rem">📭</div>
          <p>No bookings yet. <a href="booking.jsp" style="color:var(--primary)">Make your first booking</a></p>
        </div>
      <% } else { %>
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Type</th>
            <th>Hospital</th>
            <th>Doctor</th>
            <th>Date</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <% for (Booking b : bookings) {
               String badgeCls = "badge-secondary";
               if ("confirmed".equals(b.getStatus())) badgeCls = "badge-success";
               else if ("pending".equals(b.getStatus())) badgeCls = "badge-warning";
               else if ("cancelled".equals(b.getStatus())) badgeCls = "badge-danger";
               else if ("completed".equals(b.getStatus())) badgeCls = "badge-info";
          %>
          <tr>
            <td><strong>#<%= b.getBookingId() %></strong></td>
            <td>
              <% if ("Bed".equals(b.getBookingType()))    out.print("🛏 Bed"); %>
              <% if ("ICU".equals(b.getBookingType()))    out.print("🏥 ICU"); %>
              <% if ("Doctor".equals(b.getBookingType())) out.print("👨‍⚕️ Doctor"); %>
            </td>
            <td><%= b.getHospitalName()!=null?b.getHospitalName():"—" %></td>
            <td><%= b.getDoctorName()!=null?b.getDoctorName():"—" %></td>
            <td><%= b.getBookingDate() %></td>
            <td><span class="badge <%= badgeCls %>"><%= b.getStatus().toUpperCase() %></span></td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

  </main>
</div>

<button class="voice-btn" id="voiceBtn" title="Voice Assistant">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>
<script src="js/main.js"></script>
</body>
</html>
