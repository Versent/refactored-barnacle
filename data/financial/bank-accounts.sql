-- Bank Account Database Export
-- WARNING: Contains sensitive financial data - Training purposes only
-- FLAG{sql_export_with_bank_accounts}

-- Database connection info
-- Host: financial-db.ctf-training.internal
-- Port: 5432
-- Database: banking_system
-- Username: bank_admin
-- Password: BankingSystem!2024
-- Connection: postgresql://bank_admin:BankingSystem!2024@financial-db.ctf-training.internal:5432/banking_system
-- FLAG{database_credentials_in_sql_file}

CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;

-- Customers table with PII
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    ssn VARCHAR(11),
    date_of_birth DATE,
    email VARCHAR(100),
    phone VARCHAR(20),
    street_address VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(3),
    postcode VARCHAR(10),
    country VARCHAR(50),
    mothers_maiden_name VARCHAR(50),
    drivers_license VARCHAR(20),
    passport_number VARCHAR(20),
    tax_file_number VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flag VARCHAR(100)
);

-- Bank accounts with balances
CREATE TABLE bank_accounts (
    account_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    account_number VARCHAR(20) UNIQUE,
    routing_number VARCHAR(10),
    account_type VARCHAR(20),
    account_status VARCHAR(20),
    current_balance DECIMAL(15,2),
    available_balance DECIMAL(15,2),
    overdraft_limit DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    opened_date DATE,
    last_transaction_date DATE,
    online_banking_username VARCHAR(50),
    online_banking_password VARCHAR(100),
    security_pin VARCHAR(10),
    flag VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert customer data
INSERT INTO customers VALUES
('CUST-000001', 'John', 'Michael', 'Smith', '555-12-3456', '1980-05-15', 'john.smith@email.com', '+61-400-123-456', '123 Market Street', 'Sydney', 'NSW', '2000', 'Australia', 'Johnson', 'NSW-12345678', 'PA1234567', 'TFN-123-456-789', NOW(), 'FLAG{customer_pii_with_ssn}'),
('CUST-000002', 'Sarah', 'Jane', 'Williams', '666-77-8888', '1992-08-20', 'sarah.williams@email.com', '+61-400-234-567', '456 Collins Street', 'Melbourne', 'VIC', '3000', 'Australia', 'Anderson', 'VIC-23456789', 'PA2345678', 'TFN-234-567-890', NOW(), 'FLAG{customer_mothers_maiden_name}'),
('CUST-000003', 'Robert', 'David', 'Johnson', '777-88-9999', '1975-12-01', 'robert.johnson@email.com', '+61-400-345-678', '789 Queen Street', 'Brisbane', 'QLD', '4000', 'Australia', 'Taylor', 'QLD-34567890', 'PA3456789', 'TFN-345-678-901', NOW(), 'FLAG{passport_and_tfn_exposed}'),
('CUST-000004', 'Emily', 'Catherine', 'Davis', '888-99-0000', '1988-03-10', 'emily.davis@email.com', '+61-400-456-789', '321 Wellington Street', 'Perth', 'WA', '6000', 'Australia', 'Thompson', 'WA-45678901', 'PA4567890', 'TFN-456-789-012', NOW(), 'FLAG{complete_identity_data}'),
('CUST-000005', 'Michael', 'James', 'Thompson', '999-00-1111', '1965-07-22', 'michael.thompson@email.com', '+61-400-567-890', '654 King William Street', 'Adelaide', 'SA', '5000', 'Australia', 'Roberts', 'SA-56789012', 'PA5678901', 'TFN-567-890-123', NOW(), 'FLAG{senior_customer_full_details}');

-- Insert bank account data with cleartext passwords
INSERT INTO bank_accounts VALUES
('ACCT-00001', 'CUST-000001', '1234567890', '063-000', 'Checking', 'Active', 50000.00, 48500.00, 2000.00, 0.10, '2018-03-15', '2024-10-20', 'jsmith123', 'JohnSmith!2024', '1234', 'FLAG{checking_account_with_password}'),
('ACCT-00002', 'CUST-000001', '1234567891', '063-000', 'Savings', 'Active', 125000.00, 125000.00, 0.00, 2.50, '2018-03-15', '2024-10-15', 'jsmith123', 'JohnSmith!2024', '1234', 'FLAG{high_balance_savings_account}'),
('ACCT-00003', 'CUST-000002', '2345678901', '083-000', 'Checking', 'Active', 35000.00, 34200.00, 1000.00, 0.10, '2020-06-20', '2024-10-19', 'swilliams456', 'SecurePass!456', '4567', 'FLAG{anz_checking_with_credentials}'),
('ACCT-00004', 'CUST-000002', '2345678902', '083-000', 'Savings', 'Active', 85000.00, 85000.00, 0.00, 2.75, '2020-06-20', '2024-10-10', 'swilliams456', 'SecurePass!456', '4567', 'FLAG{joint_account_access}'),
('ACCT-00005', 'CUST-000003', '3456789012', '062-000', 'Business Checking', 'Active', 450000.00, 420000.00, 50000.00, 0.25, '2015-01-10', '2024-10-20', 'rjohnson789', 'BizAccount!789', '7890', 'FLAG{business_account_large_balance}'),
('ACCT-00006', 'CUST-000003', '3456789013', '062-000', 'Investment', 'Active', 1250000.00, 1250000.00, 0.00, 4.50, '2016-08-15', '2024-10-18', 'rjohnson789', 'BizAccount!789', '7890', 'FLAG{investment_account_million_plus}'),
('ACCT-00007', 'CUST-000004', '4567890123', '084-000', 'Checking', 'Active', 28000.00, 27500.00, 1500.00, 0.10, '2019-11-05', '2024-10-20', 'edavis321', 'Emily!Davis321', '3210', 'FLAG{westpac_account_details}'),
('ACCT-00008', 'CUST-000005', '5678901234', '063-000', 'Retirement', 'Active', 750000.00, 750000.00, 0.00, 3.75, '2005-03-20', '2024-10-01', 'mthompson654', 'Retirement!2024', '6543', 'FLAG{retirement_account_high_value}');

-- Wire transfer history
CREATE TABLE wire_transfers (
    transfer_id VARCHAR(20) PRIMARY KEY,
    from_account VARCHAR(20),
    to_account VARCHAR(20),
    beneficiary_name VARCHAR(100),
    beneficiary_bank VARCHAR(100),
    beneficiary_account VARCHAR(30),
    swift_code VARCHAR(11),
    amount DECIMAL(15,2),
    currency VARCHAR(3),
    transfer_date TIMESTAMP,
    purpose VARCHAR(200),
    status VARCHAR(20),
    initiated_by VARCHAR(100),
    flag VARCHAR(100)
);

INSERT INTO wire_transfers VALUES
('WIRE-00001', '3456789012', 'EXTERNAL', 'Tech Supplier Pty Ltd', 'HSBC Australia', 'AU12345678901234567890', 'HKBAAU2S', 125000.00, 'AUD', '2024-10-15 09:30:00', 'Payment for software licenses', 'Completed', 'Robert Johnson', 'FLAG{wire_transfer_with_swift}'),
('WIRE-00002', '3456789013', 'EXTERNAL', 'Overseas Investment Fund', 'Citibank Singapore', 'SG9876543210987654321', 'CITISGSG', 500000.00, 'AUD', '2024-10-10 14:20:00', 'Investment portfolio funding', 'Completed', 'Robert Johnson', 'FLAG{large_international_wire}'),
('WIRE-00003', '1234567890', 'EXTERNAL', 'Property Settlement', 'NAB Bank', 'AU55555555555555555555', 'NATAAU33', 850000.00, 'AUD', '2024-09-20 11:45:00', 'Real estate purchase settlement', 'Completed', 'John Smith', 'FLAG{property_purchase_wire}'),
('WIRE-00004', '