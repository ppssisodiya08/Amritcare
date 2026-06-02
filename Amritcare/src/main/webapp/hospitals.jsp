<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.HospitalDAO, com.amritcare.model.Hospital, java.util.List" %>
<%
    HospitalDAO dao = new HospitalDAO();
    List<Hospital> hospitals = dao.getAllHospitals();
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hospitals — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="HospitalServlet" class="active">Hospitals</a></li>
    <li><a href="ambulance.jsp">🚑 Ambulance</a></li>
    <% if (userName != null) { %>
      <li><a href="dashboard.jsp">Dashboard</a></li>
      <li><a href="LogoutServlet">Logout</a></li>
    <% } else { %>
      <li><a href="login.jsp">Login</a></li>
      <li><a href="register.jsp" class="btn-nav">Register</a></li>
    <% } %>
  </ul>
</nav>

<!-- Page Header -->
<div style="background:linear-gradient(135deg,var(--primary-dark),var(--primary));color:#fff;padding:3rem 2rem 2rem;">
  <div class="container">
    <h1 style="font-family:'Playfair Display',serif;font-size:2rem;margin-bottom:0.5rem">🏥 Find Hospitals</h1>
    <p style="opacity:0.85">Real-time availability across <%= hospitals.size() %> partner hospitals in Bhopal</p>
  </div>
</div>

<section class="section">
  <div class="container">

    <!-- Search Bar -->
    <div class="search-bar">
      <input type="text" id="hospitalSearch" placeholder="🔍 Search by name, location or specialization…" class="form-control" style="flex:1">
      <button class="btn btn-primary" onclick="document.getElementById('hospitalSearch').dispatchEvent(new Event('input'))">Search</button>
    </div>

    <!-- Filter Tags -->
    <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:2rem;">
      <span style="font-size:0.85rem;color:var(--muted);align-self:center;">Quick filters:</span>
      <% String[] filters = {"Cardiology","Neurology","Orthopaedics","Gynaecology","Oncology","ICU"}; %>
      <% for (String f : filters) { %>
        <button class="btn btn-outline btn-sm" onclick="document.getElementById('hospitalSearch').value='<%= f %>';document.getElementById('hospitalSearch').dispatchEvent(new Event('input'))"><%= f %></button>
      <% } %>
      <button class="btn btn-sm" style="background:var(--bg);color:var(--muted)" onclick="document.getElementById('hospitalSearch').value='';document.getElementById('hospitalSearch').dispatchEvent(new Event('input'))">Clear</button>
    </div>

    <!-- Hospital Grid -->
    <div class="grid-3" id="hospitalsGrid">
      <%
        for (Hospital h : hospitals) {
          String[] specs = (h.getSpecialization() != null ? h.getSpecialization() : "").split(",");
      %>
      <div class="hospital-card fade-in">
        <div class="hcard-header">
          <div>
            <div class="hcard-name">🏥 <%= h.getName() %></div>
            <div class="hcard-loc">📍 <%= h.getLocation() %></div>
          </div>
          <div>
            <div class="rating-stars" style="font-size:0.85rem">
              <%
                double r = h.getRating();
                int full = (int)r;
                for (int i=0;i<full;i++) out.print("★");
                for (int i=full;i<5;i++) out.print("☆");
              %>
            </div>
            <small style="opacity:0.8"><%= h.getRating() %>/5</small>
          </div>
        </div>
        <div class="hcard-body">
          <div class="specialization-tags">
            <% for (int i=0; i<Math.min(specs.length,3); i++) { %>
              <span class="spec-tag"><%= specs[i].trim() %></span>
            <% } %>
          </div>
          <div class="resource-badges">
            <div class="resource-badge">
              <div class="rb-count" style="color:<%= h.getAvailableBeds()>0?"var(--success)":"var(--danger)" %>">
                <%= h.getAvailableBeds() %>
              </div>
              <div class="rb-label">Beds</div>
            </div>
            <div class="resource-badge">
              <div class="rb-count" style="color:<%= h.getAvailableIcu()>0?"var(--primary)":"var(--danger)" %>">
                <%= h.getAvailableIcu() %>
              </div>
              <div class="rb-label">ICU</div>
            </div>
            <div class="resource-badge">
              <div class="rb-count" style="color:<%= h.getAvailableDoctors()>0?"var(--success)":"var(--danger)" %>">
                <%= h.getAvailableDoctors() %>
              </div>
              <div class="rb-label">Doctors</div>
            </div>
          </div>
          <p style="font-size:0.83rem;color:var(--muted);margin-top:0.5rem">📞 <%= h.getContact() %></p>
        </div>
        <div class="hcard-actions">
          <a href="booking.jsp?hospitalId=<%= h.getId() %>&type=Bed"
             class="btn btn-primary btn-sm" style="<%= h.getAvailableBeds()==0?"opacity:0.5;cursor:not-allowed":"" %>">
            🛏 Bed
          </a>
          <a href="booking.jsp?hospitalId=<%= h.getId() %>&type=ICU"
             class="btn btn-outline btn-sm" style="<%= h.getAvailableIcu()==0?"opacity:0.5;cursor:not-allowed":"" %>">
            🏥 ICU
          </a>
          <a href="booking.jsp?hospitalId=<%= h.getId() %>&type=Doctor"
             class="btn btn-success btn-sm" style="<%= h.getAvailableDoctors()==0?"opacity:0.5;cursor:not-allowed":"" %>">
            👨‍⚕️ Doctor
          </a>
        </div>
      </div>
      <% } %>
    </div>

  </div>
</section>

<footer><p>© 2026 AmritCare — Smart Healthcare, Bhopal</p></footer>
<button class="voice-btn" id="voiceBtn" title="Voice Assistant">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>
<script src="js/main.js"></script>
</body>
</html>
