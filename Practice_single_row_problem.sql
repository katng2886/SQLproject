--Ngoc (Katie) Nguyen
--1. Write an SQL query to display a text string 'your_first_name your_last_name' that represents your full name using the DUAL table.
SELECT
    'ngoc_nguyen'
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--2. Modify the query you created in problem 1. This time, use the INITCAP function to convert characters in the text string 'your_first_name your_last_name' to mixed case.
SELECT
    INITCAP('ngoc_nguyen')
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--3. Modify the query you created in problem 1. This time, use the INSTR function to determine the position of the single blank space in the text string 'your_first_name your_last_name'.
SELECT
    'ngoc_nguyen',
    INSTR('ngoc_nguyen', '_') "Position after underscore"
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--4. Modify the query you created in problem 1. This time, use the SUBSTR function to extract a substring that represents your last name from the text string 'your_first_name your_last_name'. Assume you know the number of characters you need to extract.
SELECT
    'ngoc_nguyen',
    SUBSTR('ngoc_nguyen', 6, 6)
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--5.Modify the query you created in problem 1. This time, use the INSTR and SUBSTR functions to extract a substring that represents your first name from the text string 'your_first_name your_last_name'. Assume you do not know the number of characters to extract.
SELECT
    'ngoc_nguyen',
    SUBSTR('ngoc_nguyen', 1, INSTR('ngoc_nguyen', '_') - 1) AS "First Name"
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--6.Modify the query you created in problem 1. This time, use the INSTR, SUBSTR, and LENGTH functions to extract a substring that represents your last name from the text string 'your_first_name your_last_name'. Assume you do not know the number of characters you need to extract.
SELECT
    'ngoc_nguyen',
    SUBSTR('ngoc_nguyen', 6, INSTR('ngoc_nguyen', '_') + 1)         AS "Last Name",
    LENGTH(SUBSTR('ngoc_nguyen', 6, INSTR('ngoc_nguyen', '_') + 1)) AS "Lenght"
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--7.Write an SQL query to join three character strings: your first name, blank space, and your last name. Use a nested CONCAT function and the DUAL table.
SELECT
    CONCAT(CONCAT('ngoc', ' '), 'nguyen')
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--8.Write an SQL query to retrieve the current date using the SYSDATE function and the DUAL table.
SELECT
    SYSDATE
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--9.Write an SQL query to calculate the number of months until Christmas. Use the MONTHS_BETWEEN function and the DUAL table. Then, round off the answer to an integer. Decide which function - ROUND or TRANC - to be used for rounding off. Explain your reasoning.
SELECT
    ROUND(MONTHS_BETWEEN(DATE '2024-10-11', SYSDATE))
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--9.Write an SQL query to calculate the number of months until Christmas. Use the MONTHS_BETWEEN function and the DUAL table. Then, round off the answer to an integer. Decide which function - ROUND or TRANC - to be used for rounding off. Explain your reasoning.
SELECT
    TRUNC(MONTHS_BETWEEN(DATE '2024-10-11', SYSDATE))
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--9.Write an SQL query to calculate the number of months until Christmas. Use the MONTHS_BETWEEN function and the DUAL table. Then, round off the answer to an integer. Decide which function - ROUND or TRANC - to be used for rounding off. Explain your reasoning.
SELECT
    (MONTHS_BETWEEN(DATE '2024-10-11', SYSDATE))
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--10. Write an SQL query to display a text string 'JANUARY 21, 2013' as a date using the TO_DATE function and the DUAL table. (Hint: correct format model to use for this string is 'MONTH DD, YYYY').
SELECT
    TO_DATE ('JANUARY 21, 2013', 'MONTH DD, YYYY')
FROM
    DUAL;

--Ngoc (Katie) Nguyen
--11.	Write an SQL query to display a date '21-JAN-13' as a text string using the TO_CHAR function and the DUAL table. You may use any format model that is different from the default Oracle date format
SELECT
    TO_CHAR(TO_DATE('JAN-21-2013', 'MM-DD-YYYY'), 'MONTH DD, YYYY')
FROM
    DUAL;