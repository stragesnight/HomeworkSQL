-- Домашнее Задание №11
--  Ученик: Шелест Александр

-- порядок выполнения скриптов:
-- CreateDB.sql -> CreateTriggers.sql -> InsertValues.sql -> Examples.sql

USE SportShop;
GO

-- 1. при добавлении нового товара триггер проверяет его
-- наличие на складе, если такой товар уже есть и новые
-- данные о товаре совпадают с уже существующими данными,
-- вместо добавления происходит обновление информации
-- о количестве товара.

-- добавление товара, отличного от остальных
INSERT INTO Products (type_id, name, quantity, cost, manufacturer_id, price) 
    VALUES (1, 'Some other sneakers', 10, 35, 1, 50);
-- добавление товара-дупликата (идентичный прошлому)
INSERT INTO Products (type_id, name, quantity, cost, manufacturer_id, price) 
    VALUES (1, 'Some other sneakers', 5, 35, 1, 50);
GO
-- теперь вместо добавление нового товара, изменится количество старого
SELECT * FROM Products;
GO


-- 2. при увольнении (удалении из таблицы) сотрудника
-- триггер переносит информацию о сотруднике в таблицу
-- "Архив сотрудников" (EmployeeArchive)

-- удаление сотрудника
DELETE Employees WHERE name = 'Lera' AND position = 'Assistant';
GO
-- вывод архива сотрудников
SELECT * FROM EmployeeArchive;
GO


-- 3. триггер запрещает добавлять нового продавца, если
-- количество существующих продавцов больше 6.

-- сейчас в базе находится 5 продавцов

-- добавление новых продавцов
INSERT INTO Employees (name, surname, fathers, position, application_date, sex, salary)
    -- 6-й продавец добавится
    VALUES ('Test', 'Employee', 'Fathers', 'Cashier', '2021-11-10', 'M', 2000);
INSERT INTO Employees (name, surname, fathers, position, application_date, sex, salary)
    -- но 7-й уже нет
    VALUES ('Should', 'Not', 'Be_Added', 'Cashier', '2021-11-10', 'M', 2000);
GO

SELECT * FROM Employees;
GO

