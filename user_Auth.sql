CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE,
    Password NVARCHAR(100) -- You should hash passwords for security
);

INSERT INTO Users (UserID, Username, Password)
VALUES 
(1, 'admin', 'admin_password'),
(2, 'employee1', 'first_employed'),
(3, 'employee2', 'second_employed');

SELECT * FROM Users;

DECLARE @EnteredUsername NVARCHAR(50) = 'admin'; -- Enter the username you want to authenticate
DECLARE @EnteredPassword NVARCHAR(100) = 'admin_password'; -- Enter the password you want to authenticate

DECLARE @HashedPassword NVARCHAR(100);

-- Retrieve the hashed password for the entered username
SELECT @HashedPassword = Password
FROM Users
WHERE Username = @EnteredUsername;

-- Check if the entered password matches the hashed password
IF @HashedPassword IS NOT NULL AND @HashedPassword = HASHBYTES('SHA2_256', @EnteredPassword)
BEGIN
    PRINT 'Login successful'; -- Print message indicating successful login
    -- Proceed with allowing access or executing further actions
END
ELSE
BEGIN
    PRINT 'Invalid username or password'; -- Print message indicating failed login attempt
    -- Deny access or take appropriate action for failed login
END;




CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(50) UNIQUE,
    Password NVARCHAR(100) -- You should hash passwords for security
);

INSERT INTO Users (UserID, Username, Password)
VALUES 
(1, 'admin', HASHBYTES('SHA2_256', 'admin_password')), -- Hash the password before inserting
(2, 'employee1', HASHBYTES('SHA2_256', 'first_employed')),
(3, 'employee2', HASHBYTES('SHA2_256', 'second_employed'));

SELECT * FROM Users;

DECLARE @EnteredUsername NVARCHAR(50) = 'admin'; -- Enter the username you want to authenticate
DECLARE @EnteredPassword NVARCHAR(100) = 'admin_password'; -- Enter the password you want to authenticate

DECLARE @HashedPassword NVARCHAR(100);

-- Hash the entered password before comparing
SET @EnteredPassword = CONVERT(NVARCHAR(100), HASHBYTES('SHA2_256', @EnteredPassword), 2);

-- Retrieve the hashed password for the entered username
SELECT @HashedPassword = Password
FROM Users
WHERE Username = @EnteredUsername;

-- Check if the entered password matches the hashed password
IF @HashedPassword IS NOT NULL AND @HashedPassword = @EnteredPassword
BEGIN
    PRINT 'Login successful'; -- Print message indicating successful login
    -- Proceed with allowing access or executing further actions
END
ELSE
BEGIN
    PRINT 'Invalid username or password'; -- Print message indicating failed login attempt
    -- Deny access or take appropriate action for failed login
END;
