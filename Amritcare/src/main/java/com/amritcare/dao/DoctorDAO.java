package com.amritcare.dao;

import com.amritcare.model.Doctor;
import com.amritcare.util.DBConnection;

import java.sql.*;
import java.util.*;

public class DoctorDAO {

    private Doctor map(ResultSet rs) throws SQLException {
        Doctor d = new Doctor();
        d.setId(rs.getInt("id"));
        d.setHospitalId(rs.getInt("hospital_id"));
        d.setName(rs.getString("name"));
        d.setSpecialization(rs.getString("specialization"));
        d.setQualification(rs.getString("qualification"));
        d.setExperience(rs.getInt("experience"));
        d.setAvailability(rs.getString("availability"));
        d.setSchedule(rs.getString("schedule"));
        try { d.setHospitalName(rs.getString("hospital_name")); } catch (SQLException ignored) {}
        return d;
    }

    public List<Doctor> getDoctorsByHospital(int hospitalId) {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT * FROM doctor WHERE hospital_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hospitalId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Doctor> getAvailableDoctors(int hospitalId) {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT * FROM doctor WHERE hospital_id = ? AND availability = 'available'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, hospitalId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addDoctor(Doctor d) {
        String sql = "INSERT INTO doctor (hospital_id, name, specialization, qualification, experience, schedule) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, d.getHospitalId());
            ps.setString(2, d.getName());
            ps.setString(3, d.getSpecialization());
            ps.setString(4, d.getQualification());
            ps.setInt(5, d.getExperience());
            ps.setString(6, d.getSchedule());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateAvailability(int id, String availability) {
        String sql = "UPDATE doctor SET availability = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, availability); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteDoctor(int id) {
        String sql = "DELETE FROM doctor WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
