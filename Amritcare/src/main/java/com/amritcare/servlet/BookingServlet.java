package com.amritcare.servlet;

import com.amritcare.dao.BookingDAO;
import com.amritcare.model.Booking;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String patientName  = req.getParameter("patientName").trim();
        String patientEmail = req.getParameter("patientEmail").trim();
        String contact      = req.getParameter("contact").trim();
        String bookingType  = req.getParameter("bookingType");
        String bookingDate  = req.getParameter("bookingDate");
        String notes        = req.getParameter("notes");
        int hospitalId      = Integer.parseInt(req.getParameter("hospitalId"));

        Booking booking = new Booking();
        booking.setPatientName(patientName);
        booking.setPatientEmail(patientEmail);
        booking.setContact(contact);
        booking.setHospitalId(hospitalId);
        booking.setBookingType(bookingType);
        booking.setBookingDate(bookingDate);
        booking.setNotes(notes);

        // Set type-specific IDs
        try {
            if ("Doctor".equals(bookingType)) {
                booking.setDoctorId(Integer.parseInt(req.getParameter("doctorId")));
            } else if ("Bed".equals(bookingType)) {
                booking.setBedId(Integer.parseInt(req.getParameter("bedId")));
            } else if ("ICU".equals(bookingType)) {
                booking.setIcuId(Integer.parseInt(req.getParameter("icuId")));
            }
        } catch (NumberFormatException ignored) {}

        BookingDAO dao = new BookingDAO();
        int bookingId  = dao.createBooking(booking);

        if (bookingId > 0) {
            req.setAttribute("success", "Booking confirmed! Your Booking ID is #" + bookingId);
            req.setAttribute("bookingId", bookingId);
        } else {
            req.setAttribute("error", "Booking failed. Please try again.");
        }
        req.getRequestDispatcher("dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Handle status update (hospital admin)
        String action    = req.getParameter("action");
        String bookingId = req.getParameter("id");
        String status    = req.getParameter("status");

        if ("updateStatus".equals(action) && bookingId != null && status != null) {
            BookingDAO dao = new BookingDAO();
            dao.updateStatus(Integer.parseInt(bookingId), status);
        }
        resp.sendRedirect(req.getHeader("Referer"));
    }
}
