# SQL-PROJECT-Student Course Management System
# Project Description
This SQL-based project simulates a Student Course Management System for an EdTech company. The goal is to design and implement a relational database system to manage students, instructors, courses, and enrollments. The project demonstrates database schema creation, data insertion, querying techniques, indexing, views, and triggers.

# ERD (Entity Relationship Diagram)
![Student Course Management System ERD](https://github.com/user-attachments/assets/1b2627e9-bba4-4eb7-a1b4-91cf69ea7266)
https://lucid.app/lucidchart/01dbfad8-83dc-42b9-b76e-11d56596576f/edit?viewport_loc=-232%2C-100%2C1632%2C690%2C0_0&invitationId=inv_17272fea-1abc-4720-a69d-53c7de16b77f
# Summary for ERD Above
Students ---	Enrollments	 --- One-to-Many ---	One student can enroll in many courses
Courses	--- Enrollments ---	One-to-Many	---- One course can have many student enrollments
Instructors ---	Courses ----	One-to-Many ----	One instructor can teach many courses

# How to Run the SQL Code
 After opening a new script on the Default DB on DBeaver :-
  -- Create the database
CREATE DATABASE course_management;
-- Create Schema Edtech
   CREATE SCHEMA Edtech
-- Run the SQL scripts
-- Create the tables
-- Insert Data in the Tables
-- Run Part 3 and Part 4 queries

# Explanation of the Schema
Tables:
Students: Holds basic info like name, email, and DOB.
Instructors: Stores instructor information.
Courses: Each course has a description and is taught by an instructor.
Enrollments: A junction table linking students and courses stores the grade and enrollment date.

Relationships:
Students -- Enrollments: One-to-many
Courses -- Enrollments: One-to-many
Instructors -- Courses: One-to-many

# Descriptions of Key Queries
# PART 3 WRITING THE SQL QUERIES
# 3.1 Getting Students who enrolled in at least one course
SELECT DISTINCT s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id;
![image](https://github.com/user-attachments/assets/bbb332d9-02f1-417b-a2db-622ff5d1809a)

# 3.2 Getting Students enrolled in more than two courses
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS course_count
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING course_count > 2;
![image](https://github.com/user-attachments/assets/48d511a8-76bb-42a4-a9e9-a25e94f8460b)
In this case, we had no student who enrolled for more than two courses

# 3.3 Courses with total enrolled students
SELECT c.course_name, COUNT(e.student_id) AS total_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;
![image](https://github.com/user-attachments/assets/b03d5423-ed9a-4dc2-8051-4c0dba6d1830)

# 3.4 Average grade per course
SELECT c.course_name, 
       AVG(CASE 
           WHEN e.grade = 'A' THEN 4
           WHEN e.grade = 'B' THEN 3
           WHEN e.grade = 'C' THEN 2
           WHEN e.grade = 'D' THEN 1
           WHEN e.grade = 'F' THEN 0
       END) AS average_grade
FROM courses c JOIN enrollments e ON c.course_id = e.course_id GROUP BY c.course_id;
![image](https://github.com/user-attachments/assets/347eb6fd-44ca-4144-b5f3-85e983a6abf2)

# 3.4 Students who haven’t enrolled in any course
SELECT s.first_name, s.last_name FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;
![image](https://github.com/user-attachments/assets/b1720f05-2e2d-4cf5-a5c2-c291e273586a)
 From above, there were no students who never enrolled for any course

# 3.5 Students with their average grade across all courses
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
![image](https://github.com/user-attachments/assets/d356c9bd-5d5a-4510-81b2-45bbccf4d551)

# 3.6 Instructors with the number of courses they teach
SELECT i.first_name, i.last_name, COUNT(c.course_id) AS total_courses FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
GROUP BY i.instructor_id;
![image](https://github.com/user-attachments/assets/feaddb39-244a-410c-bbe1-cdc61215d8d7)

# 3.7 Students enrolled in a course taught by “Mercy Smith”
SELECT s.first_name, s.last_name FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Mercy' AND i.last_name = 'Smith';
![image](https://github.com/user-attachments/assets/707c95d2-7163-4817-b908-57042d8b8663)

# 3.8 Top 3 students by average grade
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
![image](https://github.com/user-attachments/assets/92f3df1e-044b-41c4-b71e-662002bfece2)

# 3.9 Students failing (grade = ‘F’) in more than one course
SELECT s.first_name, s.last_name, COUNT(e.course_id) AS failing_courses
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
WHERE e.grade = 'F'
GROUP BY s.student_id
HAVING failing_courses > 1;
![image](https://github.com/user-attachments/assets/df19912b-4952-4144-b17f-00f853b908e9)
In this case, we dont have any failing student in more than one course


# Part 4: ADVANCED SQL
# 4.1 Create a VIEW named student_course_summary (student name, course, grade)
CREATE VIEW student_course_summary AS
SELECT CONCAT(s.first_name, ' ', s.last_name) AS student_name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;
# 4.1.1 Displaying the student_course_summary view created above
SELECT * FROM student_course_summary;
![image](https://github.com/user-attachments/assets/1091911a-f202-410f-804a-3cc07a99078b)

-- Adding an INDEX on Enrollments.student_id
CREATE INDEX idx_student_id ON enrollments(student_id);

# 4.2 Creating a trigger or stored procedure that logs new enrollments
# 4.2.1 create a enrollment_logs table to store logs
CREATE TABLE enrollment_logs ( 
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    action VARCHAR(50),
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# 4.2.2 Create a trigger that inserts a log when a new enrollment is added
DELIMITER $$

CREATE TRIGGER log_new_enrollment
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_logs (student_id, course_id, action)
    VALUES (NEW.student_id, NEW.course_id, 'ENROLLMENT CREATED');
END$$

DELIMITER ;

-- Select all from enrollment to verify logging works by inserting a new row into enrollments
SELECT * FROM enrollment_logs;
![image](https://github.com/user-attachments/assets/922a1d7b-32ed-4769-a541-5fcc03c2e3b0)
The Trigger Logs every new enrollment to an enrollment_logs table

# Challenges and Lessons Learned
1. Understanding relationships and foreign key constraints.
2. Importance of indexing for performance.
3. Learned to use UNION, JOIN, GROUP BY, and subqueries effectively.
4. Gained experience with triggers and views for real-world use cases.



