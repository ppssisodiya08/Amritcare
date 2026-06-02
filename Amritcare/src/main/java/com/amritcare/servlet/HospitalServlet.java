package com.amritcare.servlet;

import com.amritcare.dao.HospitalDAO;
import com.amritcare.dao.DoctorDAO;
import com.amritcare.model.Hospital;
import com.amritcare.model.Doctor;


import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/HospitalServlet")
public class HospitalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("search".equals(action)) {
            // Return JSON list of hospitals for AJAX search
            String keyword = req.getParameter("q");
            HospitalDAO dao = new HospitalDAO();
            List<Hospital> hospitals = (keyword != null && !keyword.isEmpty())
                    ? dao.searchHospitals(keyword)
                    : dao.getAllHospitals();

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print(hospitalsToJson(hospitals));
            out.flush();

        } else if ("doctors".equals(action)) {
            // Return doctors for a specific hospital
            int hospitalId = Integer.parseInt(req.getParameter("hospitalId"));
            DoctorDAO dao = new DoctorDAO();
            List<Doctor> doctors = dao.getAvailableDoctors(hospitalId);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            PrintWriter out = resp.getWriter();
            out.print(doctorsToJson(doctors));
            out.flush();

        } else {
            // Default: forward to hospitals JSP
            HospitalDAO dao = new HospitalDAO();
            req.setAttribute("hospitals", dao.getAllHospitals());
            req.getRequestDispatcher("hospitals.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Add hospital (city admin)
        String action = req.getParameter("action");
        if ("add".equals(action)) {
            Hospital h = new Hospital();
            h.setName(req.getParameter("name"));
            h.setLocation(req.getParameter("location"));
            h.setContact(req.getParameter("contact"));
            h.setSpecialization(req.getParameter("specialization"));
            h.setTotalBeds(Integer.parseInt(req.getParameter("totalBeds")));
            h.setTotalIcu(Integer.parseInt(req.getParameter("totalIcu")));
            try {
                h.setLatitude(Double.parseDouble(req.getParameter("latitude")));
                h.setLongitude(Double.parseDouble(req.getParameter("longitude")));
            } catch (Exception ignored) {}

            HospitalDAO dao = new HospitalDAO();
            if (dao.addHospital(h)) {
                req.setAttribute("success", "Hospital added successfully!");
            } else {
                req.setAttribute("error", "Failed to add hospital.");
            }
        }
        resp.sendRedirect("manage_hospitals.jsp");
    }

    // ── JSON serialization helpers ───────────────────────────────
    private String hospitalsToJson(List<Hospital> hospitals) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < hospitals.size(); i++) {
            Hospital h = hospitals.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
              .append("\"id\":").append(h.getId()).append(",")
              .append("\"name\":\"").append(esc(h.getName())).append("\",")
              .append("\"location\":\"").append(esc(h.getLocation())).append("\",")
              .append("\"contact\":\"").append(esc(h.getContact())).append("\",")
              .append("\"specialization\":\"").append(esc(h.getSpecialization())).append("\",")
              .append("\"rating\":").append(h.getRating()).append(",")
              .append("\"availableBeds\":").append(h.getAvailableBeds()).append(",")
              .append("\"availableIcu\":").append(h.getAvailableIcu()).append(",")
              .append("\"availableDoctors\":").append(h.getAvailableDoctors()).append(",")
              .append("\"lat\":").append(h.getLatitude()).append(",")
              .append("\"lng\":").append(h.getLongitude())
              .append("}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String doctorsToJson(List<Doctor> doctors) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < doctors.size(); i++) {
            Doctor d = doctors.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
              .append("\"id\":").append(d.getId()).append(",")
              .append("\"name\":\"").append(esc(d.getName())).append("\",")
              .append("\"specialization\":\"").append(esc(d.getSpecialization())).append("\",")
              .append("\"qualification\":\"").append(esc(d.getQualification())).append("\",")
              .append("\"experience\":").append(d.getExperience()).append(",")
              .append("\"schedule\":\"").append(esc(d.getSchedule())).append("\"")
              .append("}");
        }
        sb.append("]");
        return sb.toString();
    }

    private String esc(String s) {
        return s == null ? "" : s.replace("\"", "\\\"").replace("\n", "\\n");
    }
}
