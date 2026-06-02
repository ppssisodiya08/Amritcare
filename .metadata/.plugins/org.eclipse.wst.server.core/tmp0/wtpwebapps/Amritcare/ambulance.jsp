<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.amritcare.dao.*,com.amritcare.model.*,java.util.List" %>
<%
    AmbulanceDAO aDao = new AmbulanceDAO();
    HospitalDAO  hDao = new HospitalDAO();
    List<Ambulance> ambulances = aDao.getAllAmbulances();
    List<Hospital>  hospitals  = hDao.getAllHospitals();
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ambulance Tracking — AmritCare</title>
  <link rel="stylesheet" href="css/style.css">
  <style>
    #mapContainer { height: 500px; border-radius: var(--radius); overflow:hidden; background:#e8f4f8; position:relative; }
    .map-placeholder {
      width:100%; height:100%;
      background: linear-gradient(135deg, #d0e8f2 0%, #b8daf0 100%);
      display:flex; flex-direction:column; align-items:center; justify-content:center;
      color: var(--primary-dark);
    }
    .sim-canvas { position:absolute; top:0; left:0; width:100%; height:100%; }
    .status-available { color: var(--success); }
    .status-on_call   { color: var(--danger); }
    .status-returning { color: var(--warning); }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="index.jsp" class="navbar-brand"><span class="logo-icon">🏥</span> AmritCare</a>
  <ul class="nav-links">
    <li><a href="index.jsp">Home</a></li>
    <li><a href="HospitalServlet">Hospitals</a></li>
    <li><a href="ambulance.jsp" class="active">🚑 Ambulance</a></li>
    <% if (userName != null) { %>
      <li><a href="dashboard.jsp">Dashboard</a></li>
      <li><a href="LogoutServlet">Logout</a></li>
    <% } else { %>
      <li><a href="login.jsp">Login</a></li>
    <% } %>
  </ul>
</nav>

<div style="background:linear-gradient(135deg,#b71c1c,#ef233c);color:#fff;padding:2.5rem 2rem 2rem;">
  <div class="container">
    <h1 style="font-family:'Playfair Display',serif;font-size:2rem">🚑 Live Ambulance Tracking</h1>
    <p style="opacity:0.85">Real-time location of city ambulances — Bhopal</p>
  </div>
</div>

<section class="section">
  <div class="container">
    <div class="grid-2" style="gap:2rem;align-items:start">

      <!-- Map / Simulation -->
      <div>
        <div class="card">
          <div class="card-header">
            <strong>🗺️ Live Map</strong>
            <div style="display:flex;gap:8px;align-items:center;font-size:0.82rem">
              <span style="color:var(--success)">🟢 Available</span>
              <span style="color:var(--danger)">🔴 On Call</span>
              <span style="color:var(--warning)">🟡 Returning</span>
            </div>
          </div>
          <div id="mapContainer">
            <canvas class="sim-canvas" id="ambulanceCanvas"></canvas>
          </div>
        </div>
        <p style="font-size:0.8rem;color:var(--muted);margin-top:0.5rem;text-align:center">
          📍 Simulated map of Bhopal, Madhya Pradesh. Markers update every 3 seconds.
          <br>For production, integrate Google Maps API key.
        </p>
      </div>

      <!-- Ambulance List -->
      <div>
        <div class="card">
          <div class="card-header"><strong>🚑 Fleet Status (<%= ambulances.size() %> units)</strong></div>
          <div class="ambulance-list">
            <% for (Ambulance a : ambulances) { %>
            <div class="ambulance-item" onclick="focusAmbulance(<%= a.getId() %>)">
              <div class="amb-icon">🚑</div>
              <div style="flex:1">
                <div style="font-weight:600"><%= a.getVehicleNumber() %></div>
                <div style="font-size:0.82rem;color:var(--muted)">Driver: <%= a.getDriverName() %> · <%= a.getContact() %></div>
                <div style="font-size:0.82rem;color:var(--muted)">Base: <%= a.getHospitalName()!=null?a.getHospitalName():"—" %></div>
              </div>
              <div>
                <span class="badge <%= "available".equals(a.getStatus())?"badge-success":"on_call".equals(a.getStatus())?"badge-danger":"badge-warning" %>">
                  <%= a.getStatus().replace("_"," ").toUpperCase() %>
                </span>
              </div>
            </div>
            <% } %>
          </div>
        </div>

        <!-- Emergency Call Box -->
        <div class="card" style="margin-top:1.5rem;border-left:4px solid var(--danger)">
          <div class="card-body" style="text-align:center;padding:1.5rem">
            <div style="font-size:2.5rem;margin-bottom:0.75rem">🆘</div>
            <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.5rem;color:var(--danger)">Emergency?</h3>
            <p style="color:var(--muted);font-size:0.9rem;margin-bottom:1rem">Call our 24/7 ambulance dispatch immediately</p>
            <a href="tel:108" class="btn btn-danger btn-lg" style="width:100%;justify-content:center">📞 Call 108 — Ambulance</a>
            <p style="margin-top:0.75rem;font-size:0.8rem;color:var(--muted)">Free emergency service · Available 24/7</p>
          </div>
        </div>

        <!-- Nearest Hospitals -->
        <div class="card" style="margin-top:1.5rem">
          <div class="card-header"><strong>🏥 Nearest Hospitals</strong></div>
          <% int count=0; for (Hospital h : hospitals) { if(count++>=3) break; %>
          <div style="padding:12px 16px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:12px">
            <span style="font-size:1.5rem">🏥</span>
            <div style="flex:1">
              <div style="font-weight:600;font-size:0.9rem"><%= h.getName() %></div>
              <div style="font-size:0.8rem;color:var(--muted)"><%= h.getLocation() %></div>
            </div>
            <div style="text-align:right;font-size:0.82rem">
              <div style="color:var(--success);font-weight:600">🛏 <%= h.getAvailableBeds() %> beds</div>
              <div style="color:var(--primary)">🏥 <%= h.getAvailableIcu() %> ICU</div>
            </div>
          </div>
          <% } %>
        </div>
      </div>

    </div>
  </div>
</section>

<footer><p>© 2026 AmritCare — Emergency Helpline: 108</p></footer>

<button class="voice-btn" id="voiceBtn">🎤</button>
<div class="voice-tooltip" id="voiceTooltip"></div>
<script src="js/main.js"></script>

<script>
const canvas = document.getElementById('ambulanceCanvas');
const ctx    = canvas.getContext('2d');


function resizeCanvas() {
  const container = document.getElementById('mapContainer');
  canvas.width  = container.offsetWidth;
  canvas.height = container.offsetHeight;
}
resizeCanvas();
window.addEventListener('resize', () => { resizeCanvas(); drawMap(); });


const hospitals = [
  <% for (Hospital h : hospitals) { %>
  { name: "<%= h.getName().replace("\"","") %>", lat: <%= h.getLatitude() %>, lng: <%= h.getLongitude() %> },
  <% } %>
];

const ambulances = [
  <% for (Ambulance a : ambulances) { %>
  { id: <%= a.getId() %>, vehicle: "<%= a.getVehicleNumber() %>", lat: <%= a.getCurrentLat() %>, lng: <%= a.getCurrentLng() %>, status: "<%= a.getStatus() %>",
    vLat: (Math.random()-0.5)*0.0003, vLng: (Math.random()-0.5)*0.0003 },
  <% } %>
];


const mapBounds = { minLat:23.18, maxLat:23.32, minLng:77.36, maxLng:77.52 };

function latLngToXY(lat, lng) {
  const x = ((lng - mapBounds.minLng) / (mapBounds.maxLng - mapBounds.minLng)) * canvas.width;
  const y = ((mapBounds.maxLat - lat) / (mapBounds.maxLat - mapBounds.minLat)) * canvas.height;
  return { x, y };
}

function drawMap() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);


  const grad = ctx.createLinearGradient(0, 0, canvas.width, canvas.height);
  grad.addColorStop(0, '#d4e9f7');
  grad.addColorStop(1, '#c2ddf0');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, canvas.width, canvas.height);


  ctx.strokeStyle = '#b0c8dd'; ctx.lineWidth = 2;
  [0.3,0.5,0.7].forEach(r => {
    ctx.beginPath(); ctx.moveTo(0, canvas.height*r); ctx.lineTo(canvas.width, canvas.height*r); ctx.stroke();
    ctx.beginPath(); ctx.moveTo(canvas.width*r, 0); ctx.lineTo(canvas.width*r, canvas.height); ctx.stroke();
  });

  
  hospitals.forEach((h, i) => {
    const pos = latLngToXY(h.lat, h.lng);
    ctx.beginPath();
    ctx.arc(pos.x, pos.y, 14, 0, Math.PI*2);
    ctx.fillStyle = 'rgba(0,119,182,0.85)';
    ctx.fill();
    ctx.strokeStyle = '#fff'; ctx.lineWidth = 2; ctx.stroke();

    
    ctx.fillStyle = '#fff';
    ctx.font = 'bold 12px sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('H', pos.x, pos.y);

    
    ctx.fillStyle = '#023e8a';
    ctx.font = '10px DM Sans, sans-serif';
    ctx.fillText(h.name.split(' ')[0], pos.x, pos.y + 22);
  });

  
  ambulances.forEach(a => {
    const pos = latLngToXY(a.lat, a.lng);
    const color = a.status==='available' ? '#06d6a0' : a.status==='on_call' ? '#ef233c' : '#ffd166';

   
    ctx.beginPath();
    ctx.arc(pos.x+2, pos.y+2, 12, 0, Math.PI*2);
    ctx.fillStyle = 'rgba(0,0,0,0.15)';
    ctx.fill();

    ctx.beginPath();
    ctx.arc(pos.x, pos.y, 12, 0, Math.PI*2);
    ctx.fillStyle = color;
    ctx.fill();
    ctx.strokeStyle = '#fff'; ctx.lineWidth = 2; ctx.stroke();


    ctx.fillStyle = '#fff';
    ctx.font = '12px sans-serif';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('🚑', pos.x, pos.y);

   
    ctx.fillStyle = '#333';
    ctx.font = '9px sans-serif';
    ctx.fillText(a.vehicle.split('-').pop(), pos.x, pos.y + 20);
  });

  
  ctx.font = 'bold 11px sans-serif';
  [['#06d6a0','Available'],['#ef233c','On Call'],['#ffd166','Returning']].forEach(([c,l],i) => {
    ctx.beginPath(); ctx.arc(14, 14+i*20, 6, 0, Math.PI*2); ctx.fillStyle=c; ctx.fill();
    ctx.fillStyle='#333'; ctx.textAlign='left'; ctx.textBaseline='middle';
    ctx.fillText(l, 24, 14+i*20);
  });
}


function updateAmbulances() {
  ambulances.forEach(a => {
    a.lat += a.vLat + (Math.random()-0.5)*0.0001;
    a.lng += a.vLng + (Math.random()-0.5)*0.0001;
    
    if (a.lat < mapBounds.minLat || a.lat > mapBounds.maxLat) a.vLat *= -1;
    if (a.lng < mapBounds.minLng || a.lng > mapBounds.maxLng) a.vLng *= -1;
    a.lat = Math.max(mapBounds.minLat, Math.min(mapBounds.maxLat, a.lat));
    a.lng = Math.max(mapBounds.minLng, Math.min(mapBounds.maxLng, a.lng));
  });
  drawMap();
}


function focusAmbulance(id) {
  const a = ambulances.find(x => x.id === id);
  if (a) {
    
    const pos = latLngToXY(a.lat, a.lng);
    ctx.beginPath();
    ctx.arc(pos.x, pos.y, 25, 0, Math.PI*2);
    ctx.strokeStyle = '#ef233c';
    ctx.lineWidth = 3;
    ctx.stroke();
  }
}

drawMap();
setInterval(updateAmbulances, 2000);
</script>
</body>
</html>
