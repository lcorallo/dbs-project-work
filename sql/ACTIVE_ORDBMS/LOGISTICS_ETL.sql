-- Populate D_TIME
INSERT INTO D_TIME@DW (ID, DAY, WEEK, MONTH, QUARTER, YEAR, ISWEEKEND, ISHOLIDAY)
SELECT ROWNUM AS ID, DAY, WEEK, MONTH, QUARTER, YEAR, ISWEEKEND, ISHOLIDAY      -- Generate a unique ID for each row using ROWNUM
FROM (
    SELECT DISTINCT
        EXTRACT(DAY FROM CREATION_DATE) AS DAY,                                 -- Extracting Day
        ROUND(TO_NUMBER(TO_CHAR(CREATION_DATE, 'DD')) / 7 + 1) AS WEEK,         -- Week number calculation
        EXTRACT(MONTH FROM CREATION_DATE) AS MONTH,                             -- Extracting Month
        ROUND(EXTRACT(MONTH FROM CREATION_DATE) / 4 + 1) AS QUARTER,            -- Quarter calculation
        EXTRACT(YEAR FROM CREATION_DATE) + 2000 AS YEAR,                        -- Extracting Year and adjusting format
        CASE 
            WHEN TO_CHAR(CREATION_DATE, 'D') IN ('1', '7') THEN 1               -- Weekend (1 = Sunday, 7 = Saturday)
            ELSE 0                                                              -- Weekday
        END AS ISWEEKEND,
        0 AS ISHOLIDAY                                                          -- Since we don't have a holiday table, we'll set ISHOLIDAY as 0
    FROM OPERATION_ORDER
) TIME
/
COMMIT;
/



-- Populate D_AREA
CREATE TABLE temp_area (
    ID NUMBER(38) NOT NULL,
    CITY VARCHAR2(10) NOT NULL,
    ZIPCODE VARCHAR2(5) NOT NULL,
    PROVINCE VARCHAR2(5) NOT NULL,
    COUNTRY VARCHAR2(30) NOT NULL
);
/
INSERT INTO temp_area (ID, CITY, ZIPCODE, PROVINCE, COUNTRY)
SELECT 
    ROWNUM AS ID,
    CAST(SUBSTR(CITY, 1, 10) AS VARCHAR2(10)) AS CITY,  -- Truncate to fit VARCHAR2(10)
    CAST(SUBSTR(ZIPCODE, 1, 5) AS VARCHAR2(5)) AS ZIPCODE,  -- Truncate to fit VARCHAR2(5)
    CAST(SUBSTR(PROVINCE, 1, 5) AS VARCHAR2(5)) AS PROVINCE,  -- Truncate to fit VARCHAR2(5)
    CAST('IT' AS VARCHAR2(30)) AS COUNTRY  -- 'IT' fits into VARCHAR2(30)
FROM 
(
    SELECT 
        OC.address.city AS CITY,
        OC.address.zipcode AS ZIPCODE,
        OC.address.province AS PROVINCE,
        'Italy' AS COUNTRY
    FROM OPERATIONAL_CENTER OC
);
INSERT INTO D_AREA@DW (ID, CITY, ZIPCODE, PROVINCE, COUNTRY)
SELECT ID, CITY, ZIPCODE, PROVINCE, COUNTRY
FROM temp_area;
/
COMMIT;
/
DROP TABLE temp_area;


-- Populate D_ORDER_MODE
INSERT INTO D_ORDER_MODE@DW (ID, TYPE)
SELECT ROWNUM AS ID, T
FROM (
    SELECT DISTINCT TYPE AS T
    FROM OPERATION_ORDER
) operation_type;
/
COMMIT;
/


-- Populate D_PLACEMENT_MODE
INSERT INTO D_PLACEMENT_MODE@DW (ID, TYPE)
SELECT ROWNUM AS ID, T
FROM (
    SELECT DISTINCT PLACEMENTBY AS T
    FROM OPERATION_ORDER
) placement_type;
/
COMMIT;
/


-- Populate D_ORGANIZATION
CREATE TABLE TeamOperationalCenter (
    TEAMCODE VARCHAR(255),
    OPERATIONALCENTERCODE VARCHAR(255)
);
/
INSERT INTO TeamOperationalCenter (TEAMCODE, OPERATIONALCENTERCODE)
SELECT CODE AS TEAMCODE, DEREF(centerRef).CODE AS OPERATIONALCENTERCODE
FROM TEAM;
/
INSERT INTO D_ORGANIZATION@DW (ID, TEAMCODE, OPERATIONALCENTERCODE)
SELECT ROWNUM AS ID, TEAMCODE, OPERATIONALCENTERCODE
FROM TeamOperationalCenter;
/
COMMIT;
/
DROP TABLE TeamOperationalCenter;


