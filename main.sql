CREATE DATABASE Salon_Booking_System;

-- use created database
USE Salon_Booking_System;


-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Phone, Email)
VALUES 
(1, 'John Doe', '123-456-7890', 'john@example.com'),
(2, 'Jane Smith', '987-654-3210', 'jane@example.com'),
(3, 'Alice Johnson', '555-123-4567', 'alice@example.com'),
(4, 'Bob Brown', '777-888-9999', 'bob@example.com'),
(5, 'Emily Davis', '111-222-3333', 'emily@example.com');

-- Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Position NVARCHAR(100)
);

INSERT INTO Employees (EmployeeID, Name, Position)
VALUES 
(1, 'Michael Scott', 'Manager'),
(2, 'Dwight Schrute', 'Assistant Manager'),
(3, 'Jim Halpert', 'Stylist'),
(4, 'Pam Beesly', 'Receptionist'),
(5, 'Angela Martin', 'Stylist');

-- Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Price DECIMAL(10, 2)
);

INSERT INTO Services (ServiceID, Name, Price)
VALUES 
(1, 'Haircut', 20.00),
(2, 'Hair Color', 50.00),
(3, 'Manicure', 30.00),
(4, 'Pedicure', 35.00),
(5, 'Massage', 60.00);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    AppointmentDateTime DATETIME,
    Status NVARCHAR(50)
);

INSERT INTO Appointments (CustomerID, EmployeeID, ServiceID, AppointmentDateTime, Status)
VALUES (1, 3, 1, '2024-03-21 10:00:00', 'Pending');


-- Payments table
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    AppointmentID INT FOREIGN KEY REFERENCES Appointments(AppointmentID),
    Amount DECIMAL(10, 2),
    PaymentDateTime DATETIME
);

-- Inventory table
CREATE TABLE Inventory (
    ProductID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Quantity INT,
    Price DECIMAL(10, 2)
);

INSERT INTO Inventory (ProductID, Name, Quantity, Price)
VALUES 
(1, 'Shampoo', 50, 10.00),
(2, 'Conditioner', 40, 8.00),
(3, 'Hair Gel', 30, 12.00),
(4, 'Nail Polish', 100, 5.00),
(5, 'Massage Oil', 20, 15.00);


-- QUERY

SELECT * FROM Inventory;
SELECT * FROM Payments;
SELECT * FROM Appointments;
SELECT * FROM Customers;
SELECT * FROM Employees;
SELECT * FROM Services;



SELECT e.Name AS EmployeeName
FROM Employees e
LEFT JOIN Appointments a ON e.EmployeeID = a.EmployeeID
WHERE a.AppointmentDateTime NOT BETWEEN '2024-03-21 09:00:00' AND '2024-03-21 10:00:00'
AND a.ServiceID = 1; -- Replace 1 with the desired service ID


SELECT a.AppointmentID, SUM(p.Amount) AS TotalPayment
FROM Appointments a
LEFT JOIN Payments p ON a.AppointmentID = p.AppointmentID
GROUP BY a.AppointmentID;

SELECT c.Name AS CustomerName, a.AppointmentDateTime, s.Name AS ServiceName
FROM Customers c
INNER JOIN Appointments a ON c.CustomerID = a.CustomerID
INNER JOIN Services s ON a.ServiceID = s.ServiceID;

UPDATE Customers
SET Name = 'John Doe Jr.'
WHERE CustomerID = 1;

DELETE FROM Employees
WHERE EmployeeID = 5;

ALTER TABLE Services
ALTER COLUMN Name NVARCHAR(150);




-- Creating functions

CREATE FUNCTION CalculateTotalAppointmentCost (@AppointmentID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalCost DECIMAL(10, 2);
    SELECT @TotalCost = SUM(s.Price)
    FROM Appointments a
    INNER JOIN Services s ON a.ServiceID = s.ServiceID
    WHERE a.AppointmentID = @AppointmentID;
    RETURN @TotalCost;
END;



-- triggers
CREATE TRIGGER UpdateInventoryOnAppointment
ON Appointments
AFTER INSERT
AS
BEGIN
    UPDATE Inventory
    SET Quantity = Quantity - 1
    WHERE ProductID IN (
        SELECT ProductID FROM Services
        WHERE ServiceID IN (
            SELECT ServiceID FROM inserted
        )
    );
END;


-- stored procedure
CREATE PROCEDURE SendEmailNotification
AS
BEGIN
  DECLARE @Body NVARCHAR(MAX);
  SET @Body = 'Dear Customer, your appointment is scheduled for tomorrow.';
  
  EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'YourMailProfile',
    @recipients = 'customer@example.com',
    @body = @Body,
    @subject = 'Appointment Reminder';
END;

CREATE PROCEDURE BookAppointment
    @CustomerID INT,
    @EmployeeID INT,
    @ServiceID INT,
    @AppointmentDateTime DATETIME
AS
BEGIN
    INSERT INTO Appointments (CustomerID, EmployeeID, ServiceID, AppointmentDateTime, Status)
    VALUES (@CustomerID, @EmployeeID, @ServiceID, @AppointmentDateTime, 'Pending');
END;



-- TRANSACTIONS
BEGIN TRANSACTION;

DECLARE @AppointmentID INT;

-- Book the appointment
INSERT INTO Appointments (CustomerID, EmployeeID, ServiceID, AppointmentDateTime, Status)
VALUES (1, 3, 1, '2024-03-21 10:00:00', 'Pending');

-- Get the AppointmentID of the newly inserted appointment
SET @AppointmentID = SCOPE_IDENTITY();

-- Update inventory based on the service booked
UPDATE Inventory
SET Quantity = Quantity - 1
WHERE ProductID IN (
    SELECT ProductID FROM Services
    WHERE ServiceID = 1
);

-- Check if any error occurred
IF @@ERROR <> 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'An error occurred. Rolling back transaction.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Appointment booked successfully.';
END;