/*Practice using: CUBE, ROLLUP, CASE statements, TRUNC, TO_CHAR, TO_DATE */

DROP TABLE ALIASES CASCADE CONSTRAINTS;

DROP TABLE CRIMINALS CASCADE CONSTRAINTS;

DROP TABLE CRIMES CASCADE CONSTRAINTS;

DROP TABLE APPEALS CASCADE CONSTRAINTS;

DROP TABLE OFFICERS CASCADE CONSTRAINTS;

DROP TABLE CRIME_OFFICERS CASCADE CONSTRAINTS;

DROP TABLE CRIME_CHARGES CASCADE CONSTRAINTS;

DROP TABLE CRIME_CODES CASCADE CONSTRAINTS;

DROP TABLE PROB_OFFICERS CASCADE CONSTRAINTS;

DROP TABLE SENTENCES CASCADE CONSTRAINTS;

DROP SEQUENCE APPEALS_ID_SEQ;

DROP TABLE PROB_CONTACT CASCADE CONSTRAINTS;

CREATE TABLE ALIASES (
  ALIAS_ID NUMBER(6),
  CRIMINAL_ID NUMBER(6),
  ALIAS VARCHAR2(10)
);

CREATE TABLE CRIMINALS (
  CRIMINAL_ID NUMBER(6),
  LAST VARCHAR2(15),
  FIRST VARCHAR2(10),
  STREET VARCHAR2(30),
  CITY VARCHAR2(20),
  STATE CHAR(2),
  ZIP CHAR(5),
  PHONE CHAR(10),
  V_STATUS CHAR(1) DEFAULT 'N',
  P_STATUS CHAR(1) DEFAULT 'N'
);

CREATE TABLE CRIMES (
  CRIME_ID NUMBER(9),
  CRIMINAL_ID NUMBER(6),
  CLASSIFICATION CHAR(1),
  DATE_CHARGED DATE,
  STATUS CHAR(2),
  HEARING_DATE DATE,
  APPEAL_CUT_DATE DATE
);

CREATE TABLE SENTENCES (
  SENTENCE_ID NUMBER(6),
  CRIMINAL_ID NUMBER(9),
  TYPE CHAR(1),
  PROB_ID NUMBER(5),
  START_DATE DATE,
  END_DATE DATE,
  VIOLATIONS NUMBER(3)
);

CREATE TABLE PROB_OFFICERS (
  PROB_ID NUMBER(5),
  LAST VARCHAR2(15),
  FIRST VARCHAR2(10),
  STREET VARCHAR2(30),
  CITY VARCHAR2(20),
  STATE CHAR(2),
  ZIP CHAR(5),
  PHONE CHAR(10),
  EMAIL VARCHAR2(30),
  STATUS CHAR(1) DEFAULT 'A',
  MGR_ID NUMBER(5)
);

CREATE TABLE OFFICERS (
  OFFICER_ID NUMBER(8),
  LAST VARCHAR2(15),
  FIRST VARCHAR2(10),
  PRECINCT CHAR(4),
  BADGE VARCHAR2(14),
  PHONE CHAR(10),
  STATUS CHAR(1) DEFAULT 'A'
);

CREATE TABLE CRIME_CODES (
  CRIME_CODE NUMBER(3),
  CODE_DESCRIPTION VARCHAR2(30)
);

ALTER TABLE CRIMES MODIFY (CLASSIFICATION DEFAULT 'U');

ALTER TABLE CRIMES ADD (DATE_RECORDED DATE DEFAULT SYSDATE);

