
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


-- Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Position NVARCHAR(100)
);

);
-- Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Price DECIMAL(10, 2)
);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    AppointmentDateTime DATETIME,
    Status NVARCHAR(50)
);


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