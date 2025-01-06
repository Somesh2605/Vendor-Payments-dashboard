CREATE DATABASE VendorPayments;
USE VendorPayments;

-- Create the Vendors table with auto-increment for VendorID
CREATE TABLE Vendors (
    VendorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    ContactDetails VARCHAR(100)
);

-- Create the Payments table with auto-increment for PaymentID
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT,
    PaymentDate DATE,
    PaymentAmount DECIMAL(10, 2),
    PaymentStatus VARCHAR(50),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) -- Ensuring VendorID exists in Vendors table
);

-- Create the Invoices table with auto-increment for InvoiceID
CREATE TABLE Invoices (
    InvoiceID INT AUTO_INCREMENT PRIMARY KEY,
    VendorID INT,
    InvoiceDate DATE,
    DueDate DATE,
    AmountDue DECIMAL(10, 2),
    FOREIGN KEY (VendorID) REFERENCES Vendors(VendorID) -- Ensuring VendorID exists in Vendors table
);

-- Insert vendor records without specifying VendorID (it will auto-increment)
INSERT INTO Vendors (Name, ContactDetails)
VALUES
('ABC Supplies', 'abc@supplies.com'),
('XYZ Traders', 'xyz@traders.com'),
('Global Goods', 'global@goods.com'),
('Techno Equipments', 'techno@equip.com'),
('Fashionista Apparel', 'fashion@apparel.com'),
('Home Goods Inc.', 'homegoods@hgi.com'),
('Smart Electronics', 'smart@electronics.com'),
('Elite Furniture', 'elite@furniture.com'),
('Fresh Foods', 'fresh@foods.com'),
('Auto Parts Co.', 'autoparts@co.com'),
('MedCare Supplies', 'medcare@supplies.com'),
('Bright Tools', 'bright@tools.com'),
('PowerTech Industries', 'powertech@ind.com'),
('Optimum Solutions', 'optimum@solutions.com'),
('Quality Printers', 'quality@printers.com'),
('Clever Construction', 'clever@construction.com'),
('NextGen Robotics', 'nextgen@robotics.com'),
('EcoEnergy Solutions', 'ecoenergy@sol.com'),
('Urban Style', 'urban@style.com'),
('Innovative Designs', 'innovative@designs.com');

-- Insert payment records with VendorID explicitly set (make sure the VendorID exists in the Vendors table)
INSERT INTO Payments (VendorID, PaymentDate, PaymentAmount, PaymentStatus)
VALUES
(1, '2025-01-05', 5000, 'Paid'),
(2, '2025-01-10', 2000, 'Paid'),
(3, '2025-01-08', 7000, 'Paid'),
(4, '2025-01-12', 3000, 'Outstanding'),
(5, '2025-01-13', 1500, 'Paid'),
(6, '2025-01-15', 4000, 'Paid'),
(7, '2025-01-17', 2500, 'Outstanding'),
(8, '2025-01-18', 3500, 'Paid'),
(9, '2025-01-20', 1200, 'Paid'),
(10, '2025-01-21', 6000, 'Paid'),
(11, '2025-01-23', 2500, 'Paid'),
(12, '2025-01-25', 500, 'Outstanding'),
(13, '2025-01-27', 8000, 'Paid'),
(14, '2025-01-30', 3000, 'Paid'),
(15, '2025-01-31', 5000, 'Outstanding'),
(16, '2025-02-02', 4500, 'Paid'),
(17, '2025-02-03', 7000, 'Paid'),
(18, '2025-02-05', 1000, 'Outstanding'),
(19, '2025-02-07', 3000, 'Paid'),
(20, '2025-02-09', 5500, 'Outstanding');

-- Insert invoice records with VendorID explicitly set (make sure the VendorID exists in the Vendors table)
INSERT INTO Invoices (VendorID, InvoiceDate, DueDate, AmountDue)
VALUES
(1, '2025-01-01', '2025-01-10', 5000),
(2, '2025-01-05', '2025-01-15', 2000),
(3, '2025-01-07', '2025-01-17', 7000),
(4, '2025-01-10', '2025-01-20', 3000),
(5, '2025-01-12', '2025-01-22', 1500),
(6, '2025-01-14', '2025-01-24', 4000),
(7, '2025-01-17', '2025-01-27', 2500),
(8, '2025-01-18', '2025-01-28', 3500),
(9, '2025-01-19', '2025-01-29', 1200),
(10, '2025-01-20', '2025-01-30', 6000),
(11, '2025-01-22', '2025-02-01', 2500),
(12, '2025-01-24', '2025-02-03', 500),
(13, '2025-01-26', '2025-02-05', 8000),
(14, '2025-01-28', '2025-02-07', 3000),
(15, '2025-01-30', '2025-02-09', 5000),
(16, '2025-02-02', '2025-02-12', 4500),
(17, '2025-02-04', '2025-02-14', 7000),
(18, '2025-02-06', '2025-02-16', 1000),
(19, '2025-02-08', '2025-02-18', 3000),
(20, '2025-02-10', '2025-02-20', 5500);

-- Query 1: Calculate Outstanding Amount for each Vendor
SELECT v.Name AS VendorName, 
       SUM(i.AmountDue - IFNULL(p.PaymentAmount, 0)) AS OutstandingAmount
FROM Vendors v
JOIN Invoices i ON v.VendorID = i.VendorID
LEFT JOIN Payments p ON v.VendorID = p.VendorID
WHERE p.PaymentStatus = 'Outstanding' OR p.PaymentStatus IS NULL
GROUP BY v.Name;

-- Query 2: List Vendors with Invoices and Payments made before the Due Date
SELECT v.Name AS VendorName, 
       i.InvoiceDate, 
       i.DueDate, 
       p.PaymentDate
FROM Vendors v
JOIN Invoices i ON v.VendorID = i.VendorID
JOIN Payments p ON v.VendorID = p.VendorID
WHERE p.PaymentDate <= i.DueDate;

-- Query 3: Calculate Total Invoices, Total Due, Total Paid, and Outstanding Amount for each Vendor
SELECT v.Name AS VendorName, 
       COUNT(i.InvoiceID) AS TotalInvoices, 
       SUM(i.AmountDue) AS TotalDue, 
       SUM(IFNULL(p.PaymentAmount, 0)) AS TotalPaid, 
       SUM(i.AmountDue - IFNULL(p.PaymentAmount, 0)) AS OutstandingAmount
FROM Vendors v
JOIN Invoices i ON v.VendorID = i.VendorID
LEFT JOIN Payments p ON v.VendorID = p.VendorID
GROUP BY v.Name;