ALTER TABLE PROB_OFFICERS ADD (PAGER# CHAR(10));

ALTER TABLE ALIASES MODIFY (ALIAS VARCHAR2(20));

ALTER TABLE CRIMINALS ADD CONSTRAINT CRIMINALS_ID_PK PRIMARY KEY (CRIMINAL_ID);

ALTER TABLE CRIMINALS ADD CONSTRAINT CRIMINALS_VSTATUS_CK CHECK (V_STATUS IN('Y', 'N'));

ALTER TABLE CRIMINALS ADD CONSTRAINT CRIMINALS_PSTATUS_CK CHECK (P_STATUS IN('Y', 'N'));

ALTER TABLE ALIASES ADD CONSTRAINT ALIASES_ID_PK PRIMARY KEY (ALIAS_ID);

ALTER TABLE ALIASES ADD CONSTRAINT APPEALS_CRIMINALID_FK FOREIGN KEY (CRIMINAL_ID) REFERENCES CRIMINALS(CRIMINAL_ID);

ALTER TABLE ALIASES MODIFY (CRIMINAL_ID NOT NULL);

ALTER TABLE CRIMES ADD CONSTRAINT CRIMES_ID_PK PRIMARY KEY (CRIME_ID);

ALTER TABLE CRIMES ADD CONSTRAINT CRIMES_CLASS_CK CHECK (CLASSIFICATION IN('F', 'M', 'O', 'U'));

ALTER TABLE CRIMES ADD CONSTRAINT CRIMES_STATUS_CK CHECK (STATUS IN('CL', 'CA', 'IA'));

ALTER TABLE CRIMES ADD CONSTRAINT CRIMES_CRIMINALID_FK FOREIGN KEY (CRIMINAL_ID) REFERENCES CRIMINALS(CRIMINAL_ID);

ALTER TABLE CRIMES MODIFY (CRIMINAL_ID NOT NULL);

ALTER TABLE PROB_OFFICERS ADD CONSTRAINT PROBOFFICERS_ID_PK PRIMARY KEY (PROB_ID);

ALTER TABLE PROB_OFFICERS ADD CONSTRAINT PROBOFFICERS_STATUS_CK CHECK (STATUS IN('A', 'I'));

ALTER TABLE SENTENCES ADD CONSTRAINT SENTENCES_ID_PK PRIMARY KEY (SENTENCE_ID);

ALTER TABLE SENTENCES ADD CONSTRAINT SENTENCES_CRIMEID_FK FOREIGN KEY (CRIMINAL_ID) REFERENCES CRIMINALS(CRIMINAL_ID);

ALTER TABLE SENTENCES MODIFY (CRIMINAL_ID NOT NULL);

ALTER TABLE SENTENCES ADD CONSTRAINT SENTENCES_PROBID_FK FOREIGN KEY (PROB_ID) REFERENCES PROB_OFFICERS(PROB_ID);

ALTER TABLE SENTENCES ADD CONSTRAINT SENTENCES_TYPE_CK CHECK (TYPE IN('J', 'H', 'P'));

ALTER TABLE OFFICERS ADD CONSTRAINT OFFICERS_ID_PK PRIMARY KEY (OFFICER_ID);

ALTER TABLE OFFICERS ADD CONSTRAINT OFFICERS_STATUS_CK CHECK (STATUS IN('A', 'I'));

ALTER TABLE CRIME_CODES ADD CONSTRAINT CRIMECODES_CODE_PK PRIMARY KEY (CRIME_CODE);

CREATE TABLE APPEALS (
  APPEAL_ID NUMBER(5),
  CRIME_ID NUMBER(9) NOT NULL,
  FILING_DATE DATE,
  HEARING_DATE DATE,
  STATUS CHAR(1) DEFAULT 'P',
  CONSTRAINT APPEALS_ID_PK PRIMARY KEY (APPEAL_ID),
  CONSTRAINT APPEALS_CRIMEID_FK FOREIGN KEY (CRIME_ID) REFERENCES CRIMES(CRIME_ID),
  CONSTRAINT APPEALS_STATUS_CK CHECK (STATUS IN('P', 'A', 'D'))
);

CREATE TABLE CRIME_OFFICERS (
  CRIME_ID NUMBER(9),
  OFFICER_ID NUMBER(8),
  CONSTRAINT CRIMEOFFICERS_CID_OID_PK PRIMARY KEY (CRIME_ID, OFFICER_ID),
  CONSTRAINT CRIMEOFFICERS_CRIMEID_FK FOREIGN KEY (CRIME_ID) REFERENCES CRIMES(CRIME_ID),
  CONSTRAINT CRIMEOFFICERS_OFFICERID_FK FOREIGN KEY (OFFICER_ID) REFERENCES OFFICERS(OFFICER_ID)
);

CREATE TABLE CRIME_CHARGES (
  CHARGE_ID NUMBER(10),
  CRIME_ID NUMBER(9) NOT NULL,
  CRIME_CODE NUMBER(3) NOT NULL,
  CHARGE_STATUS CHAR(2),
  FINE_AMOUNT NUMBER(7, 2),
  6/RT_FEE NUMBER(7, 2),
  AMOUNT_PAID NUMBER(7, 2),
  PAY_DUE_DATE DATE,
  CONSTRAINT CRIMECHARGES_ID_PK PRIMARY KEY (CHARGE_ID),
  CONSTRAINT CRIMECHARGES_CRIMEID_FK FOREIGN KEY (CRIME_ID) REFERENCES CRIMES(CRIME_ID),
  CONSTRAINT CRIMECHARGES_CODE_FK FOREIGN KEY (CRIME_CODE) REFERENCES CRIME_CODES(CRIME_CODE),
  CONSTRAINT CRIMECHARGES_STATUS_CK CHECK (CHARGE_STATUS IN('PD', 'GL', 'NG'))
);

INSERT INTO CRIME_CODES VALUES (
  301,
  'Agg Assault'
);

INSERT INTO CRIME_CODES VALUES (
  302,
  'Auto Theft'
);

INSERT INTO CRIME_CODES VALUES (
  303,
  'Burglary-Business'
);

INSERT INTO CRIME_CODES VALUES (
  304,
  'Criminal Mischief'
);

INSERT INTO CRIME_CODES VALUES (
  305,
  'Drug Offense'
);

INSERT INTO CRIME_CODES VALUES (
  306,
  'Bomb Threat'
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  100,
  'Peek',
  'Susan',
  'Virginia Beach',
  'A',
  NULL
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  102,
  'Speckle',
  'Jeff',
  'Virginia Beach',
  'A',
  100
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  104,
  'Boyle',
  'Chris',
  'Virginia Beach',
  'A',
  100
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  106,
  'Taps',
  'George',
  'Chesapeake',
  'A',
  NULL
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  108,
  'Ponds',
  'Terry',
  'Chesapeake',
  'A',
  106
);

INSERT INTO PROB_OFFICERS (
  PROB_ID,
  LAST,
  FIRST,
  CITY,
  STATUS,
  MGR_ID
) VALUES (
  110,
  'Hawk',
  'Fred',
  'Chesapeake',
  'I',
  106
);

INSERT INTO OFFICERS (
  OFFICER_ID,
  LAST,
  FIRST,
  PRECINCT,
  BADGE,
  PHONE,
  STATUS
) VALUES (
  111112,
  'Shocks',
  'Pam',
  'OCVW',
  'E5546A33',
  '7574446767',
  'A'
);

INSERT INTO OFFICERS (
  OFFICER_ID,
  LAST,
  FIRST,
  PRECINCT,
  BADGE,
  PHONE,
  STATUS
) VALUES (
  111113,
  'Busey',
  'Gerry',
  'GHNT',
  'E5577D48',
  '7574446767',
  'A'
);

INSERT INTO OFFICERS (
  OFFICER_ID,
  LAST,
  FIRST,
  PRECINCT,
  BADGE,
  PHONE,
  STATUS
) VALUES (
  111114,
  'Gants',
  'Dale',
  'SBCH',
  'E5536N02',
  '7574446767',
  'A'
);

INSERT INTO OFFICERS (
  OFFICER_ID,
  LAST,
  FIRST,
  PRECINCT,
  BADGE,
  PHONE,
  STATUS
) VALUES (
  111115,
  'Hart',
  'Leigh',
  'WAVE',
  'E5511J40',
  '7574446767',
  'A'
);

INSERT INTO OFFICERS (
  OFFICER_ID,
  LAST,
  FIRST,
  PRECINCT,
  BADGE,
  PHONE,
  STATUS
) VALUES (
  111116,
  'Sands',
  'Ben',
  'OCVW',
  'E5588R00',
  '7574446767',
  'I'
);

COMMIT;

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1020,
  'Phelps',
  'Sam',
  '1105 Tree Lane',
  'Virginia Beach',
  'VA',
  '23510',
  7576778484,
  'Y',
  'N'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10085,
  1020,
  'F',
  '03-SEP-08',
  'CA',
  '15-SEP-08',
  '15-DEC-08'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5000,
  10085,
  301,
  'GL',
  3000,
  200,
  40,
  '15-OCT-08'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5001,
  10085,
  305,
  'GL',
  1000,
  100,
  NULL,
  '15-OCT-08'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1000,
  1020,
  'J',
  NULL,
  '15-SEP-08',
  '15-SEP-10',
  0
);

