<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedUser") != null) { response.sendRedirect("dashboard.jsp"); return; }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    body { display:flex; flex-direction:column; min-height:100vh; }
    .reg-wrap { flex:1; display:flex; align-items:center; justify-content:center; padding:3rem 1rem; }
  </style>
</head>
<body>
<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="login.jsp">Login</a></li>
  </ul>
</nav>

<div class="reg-wrap">
  <div class="form-card" style="max-width:460px">
    <div style="text-align:center;margin-bottom:2rem">
      <div style="font-size:3rem">👤</div>
      <h1 class="form-title">Create Account</h1>
      <p style="color:var(--muted);font-size:0.9rem">Join AmritCare as a patient</p>
    </div>

    <% if (error != null) { %>
      <div class="alert alert-danger">❌ <%= error %></div>
    <% } %>

    <form action="RegisterServlet" method="post" onsubmit="return validateForm('regForm')" id="regForm">
      <div class="form-group">
        <label>Full Name <span style="color:var(--danger)">*</span></label>
        <input type="text" name="name" class="form-control" placeholder="Rahul Sharma" required>
      </div>
      <div class="form-group">
        <label>Email Address <span style="color:var(--danger)">*</span></label>
        <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label>Phone Number <span style="color:var(--danger)">*</span></label>
        <input type="tel" name="phone" class="form-control" placeholder="10-digit mobile number" required maxlength="10" pattern="\d{10}">
      </div>
      <div class="form-group">
        <label>Password <span style="color:var(--danger)">*</span></label>
        <input type="password" name="password" id="pw" class="form-control" placeholder="Minimum 6 characters" required minlength="6">
      </div>
      <div class="form-group">
        <label>Confirm Password <span style="color:var(--danger)">*</span></label>
        <input type="password" name="confirmPw" id="cpw" class="form-control" placeholder="Repeat your password" required>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center">
        Create Account →
      </button>
    </form>

    <p style="text-align:center;margin-top:1.25rem;font-size:0.9rem;color:var(--muted)">
      Already have an account? <a href="login.jsp" style="color:var(--primary);font-weight:600">Login</a>
    </p>
  </div>
</div>

<footer><p>© 2026 AmritCare</p></footer>
<script src="js/main.js"></script>
<script>
  document.getElementById('regForm').addEventListener('submit', function(e) {
    const pw = document.getElementById('pw').value;
    const cp = document.getElementById('cpw').value;
    if (pw !== cp) {
      e.preventDefault();
      document.getElementById('cpw').classList.add('error');
      alert('Passwords do not match!');
    }
  });
</script>
</body>
</html>
