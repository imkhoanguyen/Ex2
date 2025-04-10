CREATE PROCEDURE sp_GetComplexOrderReport
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @CustomerID INT = NULL,
    @MinAmount DECIMAL(18,2) = NULL,
    @MaxAmount DECIMAL(18,2) = NULL,
    @OrderStatus VARCHAR(50) = NULL,
    @ShipmentStatus VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        o.OrderID,
        o.OrderDate,
        c.Name AS CustomerName,
        COALESCE(SUM(oi.Quantity * oi.Price), 0) AS TotalAmount,
        COALESCE(SUM(oi.Quantity), 0) AS TotalQuantity,
        s.ShipmentDate,
        s.DeliveryStatus,
        o.Status AS OrderStatus
    FROM 
        Orders o
    INNER JOIN 
        Customers c ON o.CustomerID = c.ID
    LEFT JOIN 
        OrderItems oi ON o.OrderID = oi.OrderID
    LEFT JOIN 
        Shipments s ON o.OrderID = s.OrderID
    WHERE 
        (@StartDate IS NULL OR o.OrderDate >= @StartDate)
        AND (@EndDate IS NULL OR o.OrderDate <= @EndDate)
        AND (@CustomerID IS NULL OR o.CustomerID = @CustomerID)
        AND (@OrderStatus IS NULL OR o.Status = @OrderStatus)
        AND (@ShipmentStatus IS NULL OR s.DeliveryStatus = @ShipmentStatus)
    GROUP BY 
        o.OrderID,
        o.OrderDate,
        c.Name,
        s.ShipmentDate,
        s.DeliveryStatus,
        o.Status
    HAVING 
        (@MinAmount IS NULL OR COALESCE(SUM(oi.Quantity * oi.Price), 0) >= @MinAmount)
        AND (@MaxAmount IS NULL OR COALESCE(SUM(oi.Quantity * oi.Price), 0) <= @MaxAmount)
    ORDER BY 
        o.OrderDate DESC;
END