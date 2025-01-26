-- Ops1: 
-- Objective: Analyze the distribution of order counts across time (month and year) 
-- and geographical regions (provinces) to identify trends or patterns.
SELECT D_TIME.Month, D_TIME.Year, D_AREA.Province, COUNT(F.NOORDER) AS N
FROM F_ORDER_DEMAND F
INNER JOIN D_TIME ON D_TIME.ID = F.TIME_ID
INNER JOIN D_AREA ON D_AREA.ID = F.AREA_ID
GROUP BY CUBE(D_TIME.Month, D_TIME.Year, D_AREA.Province)
ORDER BY 
    D_TIME.Year, 
    D_TIME.Month, 
    D_AREA.Province;


-- Ops2:
-- Objective: Evaluate the performance of different order and placement modes 
-- by analyzing their respective order counts.
SELECT D_ORDER_MODE.Type as ORDER_MODE, D_PLACEMENT_MODE.Type as PLACEMENT_MODE, COUNT(F.NOORDER) AS N
FROM F_ORDER_DEMAND F
INNER JOIN D_ORDER_MODE ON D_ORDER_MODE.ID = F.ORDER_MODE_ID
INNER JOIN D_PLACEMENT_MODE ON D_PLACEMENT_MODE.ID = F.PLACEMENT_MODE_ID
GROUP BY CUBE(D_ORDER_MODE.Type, D_PLACEMENT_MODE.Type)

-- Ops3:
-- Objective: Assess the operational demand across time (month and year) and 
-- operational centers to support resource allocation and planning
SELECT D_TIME.Month, D_TIME.Year, D_ORGANIZATION.OperationalCenterCode, COUNT(F.NOORDER) AS N
FROM F_ORDER_DEMAND F
INNER JOIN D_TIME ON D_TIME.ID = F.TIME_ID
INNER JOIN D_ORGANIZATION ON D_ORGANIZATION.ID = F.ORGANIZATION_ID
GROUP BY CUBE(D_TIME.Month, D_TIME.Year, D_ORGANIZATION.OperationalCenterCode)
ORDER BY 
    D_TIME.Year, 
    D_TIME.Month, 
    D_ORGANIZATION.OperationalCenterCode;


-- Ops4:
-- Objective: Analyze the average team scores across time (month and year) and geographical 
-- regions (provinces) to identify performance trends and regional variations.
-- Note: The OLTP system does not track the timestamp of score updates. A mechanism 
-- must be implemented in the data warehouse to record and manage this information.
SELECT D_TIME.Month, D_TIME.Year, D_AREA.Province, AVG(F.SCORE) AS S
FROM F_TEAM_SCORE F
INNER JOIN D_TIME ON D_TIME.ID = F.TIME_ID
INNER JOIN D_AREA ON D_AREA.ID = F.AREA_ID
GROUP BY CUBE(D_TIME.Month, D_TIME.Year, D_AREA.Province)
ORDER BY 
    D_TIME.Year,
    D_TIME.Month ASC;


-- Ops5:
-- Objective: Evaluate the average team scores based on operational centers and provinces 
-- to gain insights into performance differences between regions and centers.
SELECT D_ORGANIZATION.OperationalCenterCode, D_AREA.Province, AVG(F.SCORE) AS S
FROM F_TEAM_SCORE F
INNER JOIN D_ORGANIZATION ON D_ORGANIZATION.ID = F.ORGANIZATION_ID
INNER JOIN D_AREA ON D_AREA.ID = F.AREA_ID
GROUP BY CUBE(D_ORGANIZATION.OperationalCenterCode, D_AREA.Province);