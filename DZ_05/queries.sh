#!/bin/bash

# Домашнее Задание №5
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
echo -e "\n Группы:\n"
$CMD "SELECT * FROM Groups"
echo -e "\n Предметы:\n"
$CMD "SELECT * FROM Subjects ORDER BY Id"
echo -e "\n Учителя:\n"
$CMD "SELECT * FROM Teachers"
echo -e "\n Лекции:\n"
$CMD "SELECT * FROM Lectures"
echo -e "\n Группы-лекции:\n"
$CMD "SELECT * FROM GroupsLectures"


QUERY="
SELECT COUNT(DISTINCT L.TeacherId) TeacherCount 
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
INNER JOIN Groups G
    ON G.Id = GL.GroupId
    INNER JOIN Departments D
        ON D.Id = G.DepartmentId
        WHERE D.Name = 'Software Development';"
echo '1. Вывести количество преподавателей'
echo '   кафедры “Software Development”.'
execq

QUERY="
SELECT COUNT(*) McQueensLectures 
FROM Lectures
INNER JOIN Teachers T
    ON T.Id = TeacherId
    WHERE T.Name = 'Dave' AND T.Surname = 'McQueen';"
echo '2. Вывести количество лекций, которые читает'
echo '   преподаватель “Dave McQueen”.'
execq

QUERY="
SELECT COUNT(*) LecturesInD201 
FROM Lectures
    WHERE LectureRoom = 'D201';"
echo '3. Вывести количество занятий, проводимых'
echo '   в аудитории “D201”.'
execq

QUERY="
SELECT LectureRoom, COUNT(*) LectureCount 
FROM Lectures
GROUP BY LectureRoom;"
echo '4. Вывести названия аудиторий и количество'
echo '   лекций, проводимых в них.'
execq

QUERY="
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
    ON G.Id = DistinctGroups.GId;"
echo '5. Вывести количество студентов, посещающих '
echo '   лекции преподавателя “Jack Underhill”.'
execq

QUERY="
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
            WHERE F.Name = 'Computer Science';"
echo '6. Вывести среднюю ставку преподавателей'
echo '   факультета “Computer Science”.'
execq

QUERY="
SELECT 
      MIN(Students) MinStuds
    , MAX(Students) MaxStuds
FROM Groups;"
echo '7. Вывести минимальное и максимальное количество'
echo '   студентов среди всех групп.'
execq

QUERY="
SELECT AVG(Financing) AvgFinancing
FROM Departments;"
echo '8. Вывести средний фонд финансирования кафедр'
execq

QUERY="
SELECT
      (T.Name + ' ' + T.Surname) FullName
    , COUNT(DISTINCT L.SubjectId) SubjectCount
FROM Lectures L
INNER JOIN Teachers T
    ON T.Id = L.TeacherId
GROUP BY (T.Name + ' ' + T.Surname);"
echo '9. Вывести полные имена преподавателей и количество'
echo '   читаемых ими дисциплин.'
execq

QUERY="
SELECT 
      DayOfWeek
    , COUNT(*) NumLectures
FROM Lectures
GROUP BY DayOfWeek;"
echo '10. Вывести количество лекций в каждый день недели.'
execq

QUERY="
SELECT 
      L.LectureRoom
    , COUNT(DISTINCT G.DepartmentId) DepartmentCount
FROM GroupsLectures GL
INNER JOIN Lectures L
    ON L.Id = GL.LectureId
INNER JOIN Groups G
    ON G.Id = GL.GroupId
GROUP BY L.LectureRoom;"
echo '11. Вывести номера аудиторий и количество кафедр,'
echo '    чьи лекции в них читаются.'
execq

QUERY="
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
GROUP BY F.Name;"
echo '12. Вывести названия факультетов и количество дисциплин,'
echo '    которые на них читаются.'
execq

QUERY="
SELECT
      (T.Surname + ', ' + L.LectureRoom) TeacherRoomPair
    , COUNT(DISTINCT L.SubjectId) SubjectCount
FROM Lectures L
INNER JOIN Teachers T
    ON T.Id = L.TeacherId
GROUP BY (T.Surname + ', ' + L.LectureRoom);"
echo '13. Вывести количество лекций для каждой пары'
echo '    преподаватель-аудитория.'
execq

