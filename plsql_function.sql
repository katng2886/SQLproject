--Functions:

-- Display members using functions:

DROP FUNCTION member_display;
CREATE OR REPLACE  FUNCTION member_display 
(m_id IN NUMBER, 
m_firstname IN VARCHAR2,
m_lastname IN VARCHAR2
)
RETURN VARCHAR2
IS 
member_info VARCHAR(100); 
BEGIN 
member_info := 'Member ID: ' ||m_id|| ' - ' || ' Name: ' ||m_lastname|| ', ' || m_firstname;

RETURN member_info;

END;

--Testing function: 
DECLARE 
    member_info VARCHAR2(100); 
    m_id BB_SHOPPER.IDSHOPPER%TYPE := 25; 
    m_firstname BB_SHOPPER.FIRSTNAME%TYPE := 'Scott'; 
    m_lastname BB_SHOPPER.LASTNAME%TYPE := 'Savid';  
BEGIN 
    member_info := member_display(m_id, m_firstname, m_lastname); 
    DBMS_OUTPUT.PUT_LINE(member_info); 
END;

--Key note: 
--1. OUT parameter are not typically used in functions
--      Mixing OUT and RETURN -> Confusion. 
--      It prohibits the function from being used in SQL. 
--2. When using RETURN sentence -> only 1 return is executed.
'''RETURN statement in a PROEDURE: 
- Different purpose than a RERYRN stmt in a function, 
- Used to change flow of execution
- Stops processing in that block and moves to the next stmt after the procedure call
- Stand-alone stmt with NO arguments
'''

'''PARAMETER CONSTRAINT
- Fornal parameters - included in a program unit. 
- Actual parameters - argumens used in a program unit call.
- Arguments for an OUT parameter must be a variable to hold the value returned. 
- Actual parameters determine the size of the formal parameters
'''

'''PASSING PARAMETER CONSTRAINT
- 2 techniques: 
    - Passed by REFERENCE - create POINTER to value the actual parameter (USE a compiler hint to use pass by reference)
    - Passed by VALUE - copies value from actual to formal parameter. (DEFAULT)
'''

--Pass by REFERENCE
CREATE OR REPLACE PROCEDURE test_nocopy_sp (
    p_in IN NUMBER, 
    p_out OUT NOCOPY VARCHAR2
)
IS
BEGIN 
    p_out := 'N'; 
    IF p_in = 1 THEN 
        RAISE NO_DATA_FOUND; 
    END IF; 
END;

 