-- Insert FACT ORDER DEMAND
CREATE TABLE TEMP_ORDER_DEMAND (
    ID INTEGER NOT NULL,  
    noOrder INTEGER NOT NULL,                          
    placement_mode_id INTEGER NOT NULL,               
    order_mode_id INTEGER NOT NULL,                   
    organization_id INTEGER NOT NULL,                  
    area_id INTEGER NOT NULL,                        
    time_id INTEGER NOT NULL
);


INSERT INTO TEMP_ORDER_DEMAND (ID, NOORDER, PLACEMENT_MODE_ID, ORDER_MODE_ID, ORGANIZATION_ID, AREA_ID, TIME_ID)
SELECT ROWNUM AS ID, NOORDER, PLACEMENT_MODE_ID, ORDER_MODE_ID, ORGANIZATION_ID, AREA_ID, TIME_ID
FROM (
    SELECT DISTINCT OO.CODE AS NOORDER, TIME.ID AS TIME_ID, ORDERMODE.ID AS ORDER_MODE_ID, PLACEMENTMODE.ID AS PLACEMENT_MODE_ID, ORGS.ID AS ORGANIZATION_ID, AREA.ID AS AREA_ID
    FROM OPERATION_ORDER OO, D_TIME@DW TIME, D_ORDER_MODE@DW ORDERMODE , D_PLACEMENT_MODE@DW PLACEMENTMODE, D_ORGANIZATION@DW ORGS, D_AREA@DW AREA
    WHERE 
        TIME.DAY = EXTRACT(DAY FROM OO.CREATION_DATE) AND
        TIME.MONTH = EXTRACT(MONTH FROM OO.CREATION_DATE) AND
        TIME.YEAR = EXTRACT(YEAR FROM OO.CREATION_DATE) + 2000 AND
        ORDERMODE.TYPE =  OO.type AND
        PLACEMENTMODE.TYPE = OO.placementby AND
        ORGS.TEAMCODE = DEREF(teamRef).code AND
        
        AREA.CITY = DEREF(DEREF(teamRef).centerRef).address.city AND
        AREA.ZIPCODE = DEREF(DEREF(teamRef).centerRef).address.zipcode AND
        AREA.PROVINCE = DEREF(DEREF(teamRef).centerRef).address.province
) FACT


INSERT INTO F_ORDER_DEMAND@DW (ID, NOORDER, PLACEMENT_MODE_ID, ORDER_MODE_ID, ORGANIZATION_ID, AREA_ID, TIME_ID)
SELECT ID, NOORDER, PLACEMENT_MODE_ID, ORDER_MODE_ID, ORGANIZATION_ID, AREA_ID, TIME_ID FROM TEMP_ORDER_DEMAND;
/
COMMIT;
/
DROP TABLE TEMP_ORDER_DEMAND;



-- INSERT FACT TEAM SCORE


INSERT INTO D_TIME@DW (ID, DAY, WEEK, MONTH, QUARTER, YEAR, ISWEEKEND, ISHOLIDAY) VALUES (
(SELECT MAX(ID) + 1 AS ID FROM D_TIME@DW), 31,5, 1, 1, 2025, 0, 0);
/
CREATE TABLE TEMP_TEAM_SCORE (
    ID INTEGER NOT NULL,                               
    score INTEGER NOT NULL,                           
    organization_id INTEGER NOT NULL,                 
    area_id INTEGER NOT NULL,                        
    time_id INTEGER NOT NULL                      
);
/
INSERT INTO TEMP_TEAM_SCORE (ID, SCORE, ORGANIZATION_ID, AREA_ID, TIME_ID)
SELECT  ROWNUM AS ID, SCORE, ORGANIZATION_ID, AREA_ID, TIME_ID
FROM (
    SELECT T.SCORE, ORGS.ID AS ORGANIZATION_ID, AREA.ID AS AREA_ID, TIME_ID
    FROM TEAM T, D_ORGANIZATION@DW ORGS, D_AREA@DW AREA, (SELECT MAX(ID) AS TIME_ID FROM D_TIME@DW)
    WHERE ORGS.TEAMCODE = T.CODE AND
        DEREF(T.CENTERREF).address.city = AREA.city AND
        DEREF(T.CENTERREF).address.zipcode = AREA.zipcode AND
        DEREF(T.CENTERREF).address.province = AREA.province
);
/
INSERT INTO F_TEAM_SCORE@DW (ID, SCORE, ORGANIZATION_ID, AREA_ID, TIME_ID)
SELECT ID, SCORE, ORGANIZATION_ID, AREA_ID, TIME_ID FROM TEMP_TEAM_SCORE;
/
DROP TABLE TEMP_TEAM_SCORE;
/
COMMIT;