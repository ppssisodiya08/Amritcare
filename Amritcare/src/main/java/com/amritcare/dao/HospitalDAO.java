package com.amritcare.dao;

import com.amritcare.model.Hospital;
import com.amritcare.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HospitalDAO {

    /** Map a ResultSet row → Hospital object */
    private Hospital map(ResultSet rs) throws SQLException {
        Hospital h = new Hospital();
        h.setId(rs.getInt("id"));
        h.setName(rs.getString("name"));
        h.setLocation(rs.getString("location"));
        h.setContact(rs.getString("contact"));
        h.setSpecialization(rs.getString("specialization"));
        h.setRating(rs.getDouble("rating"));
        h.setTotalBeds(rs.getInt("total_beds"));
        h.setTotalIcu(rs.getInt("total_icu"));
        h.setLatitude(rs.getDouble("latitude"));
        h.setLongitude(rs.getDouble("longitude"));
        h.setStatus(rs.getString("status"));
        return h;
    }

    /** Get all active hospitals with live availability counts */
    public List<Hospital> getAllHospitals() {
        List<Hospital> list = new ArrayList<>();
        String sql = "SELECT h.*, " +
                     "(SELECT COUNT(*) FROM bed WHERE hospital_id=h.id AND status='available') AS avail_beds, " +
                     "(SELECT COUNT(*) FROM icu WHERE hospital_id=h.id AND status='available') AS avail_icu, " +
                     "(SELECT COUNT(*) FROM doctor WHERE hospital_id=h.id AND availability='available') AS avail_docs " +
                     "FROM hospital h WHERE h.status='active' ORDER BY h.rating DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Hospital h = map(rs);
                h.setAvailableBeds(rs.getInt("avail_beds"));
                h.setAvailableIcu(rs.getInt("avail_icu"));
                h.setAvailableDoctors(rs.getInt("avail_docs"));
                list.add(h);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Get single hospital by ID */
    public Hospital getHospitalById(int id) {
        String sql = "SELECT * FROM hospital WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /** Search hospitals by keyword (name, location, specialization) */
    public List<Hospital> searchHospitals(String keyword) {
        List<Hospital> list = new ArrayList<>();
        String sql = "SELECT h.*, " +
                     "(SELECT COUNT(*) FROM bed WHERE hospital_id=h.id AND status='available') AS avail_beds, " +
                     "(SELECT COUNT(*) FROM icu WHERE hospital_id=h.id AND status='available') AS avail_icu, " +
                     "(SELECT COUNT(*) FROM doctor WHERE hospital_id=h.id AND availability='available') AS avail_docs " +
                     "FROM hospital h WHERE h.status='active' AND " +
                     "(h.name LIKE ? OR h.location LIKE ? OR h.specialization LIKE ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            String kw = "%" + keyword + "%";
            ps.setString(1, kw); ps.setString(2, kw); ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Hospital h = map(rs);
                h.setAvailableBeds(rs.getInt("avail_beds"));
                h.setAvailableIcu(rs.getInt("avail_icu"));
                h.setAvailableDoctors(rs.getInt("avail_docs"));
                list.add(h);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /** Add a new hospital */
    public boolean addHospital(Hospital h) {
        String sql = "INSERT INTO hospital (name, location, contact, specialization, total_beds, total_icu, latitude, longitude) VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, h.getName());
            ps.setString(2, h.getLocation());
            ps.setString(3, h.getContact());
            ps.setString(4, h.getSpecialization());
            ps.setInt(5, h.getTotalBeds());
            ps.setInt(6, h.getTotalIcu());
            ps.setDouble(7, h.getLatitude());
            ps.setDouble(8, h.getLongitude());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Update hospital status */
    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE hospital SET status = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /** Total hospital count */
    public int getTotalHospitals() {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM hospital WHERE status='active'")) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
