-- Step 1: Drop existing tables and types to avoid conflicts
DROP TABLE COMPANY;
/
DROP TABLE OPERATIONAL_CENTER;
/
DROP TYPE COMPANY_TY FORCE;
/
DROP TYPE SERVICE_TY FORCE;
/
DROP TYPE SERVICES_TY FORCE;
/
DROP TYPE OPERATIONAL_CENTER_TY FORCE;
/
DROP INDEX IDX_TEAM;
/
DROP TABLE TEAM;
/
DROP TYPE TEAM_TY FORCE;
/
DROP TYPE MEMBER_TY FORCE;
/
DROP TYPE MEMBERS_TY FORCE;
/
DROP TABLE ACCOUNT;
/
DROP TABLE CUSTOMER;
/
DROP TYPE CUSTOMER_TY FORCE;
/
DROP TYPE BUSINESS_TY FORCE;
/
DROP TYPE INDIVIDUAL_TY FORCE;
/
DROP TYPE PERSON_TY FORCE;
/
DROP TYPE ACCOUNT_TY FORCE;
/
DROP TYPE ADDRESS_TY FORCE;
/
DROP TABLE OPERATION_ORDER;
/
DROP TYPE ORDER_TY FORCE;
/
DROP TYPE DELIVERY_TY FORCE;
/
DROP CLUSTER TEAM_HASH_CLUSTER;
/
DROP DATABASE LINK DW;
/
-- Step 2: Create types for Service, Services, and Company
CREATE OR REPLACE TYPE SERVICE_TY AS OBJECT (
    code INTEGER,                                       -- Unique service code
    name VARCHAR2(50),                                   -- Service name
    description VARCHAR2(200)                            -- Description of the service
);
/
CREATE OR REPLACE TYPE SERVICES_TY AS TABLE OF SERVICE_TY;  -- Collection of services
/
CREATE OR REPLACE TYPE COMPANY_TY AS OBJECT (
    name VARCHAR(30),                                    -- Company name
    services SERVICES_TY                                  -- Collection of services
);
/

-- Step 3: Create COMPANY table using the COMPANY_TY object type
CREATE TABLE COMPANY OF COMPANY_TY (
  CONSTRAINT COMPANY_PK PRIMARY KEY (name) ENABLE   -- Primary key constraint on 'name'
) NESTED TABLE services STORE as services_TAB;      -- Store services in a nested table
/

-- Step 4: Create the ADDRESS_TY object type to represent an address
CREATE OR REPLACE TYPE ADDRESS_TY AS OBJECT (
    street VARCHAR2(50),                               -- Street address
    city VARCHAR2(10),                                 -- City
    province VARCHAR2(5),                              -- Province
    zipcode VARCHAR2(5)                                -- Zipcode
);
/

-- Step 5: Create the OPERATIONAL_CENTER_TY object type
CREATE OR REPLACE TYPE OPERATIONAL_CENTER_TY AS OBJECT (
    code INTEGER,                                      -- Operational center code
    name VARCHAR2(20),                                  -- Operational center name
    address ADDRESS_TY,                                 -- Address (using ADDRESS_TY)
    companyRef REF COMPANY_TY                           -- Reference to the COMPANY object type
);
/

-- Step 6: Create OPERATIONAL_CENTER table
CREATE TABLE OPERATIONAL_CENTER OF OPERATIONAL_CENTER_TY (
    SCOPE FOR (companyRef) IS COMPANY,                 -- Scope for the reference to the COMPANY table
    CONSTRAINT OPERATIONAL_CENTER_PK PRIMARY KEY (code) ENABLE  -- Primary key constraint on 'code'
);
/

-- Step 7: Create the PERSON_TY object type (base type for all persons)
CREATE OR REPLACE TYPE PERSON_TY AS OBJECT (
    name VARCHAR2(20),                                  -- Person's first name
    surname VARCHAR2(20)                                -- Person's surname
)
NOT INSTANTIABLE
NOT FINAL;                                              -- The PERSON_TY type cannot be instantiated directly
/

-- Step 8: Create MEMBER_TY (inherits from PERSON_TY) for team members
CREATE OR REPLACE TYPE MEMBER_TY UNDER PERSON_TY (
    CF CHAR(16)                                         -- Unique identifier for the member (e.g., tax code)
);
/

-- Step 9: Create MEMBERS_TY as a collection of MEMBER_TY objects (VARRAY of size 8)
CREATE OR REPLACE TYPE MEMBERS_TY AS VARRAY(8) OF MEMBER_TY;
/

