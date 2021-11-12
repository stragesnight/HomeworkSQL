-- 1
SELECT COUNT(DISTINCT L.TeacherId) TeacherCount 
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
INNER JOIN Groups G
    ON G.Id = GL.GroupId
    INNER JOIN Departments D
        ON D.Id = G.DepartmentId
        WHERE D.Name = 'Software Development';
GO

-- 2
SELECT COUNT(*) McQueensLectures 
FROM Lectures
INNER JOIN Teachers T
    ON T.Id = TeacherId
    WHERE T.Name = 'Dave' AND T.Surname = 'McQueen';
GO

-- 3
SELECT COUNT(*) LecturesInD201 
FROM Lectures
    WHERE LectureRoom = 'D201';
GO

-- 4
SELECT LectureRoom, COUNT(*) LectureCount 
FROM Lectures
GROUP BY LectureRoom;
GO

-- 5
SELECT SUM(G.Students) StudentCount
FROM (
SELECT DISTINCT GL.GroupId GId
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers T
        ON T.Id = L.TeacherId
        WHERE T.Name = 'Jack' 
        AND T.Surname = 'Underhill'
) DistinctGroups
INNER JOIN Groups G
    ON G.Id = DistinctGroups.GId;
GO

-- 6
SELECT AVG(DISTINCT T.Salary) AvgSalary
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers T
        ON T.Id = L.TeacherId
INNER JOIN Groups G
    ON G.Id = GL.GroupId
    INNER JOIN Departments D
        ON D.Id = G.DepartmentId
        INNER JOIN Faculties F
            ON F.Id = D.FacultyId
            WHERE F.Name = 'Computer Science';
GO

-- 7
SELECT 
      MIN(Students) MinStuds
    , MAX(Students) MaxStuds
FROM Groups;
GO

-- 8
SELECT AVG(Financing) AvgFinancing
FROM Departments;
GO

-- 9
SELECT
      (T.Name + ' ' + T.Surname) FullName
    , COUNT(DISTINCT L.SubjectId) SubjectCount
FROM Lectures L
INNER JOIN Teachers T
    ON T.Id = L.TeacherId
GROUP BY (T.Name + ' ' + T.Surname);
GO

-- 10
SELECT 
      DayOfWeek
    , COUNT(*) NumLectures
FROM Lectures
GROUP BY DayOfWeek;
GO

-- 11
SELECT 
      L.LectureRoom
    , COUNT(DISTINCT G.DepartmentId) DepartmentCount
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
INNER JOIN Groups G
    ON G.Id = GL.GroupId
GROUP BY L.LectureRoom;
GO

-- 12
SELECT
      F.Name
    , COUNT(DISTINCT L.SubjectId) SubjectCount
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
INNER JOIN Groups G 
    ON G.Id = GL.GroupId
    INNER JOIN Departments D
        ON D.Id = G.DepartmentId
        INNER JOIN Faculties F
            ON F.Id = D.FacultyId
GROUP BY F.Name;
GO

-- 13
SELECT
      (T.Surname + ', ' + L.LectureRoom) TeacherRoomPair
    , COUNT(DISTINCT L.SubjectId) SubjectCount
FROM Lectures L
INNER JOIN Teachers T
    ON T.Id = L.TeacherId
GROUP BY (T.Surname + ', ' + L.LectureRoom);
GO

