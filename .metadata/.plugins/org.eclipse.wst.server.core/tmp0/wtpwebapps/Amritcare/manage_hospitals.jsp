<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.List" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"city_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    HospitalDAO hDao = new HospitalDAO();
    String msg = "", msgType = "success";

    // Handle add
    String action = request.getParameter("action");
    if ("add".equals(action)) {
        Hospital h = new Hospital();
        h.setName(request.getParameter("name"));
        h.setLocation(request.getParameter("location"));
        h.setContact(request.getParameter("contact"));
        h.setSpecialization(request.getParameter("specialization"));
        try { h.setTotalBeds(Integer.parseInt(request.getParameter("totalBeds"))); } catch(Exception e){}
        try { h.setTotalIcu(Integer.parseInt(request.getParameter("totalIcu"))); }   catch(Exception e){}
        try { h.setLatitude(Double.parseDouble(request.getParameter("latitude"))); } catch(Exception e){}
        try { h.setLongitude(Double.parseDouble(request.getParameter("longitude"))); } catch(Exception e){}
        if (hDao.addHospital(h)) msg = "Hospital added successfully!";
        else { msg = "Failed to add hospital."; msgType = "danger"; }
    } else if ("deactivate".equals(action)) {
        hDao.updateStatus(Integer.parseInt(request.getParameter("id")), "inactive");
        msg = "Hospital deactivated.";
    } else if ("activate".equals(action)) {
        hDao.updateStatus(Integer.parseInt(request.getParameter("id")), "active");
        msg = "Hospital activated.";
    }

    List<Hospital> hospitals = hDao.getAllHospitals();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Hospitals — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="admin_dashboard.jsp">Dashboard</a></li>
    <li><a href="manage_hospitals.jsp" class="active">Hospitals</a></li>
    <li><a href="reports.jsp">Reports</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-user"><div class="avatar">A</div><div class="user-name">City Admin</div><div class="user-role">Super Admin</div></div>
    <ul class="sidebar-nav">
      <li><a href="admin_dashboard.jsp"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_hospitals.jsp" class="active"><span class="nav-icon">🏥</span> Hospitals</a></li>
      <li><a href="reports.jsp"><span class="nav-icon">📈</span> Reports</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">
    <h1 style="font-family:'Playfair Display',serif;margin-bottom:1.5rem">🏥 Manage Hospitals</h1>

    <% if (!msg.isEmpty()) { %><div class="alert alert-<%= msgType %>"><%= msg %></div><% } %>

    <!-- Add Hospital Form -->
    <div class="card mb-3" style="margin-bottom:1.5rem">
      <div class="card-header"><strong>➕ Add New Hospital</strong></div>
      <div class="card-body">
        <form action="manage_hospitals.jsp" method="post">
          <input type="hidden" name="action" value="add">
          <div class="grid-2">
            <div class="form-group">
              <label>Hospital Name *</label>
              <input type="text" name="name" class="form-control" required placeholder="Full hospital name">
            </div>
            <div class="form-group">
              <label>Location *</label>
              <input type="text" name="location" class="form-control" required placeholder="Area, Bhopal">
            </div>
            <div class="form-group">
              <label>Contact</label>
              <input type="text" name="contact" class="form-control" placeholder="Phone number">
            </div>
            <div class="form-group">
              <label>Specializations</label>
              <input type="text" name="specialization" class="form-control" placeholder="Cardiology, General, etc.">
            </div>
            <div class="form-group">
              <label>Total Beds</label>
              <input type="number" name="totalBeds" class="form-control" min="0" value="50">
            </div>
            <div class="form-group">
              <label>Total ICU Units</label>
              <input type="number" name="totalIcu" class="form-control" min="0" value="10">
            </div>
            <div class="form-group">
              <label>Latitude (GPS)</label>
              <input type="text" name="latitude" class="form-control" placeholder="e.g. 23.2599" value="23.2599">
            </div>
            <div class="form-group">
              <label>Longitude (GPS)</label>
              <input type="text" name="longitude" class="form-control" placeholder="e.g. 77.4126" value="77.4126">
            </div>
          </div>
          <button type="submit" class="btn btn-primary">Add Hospital</button>
        </form>
      </div>
    </div>

    <!-- Hospital List -->
    <div class="table-wrapper">
      <div class="card-header"><strong>All Hospitals (<%= hospitals.size() %>)</strong></div>
      <table>
        <thead>
          <tr><th>Name</th><th>Location</th><th>Contact</th><th>Beds</th><th>ICU</th><th>Rating</th><th>Action</th></tr>
        </thead>
        <tbody>
          <% for (Hospital h : hospitals) { %>
          <tr>
            <td><strong><%= h.getName() %></strong></td>
            <td style="font-size:0.85rem"><%= h.getLocation() %></td>
            <td style="font-size:0.85rem"><%= h.getContact() %></td>
            <td><span style="color:var(--success);font-weight:700"><%= h.getAvailableBeds() %></span>/<%= h.getTotalBeds() %></td>
            <td><span style="color:var(--primary);font-weight:700"><%= h.getAvailableIcu() %></span>/<%= h.getTotalIcu() %></td>
            <td>⭐ <%= h.getRating() %></td>
            <td>
              <a href="manage_hospitals.jsp?action=deactivate&id=<%= h.getId() %>"
                 class="btn btn-danger btn-sm"
                 onclick="return confirm('Deactivate this hospital?')">Deactivate</a>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </main>
</div>
<script src="js/main.js"></script>
</body>
</html>
