
-- Домашняя Работа №7
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
ALTER TABLE GroupsStudents 
    DROP CONSTRAINT IF EXISTS 
          FK_GroupsStudents_GroupId
        , FK_GroupsStudents_StudentId;
GO

DROP TABLE IF EXISTS Faculties;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Curators;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Lectures;
DROP TABLE IF EXISTS GroupsCurators;
DROP TABLE IF EXISTS GroupsLectures;
DROP TABLE IF EXISTS GroupsStudents;
GO


CREATE TABLE Faculties(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(48) NOT NULL UNIQUE CHECK (Name != '')

    , PRIMARY KEY (Id)
);

CREATE TABLE Departments(
      Id int IDENTITY(1,1) NOT NULL
    , Building int NOT NULL CHECK (Building >= 1 AND Building <= 5)
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
    , IsProfessor bit NOT NULL DEFAULT 0
    , Name nvarchar(16) NOT NULL CHECK (Name != '')
    , Surname nvarchar(16) NOT NULL CHECK (Surname != '')
    , Salary money NOT NULL CHECK (Salary > 0)

    , PRIMARY KEY (Id)
);

CREATE TABLE Students(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(16) NOT NULL CHECK (Name != '')
    , Surname nvarchar(16) NOT NULL CHECK (Surname != '')
    , Rating int NOT NULL CHECK (Rating >= 0 AND Rating <= 5)

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
    , [Date] date NOT NULL CHECK ([Date] < '2021-11-16') 
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

CREATE TABLE GroupsStudents(
      Id int IDENTITY(1,1) NOT NULL
    , GroupId int NOT NULL
    , StudentId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_GroupsStudents_GroupId
      FOREIGN KEY (GroupId) REFERENCES Groups (Id)
    , CONSTRAINT FK_GroupsStudents_StudentId
      FOREIGN KEY (StudentId) REFERENCES Students (Id)
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

INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES
      (1, 53000, 'Software Development', 1)
    , (2, 16000, 'Front-end Development', 1)
    , (3, 10000, 'Radiocommunication', 2)
    , (4, 11000, 'Communication Algorithms', 2)
    , (5, 67000, 'Stock Market', 3)
    , (1, 45000, 'Market Analysis', 3)
    , (2, 10000, 'Network Communication', 4)
    , (3, 11500, 'Network Architecture', 4)
    , (4, 14500, 'Malware Analysis', 5)
    , (5, 57000, 'Binary Exploitation', 5)
    , (1, 15000, 'Integrated Circuits', 6)
    , (2, 11500, 'Chip Manufacturing', 6);
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

INSERT INTO Teachers (IsProfessor, Name, Surname, Salary) VALUES
      (1, 'Alexander', 'Mirosh', 1600)
    , (1, 'Bogdan', 'Gorban', 1700)
    , (1, 'Carolina', 'Bloomberg', 1800)
    , (1, 'Dave', 'McQueen', 1900)
    , (1, 'Eugeniy', 'Prostachkov', 2000)
    , (1, 'Fedor', 'Barabolya', 2100)
    , (1, 'Govard', 'Lovecraft', 2200)
    , (1, 'Samantha', 'Adams', 2300)
    , (1, 'Igor', 'Svetov', 2400)
    , (1, 'Jack', 'Underhill', 1600)
    , (1, 'Klint', 'Westwood', 1700)
    , (1, 'Lolitta', 'Kryachko', 1800)
    , (0, 'Akira', 'Yamaoka', 1500)
    , (0, 'Valentin', 'Prikolov', 1400)
    , (0, 'Abbaccyo', 'Vespuchello', 1600)
    , (0, 'Chin Lun', 'Bul', 1500);
GO

INSERT INTO Students (Name, Surname, Rating) VALUES
      ('Abdul', 'Babul', 4)
    , ('Bob', 'Clob', 3)
    , ('Carl', 'Darl', 2)
    , ('Denis', 'Enis', 1)
    , ('Evan', 'Fevan', 5)
    , ('Frank', 'Sinatra', 4)
    , ('George', 'Michael', 3)
    , ('Hugo', 'Igo', 2)
    , ('Ivanna', 'Jovanna', 1)
    , ('Jack', 'Black', 5)
    , ('Katerine', 'Lateline', 4)
    , ('Lemon', 'Melon', 3)
    , ('Martin', 'Nartin', 2)
    , ('Nicholas', 'Onolas', 1)
    , ('Orest', 'Prest', 5)
    , ('Pavlo', 'Quvlo', 4)
    , ('Qarkin', 'Rarkin', 3)
    , ('Rita', 'Sita', 2)
    , ('Sasuke', 'Uchiha', 1)
    , ('Trevor', 'Uvor', 5)
    , ('Umal', 'Jamal', 4)
    , ('Vitaliy', 'Vitalniy', 3)
    , ('Angelina', 'Bangelina', 2)
    , ('Bertold', 'Certold', 1)
    , ('Charley', 'Chocoletto', 5)
    , ('Dan', 'Ean', 4)
    , ('Embargo', 'Baremgo', 3)
    , ('Fumo', 'Nakadashi', 2)
    , ('Grigoriy', 'Skovoroda', 1)
    , ('Hindul', 'Indul', 5)
    , ('Ibragim', 'Nosenberg', 4)
    , ('Julia', 'Kulia', 3)
    , ('Karp', 'Larp', 2)
    , ('Linus', 'Torvalds', 1)
    , ('Minato', 'Kintama', 5)
    , ('Nolbert', 'Friderich', 4)
    , ('Oksana', 'Sqlenko', 3)
    , ('Patricia', 'Bernisia', 2)
    , ('Qulba', 'Trulba', 1)
    , ('Retardinio', 'Computerino', 5);
GO

INSERT INTO Groups (Name, Year, DepartmentId) VALUES
      ('B001', 1, 1)
    , ('A002', 2, 2)
    , ('B003', 3, 3)
    , ('C004', 4, 4)
    , ('D221', 5, 5)
    , ('E006', 1, 6)
    , ('F007', 2, 7)
    , ('G008', 3, 8)
    , ('H009', 4, 9)
    , ('P107', 2, 5)
    , ('B203', 3, 3)
    , ('C204', 5, 4)
    , ('E206', 1, 5)
    , ('F207', 2, 7)
    , ('H209', 4, 9)
    , ('J010', 5, 1)
    , ('K011', 5, 11)
    , ('L012', 2, 12)
    , ('K211', 1, 1)
    , ('L212', 5, 12);
GO

INSERT INTO Lectures ([Date], SubjectId, TeacherId) VALUES
      ('2017-05-06', 1, 2), ('2017-05-06', 2, 3)
    , ('2017-05-07', 3, 4), ('2017-05-07', 4, 5)
    , ('2017-05-08', 2, 3), ('2017-05-08', 3, 4)
    , ('2017-05-09', 4, 5), ('2017-05-09', 5, 6)
    , ('2017-05-10', 3, 4), ('2017-05-10', 4, 5)
    , ('2017-05-17', 5, 6), ('2017-05-17', 6, 7)
    , ('2017-05-18', 4, 5), ('2017-05-18', 5, 6)
    , ('2017-05-19', 6, 7), ('2017-05-19', 7, 8)
    , ('2017-05-20', 5, 6), ('2017-05-20', 6, 7)
    , ('2017-05-23', 7, 8), ('2017-05-23', 8, 9)
    , ('2017-05-24', 15, 12), ('2017-05-24', 14, 11)
    , ('2017-05-25', 13, 10), ('2017-05-25', 12, 9)
    , ('2017-05-26', 14, 11), ('2017-05-26', 13, 10)
    , ('2017-05-27', 12, 9), ('2017-05-27', 11, 8)
    , ('2017-06-02', 13, 10), ('2017-06-02', 12, 9)
    , ('2017-06-03', 11, 8), ('2017-06-04', 10, 7)
    , ('2017-06-04', 12, 9), ('2017-06-04', 11, 8)
    , ('2017-06-05', 10, 7), ('2017-06-05', 9, 6)
    , ('2017-06-06', 11, 8), ('2017-06-06', 10, 7)
    , ('2017-06-07', 9, 6), ('2017-06-07', 8, 5);
GO

INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
      (1, 1), (1, 11), (1, 9)
    , (2, 2), (2, 12), (2, 9)
    , (3, 3), (3, 13), (3, 1)
    , (4, 4), (4, 14), (4, 1)
    , (5, 5), (5, 15)
    , (6, 6), (6, 16)
    , (7, 7), (7, 17), (7, 15)
    , (8, 8), (8, 18), (8, 15)
    , (9, 9), (9, 19), (9, 18)
    , (10, 10), (10, 20);
GO

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
      (1, 1), (2, 2), (3, 3), (4, 4), (5, 5)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (11, 11), (12, 12), (1, 13), (2, 14), (3, 15)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (9, 21), (10, 22), (11, 23), (12, 24), (1, 25)
    , (2, 26), (3, 27), (4, 28), (5, 29), (6, 30)
    , (7, 31), (8, 32), (9, 33), (10, 34), (11, 35)
    , (12, 36), (1, 37), (2, 38), (3, 39), (4, 40)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (11, 11), (12, 12), (1, 13), (2, 14), (3, 15)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (4, 16), (5, 17), (6, 18), (7, 19), (8, 20)
    , (9, 21), (10, 22), (11, 23), (12, 24), (1, 25)
    , (2, 26), (3, 27), (4, 28), (5, 29), (6, 30)
    , (7, 31), (8, 32), (9, 33), (10, 34), (11, 35)
    , (12, 36), (1, 37), (2, 38), (3, 39), (4, 40);
GO

INSERT INTO GroupsStudents (GroupId, StudentId) VALUES
      (1, 1), (1, 2), (1, 3), (1, 4)
    , (2, 1), (2, 2)
    , (3, 5), (3, 6), (3, 7), (3, 8)
    , (4, 5), (4, 6)
    , (5, 9), (5, 10), (5, 11), (5, 12)
    , (6, 9), (6, 10)
    , (7, 13), (7, 14), (7, 15), (7, 16)
    , (8, 13), (8, 14)
    , (9, 17), (9, 18), (9, 19), (9, 20)
    , (10, 17), (10, 18)
    , (11, 21), (11, 22), (11, 23), (11, 24)
    , (12, 21), (12, 22)
    , (13, 25), (13, 26), (13, 27), (13, 28)
    , (14, 25), (14, 26)
    , (15, 29), (15, 30), (15, 31), (15, 32)
    , (16, 29), (16, 30)
    , (17, 33), (17, 34), (17, 35), (17, 36)
    , (18, 33), (18, 34)
    , (19, 37), (19, 38), (19, 39), (19, 40)
    , (20, 37), (20, 38);
GO

