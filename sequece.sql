
--Ngoc (Katie) Nguyen
--1. Create a sequence for populatin the CUSTOMER# column of the CUSTOMERS table
CREATE SEQUENCE CUSTOMERS_CUSTOMER#_SEQ NOCYCLE;

--Ngoc (Katie) Nguyen
--2. Insert customer value using sequence
INSERT INTO CUSTOMERS (
  CUSTOMER#,
  LASTNAME,
  FIRSTNAME,
  ZIP
) VALUES (
  CUSTOMERS_CUSTOMER#_SEQ.NEXTVAL,
  'SHOULDERS',
  'FRANK',
  '23567'
)

--Ngoc (Katie) Nguyen
--3. Create MY_FIRST_SEQ
DROP SEQUENCE my_first_seq;
CREATE SEQUENCE my_first_seq
INCREMENT BY -3 
START WITH 5
MINVALUE 0 
MAXVALUE 100
NOCYCLE;

--Ngoc (Katie) Nguyen
--4. Issue a SELECT statement that displays NEXTVAL for MY_FIRST_SEQ 3 times. 
SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL; -- 1st SELECT
SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL; -- 2nd SELECT
SELECT MY_FIRST_SEQ.NEXTVAL FROM DUAL; -- 3rd SELECT


--Ngoc (Katie) Nguyen
--5. Change the setting of MY_FIRST_SEQ so that the minimum value that can be generated is -1000
ALTER SEQUENCE my_first_seq
MINVALUE -1000;


--Ngoc (Katie) Nguyen
--9. Create bitmap on customers to speed up the queries that search for customers based on their state of residence. Verify that the index exits and then delete the index. 
CREATE BITMAP INDEX customers_state_idx ON CUSTOMERS (state);

SELECT table_name, index_name, index_type from user_indexes where table_name = 'CUSTOMERS';

DROP INDEX customers_state_idx;