IF NOT EXISTS(SELECT * FROM sys.databases where name = 'moze2')
    CREATE DATABASE moze2
GO

USE moze2
GO

-- DOWN
IF EXISTS( SELECT* FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_jobs_contracted_by')
    ALTER TABLE jobs DROP CONSTRAINT fk_jobs_contracted_by

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_jobs_job_submitted_by')
    ALTER TABLE jobs DROP CONSTRAINT fk_jobs_job_submitted_by

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_contractors_contractor_state')
    ALTER TABLE contractors DROP CONSTRAINT fk_contractors_contractor_state

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME = 'fk_customers_customer_state')
    ALTER TABLE customers DROP CONSTRAINT fk_customers_customer_state

DROP TABLE IF EXISTS jobs
DROP TABLE IF EXISTS contractors
DROP TABLE IF EXISTS customers
DROP TABLE IF EXISTS state_lookup



GO

-- UP Metadata
CREATE TABLE state_lookup(
    state_code char(2) NOT NULL,
    CONSTRAINT pk_state_lookup_state_code PRIMARY KEY(state_code)
)

CREATE TABLE customers(
    customer_id int identity NOT NULL,
    customer_email varchar(50) NOT NULL,
    customer_min_price money NOT NULL,
    customer_max_price money NOT NULL,
    customer_city varchar(50) NOT NULL,
    customer_state char(2) NOT NULL,
    CONSTRAINT pk_customers_customer_id primary key(customer_id),
    CONSTRAINT u_customer_email unique(customer_email),
    CONSTRAINT ck_min_max_price check(customer_min_price <= customer_max_price)
)

ALTER TABLE customers
    ADD CONSTRAINT fk_customers_customer_state FOREIGN KEY (customer_state)
        REFERENCES state_lookup(state_code)


CREATE TABLE contractors(
    contractor_id int IDENTITY NOT NULL,
    contractor_email varchar(50) NOT NULL,
    contractor_rate money NOT NULL,
    contractor_city varchar(50) NOT NULL,
    contractor_state char(2) NOT NULL,
    CONSTRAINT pk_contractors_contractor_email PRIMARY KEY(contractor_id),
    CONSTRAINT u_contractors_contractor_email UNIQUE(contractor_email),
)

ALTER TABLE contractors
    ADD CONSTRAINT fk_contractors_contractor_state FOREIGN KEY (contractor_state)
        REFERENCES state_lookup(state_code)


CREATE TABLE jobs(
    job_id int IDENTITY NOT NULL,
    job_submitted_by int NOT NULL,
    job_requested_date date NOT NULL,
    job_contracted_by int NULL,
    job_service_rate money NULL,
    job_estimated_date date NULL,
    job_completed_date date null,
    job_customer_rating int null,
    CONSTRAINT pk_jobs_job_id PRIMARY KEY(job_id),
)
ALTER TABLE jobs
    ADD CONSTRAINT fk_jobs_job_submitted_by FOREIGN KEY(job_submitted_by) 
    REFERENCES customers(customer_id)

ALTER TABLE jobs
    ADD CONSTRAINT fk_jobs_contracted_by FOREIGN KEY (job_contracted_by)
    REFERENCES contractors(contractor_id)

GO
-- UP Data
INSERT INTO state_lookup (state_code)
VALUES ('NY'), ('NJ'), ('CT');

INSERT INTO customers (customer_email, customer_min_price, customer_max_price, customer_city, customer_state)
VALUES 
('lkarforless@superrito.com', 50, 100, 'Syracuse', 'NY'),
('bdehatchett@dayrep.com', 25, 50, 'Syracuse', 'NY'),
('pmeaup@dayrep.com', 100, 150, 'Syracuse', 'NY'),
('tanott@gustr.com', 25, 75, 'Rochester', 'NY'),
('sboate@gustr.com', 50, 100, 'New Haven', 'CT');


INSERT INTO contractors (contractor_email, contractor_rate, contractor_city, contractor_state)
VALUES
('otyme@dayre.com', 50.000, 'Syracuse', 'NY'),
('meyezing@dayrep.com', 75.000, 'Syracuse', 'NY'),
('bitall@dayrep.com', 35.000, 'Rochester', 'NY'),
('ssbeeches@dayrep.com', 85.000, 'Hartford', 'CT');

INSERT INTO jobs (job_submitted_by, job_requested_date, job_contracted_by, job_service_rate, job_estimated_date, job_completed_date)
VALUES
(1, '2020-05-01',null,null,null,null),
(2, '2020-05-01', 1, 50.000, '2020-05-01',null),
(5, '2020-05-01', 4, 85.000, '2020-05-03', '2020-05-03');


GO

-- Verify
SELECT *
FROM state_lookup;

SELECT *
FROM customers;

SELECT * 
FROM contractors;

SELECT *
FROM jobs;
