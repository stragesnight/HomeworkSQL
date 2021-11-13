-- Домашняя Работа №6
--  Ученик: Шелест Александр

USE Academy;
GO


ALTER TABLE Departments 
    DROP CONSTRAINT IF EXISTS FK_Departments_FacultyId;
ALTER TABLE Groups 
    DROP CONSTRAINT IF EXISTS FK_Groups_DepartmentId;
ALTER TABLE Lectures 
    DROP CONSTRAINT IF EXISTS 
          FK_Lectures_SubjectId
        , FK_Lectures_TeacherId;
ALTER TABLE GroupsCurators 
    DROP CONSTRAINT IF EXISTS 
          FK_GroupsCurators_CuratorId
        , FK_GroupsCurators_GroupId;
ALTER TABLE GroupsLectures 
    DROP CONSTRAINT IF EXISTS 
          FK_GroupsLectures_GroupId
        , FK_GroupsLectures_LectureId;
GO

DROP TABLE IF EXISTS Faculties;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Curators;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Lectures;
DROP TABLE IF EXISTS GroupsCurators;
DROP TABLE IF EXISTS GroupsLectures;
GO


CREATE TABLE Faculties(
      Id int IDENTITY(1,1) NOT NULL
    , Financing money NOT NULL DEFAULT 0 CHECK (Financing >= 0)
    , Name nvarchar(48) NOT NULL UNIQUE CHECK (Name != '')

    , PRIMARY KEY (Id)
);

CREATE TABLE Departments(
      Id int IDENTITY(1,1) NOT NULL
    , Financing money NOT NULL DEFAULT 0 CHECK (Financing >= 0)
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')
    , FacultyId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Departments_FacultyId 
      FOREIGN KEY (FacultyId) REFERENCES Faculties (Id)
);

CREATE TABLE Subjects(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')

    , PRIMARY KEY (Id)
);

CREATE TABLE Curators(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(32) NOT NULL CHECK (Name != '')
    , Surname nvarchar(32) NOT NULL CHECK (Surname != '')

    , PRIMARY KEY (Id)
);

CREATE TABLE Teachers(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(16) NOT NULL CHECK (Name != '')
    , Surname nvarchar(16) NOT NULL CHECK (Surname != '')
    , Salary money NOT NULL CHECK (Salary > 0)

    , PRIMARY KEY (Id)
);

CREATE TABLE Groups(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(10) NOT NULL UNIQUE CHECK (Name != '')
    , Year int NOT NULL CHECK (Year >= 1 AND Year <= 5)
    , DepartmentId int NOT NULL 

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Groups_DepartmentId 
      FOREIGN KEY (DepartmentId) REFERENCES Departments (Id)
);

