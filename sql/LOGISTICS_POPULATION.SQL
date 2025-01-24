CREATE OR REPLACE FUNCTION generate_random_name
RETURN VARCHAR2
IS
    -- Define a nested table type for names
    TYPE NAMES_TY IS TABLE OF VARCHAR2(30);

    -- Initialize a nested table of names
    name NAMES_TY := NAMES_TY(
        'Luca', 'Paolo', 'Marco', 'Giovanni', 'Francesco', 'Antonio', 
        'Stefano', 'Matteo', 'Alessandro', 'Roberto', 'Giulio', 'Leonardo', 
        'Tommaso', 'Enrico', 'Daniele',  -- 15 Male Names
        'Maria', 'Giulia', 'Anna', 'Sofia', 'Chiara', 'Martina', 
        'Francesca', 'Alessandra', 'Valentina', 'Laura', 'Elena', 'Irene', 
        'Paola', 'Simona', 'Caterina'   -- 15 Female Names
    );
BEGIN
    -- Generate a random index and pick a name
    RETURN name(TRUNC(DBMS_RANDOM.VALUE(1, name.COUNT + 1)));
END generate_random_name;
/

CREATE OR REPLACE FUNCTION generate_random_surname
RETURN VARCHAR2
IS
    -- Define a nested table type for surnames
    TYPE SURNAMES_TY IS TABLE OF VARCHAR2(30);

    -- Initialize a nested table with 15 male and 15 female surnames
    surname SURNAMES_TY := SURNAMES_TY(
        'Rossi', 'Bianchi', 'Lombardi', 'Giordano', 'Ricci', 'Mariani', 
        'Barbieri', 'Ferrari', 'Costa', 'Galli', 'Moretti', 'Fontana', 
        'Sartori', 'Migliorini', 'De Luca',  -- 15 Male Surnames
        'Conti', 'Giovanni', 'Coppola', 'DAmico', 'Sanna', 'Puglisi', 
        'Martini', 'Esposito', 'Vitali', 'Greco', 'Giorgi', 'Luciani', 
        'Rinaldi', 'Ruggiero', 'Basilio'   -- 15 Female Surnames
    );
BEGIN
    RETURN surname(TRUNC(DBMS_RANDOM.VALUE(1, surname.COUNT + 1)));
END generate_random_surname;
/
CREATE OR REPLACE FUNCTION generate_random_email (
    name IN VARCHAR2,
    surname IN VARCHAR2
)
RETURN VARCHAR2
IS
    TYPE PROVIDER_TY IS TABLE OF VARCHAR2(20);
    providers PROVIDER_TY := PROVIDER_TY('gmail.com', 'live.it', 'outlook.com', 'libero.it', 'hotmail.com');
    generated_provider VARCHAR(20);
BEGIN

    generated_provider := providers(TRUNC(DBMS_RANDOM.VALUE(1, providers.COUNT + 1)));

    RETURN LOWER(name || '.' || surname || TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 1000))) || '@' || generated_provider);

END generate_random_email;
/


