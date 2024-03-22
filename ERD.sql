Table Customers {
    CustomerID INT [primary key]
    Name NVARCHAR(100)
    Phone NVARCHAR(20)
    Email NVARCHAR(100)
}

Table Employees {
    EmployeeID INT [primary key]
    Name NVARCHAR(100)
    Position NVARCHAR(100)
}

Table Services {
    ServiceID INT [primary key]
    Name NVARCHAR(100)
    Price DECIMAL(10, 2)
}

Table Appointments {
    AppointmentID INT [primary key]
    CustomerID INT
    EmployeeID INT
    ServiceID INT 
    AppointmentDateTime DATETIME
    Status NVARCHAR(50)
}

Table Payments {
    PaymentID INT [primary key]
    AppointmentID INT 
    Amount DECIMAL(10, 2)
    PaymentDateTime DATETIME
}

Table Inventory {
    ProductID INT [primary key]
    Name NVARCHAR(100)
    Quantity INT
    Price DECIMAL(10, 2)
}

Ref: Appointments.CustomerID > Customers.CustomerID
Ref: Appointments.EmployeeID > Employees.EmployeeID
Ref: Appointments.ServiceID > Services.ServiceID
Ref: Payments.AppointmentID > Appointments.AppointmentID
