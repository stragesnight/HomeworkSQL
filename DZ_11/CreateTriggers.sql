-- Домашнее Задание №11
--  Ученик: Шелест Александр

-- порядок выполнения скриптов:
-- CreateDB.sql -> CreateTriggers.sql -> InsertValues.sql -> Examples.sql

USE SportShop;
GO

-- удалить существующие обьекты
if OBJECT_ID('FN_IsDuplicateProduct') IS NOT NULL
    DROP FUNCTION FN_IsDuplicateProduct;
GO
if OBJECT_ID('FN_NumCachiers') IS NOT NULL
    DROP FUNCTION FN_NumCachiers;
GO
IF OBJECT_ID('TR_Insert_Product') IS NOT NULL
    DROP TRIGGER TR_Insert_Product;
GO
IF OBJECT_ID('TR_Fire_Employee') IS NOT NULL
    DROP TRIGGER TR_Fire_Employee;
GO


-- проверить, является ли товар дубликатом 
CREATE FUNCTION FN_IsDuplicateProduct
    (
          @type_id INT
        , @name NVARCHAR(32)
        , @cost DECIMAL(8,2)
        , @manufacturer_id INT
        , @price DECIMAL(8,2)
    )
RETURNS INT
AS
BEGIN
    DECLARE @res INT;
    -- если хотя бы один товар соответствует условию запроса,
    -- то переменной @res присвается 1, т.е. дубликат найден
    SELECT @res = COUNT(*)
    FROM Products AS P
    WHERE @type_id = P.type_id
    AND @name = P.name
    AND @cost = P.cost
    AND @manufacturer_id = P.manufacturer_id
    AND @price = P.price;

    RETURN @res;
END
GO

-- вычислить количество продавцов
CREATE FUNCTION FN_NumCachiers ()
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT;

    SELECT @cnt = COUNT(*)
    FROM Employees AS E
    WHERE LOWER(E.position) = 'cashier';

    return @cnt;
END
GO

-- 1. при добавлении нового товара триггер проверяет его
-- наличие на складе, если такой товар уже есть и новые
-- данные о товаре совпадают с уже существующими данными,
-- вместо добавления происходит обновление информации
-- о количестве товара.
CREATE TRIGGER TR_Insert_Product ON Products
INSTEAD OF INSERT -- заменяет INSERT
AS
BEGIN
    -- обновить количество товаров, если их дубликат был найден
    UPDATE P SET P.quantity = P.quantity + I.quantity
    FROM Products AS P
    INNER JOIN inserted AS I
        ON I.type_id = P.type_id
        AND I.name = P.name
        AND I.cost = P.cost
        AND I.manufacturer_id = P.manufacturer_id
        AND I.price = P.price;
    -- вставить в таблицу Products значения из таблицы inserted
    -- если их дубликат не был найден
    INSERT INTO Products 
          (type_id, name, quantity, cost, manufacturer_id, price)
    SELECT type_id, name, quantity, cost, manufacturer_id, price
    FROM inserted
    -- * функция объявлена выше, проверяет наличие товара с заданными параметрами *
    WHERE dbo.FN_IsDuplicateProduct(type_id, name, cost, manufacturer_id, price) = 0;
END
GO

-- 2. при увольнении (удалении из таблицы) сотрудника
-- триггер переносит информацию о сотруднике в таблицу
-- "Архив сотрудников" (EmployeeArchive)
CREATE TRIGGER TR_Fire_Employee ON Employees
FOR DELETE -- выполняется после DELETE
AS
BEGIN
    -- встввить в таблицу EmployeeArchive значения из табилцы deleted
    INSERT INTO EmployeeArchive 
    (name, surname, fathers, position, application_date, sex, salary)
    SELECT name, surname, fathers, position, application_date, sex, salary
    FROM deleted;
END
GO

-- 3. триггер запрещает добавлять нового продавца, если
-- количество существующих продавцов больше 6.
CREATE TRIGGER TR_Add_Cashier ON Employees
INSTEAD OF INSERT -- заменяет INSERT
AS
BEGIN
    -- вставить в таблицу Employees значения из таблицы inserted
    INSERT INTO Employees
    (name, surname, fathers, position, application_date, sex, salary)
    SELECT name, surname, fathers, position, application_date, sex, salary
    FROM inserted AS I
    -- если новый сотрудник - не продавец
    WHERE LOWER(I.position) != 'cashier'
    -- или если количество продавцов меньше 6
    OR dbo.FN_NumCachiers() < 6;
END
GO

