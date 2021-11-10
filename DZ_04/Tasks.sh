#!/bin/sh

echo '-= Домашнее Задание №4 =-'
echo '   Ученик: Шелест Александр'
echo ''
echo ''

PASS=$(cat ~/documents/mssqlserverpass)
CMD="sqlcmd -S localhost -U SA -d Academy -P $PASS -Q"

echo 'Кафедры:'
$CMD "SELECT * FROM Departments"
echo 'Факультеты:'
$CMD "SELECT * FROM Faculties"
echo 'Группы:'
$CMD "SELECT * FROM Groups"
echo 'Учителя:'
$CMD "SELECT * FROM Teachers"
echo ''

TASK="
SELECT * FROM Departments ORDER BY Id DESC"
echo '1. Вывести таблицу кафедр, но расположить её поля в обратном порядке'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Name [Group Name], Rating [Group Rating] FROM Groups"
echo '2. Вывести названия групп и их рейтинги, используя в качестве'
echo '   названий выводимых полей "Group Name" и "Group Rating" соответственно'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT T.Surname,
    (T.Salary / T.Premium * 100) SalaryRatio,
    (T.Salary / (T.Salary + T.Premium) * 100) WageRatio
FROM Teachers T"
echo '3. Вывести для преподавателей их фамилию, процент ставки по отношению'
echo '   к надбавке и процент сатвки по отношению к зарплате'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT ('The dean of faculty \"' + F.Name + '\" is ' + F.Dean) msg
FROM Faculties F "
echo '4. Вывести таблицу факультетов в виде одного поля'
echo '   в следующем формате: "The dean of faculty [faculty] is [dean]."'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname FROM Teachers
    WHERE IsProfessor = 1
    AND Salary > 1050"
echo '5. Вывести фамилии преподавателей, которые являются'
echo '   профессорами и ставка которых превышает 1050'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Name FROM Departments
    WHERE Financing < 11000 OR Financing > 25000"
echo '6. Вывести названия кафедр, фонд финансирования которых'
echo '   меньше 11000 или больше 25000'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Name FROM Faculties WHERE Name != 'Computer Science'"
echo '7. Вывести названия факультетов кроме факультета "Computer Science"'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname, Position FROM Teachers WHERE IsProfessor = 0"
echo '8. Вывести фамилии и должности предподавателей,'
echo '   которые не являются профессорами'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname, Position, Salary, Premium FROM Teachers
    WHERE Premium >= 160 AND Premium <= 550 
    AND IsAssistant = 1"
echo '9. Вывести фамилии, должности, ставки и надбавки ассистентов,'
echo '   у которых надбавка в диапазоне от 160 до 550'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname, Salary FROM Teachers 
    WHERE IsAssistant = 1"
echo '10. Вывести фамилии и ставки ассистентов'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname, Position FROM Teachers
    WHERE EmploymentDate < '2000-01-01'"
echo '11. Вывести фамилии и должности преподавателей, которые'
echo '    были приняты на работу до 01.01.2000'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Name [Name of Department] FROM Departments
    WHERE Name < 'Software Development'
    ORDER BY Name"
echo '12. Вывести названия кафедр. которые в алфавитном порядке'
echo '    располагаются до кафедры "Software Development".'
echo '    Выводимое поле должно иметь название "Name of Department"'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname FROM Teachers
    WHERE IsAssistant = 1
    AND (Salary + Premium) < 1200"
echo '13. Вывести фамилии ассистентов, имеющих зарплату не более 1200'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Name FROM Groups
    WHERE Year = 5
    AND Rating >= 2 AND Rating <= 4"
echo '14. Вывести названия групп 5-го курса, имеющих рейтинг'
echo '    в диапазоне от 2 до 4'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

TASK="
SELECT Surname FROM Teachers
    WHERE IsAssistant = 1
    AND (Salary < 550 OR Premium < 200)"
echo '15. Вывести фамилии ассистентов со ставкой меньше 550'
echo '    или надбавкой меньше 200'
echo "\nЗапрос TSQL: $TASK\n"
$CMD "$TASK"
echo ''

