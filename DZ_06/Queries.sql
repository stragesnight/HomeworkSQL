-- 1
SELECT TOP 50
      T.Surname AS Teacher
    , G.Name AS GroupName
FROM
      Teachers AS T
    , Groups AS G
ORDER BY T.Surname;
GO

-- 2
SELECT DISTINCT
    F.Name AS Faculty
FROM Faculties AS F
INNER JOIN Departments AS D
    ON F.Id = D.FacultyId
WHERE F.Financing > D.Financing;
GO

-- 3
SELECT
      C.Surname AS Curator
    , G.Name AS GroupName
FROM GroupsCurators AS GC
INNER JOIN Curators AS C
    ON C.Id = GC.CuratorId
INNER JOIN Groups AS G
    ON G.Id = GC.GroupId;
GO

-- 4
SELECT DISTINCT
      T.Name
    , T.Surname
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
WHERE G.Name = 'P107';
GO

-- 5
SELECT DISTINCT
      T.Surname AS TeacherSurname
    , F.Name AS FacultyName
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
    INNER JOIN Departments AS D
        ON D.Id = G.DepartmentId
        INNER JOIN Faculties AS F
            ON F.Id = D.FacultyId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId;
GO

-- 6
SELECT
      D.Name AS DepartmentName
    , G.Name AS GroupName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
ORDER BY G.Name;
GO

-- 7
SELECT DISTINCT
    S.Name AS SubjectName
FROM Lectures AS L
INNER JOIN Subjects AS S
    ON S.Id = L.SubjectId
INNER JOIN Teachers AS T
    ON T.Id = L.TeacherId
    WHERE T.Name = 'Samantha'
    AND T.Surname = 'Adams';
GO

-- 8
SELECT DISTINCT
    D.Name AS DepartmentName
FROM GroupsLectures AS GL
INNER JOIN Groups G
    ON G.Id = GL.GroupId
    INNER JOIN Departments AS D
        ON D.Id = G.DepartmentId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Subjects AS S
        ON S.Id = L.SubjectId
WHERE S.Name = 'Database Theory';
GO

-- 9
SELECT
    G.Name AS GroupName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
    INNER JOIN Faculties AS F
        ON F.Id = D.FacultyId
WHERE F.Name = 'Computer Science';

-- 10
SELECT
      G.Name AS GroupName
    , F.Name AS FacultyName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
    INNER JOIN Faculties AS F
        ON F.Id = D.FacultyId
WHERE G.Year = 5;

-- 11
SELECT DISTINCT
      (T.Surname + ' ' + T.Name) AS TeacherName
    , S.Name AS SubjectName
    , G.Name AS GroupName
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
    INNER JOIN Subjects AS S
        ON S.Id = L.SubjectId
WHERE L.LectureRoom = 'B103';

