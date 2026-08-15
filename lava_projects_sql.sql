SET SQL_SAFE_UPDATES = 0;
DROP DATABASE IF EXISTS biobank_db;
CREATE DATABASE biobank_db;
USE biobank_db;
CREATE TABLE donors (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    dob DATE NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    blood_type VARCHAR(5) CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    contact_email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE consents (
    consent_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    consent_type VARCHAR(50) NOT NULL,
    signed_date DATE NOT NULL,
    status ENUM('Active', 'Revoked', 'Expired') DEFAULT 'Active',
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE
);
CREATE TABLE sample_types (
    sample_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    recommended_temp_celsius DECIMAL(5,1) NOT NULL
);
CREATE TABLE storage_locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    building VARCHAR(50) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    freezer_unit VARCHAR(50) NOT NULL,
    shelf_box VARCHAR(50) NOT NULL,
    temp_celsius DECIMAL(5,1) NOT NULL,
    capacity INT NOT NULL
);
CREATE TABLE biospecimens (
    sample_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    sample_type_id INT NOT NULL,
    collection_date DATETIME NOT NULL,
    initial_volume_ml DECIMAL(6,2) NOT NULL,
    current_volume_ml DECIMAL(6,2) NOT NULL,
    status ENUM('Available', 'Depleted', 'Discarded') DEFAULT 'Available',
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id) ON DELETE CASCADE,
    FOREIGN KEY (sample_type_id) REFERENCES sample_types(sample_type_id)
);
CREATE TABLE aliquots (
    aliquot_id INT AUTO_INCREMENT PRIMARY KEY,
    sample_id INT NOT NULL,
    location_id INT NOT NULL,
    volume_ml DECIMAL(6,2) NOT NULL,
    concentration_mg_ml DECIMAL(6,2),
    aliquot_status ENUM('Available', 'Reserved', 'Used') DEFAULT 'Available',
    FOREIGN KEY (sample_id) REFERENCES biospecimens(sample_id) ON DELETE CASCADE,
    FOREIGN KEY (location_id) REFERENCES storage_locations(location_id)
);
CREATE TABLE researchers (
    researcher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    institution VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL
);
CREATE TABLE test_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    researcher_id INT NOT NULL,
    aliquot_id INT NOT NULL,
    request_date DATETIME NOT NULL,
    purpose VARCHAR(255) NOT NULL,
    project_title VARCHAR(150) NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (researcher_id) REFERENCES researchers(researcher_id),
    FOREIGN KEY (aliquot_id) REFERENCES aliquots(aliquot_id)
);
INSERT INTO sample_types (type_name, recommended_temp_celsius) VALUES
('Whole Blood', -80.0), ('Serum', -80.0), ('Plasma', -80.0),
('Genomic DNA', -20.0), ('Tissue Biopsy', -196.0), ('RNA Extract', -80.0),
('Saliva', -20.0), ('Urine', -80.0), ('Bone Marrow', -196.0), ('Cell Line', -196.0);
INSERT INTO storage_locations (building, room_number, freezer_unit, shelf_box, temp_celsius, capacity) VALUES
('BioBuilding A', 'Lab-101', 'Freezer-A1', 'Shelf-1 / Box-A', -80.0, 100),
('BioBuilding A', 'Lab-101', 'Freezer-A2', 'Shelf-2 / Box-B', -80.0, 100),
('BioBuilding A', 'Lab-102', 'Freezer-A3', 'Shelf-1 / Box-C', -20.0, 150),
('BioBuilding B', 'Lab-205', 'Cryo-Tank-1', 'Rack-1 / Box-A', -196.0, 50),
('BioBuilding B', 'Lab-205', 'Cryo-Tank-2', 'Rack-2 / Box-B', -196.0, 50),
('BioBuilding B', 'Lab-206', 'Freezer-B1', 'Shelf-1 / Box-D', -80.0, 200),
('BioBuilding C', 'Lab-301', 'Freezer-C1', 'Shelf-3 / Box-A', -20.0, 100),
('BioBuilding C', 'Lab-301', 'Freezer-C2', 'Shelf-4 / Box-B', -80.0, 100),
('BioBuilding C', 'Lab-302', 'Cryo-Tank-3', 'Rack-1 / Box-E', -196.0, 75),
('BioBuilding C', 'Lab-302', 'Freezer-C3', 'Shelf-2 / Box-F', -80.0, 120);