INSERT INTO ALIASES (
  ALIAS_ID,
  CRIMINAL_ID,
  ALIAS
) VALUES (
  100,
  1020,
  'Bat'
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10085,
  111112
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1021,
  'Sums',
  'Tammy',
  '22 E. Ave',
  'Virginia Beach',
  'VA',
  '23510',
  7575453390,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10086,
  1021,
  'M',
  '20-OCT-08',
  'CL',
  '05-DEC-08',
  NULL
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5002,
  10086,
  304,
  'GL',
  200,
  100,
  25,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1001,
  1021,
  'P',
  102,
  '05-DEC-08',
  '05-JUN-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10086,
  111114
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1022,
  'Caulk',
  'Dave',
  '8112 Chester Lane',
  'Chesapeake',
  'VA',
  '23320',
  7578403690,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10087,
  1022,
  'M',
  '30-OCT-08',
  'IA',
  '05-DEC-08',
  '15-MAR-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5003,
  10087,
  305,
  'GL',
  100,
  50,
  150,
  '15-MAR-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1002,
  1022,
  'P',
  108,
  '20-MAR-09',
  '20-AUG-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10087,
  111115
);

INSERT INTO ALIASES (
  ALIAS_ID,
  CRIMINAL_ID,
  ALIAS
) VALUES (
  101,
  1022,
  'Cabby'
);

