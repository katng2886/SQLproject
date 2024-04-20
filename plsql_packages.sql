-- Practice: Packages:
SET SERVEROUT ON
--Ngoc (Katie) Nguyen
--7.1: 
CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_inf_pp -- fixing typo error
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2 IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;

 PROCEDURE basket_inf_pp 
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_inf_pp;
END;

DROP PACKAGE order_info_pkg;

--Ngoc (Katie) Nguyen
--7.2: 
CREATE OR REPLACE PACKAGE order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2;
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE);
END;

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;

 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;



--Create an anonymous blocks that calls both the packaged procedure and function with basket ID = 12
DECLARE 
  basket_id NUMBER := 12; 
  ship_info VARCHAR2(100); 
  basket_shop VARCHAR2(100);
  basket_date DATE;
BEGIN 
--Calling Function
  ship_info := order_info_pkg.ship_name_pf(basket_id);
  DBMS_OUTPUT.PUT_LINE('Shipping info: '|| ship_info);

--Calling procedure
  order_info_pkg.basket_info_pp(basket_id, basket_shop, basket_date);
  DBMS_OUTPUT.PUT_LINE('Shopper ID: '|| basket_Shop ||'-' ||'Order date: ' ||basket_date);
end;

--Test the packaged function using SELECT
SELECT IDBASKET, order_info_pkg.ship_name_pf(IDBASKET) FROM BB_BASKET WHERE IDBASKET = 12;


--Ngoc (Katie) Nguyen
--7.3: 
CREATE OR REPLACE PACKAGE order_info_pkg IS
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   ship_out_info OUT VARCHAR2);
END;

CREATE OR REPLACE PACKAGE BODY order_info_pkg IS
 FUNCTION ship_name_pf  
   (p_basket IN NUMBER)
   RETURN VARCHAR2
  IS
   lv_name_txt VARCHAR2(25);
 BEGIN
  SELECT shipfirstname||' '||shiplastname
   INTO lv_name_txt
   FROM bb_basket
   WHERE idBasket = p_basket;
  RETURN lv_name_txt;
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END ship_name_pf;
 
 PROCEDURE basket_info_pp
  (p_basket IN NUMBER,
   p_shop OUT NUMBER,
   p_date OUT DATE,
   ship_out_info OUT VARCHAR2)
  IS
 BEGIN
   SELECT idshopper, dtordered
    INTO p_shop, p_date
    FROM bb_basket
    WHERE idbasket = p_basket;
    ship_out_info := ship_name_pf(p_basket);
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('Invalid basket id');
 END basket_info_pp;
END;

--Test using basket ID = 4
DECLARE 
  basket_id NUMBER := 4; 
  shopper_id VARCHAR2(100);
  order_date DATE;
  ship_info VARCHAR2(100);
BEGIN 
  order_info_pkg.basket_info_pp(basket_id, shopper_id, order_date, ship_info);
  DBMS_OUTPUT.PUT_LINE('Shopper ID: ' ||shopper_id);
  DBMS_OUTPUT.PUT_LINE('Order date: '||order_date);
  DBMS_OUTPUT.PUT_LINE('Name: '||ship_info);
END;


--Ngoc (Katie) Nguyen
--7.4:

CREATE OR REPLACE PACKAGE LOGIN_PGK IS 
  FUNCTION ver_user (
    u_name IN BB_SHOPPER.USERNAME%TYPE,
    p_word IN BB_SHOPPER.PASSWORD%TYPE, 
    zipcode OUT BB_SHOPPER.ZIPCODE%TYPE, 
    id_shop OUT BB_SHOPPER.IDSHOPPER%TYPE
  )RETURN VARCHAR2;
  END;



CREATE OR REPLACE PACKAGE BODY LOGIN_PGK IS
  FUNCTION VER_USER(
  u_name IN BB_SHOPPER.USERNAME%TYPE, 
  p_word IN BB_SHOPPER.PASSWORD%TYPE,
  zipcode OUT BB_SHOPPER.ZIPCODE%TYPE, 
  id_shop OUT BB_SHOPPER.IDSHOPPER%TYPE
) RETURN VARCHAR2 IS 
  pass_word_check VARCHAR2(100);
BEGIN 
  SELECT PASSWORD INTO pass_word_check FROM BB_SHOPPER WHERE USERNAME = u_name; 
  SELECT SUBSTR(ZIPCODE, 1, 3), IDSHOPPER INTO zipcode, id_shop FROM BB_SHOPPER WHERE USERNAME = u_name;
  RETURN 'Y';
EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    RETURN 'N';
END VER_USER;
END;
/
--Createing function ----- SUCCEED
CREATE OR REPLACE FUNCTION VER_USER(
  u_name IN BB_SHOPPER.USERNAME%TYPE, 
  p_word IN BB_SHOPPER.PASSWORD%TYPE,
  zipcode OUT BB_SHOPPER.ZIPCODE%TYPE, 
  id_shop OUT BB_SHOPPER.IDSHOPPER%TYPE
) RETURN VARCHAR2 IS 
  pass_word_check VARCHAR2(100);
BEGIN 
  SELECT PASSWORD INTO pass_word_check FROM BB_SHOPPER WHERE USERNAME = u_name; 
  SELECT SUBSTR(ZIPCODE, 1, 3), IDSHOPPER INTO zipcode, id_shop FROM BB_SHOPPER WHERE USERNAME = u_name;

  -- Return 'Y' if no exception occurred
  RETURN 'Y';
EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    RETURN 'N';
END;

--TESTING FUNCTION
DECLARE
  v_username BB_SHOPPER.USERNAME%TYPE := 'gma1'; -- Replace with actual username
  v_password BB_SHOPPER.PASSWORD%TYPE := 'goofy'; -- Replace with actual password
  v_zipcode BB_SHOPPER.ZIPCODE%TYPE;
  v_idshop BB_SHOPPER.IDSHOPPER%TYPE;
  v_result VARCHAR2(1);
BEGIN
  v_result := VER_USER(v_username, v_password, v_zipcode, v_idshop);
  
  IF v_result = 'Y' THEN
    DBMS_OUTPUT.PUT_LINE(v_result);
    DBMS_OUTPUT.PUT_LINE('ZIPCODE: ' || v_zipcode);
    DBMS_OUTPUT.PUT_LINE('IDSHOPPER: ' || v_idshop);
  ELSE
    DBMS_OUTPUT.PUT_LINE('User verification failed.');
  END IF;
END;
/

--TESTING PACKAGE
DECLARE
  v_username BB_SHOPPER.USERNAME%TYPE := 'gma1'; -- Replace with actual username
  v_password BB_SHOPPER.PASSWORD%TYPE := 'goofy'; -- Replace with actual password
  v_zipcode BB_SHOPPER.ZIPCODE%TYPE;
  v_idshop BB_SHOPPER.IDSHOPPER%TYPE;
  v_result VARCHAR2(1);
BEGIN
  v_result := LOGIN_PGK.VER_USER(v_username, v_password, v_zipcode, v_idshop);
  
  IF v_result = 'Y' THEN
    DBMS_OUTPUT.PUT_LINE(V_result);
    DBMS_OUTPUT.PUT_LINE(v_zipcode);
    DBMS_OUTPUT.PUT_LINE( v_idshop);
  ELSE
    DBMS_OUTPUT.PUT_LINE(v_result);
  END IF;
END;
/

--Ngoc (Katie) Nguyen
--7.5: 
SELECT * FROM BB_SHOPPER
CREATE OR REPLACE PACKAGE SHOP_QUERY_PKG IS 
  PROCEDURE  look_ups (
    shopper_id IN BB_SHOPPER.IDSHOPPER%TYPE, 
    last_name IN BB_SHOPPER.LASTNAME%TYPE, 
    c_name OUT VARCHAR2, 
    c_city OUT VARCHAR2, 
    c_state OUT VARCHAR2, 
    c_phone_number OUT VARCHAR2,
    c_email OUT VARCHAR2
  );
END; 

CREATE OR REPLACE PACKAGE BODY SHOP_QUERY_PKG IS
  PROCEDURE look_ups(
    shopper_id IN BB_SHOPPER.IDSHOPPER%TYPE, 
    last_name IN BB_SHOPPER.LASTNAME%TYPE, 
    c_name OUT VARCHAR2, 
    c_city OUT VARCHAR2, 
    c_state OUT VARCHAR2, 
    c_phone_number OUT VARCHAR2,
    c_email OUT VARCHAR2
  ) IS
  BEGIN
    SELECT FIRSTNAME || LASTNAME, CITY, STATE, PHONE, EMAIL 
    INTO c_name, c_city, c_state, c_phone_number, c_email FROM BB_SHOPPER
    WHERE shopper_id = IDSHOPPER or last_name = LASTNAME;
    DBMS_OUTPUT.PUT_LINE(c_name);
    DBMS_OUTPUT.PUT_LINE(c_city);
    DBMS_OUTPUT.PUT_LINE(c_state);
    DBMS_OUTPUT.PUT_LINE(c_phone_number);
    DBMS_OUTPUT.PUT_LINE(c_email);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found');
  END look_ups;
END;
/

DECLARE
  shopper_id NUMBER := 23;
  last_name VARCHAR2(100); 
  c_name VARCHAR2(100);
  c_city VARCHAR2(100);
  c_state VARCHAR2(100); 
  c_phone_number VARCHAR2(100);
  c_email VARCHAR2(100);
  status VARCHAR2(100);
BEGIN 
  SHOP_QUERY_PKG.look_ups(shopper_id, last_name, c_name, c_city, c_state, c_phone_number, c_email);
END;

DECLARE
  shopper_id NUMBER;
  last_name VARCHAR2(100) := 'Ratman'; 
  c_name VARCHAR2(100);
  c_city VARCHAR2(100);
  c_state VARCHAR2(100); 
  c_phone_number VARCHAR2(100);
  c_email VARCHAR2(100);
  status VARCHAR2(100);
BEGIN 
  SHOP_QUERY_PKG.look_ups(shopper_id, last_name, c_name, c_city, c_state, c_phone_number, c_email);
END;