-- Step 10: Create the TEAM_TY object type to represent a team
CREATE OR REPLACE TYPE TEAM_TY AS OBJECT (
    code INTEGER,                                      -- Team code
    name VARCHAR2(20),                                  -- Team name
    noOperations INTEGER,                               -- Number of operations
    score INTEGER,                                      -- Team score
    members MEMBERS_TY,                                 -- Collection of team members
    centerRef REF OPERATIONAL_CENTER_TY                 -- Reference to the operational center
);
/

-- Step 11: Create the TEAM_HASH_CLUSTER for optimized storage and access by team code
CREATE CLUSTER TEAM_HASH_CLUSTER ( 
    CODE INTEGER                                        -- Define the clustered key (team code)
) 
HASHKEYS 200                                           -- Define the number of hash keys
SIZE 212;                                              -- Define the size of the cluster
/

-- Step 12: Create TEAM table using the TEAM_TY object type
CREATE TABLE TEAM OF TEAM_TY (
  SCOPE FOR (centerRef) IS OPERATIONAL_CENTER,         -- Scope for the reference to the OPERATIONAL_CENTER table
  CONSTRAINT TEAM_PK PRIMARY KEY (code) ENABLE         -- Primary key constraint on 'code'
)
CLUSTER TEAM_HASH_CLUSTER (CODE);                      -- Use the TEAM_HASH_CLUSTER for storage
/

-- Step 13: Create CUSTOMER_TY (inherits from PERSON_TY) to represent a customer
CREATE OR REPLACE TYPE CUSTOMER_TY UNDER PERSON_TY (
    code INTEGER,                                      -- Customer code
    email VARCHAR2(50),                                 -- Customer's email address
    type VARCHAR2(20)                                   -- Customer type (e.g., Individual, Business)
)
NOT FINAL;                                              -- The CUSTOMER_TY type is not final, so it can be extended
/

-- Step 14: Create BUSINESS_TY and INDIVIDUAL_TY types as extensions of CUSTOMER_TY
CREATE OR REPLACE TYPE BUSINESS_TY UNDER CUSTOMER_TY();  -- Represent a business customer
/
CREATE OR REPLACE TYPE INDIVIDUAL_TY UNDER CUSTOMER_TY();  -- Represent an individual customer
/

-- Step 15: Create CUSTOMER table using the CUSTOMER_TY object type
CREATE TABLE CUSTOMER OF CUSTOMER_TY (
    CHECK (type IN ('Individual', 'Business')),         -- Ensure that 'type' is either 'Individual' or 'Business'
    CONSTRAINT CUSTOMER_PK PRIMARY KEY (code) ENABLE    -- Primary key constraint on 'code'
);
/

-- Step 16: Create ACCOUNT_TY object type to represent customer accounts
CREATE OR REPLACE TYPE ACCOUNT_TY AS OBJECT (
    code INTEGER,                                      -- Account code
    customerRef REF CUSTOMER_TY                         -- Reference to the CUSTOMER object type
);
/

-- Step 17: Create ACCOUNT table using the ACCOUNT_TY object type
CREATE TABLE ACCOUNT OF ACCOUNT_TY (
    SCOPE FOR (customerRef) IS CUSTOMER,                -- Scope for the reference to the CUSTOMER table
    CONSTRAINT ACCOUNT_PK PRIMARY KEY (code) ENABLE     -- Primary key constraint on 'code'
);
/

-- Step 18: Create DELIVERY_TY object type to represent delivery information
CREATE OR REPLACE TYPE DELIVERY_TY AS OBJECT (
    customerFeedback VARCHAR2(200),                     -- Feedback from the customer
    deliveryTime INTERVAL DAY TO SECOND                 -- Time interval for delivery
);
/

-- Step 19: Create ORDER_TY object type to represent an operation order
CREATE OR REPLACE TYPE ORDER_TY AS OBJECT (
    code INTEGER,                                      -- Order code
    type VARCHAR2(10),                                  -- Order type (e.g., BULK, URGENT, REGULAR)
    creation_date DATE,                                 -- Date of order creation
    cost NUMBER(15, 2),                                 -- Order cost
    placementBy VARCHAR2(10),                           -- Method of order placement (PHONE, EMAIL, PLATFORM)
    teamRef REF TEAM_TY,                                -- Reference to the TEAM object type
    accountRef REF ACCOUNT_TY,                          -- Reference to the ACCOUNT object type
    delivery DELIVERY_TY                                 -- Delivery details (using DELIVERY_TY)
);
/

