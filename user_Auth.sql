
CREATE TABLE Users (
  UserID INT PRIMARY KEY IDENTITY,
  Username NVARCHAR(50) UNIQUE,
  PasswordHash NVARCHAR(255) NOT NULL,
  RoleID INT FOREIGN KEY REFERENCES Roles(RoleID)
);


CREATE TABLE Roles (
  RoleID INT PRIMARY KEY IDENTITY,
  RoleName NVARCHAR(50)
);

INSERT INTO Roles (RoleName)
VALUES ('Admin'), ('Stylist'), ('Receptionist');

DECLARE @password NVARCHAR(50) = 'password123';
DECLARE @hashedPassword NVARCHAR(255);

-- Simulate password hashing using BCrypt (replace with actual hashing function)
SET @hashedPassword = 'HASHED_PASSWORD_VALUE';

INSERT INTO Users (Username, PasswordHash, RoleID)
VALUES ('admin', @hashedPassword, 1);

-- Add more users with different roles

-- stored procedure for reporting capabilities
CREATE PROCEDURE GetAppointmentsByStylist (@StartDate DATETIME, @EndDate DATETIME, @StylistID INT)
AS
BEGIN
  SELECT 
    a.AppointmentDateTime,
    c.Name AS CustomerName,
    s.Name AS StylistName,
    ser.Name AS ServiceName
  FROM Appointments a
  INNER JOIN Customers c ON a.CustomerID = c.CustomerID
  INNER JOIN Employees s ON a.EmployeeID = s.EmployeeID
  INNER JOIN Services ser ON a.ServiceID = ser.ServiceID
  WHERE a.AppointmentDateTime >= @StartDate AND a.AppointmentDateTime <= @EndDate
  AND a.EmployeeID = @StylistID;
END;