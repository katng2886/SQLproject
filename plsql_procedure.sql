--Ngoc (Katie) Nguyen
/*Create a procedure name: STATUS_SHIP_SP -> allows an emp in the Shipping department to update an order status to add shipping info. 
The BB_BASKETSTATUS table lists events for each order so that a shopper can see the current status, date and comments as each stage of the order process is finished. 
The IDSTAGE column of the BB_BASKETSTATUS table identifies each stage, the value 3 in this column indicates that an order has been shipped.
The procedure should allow adding a row with an IDSTAGE of 3, date shipped, tracking number and shipper. 
The BB_STATUS_SEQ sequence is used to provid a value for the PK column. */


CREATE OR REPLACE PROCEDURE STATUS_SHIP_SP (
    BASKET_ID IN BB_BASKETSTATUS.IDSTATUS%TYPE,
    SHIP_DATE IN BB_BASKETSTATUS.DTSTAGE%TYPE,
    SHIPPER_NAME IN BB_BASKETSTATUS.SHIPPER%TYPE,
    TRACKING_INFO IN BB_BASKETSTATUS.SHIPPINGNUM%TYPE
) IS
    STATUS_ID NUMBER;
    STAGE_ID  NUMBER := 3;
BEGIN
    SELECT
        BB_STATUS_SEQ.NEXTVAL INTO STATUS_ID
    FROM
        DUAL;
    INSERT INTO BB_BASKETSTATUS (
        IDSTATUS,
        IDBASKET,
        DTSTAGE,
        SHIPPER,
        SHIPPINGNUM
    ) VALUES (
        STATUS_ID,
        BASKET_ID,
        SHIP_DATE,
        SHIPPER_NAME,
        TRACKING_INFO
    );
    DBMS_OUTPUT.PUT_LINE('Order status updated successfully');
END STATUS_SHIP_SP;
/

EXECUTE STATUS_SHIP_SP(3, '10-Feb-12', 'UPS', 'ZW2384YXK4957');
DROP PROCEDURE STATUS_SHIP_SP;

SELECT
    *
FROM
    BB_BASKETSTATUS;
 --Ngoc (Katie) Nguyen
 --5.6

 /*
Create the procedure that returns most recent order status information for a specified basket. 
This proceure should determine the most recent ordering-stage entry in the BB_BASKETSTATUS table and return the data. 
Use an IF or CASE clause to return a stage description instead of an IDSTAGE NUMBER, which means little to shoppers
- IF 1 -> Submitted and received
2-> Confirmed, proccessed, sent to shipping
3 -> Shipped
4 -> cancelled
5 -> Back-ordered
*/
SELECT
    MIN(DTSTAGE)
FROM
    BB_BASKETSTATUS;
SELECT
    MAX(DTSTAGE)
FROM
    BB_BASKETSTATUS;
 -- Ngoc(Katie) Nguyen
DROP PROCEDURE STATUS_SP;

CREATE OR REPLACE PROCEDURE STATUS_SP 
( BASKET_ID IN NUMBER, STATUS OUT VARCHAR2, DAY_STAGE OUT DATE ) IS
    STAGE NUMBER;
    CURSOR C_STAGE IS
    SELECT
        IDSTAGE,
        DTSTAGE INTO STAGE,
        DAY_STAGE
    FROM
        BB_BASKETSTATUS
    WHERE
        IDBASKET = BASKET_ID
    ORDER BY
        DAY_STAGE DESC FETCH FIRST ROW ONLY;
BEGIN
    OPEN C_STAGE;
    FETCH C_STAGE INTO STAGE, DAY_STAGE;
    CLOSE C_STAGE;

    IF STAGE = 1 THEN
            STATUS := 'Submitted and received';
    ELSIF STAGE = 2 THEN
            STATUS := 'Confirmed, processed, sent to shipping';
    ELSIF STAGE = 3 THEN
            STATUS := 'Shipped';
    ELSIF STAGE = 4 THEN
            STATUS := 'Cancelled';
    ELSIF STAGE = 5 THEN
            STATUS := 'Back-ordered';
    ELSE
        RAISE NO_DATA_FOUND;
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No record!!!');
END STATUS_SP;
/
DECLARE
    V_STATUS VARCHAR2(100);
    V_DATE   DATE;
BEGIN
    STATUS_SP (4, V_STATUS, V_DATE);
    DBMS_OUTPUT.PUT_LINE('Status: '
                         || V_STATUS);
    DBMS_OUTPUT.PUT_LINE('Date: '
                         || TO_CHAR(V_DATE, 'YYYY-MM-DD'));
END;



DECLARE
    V_STATUS VARCHAR2(100);
    V_DATE   DATE;
BEGIN
    STATUS_SP (6, V_STATUS, V_DATE);
    DBMS_OUTPUT.PUT_LINE('Status: '
                         || V_STATUS);
    DBMS_OUTPUT.PUT_LINE('Date: '
                         || TO_CHAR(V_DATE, 'YYYY-MM-DD'));
