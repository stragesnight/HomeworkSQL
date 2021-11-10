USE master;
GO

--DROP DATABASE IF EXISTS Teststep;
--GO

CREATE DATABASE Teststep;
GO

USE Teststep;
GO

DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS OrderItems;
GO


CREATE TABLE Vendors(
    vend_id char(10) NOT NULL,
    vend_name char(50) NOT NULL,
    vend_address char(50) NOT NULL,
    vend_city char(50) NOT NULL,
    vend_state char(5) NOT NULL,
    vend_zip char(50) NOT NULL,
    vend_country char(50) NOT NULL
);
GO

CREATE TABLE Products(
    prod_id char(10) NOT NULL,
    vend_id char(10) NOT NULL,
    prod_name char(255) NOT NULL,
    prod_price decimal(8,2) NOT NULL,
    prod_desc varchar(1000) NULL
);
CREATE TABLE Customers(
    cust_id char(10) NOT NULL,
    cust_name char(50) NOT NULL,
    cust_address char(50) NULL,
    cust_city char(50) NULL,
    cust_state char(5) NULL,
    cust_zip char(10) NULL,
    cust_country char(50) NULL,
    cust_contact char(50) NULL,
    cust_email char(255) NULL,
);
CREATE TABLE Orders(
    order_num int NOT NULL,
    order_date datetime NOT NULL,
    cust_id char(10) NOT NULL,
);
CREATE TABLE OrderItems(
    order_num int NOT NULL,
    order_item int NOT NULL,
    prod_id char(10) NOT NULL,
    quantity int NOT NULL,
    item_price decimal(8,2) NOT NULL
);
GO


ALTER TABLE Customers WITH NOCHECK ADD 
    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (cust_id);
ALTER TABLE OrderItems WITH NOCHECK ADD 
    CONSTRAINT PK_OrderItems PRIMARY KEY CLUSTERED (order_num, order_item);
ALTER TABLE Orders WITH NOCHECK ADD 
    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (order_num);
ALTER TABLE Products WITH NOCHECK ADD 
    CONSTRAINT PK_Products PRIMARY KEY CLUSTERED (prod_id);
ALTER TABLE Vendors WITH NOCHECK ADD 
    CONSTRAINT PK_Vendors PRIMARY KEY CLUSTERED (vend_id);
GO


ALTER TABLE OrderItems ADD
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (order_num) REFERENCES Orders (order_num),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (prod_id) REFERENCES Products (prod_id);
ALTER TABLE Orders ADD 
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);
ALTER TABLE Products ADD
    CONSTRAINT FK_Products_Vendors FOREIGN KEY (vend_id) REFERENCES Vendors (vend_id);
GO


