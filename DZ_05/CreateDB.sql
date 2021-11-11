-- Домашняя Работа №5
--  Ученик: Шелест Александр

USE Academy;
GO


ALTER TABLE Departments 
    DROP CONSTRAINT IF EXISTS FK_Departments_FacultyId;

ALTER TABLE Groups 
    DROP CONSTRAINT IF EXISTS FK_Groups_DepartmentId;

ALTER TABLE Lectures
    DROP CONSTRAINT IF EXISTS 
        FK_Lectures_SubjectId,
        FK_Lectures_TeacherId;

ALTER TABLE GroupsLectures
    DROP CONSTRAINT IF EXISTS 
        FK_GroupsLectures_GroupId,
        FK_GroupsLectures_LectureId;
GO

DROP TABLE IF EXISTS Faculties;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Lectures;
DROP TABLE IF EXISTS GroupsLectures;
GO


CREATE TABLE Faculties(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Name nvarchar(100) NOT NULL UNIQUE CHECK (Name != '')
);

CREATE TABLE Departments(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Financing money NOT NULL DEFAULT 0 CHECK (Financing >= 0)
    , Name nvarchar(100) NOT NULL UNIQUE CHECK (Name != '')
    , FacultyId int NOT NULL

    , CONSTRAINT FK_Departments_FacultyId 
      FOREIGN KEY (FacultyId) REFERENCES Faculties (Id)
);

CREATE TABLE Groups(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Name nvarchar(10) NOT NULL UNIQUE CHECK (Name != '')
    , Year int NOT NULL CHECK (Year >= 1 AND Year <= 5)
    , DepartmentId int NOT NULL 

    , CONSTRAINT FK_Groups_DepartmentId 
      FOREIGN KEY (DepartmentId) REFERENCES Departments (Id)
);

CREATE TABLE Subjects(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Name nvarchar(100) NOT NULL UNIQUE CHECK (Name != '')
);

CREATE TABLE Teachers(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Name nvarchar(MAX) NOT NULL CHECK (Name != '')
    , Surname nvarchar(MAX) NOT NULL CHECK (Surname != '')
    , Salary money NOT NULL CHECK (Salary > 0)
);

