-- Домашнее Задание №10
--  Ученик: Шелест Александр

-- порядок выполнения скриптов:
-- CreateDB.sql -> CreateTriggers.sql -> InsertValues.sql

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO


-- создать базу данных, если она ещё не создана

IF DB_ID('SportShop') IS NULL
    CREATE DATABASE SportShop;
GO

USE SportShop;
GO


-- удалить внешние ключи

IF OBJECT_ID('Products') IS NOT NULL
BEGIN
    ALTER TABLE Products
        DROP CONSTRAINT IF EXISTS 
              FK_Products_type_id
            , FK_Products_manufacturer_id;
END
GO
IF OBJECT_ID('Orders') IS NOT NULL
BEGIN
    ALTER TABLE Orders
        DROP CONSTRAINT IF EXISTS 
              FK_Orders_prod_id
            , FK_Order_employee_id
            , FK_Order_cust_id;
END
GO


-- удалить таблицы

DROP TABLE IF EXISTS ProductTypes;
DROP TABLE IF EXISTS Manufacturers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS EmployeeArchive;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
GO


-- создать таблицы

CREATE TABLE ProductTypes (
      id INT IDENTITY(1,1) NOT NULL
    , name NVARCHAR(64) NOT NULL CHECK (name != '')

    , PRIMARY KEY (id)
);
GO

CREATE TABLE Manufacturers (
      id INT IDENTITY(1,1) NOT NULL
    , name NVARCHAR(64) NOT NULL CHECK (name != '')

    , PRIMARY KEY (id)
);
GO

CREATE TABLE Employees (
      id INT IDENTITY(1,1) NOT NULL
    , name NVARCHAR(32) NOT NULL CHECK (name != '')
    , surname NVARCHAR(32) NOT NULL
    , fathers NVARCHAR(32) NULL
    , position NVARCHAR(32) NOT NULL CHECK (position != '')
    , application_date DATE NOT NULL CHECK (application_date >= '2020-02-02')
    , sex CHAR(1) NOT NULL CHECK (sex = 'M' OR sex = 'F')
    , salary DECIMAL(8,2) NOT NULL CHECK (salary >= 0)
    
    , PRIMARY KEY (id)
);
GO

CREATE TABLE EmployeeArchive (
      id INT IDENTITY(1,1) NOT NULL
    , name NVARCHAR(32) NOT NULL CHECK (name != '')
    , surname NVARCHAR(32) NOT NULL
    , fathers NVARCHAR(32) NULL
    , position NVARCHAR(32) NOT NULL CHECK (position != '')
    , application_date DATE NOT NULL CHECK (application_date >= '2020-02-02')
    , sex CHAR(1) NOT NULL CHECK (sex = 'M' OR sex = 'F')
    , salary DECIMAL(8,2) NOT NULL CHECK (salary >= 0)
    
    , PRIMARY KEY (id)
);
GO

CREATE TABLE Customers (
      id INT IDENTITY(1,1) NOT NULL
    , name NVARCHAR(32) NOT NULL CHECK (name != '')
    , surname NVARCHAR(32) NOT NULL
    , fathers NVARCHAR(32) NULL
    , email NVARCHAR(24) NULL
    , contact_phone NVARCHAR(14) NULL
    , sex CHAR(1) NOT NULL CHECK (sex = 'M' OR sex = 'F')
    --, order_history
    , discount DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK (discount >= 0 AND discount <= 100)
    , subscribed BIT NOT NULL DEFAULT 1

    , PRIMARY KEY (id)
);
GO

CREATE TABLE Products (
      id INT IDENTITY(1,1) NOT NULL
    , type_id INT NOT NULL
    , name NVARCHAR(32) NOT NULL CHECK (name != '')
    , quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0)
    , cost DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK (cost >= 0)
    , manufacturer_id INT NOT NULL
    , price DECIMAL(8,2) NOT NULL DEFAULT 0 CHECK (price >= 0)

    , PRIMARY KEY (id)
    , CONSTRAINT FK_Products_type_id
      FOREIGN KEY (type_id) REFERENCES ProductTypes (id)
    , CONSTRAINT FK_Products_manufacturer_id
      FOREIGN KEY (manufacturer_id) REFERENCES Manufacturers (id)
);
GO


IF OBJECT_ID('dbo.CalculatePrice') IS NOT NULL
    DROP FUNCTION dbo.CalculatePrice
GO

-- вычислить стоимость заказа
CREATE FUNCTION CalculatePrice
    (
          @prod_id INT
        , @prod_count INT
        , @cust_id INT
    )
RETURNS DECIMAL(8,2)
AS
BEGIN
    DECLARE @res DECIMAL(8,2);
    -- финальная цена = [цена товара] * [количество] * [1 - скидка]
    SELECT @res = 
        (P.price * CAST(@prod_count AS DECIMAL)) 
        * (1.0 - (C.discount / 100.0))
    FROM Products AS P
       , Customers AS C
    WHERE P.id = @prod_id
    AND C.id = @cust_id;
    RETURN @res;
END
GO

CREATE TABLE Orders (
      id INT IDENTITY(1,1) NOT NULL
    , prod_id INT NOT NULL
    , prod_count INT NOT NULL DEFAULT 1 CHECK (prod_count > 0) 
    , employee_id INT NOT NULL
    , cust_id INT NOT NULL
    , order_date date NOT NULL CHECK (order_date >= '2020-02-02')
    -- вычисляемое поле
    , price AS dbo.CalculatePrice(prod_id, prod_count, cust_id)

    , PRIMARY KEY (id)
    , CONSTRAINT FK_Orders_prod_id
      FOREIGN KEY (prod_id) REFERENCES Products (id)
    , CONSTRAINT FK_Order_employee_id
      FOREIGN KEY (employee_id) REFERENCES Employees (id)
    , CONSTRAINT FK_Order_cust_id
      FOREIGN KEY (cust_id) REFERENCES Customers (id)
);
GO

