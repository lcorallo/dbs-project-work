-- Step 1: Verify the current value of the 'common_user_prefix' parameter
-- This parameter determines the prefix for common users (default is 'C##').
SELECT * 
FROM V$PARAMETER 
WHERE NAME = 'common_user_prefix';
/

-- Step 2: Remove the prefix requirement for common user names.
-- Note: After executing this command, a database restart is required for the change to take effect.
ALTER SYSTEM SET common_user_prefix = '' SCOPE = SPFILE;
/

-- Step 3: Create a new user 'LOGISTICS_DW' for the Data Warehouse with required settings
CREATE USER "LOGISTICS_DW"
    PROFILE "DEFAULT"                               -- Assign the default profile to the user
    IDENTIFIED BY "password"                        -- Set the user's password
    DEFAULT TABLESPACE "USERS"                      -- Set the default tablespace for the user
    TEMPORARY TABLESPACE "TEMP"                     -- Assign a temporary tablespace for the user
    QUOTA UNLIMITED ON USERS                        -- Allow unlimited storage in the 'USERS' tablespace
    ACCOUNT UNLOCK;                                 -- Unlock the account to make it active
/

-- Step 4: Grant essential privileges to 'LOGISTICS_DW' user
GRANT "CONNECT" TO "LOGISTICS_DW";                     -- Grant the ability to connect to the database
GRANT CREATE ANY TABLE TO "LOGISTICS_DW";             -- Allow the user to create tables
GRANT ALTER ANY TABLE TO "LOGISTICS_DW";              -- Allow modification of any table
GRANT DROP ANY TABLE TO "LOGISTICS_DW";               -- Allow deletion of any table

-- Step 5: Grant additional privileges for creating a database link
GRANT CREATE DATABASE LINK TO "LOGISTICS_DW";         -- Allow the user to create database links
GRANT CREATE SESSION TO "LOGISTICS_DW";              -- Grant the ability to create sessions