<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.*" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"city_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    BookingDAO  bDao = new BookingDAO();
    HospitalDAO hDao = new HospitalDAO();
    List<Booking>  allBookings = bDao.getAllBookings();
    List<Hospital> hospitals   = hDao.getAllHospitals();

    long pendingCount   = allBookings.stream().filter(b->"pending".equals(b.getStatus())).count();
    long confirmedCount = allBookings.stream().filter(b->"confirmed".equals(b.getStatus())).count();
    long cancelledCount = allBookings.stream().filter(b->"cancelled".equals(b.getStatus())).count();
    long completedCount = allBookings.stream().filter(b->"completed".equals(b.getStatus())).count();
    long bedBookings    = allBookings.stream().filter(b->"Bed".equals(b.getBookingType())).count();
    long icuBookings    = allBookings.stream().filter(b->"ICU".equals(b.getBookingType())).count();
    long docBookings    = allBookings.stream().filter(b->"Doctor".equals(b.getBookingType())).count();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Reports & Analytics — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
</head>
<body>
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="admin_dashboard.jsp">Dashboard</a></li>
    <li><a href="manage_hospitals.jsp">Hospitals</a></li>
    <li><a href="reports.jsp" class="active">Reports</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-user"><div class="avatar">A</div><div class="user-name">City Admin</div><div class="user-role">Super Admin</div></div>
    <ul class="sidebar-nav">
      <li><a href="admin_dashboard.jsp"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_hospitals.jsp"><span class="nav-icon">🏥</span> Hospitals</a></li>
      <li><a href="reports.jsp" class="active"><span class="nav-icon">📈</span> Reports</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">

    <h1 style="font-family:'Playfair Display',serif;margin-bottom:1.5rem">📈 Analytics & Reports</h1>

    <!-- Stats -->
    <div class="grid-4" style="margin-bottom:2rem">
      <div class="stat-card">
        <div class="stat-icon blue">📅</div>
        <div><div class="stat-value"><%= allBookings.size() %></div><div class="stat-label">Total Bookings</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">✅</div>
        <div><div class="stat-value"><%= confirmedCount+completedCount %></div><div class="stat-label">Confirmed/Completed</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon orange">⏳</div>
        <div><div class="stat-value"><%= pendingCount %></div><div class="stat-label">Pending</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon red">❌</div>
        <div><div class="stat-value"><%= cancelledCount %></div><div class="stat-label">Cancelled</div></div>
      </div>
    </div>

    <!-- Charts Row -->
    <div class="grid-2" style="margin-bottom:2rem">
      <div class="card">
        <div class="card-header"><strong>Bookings by Status</strong></div>
        <div class="card-body">
          <canvas id="statusChart" height="200"></canvas>
        </div>
      </div>
      <div class="card">
        <div class="card-header"><strong>Bookings by Type</strong></div>
        <div class="card-body">
          <canvas id="typeChart" height="200"></canvas>
        </div>
      </div>
    </div>

    <!-- Hospital Resource Bar Chart -->
    <div class="card mb-3" style="margin-bottom:1.5rem">
      <div class="card-header"><strong>Hospital Resource Availability</strong></div>
      <div class="card-body">
        <canvas id="resourceChart" height="120"></canvas>
      </div>
    </div>

    <!-- All Bookings Table -->
    <div class="table-wrapper">
      <div class="card-header"><strong>All Bookings (<%= allBookings.size() %>)</strong></div>
      <table>
        <thead>
          <tr><th>#</th><th>Patient</th><th>Hospital</th><th>Type</th><th>Date</th><th>Contact</th><th>Status</th></tr>
        </thead>
        <tbody>
          <% for (Booking b : allBookings) {
               String bc="badge-secondary";
               if ("confirmed".equals(b.getStatus())) bc="badge-success";
               else if ("pending".equals(b.getStatus())) bc="badge-warning";
               else if ("cancelled".equals(b.getStatus())) bc="badge-danger";
               else if ("completed".equals(b.getStatus())) bc="badge-info";
          %>
          <tr>
            <td>#<%= b.getBookingId() %></td>
            <td><%= b.getPatientName() %><br><small style="color:var(--muted)"><%= b.getPatientEmail() %></small></td>
            <td><%= b.getHospitalName() %></td>
            <td><%= b.getBookingType() %></td>
            <td><%= b.getBookingDate() %></td>
            <td><%= b.getContact() %></td>
            <td><span class="badge <%= bc %>"><%= b.getStatus().toUpperCase() %></span></td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </main>
</div>

<script src="js/main.js"></script>
<script>
  // Status Pie Chart
  new Chart(document.getElementById('statusChart'), {
    type: 'doughnut',
    data: {
      labels: ['Pending','Confirmed','Completed','Cancelled'],
      datasets: [{
        data: [<%= pendingCount %>,<%= confirmedCount %>,<%= completedCount %>,<%= cancelledCount %>],
        backgroundColor: ['#ffd166','#06d6a0','#00b4d8','#ef233c'],
        borderWidth: 2
      }]
    },
    options: { plugins: { legend: { position: 'bottom' } }, cutout: '65%' }
  });

  // Type Bar Chart
  new Chart(document.getElementById('typeChart'), {
    type: 'bar',
    data: {
      labels: ['Bed Bookings','ICU Bookings','Doctor Appointments'],
      datasets: [{
        label: 'Count',
        data: [<%= bedBookings %>,<%= icuBookings %>,<%= docBookings %>],
        backgroundColor: ['#0077b6','#ef233c','#06d6a0'],
        borderRadius: 8
      }]
    },
    options: { plugins: { legend: { display:false } }, scales: { y: { beginAtZero:true } } }
  });

  // Hospital Resource Chart
  new Chart(document.getElementById('resourceChart'), {
    type: 'bar',
    data: {
      labels: [<% for(Hospital h:hospitals) out.print("'"+h.getName().replace("'","")+"',"); %>],
      datasets: [
        { label:'Available Beds', data:[<% for(Hospital h:hospitals) out.print(h.getAvailableBeds()+","); %>], backgroundColor:'rgba(6,214,160,0.7)', borderRadius:4 },
        { label:'Available ICU',  data:[<% for(Hospital h:hospitals) out.print(h.getAvailableIcu()+","); %>], backgroundColor:'rgba(0,119,182,0.7)', borderRadius:4 },
        { label:'Doctors Online', data:[<% for(Hospital h:hospitals) out.print(h.getAvailableDoctors()+","); %>], backgroundColor:'rgba(255,209,102,0.8)', borderRadius:4 }
      ]
    },
    options: { plugins: { legend: { position:'bottom' } }, scales: { x: { stacked:false }, y: { beginAtZero:true } } }
  });
</script>
</body>
</html>
