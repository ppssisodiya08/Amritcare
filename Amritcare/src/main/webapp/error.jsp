<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Error — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style> body{display:flex;flex-direction:column;min-height:100vh;align-items:center;justify-content:center;text-align:center} </style>
</head>
<body>
  <div style="font-size:5rem">😓</div>
  <h1 style="font-family:'Playfair Display',serif;color:var(--danger);margin:1rem 0">Something went wrong</h1>
  <p style="color:var(--muted);margin-bottom:2rem">
    <% if (exception != null) { %><%= exception.getMessage() %><% } else { %>An unexpected error occurred.<% } %>
  </p>
  <a href="index.jsp" class="btn btn-primary">← Go Home</a>
</body>
</html>
