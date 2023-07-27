set serveroutput on
CREATE OR REPLACE TRIGGER display_salary_changes 
BEFORE INSERT OR UPDATE ON EMPLOYEE 
FOR EACH ROW 
WHEN (NEW.E# > 0) 
DECLARE 
   sal_diff number; 
BEGIN 
   sal_diff := :NEW.salary  - :OLD.salary; 
   dbms_output.put_line('Old salary: ' || :OLD.salary); 
   dbms_output.put_line('New salary: ' || :NEW.salary); 
   dbms_output.put_line('Salary difference: ' || sal_diff); 
END; 
/ 
show error
set serveroutput off
