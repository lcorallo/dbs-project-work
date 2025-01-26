-- Step 1: Drop existing tables if they exist to avoid conflicts during recreation
DROP TABLE F_Order_Demand;
/
DROP TABLE F_Team_Score;
/
DROP TABLE D_Placement_Mode;
/
DROP TABLE D_Order_Mode;
/
DROP TABLE D_Organization;
/
DROP TABLE D_Area;
/
DROP TABLE D_Time;
/
DROP DATABASE LINK OLTP;
/

-- Step 2: Create the 'D_Placement_Mode' dimension table
CREATE TABLE D_Placement_Mode (
    ID INTEGER NOT NULL,                               -- Primary key for the Placement Mode
    type VARCHAR2(9) NOT NULL,                         -- Type of placement (PHONE, EMAIL, PLATFORM)
    CHECK (type IN ('PHONE', 'EMAIL', 'PLATFORM')),    -- Restrict valid values for 'type'
    CONSTRAINT PlacementMode_PK PRIMARY KEY (ID)       -- Primary key constraint on 'ID'
);
/

-- Step 3: Create the 'D_Order_Mode' dimension table
CREATE TABLE D_Order_Mode (
    ID INTEGER NOT NULL,                               -- Primary key for the Order Mode
    type VARCHAR2(9) NOT NULL,                         -- Type of order mode (BULK, URGENT, REGULAR)
    CHECK (type IN ('BULK', 'URGENT', 'REGULAR')),     -- Restrict valid values for 'type'
    CONSTRAINT OrderMode_PK PRIMARY KEY (ID)           -- Primary key constraint on 'ID'
);
/

-- Step 4: Create the 'D_Organization' dimension table
CREATE TABLE D_Organization (
    ID INTEGER NOT NULL,                               -- Primary key for the organization
    teamCode INTEGER NOT NULL,                         -- Code for the team
    operationalCenterCode INTEGER NOT NULL,            -- Code for the operational center
    CONSTRAINT Organization_PK PRIMARY KEY (ID)        -- Primary key constraint on 'ID'
);
/

-- Step 5: Create the 'D_Area' dimension table
CREATE TABLE D_Area (
    ID INTEGER NOT NULL,                               -- Primary key for the Area
    city VARCHAR2(10) NOT NULL,                        -- City name
    zipcode VARCHAR2(5) NOT NULL,                      -- Zipcode
    province VARCHAR2(5) NOT NULL,                     -- Province (2-character code)
    country VARCHAR2(30) NOT NULL,                     -- Country name
    CONSTRAINT Area_PK PRIMARY KEY (ID)                -- Primary key constraint on 'ID'
);
/

-- Step 6: Create the 'D_Time' dimension table
CREATE TABLE D_Time (
    ID INTEGER NOT NULL,                               -- Primary key for the Time
    day INTEGER NOT NULL,                              -- Day of the month
    week INTEGER NOT NULL,                             -- Week of the year
    month INTEGER NOT NULL,                            -- Month of the year
    quarter INTEGER NOT NULL,                          -- Quarter of the year
    year INTEGER NOT NULL,                             -- Year
    isWeekend NUMBER(1) CHECK (isWeekend IN (0, 1)) NOT NULL,  -- Indicates if the day is a weekend (0 for FALSE, 1 for TRUE)
    isHoliday NUMBER(1) CHECK (isHoliday IN (0, 1)) NOT NULL,  -- Indicates if the day is a holiday (0 for FALSE, 1 for TRUE)
    CONSTRAINT Time_PK PRIMARY KEY (ID)               -- Primary key constraint on 'ID'
);
/

-- Step 7: Create the 'F_Order_Demand' fact table
CREATE TABLE F_Order_Demand (
    ID INTEGER NOT NULL,                               -- Primary key for the fact table
    noOrder INTEGER NOT NULL,                          -- Number of orders
    forecast INTEGER,                                  -- Forecasted value (nullable)
    placement_mode_id INTEGER NOT NULL,                -- Foreign key to D_Placement_Mode
    order_mode_id INTEGER NOT NULL,                    -- Foreign key to D_Order_Mode
    organization_id INTEGER NOT NULL,                  -- Foreign key to D_Organization
    area_id INTEGER NOT NULL,                          -- Foreign key to D_Area
    time_id INTEGER NOT NULL,                          -- Foreign key to D_Time
    FOREIGN KEY (placement_mode_id) REFERENCES D_Placement_Mode (ID),  -- Reference to D_Placement_Mode
    FOREIGN KEY (order_mode_id) REFERENCES D_Order_Mode (ID),          -- Reference to D_Order_Mode
    FOREIGN KEY (organization_id) REFERENCES D_Organization (ID),      -- Reference to D_Organization
    FOREIGN KEY (area_id) REFERENCES D_Area (ID),                      -- Reference to D_Area
    FOREIGN KEY (time_id) REFERENCES D_Time (ID)                       -- Reference to D_Time
);
/

-- Step 8: Create the 'F_Team_Score' fact table
CREATE TABLE F_Team_Score (
    ID INTEGER NOT NULL,                               -- Primary key for the fact table
    score INTEGER NOT NULL,                            -- Team score
    organization_id INTEGER NOT NULL,                  -- Foreign key to D_Organization
    area_id INTEGER NOT NULL,                          -- Foreign key to D_Area
    time_id INTEGER NOT NULL,                          -- Foreign key to D_Time
    FOREIGN KEY (organization_id) REFERENCES D_Organization (ID),      -- Reference to D_Organization
    FOREIGN KEY (area_id) REFERENCES D_Area (ID),                      -- Reference to D_Area
    FOREIGN KEY (time_id) REFERENCES D_Time (ID)                       -- Reference to D_Time
);
/
-- Step 9: Create a database link named 'oltp' for connecting to another Oracle database
CREATE DATABASE LINK oltp
CONNECT TO "LOGISTICS" IDENTIFIED BY "password"
USING '(DESCRIPTION=
         (ADDRESS=(PROTOCOL=TCP)(HOST=oracle-xe)(PORT=1521))
         (CONNECT_DATA=(SERVICE_NAME=XE))
        )';
/


-- Step 10: Test the database link by using tnsping
tnsping oltp;                                       -- Verify the connection to the 'oltp' database link
