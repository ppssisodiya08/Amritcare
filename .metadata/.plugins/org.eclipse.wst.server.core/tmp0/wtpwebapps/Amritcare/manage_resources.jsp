<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.model.*,com.amritcare.util.DBConnection,java.sql.*,java.util.*" %>
<%
    if (session.getAttribute("loggedUser")==null) { response.sendRedirect("login.jsp"); return; }
    User user = (User) session.getAttribute("loggedUser");
    if (!"hospital_admin".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    int hospitalId = user.getHospitalId();
    String msg = "", msgType = "success";

    // Handle status update
    String updateType = request.getParameter("updateType");
    String unitId     = request.getParameter("unitId");
    String newStatus  = request.getParameter("status");

    if (updateType != null && unitId != null && newStatus != null) {
        String table = "bed".equals(updateType) ? "bed" : "icu";
        String sql   = "UPDATE " + table + " SET status=? WHERE id=? AND hospital_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, Integer.parseInt(unitId));
            ps.setInt(3, hospitalId);
            ps.executeUpdate();
            msg = "Status updated successfully!";
        } catch (Exception e) { msg = "Update failed: " + e.getMessage(); msgType = "danger"; }
    }

    // Load beds
    List<Map<String,String>> beds = new ArrayList<>();
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM bed WHERE hospital_id=? ORDER BY bed_number")) {
        ps.setInt(1, hospitalId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> m = new LinkedHashMap<>();
            m.put("id", rs.getString("id"));
            m.put("number", rs.getString("bed_number"));
            m.put("type", rs.getString("type"));
            m.put("status", rs.getString("status"));
            beds.add(m);
        }
    } catch (Exception e) { e.printStackTrace(); }

    // Load ICU units
    List<Map<String,String>> icus = new ArrayList<>();
    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement("SELECT * FROM icu WHERE hospital_id=? ORDER BY unit_number")) {
        ps.setInt(1, hospitalId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Map<String,String> m = new LinkedHashMap<>();
            m.put("id", rs.getString("id"));
            m.put("number", rs.getString("unit_number"));
            m.put("status", rs.getString("status"));
            icus.add(m);
        }
    } catch (Exception e) { e.printStackTrace(); }

    long availBeds = beds.stream().filter(b->"available".equals(b.get("status"))).count();
    long availIcus = icus.stream().filter(i->"available".equals(i.get("status"))).count();
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Resources — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    .unit-grid { display:grid; grid-template-columns: repeat(auto-fill,minmax(160px,1fr)); gap:0.75rem; }
    .unit-card {
      background:var(--card); border-radius:12px; padding:1rem; text-align:center;
      border:2px solid var(--border); transition:all 0.2s;
    }
    .unit-card.available { border-color:var(--success); background:rgba(6,214,160,0.05); }
    .unit-card.occupied  { border-color:var(--danger);  background:rgba(239,35,60,0.05); }
    .unit-card.maintenance { border-color:var(--warning); background:rgba(255,209,102,0.08); }
    .unit-number { font-size:1.1rem; font-weight:700; margin-bottom:0.5rem; }
    .unit-status { font-size:0.75rem; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:0.75rem; }
    .unit-actions select { font-size:0.8rem; padding:4px 8px; border-radius:6px; border:1px solid var(--border); }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="hospital_dashboard.jsp">Dashboard</a></li>
    <li><a href="manage_resources.jsp" class="active">Resources</a></li>
    <li><a href="manage_doctors.jsp">Doctors</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div class="dashboard-layout">
  <aside class="sidebar">
    <div class="sidebar-user">
      <div class="avatar">H</div>
      <div class="user-name">Hospital Admin</div>
      <div class="user-role">Staff</div>
    </div>
    <ul class="sidebar-nav">
      <li><a href="hospital_dashboard.jsp"><span class="nav-icon">📊</span> Dashboard</a></li>
      <li><a href="manage_resources.jsp" class="active"><span class="nav-icon">🛏</span> Resources</a></li>
      <li><a href="manage_doctors.jsp"><span class="nav-icon">👨‍⚕️</span> Doctors</a></li>
      <li><a href="LogoutServlet"><span class="nav-icon">🚪</span> Logout</a></li>
    </ul>
  </aside>

  <main class="dashboard-content">

    <h1 style="font-family:'Playfair Display',serif;margin-bottom:1.5rem">🛏 Resource Management</h1>

    <% if (!msg.isEmpty()) { %>
      <div class="alert alert-<%= msgType %>"><%= msg %></div>
    <% } %>

    <!-- Summary Stats -->
    <div class="grid-4" style="margin-bottom:2rem">
      <div class="stat-card">
        <div class="stat-icon green">🛏</div>
        <div><div class="stat-value"><%= availBeds %></div><div class="stat-label">Available Beds</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon red">🛏</div>
        <div><div class="stat-value"><%= beds.size()-availBeds %></div><div class="stat-label">Occupied Beds</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon green">🏥</div>
        <div><div class="stat-value"><%= availIcus %></div><div class="stat-label">Available ICU</div></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon red">🏥</div>
        <div><div class="stat-value"><%= icus.size()-availIcus %></div><div class="stat-label">Occupied ICU</div></div>
      </div>
    </div>

    <!-- Beds -->
    <div class="card mb-3" style="margin-bottom:1.5rem">
      <div class="card-header"><strong>🛏 Beds (<%= beds.size() %> total, <%= availBeds %> available)</strong></div>
      <div class="card-body">
        <div class="unit-grid">
          <% for (Map<String,String> b : beds) { %>
          <div class="unit-card <%= b.get("status") %>">
            <div class="unit-number"><%= b.get("number") %></div>
            <div class="unit-status" style="color:<%= "available".equals(b.get("status"))?"var(--success)":"available".equals(b.get("status"))?"var(--danger)":"var(--warning)" %>">
              <%= b.get("status") %> | <%= b.get("type") %>
            </div>
            <div class="unit-actions">
              <form action="manage_resources.jsp" method="get" style="display:inline">
                <input type="hidden" name="updateType" value="bed">
                <input type="hidden" name="unitId" value="<%= b.get("id") %>">
                <select name="status" onchange="this.form.submit()" style="width:100%">
                  <option value="available"   <%= "available".equals(b.get("status"))?"selected":"" %>>Available</option>
                  <option value="occupied"    <%= "occupied".equals(b.get("status"))?"selected":"" %>>Occupied</option>
                  <option value="maintenance" <%= "maintenance".equals(b.get("status"))?"selected":"" %>>Maintenance</option>
                </select>
              </form>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>

    <!-- ICU -->
    <div class="card">
      <div class="card-header"><strong>🏥 ICU Units (<%= icus.size() %> total, <%= availIcus %> available)</strong></div>
      <div class="card-body">
        <div class="unit-grid">
          <% for (Map<String,String> icu : icus) { %>
          <div class="unit-card <%= icu.get("status") %>">
            <div class="unit-number"><%= icu.get("number") %></div>
            <div class="unit-status">
              <span class="badge <%= "available".equals(icu.get("status"))?"badge-success":"badge-danger" %>">
                <%= icu.get("status") %>
              </span>
            </div>
            <div class="unit-actions">
              <form action="manage_resources.jsp" method="get">
                <input type="hidden" name="updateType" value="icu">
                <input type="hidden" name="unitId" value="<%= icu.get("id") %>">
                <select name="status" onchange="this.form.submit()" style="width:100%">
                  <option value="available"   <%= "available".equals(icu.get("status"))?"selected":"" %>>Available</option>
                  <option value="occupied"    <%= "occupied".equals(icu.get("status"))?"selected":"" %>>Occupied</option>
                  <option value="maintenance" <%= "maintenance".equals(icu.get("status"))?"selected":"" %>>Maintenance</option>
                </select>
              </form>
            </div>
          </div>
          <% } %>
        </div>
      </div>
    </div>

  </main>
</div>
<script src="js/main.js"></script>
</body>
</html>
