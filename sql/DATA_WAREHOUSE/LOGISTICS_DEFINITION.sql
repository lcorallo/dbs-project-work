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
CREATE TABLE D_Placement_Mode (
    ID INTEGER NOT NULL,
    type VARCHAR2(9) NOT NULL,
    CHECK (type IN ('PHONE', 'EMAIL', 'PLATFORM')),
    CONSTRAINT PlacementMode_PK PRIMARY KEY (ID)
);
/
CREATE TABLE D_Order_Mode (
    ID INTEGER NOT NULL,
    type VARCHAR2(9) NOT NULL,
    CHECK (type IN ('BULK', 'URGENT', 'REGULAR')),
    CONSTRAINT OrderMode_PK PRIMARY KEY (ID)
);
/
CREATE TABLE D_Organization (
    ID INTEGER NOT NULL,
    teamCode INTEGER NOT NULL,
    operationalCenterCode INTEGER NOT NULL,
    CONSTRAINT Organization_PK PRIMARY KEY (ID)
);
/
CREATE TABLE D_Area (
    ID INTEGER NOT NULL,
    city VARCHAR2(30) NOT NULL,
    province CHAR(2) NOT NULL,
    country VARCHAR2(30) NOT NULL,
    CONSTRAINT Area_PK PRIMARY KEY (ID)
);
/
CREATE TABLE D_Time (
    ID INTEGER NOT NULL,
    day INTEGER NOT NULL,
    week INTEGER NOT NULL,
    month INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    year INTEGER NOT NULL,
    isWeekend NUMBER(1) CHECK (isWeekend IN (0, 1)) NOT NULL, -- 0 for FALSE, 1 for TRUE
    isHoliday NUMBER(1) CHECK (isHoliday IN (0, 1)) NOT NULL, -- 0 for FALSE, 1 for TRUE
    CONSTRAINT Time_PK PRIMARY KEY (ID)
);
/
CREATE TABLE F_Order_Demand (
    ID INTEGER NOT NULL,
    noOrder INTEGER NOT NULL,
    forecast INTEGER,
    placement_mode_id INTEGER NOT NULL,
    order_mode_id INTEGER NOT NULL,
    organization_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    time_id INTEGER NOT NULL,
    FOREIGN KEY (placement_mode_id) REFERENCES D_Placement_Mode (ID),
    FOREIGN KEY (order_mode_id) REFERENCES D_Order_Mode (ID),
    FOREIGN KEY (organization_id) REFERENCES D_Organization (ID),
    FOREIGN KEY (area_id) REFERENCES D_Area (ID),
    FOREIGN KEY (time_id) REFERENCES D_Time (ID)
);
/
CREATE TABLE F_Team_Score (
    ID INTEGER NOT NULL,
    score INTEGER NOT NULL,
    organization_id INTEGER NOT NULL,
    area_id INTEGER NOT NULL,
    time_id INTEGER NOT NULL,
    FOREIGN KEY (organization_id) REFERENCES D_Organization (ID),
    FOREIGN KEY (area_id) REFERENCES D_Area (ID),
    FOREIGN KEY (time_id) REFERENCES D_Time (ID)
);
/