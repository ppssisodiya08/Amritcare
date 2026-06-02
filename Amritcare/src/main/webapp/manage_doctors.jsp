<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.List" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"hospital_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    int hospitalId = user.getHospitalId();
    DoctorDAO dDao = new DoctorDAO();

    // Handle form submissions
    String action = request.getParameter("action");
    String msg = "", msgType = "success";

    if ("add".equals(action)) {
        Doctor d = new Doctor();
        d.setHospitalId(hospitalId);
        d.setName(request.getParameter("name"));
        d.setSpecialization(request.getParameter("specialization"));
        d.setQualification(request.getParameter("qualification"));
        try { d.setExperience(Integer.parseInt(request.getParameter("experience"))); } catch(Exception e){}
        d.setSchedule(request.getParameter("schedule"));
        if (dDao.addDoctor(d)) msg = "Doctor added successfully!";
        else { msg = "Failed to add doctor."; msgType = "danger"; }
    } else if ("toggle".equals(action)) {
        int docId = Integer.parseInt(request.getParameter("id"));
        String avail = request.getParameter("avail");
        dDao.updateAvailability(docId, avail);
        msg = "Doctor availability updated!";
    } else if ("delete".equals(action)) {
        int docId = Integer.parseInt(request.getParameter("id"));
        if (dDao.deleteDoctor(docId)) msg = "Doctor removed.";
        else { msg = "Could not remove doctor."; msgType = "danger"; }
    }

    List<Doctor> doctors = dDao.getDoctorsByHospital(hospitalId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Doctors — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="hospital_dashboard.jsp">Dashboard</a></li>
    <li><a href="manage_resources.jsp">Resources</a></li>
    <li><a href="manage_doctors.jsp" class="active">Doctors</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-user">
      <div class="avatar">H</div>
      <div class="user-name">Hospital Admin</div>
      <div class="user-role">Hospital Staff</div>
    </div>
    <ul class="sidebar-nav">
      <li><a href="hospital_dashboard.jsp"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_resources.jsp"><span class="nav-icon">🛏</span> Resources</a></li>
      <li><a href="manage_doctors.jsp" class="active"><span class="nav-icon">👨‍⚕️</span> Doctors</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">

    <h1 style="font-family:'Playfair Display',serif;margin-bottom:1.5rem">👨‍⚕️ Manage Doctors</h1>

    <% if (!msg.isEmpty()) { %>
      <div class="alert alert-<%= msgType %>"><%= msg %></div>
    <% } %>

    <!-- Add Doctor Form -->
    <div class="card mb-3" style="margin-bottom:1.5rem">
      <div class="card-header"><strong>➕ Add New Doctor</strong></div>
      <div class="card-body">
        <form action="manage_doctors.jsp" method="post">
          <input type="hidden" name="action" value="add">
          <div class="grid-2">
            <div class="form-group">
              <label>Doctor Name *</label>
              <input type="text" name="name" class="form-control" placeholder="Dr. Full Name" required>
            </div>
            <div class="form-group">
              <label>Specialization *</label>
              <input type="text" name="specialization" class="form-control" placeholder="e.g. Cardiology" required>
            </div>
            <div class="form-group">
              <label>Qualification</label>
              <input type="text" name="qualification" class="form-control" placeholder="e.g. MBBS, MD">
            </div>
            <div class="form-group">
              <label>Experience (years)</label>
              <input type="number" name="experience" class="form-control" placeholder="Years of experience" min="0">
            </div>
          </div>
          <div class="form-group">
            <label>Schedule</label>
            <input type="text" name="schedule" class="form-control" placeholder="e.g. Mon-Fri 9AM-5PM">
          </div>
          <button type="submit" class="btn btn-primary">Add Doctor</button>
        </form>
      </div>
    </div>

    <!-- Doctors List -->
    <div class="table-wrapper">
      <div class="card-header"><strong>Registered Doctors (<%= doctors.size() %>)</strong></div>
      <table>
        <thead>
          <tr><th>Name</th><th>Specialization</th><th>Qualification</th><th>Exp.</th><th>Schedule</th><th>Status</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <% for (Doctor d : doctors) { %>
          <tr>
            <td><strong>Dr. <%= d.getName() %></strong></td>
            <td><%= d.getSpecialization() %></td>
            <td style="font-size:0.82rem"><%= d.getQualification() %></td>
            <td><%= d.getExperience() %>y</td>
            <td style="font-size:0.82rem;color:var(--muted)"><%= d.getSchedule() %></td>
            <td>
              <% if ("available".equals(d.getAvailability())) { %>
                <span class="badge badge-success">AVAILABLE</span>
              <% } else { %>
                <span class="badge badge-danger"><%= d.getAvailability().toUpperCase() %></span>
              <% } %>
            </td>
            <td>
              <% String toggleAvail = "available".equals(d.getAvailability()) ? "unavailable" : "available"; %>
              <a href="manage_doctors.jsp?action=toggle&id=<%= d.getId() %>&avail=<%= toggleAvail %>"
                 class="btn btn-sm btn-outline">
                <%= "available".equals(d.getAvailability()) ? "Mark Unavailable" : "Mark Available" %>
              </a>
              <a href="manage_doctors.jsp?action=delete&id=<%= d.getId() %>"
                 class="btn btn-danger btn-sm"
                 onclick="return confirm('Remove Dr. <%= d.getName() %>?')">✗</a>
            </td>
          </tr>
          <% } %>
          <% if (doctors.isEmpty()) { %>
          <tr><td colspan="7" style="text-align:center;color:var(--muted);padding:2rem">No doctors added yet.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>

  </main>
</div>
<script src="js/main.js"></script>
</body>
</html>
