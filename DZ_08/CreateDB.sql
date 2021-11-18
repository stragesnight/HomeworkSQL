-- Домашнее Задание №8
--  Ученик: Шелест Александр

DROP DATABASE Academy;
CREATE DATABASE Academy;
GO

USE Academy;
GO

PRINT 'CREATING TABLES...'

CREATE TABLE Teachers(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(16) NOT NULL CHECK (Name != '')
    , Surname nvarchar(16) NOT NULL CHECK (Surname != '')

    , PRIMARY KEY (Id)
);
GO

CREATE TABLE Assistants(
      Id int IDENTITY(1,1) NOT NULL
    , TeacherId int NOT NULL
    
    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Assistants_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers (Id)
);
GO

CREATE TABLE Curators(
      Id int IDENTITY(1,1) NOT NULL
    , TeacherId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Curators_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers (Id)
);
GO

CREATE TABLE Deans(
      Id int IDENTITY(1,1) NOT NULL
    , TeacherId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Deans_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers (Id)
);
GO

CREATE TABLE Heads(
      Id int IDENTITY(1,1) NOT NULL
    , TeacherId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Heads_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers (Id)
);
GO

CREATE TABLE Faculties(
      Id int IDENTITY(1,1) NOT NULL
    , Building int NOT NULL CHECK (Building >= 1 AND Building <= 5)
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')
    , DeanId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Faculties_DeanId
      FOREIGN KEY (DeanId) REFERENCES Deans (Id)
);
GO

CREATE TABLE Departments(
      Id int IDENTITY(1,1) NOT NULL
    , Building int NOT NULL CHECK (Building >= 1 AND Building <= 5)
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')
    , FacultyId int NOT NULL
    , HeadId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Departments_FacultyId
      FOREIGN KEY (FacultyId) REFERENCES Faculties (Id)
    , CONSTRAINT FK_Departments_HeadId
      FOREIGN KEY (HeadId) REFERENCES Heads (Id)
);
GO

CREATE TABLE Groups(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')
    , Year int NOT NULL CHECK (Year >= 1 AND Year <= 5)
    , DepartmentId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Groups_DepartmentId
      FOREIGN KEY (DepartmentId) REFERENCES Departments (Id)
);
GO

CREATE TABLE Subjects(
      Id int IDENTITY(1,1) NOT NULL
    , Name nvarchar(32) NOT NULL UNIQUE CHECK (Name != '')

    , PRIMARY KEY (Id)
);
GO

CREATE TABLE LectureRooms(
      Id int IDENTITY(1,1) NOT NULL
    , Building int NOT NULL CHECK (Building >= 1 AND Building <= 5)
    , Name nvarchar(10) NOT NULL UNIQUE CHECK (Name != '')

    , PRIMARY KEY (Id)
);
GO

CREATE TABLE Lectures(
      Id int IDENTITY(1,1) NOT NULL
    , SubjectId int NOT NULL
    , TeacherId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Lectures_SubjectId
      FOREIGN KEY (SubjectId) REFERENCES Subjects (Id)
    , CONSTRAINT FK_Lectures_TeacherId
      FOREIGN KEY (TeacherId) REFERENCES Teachers (Id)

);
GO

CREATE TABLE Schedules(
      Id int IDENTITY(1,1) NOT NULL
    , Class int NOT NULL CHECK (Class >= 1 AND Class <= 8)
    , DayOfWeek int NOT NULL CHECK (DayOfWeek >= 1 AND DayOfWeek <= 7)
    , Week int NOT NULL CHECK (Week >= 1 AND Week <= 52)
    , LectureId int NOT NULL
    , LectureRoomId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_Schedules_LectureId
      FOREIGN KEY (LectureId) REFERENCES Lectures (Id)
    , CONSTRAINT FK_Schedules_LectureRoomId
      FOREIGN KEY (LectureRoomId) REFERENCES LectureRooms (Id)
);
GO

CREATE TABLE GroupsCurators(
      Id int IDENTITY(1,1) NOT NULL
    , GroupId int NOT NULL
    , CuratorId int NOT NULL

    , PRIMARY KEY (Id)
    , CONSTRAINT FK_GroupsCurators_GroupId
      FOREIGN KEY (GroupId) REFERENCES Groups (Id)
    , CONSTRAINT FK_GroupsCurators_CuratorId
      FOREIGN KEY (CuratorId) REFERENCES Curators (Id)
);
GO

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

PRINT 'INSERTING VALUES INTO TABLES...'
GO

-- 2
INSERT INTO Teachers (Name, Surname) VALUES
      ('Alexander', 'Mirosh')
    , ('Bogdan', 'Gorban')
    , ('Carolina', 'Bloomberg')
    , ('Dave', 'McQueen')
    , ('Eugeniy', 'Prostachkov')
    , ('Fedor', 'Barabolya')
    , ('Govard', 'Lovecraft')
    , ('Samantha', 'Adams')
    , ('Igor', 'Svetov')
    , ('Jack', 'Underhill')
    , ('Klint', 'Westwood')
    , ('Lolitta', 'Kryachko')
    , ('Akira', 'Yamaoka')
    , ('Edward', 'Hopper')
    , ('Abbaccyo', 'Vespuchello')
    , ('Chin Lun', 'Bul')
    , ('Jack', 'Black')
    , ('Alex', 'Carmack')
    , ('Lemon', 'Melon')
    , ('Martin', 'Nartin')
    , ('Nicholas', 'Onolas')
    , ('Orest', 'Prest')
    , ('Pavlo', 'Quvlo')
    , ('Qarkin', 'Rarkin')
    , ('Rita', 'Sita')
    , ('Sasuke', 'Uchiha')
    , ('Trevor', 'Uvor')
    , ('Paizuri', 'Nakadashi');
GO

-- 7
INSERT INTO Assistants (TeacherId) VALUES
    (1), (5), (9), (13), (17), (21), (25);
GO

-- 7
INSERT INTO Curators (TeacherId) VALUES
    (2), (6), (10), (14), (18), (22), (26);
GO

-- 7
INSERT INTO Deans (TeacherId) VALUES
    (3), (7), (11), (15), (19), (23), (27);
GO

-- 7
INSERT INTO Heads (TeacherId) VALUES
    (4), (8), (12), (16), (20), (24), (28);
GO

-- 7
INSERT INTO Faculties (Building, Name, DeanId) VALUES
      (1, 'Computer Science', 1)
    , (2, 'Radioelectronics', 2)
    , (3, 'Cryptocurrencies', 3)
    , (4, 'Networks & Communication', 4)
    , (5, 'Cybersecurity', 5)
    , (1, 'Electronic Engineering', 6)
    , (2, 'Digital Design', 7);
GO

-- 14
INSERT INTO Departments (Building, Name, FacultyId, HeadId) VALUES
      (1, 'Software Development', 1, 1)
    , (1, 'Front-end Development', 1, 1)
    , (2, 'Radiocommunication', 2, 2)
    , (2, 'Communication Algorithms', 2, 2)
    , (3, 'Stock Market', 3, 3)
    , (3, 'Market Analysis', 3, 3)
    , (4, 'Network Communication', 4, 4)
    , (4, 'Network Architecture', 4, 4)
    , (5, 'Malware Analysis', 5, 5)
    , (5, 'Binary Exploitation', 5, 5)
    , (1, 'Integrated Circuits', 6, 6)
    , (1, 'Chip Manufacturing', 6, 6)
    , (2, 'Image Processing in Photoshop', 6, 6)
    , (2, 'Site Design in HTML/CSS', 6, 6);
GO

-- 31
INSERT INTO Groups (Name, Year, DepartmentId) VALUES
      ('B001', 5, 1)
    , ('A002', 5, 2)
    , ('B003', 5, 3)
    , ('C004', 5, 4)
    , ('D221', 5, 5)
    , ('E006', 5, 6)
    , ('F007', 5, 7)
    , ('G008', 5, 8)
    , ('H009', 5, 9)
    , ('P107', 5, 5)
    , ('B203', 5, 3)
    , ('C204', 5, 13)
    , ('E206', 5, 14)
    , ('F207', 5, 7)
    , ('H209', 5, 9)
    , ('J010', 5, 1)
    , ('F505', 5, 7)
    , ('G808', 5, 8)
    , ('H809', 5, 9)
    , ('P807', 5, 5)
    , ('B803', 3, 3)
    , ('C804', 5, 13)
    , ('E896', 1, 14)
    , ('F897', 2, 7)
    , ('H899', 4, 9)
    , ('J890', 5, 1)
    , ('K991', 5, 11)
    , ('K091', 5, 11)
    , ('L092', 2, 12)
    , ('K291', 1, 1)
    , ('L292', 5, 12);
GO

-- 17
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
    , ('Chip Manufacturing Progress')
    , ('Color Theory')
    , ('Site Design in HTML/CSS');
GO

-- 25
INSERT INTO LectureRooms (Building, Name) VALUES
      (1, 'A101'), (1, 'A102'), (1, 'A103'), (1, 'A114'), (1, 'A105')
    , (2, 'A201'), (2, 'A202'), (2, 'A203'), (2, 'A204'), (2, 'A205')
    , (3, 'A311'), (3, 'A302'), (3, 'A303'), (3, 'A104'), (3, 'A305')
    , (4, 'A401'), (4, 'A402'), (4, 'A403'), (4, 'A404'), (4, 'A405')
    , (5, 'A501'), (5, 'A502'), (5, 'A503'), (5, 'A504'), (5, 'A505');
GO

-- 28
INSERT INTO Lectures (SubjectId, TeacherId) VALUES
      (1, 1), (2, 2), (3, 3), (4, 4), (5, 5)
    , (6, 6), (7, 7), (8, 8), (9, 9)
    , (10, 10), (11, 11), (12, 12), (13, 13)
    , (14, 14), (15, 15), (16, 16), (17, 17)
    , (1, 18), (2, 19), (3, 20), (4, 21)
    , (5, 22), (6, 23), (7, 24), (8, 25)
    , (9, 26), (10, 27), (11, 28);
GO

INSERT INTO Schedules (Class, DayOfWeek, Week, LectureId, LectureRoomId) VALUES
      (1, 1, 1, 1, 1), (2, 1, 1, 2, 2), (3, 1, 1, 3, 3), (4, 1, 1, 4, 4)
    , (1, 2, 1, 5, 5), (2, 2, 1, 6, 6), (3, 2, 1, 7, 7), (4, 2, 1, 8, 8)
    , (2, 3, 1, 10, 10), (3, 3, 1, 11, 11), (4, 3, 1, 12, 12), (1, 4, 1, 13, 13)
    , (2, 4, 1, 14, 14), (3, 4, 1, 15, 15), (4, 4, 1, 16, 16), (1, 1, 2, 11, 11)
    , (2, 1, 2, 12, 12), (3, 1, 2, 13, 13), (4, 1, 2, 14, 14), (1, 2, 2, 15, 15)
    , (2, 2, 2, 16, 16), (3, 2, 2, 17, 17), (4, 2, 2, 18, 18), (1, 3, 2, 19, 19)
    , (2, 3, 2, 10, 10), (3, 3, 2, 11, 11), (4, 3, 2, 12, 12), (1, 4, 2, 13, 13)
    , (2, 4, 2, 14, 14), (3, 4, 2, 15, 15), (4, 4, 2, 16, 16), (1, 3, 1, 9, 9);
GO

-- 31
INSERT INTO GroupsCurators (GroupId, CuratorId) VALUES
      (1, 1), (2, 2), (3, 3), (4, 4), (5, 5)
    , (6, 6), (7, 7), (8, 1), (9, 2), (10, 3)
    , (11, 4), (12, 5), (13, 6), (14, 7), (15, 1)
    , (16, 2), (17, 3), (18, 4), (19, 5), (20, 6)
    , (21, 7), (22, 1), (23, 2), (24, 3), (25, 4)
    , (26, 5), (27, 6), (28, 7), (29, 1), (30, 2), (31, 3);
GO

-- 31
INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
      (1, 1), (2, 2), (3, 3), (4, 4), (5, 5)
    , (6, 6), (7, 7), (8, 8), (9, 9), (10, 10)
    , (11, 11), (12, 12), (13, 13), (14, 14), (15, 15)
    , (16, 16), (17, 17), (18, 18), (19, 19), (20, 20)
    , (21, 21), (22, 22), (23, 23), (24, 24), (25, 25)
    , (26, 26), (27, 27), (28, 28), (29, 1), (30, 2), (31, 3);
GO

