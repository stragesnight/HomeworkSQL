#!/bin/bash

# Домашняя Работа №6
#  Ученик: Шелест Александр

PASS=$(cat ~/documents/mssqlserverpass)
CMD="sqlcmd -S localhost -U SA -P $PASS -d Academy -Q"

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
echo -e "\n Студенты:\n"
$CMD "SELECT * FROM Students ORDER BY Id"
echo -e "\n Лекции:\n"
$CMD "SELECT * FROM Lectures"
echo -e "\n Группы-кураторы:\n"
$CMD "SELECT * FROM GroupsCurators"
echo -e "\n Группы-лекции:\n"
$CMD "SELECT * FROM GroupsLectures"
echo -e "\n Группы-студенты:\n"
$CMD "SELECT * FROM GroupsStudents"

QUERY="
SELECT 
      D.Building AS BuildingNumer
    , SUM(D.Financing) AS TotalFinancing
FROM Departments AS D
GROUP BY D.Building
HAVING SUM(D.Financing) > 100000; "
echo '1. Вывести номера корпусов, если суммарный'
echo '   фонд финансирования расположеннных в них'
echo '   кафедр превышает 100000'
execq

QUERY="
SELECT 
      G.Name AS GroupName
    , COUNT(L.[Date]) AS LectureCount
FROM GroupsLectures AS GL
INNER JOIN Groups AS G
    ON G.Id = GL.GroupId
INNER JOIN Lectures AS L
    ON L.Id = GL.LectureId
GROUP BY G.Name
HAVING COUNT(L.[Date]) > 10; "
echo '2. Вывести названия групп 5-го курса кафедры'
echo '   "Software Development", которые имеют'
echo '   более 10 пар в первую неделю'
execq

QUERY="
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
); "
echo '3. Вывести названия групп, имеющих рейтинг'
echo '   больше, чем рейтинг группы "D221"'
execq

QUERY="
SELECT
      T.Surname
    , T.Name
    , T.Salary
FROM Teachers AS T
WHERE T.Salary > (
    SELECT AVG(T.Salary)
    FROM Teachers AS T
    WHERE T.IsProfessor = 1
); "
echo '4. Вывести фамилии и имена преподавателей,'
echo '   ставка которых выше средней ставки профессоров'
execq

QUERY="
SELECT
      G.Name AS GroupName
    , COUNT(C.Id) AS CuratorCount
FROM GroupsCurators AS GC
INNER JOIN Groups AS G
    ON G.Id = GC.GroupId
INNER JOIN Curators AS C
    ON C.Id = GC.CuratorId
GROUP BY G.Name
HAVING COUNT(C.Id) > 1; "
echo '5. Вывести названия групп, у которых'
echo '   больше одного куратора'
execq

QUERY="
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
);"
echo '6. Вывести названия групп, имеющих рейтинг'
echo '   больше, чем минимальный рейтинг '
echo '   групп 5-го курса'
execq

QUERY="
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
); "
echo '7. Вывести названия факультетов, суммарный'
echo '   фонд финансирования которых больше суммарного'
echo '   фонда кафедр факультета "Computer Science"'
execq

QUERY="
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
    , T.Surname + ' ' + T.Name;"
echo '8. Вывести названия дисциплин и полные имена'
echo '   преподавателей, читающих наибольшее'
echo '   количество лекций по ним'
execq

QUERY="
SELECT TOP 1
      S.Name AS SubjectName
    , COUNT(L.Id) AS LectureCount
FROM Lectures AS L
INNER JOIN Subjects AS S
    ON S.Id = L.SubjectId
GROUP BY S.Name
ORDER BY LectureCount;"
echo '9. Вывести название дисциплины, по которому'
echo '   читается меньше всего лекций'
execq

QUERY="
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
) AS Ss; "
echo '10. Вывести количество студентов и читаемых'
echo '    дисциплин на кафедре "Software Development"'
execq

