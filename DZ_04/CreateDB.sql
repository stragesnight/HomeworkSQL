-- Домашнаяя Работа №4
--  Ученик: Шелест Александр

USE Academy;
GO

IF OBJECT_ID(N'dbo.Departments', N'U') IS NOT NULL
    DROP TABLE Departments;
GO

CREATE TABLE Departments(
      Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Financing MONEY NOT NULL DEFAULT 0 CHECK (Financing >= 0)
    , Name NVARCHAR(32) NOT NULL UNIQUE CHECK (Name != '')
);
GO


IF OBJECT_ID(N'dbo.Faculties', N'U') IS NOT NULL
    DROP TABLE Faculties;
GO

CREATE TABLE Faculties(
      Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Dean NVARCHAR(32) NOT NULL CHECK (Dean != '')
    , Name NVARCHAR(32) NOT NULL UNIQUE CHECK (Name != '')
);
GO

IF OBJECT_ID(N'dbo.Groups', N'U') IS NOT NULL
    DROP TABLE Groups;
GO

CREATE TABLE Groups(
      Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    , Name NVARCHAR(10) NOT NULL UNIQUE CHECK (Name != '')
    , Rating INT NOT NULL CHECK (Rating >= 0 AND Rating <= 5)
    , Year INT NOT NULL CHECK (Year > 0 AND Year <= 5)
);
GO

IF OBJECT_ID(N'dbo.Teachers', N'U') IS NOT NULL
    DROP TABLE Teachers;
GO

CREATE TABLE Teachers(
      Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY
    , EmploymentDate DATE NOT NULL CHECK (EmploymentDate >= '1990-01-01')
    , IsAssistant BIT NOT NULL DEFAULT 0
    , IsProfessor BIT NOT NULL DEFAULT 0
    , Name NVARCHAR(16) NOT NULL CHECK (Name != '')
    , Surname NVARCHAR(18) NOT NULL CHECK (Surname != '')
    , Position NVARCHAR(32) NOT NULL CHECK (Position != '')
    , Premium MONEY NOT NULL DEFAULT 0 CHECK (Premium >= 0)
    , Salary MONEY NOT NULL CHECK (Salary >= 0)
);
GO


INSERT INTO Departments(Financing, Name) VALUES
      (6700,  'Networking & Cybersecurity')
    , (24000, 'Front-End Development')
    , (15670, 'Computer Science')
    , (5600,  'Electronic Engineering')
    , (26000, 'Software Development')
    , (16700, 'Wearable Electronics')
GO

INSERT INTO Faculties(Dean, Name) VALUES
      ('Johnatan Bean', 'Computer Science')
    , ('Bob Beebo', 'Applied Electronics')
    , ('Valentin Marley', 'Front-End Development')
    , ('John Doe', 'Systems Programming In C')
    , ('Donatan Joe', 'Network Architecture')
    , ('Ramjesh Irabul', 'Software Development in Java');
GO

INSERT INTO Groups (Name, Rating, Year) VALUES
      ('PV-011', 5, 2)
    , ('OD-533', 4, 3)
    , ('MD-221', 5, 4)
    , ('EL-005', 3, 1)
    , ('AB-001', 4, 4)
    , ('CC-880', 2, 5);
GO

INSERT INTO Teachers(
    EmploymentDate, 
    IsAssistant, 
    IsProfessor, 
    Name, 
    Surname, 
    Position, 
    Premium, 
    Salary
) VALUES
      ('2008-01-02', 1, 0, 'Diana', 'Chvapkovzky', 'Nurse', 170, 1200)
    , ('2000-02-01', 1, 0, 'Michael', 'Chopkins', 'Door holder', 99, 999)
    , ('2007-03-15', 0, 1, 'Donatan', 'Joe', 'Network Architecture Teacher', 560, 2300)
    , ('2009-10-13', 0, 1, 'Vladimir', 'Dobryakov', 'Software Development In C++', 370, 1100)
    , ('1995-05-06', 1, 0, 'Igor', 'Bogatelya', 'Main Assistant', 467, 1750)
    , ('2012-12-12', 1, 0, 'Bob', 'Dohn', 'Just A Nice Guy', 50, 250)
    , ('1993-02-03', 0, 1, 'Trevor', 'Philips', 'Director', 1600, 7600)
    , ('1999-12-30', 0, 1, 'Ada', 'Lovelace', 'Theory Of Algorithms Teacher', 540, 2500)
    , ('2001-12-21', 0, 1, 'Kurosan', 'Murasaki', 'Programming In C Teacher', 790, 3670)
    , ('2002-07-08', 0, 1, 'Ramjadhul', 'Triadrenjal', 'Java Teacher', 470, 1000);
GO

