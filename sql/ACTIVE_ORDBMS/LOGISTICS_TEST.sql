-- Trigger

-- CHECK_TEAM

---- 1) Create a team with operations > 0 -> Should throw error: 
----   A team must start with 0 noOperations
INSERT INTO TEAM (code, name, noOperations, score, members, centerRef) VALUES (
    151,
    'Bad Path',
    5,
    0,
    MEMBERS_TY(MEMBER_TY('Mario','Rossi','CFMRRS')),
    (SELECT REF(OS) FROM OPERATIONAL_CENTER OS WHERE OS.CODE = 1)
);

---- 2) Update a team adding operations more than once -> Should
----   throw error: A team operations must be greater than 0 and can be
----   incremented only by one each time.
UPDATE TEAM SET noOperations = noOperations + 5 WHERE CODE = 1;


---- 3) Update a team setting new score values -> Should
----   throw error: score must be between 0 and 100
UPDATE TEAM SET score = 101 WHERE CODE = 1;

---- 4) Create a team without operations and score. Should be set to 0
INSERT INTO TEAM (code, name, members, centerRef) VALUES (
    151,
    'Team Test',
    MEMBERS_TY(MEMBER_TY('Mario','Rossi','CFMRRS')),
    (SELECT REF(OS) FROM OPERATIONAL_CENTER OS WHERE OS.CODE = 1)
);
/
SELECT * FROM TEAM WHERE CODE = 151; -- Check noOperations = 0 and score = 0


-- SYNC_TEAM_OPS


---- 1) Create an order associated to a Team. Must be
----   incremented noOperations
INSERT INTO OPERATION_ORDER (code, type, creation_date, cost, placementBy, teamRef, accountRef, delivery) VALUES (
    36001,
    'REGULAR',
    TO_DATE('31-01-2025', 'DD-MM-YYYY'),
    15.99,
    'PHONE',
    (SELECT REF(T) FROM TEAM T WHERE T.CODE = 151),
    (SELECT REF(AC) FROM ACCOUNT AC WHERE DEREF(CUSTOMERREF).code = 1 FETCH FIRST 1 ROW ONLY),
    DELIVERY_TY (NULL, INTERVAL '40' HOUR)
);
/
SELECT * FROM TEAM WHERE CODE = 151; -- Check noOperations = 1


---- 1) Remove association of order created. Must be
----   decremented noOperations
UPDATE OPERATION_ORDER SET teamRef = NULL WHERE CODE = 36001;
/
SELECT * FROM TEAM WHERE CODE = 151; -- Check noOperations = 0;


---- 2) Associate an order to the Team. Must be
----    incremented noOperations
UPDATE OPERATION_ORDER SET teamRef = (SELECT REF(T) FROM TEAM T WHERE T.CODE = 151) WHERE CODE = 1;
/
SELECT * FROM TEAM WHERE CODE = 151; -- Check noOperations = 1;


-- Index Testing

-- OPS4: Using Hash Based
EXPLAIN PLAN FOR
SELECT NOOPERATIONS FROM TEAM WHERE CODE = 123;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- OPS5: Usin B+Tree
EXPLAIN PLAN FOR
SELECT NAME, SCORE FROM TEAM ORDER BY SCORE DESC;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);