END;


 -- Ngoc (Katie) Nguyen
 --5.7:

 /*
- Create a procedure named: PROMO_SHIP that determines who these customers are and then updates the BB_PROMOLIST table: 
- Date cutoff: Any customers who havent shopped on the site since this day shoule be included as incentive participants. 
Use the basket creation date to reflect shopper activity dates. 
- Month: (APR) should be added to the promotion table to indicate which months free shipping is effective. 
- Year: 4 digits year indicate the year the promotion is effective.
- promo-flag - 1: represents free shipping. 
*/

 CREATE OR REPLACE PROCEDURE PROMO_SHIP (CUTOFF_DATE IN BB_BASKET.DTCREATED%TYPE) AS
    CUTOFF_MONTH    BB_PROMOLIST.MONTH%TYPE;
    CUTOFF_YEAR     BB_PROMOLIST.YEAR%TYPE;
    SHOPPER_ID_MIN  BB_BASKET.IDSHOPPER%TYPE;
    SHOPPER_ID_MAX  BB_BASKET.IDSHOPPER%TYPE;
    BASKET_DATE     BB_BASKET.DTCREATED%TYPE;
    ID_SHOPPER      BB_BASKET.IDSHOPPER%TYPE;
    SHOPPER_ID_FLAG NUMBER;
BEGIN
    SELECT
        MIN(IDSHOPPER),
        MAX(IDSHOPPER) INTO SHOPPER_ID_MIN,
        SHOPPER_ID_MAX
    FROM
        BB_BASKET;
    FOR I IN SHOPPER_ID_MIN..SHOPPER_ID_MAX LOOP
        SELECT
            MAX(DTCREATED) INTO BASKET_DATE
        FROM
            BB_BASKET
        WHERE
            IDSHOPPER = I;
        IF CUTOFF_DATE >= BASKET_DATE THEN
            SELECT
                COUNT(IDSHOPPER) INTO SHOPPER_ID_FLAG
            FROM
                BB_PROMOLIST
            WHERE
                I = IDSHOPPER;
            IF SHOPPER_ID_FLAG = 1 THEN
                CONTINUE;
            ELSE
                INSERT INTO BB_PROMOLIST (
                    IDSHOPPER,
                    MONTH,
                    YEAR,
                    PROMO_FLAG,
                    USED
                ) VALUES (
                    I,
                    CUTOFF_MONTH,
                    CUTOFF_YEAR,
                    1,
                    'N'
                );
            END IF;
        END IF;
    END LOOP;

    COMMIT;
END;
/

DROP PROCEDURE PROMO_SHIP;

EXECUTE PROMO_SHIP('15-Feb-12')

SELECT
    *
FROM
    BB_PROMOLIST;

--Ngoc (Katie) Nguyen


CREATE SEQUENCE BB_BASKETITEM_SEQ;

CREATE OR REPLACE PROCEDURE BASKET_ADD_SP (
    BASKET_ID IN BB_BASKETITEM.IDBASKET%TYPE,
    PRODUCT_ID IN BB_BASKETITEM.IDPRODUCT%TYPE,
    PRODUCT_PRICE IN BB_BASKETITEM.PRICE%TYPE,
    P_QUANTITY IN BB_BASKETITEM.QUANTITY%TYPE,
    SIZE_CODE IN NUMBER,
    FORM_CODE IN NUMBER
) AS
    ID_BASKET_ITEM NUMBER;
BEGIN
    SELECT BB_BASKETITEM_SEQ.NEXTVAL INTO ID_BASKET_ITEM FROM DUAL;
    
    INSERT INTO BB_BASKETITEM (
        IDBASKETITEM,
        IDBASKET,
        IDPRODUCT,
        PRICE,
        QUANTITY,
        OPTION1,
        OPTION2
    ) VALUES (
        ID_BASKET_ITEM,
        BASKET_ID,
        PRODUCT_ID,
        PRODUCT_PRICE,
        P_QUANTITY,
        SIZE_CODE,
        FORM_CODE
    );
    
    DBMS_OUTPUT.PUT_LINE('UPDATE COMPLETED!');
END;
/


EXECUTE BASKET_ADD_SP (14, 8, 10.80, 1, 2, 4)

--Ngoc (Katie) Nguyen
--5.9: 

DROP PROCEDURE MEMBER_CK_SP
CREATE OR REPLACE PROCEDURE MEMBER_CK_SP (
    member_ID IN VARCHAR2,
    member_pw IN VARCHAR2
) AS
    member_fname VARCHAR2(100);
    member_lname VARCHAR2(100); 
    cookie_value NUMBER;
BEGIN
    SELECT FIRSTNAME, LASTNAME, cookie
    INTO member_fname, member_lname, cookie_value
    FROM BB_SHOPPER
    WHERE USERNAME = member_ID AND PASSWORD = member_pw;
    DBMS_OUTPUT.PUT_LINE('Member: ' || member_fname || ' ' || member_lname || ', Cookie: ' || cookie_value);
    DBMS_OUTPUT.PUT_LINE('VALID');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('INVALID');
END;
/
EXECUTE MEMBER_CK_SP ('rat55', 'kile');
EXECUTE MEMBER_CK_SP ('rat', 'kile');