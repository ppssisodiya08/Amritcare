-- AmritCare Database Schema
-- Run this file in MySQL to set up the database
-- ============================================

CREATE DATABASE IF NOT EXISTS amritcare;
USE amritcare;

-- ---------------------------------------------
-- TABLE: users
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    role ENUM('patient', 'hospital_admin', 'city_admin') DEFAULT 'patient',
    hospital_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------
-- TABLE: hospital
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS hospital (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(200) NOT NULL,
    contact VARCHAR(20),
    specialization VARCHAR(200),
    rating DECIMAL(2,1) DEFAULT 4.0,
    total_beds INT DEFAULT 50,
    total_icu INT DEFAULT 10,
    latitude DECIMAL(10,6) DEFAULT 23.2599,
    longitude DECIMAL(10,6) DEFAULT 77.4126,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------
-- TABLE: doctor
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS doctor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(100),
    experience INT DEFAULT 0,
    availability ENUM('available', 'unavailable', 'on_leave') DEFAULT 'available',
    schedule VARCHAR(200) DEFAULT 'Mon-Fri 9AM-5PM',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- TABLE: bed
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS bed (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    bed_number VARCHAR(20) NOT NULL,
    type ENUM('general', 'private', 'semi-private') DEFAULT 'general',
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- TABLE: icu
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS icu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    unit_number VARCHAR(20) NOT NULL,
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(id) ON DELETE CASCADE
);

-- ---------------------------------------------
-- TABLE: booking
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS booking (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    patient_email VARCHAR(100),
    contact VARCHAR(20) NOT NULL,
    hospital_id INT NOT NULL,
    doctor_id INT DEFAULT NULL,
    bed_id INT DEFAULT NULL,
    icu_id INT DEFAULT NULL,
    booking_type ENUM('Bed', 'ICU', 'Doctor') NOT NULL,
    booking_date DATE NOT NULL,
    notes TEXT,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(id),
    FOREIGN KEY (bed_id) REFERENCES bed(id),
    FOREIGN KEY (icu_id) REFERENCES icu(id)
);

-- ---------------------------------------------
-- TABLE: ambulance
-- ---------------------------------------------
CREATE TABLE IF NOT EXISTS ambulance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_number VARCHAR(20) NOT NULL,
    driver_name VARCHAR(100),
    contact VARCHAR(20),
    current_lat DECIMAL(10,6) DEFAULT 23.2599,
    current_lng DECIMAL(10,6) DEFAULT 77.4126,
    status ENUM('available', 'on_call', 'returning') DEFAULT 'available',
    hospital_id INT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id) REFERENCES hospital(id)
);


INSERT INTO users (name, email, password, role) VALUES
('City Admin', 'admin@amritcare.in', 'admin123', 'city_admin');

-- Sample Hospitals
INSERT INTO hospital (name, location, contact, specialization, rating, total_beds, total_icu, latitude, longitude) VALUES
('AIIMS Bhopal', 'Saket Nagar, Bhopal', '0755-2672335', 'Multi-specialty, Cardiology, Neurology', 4.8, 300, 40, 23.2131, 77.4309),
('Hamidia Hospital', 'Royal Market, Bhopal', '0755-2540222', 'General, Orthopaedics, Surgery', 4.2, 500, 30, 23.2649, 77.4065),
('Bansal Hospital', 'New Market, Bhopal', '0755-4274400', 'Cardiology, Oncology, Nephrology', 4.6, 150, 20, 23.2332, 77.4172),
('Care CHL Hospital', 'AB Road, Bhopal', '0755-4000000', 'Gynaecology, Paediatrics, IVF', 4.5, 200, 25, 23.2423, 77.4515),
('Chirayu Hospital', 'Bhadbhada Road, Bhopal', '0755-6678001', 'Spine, Neurology, Trauma', 4.3, 250, 35, 23.2515, 77.3890);

-- Hospital Admin users
INSERT INTO users (name, email, password, role, hospital_id) VALUES
('AIIMS Admin', 'aiims@amritcare.in', 'hospital123', 'hospital_admin', 1),
('Hamidia Admin', 'hamidia@amritcare.in', 'hospital123', 'hospital_admin', 2),
('Bansal Admin', 'bansal@amritcare.in', 'hospital123', 'hospital_admin', 3);