INSERT INTO COMPANY (name, services) 
VALUES (
    'Brightway', 
    SERVICES_TY(
        SERVICE_TY(1, 'Fast Shipping', 'Fast shipping to get priority'),
        SERVICE_TY(2, 'Express Delivery', 'Delivery within 24 hours'),
        SERVICE_TY(3, 'Standard Shipping', 'Affordable standard delivery'),
        SERVICE_TY(4, 'Overnight Shipping', 'Shipping overnight for urgent items'),
        SERVICE_TY(5, 'Same-Day Shipping', 'Delivery on the same day'),
        SERVICE_TY(6, 'International Shipping', 'Global logistics services'),
        SERVICE_TY(7, 'Freight Services', 'Bulk shipping for heavy loads'),
        SERVICE_TY(8, 'E-Commerce Shipping', 'Specialized shipping for online stores'),
        SERVICE_TY(9, 'Warehouse Storage', 'Temporary storage solutions'),
        SERVICE_TY(10, 'Cold Chain Logistics', 'Shipping for temperature-sensitive goods')
    )
);
-- SELECT c.NAME, s.CODE, s.NAME, s.DESCRIPTION
-- FROM COMPANY c, TABLE(c.services) s;

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (1, 'AAA000', Address_TY('Via Roma, 51', 'Bari', 'BA', '70124'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (2, 'BBB001', Address_TY('Corso Vittorio Emanuele, 12', 'BA', 'BA', '70100'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (3, 'CCC002', Address_TY('Via Dante, 44', 'Milano', 'MI', '20121'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (4, 'DDD003', Address_TY('Piazza del Popolo, 5', 'Roma', 'RM', '00187'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (5, 'EEE004', Address_TY('Via Garibaldi, 22', 'Firenze', 'FI', '50129'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (6, 'FFF005', Address_TY('Corso Mazzini, 89', 'Bari', 'BA', '70127'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (7, 'GGG006', Address_TY('Via Mazzini, 15', 'Verona', 'VR', '37121'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (8, 'HHH007', Address_TY('Piazza San Marco, 3', 'Venezia', 'VE', '30124'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (9, 'III008', Address_TY('Via Etnea, 110', 'Catania', 'CT', '95131'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (10, 'JJJ009', Address_TY('Via Manzoni, 50', 'Torino', 'TO', '10121'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (11, 'KKK010', Address_TY('Via Indipendenza, 30', 'Bologna', 'BO', '40121'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (12, 'LLL011', Address_TY('Via Libertà, 70', 'Palermo', 'PA', '90143'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (13, 'MMM012', Address_TY('Via Cavour, 18', 'Milano', 'MI', '20057'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (14, 'NNN013', Address_TY('Via Emilia, 25', 'Milano', 'MI', '20091'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));

INSERT INTO OPERATIONAL_CENTER (code, name, address, companyRef) 
VALUES (15, 'OOO014', Address_TY('Via Vittorio Veneto, 7', 'Brescia', 'BS', '25121'), (SELECT REF(c) FROM company c WHERE c.name = 'Brightway'));


BEGIN
    FOR i IN 1..150 LOOP
        INSERT INTO TEAM (code, name, noOperations, score, centerRef, members) VALUES (
            i,
            UPPER('AA-' || DBMS_RANDOM.STRING('A', 5) || '-000'),
            0,
            TRUNC(DBMS_RANDOM.VALUE(1, 100)),
            (SELECT REF(c) FROM OPERATIONAL_CENTER c WHERE c.code = (MOD(i, 15) + 1)),
            MEMBERS_TY (
                MEMBER_TY(generate_random_name(), generate_random_surname(), UPPER(DBMS_RANDOM.STRING('A', 16))),
                MEMBER_TY(generate_random_name(), generate_random_surname(), UPPER(DBMS_RANDOM.STRING('A', 16))),
                MEMBER_TY(generate_random_name(), generate_random_surname(), UPPER(DBMS_RANDOM.STRING('A', 16))),
                MEMBER_TY(generate_random_name(), generate_random_surname(), UPPER(DBMS_RANDOM.STRING('A', 16))),
                MEMBER_TY(generate_random_name(), generate_random_surname(), UPPER(DBMS_RANDOM.STRING('A', 16)))
            )
        );
    END LOOP;
END;
/


DECLARE
    v_name VARCHAR2(20);
    v_surname VARCHAR2(20);
    v_email VARCHAR2(50);
BEGIN
    FOR i IN 1..400 LOOP
        v_name := generate_random_name();
        v_surname := generate_random_surname();
        v_email := generate_random_email(v_name, v_surname);
       

        INSERT INTO CUSTOMER (code, name, surname, email, type) VALUES (
            i, v_name, v_surname, v_email, 'Individual'
        );

        INSERT INTO ACCOUNT (code, customerRef) VALUES (
            TO_NUMBER(TO_CHAR(i) || RPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 1000))), 4, '0')),
            (SELECT REF(C) FROM CUSTOMER C WHERE code = i)
        );
        INSERT INTO ACCOUNT (code, customerRef) VALUES (
            TO_NUMBER(TO_CHAR(i) || RPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 1000))), 4, '0')),
            (SELECT REF(C) FROM CUSTOMER C WHERE code = i)
        );

    END LOOP;

    FOR i IN 401..500 LOOP
        v_name := generate_random_name();
        v_surname := generate_random_surname();
        v_email := generate_random_email(v_name, v_surname);

        INSERT INTO CUSTOMER (code, name, surname, email, type) VALUES (
            i, v_name, v_surname, v_email, 'Business'
        );

        
        INSERT INTO ACCOUNT (code, customerRef) VALUES (
            TO_NUMBER(TO_CHAR(i) || RPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 1000))), 4, '0')),
            (SELECT REF(C) FROM CUSTOMER C WHERE code = i)
        );
        INSERT INTO ACCOUNT (code, customerRef) VALUES (
            TO_NUMBER(TO_CHAR(i) || RPAD(TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(1, 1000))), 4, '0')),
            (SELECT REF(C) FROM CUSTOMER C WHERE code = i)
        );

    END LOOP;
END;
/


CREATE OR REPLACE FUNCTION generate_random_order (
    code IN INTEGER,
    random_team_ref IN REF TEAM_TY,
    delivery_options IN DELIVERY_TY
)
RETURN ORDER_TY
IS
    TYPE ORDERS_OPTIONS_TY IS TABLE OF VARCHAR2(10);
    TYPE ORDERS_PLACEMENT_TY IS TABLE OF VARCHAR2(10);

    ordersOptions ORDERS_OPTIONS_TY := ORDERS_OPTIONS_TY('BULK', 'REGULAR', 'URGENT');
    ordersPlacement ORDERS_PLACEMENT_TY := ORDERS_PLACEMENT_TY('PHONE', 'EMAIL', 'PLATFORM');

    random_account_ref REF ACCOUNT_TY;
    random_delivery_time INTERVAL DAY TO SECOND;
BEGIN
    SELECT REF(A) INTO random_account_ref FROM ACCOUNT A ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY;

    RETURN ORDER_TY(
        code, 
        ordersOptions(TRUNC(DBMS_RANDOM.VALUE(1, ordersOptions.COUNT + 1))),
        TO_DATE(SYSDATE, 'YYYY-MM-DD') + (DBMS_RANDOM.VALUE(-3650, 0)),
        ROUND(DBMS_RANDOM.VALUE(10, 500), 2),
        ordersPlacement(TRUNC(DBMS_RANDOM.VALUE(1, ordersPlacement.COUNT + 1))),
        random_team_ref,
        random_account_ref,
        delivery_options
    );
END generate_random_order;
/


DECLARE
    TYPE FEEDBACK_TY IS TABLE OF VARCHAR2(200);
    random_team_ref REF TEAM_TY;
    random_delivery_time INTERVAL DAY TO SECOND;

    feedback FEEDBACK_TY := FEEDBACK_TY(
        'The website could be more user-friendly.',
        'Good product, but delivery was late.',
        'Dissatisfied',
        'I had a poor experience with the customer service.',
        'Excellent',
        'Best customer support I have ever received!',
        'Positive',
        'Great service, will come again!',
        'Negative',
        'The food was cold and took too long to arrive.',
        'The experience was okay, nothing special.'
    );
    
BEGIN
    FOR i IN 1..35400 LOOP
        SELECT REF(T) INTO random_team_ref FROM TEAM T ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY;
        SELECT INTERVAL '1' HOUR * ROUND(DBMS_RANDOM.VALUE(0, 240)) AS random_hour_interval INTO random_delivery_time FROM dual;

        -- Generate random feedback index and select feedback message
        DECLARE
            random_feedback_index NUMBER := TRUNC(DBMS_RANDOM.VALUE(1, feedback.COUNT + 1));
        BEGIN
            -- Insert operation order with randomly generated values
            INSERT INTO OPERATION_ORDER 
            VALUES (
                generate_random_order(
                    i, 
                    random_team_ref, 
                    DELIVERY_TY (
                        feedback(random_feedback_index), -- Correctly access feedback
                        random_delivery_time
                    )
                )
            );
        END;
    END LOOP;

    FOR i IN 35401..36000 LOOP
        SELECT REF(T) INTO random_team_ref FROM TEAM T ORDER BY DBMS_RANDOM.VALUE FETCH FIRST 1 ROWS ONLY;
        INSERT INTO OPERATION_ORDER VALUES (generate_random_order(i, random_team_ref, NULL));
    END LOOP;
END;
