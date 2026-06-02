package com.amritcare.model;

public class Hospital {
    private int id;
    private String name;
    private String location;
    private String contact;
    private String specialization;
    private double rating;
    private int totalBeds;
    private int totalIcu;
    private double latitude;
    private double longitude;
    private String status;

    // Computed fields from DB queries
    private int availableBeds;
    private int availableIcu;
    private int availableDoctors;

    public Hospital() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getSpecialization() { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public int getTotalBeds() { return totalBeds; }
    public void setTotalBeds(int totalBeds) { this.totalBeds = totalBeds; }

    public int getTotalIcu() { return totalIcu; }
    public void setTotalIcu(int totalIcu) { this.totalIcu = totalIcu; }

    public double getLatitude() { return latitude; }
    public void setLatitude(double latitude) { this.latitude = latitude; }

    public double getLongitude() { return longitude; }
    public void setLongitude(double longitude) { this.longitude = longitude; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getAvailableBeds() { return availableBeds; }
    public void setAvailableBeds(int availableBeds) { this.availableBeds = availableBeds; }

    public int getAvailableIcu() { return availableIcu; }
    public void setAvailableIcu(int availableIcu) { this.availableIcu = availableIcu; }

    public int getAvailableDoctors() { return availableDoctors; }
    public void setAvailableDoctors(int availableDoctors) { this.availableDoctors = availableDoctors; }
}
