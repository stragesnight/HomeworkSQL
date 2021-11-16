-- 1
SELECT 
      D.Building AS BuildingNumer
    , SUM(D.Financing) AS TotalFinancing
FROM Departments AS D
GROUP BY D.Building
HAVING SUM(D.Financing) > 100000;

-- 2
SELECT 
      G.Name AS GroupName
    , COUNT(L.[Date]) AS LectureCount
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
GROUP BY G.Name
HAVING COUNT(L.[Date]) > 10;

-- 3
SELECT
      G.Name AS GroupName
    , AVG(S.Rating) AS GroupRating
FROM GroupsStudents AS GS
INNER JOIN Students AS S
    ON S.Id = GS.StudentId
INNER JOIN Groups AS G
    ON G.Id = GS.GroupId
GROUP BY G.Name
HAVING AVG(S.Rating) > (
    SELECT AVG(S.Rating)
    FROM GroupsStudents AS GS
    INNER JOIN Students AS S
        ON S.Id = GS.StudentId
    INNER JOIN Groups AS G
        ON G.Id = GS.GroupId
    WHERE G.Name = 'D221'
);

-- 4
SELECT
      T.Surname
    , T.Name
    , T.Salary
FROM Teachers AS T
WHERE T.Salary > (
    SELECT AVG(T.Salary)
    FROM Teachers AS T
    WHERE T.IsProfessor = 1
);

-- 5
SELECT
      G.Name AS GroupName
    , COUNT(C.Id) AS CuratorCount
FROM GroupsCurators AS GC
INNER JOIN Groups AS G
    ON G.Id = GC.GroupId
INNER JOIN Curators AS C
    ON C.Id = GC.CuratorId
GROUP BY G.Name
HAVING COUNT(C.Id) > 1;

-- 6
SELECT
      G.Name AS GroupName
    , AVG(S.Rating) AS GroupRating
FROM GroupsStudents AS GS
INNER JOIN Groups AS G
    ON G.Id = GS.GroupId
INNER JOIN Students AS S
    ON S.Id = GS.StudentId
GROUP BY G.Name
HAVING AVG(S.Rating) > (
    SELECT MIN(S.Rating)
    FROM GroupsStudents AS GS
    INNER JOIN Groups AS G
        ON G.Id = GS.GroupId
    INNER JOIN Students AS S
        ON S.Id = GS.StudentId
    WHERE G.Year = 5
);

-- 7
SELECT
      F.Name AS FacultyName
    , SUM(D.Financing) AS TotalFinancing
FROM Departments AS D
INNER JOIN Faculties AS F
    ON F.Id = D.FacultyId
GROUP BY F.Name
HAVING SUM(D.Financing) > (
    SELECT SUM(D.Financing)
    FROM Departments AS D
    INNER JOIN Faculties AS F
        ON F.Id = D.FacultyId
    WHERE F.Name = 'Computer Science'
);

-- 8
SELECT
      S.Name AS SubjectName
    , T.Surname + ' ' + T.Name AS TeacherName
    , MAX(SQ.LCount) AS LectureCount
FROM Lectures AS L
INNER JOIN Subjects AS S
    ON S.Id = L.SubjectId
INNER JOIN Teachers AS T
    ON T.Id = L.TeacherId
INNER JOIN ( 
    SELECT
          S.Id AS SId
        , T.Id AS TId
        , COUNT(L.Id) AS LCount
    FROM Lectures AS L
    INNER JOIN Subjects AS S
        ON S.Id = L.SubjectId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
    GROUP BY S.Id, T.Id
) AS SQ
    ON SQ.SId = S.Id
GROUP BY 
      S.Name
    , T.Surname + ' ' + T.Name;

-- 9
SELECT TOP 1
      S.Name AS SubjectName
    , COUNT(L.Id) AS LectureCount
FROM Lectures AS L
INNER JOIN Subjects AS S
    ON S.Id = L.SubjectId
GROUP BY S.Name
ORDER BY LectureCount;

-- 10
SELECT
      COUNT(DISTINCT STs.STId) AS StudentCount
    , COUNT(DISTINCT Ss.SId) AS SubjectCount
FROM (
    SELECT DISTINCT ST.Id AS STId
    FROM GroupsStudents AS GS
    INNER JOIN Groups AS G
        ON G.Id = GS.GroupId
        INNER JOIN Departments AS D
            ON D.Id = G.DepartmentId
    INNER JOIN Students AS ST
        ON ST.Id = GS.StudentId
    WHERE D.Name = 'Software Development'
) AS STs
, (
    SELECT DISTINCT S.Id AS SId
    FROM GroupsLectures AS GL
    INNER JOIN Groups AS G
        ON G.Id = GL.GroupId
        INNER JOIN Departments AS D
            ON D.Id = G.DepartmentId
    INNER JOIN Lectures AS L
        ON L.Id = GL.LectureId
        INNER JOIN Subjects AS S
             ON S.Id = L.SubjectId
    WHERE D.Name = 'Software Development'
) AS Ss;

