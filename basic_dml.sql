--Basic DML.
-- NGOC (Katie) NGUYEN


-- CREATE TABLE
CREATE TABLE NGOC_NGUYEN (
    ID NUMBER(2) CONSTRAINT ID_PK PRIMARY KEY,
    FIRSTNAME VARCHAR2(20),
    LASTNAME VARCHAR(20),
    DOB DATE CONSTRAINT DOB_check CHECK (DOB < DATE '2006-01-31'), -- checking for birthday to be at least 18 years old
    CLASS_NAME CHAR(9),
    COURSE_ID NUMBER(3),
    ENROLL_DATE DATE
);

DESCRIBE ngoc_nguyen;

-- NGOC (Katie) NGUYEN
INSERT INTO NGOC_NGUYEN (
    ID,
    FIRSTNAME,
    LASTNAME,
    DOB,
    CLASS_NAME,
    COURSE_ID,
    ENROLL_DATE
) VALUES (
    1,
    'Katie',
    'Nguyen',
    '21-Jun-1999',
    'Database',
    314,
    '16-Jan-2024'
);

SELECT
    *
FROM
    NGOC_NGUYEN;

-- NGOC (Katie) NGUYEN
INSERT INTO NGOC_NGUYEN (
    ID,
    FIRSTNAME,
    LASTNAME,
    DOB
) VALUES (
    2,
    'John',
    'Doe',
    '01-Jan-2000'
);

SELECT
    *
FROM
    NGOC_NGUYEN;


-- NGOC (Katie) NGUYEN
UPDATE NGOC_NGUYEN SET FIRSTNAME = 'Ngoc' WHERE ID = 1;

SELECT * FROM NGOC_NGUYEN;


-- NGOC (Katie) NGUYEN
DELETE FROM NGOC_NGUYEN WHERE ID = 2; 

SELECT * FROM NGOC_NGUYEN;

-- NGOC (Katie) NGUYEN
COMMIT;

-- NGOC (Katie) NGUYEN
ROLLBACK; -- undo the changes 

-- NGOC (Katie) NGUYEN
DROP TABLE NGOC_NGUYEN;