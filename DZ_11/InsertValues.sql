-- Домашнее Задание №11
--  Ученик: Шелест Александр

-- порядок выполнения скриптов:
-- CreateDB.sql -> CreateTriggers.sql -> InsertValues.sql -> Examples.sql

USE SportShop;
GO

-- вставить значения в таблицы

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
    , ('Eugen',    'Belenko', NULL,         'Cashier',      '2020-05-04', 'M', 1700)
    , ('Anna',     'Belenko', NULL,         'Cashier',      '2020-06-06', 'F', 1800)
    , ('Boris',    'Cachenko',NULL,         'Cashier',      '2020-07-04', 'M', 1800)
    , ('Vladimir', 'Glek',    'Artemovich', 'Assistant',    '2020-03-03', 'M', 1500)
    , ('Lera',     'Glek',    'Artemovna',  'Assistant',    '2020-03-03', 'F', 1500);
GO

INSERT INTO Customers 
(name, surname, fathers, email, contact_phone, sex, discount, subscribed) VALUES
      ('USER',    'UNREGISTERED', NULL,           
        NULL,                     NULL,        'M', 0,  0)
    , ('Test',    'Test',         'Test',         
        'Test',                   'Test',      'M', 10, 1)
    , ('Anton',   'Shostakov',    NULL,           
        'shostakov@mail.com',     NULL,        'M', 2,  1)
    , ('Rita',    'Romanova',     NULL,           
        'scruber@mail.com',       NULL,        'F', 0,  0)
    , ('Ibragim', 'Izenberg',     'Ibragimovich', 
        'shekel@mail.com',        NULL,        'M', 5,  1)
    , ('Ira',     'Shpek',        'Evanovna',     
        NULL,                 '+380987654321', 'F', 3,  1)
    , ('Bob',     'Johnson',      NULL,           
        'johnson@mail.com',       NULL,        'M', 4,  1)
    , ('John',    'Bobson',       NULL,           
        NULL,                 '+119087612345', 'M', 1,  0);
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
    , (7, 'Protein shake #1',   16, 6,      2,  8)
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

