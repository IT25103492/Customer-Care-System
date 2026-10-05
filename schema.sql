-- Customer Care System Database Schema for Microsoft SQL Server
-- Database Name: CustomerCareDB

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CustomerCareDB')
BEGIN
    CREATE DATABASE CustomerCareDB;
END
GO

USE CustomerCareDB;
GO

-- 1. Users Table
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Customer', 'Customer Support Officer', 'Team Supervisor', 'Technical Staff', 'Customer Care Manager', 'System Administrator')),
    ContactNo NVARCHAR(20) NULL,
    Status NVARCHAR(20) DEFAULT 'Active' CHECK (Status IN ('Active', 'Deactivated')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. Tickets Table
IF OBJECT_ID('dbo.Tickets', 'U') IS NOT NULL DROP TABLE dbo.Tickets;
CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    TicketNumber NVARCHAR(30) NOT NULL UNIQUE,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    AssignedTo INT NULL FOREIGN KEY REFERENCES Users(UserID),
    Subject NVARCHAR(200) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'Medium' CHECK (Priority IN ('Low', 'Medium', 'High', 'Urgent')),
    Description NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Open' CHECK (Status IN ('Open', 'In Progress', 'Escalated', 'Resolved', 'Closed')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- 3. Enquiries Table
IF OBJECT_ID('dbo.Enquiries', 'U') IS NOT NULL DROP TABLE dbo.Enquiries;
CREATE TABLE Enquiries (
    EnquiryID INT IDENTITY(1,1) PRIMARY KEY,
    EnquiryNumber NVARCHAR(30) NOT NULL UNIQUE,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    Subject NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Response NVARCHAR(MAX) NULL,
    RespondedBy INT NULL FOREIGN KEY REFERENCES Users(UserID),
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Answered', 'Resolved')),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 4. Messages Table (Communication History)
IF OBJECT_ID('dbo.Messages', 'U') IS NOT NULL DROP TABLE dbo.Messages;
CREATE TABLE Messages (
    MessageID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NULL FOREIGN KEY REFERENCES Tickets(TicketID),
    EnquiryID INT NULL FOREIGN KEY REFERENCES Enquiries(EnquiryID),
    SenderID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    ReceiverID INT NULL FOREIGN KEY REFERENCES Users(UserID),
    MessageText NVARCHAR(MAX) NOT NULL,
    IsRead BIT DEFAULT 0,
    IsEdited BIT DEFAULT 0,
    SentAt DATETIME DEFAULT GETDATE()
);

-- 5. Escalations Table
IF OBJECT_ID('dbo.Escalations', 'U') IS NOT NULL DROP TABLE dbo.Escalations;
CREATE TABLE Escalations (
    EscalationID INT IDENTITY(1,1) PRIMARY KEY,
    TicketID INT NOT NULL FOREIGN KEY REFERENCES Tickets(TicketID) ON DELETE CASCADE,
    EscalatedBy INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    EscalatedTo INT NULL FOREIGN KEY REFERENCES Users(UserID),
    Reason NVARCHAR(MAX) NOT NULL,
    Priority NVARCHAR(20) DEFAULT 'High',
    Status NVARCHAR(20) DEFAULT 'Escalated' CHECK (Status IN ('Escalated', 'Under Review', 'Resolved', 'Dismissed')),
    EscalatedAt DATETIME DEFAULT GETDATE()
);

-- 6. Feedbacks Table
IF OBJECT_ID('dbo.Feedbacks', 'U') IS NOT NULL DROP TABLE dbo.Feedbacks;
CREATE TABLE Feedbacks (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    TicketID INT NULL FOREIGN KEY REFERENCES Tickets(TicketID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments NVARCHAR(MAX) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- 7. Notifications Table
IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL DROP TABLE dbo.Notifications;
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    Title NVARCHAR(150) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Seed Default Accounts for Testing & Demo
INSERT INTO Users (FullName, Email, Password, Role, ContactNo, Status) VALUES
('System Administrator', 'admin@customercare.com', 'admin123', 'System Administrator', '0771234560', 'Active'),
('Customer Care Manager', 'manager@customercare.com', 'manager123', 'Customer Care Manager', '0771234561', 'Active'),
('Team Supervisor', 'supervisor@customercare.com', 'super123', 'Team Supervisor', '0771234562', 'Active'),
('Support Officer', 'officer@customercare.com', 'staff123', 'Customer Support Officer', '0771234563', 'Active'),
('Technical Staff', 'tech@customercare.com', 'tech123', 'Technical Staff', '0771234564', 'Active'),
('John Customer', 'customer@gmail.com', 'cust123', 'Customer', '0771234565', 'Active');
GO