INSERT INTO donors (full_name, dob, gender, blood_type, contact_email) VALUES
('Youssef Reda', '1995-03-15', 'M', 'A+', 'youssef.reda@example.com'),
('Ahmed Gharib', '1988-07-22', 'M', 'O+', 'ahmed.gharib@example.com'),
('Sayed Wael', '2001-11-05', 'M', 'B-', 'sayed.wael@example.com'),
('Sara Mahmoud', '1999-01-30', 'F', 'AB+', 'sara.mahmoud@example.com'),
('Mona Zaki', '1992-05-18', 'F', 'O-', 'mona.zaki@example.com'),
('Omar Hassan', '1985-09-12', 'M', 'A-', 'omar.hassan@example.com'),
('Nour El-Din', '2000-04-25', 'F', 'B+', 'nour.eldin@example.com'),
('Khaled Ibrahim', '1979-12-08', 'M', 'AB-', 'khaled.ibrahim@example.com'),
('Heba Aly', '1996-08-14', 'F', 'O+', 'heba.aly@example.com'),
('Tarek Samy', '1990-02-02', 'M', 'A+', 'tarek.samy@example.com');

INSERT INTO consents (donor_id, consent_type, signed_date, status) VALUES
(1, 'General Biobank Research', '2024-01-10', 'Active'),
(2, 'Genomic Sequencing', '2024-01-15', 'Active'),
(3, 'Oncology Research', '2024-02-01', 'Active'),
(4, 'General Biobank Research', '2024-02-10', 'Active'),
(5, 'Rare Disease Research', '2024-02-20', 'Active'),
(6, 'Genomic Sequencing', '2024-03-01', 'Active'),
(7, 'General Biobank Research', '2024-03-05', 'Active'),
(8, 'Oncology Research', '2024-03-12', 'Active'),
(9, 'Cardiovascular Research', '2024-03-18', 'Active'),
(10, 'General Biobank Research', '2024-03-22', 'Revoked');

INSERT INTO biospecimens (donor_id, sample_type_id, collection_date, initial_volume_ml, current_volume_ml, status) VALUES
(1, 1, '2024-04-01 09:30:00', 10.00, 8.00, 'Available'),
(2, 4, '2024-04-02 11:15:00', 5.00, 4.00, 'Available'),
(3, 5, '2024-04-03 14:00:00', 2.00, 1.50, 'Available'),
(4, 2, '2024-04-04 10:45:00', 8.00, 8.00, 'Available'),
(5, 3, '2024-04-05 08:30:00', 6.00, 6.00, 'Available'),
(6, 6, '2024-04-06 13:20:00', 3.00, 3.00, 'Available'),
(7, 7, '2024-04-07 09:00:00', 15.00, 15.00, 'Available'),
(8, 8, '2024-04-08 15:10:00', 20.00, 20.00, 'Available'),
(9, 9, '2024-04-09 11:00:00', 1.50, 1.50, 'Available'),
(10, 10, '2024-04-10 12:00:00', 4.00, 0.00, 'Depleted');

INSERT INTO aliquots (sample_id, location_id, volume_ml, concentration_mg_ml, aliquot_status) VALUES
(1, 1, 2.00, 1.50, 'Available'),
(1, 1, 2.00, 1.50, 'Reserved'),
(2, 3, 1.00, 5.20, 'Available'),
(3, 4, 0.50, 2.10, 'Available'),
(4, 2, 2.00, 0.90, 'Available'),
(5, 6, 2.00, 1.10, 'Available'),
(6, 8, 1.00, 3.40, 'Available'),
(7, 7, 5.00, 0.10, 'Available'),
(8, 7, 5.00, 0.05, 'Available'),
(9, 5, 0.50, 8.00, 'Available');
INSERT INTO researchers (full_name, institution, email, role) VALUES
('Dr. Mohamed Ali', 'Cairo University', 'm.ali@cu.edu.eg', 'Lead Principal Investigator'),
('Dr. Mona Hassan', 'National Research Centre', 'mona.hassan@nrc.sci.eg', 'Senior Scientist'),
('Dr. Sherif Kamel', 'Ain Shams University', 's.kamel@asu.edu.eg', 'Genomics Professor'),
('Dr. Rania Mahmoud', 'Mansoura University', 'r.mahmoud@mans.edu.eg', 'Oncology Researcher'),
('Dr. Yasser Fouad', 'Alexandria University', 'y.fouad@alexu.edu.eg', 'Bioinformatician'),
('Dr. Hoda Hamdy', 'Zewail City', 'h.hamdy@zewailcity.edu.eg', 'Postdoc Fellow'),
('Dr. Amr Mustafa', 'Aswan Heart Centre', 'amr.mustafa@myheart.org', 'Cardiologist'),
('Dr. Dalia Nabil', 'AUC', 'd.nabil@aucegypt.edu', 'Biotech Lecturer'),
('Dr. Ehab Farouk', 'Theodor Bilharz Research Inst.', 'ehab.f@tbri.gov.eg', 'Immunologist'),
('Dr. Nessma Said', 'ASRT', 'nessma.said@asrt.sci.eg', 'Research Analyst');
INSERT INTO test_requests (researcher_id, aliquot_id, request_date, purpose, project_title, status) VALUES
(1, 1, '2024-05-01 10:00:00', 'Genomic sequencing for diabetes biomarker discovery', 'Diabetes Biomarkers', 'Approved'),
(2, 3, '2024-05-02 12:30:00', 'DNA extraction and PCR amplification', 'Oncology Genetics', 'Approved'),
(3, 2, '2024-05-03 14:15:00', 'Whole genome mapping', 'Egyptian Genome Project', 'Pending'),
(4, 4, '2024-05-04 09:00:00', 'Histopathology staining and microscopy', 'Tumor Microenvironment', 'Approved'),
(5, 5, '2024-05-05 11:45:00', 'Serum proteomic profiling', 'Proteomics Mapping', 'Pending'),
(6, 6, '2024-05-06 16:00:00', 'Plasma assay for viral detection', 'Viral Markers Study', 'Completed'),
(7, 7, '2024-05-07 10:30:00', 'RNA sequencing for metabolic pathways', 'RNAseq Liver Project', 'Rejected'),
(8, 8, '2024-05-08 13:00:00', 'Salivary biomarker validation', 'Non-invasive Diagnostics', 'Pending'),
(9, 9, '2024-05-09 15:20:00', 'Urine metabolite identification', 'Kidney Disease Markers', 'Approved'),
(10, 10, '2024-05-10 08:45:00', 'Bone marrow stem cell isolation', 'Stem Cell Therapy', 'Pending');
CREATE VIEW vw_available_inventory AS
SELECT 
    a.aliquot_id,
    st.type_name,
    a.volume_ml,
    a.concentration_mg_ml,
    sl.building,
    sl.freezer_unit,
    sl.shelf_box,
    sl.temp_celsius AS current_storage_temp,
    st.recommended_temp_celsius
