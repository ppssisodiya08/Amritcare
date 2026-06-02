package com.amritcare.model;

public class Ambulance {
    private int id;
    private String vehicleNumber;
    private String driverName;
    private String contact;
    private double currentLat;
    private double currentLng;
    private String status;
    private int hospitalId;
    private String hospitalName;

    public Ambulance() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }

    public String getDriverName() { return driverName; }
    public void setDriverName(String driverName) { this.driverName = driverName; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public double getCurrentLat() { return currentLat; }
    public void setCurrentLat(double currentLat) { this.currentLat = currentLat; }

    public double getCurrentLng() { return currentLng; }
    public void setCurrentLng(double currentLng) { this.currentLng = currentLng; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getHospitalId() { return hospitalId; }
    public void setHospitalId(int hospitalId) { this.hospitalId = hospitalId; }

    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = hospitalName; }
}
