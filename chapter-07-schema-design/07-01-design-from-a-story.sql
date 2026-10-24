-- SQL 199 | 7.1 Designing tables from a story
-- Run from the repo root:  sqlite3 -box < chapter-07-schema-design/07-01-design-from-a-story.sql
-- Real world: an architect turning "we want a 3-bedroom house with a big kitchen"
-- into a floor plan. Nouns become rooms (tables), details become fittings (columns).
--
-- The story: "A clinic has doctors. Patients book appointments with a doctor
-- at a date and time. Each appointment can have a prescription listing medicines."
-- Nouns -> tables: doctors, patients, appointments, prescriptions, medicines.
-- "has / with / listing" -> relationships (foreign keys).

PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS prescription_items;
DROP TABLE IF EXISTS medicines;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS doctors;

CREATE TABLE doctors (
    doctor_id   INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    speciality  TEXT NOT NULL
);
CREATE TABLE patients (
    patient_id  INTEGER PRIMARY KEY,
    full_name   TEXT NOT NULL,
    birth_date  TEXT,
    phone       TEXT UNIQUE
);
CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY,
    doctor_id      INTEGER NOT NULL REFERENCES doctors(doctor_id),
    patient_id     INTEGER NOT NULL REFERENCES patients(patient_id),
    starts_at      TEXT NOT NULL,                 -- 'YYYY-MM-DD HH:MM'
    UNIQUE (doctor_id, starts_at)                 -- a doctor cannot be double-booked
);
CREATE TABLE medicines (
    medicine_id INTEGER PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE
);
CREATE TABLE prescription_items (                 -- many-to-many: appointment <-> medicine
    appointment_id INTEGER REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    medicine_id    INTEGER REFERENCES medicines(medicine_id),
    dosage         TEXT NOT NULL,
    PRIMARY KEY (appointment_id, medicine_id)
);

INSERT INTO doctors VALUES (1, 'Dr. Mehta', 'General'), (2, 'Dr. Okafor', 'Skin');
INSERT INTO patients VALUES (1, 'Riya', '1995-06-01', '555-1001'), (2, 'Sven', '1988-11-23', '555-1002');
INSERT INTO appointments VALUES (1, 1, 1, '2026-10-24 10:00'), (2, 2, 2, '2026-10-24 10:00');
INSERT INTO medicines VALUES (1, 'Paracetamol'), (2, 'Cetirizine');
INSERT INTO prescription_items VALUES (1, 1, '500mg twice a day'), (2, 2, '10mg at night');

-- The design answers the story's questions.
SELECT a.starts_at, d.full_name AS doctor, p.full_name AS patient, m.name AS medicine, pi.dosage
FROM appointments a
JOIN doctors d  ON d.doctor_id = a.doctor_id
JOIN patients p ON p.patient_id = a.patient_id
LEFT JOIN prescription_items pi ON pi.appointment_id = a.appointment_id
LEFT JOIN medicines m ON m.medicine_id = pi.medicine_id;
