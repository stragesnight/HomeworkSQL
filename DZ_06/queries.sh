#!/bin/bash

# Домашняя Работа №6
#  Ученик: Шелест Александр

PASS=$(cat ~/documents/mssqlserverpass)
CMD="sqlcmd -S localhost -U SA -P $PASS -d Academy -Q"
EXECQ="
echo -e \"\nЗапрос T-SQL: $QUERY\n\"
$CMD \"$QUERY\"
echo -e \"\n\n\""

execq() {
    echo -e "\nЗапрос T-SQL:\n$QUERY\n"
    echo -e "Результат запроса:\n"
    $CMD "$QUERY"
    echo -e "\n\n"
}

echo -e "\n Факультеты:\n"
$CMD "SELECT * FROM Faculties"
echo -e "\n Кафедры:\n"
$CMD "SELECT * FROM Departments"
echo -e "\n Предметы:\n"
$CMD "SELECT * FROM Subjects ORDER BY Id"
echo -e "\n Кураторы:\n"
$CMD "SELECT * FROM Curators ORDER BY Id"
echo -e "\n Группы:\n"
$CMD "SELECT * FROM Groups"
echo -e "\n Учителя:\n"
$CMD "SELECT * FROM Teachers"
echo -e "\n Лекции:\n"
$CMD "SELECT * FROM Lectures"
echo -e "\n группы-кураторы:\n"
$CMD "SELECT * FROM GroupsCurators"
echo -e "\n группы-лекции:\n"
$CMD "SELECT * FROM GroupsLectures"


QUERY="
SELECT TOP 50
      T.Surname AS Teacher
    , G.Name AS GroupName
FROM
      Teachers AS T
    , Groups AS G
ORDER BY T.Surname; "
echo '1. Вывести все возможные пары строк'
echo '   преподавателей и групп'
execq

QUERY="
SELECT DISTINCT
    F.Name AS Faculty
FROM Faculties AS F
INNER JOIN Departments AS D
    ON F.Id = D.FacultyId
WHERE F.Financing > D.Financing; "
echo '2. Вывести названия факультетов, фонд финансирования'
echo '   которых превышает фонд финансирования факультета'
execq

QUERY="
SELECT
      C.Surname AS Curator
    , G.Name AS GroupName
FROM GroupsCurators AS GC
INNER JOIN Curators AS C
    ON C.Id = GC.CuratorId
INNER JOIN Groups AS G
    ON G.Id = GC.GroupId; "
echo '3. Вывести фамилии кураторов групп и названия'
echo '   групп, которые они курируют'
execq

QUERY="
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
WHERE G.Name = 'P107'; "
echo '4. Вывести имена и фамилии преподавателей,'
echo '   которые читают лекции у группы "P107"'
execq

QUERY="
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
        ON T.Id = L.TeacherId; "
echo '5. Вывести фамилии преподавателей и названия'
echo '   факультетов, в которых они читают лекции'
execq

QUERY="
SELECT
      D.Name AS DepartmentName
    , G.Name AS GroupName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
ORDER BY G.Name; "
echo '6. Вывести названия кафедр и названия'
echo '   групп, которые к ним относятся'
execq

QUERY="
SELECT DISTINCT
    S.Name AS SubjectName
FROM Lectures AS L
INNER JOIN Subjects AS S
    ON S.Id = L.SubjectId
INNER JOIN Teachers AS T
    ON T.Id = L.TeacherId
    WHERE T.Name = 'Samantha'
    AND T.Surname = 'Adams'; "
echo '7. Вывести названия дисциплин, которые читает'
echo '   преподаватель "Samantha Adams"'
execq

QUERY="
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
WHERE S.Name = 'Database Theory'; "
echo '8. Вывести названия кафедр, на которых'
echo '   читается дисциплина "Database Theory"'
execq

QUERY="
SELECT
    G.Name AS GroupName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
    INNER JOIN Faculties AS F
        ON F.Id = D.FacultyId
WHERE F.Name = 'Computer Science'; "
echo '9. Вывести названия групп, которые относятся'
echo '   к факультету "Computer Science"'
execq

QUERY="
SELECT
      G.Name AS GroupName
    , F.Name AS FacultyName
FROM Groups AS G
INNER JOIN Departments AS D
    ON D.Id = G.DepartmentId
    INNER JOIN Faculties AS F
        ON F.Id = D.FacultyId
WHERE G.Year = 5; "
echo '10. Вывести названия групп 5-го курса,'
echo '    а также названия факультетов,'
echo '    к которым они относятся'
execq

QUERY="
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
WHERE L.LectureRoom = 'B103';"
echo '11. Вывести полные имена преподавателей и лекции'
echo '    которые они читают, причем отобрать только те'
echo '    лекции, которые читаются в аудитории "В103"'
execq