INSERT INTO APPEALS (
  APPEAL_ID,
  CRIME_ID,
  FILING_DATE,
  HEARING_DATE,
  STATUS
) VALUES (
  7500,
  10087,
  '10-DEC-08',
  '20-DEC-08',
  'A'
);

INSERT INTO APPEALS (
  APPEAL_ID,
  CRIME_ID,
  FILING_DATE,
  HEARING_DATE,
  STATUS
) VALUES (
  7501,
  10086,
  '15-DEC-08',
  '20-DEC-08',
  'A'
);

INSERT INTO APPEALS (
  APPEAL_ID,
  CRIME_ID,
  FILING_DATE,
  HEARING_DATE,
  STATUS
) VALUES (
  7502,
  10085,
  '20-SEP-08',
  '28-OCT-08',
  'A'
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1023,
  'Dabber',
  'Pat',
  NULL,
  'Chesapeake',
  'VA',
  '23320',
  NULL,
  'N',
  'N'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10088,
  1023,
  'O',
  '05-NOV-08',
  'CA',
  NULL,
  NULL
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5004,
  10088,
  306,
  'PD',
  NULL,
  NULL,
  NULL,
  NULL
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10088,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1025,
  'Cat',
  'Tommy',
  NULL,
  'Norfolk',
  'VA',
  '26503',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10089,
  1025,
  'M',
  '22-OCT-08',
  'CA',
  '25-NOV-08',
  '15-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5005,
  10089,
  305,
  'GL',
  100,
  50,
  NULL,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1004,
  1025,
  'P',
  106,
  '20-DEC-08',
  '20-MAR-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10089,
  111115
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10089,
  111116
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1026,
  'Simon',
  'Tim',
  NULL,
  'Norfolk',
  'VA',
  '26503',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10090,
  1026,
  'M',
  '22-OCT-08',
  'CA',
  '25-NOV-08',
  '15-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5006,
  10090,
  305,
  'GL',
  100,
  50,
  NULL,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1005,
  1026,
  'P',
  106,
  '20-DEC-08',
  '20-MAR-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10090,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1027,
  'Pints',
  'Reed',
  NULL,
  'Norfolk',
  'VA',
  '26505',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10091,
  1027,
  'M',
  '24-OCT-08',
  'CA',
  '28-NOV-08',
  '15-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5007,
  10091,
  305,
  'GL',
  100,
  50,
  20,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1006,
  1027,
  'P',
  106,
  '20-DEC-08',
  '20-MAR-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10091,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1028,
  'Mansville',
  'Nancy',
  NULL,
  'Norfolk',
  'VA',
  '26505',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10092,
  1028,
  'M',
  '24-OCT-08',
  'CA',
  '28-NOV-08',
  '15-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5008,
  10092,
  305,
  'GL',
  100,
  50,
  25,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1007,
  1028,
  'P',
  106,
  '20-DEC-08',
  '20-MAR-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10092,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1024,
  'Perry',
  'Cart',
  NULL,
  'Norfolk',
  'VA',
  '26501',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10093,
  1024,
  'M',
  '22-OCT-08',
  'CA',
  '25-NOV-08',
  '15-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5009,
  10093,
  305,
  'GL',
  100,
  50,
  NULL,
  '15-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1003,
  1024,
  'P',
  106,
  '20-DEC-08',
  '20-MAR-09',
  1
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10093,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1029,
  'Statin',
  'Penny',
  NULL,
  'Norfolk',
  'VA',
  '26505',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  10094,
  1029,
  'M',
  '26-OCT-08',
  'CA',
  '26-NOV-08',
  '17-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5010,
  10094,
  305,
  'GL',
  50,
  50,
  NULL,
  '17-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1008,
  1029,
  'P',
  106,
  '20-DEC-08',
  '05-FEB-09',
  1
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  10094,
  111115
);

