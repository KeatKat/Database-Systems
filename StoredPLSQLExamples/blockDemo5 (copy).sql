-- blockDemo5
set serveroutput on;
DECLARE
s1 varchar2(100);
s2 varchar2(100);
s3 varchar2(100);
--
--
FUNCTION demo5F(hello IN VARCHAR2,
		 world IN varchar2) 
return varchar2 IS
BEGIN
   return (hello || ' ' || world || '!!!');
END;
--
--

BEGIN
  s1 := '&s1';
  s2 := '&s2';
  s3 := demo5F(s1, s2);
  dbms_output.put_line('s3: ' || s3);
  dbms_output.put_line('demo5F: ' || demo5F(s1, s2));
END;
/
show error
set serveroutput off;
