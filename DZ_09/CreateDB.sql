-- Домашнее Задание №9
--  Ученик: Шелест Александр

SET ANSI_NULLS, QUOTED_IDENTIFIER ON;
GO

IF DB_ID('SportShop') IS NULL
    CREATE DATABASE SportShop;
GO

USE SportShop;
GO

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

DROP TABLE IF EXISTS ProductTypes;
DROP TABLE IF EXISTS Manufacturers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
GO


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
    , cost decimal(8,2) NOT NULL DEFAULT 0 CHECK (cost >= 0)
    , manufacturer_id INT NOT NULL
    , price decimal(8,2) NOT NULL DEFAULT 0 CHECK (price >= 0)

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


INSERT INTO ProductTypes (name) VALUES
      ('Sport clothes')
    , ('Bikes')
    , ('Game-specific equipment')
    , ('Bike & motorcycle equipment')
    , ('Gymnastic equipment')
    , ('Hiking & traveling equipment')
    , ('Protein shakes');
GO

INSERT INTO Manufacturers (name) VALUES
      ('A&B')
    , ('SportLife Group')
    , ('USG')
    , ('Balls')
    , ('HikingLife')
    , ('BikeLine')
    , ('International sport culture group')
    , ('J&J');
GO

INSERT INTO Employees 
(name, surname, fathers, position, application_date, sex, salary) VALUES
      ('Adam',     'Abrams',  NULL,         'Cashier',      '2021-01-01', 'M', 1400)
    , ('Sophia',   'Gnostic', NULL,         'Director',     '2020-02-03', 'F', 2200)
    , ('Alex',     'Shchuk',  'Igorovich',  'Lead Manager', '2020-05-05', 'M', 2000)
    , ('Boris',    'Belenko', NULL,         'Cashier',      '2020-02-04', 'M', 1800)
    , ('Vladimir', 'Glek',    'Artemovich', 'Assistant',    '2020-03-03', 'M', 1500)
    , ('Zhora',    'Bebrik',  'Romanovich', 'Assistant',    '2020-03-04', 'M', 1500);
GO

INSERT INTO Customers 
(name, surname, fathers, email, contact_phone, sex, discount, subscribed) VALUES
      ('USER',    'UNREGISTERED', NULL,           NULL,                 NULL,            'M', 0,  0)
    , ('Test',    'Test',         'Test',         'Test',               'Test',          'M', 10, 1)
    , ('Anton',   'Shostakov',    NULL,           'shostakov@mail.com', NULL,            'M', 2,  1)
    , ('Rita',    'Romanova',     NULL,           'scruber@mail.com',   NULL,            'F', 0,  0)
    , ('Ibragim', 'Izenberg',     'Ibragimovich', 'shekel@mail.com',    NULL,            'M', 5,  1)
    , ('Ira',     'Shpek',        'Evanovna',     NULL,                 '+380987654321', 'F', 3,  1)
    , ('Bob',     'Johnson',      NULL,           'johnson@mail.com',   NULL,            'M', 4,  1)
    , ('John',    'Bobson',       NULL,           NULL,                 '+119087612345', 'M', 1,  0);
GO

INSERT INTO Products (type_id, name, quantity, cost, manufacturer_id, price) VALUES
      (1, 'Sneakers',           5,  30,     1,  40)
    , (1, 'Jacket',             6,  20,     2,  35)
    , (1, 'Pants',              7,  15,     3,  30)
    , (2, 'Sport bike',         3,  350,    6,  450)
    , (2, 'City bike',          3,  340,    6,  430)
    , (2, 'Mountain bike',      3,  370,    6,  500)
    , (3, 'Football ball',      15, 15,     4,  20)
    , (3, 'Soccer ball',        15, 13,     4,  18)
    , (3, 'Tennis rocket',      10, 15,     3,  15)
    , (4, 'Helmet',             10, 20,     6,  25)
    , (4, 'Motorcycle Helmet',  8,  30,     6,  50)
    , (4, 'Gloves',             8,  10,     7,  15)
    , (5, 'Gymnastic rug',      16, 18,     8,  24)
    , (5, 'Gymnastic Ball',     8,  16,     4,  20)
    , (5, 'Expander',           10, 14,     7,  15)
    , (6, 'Hiking suite',       7,  53,     5,  65)
    , (6, 'Hiking sticks',      8,  14,     5,  22)
    , (6, 'Hiking shoes',       7,  34,     5,  42)
    , (7, 'Proteing shake #1',  16, 6,      2,  8)
    , (7, 'Protein shake #2',   16, 5,      2,  7)
    , (7, 'Protein shake #3',   16, 5,      2,  9);
GO

INSERT INTO Orders (prod_id, prod_count, employee_id, cust_id, order_date) VALUES
      (1,  4, 1, 1, '2021-10-10')
    , (2,  4, 1, 1, '2021-10-10')
    , (20, 1, 4, 2, '2021-10-11')
    , (15, 3, 4, 3, '2021-10-11')
    , (10, 1, 4, 4, '2021-10-12')
    , (11, 6, 1, 4, '2021-10-12')
    , (3,  2, 1, 5, '2021-10-13')
    , (4,  3, 1, 6, '2021-10-14')
    , (5,  5, 4, 1, '2021-10-14')
    , (6,  1, 4, 1, '2021-10-14')
    , (7,  4, 4, 1, '2021-10-14')
    , (15, 2, 4, 7, '2021-10-15')
    , (17, 3, 4, 8, '2021-10-15')
    , (11, 1, 1, 3, '2021-10-15');
GO

PRINT 'ProductTypes:';
SELECT * FROM ProductTypes;
GO

PRINT 'Manufacturers:';
SELECT * FROM Manufacturers;
GO

PRINT 'Employees:';
SELECT * FROM Employees;
GO

PRINT 'Customers:';
SELECT * FROM Customers;
GO

PRINT 'Products:';
SELECT * FROM Products;
GO

PRINT 'Orders:';
SELECT * FROM Orders;
GO

