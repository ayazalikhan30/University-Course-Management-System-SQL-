
CREATE TABLE Students (
    StudentID  INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Courses (
    CourseID  INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    DepartmentID INT REFERENCES Departments(DepartmentID),
    Credits INT
);

CREATE TABLE Instructors (
    InstructorID  INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID  INT PRIMARY KEY,
    StudentID INT REFERENCES Students(StudentID),
    CourseID INT REFERENCES Courses(CourseID),
    EnrollmentDate DATE
);

CREATE TABLE Departments (
    DepartmentID  INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

---- INSERTING VALUES -----

--  Insert into Students
INSERT INTO Students
    (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

--  Insert into Courses
INSERT INTO Courses
    (CourseID, CourseName, DepartmentID, Credits)
VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

--  Insert INTO Instructors
INSERT INTO Instructors
    (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2);


--  Insert into Enrollments
INSERT INTO Enrollments
    (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

--  Insert into Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

---- QUESTIONS ----

-- Q1 Perform CRUD Operations on all tables.

-- Department Table 

-- CREATE
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (3, 'Physics');

-- READ
SELECT * FROM Departments;

-- UPDATE
UPDATE Departments
SET DepartmentName = 'Applied Physics'
WHERE DepartmentID = 3;

-- DELETE
DELETE FROM Departments
WHERE DepartmentID = 3;

-- Students Table

-- -- CREATE
INSERT INTO Students
(StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES
(3, 'Rahul', 'Verma', 'rahul.verma@email.com','2001-06-15', '2025-08-01');

-- READ
SELECT * FROM Students;

-- UPDATE
UPDATE Students
SET Email = 'rahul.new@email.com'
WHERE StudentID = 3;

-- DELETE
DELETE FROM Students
WHERE StudentID = 3;


-- Courses Table--
-- CREATE
INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits)
VALUES (103, 'Physics Fundamentals', 3, 4);

-- READ
SELECT * FROM Courses
WHERE CourseID = 103;

-- UPDATE
UPDATE Courses
SET Credits = 5
WHERE CourseID = 103;

-- DELETE
DELETE FROM Courses
WHERE CourseID = 103;


-- Instructors Table -- 

-- CREATE
INSERT INTO Instructors
    (InstructorID, FirstName, LastName, Email, DepartmentID)
VALUES
    (3, 'Neha', 'Sharma', 'neha.sharma@univ.com', 3);

-- READ
SELECT * FROM Instructors;

-- UPDATE
UPDATE Instructors
SET Email = 'neha.new@univ.com'
WHERE InstructorID = 3;

-- DELETE
DELETE FROM Instructors
WHERE InstructorID = 3;

-- Enrollments Table -- 


-- CREATE
INSERT INTO Enrollments
    (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES
    (3, 3, 103, '2025-08-01');

-- READ
SELECT * FROM Enrollments;

-- UPDATE
UPDATE Enrollments
SET EnrollmentDate = '2025-09-01'
WHERE EnrollmentID = 3;

-- DELETE
DELETE FROM Enrollments
WHERE EnrollmentID = 3;

--Q2. Retrieve students who enrolled after 2022.

SELECT * FROM Students 
WHERE EnrollmentDate > '2022-12-31';


-- Q3. Retrieve courses offered by the Mathematics department with a limit of 5 courses.

SELECT D.DepartmentName , C.CourseName AS "Course offered by Maths Department" ,C.CourseID
FROM Courses C
Inner JOIN Departments D
ON C.DepartmentID = D.DepartmentID
Where D.DepartmentName = 'Mathematics'
LIMIT 5;

-- Q4. Get the number of students enrolled in each course, filtering for courses with more than 5 students.

SELECT C.CourseName , Count(E.StudentID) AS "No.of Students"
From Enrollments E
Join Courses C
ON C.CourseID = E.CourseID
Group by C.CourseName
Having Count ('No.of Students') > 5;


-- Q5. Find students who are enrolled in both Introduction to SQL and Data Structures.
Select S.StudentID ,S.FirstName , S.LastName
From Enrollments E
Join Courses C
ON E.CourseID = C.CourseID
JOIN Students S
ON S.StudentID = E.StudentID
Where C.CourseName = 'Introduction to SQL' OR C.CourseName = 'Data Structures'
GROUP BY S.StudentID,S.FirstName,S.LastName
Having  Count(Distinct C.CourseID) = 2;

-- Q6. Find students who are either enrolled in Introduction to SQL or Data Structures.

Select Distinct S.StudentID ,S.FirstName , S.LastName
From Enrollments E
Join Courses C
ON E.CourseID = C.CourseID
JOIN Students S
ON S.StudentID = E.StudentID
Where C.CourseName = 'Introduction to SQL' OR C.CourseName = 'Data Structures';

-- Q7. Calculate the average number of credits for all courses.

SELECT  ROUND(AVG(Credits),2) 
FROM Courses;
-- Group By CourseName;

--Q8. Find the maximum salary of instructors in the Computer Science department.

-- to do this question we need to add salary column in Instructor Table 
Alter Table Instructors
Add Column Salary NUMERIC(10, 2);

Update Instructors 
SET Salary = 60000
Where InstructorID = 1;
Update Instructors 
SET Salary = 50000
Where InstructorID = 2;

-- Now doing Q8

Select  MAX(Salary)
From Instructors 
Where D.DepartmentName = 'Computer Science';


-- Q9-Count the number of students enrolled in each department.
SELECT D.DepartmentName , Count (Distinct E.StudentID)
FROM Courses C
Join Departments D
ON D.DepartmentID = C.DepartmentID
Join Enrollments E
ON E.CourseID = C.CourseID
Join Students S
On S.StudentID = E.StudentID
Group BY D.DepartmentName;


-- Q-10. INNER JOIN: Retrieve students and their corresponding courses.
Select Distinct E.StudentID , S.FirstName ,S.LastName, C.CourseName
From Courses C
Join EnrollMents E
On C.CourseID = E.CourseID
JOIN Students S
On S.StudentID = E.StudentID;
-- Here we dont need group by because question didnt asked for Aggregation

-- Q11. LEFT JOIN: Retrieve all students and their corresponding courses, if any.

Select S.StudentID ,S.FirstName,S.LastName , C.CourseName
FROM Students S
Left Join Enrollments E
ON S.StudentID = E.StudentID
Left JOIN Courses C
ON E.CourseID = C.CourseID;

-- Q12. Subquery: Find students enrolled in courses that have more than 10 students.

Select FirstName, LastName
From Students
Where StudentID
In (Select StudentID From Enrollments Where CourseID 
      In (Select CourseID From Enrollments 
	       Group By CourseID 
		   Having Count (Distinct StudentID)>10));

-- Alternate solution --

/*SELECT S.StudentID, S.FirstName, S.LastName
FROM Students S
JOIN Enrollments E
    ON S.StudentID = E.StudentID
WHERE E.CourseID IN (
    SELECT CourseID
    FROM Enrollments
    GROUP BY CourseID
    HAVING COUNT(DISTINCT StudentID) > 0
);*/

-- Q13. Extract the year from the EnrollmentDate of students.

Select FirstName , LastName, EnrollmentDate,
Extract (year From EnrollmentDate)
From Students; 

-- Q14 Concatenate the instructor's first and last name.

Select FirstName, LastName, Concat(FirstName ,' ', LastName) AS FULLNAME 
From Instructors;

-- Q15. Calculate the running total of students enrolled in courses.

SELECT EnrollmentID, StudentID, CourseID,
    COUNT(*) OVER (ORDER BY EnrollmentID) AS RunningTotal
FROM Enrollments;

--Q16. Label students as 'Senior' or 'Junior' based on their year of enrollment. (If the enrollment date is more than 4
-- years from the current date, put the label 'Senior' otherwise 'Junior')

Select StudentID , FirstName , LastName , EnrollmentDate ,
Case 
    When EnrollmentDate < Current_Date - INTERVAL '4 Years'
    THEN 'Senior'
	ELSE 'Junior'
	End AS StudentCategory
From Students;