-- Sample Doctors
INSERT INTO doctor (hospital_id, name, specialization, qualification, experience, availability, schedule) VALUES
(1, 'Dr. Ramesh Sharma', 'Cardiology', 'MBBS, MD, DM Cardiology', 15, 'available', 'Mon-Sat 9AM-2PM'),
(1, 'Dr. Priya Singh', 'Neurology', 'MBBS, MD Neurology', 12, 'available', 'Mon-Fri 10AM-4PM'),
(1, 'Dr. Anil Kumar', 'Orthopaedics', 'MBBS, MS Ortho', 10, 'unavailable', 'Tue-Sat 9AM-1PM'),
(2, 'Dr. Sunita Verma', 'General Medicine', 'MBBS, MD Medicine', 8, 'available', 'Mon-Sat 8AM-2PM'),
(2, 'Dr. Rajesh Patel', 'Surgery', 'MBBS, MS Surgery', 18, 'available', 'Mon-Fri 9AM-5PM'),
(3, 'Dr. Meena Gupta', 'Oncology', 'MBBS, MD, DNB Oncology', 20, 'available', 'Mon-Fri 10AM-3PM'),
(3, 'Dr. Vikas Joshi', 'Nephrology', 'MBBS, MD Nephrology', 11, 'available', 'Mon-Sat 9AM-1PM'),
(4, 'Dr. Anita Rawat', 'Gynaecology', 'MBBS, MS Gynae', 14, 'available', 'Mon-Sat 10AM-5PM'),
(5, 'Dr. Suresh Nair', 'Neurosurgery', 'MBBS, MCh Neurosurgery', 22, 'available', 'Mon-Fri 9AM-3PM');

-- Sample Beds (5 per hospital)
INSERT INTO bed (hospital_id, bed_number, type, status) VALUES
(1, 'A-101', 'general', 'available'), (1, 'A-102', 'general', 'occupied'),
(1, 'B-201', 'private', 'available'), (1, 'B-202', 'semi-private', 'available'),
(1, 'C-301', 'general', 'occupied'),
(2, 'H-101', 'general', 'available'), (2, 'H-102', 'general', 'available'),
(2, 'H-201', 'private', 'occupied'), (2, 'H-202', 'general', 'available'),
(2, 'H-301', 'semi-private', 'maintenance'),
(3, 'BN-101', 'private', 'available'), (3, 'BN-102', 'general', 'available'),
(3, 'BN-201', 'general', 'occupied'), (3, 'BN-202', 'private', 'available'),
(3, 'BN-301', 'general', 'available'),
(4, 'CC-101', 'general', 'available'), (4, 'CC-102', 'private', 'available'),
(4, 'CC-201', 'semi-private', 'occupied'), (4, 'CC-202', 'general', 'available'),
(4, 'CC-301', 'general', 'available'),
(5, 'CH-101', 'general', 'available'), (5, 'CH-102', 'general', 'occupied'),
(5, 'CH-201', 'private', 'available'), (5, 'CH-202', 'general', 'available'),
(5, 'CH-301', 'semi-private', 'available');

-- Sample ICU Units (3 per hospital)
INSERT INTO icu (hospital_id, unit_number, status) VALUES
(1, 'ICU-1A', 'available'), (1, 'ICU-1B', 'occupied'), (1, 'ICU-1C', 'available'),
(2, 'ICU-2A', 'occupied'), (2, 'ICU-2B', 'occupied'), (2, 'ICU-2C', 'available'),
(3, 'ICU-3A', 'available'), (3, 'ICU-3B', 'available'), (3, 'ICU-3C', 'occupied'),
(4, 'ICU-4A', 'available'), (4, 'ICU-4B', 'maintenance'), (4, 'ICU-4C', 'available'),
(5, 'ICU-5A', 'occupied'), (5, 'ICU-5B', 'available'), (5, 'ICU-5C', 'available');

-- Sample Ambulances
INSERT INTO ambulance (vehicle_number, driver_name, contact, current_lat, current_lng, status, hospital_id) VALUES
('MP04-AB-1234', 'Ramu Singh', '9876543210', 23.2599, 77.4126, 'available', 1),
('MP04-CD-5678', 'Suresh Kumar', '9876543211', 23.2649, 77.4065, 'on_call', 2),
('MP04-EF-9012', 'Mahesh Yadav', '9876543212', 23.2332, 77.4172, 'available', 3),
('MP04-GH-3456', 'Dinesh Patel', '9876543213', 23.2423, 77.4515, 'available', 4),
('MP04-IJ-7890', 'Ramesh Nagar', '9876543214', 23.2515, 77.3890, 'returning', 5);

-- Sample Patient
INSERT INTO users (name, email, password, phone, role) VALUES
('Rahul Sharma', 'patient@amritcare.in', 'patient123', '9876543200', 'patient');

-- Sample Booking
INSERT INTO booking (patient_name, patient_email, contact, hospital_id, doctor_id, booking_type, booking_date, status) VALUES
('Rahul Sharma', 'patient@amritcare.in', '9876543200', 1, 1, 'Doctor', '2026-04-20', 'confirmed');

SELECT 'AmritCare database setup complete!' AS message;
