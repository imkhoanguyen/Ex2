-- Clear existing data (optional)
DELETE FROM Shipments;
DELETE FROM OrderItems;
DELETE FROM Orders;
DELETE FROM Products;
DELETE FROM Customers;

-- Reset identity counters (if using auto-increment)
DBCC CHECKIDENT ('Customers', RESEED, 0);
DBCC CHECKIDENT ('Products', RESEED, 0);
DBCC CHECKIDENT ('Orders', RESEED, 0);
DBCC CHECKIDENT ('OrderItems', RESEED, 0);
DBCC CHECKIDENT ('Shipments', RESEED, 0);

-- Insert Customers (20 records)
INSERT INTO Customers (Name, Email, Phone, Address)
VALUES 
('John Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown'),
('Sarah Johnson', 'sarah.j@email.com', '555-0102', '456 Oak Ave, Somewhere'),
('Michael Brown', 'michael.b@email.com', '555-0103', '789 Pine Rd, Nowhere'),
('Emily Davis', 'emily.d@email.com', '555-0104', '321 Elm St, Anywhere'),
('Robert Wilson', 'robert.w@email.com', '555-0105', '654 Maple Dr, Everywhere'),
('Jennifer Lee', 'jennifer.l@email.com', '555-0106', '987 Cedar Ln, Someplace'),
('David Miller', 'david.m@email.com', '555-0107', '135 Birch Blvd, Noplace'),
('Jessica Taylor', 'jessica.t@email.com', '555-0108', '246 Walnut Way, Yourtown'),
('Thomas Anderson', 'thomas.a@email.com', '555-0109', '369 Spruce Ct, Mytown'),
('Lisa Martinez', 'lisa.m@email.com', '555-0110', '482 Cherry St, Hometown'),
('James White', 'james.w@email.com', '555-0111', '591 Aspen Ave, Theirtown'),
('Patricia Harris', 'patricia.h@email.com', '555-0112', '724 Willow Way, Ourville'),
('Christopher Clark', 'chris.c@email.com', '555-0113', '853 Redwood Rd, Yourville'),
('Amanda Lewis', 'amanda.l@email.com', '555-0114', '962 Sycamore Ln, Theirville'),
('Daniel Robinson', 'daniel.r@email.com', '555-0115', '174 Magnolia Dr, Thisplace'),
('Nancy Walker', 'nancy.w@email.com', '555-0116', '285 Dogwood Ave, Thatplace'),
('Matthew Young', 'matthew.y@email.com', '555-0117', '396 Juniper Blvd, Whatplace'),
('Karen Hall', 'karen.h@email.com', '555-0118', '417 Holly Ct, Whichplace'),
('Kevin Allen', 'kevin.a@email.com', '555-0119', '528 Ivy St, Whoplace'),
('Laura King', 'laura.k@email.com', '555-0120', '639 Laurel Way, Whyplace');

-- Insert Products (15 records)
INSERT INTO Products (ProductName, Category, Price, Stock)
VALUES
('Laptop Pro', 'Electronics', 999.99, 50),
('Smartphone X', 'Electronics', 699.99, 100),
('Wireless Headphones', 'Electronics', 149.99, 200),
('Desk Chair', 'Furniture', 199.99, 30),
('Coffee Table', 'Furniture', 149.99, 25),
('LED Desk Lamp', 'Home', 29.99, 150),
('Blender', 'Kitchen', 49.99, 75),
('Running Shoes', 'Sports', 89.99, 120),
('Yoga Mat', 'Sports', 24.99, 90),
('Backpack', 'Accessories', 39.99, 80),
('Water Bottle', 'Accessories', 19.99, 200),
('Novel - The Great Adventure', 'Books', 14.99, 60),
('Cookbook', 'Books', 24.99, 40),
('Smart Watch', 'Electronics', 199.99, 70),
('Bluetooth Speaker', 'Electronics', 79.99, 100);

-- Insert Orders (30 records with random dates in the last 3 months)
DECLARE @i INT = 1;
WHILE @i <= 30
BEGIN
    INSERT INTO Orders (CustomerID, OrderDate, Status)
    VALUES (
        FLOOR(RAND() * 20) + 1, -- Random customer between 1-20
        DATEADD(DAY, -FLOOR(RAND() * 90), GETDATE()), -- Random date in last 90 days
        CASE WHEN RAND() > 0.7 THEN 'Cancelled' 
             WHEN RAND() > 0.5 THEN 'Shipped' 
             WHEN RAND() > 0.3 THEN 'Processing' 
             ELSE 'Completed' END -- Random status
    );
    SET @i = @i + 1;
END

-- Insert OrderItems (2-5 items per order)
DECLARE @order INT = 1;
WHILE @order <= 30
BEGIN
    DECLARE @items INT = FLOOR(RAND() * 4) + 2; -- 2-5 items per order
    DECLARE @j INT = 1;
    WHILE @j <= @items
    BEGIN
        INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price)
        VALUES (
            @order,
            FLOOR(RAND() * 15) + 1, -- Random product between 1-15
            FLOOR(RAND() * 5) + 1, -- 1-5 quantity
            (SELECT Price FROM Products WHERE ProductID = FLOOR(RAND() * 15) + 1) -- Actual product price
        );
        SET @j = @j + 1;
    END
    SET @order = @order + 1;
END

-- Insert Shipments (for most orders)
DECLARE @orderToShip INT = 1;
WHILE @orderToShip <= 30
BEGIN
    -- Only ship orders that aren't cancelled
    IF (SELECT Status FROM Orders WHERE OrderID = @orderToShip) != 'Cancelled'
    BEGIN
        INSERT INTO Shipments (OrderID, ShipmentDate, DeliveryStatus)
        VALUES (
            @orderToShip,
            DATEADD(DAY, FLOOR(RAND() * 5), (SELECT OrderDate FROM Orders WHERE OrderID = @orderToShip)), -- 0-5 days after order
            CASE WHEN RAND() > 0.7 THEN 'Delivered' 
                 WHEN RAND() > 0.4 THEN 'In Transit' 
                 ELSE 'Processing' END -- Random status
        );
    END
    SET @orderToShip = @orderToShip + 1;
END

-- Verify data
SELECT COUNT(*) AS CustomerCount FROM Customers;
SELECT COUNT(*) AS ProductCount FROM Products;
SELECT COUNT(*) AS OrderCount FROM Orders;
SELECT COUNT(*) AS OrderItemCount FROM OrderItems;
SELECT COUNT(*) AS ShipmentCount FROM Shipments;