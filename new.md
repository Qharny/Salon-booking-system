# Salon Booking System Database

## Customers Table
| Column       | Data Type     | Description              |
|--------------|---------------|--------------------------|
| CustomerID   | INT           | Primary key              |
| Name         | NVARCHAR(100) | Customer's name          |
| Phone        | NVARCHAR(20)  | Customer's phone number  |
| Email        | NVARCHAR(100) | Customer's email address |

### Sample Data
| CustomerID | Name           | Phone         | Email                |
|------------|----------------|---------------|----------------------|
| 1          | John Doe       | 123-456-7890  | john@example.com     |
| 2          | Jane Smith     | 987-654-3210  | jane@example.com     |
| 3          | Alice Johnson  | 555-123-4567  | alice@example.com    |
| 4          | Bob Brown      | 777-888-9999  | bob@example.com      |
| 5          | Emily Davis    | 111-222-3333  | emily@example.com    |

## Employees Table
| Column       | Data Type     | Description              |
|--------------|---------------|--------------------------|
| EmployeeID   | INT           | Primary key              |
| Name         | NVARCHAR(100) | Employee's name          |
| Position     | NVARCHAR(100) | Employee's position      |

### Sample Data
| EmployeeID | Name           | Position           |
|------------|----------------|--------------------|
| 1          | Michael Scott  | Manager            |
| 2          | Dwight Schrute | Assistant Manager  |
| 3          | Jim Halpert    | Stylist            |
| 4          | Pam Beesly     | Receptionist       |
| 5          | Angela Martin  | Stylist            |

## Services Table
| Column       | Data Type     | Description              |
|--------------|---------------|--------------------------|
| ServiceID    | INT           | Primary key              |
| Name         | NVARCHAR(100) | Service name             |
| Price        | DECIMAL(10,2) | Service price            |

### Sample Data
| ServiceID | Name          | Price  |
|-----------|---------------|--------|
| 1         | Haircut       | 20.00  |
| 2         | Hair Color    | 50.00  |
| 3         | Manicure      | 30.00  |
| 4         | Pedicure      | 35.00  |
| 5         | Massage       | 60.00  |

## Appointments Table
| Column             | Data Type     | Description                          |
|--------------------|---------------|--------------------------------------|
| AppointmentID      | INT           | Primary key, Auto-increment           |
| CustomerID         | INT           | Foreign key referencing Customers    |
| EmployeeID         | INT           | Foreign key referencing Employees    |
| ServiceID          | INT           | Foreign key referencing Services     |
| AppointmentDateTime| DATETIME      | Date and time of appointment         |
| Status             | NVARCHAR(50) | Appointment status (e.g., Pending)   |

### Sample Data
| AppointmentID | CustomerID | EmployeeID | ServiceID | AppointmentDateTime      | Status   |
|---------------|------------|------------|-----------|--------------------------|----------|
| 1             | 1          | 3          | 1         | 2024-03-21 10:00:00      | Pending  |

## Payments Table
| Column             | Data Type     | Description                          |
|--------------------|---------------|--------------------------------------|
| PaymentID          | INT           | Primary key                          |
| AppointmentID      | INT           | Foreign key referencing Appointments|
| Amount             | DECIMAL(10,2) | Payment amount                       |
| PaymentDateTime    | DATETIME      | Date and time of payment             |

### Sample Data
| PaymentID | AppointmentID | Amount  | PaymentDateTime      |
|-----------|---------------|---------|----------------------|
| 1         | 1             | 0.00    | 2024-03-21 10:05:00  |

## Inventory Table
| Column       | Data Type     | Description                          |
|--------------|---------------|--------------------------------------|
| ProductID    | INT           | Primary key                          |
| Name         | NVARCHAR(100) | Product name                         |
| Quantity     | INT           | Quantity available in inventory       |
| Price        | DECIMAL(10,2) | Price per unit                       |

### Sample Data
| ProductID | Name           | Quantity | Price  |
|-----------|----------------|----------|--------|
| 1         | Shampoo        | 50       | 10.00  |
| 2         | Conditioner    | 40       | 8.00   |
| 3         | Hair Gel       | 30       | 12.00  |
| 4         | Nail Polish    | 100      | 5.00   |
| 5         | Massage Oil    | 20       | 15.00  |


Sure, let's continue with the markdown document:

```markdown
## Stored Procedures, Triggers, and Functions

### BookAppointment Stored Procedure
The `BookAppointment` stored procedure is used to book an appointment in the salon booking system. It takes input parameters such as CustomerID, EmployeeID, ServiceID, and AppointmentDateTime, and inserts a new record into the 'Appointments' table with the provided details.

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
```

### UpdateInventoryOnAppointment Trigger
The `UpdateInventoryOnAppointment` trigger is fired after an appointment is inserted into the 'Appointments' table. It updates the inventory based on the service booked by decrementing the quantity of the corresponding product.

```sql
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
```

### CalculateTotalAppointmentCost Function
The `CalculateTotalAppointmentCost` function calculates the total cost of an appointment based on the appointment ID by summing up the prices of the services associated with the appointment.

```sql
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
```

## Transactions
Transactions are used to ensure atomicity, consistency, isolation, and durability (ACID properties) in database operations. The following example demonstrates the use of transactions when booking an appointment and updating inventory:

```sql
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
    WHERE ServiceID = 1 -- Assuming ServiceID for "Haircut"
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
```

This transaction ensures that the booking of an appointment and the corresponding update of inventory occur as a single atomic operation, providing data consistency.
```

This completes the markdown document providing an overview of your entire database schema, including tables, stored procedures, triggers, functions, and transactions. Adjust the content as needed for your specific database structure and requirements.