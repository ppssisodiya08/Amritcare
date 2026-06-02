/* ============================================================
   AmritCare — Main JavaScript
   Features: Voice Assistant, AJAX Hospital Search, Animations
   ============================================================ */

/* ── Voice Assistant ─────────────────────────── */
const VoiceAssistant = (() => {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SpeechRecognition) return null;

  const recognition = new SpeechRecognition();
  recognition.lang = 'en-IN';
  recognition.interimResults = false;

  const btn     = document.getElementById('voiceBtn');
  const tooltip = document.getElementById('voiceTooltip');
  let   active  = false;

  const commands = {
    'show hospitals'   : () => (window.location.href = 'hospitals.jsp'),
    'find hospitals'   : () => (window.location.href = 'hospitals.jsp'),
    'book bed'         : () => (window.location.href = 'booking.jsp?type=Bed'),
    'book icu'         : () => (window.location.href = 'booking.jsp?type=ICU'),
    'book doctor'      : () => (window.location.href = 'booking.jsp?type=Doctor'),
    'open dashboard'   : () => (window.location.href = 'dashboard.jsp'),
    'my dashboard'     : () => (window.location.href = 'dashboard.jsp'),
    'ambulance'        : () => (window.location.href = 'ambulance.jsp'),
    'track ambulance'  : () => (window.location.href = 'ambulance.jsp'),
    'go home'          : () => (window.location.href = 'index.jsp'),
    'home'             : () => (window.location.href = 'index.jsp'),
    'login'            : () => (window.location.href = 'login.jsp'),
    'register'         : () => (window.location.href = 'register.jsp'),
    'logout'           : () => (window.location.href = 'LogoutServlet'),
    'help'             : () => showTooltip('Commands: show hospitals, book bed, book icu, book doctor, open dashboard, ambulance, go home, login'),
  };

  function showTooltip(msg) {
    if (!tooltip) return;
    tooltip.textContent = msg;
    tooltip.classList.add('show');
    setTimeout(() => tooltip.classList.remove('show'), 3500);
  }

  function speak(text) {
    const utter = new SpeechSynthesisUtterance(text);
    utter.lang = 'en-IN';
    utter.rate = 1.0;
    window.speechSynthesis.speak(utter);
  }

  recognition.onresult = (e) => {
    const transcript = e.results[0][0].transcript.toLowerCase().trim();
    showTooltip('You said: "' + transcript + '"');

    let matched = false;
    for (const [cmd, action] of Object.entries(commands)) {
      if (transcript.includes(cmd)) {
        matched = true;
        speak('Opening ' + cmd);
        setTimeout(action, 800);
        break;
      }
    }
    if (!matched) {
      speak('Sorry, I did not understand. Try saying show hospitals or book bed.');
      showTooltip('❓ Not recognized. Try: "show hospitals", "book bed"');
    }
  };

  recognition.onend = () => {
    active = false;
    if (btn) { btn.classList.remove('listening'); btn.textContent = '🎤'; }
  };

  recognition.onerror = (e) => {
    active = false;
    if (btn) { btn.classList.remove('listening'); btn.textContent = '🎤'; }
    showTooltip('Microphone error: ' + e.error);
  };

  function toggle() {
    if (active) {
      recognition.stop();
      active = false;
      if (btn) { btn.classList.remove('listening'); btn.textContent = '🎤'; }
    } else {
      recognition.start();
      active = true;
      if (btn) { btn.classList.add('listening'); btn.textContent = '⏹'; }
      showTooltip('🎤 Listening… say a command');
    }
  }

  if (btn) btn.addEventListener('click', toggle);

  return { toggle, speak, showTooltip };
})();

/* ── Hospital AJAX Search ────────────────────── */
function initHospitalSearch() {
  const searchInput = document.getElementById('hospitalSearch');
  const gridEl      = document.getElementById('hospitalsGrid');
  if (!searchInput || !gridEl) return;

  let debounceTimer;

  searchInput.addEventListener('input', () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
      const q = searchInput.value.trim();
      gridEl.innerHTML = '<div class="spinner"></div>';

      fetch('HospitalServlet?action=search&q=' + encodeURIComponent(q))
        .then(r => r.json())
        .then(hospitals => renderHospitals(hospitals, gridEl))
        .catch(() => { gridEl.innerHTML = '<p class="text-center text-muted">Error loading hospitals.</p>'; });
    }, 350);
  });
}

function renderHospitals(hospitals, container) {
  if (!hospitals.length) {
    container.innerHTML = '<p class="text-center text-muted mt-3">No hospitals found.</p>';
    return;
  }

  container.innerHTML = hospitals.map(h => `
    <div class="hospital-card fade-in">
      <div class="hcard-header">
        <div>
          <div class="hcard-name">🏥 ${h.name}</div>
          <div class="hcard-loc">📍 ${h.location}</div>
        </div>
        <div class="rating-stars">${starRating(h.rating)} <small>${h.rating}</small></div>
      </div>
      <div class="hcard-body">
        <div class="specialization-tags">
          ${(h.specialization || '').split(',').slice(0,3).map(s => `<span class="spec-tag">${s.trim()}</span>`).join('')}
        </div>
        <div class="resource-badges">
          <div class="resource-badge">
            <div class="rb-count" style="color:${h.availableBeds>0?'var(--success)':'var(--danger)'}">${h.availableBeds}</div>
            <div class="rb-label">Beds</div>
          </div>
          <div class="resource-badge">
            <div class="rb-count" style="color:${h.availableIcu>0?'var(--primary)':'var(--danger)'}">${h.availableIcu}</div>
            <div class="rb-label">ICU</div>
          </div>
          <div class="resource-badge">
            <div class="rb-count" style="color:${h.availableDoctors>0?'var(--success)':'var(--danger)'}">${h.availableDoctors}</div>
            <div class="rb-label">Doctors</div>
          </div>
        </div>
        <p style="font-size:0.83rem;color:var(--muted)">📞 ${h.contact}</p>
      </div>
      <div class="hcard-actions">
        <a href="booking.jsp?hospitalId=${h.id}&type=Bed"    class="btn btn-primary btn-sm">🛏 Bed</a>
        <a href="booking.jsp?hospitalId=${h.id}&type=ICU"    class="btn btn-outline btn-sm">🏥 ICU</a>
        <a href="booking.jsp?hospitalId=${h.id}&type=Doctor" class="btn btn-success btn-sm">👨‍⚕️ Doctor</a>
      </div>
    </div>
  `).join('');
}

