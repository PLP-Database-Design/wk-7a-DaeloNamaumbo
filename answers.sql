-- solution 1


-- First, create the original ProductDetail table
CREATE TABLE IF NOT EXISTS ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the sample data
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Create a new table in 1NF
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Transform the data into 1NF by splitting the Products column
-- For MySQL, we can use a combination of string functions

-- Insert data for OrderID 101
INSERT INTO ProductDetail_1NF VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse');

-- Insert data for OrderID 102
INSERT INTO ProductDetail_1NF VALUES
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse');

-- Insert data for OrderID 103
INSERT INTO ProductDetail_1NF VALUES
(103, 'Emily Clark', 'Phone');

-- Select from the new 1NF table to verify
SELECT * FROM ProductDetail_1NF;


-- question 2

-- First, create the original OrderDetails table (already in 1NF)
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)
);

-- Insert the sample data
INSERT INTO OrderDetails VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create 2NF tables
-- Table 1: Orders (to store order-specific information)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table 2: OrderItems (to store product-specific information for each order)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the Orders table (removing duplicates)
INSERT INTO Orders
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Insert data into the OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Select from the new 2NF tables to verify
SELECT * FROM Orders;
SELECT * FROM OrderItems;

-- Join to show the original data structure
SELECT o.OrderID, o.CustomerName, oi.Product, oi.Quantity
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID;
