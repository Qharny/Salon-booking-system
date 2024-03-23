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

SELECT * FROM Customers;

DELETE FROM Employees
WHERE EmployeeID = 5;
SELECT * FROM Employees;

ALTER TABLE Services
ALTER COLUMN Name NVARCHAR(150);
SELECT * FROM Services;


-- aggregations

SELECT AVG(Price) AS AverageServicePrice
FROM Services;

SELECT Customers.Name, SUM(Payments.Amount) AS TotalPaid
FROM Customers
LEFT JOIN Appointments ON Customers.CustomerID = Appointments.CustomerID
LEFT JOIN Payments ON Appointments.AppointmentID = Payments.AppointmentID
GROUP BY Customers.Name;


SELECT Employees.Name, COUNT(Appointments.AppointmentID) AS TotalAppointments
FROM Employees
LEFT JOIN Appointments ON Employees.EmployeeID = Appointments.EmployeeID
GROUP BY Employees.Name;


SELECT SUM(Quantity * Price) AS TotalInventoryValue
FROM Inventory;