INSERT INTO CRIMINALS (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1030,
  'Panner',
  'Lee',
  NULL,
  'Norfolk',
  'VA',
  '26505',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  25344031,
  1030,
  'M',
  '26-OCT-08',
  'CA',
  '26-NOV-08',
  '17-FEB-09'
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5011,
  25344031,
  305,
  'GL',
  50,
  50,
  NULL,
  '17-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1009,
  1030,
  'P',
  106,
  '20-DEC-08',
  '05-FEB-09',
  1
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  25344031,
  111115
);

INSERT INTO CRIMES (
  CRIME_ID,
  CRIMINAL_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  STATUS,
  HEARING_DATE,
  APPEAL_CUT_DATE
) VALUES (
  25344060,
  1030,
  'M',
  '18-NOV-08',
  'CL',
  '26-NOV-08',
  NULL
);

INSERT INTO CRIME_CHARGES(
  CHARGE_ID,
  CRIME_ID,
  CRIME_CODE,
  CHARGE_STATUS,
  FINE_AMOUNT,
  COURT_FEE,
  AMOUNT_PAID,
  PAY_DUE_DATE
) VALUES (
  5012,
  25344060,
  305,
  'GL',
  50,
  50,
  100,
  '17-FEB-09'
);

INSERT INTO SENTENCES (
  SENTENCE_ID,
  CRIMINAL_ID,
  TYPE,
  PROB_ID,
  START_DATE,
  END_DATE,
  VIOLATIONS
) VALUES (
  1010,
  1030,
  'P',
  106,
  '06-FEB-09',
  '06-JUL-09',
  0
);

INSERT INTO CRIME_OFFICERS (
  CRIME_ID,
  OFFICER_ID
) VALUES (
  25344060,
  111116
);

COMMIT;

CREATE SEQUENCE APPEALS_ID_SEQ
  START WITH 7505
  NOCACHE
  NOCYCLE;

CREATE TABLE PROB_CONTACT (
  PROB_CAT NUMBER(2),
  LOW_AMT NUMBER(5),
  HIGH_AMT NUMBER(5),
  CON_FREQ VARCHAR2(20)
);

INSERT INTO PROB_CONTACT VALUES(
  10,
  1,
  80,
  'Weekly'
);

INSERT INTO PROB_CONTACT VALUES(
  20,
  81,
  160,
  'Every 2 weeks'
);

INSERT INTO PROB_CONTACT VALUES(
  30,
  161,
  500,
  'Monthly'
);

COMMIT;

