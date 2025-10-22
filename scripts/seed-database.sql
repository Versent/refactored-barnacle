-- CTF Training Database Seed Script
-- WARNING: Contains sensitive test data for training purposes

-- Create databases
CREATE DATABASE IF NOT EXISTS ctf_training_dev;
CREATE DATABASE IF NOT EXISTS ctf_training_staging;
CREATE DATABASE IF NOT EXISTS ctf_training_prod;

USE ctf_training_prod;

-- Create users with cleartext passwords (intentional vulnerability)
CREATE USER 'dev_admin'@'%' IDENTIFIED BY 'DevP@ssw0rd123!';
CREATE USER 'staging_user'@'%' IDENTIFIED BY 'StagingPass2024!';
CREATE USER 'prod_admin'@'%' IDENTIFIED BY 'ProdAdm1n!SecretP@ss';
CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'ReadOnly2024!';
CREATE USER 'backup_admin'@'%' IDENTIFIED BY 'BackupMasterKey2024!@#';

-- Grant privileges
GRANT ALL PRIVILEGES ON ctf_training_dev.* TO 'dev_admin'@'%';
GRANT ALL PRIVILEGES ON ctf_training_staging.* TO 'staging_user'@'%';
GRANT ALL PRIVILEGES ON ctf_training_prod.* TO 'prod_admin'@'%';
GRANT SELECT ON ctf_training_prod.* TO 'readonly_user'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'backup_admin'@'%' WITH GRANT OPTION;

-- Create tables with sensitive data

-- Financial data table
CREATE TABLE financial_transactions (
    transaction_id VARCHAR(50) PRIMARY KEY,
    account_number VARCHAR(20),
    credit_card VARCHAR(19),
    amount DECIMAL(10,2),
    transaction_date DATE,
    merchant VARCHAR(100),
    cvv VARCHAR(4),
    pin_hash VARCHAR(64),
    flag VARCHAR(100)
);

-- Insert sample financial data
INSERT INTO financial_transactions VALUES
('TXN001', '4532-1234-5678-9012', '4532123456789012', 1234.56, '2024-01-15', 'Amazon AWS', '123', 'hashed_pin_value', 'FLAG{credit_card_in_database}'),
('TXN002', '5412-3456-7890-1234', '5412345678901234', 567.89, '2024-01-16', 'Microsoft Azure', '456', 'hashed_pin_value', 'FLAG{financial_data_exposed}'),
('TXN003', '3782-8224-6310-005', '378282246310005', 10234.00, '2024-01-17', 'Private Transfer', '789', 'hashed_pin_value', 'FLAG{amex_card_leaked}');

-- Customer PII table
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    ssn VARCHAR(11),
    date_of_birth DATE,
    address TEXT,
    password_hash VARCHAR(128),
    security_question VARCHAR(200),
    security_answer VARCHAR(200),
    flag VARCHAR(100)
);

-- Insert customer PII
INSERT INTO customers VALUES
('CUST001', 'John Doe', 'john.doe@email.com', '555-0100', '123-45-6789', '1980-05-15', '123 Main St, Sydney NSW 2000', '$2b$12$hashedpasswordhere', 'Mother maiden name?', 'Smith', 'FLAG{customer_pii_cleartext}'),
('CUST002', 'Jane Smith', 'jane.smith@email.com', '555-0101', '987-65-4321', '1990-08-20', '456 Oak Ave, Melbourne VIC 3000', '$2b$12$anotherhashedpass', 'First pet name?', 'Fluffy', 'FLAG{ssn_in_database}'),
('CUST003', 'Bob Johnson', 'bob.j@email.com', '555-0102', '111-22-3333', '1975-12-01', '789 Elm St, Brisbane QLD 4000', '$2b$12$yetanotherpasshash', 'Favorite color?', 'Blue', 'FLAG{security_questions_exposed}');

-- Employee records
CREATE TABLE employees (
    employee_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(12,2),
    bonus DECIMAL(12,2),
    ssn VARCHAR(11),
    bank_account VARCHAR(20),
    hire_date DATE,
    performance_rating VARCHAR(20),
    flag VARCHAR(100)
);

-- Insert employee data
INSERT INTO employees VALUES
('EMP001', 'Alice Johnson CEO', 'alice@company.com', 'Executive', 500000.00, 2000000.00, '555-12-3456', '9876543210', '2015-01-15', 'Excellent', 'FLAG{executive_compensation_exposed}'),
('EMP002', 'Charlie Admin', 'charlie@company.com', 'IT', 120000.00, 50000.00, '444-55-6666', '1234567890', '2018-03-20', 'Good', 'FLAG{employee_salary_data}'),
('EMP003', 'Diana Manager', 'diana@company.com', 'Operations', 150000.00, 75000.00, '777-88-9999', '5555555555', '2016-06-01', 'Excellent', 'FLAG{hr_data_breach}');