CREATE TABLE Lectures(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , DayOfWeek int NOT NULL CHECK (DayOfWeek >= 1 AND DayOfWeek <= 7)
    , LectureRoom nvarchar(MAX) NOT NULL CHECK (LectureRoom != '')
    , SubjectId int NOT NULL
    , TeacherId int NOT NULL

    , CONSTRAINT FK_Lectures_SubjectId
      FOREIGN KEY (SubjectId) REFERENCES Subjects(Id)
    , CONSTRAINT FK_Lectures_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures(
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , GroupId int NOT NULL
    , LectureId int NOT NULL

    , CONSTRAINT FK_GroupsLectures_GroupId
      FOREIGN KEY (GroupId) REFERENCES Groups (Id)
    , CONSTRAINT FK_GroupsLectures_LectureId
      FOREIGN KEY (LectureId) REFERENCES Lectures (Id)
);
GO


INSERT INTO Faculties (Name) VALUES
      ('Computer Science')
    , ('Radioelectronics')
    , ('Cryptocurrencies')
    , ('Networks & Communication')
    , ('Cybersecurity')
    , ('Electronic Engineering');
GO

INSERT INTO Departments (Financing, Name, FacultyId) VALUES
      (15000, 'Software Development', 1)
    , (16000, 'Front-end Development', 1)
    , (10000, 'Radiocommunication', 2)
    , (11000, 'Communication Algorithms', 2)
    , (18000, 'Stock Market', 3)
    , (17000, 'Market Analysis', 3)
    , (10000, 'Network Communication', 4)
    , (11500, 'Network Architecture', 4)
    , (13000, 'Malware Analysis', 5)
    , (14500, 'Binary Exploitation', 5)
    , (10500, 'Integrated Circuits', 6)
    , (11500, 'Chip Manufacturing', 6);
GO

INSERT INTO Groups (Name, Year, DepartmentId) VALUES
      ('BB-001', 1, 1)
    , ('AB-002', 2, 2)
    , ('BC-003', 3, 3)
    , ('CD-004', 4, 4)
    , ('DE-005', 5, 5)
    , ('EF-006', 1, 6)
    , ('FG-007', 2, 7)
    , ('GH-008', 3, 8)
    , ('HJ-009', 4, 9)
    , ('AB-202', 2, 2)
    , ('BC-203', 3, 3)
    , ('CD-204', 4, 4)
    , ('EF-206', 1, 5)
    , ('FG-207', 2, 7)
    , ('HJ-209', 4, 9)
    , ('JK-010', 5, 10)
    , ('KL-011', 1, 11)
    , ('LM-012', 2, 12)
    , ('KL-211', 1, 11)
    , ('LM-212', 2, 12);
GO

INSERT INTO Subjects (Name) VALUES
      ('Programming in C')
    , ('Programming in Java')
    , ('Front-end Frameworks')
    , ('Programming in JavaScript')
    , ('Radio Circuits')
    , ('Communication Protocols')
    , ('Stock Market Analysis Methods')
    , ('Stock Marker Trading')
    , ('Network Communication Protocols')
    , ('Computer Networks')
    , ('Network Communication Architectures')
    , ('History of Computer Viruses')
    , ('Binary Exploitation')
    , ('History of Semiconductor Computers')
    , ('Chip Manufacturing Progress');
GO

INSERT INTO Teachers (Name, Surname, Salary) VALUES
      ('Alexander', 'Mirosh', 1600)
    , ('Bogdan', 'Gorban', 1700)
    , ('Carolina', 'Bloomberg', 1800)
    , ('Dave', 'McQueen', 1900)
    , ('Eugeniy', 'Prostachkov', 2000)
    , ('Fedor', 'Barabolya', 2100)
    , ('Govard', 'Lovecraft', 2200)
    , ('Hanna', 'Moon', 2300)
    , ('Igor', 'Svetov', 2400)
    , ('Jach', 'Underhill', 1600)
    , ('Klint', 'Westwood', 1700)
    , ('Lolitta', 'Kryachko', 1800);
GO

INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES
      (1, 'A101', 1, 2) , (1, 'A201', 2, 3) , (1, 'A301', 3, 4) , (1, 'A401', 4, 5)
    , (2, 'B101', 2, 3) , (2, 'B201', 3, 4) , (2, 'B301', 4, 5) , (2, 'B401', 5, 6)
    , (3, 'C101', 3, 4) , (3, 'C201', 4, 5) , (3, 'C301', 5, 6) , (3, 'C401', 6, 7)
    , (4, 'D101', 4, 5) , (4, 'D201', 5, 6) , (4, 'D301', 6, 7) , (4, 'D401', 7, 8)
    , (5, 'E101', 5, 6) , (5, 'E201', 6, 7) , (5, 'E301', 7, 8) , (5, 'E401', 8, 9)
    , (1, 'A101', 15, 12) , (1, 'A201', 14, 11) , (1, 'A301', 13, 10) , (1, 'A401', 12, 9)
    , (2, 'B101', 14, 11) , (2, 'B201', 13, 10) , (2, 'B301', 12, 9) , (2, 'B401', 11, 8)
    , (3, 'C101', 13, 10) , (3, 'C201', 12, 9) , (3, 'C301', 11, 8) , (3, 'C401', 10, 7)
    , (4, 'D101', 12, 9) , (4, 'D201', 11, 8) , (4, 'D301', 10, 7) , (4, 'D401', 9, 6)
    , (5, 'E101', 11, 8) , (5, 'E201', 10, 7) , (5, 'E301', 9, 6) , (5, 'E401', 8, 5);
GO

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
      (1, 1) , (2, 2) , (3, 3) , (4, 4) , (5, 5)
    , (6, 6) , (7, 7) , (8, 8) , (9, 9) , (10, 10)
    , (11, 11) , (12, 12) , (1, 13) , (2, 14) , (3, 15)
    , (4, 16) , (5, 17) , (6, 18) , (7, 19) , (8, 20)
    , (9, 21) , (10, 22) , (11, 23) , (12, 24) , (1, 25)
    , (2, 26) , (3, 27) , (4, 28) , (5, 29) , (6, 30)
    , (7, 31) , (8, 32) , (9, 33) , (10, 34) , (11, 35)
    , (12, 36) , (1, 37) , (2, 38) , (3, 39) , (4, 40);
GO

