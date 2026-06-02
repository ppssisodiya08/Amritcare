<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect if already logged in
    if (session.getAttribute("loggedUser") != null) {
        String role = (String) session.getAttribute("userRole");
        if ("city_admin".equals(role)) response.sendRedirect("admin_dashboard.jsp");
        else if ("hospital_admin".equals(role)) response.sendRedirect("hospital_dashboard.jsp");
        else response.sendRedirect("dashboard.jsp");
        return;
    }
    String error   = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    body { display:flex; flex-direction:column; min-height:100vh; }
    .login-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:3rem 1rem; }
    .form-card { width:100%; }
    .demo-box { background:rgba(0,119,182,0.06); border-radius:10px; padding:1rem 1.25rem; margin-top:1.5rem; font-size:0.82rem; color:var(--muted); }
    .demo-box strong { color:var(--primary-dark); }
    .demo-row { display:flex; justify-content:space-between; margin-top:4px; }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="register.jsp" class="btn-nav">Register</a></li>
  </ul>
</nav>

<div class="login-wrap">
  <div class="form-card" style="max-width:440px">
    <div style="text-align:center;margin-bottom:2rem">
      <div style="font-size:3rem">🏥</div>
      <h1 class="form-title">Welcome Back</h1>
      <p style="color:var(--muted);font-size:0.9rem">Sign in to your AmritCare account</p>
    </div>

    <% if (error != null) { %>
      <div class="alert alert-danger">❌ <%= error %></div>
    <% } %>
    <% if (success != null) { %>
      <div class="alert alert-success">✅ <%= success %></div>
    <% } %>

    <form action="LoginServlet" method="post" onsubmit="return validateForm('loginForm')" id="loginForm">
      <div class="form-group">
        <label>Email Address</label>
        <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label>Password</label>
        <input type="password" name="password" class="form-control" placeholder="Your password" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;margin-top:0.5rem;justify-content:center">
        Sign In →
      </button>
    </form>

    <p style="text-align:center;margin-top:1.25rem;font-size:0.9rem;color:var(--muted)">
      No account? <a href="register.jsp" style="color:var(--primary);font-weight:600">Register here</a>
    </p>

    
  </div>
</div>

<footer><p>© 2026 AmritCare</p></footer>
<button class="voice-btn" id="voiceBtn" title="Voice Assistant">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>
<script src="js/main.js"></script>
</body>
</html>
