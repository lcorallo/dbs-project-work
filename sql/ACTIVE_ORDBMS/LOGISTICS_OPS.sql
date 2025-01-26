-- Op1: Register a new Customer
INSERT INTO CUSTOMER (code, NAME, SURNAME, EMAIL, TYPE) VALUES
(1000, 'Luca', 'Corallo', 'l.corallo@uniba.it', 'Individual');


-- Ops2: Add a new order
INSERT INTO OPERATION_ORDER (code, type, creation_date, cost, placementBy, accountRef, teamRef, delivery) VALUES (
    40000,
    'REGULAR',
    TO_DATE('31-01-2025', 'DD-MM-YYYY'),
    9.99,
    'PHONE',
    (SELECT REF(ACS) FROM ACCOUNT ACS WHERE ACS.CODE = 1642600),
    NULL,
    DELIVERY_TY ('great order', INTERVAL '40' HOUR)
);


-- Ops3: Assign an order to a management team
UPDATE OPERATION_ORDER
SET teamRef = (SELECT REF(T) FROM TEAM T WHERE T.CODE = 1)
WHERE OPERATION_ORDER.code = 40000


-- Op4: View the total number of operations handled by a specific team (Suppose ID 1): Query using Hash-Based Access
-- The query below checks noOperations based on the team code. The system will likely use a hash-based index 
-- due to the point access pattern (looking up a single team by code).
SELECT noOperations
FROM TEAM T
WHERE T.code = 1;


-- Op4 Explanation:
-- Note: The query is using a hash table, as expected, due to the point access pattern based on the team code.
EXPLAIN PLAN FOR
    SELECT noOperations
    FROM TEAM T
    WHERE T.code = 1;
/
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());


-- Op5: Print a list of teams sorted by their performance score. Query using B+ Tree Index
-- The query below retrieves the team name and score, ordered by score. Since this query involves sorting, 
-- a B+ tree index could be used for efficiency, especially if there are more records.
SELECT code, name, score
FROM TEAM T
ORDER BY score DESC

-- Op5 Explanation:
-- Note: The query is not using a B+ tree index, likely due to the relatively small number of records (150), 
-- making the need for such an index less relevant.
EXPLAIN PLAN FOR
    SELECT code, name, score
    FROM TEAM T
    ORDER BY score DESC;
/
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY());