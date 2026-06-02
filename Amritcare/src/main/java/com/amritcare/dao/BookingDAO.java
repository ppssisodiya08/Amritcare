package com.amritcare.dao;

import com.amritcare.model.Booking;
import com.amritcare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    private Booking map(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setBookingId(rs.getInt("booking_id"));
        b.setPatientName(rs.getString("patient_name"));
        b.setPatientEmail(rs.getString("patient_email"));
        b.setContact(rs.getString("contact"));
        b.setHospitalId(rs.getInt("hospital_id"));
        b.setBookingType(rs.getString("booking_type"));
        b.setBookingDate(rs.getString("booking_date"));
        b.setStatus(rs.getString("status"));
        b.setNotes(rs.getString("notes"));
        b.setCreatedAt(rs.getString("created_at"));
        // Joined fields (may be null)
        try { b.setHospitalName(rs.getString("hospital_name")); } catch (SQLException ignored) {}
        try { b.setDoctorName(rs.getString("doctor_name")); }   catch (SQLException ignored) {}
        return b;
    }

    /** Create a new booking. Returns booking_id or -1 */
    public int createBooking(Booking b) {
        String sql = "INSERT INTO booking (patient_name, patient_email, contact, hospital_id, " +
                     "doctor_id, bed_id, icu_id, booking_type, booking_date, notes, status) " +
                     "VALUES (?,?,?,?,?,?,?,?,?,?,'pending')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, b.getPatientName());
            ps.setString(2, b.getPatientEmail());
            ps.setString(3, b.getContact());
            ps.setInt(4, b.getHospitalId());
            ps.setObject(5, b.getDoctorId() > 0 ? b.getDoctorId() : null);
            ps.setObject(6, b.getBedId() > 0 ? b.getBedId() : null);
            ps.setObject(7, b.getIcuId() > 0 ? b.getIcuId() : null);
            ps.setString(8, b.getBookingType());
            ps.setString(9, b.getBookingDate());
            ps.setString(10, b.getNotes());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    /** Get all bookings for a patient by email */
    public List<Booking> getBookingsByEmail(String email) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.name AS hospital_name, d.name AS doctor_name " +
                     "FROM booking b JOIN hospital h ON b.hospital_id = h.id " +
                     "LEFT JOIN doctor d ON b.doctor_id = d.id " +
                     "WHERE b.patient_email = ? ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Get all bookings for a hospital */
    public List<Booking> getBookingsByHospital(int hospitalId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.name AS hospital_name, d.name AS doctor_name " +
                     "FROM booking b JOIN hospital h ON b.hospital_id = h.id " +
                     "LEFT JOIN doctor d ON b.doctor_id = d.id " +
                     "WHERE b.hospital_id = ? ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hospitalId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Get all bookings (city admin) */
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, h.name AS hospital_name, d.name AS doctor_name " +
                     "FROM booking b JOIN hospital h ON b.hospital_id = h.id " +
                     "LEFT JOIN doctor d ON b.doctor_id = d.id ORDER BY b.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Update booking status */
    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE booking SET status = ? WHERE booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Total booking count */
    public int getTotalBookings() {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM booking")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