-- Step 20: Create OPERATION_ORDER table using the ORDER_TY object type
CREATE TABLE OPERATION_ORDER OF ORDER_TY (
    SCOPE FOR (teamRef) IS TEAM,                        -- Scope for the reference to the TEAM table
    SCOPE FOR (accountRef) IS ACCOUNT,                  -- Scope for the reference to the ACCOUNT table
    CHECK (type IN ('BULK', 'URGENT', 'REGULAR')),      -- Ensure that the 'type' is a valid order type
    CHECK (placementBy IN ('PHONE', 'EMAIL', 'PLATFORM')),  -- Ensure that the 'placementBy' is valid
    CONSTRAINT OPERATION_ORDER_PK PRIMARY KEY (code) ENABLE   -- Primary key constraint on 'code'
);
/

-- Step 21: Create stored procedures for updating operations count
CREATE OR REPLACE PROCEDURE IncrementOperationsCount (incomingCode IN INTEGER)
IS
BEGIN
    UPDATE TEAM
    SET noOperations = noOperations + 1
    WHERE code = incomingCode;
END IncrementOperationsCount;
/

CREATE OR REPLACE PROCEDURE DecrementOperationsCount (incomingCode IN INTEGER)
IS
BEGIN
    UPDATE TEAM
    SET noOperations = noOperations - 1
    WHERE code = incomingCode;
END DecrementOperationsCount;
/

-- Step 22: Create triggers for synchronization and validation
CREATE OR REPLACE TRIGGER SYNC_TEAM_OPS
AFTER INSERT OR DELETE OR UPDATE OF teamRef ON OPERATION_ORDER
FOR EACH ROW
BEGIN
    DECLARE
        new_team_code INTEGER;
        old_team_code INTEGER;
    BEGIN
        -- Update the operations count for the team
        SELECT DEREF(:NEW.teamRef).code
        INTO new_team_code
        FROM dual;
        IncrementOperationsCount(new_team_code);

        SELECT DEREF(:OLD.teamRef).code
        INTO old_team_code
        FROM dual;
        DecrementOperationsCount(old_team_code);
    END;
END SYNC_TEAM_OPS;
/

-- Step 23: Create validation procedure and trigger for team scores
CREATE OR REPLACE PROCEDURE CheckTeamScore (incomingScore IN INTEGER)
IS
BEGIN
    IF incomingScore < 0 OR incomingScore > 100 THEN
        RAISE_APPLICATION_ERROR(-20999, 'A team score must be between 0 and 100');
    END IF;
END CheckTeamScore;
/

CREATE OR REPLACE TRIGGER CHECK_TEAM
BEFORE INSERT OR UPDATE ON TEAM
FOR EACH ROW
BEGIN
    -- Ensure team operations and score meet specific criteria
    IF :OLD.noOperations IS NULL THEN
        IF :NEW.noOperations IS NOT NULL AND :NEW.noOperations > 0 THEN
            RAISE_APPLICATION_ERROR(-20999, 'A team must start with 0 operations');
        END IF;
        :NEW.noOperations := 0;
    ELSE
        IF :NEW.noOperations < 0 OR ABS(:NEW.noOperations - :OLD.noOperations) > 1 THEN
            RAISE_APPLICATION_ERROR(-20999, 'A team operations must be greater than 0 and can be incremented only by one each time');
        END IF;
    END IF;

    IF :NEW.score IS NULL THEN
        :NEW.score := 0;
    ELSE
        CheckTeamScore(:NEW.score);
    END IF;
END CHECK_TEAM;
/

-- Step 24: Create index on TEAM table for efficient score lookups
CREATE INDEX IDX_TEAM ON TEAM (score);
/

-- Step 25: Create a database link named 'dw' for connecting to another Oracle database
CREATE DATABASE LINK DW
CONNECT TO "LOGISTICS_DW" IDENTIFIED BY "password"
USING '(DESCRIPTION=
         (ADDRESS=(PROTOCOL=TCP)(HOST=oracle-dw)(PORT=1521))
         (CONNECT_DATA=(SERVICE_NAME=XE))
        )';
/


-- Step 26: Test the database link by using tnsping
tnsping DW;                                       -- Verify the connection to the 'oltp' database link