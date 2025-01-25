-- Trigger Documentation

-- CHECK_TEAM Trigger: 
-- This trigger enforces business rules when inserting or updating data in the TEAM table.

---- 1) Create a team with operations > 0 (Should throw an error)  
----   Error: A team must start with 0 noOperations. No team can be created with operations already greater than 0.
INSERT INTO TEAM (code, name, noOperations, score, members, centerRef) 
VALUES (
    151,
    'Bad Path',
    5,
    0,
    MEMBERS_TY(MEMBER_TY('Mario','Rossi','CFMRRS')),
    (SELECT REF(OS) FROM OPERATIONAL_CENTER OS WHERE OS.CODE = 1)
);

---- 2) Update a team adding operations more than once (Should throw an error)
----   Error: A team's operations must be greater than 0 and can only be incremented by 1 at a time.
UPDATE TEAM 
SET noOperations = noOperations + 5 
WHERE CODE = 1;

---- 3) Update a team's score with an invalid value (Should throw an error)
----   Error: Score must be between 0 and 100. Any value outside this range is invalid.
UPDATE TEAM 
SET score = 101 
WHERE CODE = 1;

---- 4) Create a team without operations and score (Should automatically set values to 0)
INSERT INTO TEAM (code, name, members, centerRef) 
VALUES (
    151,
    'Team Test',
    MEMBERS_TY(MEMBER_TY('Mario','Rossi','CFMRRS')),
    (SELECT REF(OS) FROM OPERATIONAL_CENTER OS WHERE OS.CODE = 1)
);
-- Verify that noOperations and score are set to 0 by default.
SELECT * FROM TEAM WHERE CODE = 151; 

-- SYNC_TEAM_OPS Trigger: 
-- This trigger ensures that the team's operations count (noOperations) is updated 
-- when associated with orders in the OPERATION_ORDER table.

---- 1) Create an order associated with a team (Should increment noOperations by 1)
INSERT INTO OPERATION_ORDER (code, type, creation_date, cost, placementBy, teamRef, accountRef, delivery) 
VALUES (
    36001,
    'REGULAR',
    TO_DATE('31-01-2025', 'DD-MM-YYYY'),
    15.99,
    'PHONE',
    (SELECT REF(T) FROM TEAM T WHERE T.CODE = 151),
    (SELECT REF(AC) FROM ACCOUNT AC WHERE DEREF(CUSTOMERREF).code = 1 FETCH FIRST 1 ROW ONLY),
    DELIVERY_TY (NULL, INTERVAL '40' HOUR)
);
-- Verify noOperations is incremented by 1
SELECT * FROM TEAM WHERE CODE = 151; 

---- 2) Remove association of an order from the team (Should decrement noOperations by 1)
UPDATE OPERATION_ORDER 
SET teamRef = NULL 
WHERE CODE = 36001;
-- Verify noOperations is decremented by 1
SELECT * FROM TEAM WHERE CODE = 151;

---- 3) Re-associate an order to the team (Should increment noOperations by 1)
UPDATE OPERATION_ORDER 
SET teamRef = (SELECT REF(T) FROM TEAM T WHERE T.CODE = 151) 
WHERE CODE = 1;
-- Verify noOperations is incremented by 1 again
SELECT * FROM TEAM WHERE CODE = 151;

