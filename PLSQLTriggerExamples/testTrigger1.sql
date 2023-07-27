set serveroutput on
--
INSERT INTO EMPLOYEE VALUES( '00016', 'George Brown', TO_DATE('01-APR-1980','DD-MON-YYYY'), '123 Circle St. Horsley, NSW 2530', SYSDATE, 2600 );
--
update employee
set salary = salary - 100
where e# = '00016';
--
commit;
--
delete employee
where e# = '00016';
