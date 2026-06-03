# 🏥 AmritCare — Intelligent City-Wide Smart Healthcare Management System

<div align="center">

![AmritCare Banner](https://img.shields.io/badge/AmritCare-Healthcare%20System-blue?style=for-the-badge&logo=heart&logoColor=white)

[![Java](https://img.shields.io/badge/Java-Servlet%20%2B%20JSP-orange?style=flat-square&logo=java)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com)
[![Apache Tomcat](https://img.shields.io/badge/Apache-Tomcat%209-yellow?style=flat-square&logo=apache)](https://tomcat.apache.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![MCA Project](https://img.shields.io/badge/MCA-Minor%20Project-purple?style=flat-square)](https://www.rgpv.ac.in)

> A centralized full-stack web application connecting **hospitals**, **patients**, and **ambulance services** across a city with real-time resource tracking, instant booking, and voice assistant support.

**[📋 Project Report](#-project-report) • [⚙️ Setup](#️-installation--setup) • [📁 Structure](#-project-structure)**

</div>

---

## 📌 Table of Contents

- [About the Project](#-about-the-project)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Installation & Setup](#️-installation--setup)
- [Demo Credentials](#-demo-credentials)
- [Screenshots](#-screenshots)
- [APIs & Libraries Used](#-apis--libraries-used)
- [Contributors](#-contributors)

---

## 🏥 About the Project

**AmritCare** is a **City-Wide Smart Healthcare Management System** developed as a Minor Project for **MCA (Master of Computer Application)** at **SGSITS, Indore** under **RGPV, Bhopal**.

The system solves real-world problems faced in city healthcare:

- 🔴 Patients visit hospitals **without knowing bed/ICU availability**
- 🔴 Hospital resources are **managed manually** causing errors
- 🔴 **No centralized platform** for city-wide health monitoring
- 🔴 Ambulance dispatch is **uncoordinated**

AmritCare solves all of these with one unified platform.

---

## ✨ Features

### 👤 Patient Module
- ✅ Register & Login with session management
- ✅ Search hospitals by name, location, specialization
- ✅ View **real-time** bed, ICU, doctor availability
- ✅ Book Bed / ICU / Doctor Appointment instantly
- ✅ Personal dashboard with booking history & status

### 🏥 Hospital Admin Module
- ✅ Manage patient bookings (Confirm / Cancel / Complete)
- ✅ Add, remove, toggle doctor availability
- ✅ Update individual bed & ICU unit status

### 🌆 City Admin Module
- ✅ City-wide resource overview dashboard
- ✅ Add / Deactivate hospitals
- ✅ View all bookings across all hospitals
- ✅ Analytics with interactive Chart.js graphs

### 🚑 Ambulance Module
- ✅ Canvas-based city map with ambulance positions
- ✅ Color-coded status (🟢 Available / 🔴 On Call / 🟡 Returning)
- ✅ Nearest hospitals with live bed & ICU counts
- ✅ Emergency 108 call button

### 🎤 Voice Assistant
- ✅ Web Speech API powered
- ✅ Commands: *"show hospitals"*, *"book bed"*, *"open dashboard"*, *"ambulance"*, *"logout"*
- ✅ Audio feedback with SpeechSynthesis

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | HTML5, CSS3, JavaScript (ES6+) |
| **Backend** | Java Servlet 4.0, JSP |
| **Database** | MySQL 8.0 |
| **Server** | Apache Tomcat 9 |
| **JDBC** | mysql-connector-j-8.x.x |
| **Charts** | Chart.js 4.4.0 (CDN) |
| **Fonts** | Google Fonts (Playfair Display, DM Sans) |
| **Voice** | Web Speech API (Browser built-in) |
| **Map** | HTML5 Canvas API |
| **Architecture** | MVC + DAO Pattern |

---

## 📁 Project Structure

```
AmritCare/
│
├── 📂 sql/
│   └── amritcare_schema.sql          ← Run this first in MySQL
│
├── 📂 src/main/
│   ├── 📂 java/com/amritcare/
│   │   │
│   │   ├── 📂 model/                 ← POJO / Entity classes
│   │   │   ├── User.java
│   │   │   ├── Hospital.java
│   │   │   ├── Doctor.java
│   │   │   ├── Booking.java
│   │   │   └── Ambulance.java
│   │   │
│   │   ├── 📂 dao/                   ← Database Access Objects
│   │   │   ├── UserDAO.java
│   │   │   ├── HospitalDAO.java
│   │   │   ├── DoctorDAO.java
│   │   │   ├── BookingDAO.java
│   │   │   └── AmbulanceDAO.java
│   │   │
│   │   ├── 📂 servlet/               ← Controller layer
│   │   │   ├── LoginServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── BookingServlet.java
│   │   │   ├── HospitalServlet.java
│   │   │   └── LogoutServlet.java
│   │   │
│   │   └── 📂 util/
│   │       └── DBConnection.java     ← JDBC Singleton
│   │
│   └── 📂 webapp/
│       ├── 📂 css/
│       │   └── style.css             ← Main stylesheet
│       │
│       ├── 📂 js/
│       │   └── main.js               ← Voice Assistant + AJAX
│       │
│       ├── index.jsp                 ← Home page
│       ├── login.jsp                 ← Login
│       ├── register.jsp              ← Registration
│       ├── hospitals.jsp             ← Hospital listing
│       ├── booking.jsp               ← Booking form
│       ├── dashboard.jsp             ← Patient dashboard
│       │
│       ├── hospital_dashboard.jsp    ← Hospital admin
│       ├── manage_resources.jsp      ← Bed/ICU management
│       ├── manage_doctors.jsp        ← Doctor management
│       │
│       ├── admin_dashboard.jsp       ← City admin
│       ├── manage_hospitals.jsp      ← Hospital management
│       ├── reports.jsp               ← Analytics & Charts
│       │
│       ├── ambulance.jsp             ← Ambulance tracking
│       ├── error.jsp                 ← Error page
│       │
│       └── 📂 WEB-INF/
│           └── web.xml               ← Deployment descriptor
│
└── README.md
```

---

## 🗄 Database Schema

**7 Tables:**

```sql
users        → id, name, email, password, phone, role, hospital_id
hospital     → id, name, location, contact, specialization, rating, total_beds, total_icu, latitude, longitude
doctor       → id, hospital_id, name, specialization, qualification, experience, availability, schedule
bed          → id, hospital_id, bed_number, type, status
icu          → id, hospital_id, unit_number, status
booking      → booking_id, patient_name, patient_email, contact, hospital_id, doctor_id, bed_id, icu_id, booking_type, booking_date, status
ambulance    → id, vehicle_number, driver_name, contact, current_lat, current_lng, status, hospital_id
```

**Relationships:**

```
hospital ──< doctor
hospital ──< bed
hospital ──< icu
hospital ──< booking
hospital ──< ambulance
doctor   ──< booking
bed      ──< booking
icu      ──< booking
```

---

## ⚙️ Installation & Setup

### Prerequisites

Make sure you have these installed:

- ✅ [JDK 8+](https://www.oracle.com/java/technologies/downloads/)
- ✅ [Apache Tomcat 9](https://tomcat.apache.org/download-90.cgi)
- ✅ [MySQL 8.0+](https://dev.mysql.com/downloads/mysql/)
- ✅ [Eclipse IDE](https://www.eclipse.org/downloads/) (recommended)
- ✅ [mysql-connector-j JAR](https://dev.mysql.com/downloads/connector/j/)

---

### Step 1 — Clone the Repository

```bash
git clone https://github.com/yourusername/AmritCare.git
cd AmritCare
```

---

### Step 2 — Setup Database

Open MySQL and run:

```bash
mysql -u root -p
```

```sql
SOURCE /path/to/AmritCare/sql/amritcare_schema.sql;
```

Verify:

```sql
USE amritcare;
SHOW TABLES;
```

You should see 7 tables with sample data already loaded.

---

### Step 3 — Configure Database Connection

Open `src/main/java/com/amritcare/util/DBConnection.java` and update:

```java
private static final String URL      = "jdbc:mysql://localhost:3306/amritcare";
private static final String USERNAME = "root";        // ← your username
private static final String PASSWORD = "yourpassword"; // ← your password
```

---

### Step 4 — Add MySQL Connector JAR

Copy `mysql-connector-j-8.x.x.jar` into:

```
src/main/webapp/WEB-INF/lib/
```

---

### Step 5 — Import in Eclipse

```
1. File → Import → Existing Projects into Workspace
2. Select AmritCare folder
3. Right click project → Build Path → Add JAR (mysql connector)
4. Right click project → Properties → Targeted Runtimes → Apache Tomcat 9
```

---

### Step 6 — Run on Tomcat

```
Right click project → Run As → Run on Server → Apache Tomcat 9
```

Open browser:

```
http://localhost:8080/AmritCare/
```

---

## 🔑 Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| 🧑‍💼 City Admin | admin@amritcare.in | admin123 |
| 🏥 Hospital Admin | aiims@amritcare.in | hospital123 |
| 🏥 Hospital Admin | hamidia@amritcare.in | hospital123 |
| 👤 Patient | patient@amritcare.in | patient123 |

---

## 📸 Screenshots

> Add your screenshots in a `/screenshots` folder and update paths below.

| Page | Preview |
|------|---------|
| 🏠 Home Page | `screenshots/home.png` |
| 🏥 Hospital Listing | `screenshots/hospitals.png` |
| 📅 Booking Form | `screenshots/booking.png` |
| 📊 Patient Dashboard | `screenshots/dashboard.png` |
| 🚑 Ambulance Tracking | `screenshots/ambulance.png` |
| 📈 Admin Reports | `screenshots/reports.png` |

---

## 📦 APIs & Libraries Used

### 🖥️ Frontend (Browser)

| Name | Type | Purpose |
|------|------|---------|
| Web Speech API | Browser Built-in API | Voice assistant — speech to text |
| Canvas API | Browser Built-in API | Ambulance map drawing |
| Fetch API | Browser Built-in API | AJAX hospital search |
| Geolocation API | Browser Built-in API | User location detection |
| Chart.js 4.4.0 | JavaScript Library (CDN) | Admin analytics charts |
| Google Fonts | CSS Library (CDN) | Playfair Display + DM Sans fonts |

### ⚙️ Backend (Server)

| Name | Type | Purpose |
|------|------|---------|
| JDBC API | Java API | MySQL database connection |
| Servlet API | Java API | HTTP request handling |
| JSP API | Java API | Dynamic HTML rendering |
| MySQL Connector/J | Java Library (JAR) | Java to MySQL driver |

---

## 🏗️ Architecture

```
Browser (HTML + CSS + JS + JSP)
           ↕ HTTP
    Tomcat Servlet Container
     (LoginServlet, BookingServlet...)
           ↕ JDBC
      MySQL Database (amritcare)
```

**Pattern:** MVC (Model View Controller)
- **Model** → Java POJOs + DAO classes
- **View** → JSP pages + CSS + JavaScript  
- **Controller** → Java Servlets

---

## 👥 Contributors

| Name | Enrollment No. | Role |
|------|---------------|------|
| Pranav Pratap Singh Sisodiya | 0801CA251099 | Full Stack Development |
| Uttam Carpenter | 0801CA251143 |  Backend |
| Nitish Kumar | 0801CA251091 | Database  |
| Ramdev Thpak | 0801CA251 | Frontend & UI Design |

**Project Guide:** Ms. Shweta Gupta, Asst. Professor 
**Department:** Computer Technology and Application  
**Institute:** SGSITS, Indore  
**University:** RGPV, Bhopal  
**Session:** 2025–26

---

## 📋 Project Report

The complete project report is available in the repository:
```
AmritCare_Project_Report.docx
```

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ for MCA Minor Project — SGSITS Indore

⭐ **Star this repo if you found it helpful!** ⭐

</div>