CREATE TABLE CRIMINALS_DW (
  CRIMINAL_ID NUMBER(6),
  LAST VARCHAR2(15),
  FIRST VARCHAR2(10),
  STREET VARCHAR2(30),
  CITY VARCHAR2(20),
  STATE CHAR(2),
  ZIP CHAR(5),
  PHONE CHAR(10),
  V_STATUS CHAR(1),
  P_STATUS CHAR(1)
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1020,
  'Phelps',
  'Sam',
  '1105 Tree Lane',
  'Virginia Beach',
  'VA',
  '23510',
  7576778484,
  'Y',
  'N'
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1021,
  'Sums',
  'Tammy',
  '22 E. Ave',
  'Virginia Beach',
  'VA',
  '23510',
  7575453390,
  'N',
  'Y'
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1022,
  'Caulk',
  'Dave',
  '8112 Chester Lane',
  'Chesapeake',
  'VA',
  '23320',
  7578403690,
  'N',
  'Y'
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1023,
  'Dabber',
  'Pat',
  NULL,
  'Chesapeake',
  'VA',
  '23320',
  NULL,
  'N',
  'N'
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1024,
  'Perry',
  'Cart',
  '11 New St.',
  'Surry',
  'VA',
  '54501',
  NULL,
  'N',
  'Y'
);

INSERT INTO CRIMINALS_DW (
  CRIMINAL_ID,
  LAST,
  FIRST,
  STREET,
  CITY,
  STATE,
  ZIP,
  PHONE,
  V_STATUS,
  P_STATUS
) VALUES (
  1025,
  'Cat',
  'Tommy',
  NULL,
  'Norfolk',
  'VA',
  '26503',
  7578889393,
  'N',
  'Y'
);

COMMIT;

--Ngoc (Katie) Nguyen
--1.
SELECT
  CRIME_ID,
  CLASSIFICATION,
  DATE_CHARGED,
  HEARING_DATE,
  TRUNC(HEARING_DATE - DATE_CHARGED) AS CRIME_PERIOD
FROM
  CRIMES
WHERE
  TRUNC(HEARING_DATE - DATE_CHARGED) > 14;


-- Ngoc (Katie) Nguyen
--2.
SELECT
  PRECINCT,
  LAST,
  FIRST,
  STATUS,
  SUBSTR(PRECINCT, 2, 1),
  CASE
    WHEN SUBSTR(PRECINCT, 2, 1) = 'A' THEN
      'SHADY GROVE'
    WHEN SUBSTR(PRECINCT, 2, 1) = 'B' THEN
      'CENTER CITY'
    WHEN SUBSTR(PRECINCT, 2, 1) = 'C' THEN
      'BAY LANDING'
  END                    AS CASE_DESCRIPTION
FROM
  OFFICERS
WHERE
  STATUS = 'A';


SELECT
  TRUNC(MONTHS_BETWEEN (END_DATE, START_DATE))
FROM
  SENTENCES;

-- Ngoc (Katie) Nguyen
--3.
SELECT
  S.SENTENCE_ID,
  C.CRIMINAL_ID,
  UPPER(CONCAT(CONCAT(FIRST, ' '), LAST))         FULL_NAME,
  TO_CHAR(S.START_DATE, 'MONTH DD, YYYY')         START_DATE,
  TRUNC(MONTHS_BETWEEN(S.END_DATE, S.START_DATE))LENGTH_DATE
FROM
  SENTENCES S,
  CRIMINALS C;

SELECT
  *
FROM
  CRIME_CHARGES;

--Ngoc (Katie) Nguyen
--4.
SELECT
  CHARGE_ID,
  TO_CHAR((FINE_AMOUNT + COURT_FEE), '$9999.99' )TOTAL_AMOUNT_OWNED,
  TO_CHAR(AMOUNT_PAID, '$9999.99')                AMOUNT_PAID,
  PAY_DUE_DATE,
  CASE
    WHEN AMOUNT_PAID > (FINE_AMOUNT + COURT_FEE) THEN
      'NULL'
    WHEN AMOUNT_PAID < (FINE_AMOUNT + COURT_FEE) THEN
      TO_CHAR((FINE_AMOUNT + COURT_FEE - AMOUNT_PAID), '$9999.99')
  END                                             AMOUNT_OWNED
FROM
  CRIME_CHARGES
WHERE
  (FINE_AMOUNT + COURT_FEE - AMOUNT_PAID) > 0;