-- Database credentials table (meta)
CREATE TABLE database_credentials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    environment VARCHAR(50),
    database_type VARCHAR(50),
    host VARCHAR(200),
    port INT,
    database_name VARCHAR(100),
    username VARCHAR(100),
    password VARCHAR(200),
    connection_string TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    flag VARCHAR(100)
);

-- Insert database credentials (recursive vulnerability)
INSERT INTO database_credentials (environment, database_type, host, port, database_name, username, password, connection_string, flag) VALUES
('development', 'postgresql', 'dev-db.ctf-training.internal', 5432, 'ctf_training_dev', 'dev_admin', 'DevP@ssw0rd123!', 'postgresql://dev_admin:DevP@ssw0rd123!@dev-db.ctf-training.internal:5432/ctf_training_dev', 'FLAG{credentials_stored_in_database}'),
('production', 'postgresql', 'prod-db.ctf-training.internal', 5432, 'ctf_training_prod', 'prod_admin', 'ProdAdm1n!SecretP@ss', 'postgresql://prod_admin:ProdAdm1n!SecretP@ss@prod-db.ctf-training.internal:5432/ctf_training_prod', 'FLAG{production_db_creds_in_table}'),
('staging', 'mysql', 'staging-db.ctf-training.internal', 3306, 'ctf_training_staging', 'staging_user', 'StagingPass2024!', 'mysql://staging_user:StagingPass2024!@staging-db.ctf-training.internal:3306/ctf_training_staging', 'FLAG{staging_credentials_leaked}');

-- API keys table
CREATE TABLE api_keys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100),
    api_key TEXT,
    api_secret TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    flag VARCHAR(100)
);

-- Insert API keys
INSERT INTO api_keys (service_name, api_key, api_secret, expires_date, flag) VALUES
('AWS', 'AKIAIOSFODNN7EXAMPLE', 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY', '2025-12-31', 'FLAG{aws_keys_in_database}'),
('Stripe', 'pk_live_51HqmKH2eZvKYlo2C', 'sk_live_51HqmKH2eZvKYlo2C0FqKfdTs', '2025-12-31', 'FLAG{stripe_secret_key_stored}'),
('SendGrid', 'SG.xxxxxxxxxxxxxxxxxxxx', 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', '2025-12-31', 'FLAG{sendgrid_api_key_in_db}'),
('GitHub', 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', 'gho_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx', '2025-06-30', 'FLAG{github_token_in_database}');

-- Healthcare PHI table
CREATE TABLE patient_records (
    patient_id VARCHAR(20) PRIMARY KEY,
    full_name VARCHAR(100),
    date_of_birth DATE,
    ssn VARCHAR(11),
    diagnosis TEXT,
    medications TEXT,
    medical_history TEXT,
    insurance_number VARCHAR(50),
    doctor_name VARCHAR(100),
    flag VARCHAR(100)
);

-- Insert PHI data
INSERT INTO patient_records VALUES
('PAT001', 'Robert Johnson', '1980-05-15', '555-12-3456', 'Hypertension, Type 2 Diabetes', 'Lisinopril 10mg, Metformin 500mg', 'Chronic conditions managed since 2015', 'INS-123456789', 'Dr. Sarah Williams', 'FLAG{hipaa_violation_phi_exposed}'),
('PAT002', 'Emily Davis', '1975-08-20', '666-77-8888', 'Asthma, Anxiety Disorder', 'Albuterol inhaler, Sertraline 50mg', 'Family history of heart disease', 'INS-987654321', 'Dr. Michael Chen', 'FLAG{patient_medical_records_breach}');

-- Audit log (with passwords in logs - bad practice)
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id VARCHAR(50),
    action VARCHAR(100),
    details TEXT,
    ip_address VARCHAR(45),
    flag VARCHAR(100)
);

-- Insert audit logs with embedded credentials
INSERT INTO audit_log (user_id, action, details, ip_address, flag) VALUES
('admin', 'LOGIN', 'User logged in with password: Admin123!', '192.168.1.100', 'FLAG{passwords_in_audit_logs}'),
('user123', 'DATABASE_CONNECT', 'Connected to database using: postgresql://user:UserP@ss2024@db.internal:5432/app', '10.0.1.50', 'FLAG{connection_string_in_logs}'),
('system', 'API_CALL', 'API call made with key: sk_live_51HqmKH2eZvKYlo2C0FqKfdTs', '172.16.0.10', 'FLAG{api_key_logged}');

FLUSH PRIVILEGES;

-- Display summary
SELECT 'CTF Training Database Seeded Successfully!' AS status;
SELECT 'WARNING: This database contains intentional vulnerabilities' AS warning;
SELECT 'Total Flags Planted: 25+' AS flags;