function starRating(r) {
  const full  = Math.floor(r);
  const half  = r % 1 >= 0.5 ? 1 : 0;
  const empty = 5 - full - half;
  return '★'.repeat(full) + (half ? '½' : '') + '☆'.repeat(empty);
}

/* ── Doctor Dropdown (Booking Page) ─────────── */
function loadDoctors(hospitalId) {
  const docSelect = document.getElementById('doctorSelect');
  if (!docSelect) return;
  docSelect.innerHTML = '<option value="">Loading...</option>';

  fetch('HospitalServlet?action=doctors&hospitalId=' + hospitalId)
    .then(r => r.json())
    .then(docs => {
      if (!docs.length) {
        docSelect.innerHTML = '<option value="">No available doctors</option>';
        return;
      }
      docSelect.innerHTML = '<option value="">-- Select Doctor --</option>' +
        docs.map(d => `<option value="${d.id}">${d.name} — ${d.specialization} (${d.experience}y exp)</option>`).join('');
    });
}

/* ── Booking Form Tabs ───────────────────────── */
function initBookingTabs() {
  const tabs    = document.querySelectorAll('.booking-tab');
  const typeInp = document.getElementById('bookingType');
  const bedSec  = document.getElementById('bedSection');
  const icuSec  = document.getElementById('icuSection');
  const docSec  = document.getElementById('doctorSection');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      const type = tab.dataset.type;
      if (typeInp) typeInp.value = type;

      [bedSec, icuSec, docSec].forEach(s => { if(s) s.style.display = 'none'; });

      if (type === 'Bed'    && bedSec) bedSec.style.display = 'block';
      if (type === 'ICU'    && icuSec) icuSec.style.display = 'block';
      if (type === 'Doctor' && docSec) {
        docSec.style.display = 'block';
        const hosp = document.getElementById('hospitalSelect');
        if (hosp && hosp.value) loadDoctors(hosp.value);
      }
    });
  });

  // Hospital change → reload doctors
  const hospSel = document.getElementById('hospitalSelect');
  if (hospSel) {
    hospSel.addEventListener('change', () => {
      if (typeInp && typeInp.value === 'Doctor') loadDoctors(hospSel.value);
    });
  }
}

/* ── Form Validation ─────────────────────────── */
function validateForm(formId) {
  const form = document.getElementById(formId);
  if (!form) return true;
  let valid = true;

  form.querySelectorAll('[required]').forEach(el => {
    el.classList.remove('error');
    if (!el.value.trim()) {
      el.classList.add('error');
      valid = false;
    }
  });

  // Email validation
  const email = form.querySelector('input[type=email]');
  if (email && email.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
    email.classList.add('error');
    valid = false;
  }

  // Phone validation
  const phone = form.querySelector('input[name=phone], input[name=contact]');
  if (phone && phone.value && !/^\d{10}$/.test(phone.value.replace(/\s/g, ''))) {
    phone.classList.add('error');
    valid = false;
  }

  if (!valid) {
    showAlert('Please fill in all required fields correctly.', 'danger');
  }
  return valid;
}

/* ── Alert Helper ────────────────────────────── */
function showAlert(msg, type = 'info') {
  const icons = { success: '✅', danger: '❌', info: 'ℹ️', warning: '⚠️' };
  const div = document.createElement('div');
  div.className = `alert alert-${type} fade-in`;
  div.innerHTML = `<span>${icons[type] || 'ℹ️'}</span> ${msg}`;

  const container = document.querySelector('.alert-container') || document.querySelector('.dashboard-content') || document.body;
  container.prepend(div);
  setTimeout(() => div.remove(), 5000);
}

/* ── Scroll Animations ───────────────────────── */
function initScrollAnimations() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
      if (e.isIntersecting) {
        e.target.classList.add('fade-in');
        observer.unobserve(e.target);
      }
    });
  }, { threshold: 0.1 });

  document.querySelectorAll('.hospital-card, .stat-card, .card').forEach(el => {
    observer.observe(el);
  });
}

/* ── Counter Animation ───────────────────────── */
function animateCounters() {
  document.querySelectorAll('.stat-value[data-target]').forEach(el => {
    const target = parseInt(el.dataset.target);
    let current  = 0;
    const step   = Math.ceil(target / 50);
    const timer  = setInterval(() => {
      current = Math.min(current + step, target);
      el.textContent = current.toLocaleString();
      if (current >= target) clearInterval(timer);
    }, 30);
  });
}

/* ── Init ────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  initHospitalSearch();
  initBookingTabs();
  initScrollAnimations();
  animateCounters();

  // Auto-close alerts
  document.querySelectorAll('.alert').forEach(a => {
    setTimeout(() => a.style.opacity = '0', 4000);
    setTimeout(() => a.remove(), 4500);
  });

  // URL param: pre-select booking type
  const params = new URLSearchParams(window.location.search);
  const type   = params.get('type');
  if (type) {
    const tab = document.querySelector(`.booking-tab[data-type="${type}"]`);
    if (tab) tab.click();
  }
});
