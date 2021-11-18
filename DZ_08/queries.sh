#!/bin/bash

# Домашняя Работа №8
#  Ученик: Шелест Александр

PASS=$(cat ~/documents/mssqlserverpass)
CMD="sqlcmd -S localhost -U SA -P $PASS -d Academy -Q"

execq() {
    echo -e "\nЗапрос T-SQL:\n$QUERY\n"
    echo -e "Результат запроса:\n"
    $CMD "$QUERY"
    echo -e "\n\n"
}

echo -e "\n Teachers:\n"
$CMD "SELECT * FROM Teachers"
echo -e "\n Assistants:\n"
$CMD "SELECT * FROM Assistants"
echo -e "\n Curators:\n"
$CMD "SELECT * FROM Curators"
echo -e "\n Deans:\n"
$CMD "SELECT * FROM Deans"
echo -e "\n Heads:\n"
$CMD "SELECT * FROM Heads"
echo -e "\n Faculties:\n"
$CMD "SELECT * FROM Faculties"
echo -e "\n Faculties:\n"
$CMD "SELECT * FROM Faculties"
echo -e "\n Departments:\n"
$CMD "SELECT * FROM Departments"
echo -e "\n Groups:\n"
$CMD "SELECT * FROM Groups"
echo -e "\n LectureRooms:\n"
$CMD "SELECT * FROM LectureRooms"
echo -e "\n Lectures:\n"
$CMD "SELECT * FROM Lectures"
echo -e "\n Schedules:\n"
$CMD "SELECT * FROM Schedules"
echo -e "\n GroupsCurators:\n"
$CMD "SELECT * FROM GroupsCurators"
echo -e "\n GroupsLectures:\n"
$CMD "SELECT * FROM GroupsLectures"

QUERY="
SELECT DISTINCT LR.Name AS LectureRoomNames
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
INNER JOIN Lectures AS L
    ON L.Id = S.LectureId
    INNER JOIN Teachers AS T
        ON T.Id = L.TeacherId
WHERE T.Name = 'Edward'
AND T.Surname = 'Hopper'; "
echo '1. Вывести названия аудиторий, в которых'
echo '   читает лекции "Edward Hopper"'
execq

QUERY="
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
WHERE G.Name = 'F505'; "
echo '2. Вывести фамилии ассистентов, читающих'
echo '   лекции в группе "F505"'
execq

QUERY="
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
AND T.Surname = 'Carmack'; "
echo '3. Вывести дисциплины, которые читает'
echo '   преподаватель "Alex Carmack" для групп 5 курса'
execq

QUERY="
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
); "
echo '4. Вывести фамилии преподавателей, которые'
echo '   не читают лекции по понедельникам'
execq

QUERY="
SELECT
      LR.Building AS Building
    , LR.Name AS RoomName
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
WHERE NOT S.Class = 3
AND NOT S.DayOfWeek = 3
AND NOT S.Week = 2; "
echo '5. Вывести названия аудиторий, с указанием их'
echo '   корпусов, в которых нету лекций в среду'
echo '   второй недели на третьей паре'
execq

QUERY="
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
); "
echo '6. Вывести полные имена преподавателей факультета'
echo '   "Computer Science", которые не курируют группы'
echo '   кафедры "Software Development"'
execq

QUERY="
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
FROM @Buildings AS B; "
echo '7. Вывести список номеров всех корпусов, которые'
echo '   имеются в таблицах факультетов, кафедр'
echo '   и аудиторий.'
execq

QUERY="
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
ORDER BY TFN.Id;"
echo '8. Вывести полные имена преподавателей в следующем'
echo '   порядке: деканы факультетов, заведующие кафедрами'
echo '   преподаватели, кураторы, ассистенты'
execq

QUERY="
SELECT DISTINCT S.DayOfWeek
FROM Schedules AS S
INNER JOIN LectureRooms AS LR
    ON LR.Id = S.LectureRoomId
WHERE LR.Name IN ('A311', 'A104')
AND LR.Building = 3; "
echo '9. Вывести дни недели (без повторений), в которые'
echo '   имеются занятия в аудиториях "A311" и "А104" корпуса 6'
echo '(корпуса 6 нету по условию, так что я вывел корпус 3)'
execq

