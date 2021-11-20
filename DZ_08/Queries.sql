-- Домашнее Задание №8
--  Ученик: Шелест Александр

-- 1
SELECT DISTINCT LR.Name AS LectureRoomNames
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
INNER JOIN Lectures AS L
    ON L.Id = S.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
WHERE T.Name = 'Edward'
AND T.Surname = 'Hopper';
GO

-- 2
SELECT DISTINCT T.Surname AS AssistantsSurname
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
        INNER JOIN Assistants AS A
            ON A.TeacherId = T.Id
WHERE G.Name = 'F505';
GO

-- 3
SELECT S.Name AS SubjectName
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
    INNER JOIN Subjects AS S
        ON S.Id = L.SubjectId
WHERE G.Year = 5
AND T.Name = 'Alex'
AND T.Surname = 'Carmack';
GO

-- 4
SELECT T.Surname AS TeachersSurname
FROM Teachers AS T
WHERE T.Id NOT IN (
    SELECT T.Id
    FROM Schedules AS S
    INNER JOIN Lectures AS L
        ON L.Id = S.LectureId
        INNER JOIN Teachers AS T
            ON T.Id = L.TeacherId
    WHERE S.DayOfWeek = 1
);
GO

-- 5
SELECT
      LR.Building AS Building
    , LR.Name AS RoomName
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
WHERE NOT S.Class = 3
AND NOT S.DayOfWeek = 3
AND NOT S.Week = 2;
GO

-- 6
SELECT T.Name + ' ' + T.Surname AS FullName
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
        ON T.Id = L.TeacherId
WHERE F.Name = 'Computer Science'
AND T.Id NOT IN (
    -- список кураторов групп факультетa
    -- 'Software Development'
    SELECT C.TeacherId
    FROM GroupsCurators AS GC
    INNER JOIN Groups AS G
        ON G.Id = GL.GroupId
        INNER JOIN Departments AS D
            ON D.Id = G.DepartmentId
    INNER JOIN Curators AS C
        ON C.Id = GC.CuratorId
    WHERE D.Name = 'Software Development'
);

-- 7
DECLARE @Buildings TABLE (
    BuildingNumber int NOT NULL
);

INSERT INTO @Buildings (BuildingNumber)
    SELECT Building FROM Faculties;
INSERT INTO @Buildings (BuildingNumber)
    SELECT Building FROM Departments;
INSERT INTO @Buildings (BuildingNumber)
    SELECT Building FROM LectureRooms;

SELECT DISTINCT B.BuildingNumber
FROM @Buildings AS B;
GO

-- 8
DECLARE @TeacherFullNames TABLE (
      Id int IDENTITY(1,1) NOT NULL PRIMARY KEY
    , FullName nvarchar(48) NOT NULL
);
-- деканы факультетов
INSERT INTO @TeacherFullNames (FullName)
    SELECT DISTINCT T.Name + ' ' + T.Surname
    FROM Faculties AS F
    INNER JOIN Deans AS D
        ON D.Id = F.DeanId
        INNER JOIN Teachers AS T
            ON T.Id = D.TeacherId;
-- заведующие кафедрами
INSERT INTO @TeacherFullNames (FullName)
    SELECT DISTINCT T.Name + ' ' + T.Surname
    FROM Departments AS D
    INNER JOIN Heads AS H
        ON H.Id = D.HeadId
        INNER JOIN Teachers AS T
            ON T.Id = H.TeacherId;
-- преподаватели
INSERT INTO @TeacherFullNames (FullName)
    SELECT DISTINCT T.Name + ' ' + T.Surname
    FROM Teachers AS T;
-- кураторы
INSERT INTO @TeacherFullNames (FullName)
    SELECT DISTINCT T.Name + ' ' + T.Surname
    FROM Curators AS C
    INNER JOIN Teachers AS T
        ON T.Id = C.TeacherId;
-- ассистенты
INSERT INTO @TeacherFullNames (FullName)
    SELECT DISTINCT T.Name + ' ' + T.Surname
    FROM Assistants AS A
    INNER JOIN Teachers AS T
        ON T.Id = A.TeacherId;

SELECT TFN.FullName FROM @TeacherFullNames AS TFN
ORDER BY TFN.Id;
GO

-- 9
SELECT DISTINCT S.DayOfWeek
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
WHERE LR.Name IN ('A311', 'A104')
AND LR.Building = 3;
GO