-- Ngoc (Katie) Nguyen
--5.
SELECT
  CONCAT(CONCAT(C.FIRST, ' '), C.LAST)                 FULL_NAME,
  TO_CHAR(S.START_DATE, 'MONTH DD, YYYY')              START_DATE,
  TO_CHAR(S.END_DATE, 'MONTH DD, YYYY')                END_DATE,
  TO_CHAR(ADD_MONTHS(START_DATE, 2), 'MONTH DD, YYYY') REVIEW_DATE
FROM
  CRIMINALS C
  JOIN SENTENCES S
  ON C.CRIMINAL_ID = S.CRIMINAL_ID
WHERE
  MONTHS_BETWEEN(S.END_DATE, S.START_DATE) > 2;

-- Ngoc (Katie) Nguyen
--Chapter 11:
--1.
SELECT
  AVG(COUNT(CRIME_ID))
FROM
  CRIME_OFFICERS
GROUP BY
  OFFICER_ID;

-- Ngoc (Katie) Nguyen
--2.
SELECT
  COUNT(CRIME_ID),
  STATUS
FROM
  CRIMES
GROUP BY
  STATUS;

-- Ngoc (Katie) Nguyen
--3.
SELECT
  CRIMINAL_ID,
  COUNT(CRIME_ID) CRIME
FROM
  CRIMES
GROUP BY
  CRIMINAL_ID
HAVING
  COUNT(CRIME_ID) = (
    SELECT
      MAX(COUNT(CRIME_ID))
    FROM
      CRIMES
    GROUP BY
      CRIMINAL_ID
  );

--Ngoc (Katie) Nguyen
--4.
SELECT
  MIN(FINE_AMOUNT) LOWEST_FINE
FROM
  CRIME_CHARGES;

--Ngoc (Katie) Nguyen
--5.
SELECT
  CRIMINAL_ID,
  LAST,
  FIRST,
  COUNT(SENTENCE_ID)
FROM
  CRIMINALS
  JOIN SENTENCES
  USING (CRIMINAL_ID)
GROUP BY
  CRIMINAL_ID,
  LAST,
  FIRST
HAVING
  COUNT(SENTENCE_ID)>1;

--Ngoc (Katie) Nguyen
--6.
SELECT
  PRECINCT,
  COUNT(CHARGE_STATUS)
FROM
  CRIME_CHARGES
  JOIN CRIME_OFFICERS
  ON (CRIME_CHARGES.CRIME_ID = CRIME_OFFICERS.CRIME_ID)
  JOIN OFFICERS
  ON (CRIME_OFFICERS.OFFICER_ID = OFFICERS.OFFICER_ID)
WHERE
  CHARGE_STATUS='GL'
GROUP BY
  PRECINCT
HAVING
  COUNT(CHARGE_STATUS)>7;

--Ngoc (Katie) Nguyen
--7.

SELECT
  CLASSIFICATION,
  SUM(FINE_AMOUNT+COURT_FEE)             TOTAL_AMOUNT,
  SUM(FINE_AMOUNT+COURT_FEE-AMOUNT_PAID) OWNED
FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY
  CLASSIFICATION;

--Ngoc (Katie) Nguyen
--9.
SELECT
  CLASSIFICATION,
  CHARGE_STATUS,
  COUNT(*)
FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY
  GROUPING SETS ((CLASSIFICATION, CHARGE_STATUS), ());

--Ngoc (Katie) Nguyen
--10.
--Using ROLLUP
SELECT
  CLASSIFICATION,
  CHARGE_STATUS,
  COUNT(*) 

FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY
  ROLLUP(CLASSIFICATION, CHARGE_STATUS);


--10.A
SELECT
  CLASSIFICATION,
  CHARGE_STATUS,
  COUNT(*)

FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY CHARGE_STATUS, ROLLUP(CLASSIFICATION)


--10.B
SELECT
  CLASSIFICATION,
  CHARGE_STATUS,
  COUNT(*)

FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY CLASSIFICATION, ROLLUP(CHARGE_STATUS);



--Ngoc (Katie) Nguyen
--11. 
SELECT
  CLASSIFICATION,

  COUNT(*) 

FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY
  ROLLUP(CLASSIFICATION);

SELECT
  CLASSIFICATION,

  COUNT(*) 

FROM
  CRIMES
  JOIN CRIME_CHARGES
  USING (CRIME_ID)
GROUP BY
  CUBE(CLASSIFICATION);
