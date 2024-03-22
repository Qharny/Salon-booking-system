CREATE TABLE [Customers] (
  [CustomerID] INT PRIMARY KEY,
  [Name] NVARCHAR(100),
  [Phone] NVARCHAR(20),
  [Email] NVARCHAR(100)
)
GO

CREATE TABLE [Employees] (
  [EmployeeID] INT PRIMARY KEY,
  [Name] NVARCHAR(100),
  [Position] NVARCHAR(100)
)
GO

CREATE TABLE [Services] (
  [ServiceID] INT PRIMARY KEY,
  [Name] NVARCHAR(100),
  [Price] DECIMAL(10,2)
)
GO

CREATE TABLE [Appointments] (
  [AppointmentID] INT PRIMARY KEY,
  [CustomerID] INT,
  [EmployeeID] INT,
  [ServiceID] INT,
  [AppointmentDateTime] DATETIME,
  [Status] NVARCHAR(50)
)
GO

CREATE TABLE [Payments] (
  [PaymentID] INT PRIMARY KEY,
  [AppointmentID] INT,
  [Amount] DECIMAL(10,2),
  [PaymentDateTime] DATETIME
)
GO

CREATE TABLE [Inventory] (
  [ProductID] INT PRIMARY KEY,
  [Name] NVARCHAR(100),
  [Quantity] INT,
  [Price] DECIMAL(10,2)
)
GO

ALTER TABLE [Appointments] ADD FOREIGN KEY ([CustomerID]) REFERENCES [Customers] ([CustomerID])
GO

ALTER TABLE [Appointments] ADD FOREIGN KEY ([EmployeeID]) REFERENCES [Employees] ([EmployeeID])
GO

ALTER TABLE [Appointments] ADD FOREIGN KEY ([ServiceID]) REFERENCES [Services] ([ServiceID])
GO

ALTER TABLE [Payments] ADD FOREIGN KEY ([AppointmentID]) REFERENCES [Appointments] ([AppointmentID])
GO