FROM aliquots a
JOIN biospecimens b ON a.sample_id = b.sample_id
JOIN sample_types st ON b.sample_type_id = st.sample_type_id
JOIN storage_locations sl ON a.location_id = sl.location_id
WHERE a.aliquot_status = 'Available';
CREATE VIEW vw_project_requests_summary AS
SELECT 
    tr.request_id,
    tr.project_title,
    r.full_name AS researcher_name,
    r.institution,
    tr.purpose,
    tr.status AS request_status,
    st.type_name AS sample_type,
    a.volume_ml
FROM test_requests tr
JOIN researchers r ON tr.researcher_id = r.researcher_id
JOIN aliquots a ON tr.aliquot_id = a.aliquot_id
JOIN biospecimens b ON a.sample_id = b.sample_id
JOIN sample_types st ON b.sample_type_id = st.sample_type_id;
DELIMITER //
CREATE TRIGGER trg_reduce_sample_volume_after_aliquot
AFTER INSERT ON aliquots
FOR EACH ROW
BEGIN
    UPDATE biospecimens 
    SET current_volume_ml = current_volume_ml - NEW.volume_ml
    WHERE sample_id = NEW.sample_id;
    
    UPDATE biospecimens 
    SET status = 'Depleted'
    WHERE sample_id = NEW.sample_id AND current_volume_ml <= 0;
END //
CREATE PROCEDURE sp_approve_test_request(IN p_request_id INT)
BEGIN
    UPDATE test_requests 
    SET status = 'Approved' 
    WHERE request_id = p_request_id;
    
    UPDATE aliquots a
    JOIN test_requests tr ON a.aliquot_id = tr.aliquot_id
    SET a.aliquot_status = 'Reserved'
    WHERE tr.request_id = p_request_id;
END //
DELIMITER ;
SELECT 
    b.sample_id, 
    d.full_name AS donor_name, 
    st.type_name AS sample_type, 
    b.current_volume_ml, 
    b.status
FROM biospecimens b
JOIN donors d ON b.donor_id = d.donor_id
JOIN sample_types st ON b.sample_type_id = st.sample_type_id;
SELECT 
    st.type_name,
    COUNT(b.sample_id) AS total_samples_collected,
    AVG(b.initial_volume_ml) AS avg_initial_volume_ml,
    SUM(b.current_volume_ml) AS total_remaining_volume_ml
FROM sample_types st
JOIN biospecimens b ON st.sample_type_id = b.sample_type_id
GROUP BY st.type_name;
SELECT full_name, contact_email 
FROM donors 
WHERE donor_id IN (
    SELECT donor_id 
    FROM biospecimens 
    WHERE current_volume_ml > (SELECT AVG(current_volume_ml) FROM biospecimens)
);
INSERT INTO donors (full_name, dob, gender, blood_type, contact_email) 
VALUES ('Kirolos Aymen', '2005-06-10', 'M', 'O+', 'kirolos.aymen@example.com');
UPDATE biospecimens 
SET status = 'Available' 
WHERE sample_id = 1;
DELETE FROM consents 
WHERE status = 'Revoked';
SELECT * FROM vw_available_inventory;
SELECT * FROM vw_project_requests_summary;