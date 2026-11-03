-- ===== PURA FILE EK SAATH RUN KARO (setup + Q1-Q18) =====
DROP DATABASE IF EXISTS hospital_db;
CREATE DATABASE hospital_db;
USE hospital_db;

CREATE TABLE wards (
    ward_id INT PRIMARY KEY,
    ward_name VARCHAR(50) NOT NULL,
    floor_no INT
);
CREATE TABLE staff (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(50) NOT NULL,
    ward_id INT NULL,
    supervisor_id INT NULL,
    pay INT,
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id),
    FOREIGN KEY (supervisor_id) REFERENCES staff(staff_id)
);
CREATE TABLE drives (
    drive_id INT PRIMARY KEY,
    drive_name VARCHAR(50) NOT NULL,
    ward_id INT NULL,
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id)
);
CREATE TABLE staff_drives (
    staff_id INT,
    drive_id INT,
    PRIMARY KEY (staff_id, drive_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
    FOREIGN KEY (drive_id) REFERENCES drives(drive_id)
);
CREATE TABLE rooms (room_id INT PRIMARY KEY, room_name VARCHAR(30));
CREATE TABLE slots (slot_id INT PRIMARY KEY, slot_name VARCHAR(30));

INSERT INTO wards VALUES
(1, 'Cardiology', 2),
(2, 'Neurology', 3),
(3, 'Pediatrics', 1),
(4, 'Oncology', 4),
(5, 'Radiology', 0);
INSERT INTO staff VALUES
(201, 'Anil', 1, NULL, 88000),
(202, 'Bhavna', 1, 201, 64000),
(203, 'Chirag', 2, NULL, 91000),
(204, 'Dipti', 2, 203, 57000),
(205, 'Esha', 3, NULL, 73000),
(206, 'Farhan', 1, 202, 61000),
(207, 'Gita', NULL, NULL, 52000),
(208, 'Harsh', 3, 205, 69000),
(209, 'Isha', 4, 203, 77000),
(210, 'Jatin', 1, 202, 59000);
INSERT INTO drives VALUES
(301, 'Heart Camp', 1),
(302, 'Brain Week', 2),
(303, 'Child Care', 3),
(304, 'Wellness Run', NULL),
(305, 'Cancer Aware', 4);
INSERT INTO staff_drives VALUES
(201, 301),
(202, 301),
(203, 302),
(206, 301),
(208, 303),
(209, 305),
(204, 302),
(210, 301);
INSERT INTO rooms VALUES
(1, 'R1'),
(2, 'R2'),
(3, 'R3');
INSERT INTO slots VALUES
(1, 'Day'),
(2, 'Night');


-- =====================================================
-- SQL Unit 3 Practical Test - Set B  (hospital_db)
-- =====================================================

-- ---------- SECTION A ----------
-- Q1
SELECT 'wards'        AS table_name, COUNT(*) AS total_rows FROM wards
UNION ALL
SELECT 'staff',        COUNT(*) FROM staff
UNION ALL
SELECT 'drives',       COUNT(*) FROM drives
UNION ALL
SELECT 'staff_drives', COUNT(*) FROM staff_drives
UNION ALL
SELECT 'rooms',        COUNT(*) FROM rooms
UNION ALL
SELECT 'slots',        COUNT(*) FROM slots;

-- ---------- SECTION B : INNER JOIN ----------
-- Q2
SELECT e.staff_name, d.ward_name, e.pay
FROM staff e
INNER JOIN wards d ON e.ward_id = d.ward_id
WHERE e.pay > 62000
ORDER BY e.staff_id;

-- Q3
SELECT e.staff_name, dr.drive_name, w.ward_name
FROM staff e
INNER JOIN staff_drives sd ON e.staff_id = sd.staff_id
INNER JOIN drives dr       ON sd.drive_id = dr.drive_id
INNER JOIN wards w         ON e.ward_id = w.ward_id
ORDER BY e.staff_id, dr.drive_id;

-- Q4
SELECT w.ward_name,
       COUNT(*)     AS total_emps,
       SUM(e.pay)   AS total_pay
FROM staff e
INNER JOIN wards w ON e.ward_id = w.ward_id
GROUP BY w.ward_id, w.ward_name
ORDER BY total_pay DESC;

-- ---------- SECTION C : OUTER JOINS ----------
-- Q5
SELECT e.staff_id, e.staff_name,
       COALESCE(w.ward_name, 'No Ward') AS ward
FROM staff e
LEFT JOIN wards w ON e.ward_id = w.ward_id
ORDER BY e.staff_id;

-- Q6 (a)
SELECT e.staff_id, e.staff_name
FROM staff e
LEFT JOIN wards w ON e.ward_id = w.ward_id
WHERE w.ward_id IS NULL;


-- Q7 (a)
SELECT w.ward_name, COUNT(e.staff_id) AS total_emps
FROM staff e
RIGHT JOIN wards w ON e.ward_id = w.ward_id
GROUP BY w.ward_id, w.ward_name
ORDER BY w.ward_id;

-- Q7 (b)
SELECT w.ward_name
FROM staff e
RIGHT JOIN wards w ON e.ward_id = w.ward_id
WHERE e.staff_id IS NULL;

-- Q8 (a)
SELECT e.staff_name, w.ward_name
FROM staff e
LEFT JOIN wards w ON e.ward_id = w.ward_id
UNION
SELECT e.staff_name, w.ward_name
FROM staff e
RIGHT JOIN wards w ON e.ward_id = w.ward_id
ORDER BY staff_name, ward_name;

-- Q8 (b)
SELECT 'No ward' AS issue, e.staff_name AS name
FROM staff e
LEFT JOIN wards w ON e.ward_id = w.ward_id
WHERE w.ward_id IS NULL
UNION
SELECT 'No staff member', w.ward_name
FROM staff e
RIGHT JOIN wards w ON e.ward_id = w.ward_id
WHERE e.staff_id IS NULL
ORDER BY issue;

-- Q8 comment: LEFT JOIN aur RIGHT JOIN dono me matched rows (jaise Anil-Cardiology)


-- ---------- SECTION D : CROSS & SELF JOIN ----------
-- Q9 (a)
SELECT r.room_name, s.slot_name
FROM rooms r
CROSS JOIN slots s
ORDER BY r.room_id, s.slot_id;

-- Q9 (b)
SELECT COUNT(*) AS total_combinations
FROM rooms
CROSS JOIN slots;


-- Q10
SELECT e.staff_name AS staff_member,
       COALESCE(m.staff_name, 'No Supervisor') AS supervisor
FROM staff e
LEFT JOIN staff m ON e.supervisor_id = m.staff_id
ORDER BY e.staff_id;

-- Q11
SELECT e1.staff_name AS first_staff_member,
       e2.staff_name AS second_staff_member,
       e1.ward_id
FROM staff e1
INNER JOIN staff e2
        ON e1.ward_id = e2.ward_id
       AND e1.staff_id < e2.staff_id
ORDER BY e1.staff_id, e2.staff_id;

-- Q12
SELECT e.staff_name  AS staff_member,
       m1.staff_name AS direct_supervisor,
       m2.staff_name AS indirect_supervisor
FROM staff e
LEFT JOIN staff m1 ON e.supervisor_id  = m1.staff_id
LEFT JOIN staff m2 ON m1.supervisor_id = m2.staff_id
WHERE e.supervisor_id IS NOT NULL
ORDER BY e.staff_id;

-- ---------- SECTION E : SUBQUERIES ----------
-- Q13 (a)
SELECT staff_name, pay
FROM staff
WHERE pay > (SELECT AVG(pay) FROM staff)
ORDER BY staff_id;

-- Q13 (b)
SELECT staff_name, pay
FROM staff
WHERE pay = (SELECT MAX(pay) FROM staff);

-- Q13 (c)
SELECT staff_name, pay
FROM staff
WHERE pay = (SELECT MAX(pay) FROM staff
             WHERE pay < (SELECT MAX(pay) FROM staff));

-- Q14 (a)
SELECT staff_name
FROM staff
WHERE ward_id IN (SELECT ward_id FROM drives WHERE ward_id IS NOT NULL)
ORDER BY staff_id;

-- Q14 (b)
SELECT ward_name
FROM wards
WHERE ward_id NOT IN (SELECT ward_id FROM drives WHERE ward_id IS NOT NULL);

-- Q14 (c)
SELECT ward_name
FROM wards
WHERE ward_id NOT IN (SELECT ward_id FROM drives);
-- Q14 (c) comment: drives me ward_id NULL wali row hai (Wellness Run). NOT IN list

-- Q15
SELECT ward_name, avg_pay
FROM (
    SELECT w.ward_name, ROUND(AVG(e.pay), 1) AS avg_pay
    FROM staff e
    INNER JOIN wards w ON e.ward_id = w.ward_id
    GROUP BY w.ward_id, w.ward_name
) AS dept_summary
WHERE avg_pay > 65000
ORDER BY avg_pay DESC;

-- Q16
SELECT staff_name, pay,
       (SELECT ROUND(AVG(pay), 1) FROM staff) AS company_avg,
       CASE WHEN pay > (SELECT AVG(pay) FROM staff) THEN 'Above'
            ELSE 'Below'
       END AS status
FROM staff
ORDER BY staff_id;

-- Q17
SELECT e.staff_name, e.pay, e.ward_id
FROM staff e
WHERE e.pay > (SELECT AVG(e2.pay)
               FROM staff e2
               WHERE e2.ward_id = e.ward_id)
ORDER BY e.staff_id;
-- Q17 comment: Gita ka ward_id NULL hai. "e2.ward_id = NULL" kabhi TRUE nahi hota,

-- Q18 (a)
SELECT e.staff_name
FROM staff e
WHERE EXISTS (SELECT 1 FROM staff_drives a WHERE a.staff_id = e.staff_id)
ORDER BY e.staff_id;

-- Q18 (b)
SELECT e.staff_name
FROM staff e
WHERE NOT EXISTS (SELECT 1 FROM staff_drives a WHERE a.staff_id = e.staff_id)
ORDER BY e.staff_id;
