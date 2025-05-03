-- Create the database
CREATE DATABASE course_management;

-- Create Schema Edtech
 Create SCHEMA Edtech

 USE course_management;
 
 -- PART 1 CREATING THE TABLES
 
-- Create Students table
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    date_of_birth DATE
);

-- Create Instructors table
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);

-- Create Courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Create Enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(1),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- PART 2 INSERTING THE DATA IN THE TABLES

-- Inserting Data into Students table
INSERT INTO course_management.students (student_id, first_name, last_name, email, date_of_birth) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@gmail.com', '2000-05-15'),
(2, 'Bob', 'Kelvin', 'bob.kelvin@gmail.com', '1999-08-22'),
(3, 'Jet', 'Lee', 'jet.lee@gmail.com', '2001-12-01'),
(4, 'David', 'Wong', 'david.wong@gmail.com', '1998-07-09'),
(5, 'Eva', 'Brown', 'eva.brown@gmail.com', '2002-01-30'),
(6, 'Frank', 'lampard', 'frank.lampard@gmail.com', '2000-11-04'),
(7, 'Grace', 'Clark', 'grace.clark@gmail.com', '2001-04-18'),
(8, 'Henry', 'Kariuki', 'henry.kariuki@gmail.com', '1999-09-27'),
(9, 'Chris', 'White', 'chris.white@gmail.com', '2003-02-23'),
(10, 'Jack', 'Davis', 'jack.davis@gmail.com', '2002-10-05');

-- Display all the data inserted into students table
SELECT * FROM course_management.students s;

-- Inserting Data into Instructors table
INSERT INTO course_management.instructors (instructor_id, first_name, last_name, email) VALUES
(1, 'Mercy', 'Smith', 'mercy.smith@gmail.com'),
(2, 'Linda', 'Musyoki', 'linda.musyoki@gmail.com'),
(3, 'Robert', 'Maina', 'robert.maina@gmail.com');

-- Display all the data inserted into instructors table
SELECT * FROM course_management.instructors i ;

-- Inserting Data into table Courses
INSERT INTO course_management.courses (course_id, course_name, course_description, instructor_id) VALUES
(1, 'SQL Basics', 'Intro to SQL Fundamentals', 1),
(2, 'Advanced SQL', 'Complex SQL Concepts', 1),
(3, 'Python for Data Science', 'Intro to Python', 2),
(4, 'Data Structures', 'Learn about Data Structures', 3),
(5, 'Machine Learning', 'Basics of ML', 3);

-- Display all the data inserted into courses table
SELECT * FROM course_management.courses c ;

-- Inserting Data into table Enrollments
INSERT INTO course_management.enrollments (enrollment_id, student_id, course_id, enrollment_date, grade) VALUES
(1, 1, 1, '2024-01-15', 'A'),
(2, 1, 2, '2024-01-16', 'B'),
(3, 2, 1, '2024-01-17', 'C'),
(4, 3, 3, '2024-01-18', 'B'),
(5, 4, 4, '2024-01-19', 'A'),
(6, 5, 5, '2024-01-20', 'D'),
(7, 6, 1, '2024-01-21', 'A'),
(8, 7, 2, '2024-01-22', 'B'),
(9, 8, 5, '2024-01-23', 'A'),
(10, 9, 3, '2024-01-24', 'C'),
(11, 10, 4, '2024-01-25', 'F'),
(12, 5, 1, '2024-01-26', 'B'),
(13, 6, 2, '2024-01-27', 'A'),
(14, 7, 3, '2024-01-28', 'B'),
(15, 8, 4, '2024-01-29', 'C');

-- Display all the data inserted into Enrollments table
SELECT * FROM course_management.enrollments e ;


-- PART 3 WRITING THE SQL QUERIES

-- Students who enrolled in at least one course
SELECT DISTINCT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;

-- Students enrolled in more than two courses
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING course_count > 2;

-- Courses with total enrolled students
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- Average grade per course
SELECT c.course_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id;

-- Students who haven’t enrolled in any course
SELECT s.first_name, s.last_name FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- Students with their average grade across all courses
SELECT s.first_name, s.last_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM students s JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

-- Instructors with the number of courses they teach
SELECT i.first_name, i.last_name, COUNT(c.course_id) AS total_courses FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id;

-- Students enrolled in a course taught by “Mercy Smith”
SELECT s.first_name, s.last_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Mercy' AND i.last_name = 'Smith';

-- Top 3 students by average grade
SELECT s.first_name, s.last_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
ORDER BY average_grade DESC
LIMIT 3;

-- Students failing (grade = ‘F’) in more than one course
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS failing_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade = 'F'
GROUP BY s.student_id
HAVING failing_courses > 1;


-- Part 4: ADVANCED SQL

-- Create a VIEW named student_course_summary (student name, course, grade)
CREATE VIEW student_course_summary AS
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Displaying the student_course_summary view created above
SELECT * FROM student_course_summary;

-- Adding an INDEX on Enrollments.student_id
CREATE INDEX idx_student_id ON enrollments(student_id);

-- Create a trigger or stored procedure that logs new enrollments
-- create a enrollment_logs table to store logs
CREATE TABLE enrollment_logs ( 
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- create a trigger that inserts a log when a new enrollment is added
DELIMITER $$

CREATE TRIGGER log_new_enrollment
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_logs (student_id, course_id, action)
    VALUES (NEW.student_id, NEW.course_id, 'ENROLLMENT CREATED');
END$$

DELIMITER ;

--  Select all from enrollment to verify logging works by inserting a new row into enrollments
SELECT * FROM enrollment_logs;









