-- =========================
-- University Course Registration System
-- =========================

-- 1. Department
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    office_location VARCHAR(100)
);

-- 2. Instructor
CREATE TABLE Instructor (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 3. Student
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    major VARCHAR(100),
    enrollment_year INT
);

-- 4. Course
CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    credits INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 5. Classroom
CREATE TABLE Classroom (
    room_id INT PRIMARY KEY,
    building VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

-- 6. Enrollment (Associative Entity)
CREATE TABLE Enrollment (
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    grade VARCHAR(2),
    PRIMARY KEY (student_id, course_id, semester),
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

-- 7. CourseAssignment (Associative Entity)
CREATE TABLE CourseAssignment (
    course_id INT,
    instructor_id INT,
    semester VARCHAR(20),
    room_id INT,
    PRIMARY KEY (course_id, instructor_id, semester),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
    FOREIGN KEY (room_id) REFERENCES Classroom(room_id)
);

-- ===== Sample Data =====

-- Departments
INSERT INTO Department VALUES
(1, 'Computer Science', 'Engineering Building Room 201'),
(2, 'Mathematics', 'Math Hall Room 105'),
(3, 'English', 'Humanities Building Room 301');

-- Instructors
INSERT INTO Instructor VALUES
(101, 'Dr. Alice Smith', 'alice.smith@univ.edu', 1),
(102, 'Dr. Bob Johnson', 'bob.johnson@univ.edu', 2),
(103, 'Dr. Carol White', 'carol.white@univ.edu', 3);

-- Students
INSERT INTO Student VALUES
(1001, 'John Doe', 'john.doe@student.edu', 'Computer Science', 2023),
(1002, 'Jane Miller', 'jane.miller@student.edu', 'Mathematics', 2022),
(1003, 'Mike Brown', 'mike.brown@student.edu', 'English', 2024);

-- Courses
INSERT INTO Course VALUES
(501, 'Database Systems', 3, 1),
(502, 'Calculus I', 4, 2),
(503, 'English Literature', 3, 3);

-- Classrooms
INSERT INTO Classroom VALUES
(201, 'Engineering Building', 40),
(202, 'Math Hall', 50),
(203, 'Humanities Building', 35);

-- Course Assignments
INSERT INTO CourseAssignment VALUES
(501, 101, 'Fall 2025', 201),
(502, 102, 'Fall 2025', 202),
(503, 103, 'Fall 2025', 203);

-- Enrollments
INSERT INTO Enrollment VALUES
(1001, 501, 'Fall 2025', NULL),
(1001, 502, 'Fall 2025', NULL),
(1002, 502, 'Fall 2025', NULL),
(1003, 503, 'Fall 2025', NULL);

-- ===== Multi-Table Query =====

SELECT 
    s.name AS student_name,
    c.title AS course_title,
    i.name AS instructor_name,
    e.semester
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
JOIN CourseAssignment ca ON c.course_id = ca.course_id AND e.semester = ca.semester
JOIN Instructor i ON ca.instructor_id = i.instructor_id;