<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.HospitalDAO, com.amritcare.dao.DoctorDAO, com.amritcare.model.*,java.util.*" %>
<%
    if (session.getAttribute("loggedUser") == null) { response.sendRedirect("login.jsp"); return; }
    User loggedUser = (User) session.getAttribute("loggedUser");

    HospitalDAO hDao = new HospitalDAO();
    List<Hospital> hospitals = hDao.getAllHospitals();

    String preHospId = request.getParameter("hospitalId");
    String preType   = request.getParameter("type");
    Hospital preHosp = null;
    List<Doctor> preDoctors = new ArrayList<>();
    if (preHospId != null) {
        preHosp = hDao.getHospitalById(Integer.parseInt(preHospId));
        DoctorDAO dDao = new DoctorDAO();
        preDoctors = dDao.getAvailableDoctors(Integer.parseInt(preHospId));
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Book Appointment — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    .booking-tab {
      flex: 1; padding: 14px; text-align: center; border: 2px solid var(--border);
      border-radius: 10px; cursor: pointer; font-weight: 600; font-size: 0.95rem;
      transition: all 0.2s; background: var(--card); color: var(--text);
    }
    .booking-tab.active { background: var(--primary); color: #fff; border-color: var(--primary); }
    .booking-tab:hover:not(.active) { border-color: var(--primary); color: var(--primary); }
    .type-section { display: none; margin-top: 1rem; }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="HospitalServlet">Hospitals</a></li>
    <li><a href="dashboard.jsp">Dashboard</a></li>
    <li><a href="LogoutServlet">Logout</a></li>
  </ul>
</nav>

<div style="background:linear-gradient(135deg,var(--primary-dark),var(--primary));color:#fff;padding:2.5rem 2rem 2rem;">
  <div class="container">
    <h1 style="font-family:'Playfair Display',serif;font-size:2rem">📅 Book an Appointment</h1>
    <p style="opacity:0.85">Select your booking type and fill in the details</p>
  </div>
</div>

<section class="section">
  <div class="container" style="max-width:700px">

    <div class="card">
      <div class="card-body" style="padding:2rem">

       
        <div style="display:flex;gap:12px;margin-bottom:1.5rem">
          <button class="booking-tab <%= "Bed".equals(preType)||preType==null?"active":"" %>"
                  data-type="Bed" onclick="switchTab('Bed')">🛏 Book Bed</button>
          <button class="booking-tab <%= "ICU".equals(preType)?"active":"" %>"
                  data-type="ICU" onclick="switchTab('ICU')">🏥 Book ICU</button>
          <button class="booking-tab <%= "Doctor".equals(preType)?"active":"" %>"
                  data-type="Doctor" onclick="switchTab('Doctor')">👨‍⚕️ Doctor Appointment</button>
        </div>

        <form action="BookingServlet" method="post" onsubmit="return validateForm('bookingForm')" id="bookingForm">
          <input type="hidden" name="bookingType" id="bookingType" value="<%= preType!=null?preType:"Bed" %>">

         
          <div class="grid-2">
            <div class="form-group">
              <label>Patient Name <span style="color:var(--danger)">*</span></label>
              <input type="text" name="patientName" class="form-control" value="<%= loggedUser.getName() %>" required>
            </div>
            <div class="form-group">
              <label>Contact Number <span style="color:var(--danger)">*</span></label>
              <input type="tel" name="contact" class="form-control"
                     value="<%= loggedUser.getPhone()!=null?loggedUser.getPhone():"" %>"
                     placeholder="10-digit mobile" required maxlength="10">
            </div>
          </div>
          <div class="form-group">
            <label>Email Address <span style="color:var(--danger)">*</span></label>
            <input type="email" name="patientEmail" class="form-control" value="<%= loggedUser.getEmail() %>" required>
          </div>

       
          <div class="form-group">
            <label>Select Hospital <span style="color:var(--danger)">*</span></label>
            <select name="hospitalId" id="hospitalSelect" class="form-control" required
                    onchange="onHospitalChange(this.value)">
              <option value="">-- Select Hospital --</option>
              <% for (Hospital h : hospitals) { %>
                <option value="<%= h.getId() %>" <%= (preHosp!=null&&h.getId()==preHosp.getId())?"selected":"" %>>
                  <%= h.getName() %> (Beds: <%= h.getAvailableBeds() %>, ICU: <%= h.getAvailableIcu() %>)
                </option>
              <% } %>
            </select>
          </div>

        
          <div class="form-group">
            <label>Booking Date <span style="color:var(--danger)">*</span></label>
            <input type="date" name="bookingDate" class="form-control" required
                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
          </div>

        
          <div class="type-section" id="doctorSection">
            <div class="form-group">
              <label>Select Doctor <span style="color:var(--danger)">*</span></label>
              <select name="doctorId" id="doctorSelect" class="form-control">
                <option value="">-- Select Hospital First --</option>
                <% for (Doctor d : preDoctors) { %>
                  <option value="<%= d.getId() %>">
                    <%= d.getName() %> — <%= d.getSpecialization() %> (<%= d.getExperience() %>y)
                  </option>
                <% } %>
              </select>
            </div>
          </div>

        
          <div class="type-section" id="bedSection">
            <div class="alert alert-info">
              ℹ️ An available bed will be automatically assigned upon confirmation.
            </div>
          </div>

      
          <div class="type-section" id="icuSection">
            <div class="alert alert-warning">
              ⚠️ ICU bookings are for critical care only. Our staff will verify and confirm.
            </div>
          </div>

     
          <div class="form-group">
            <label>Additional Notes (optional)</label>
            <textarea name="notes" class="form-control" rows="3" placeholder="Any specific requirements or symptoms…"></textarea>
          </div>

          <button type="submit" class="btn btn-primary btn-lg" style="width:100%;justify-content:center">
            Confirm Booking ✓
          </button>
        </form>

      </div>
    </div>
  </div>
</section>

<footer><p>© 2026 AmritCare</p></footer>
<button class="voice-btn" id="voiceBtn" title="Voice Assistant">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>

<script src="js/main.js"></script>
<script>
  function switchTab(type) {
    document.querySelectorAll('.booking-tab').forEach(t => t.classList.remove('active'));
    document.querySelector(`.booking-tab[data-type="${type}"]`).classList.add('active');
    document.getElementById('bookingType').value = type;
    document.getElementById('bedSection').style.display    = type==='Bed'    ? 'block':'none';
    document.getElementById('icuSection').style.display    = type==='ICU'    ? 'block':'none';
    document.getElementById('doctorSection').style.display = type==='Doctor' ? 'block':'none';
  }

  function onHospitalChange(hospitalId) {
    const type = document.getElementById('bookingType').value;
    if (type === 'Doctor' && hospitalId) loadDoctors(hospitalId);
  }

  // Init on load
  const initType = '<%= preType!=null?preType:"Bed" %>';
  switchTab(initType);
  <% if (preHospId != null) { %>
    if (initType === 'Doctor') loadDoctors('<%= preHospId %>');
  <% } %>
</script>
</body>
</html>