CREATE TABLE Lectures(
      Id int IDENTITY(1,1) NOT NULL
    , LectureRoom nvarchar(16) NOT NULL CHECK (LectureRoom != '')
    , SubjectId int NOT NULL
    , TeacherId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Lectures_SubjectId
      FOREIGN KEY (SubjectId) REFERENCES Subjects(Id)
    , CONSTRAINT FK_Lectures_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsCurators(
      Id int IDENTITY(1,1) NOT NULL
    , CuratorId int NOT NULL
    , GroupId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_GroupsCurators_CuratorId
      FOREIGN KEY (CuratorId) REFERENCES Curators (Id)
    , CONSTRAINT FK_GroupsCurators_GroupId
      FOREIGN KEY (GroupId) REFERENCES Groups (Id)
);

CREATE TABLE GroupsLectures(
      Id int IDENTITY(1,1) NOT NULL
    , GroupId int NOT NULL
    , LectureId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_GroupsLectures_GroupId
      FOREIGN KEY (GroupId) REFERENCES Groups (Id)
    , CONSTRAINT FK_GroupsLectures_LectureId
      FOREIGN KEY (LectureId) REFERENCES Lectures (Id)
);
GO


INSERT INTO Faculties (Financing, Name) VALUES
      (15000, 'Computer Science')
    , (17000, 'Radioelectronics')
    , (16000, 'Cryptocurrencies')
    , (18000, 'Networks & Communication')
    , (17000, 'Cybersecurity')
    , (19000, 'Electronic Engineering');
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

INSERT INTO Subjects (Name) VALUES
      ('Programming in C')
    , ('Programming in Java')
    , ('Front-end Frameworks')
    , ('Programming in JavaScript')
    , ('Radio Circuits')
    , ('Database Theory')
    , ('Communication Protocols')
    , ('Stock Marker Trading')
    , ('Network Communication Protocols')
    , ('Computer Networks')
    , ('Network Architectures')
    , ('History of Computer Viruses')
    , ('Binary Exploitation')
    , ('History of Semiconductors')
    , ('Chip Manufacturing Progress');
GO

INSERT INTO Curators(Name, Surname) VALUES
      ('Anton', 'Belgorodsky')
    , ('Bob', 'Cantwood')
    , ('Camilla', 'Dark')
    , ('Dmitriy', 'Evdokienko')
    , ('Eliot', 'Fasthand')
    , ('Frank', 'Glarko')
    , ('Grigoriy', 'Harchuk')
    , ('Helena', 'Jacobs')
    , ('Ibar', 'Jcobs')
    , ('John', 'Blight');
GO

INSERT INTO Teachers (Name, Surname, Salary) VALUES
      ('Alexander', 'Mirosh', 1600)
    , ('Bogdan', 'Gorban', 1700)
    , ('Carolina', 'Bloomberg', 1800)
    , ('Dave', 'McQueen', 1900)
    , ('Eugeniy', 'Prostachkov', 2000)
    , ('Fedor', 'Barabolya', 2100)
    , ('Govard', 'Lovecraft', 2200)
    , ('Samantha', 'Adams', 2300)
    , ('Igor', 'Svetov', 2400)
    , ('Jack', 'Underhill', 1600)
    , ('Klint', 'Westwood', 1700)
    , ('Lolitta', 'Kryachko', 1800);
GO

INSERT INTO Groups (Name, Year, DepartmentId) VALUES
      ('B001', 1, 1)
    , ('A002', 2, 2)
    , ('B003', 3, 3)
    , ('C004', 4, 4)
    , ('D005', 5, 5)
    , ('E006', 1, 6)
    , ('F007', 2, 7)
    , ('G008', 3, 8)
    , ('H009', 4, 9)
    , ('P107', 2, 5)
    , ('B203', 3, 3)
    , ('C204', 4, 4)
    , ('E206', 1, 5)
    , ('F207', 2, 7)
    , ('H209', 4, 9)
    , ('J010', 5, 1)
    , ('K011', 1, 11)
    , ('L012', 2, 12)
    , ('K211', 1, 1)
    , ('L212', 2, 12);
GO

INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES
      ('A101', 1, 2), ('A201', 2, 3), ('A101', 3, 4), ('A201', 4, 5)
    , ('B103', 2, 3), ('D201', 3, 4), ('D101', 4, 5), ('D201', 5, 6)
    , ('C101', 3, 4), ('C201', 4, 5), ('C101', 5, 6), ('C201', 6, 7)
    , ('D101', 4, 5), ('D201', 5, 6), ('D101', 6, 7), ('D201', 7, 8)
    , ('E101', 5, 6), ('E201', 6, 7), ('E101', 7, 8), ('E201', 8, 9)
    , ('A101', 15, 12), ('A201', 14, 11), ('A101', 13, 10), ('A201', 12, 9)
    , ('B103', 14, 11), ('B201', 13, 10), ('B101', 12, 9), ('B201', 11, 8)
    , ('C101', 13, 10), ('C201', 12, 9), ('C101', 11, 8), ('C201', 10, 7)
    , ('D101', 12, 9), ('D201', 11, 8), ('D101', 10, 7), ('D201', 9, 6)
    , ('A101', 11, 8), ('A201', 10, 7), ('D101', 9, 6), ('D201', 8, 5);
GO

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
      (1, 1), (1, 11)
    , (2, 2), (2, 12)
    , (3, 3), (3, 13)
    , (4, 4), (4, 14)
    , (5, 5), (5, 15)
    , (6, 6), (6, 16)
    , (7, 7), (7, 17)
    , (8, 8), (8, 18)
    , (9, 9), (9, 19)
    , (10, 10), (10, 20);
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

