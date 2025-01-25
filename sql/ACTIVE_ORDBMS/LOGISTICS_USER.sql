
-- Step 3: Create a new user named 'LOGISTICS' with necessary configurations
CREATE USER "LOGISTICS"
    PROFILE "DEFAULT"                               -- Assign the default profile to the user
    IDENTIFIED BY "password"                       -- Set the user's password
    DEFAULT TABLESPACE "USERS"                     -- Set the default tablespace for the user
    TEMPORARY TABLESPACE "TEMP"                    -- Assign a temporary tablespace
    QUOTA UNLIMITED ON USERS                       -- Allow unlimited storage in the 'USERS' tablespace
    ACCOUNT UNLOCK;                                -- Unlock the account
/

-- Step 4: Grant basic privileges to 'LOGISTICS'
GRANT "CONNECT" TO "LOGISTICS";                   -- Allow the user to connect to the database
GRANT CREATE SESSION TO "LOGISTICS";              -- Grant the ability to create sessions
GRANT CREATE DATABASE LINK TO "LOGISTICS";        -- Allow the user to create database link

-- Step 5: Grant object-related privileges to 'LOGISTICS'
GRANT CREATE ANY TABLE TO "LOGISTICS";            -- Allow creation of tables
GRANT ALTER ANY TABLE TO "LOGISTICS";             -- Allow modification of tables
GRANT DROP ANY TABLE TO "LOGISTICS";              -- Allow deletion of tables
GRANT SELECT ANY TABLE TO "LOGISTICS";            -- Allow selection (read) from any table

-- Step 6: Grant privileges for types
GRANT CREATE ANY TYPE TO "LOGISTICS";             -- Allow creation of user-defined types
GRANT ALTER ANY TYPE TO "LOGISTICS";              -- Allow modification of user-defined types
GRANT DROP ANY TYPE TO "LOGISTICS";               -- Allow deletion of user-defined types

-- Step 7: Grant privileges for procedures
GRANT CREATE ANY PROCEDURE TO "LOGISTICS";        -- Allow creation of stored procedures
GRANT ALTER ANY PROCEDURE TO "LOGISTICS";         -- Allow modification of stored procedures
GRANT DROP ANY PROCEDURE TO "LOGISTICS";          -- Allow deletion of stored procedures

-- Step 8: Grant privileges for triggers
GRANT CREATE ANY TRIGGER TO "LOGISTICS";          -- Allow creation of triggers
GRANT ALTER ANY TRIGGER TO "LOGISTICS";           -- Allow modification of triggers
GRANT DROP ANY TRIGGER TO "LOGISTICS";            -- Allow deletion of triggers

-- Step 9: Grant privileges for clusters
GRANT CREATE ANY CLUSTER TO "LOGISTICS";          -- Allow creation of clusters
GRANT ALTER ANY CLUSTER TO "LOGISTICS";           -- Allow modification of clusters
GRANT DROP ANY CLUSTER TO "LOGISTICS";            -- Allow deletion of clusters