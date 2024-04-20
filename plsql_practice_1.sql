-- Describe: PL/SQL practices

-- 2.1 Using Scalar variable

SET SERVEROUTPUT ON
--Display to output to the server
DECLARE
   lv_test_date DATE := '10-Dec-2012';
   lv_test_num CONSTANT NUMBER(3) := 10;
   lv_test_txt VARCHAR2(10) := 'Nguyen';
BEGIN
   DBMS_OUTPUT.PUT_LINE(lv_test_date);
   DBMS_OUTPUT.PUT_LINE(lv_test_num);
   DBMS_OUTPUT.PUT_LINE(lv_test_txt);
END;

--2.2. Flowchart
--2.3. Using IF STATEMENT to check whether the customer purchases. 
-- If customer purchase > 200 -> status: high
-- 200 > customer purchase > 100 -> status: mid
-- customer purchase < 100 -> status: low 
DECLARE 
    customer_purchase NUMBER(30) := &get_num;
    cust_status VARCHAR2(20);
BEGIN 
    IF customer_purchase > 200 THEN 
        cust_status := 'HIGH';
        DBMS_OUTPUT.PUT_LINE(cust_status);
    ELSIF customer_purchase > 100 AND customer_purchase < 200 THEN 
        cust_status := 'MID';
        DBMS_OUTPUT.PUT_LINE(cust_status);
    ELSIF customer_purchase < 100 THEN 
        cust_status := 'LOW';
        DBMS_OUTPUT.PUT_LINE(cust_status);
    END IF;
END;   



--2.4. Using CASE STATEMENT
DECLARE 
    customer_purchase NUMBER(30) := &get_num;
    cust_status VARCHAR2(20);
BEGIN
    CASE
    WHEN customer_purchase > 200 THEN 
        cust_status := 'HIGH';
        DBMS_OUTPUT.PUT_LINE('Status: '||cust_status);
    WHEN customer_purchase > 100 AND customer_purchase < 200 THEN 
        cust_status := 'MID';
        DBMS_OUTPUT.PUT_LINE('Status: ' ||cust_status);
    WHEN customer_purchase < 100 THEN 
        cust_status := 'LOW';
        DBMS_OUTPUT.PUT_LINE('Status: ' ||cust_status);
    END CASE;
END;   


--2.5. Using a boolean variable
-- if the amount due - account balance = 0 -> NO payment due -> TRUE
-- else -> payment due -> FALSE
DECLARE 
    amount_due BINARY_FLOAT := &get_amount; 
    account_bal BINARY_FLOAT := &get_account_bal; 
    checking BOOLEAN;
BEGIN 
    IF (amount_due - account_bal) = 0 THEN
        checking := TRUE;
        DBMS_OUTPUT.PUT_LINE('TRUE');
    ELSE
        checking := FALSE;
        DBMS_OUTPUT.PUT_LINE('FALSE');
    END IF; 
    
END;
/