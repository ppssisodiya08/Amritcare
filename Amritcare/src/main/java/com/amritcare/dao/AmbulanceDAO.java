package com.amritcare.dao;

import com.amritcare.model.Ambulance;
import com.amritcare.util.DBConnection;

import java.sql.*;
import java.util.*;

public class AmbulanceDAO {

    private Ambulance map(ResultSet rs) throws SQLException {
        Ambulance a = new Ambulance();
        a.setId(rs.getInt("id"));
        a.setVehicleNumber(rs.getString("vehicle_number"));
        a.setDriverName(rs.getString("driver_name"));
        a.setContact(rs.getString("contact"));
        a.setCurrentLat(rs.getDouble("current_lat"));
        a.setCurrentLng(rs.getDouble("current_lng"));
        a.setStatus(rs.getString("status"));
        a.setHospitalId(rs.getInt("hospital_id"));
        try { a.setHospitalName(rs.getString("hospital_name")); } catch (SQLException ignored) {}
        return a;
    }

    public List<Ambulance> getAllAmbulances() {
        List<Ambulance> list = new ArrayList<>();
        String sql = "SELECT a.*, h.name AS hospital_name FROM ambulance a LEFT JOIN hospital h ON a.hospital_id=h.id";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateLocation(int id, double lat, double lng) {
        String sql = "UPDATE ambulance SET current_lat=?, current_lng=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, lat); ps.setDouble(2, lng); ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
