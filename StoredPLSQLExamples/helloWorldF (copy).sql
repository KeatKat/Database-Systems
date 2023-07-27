set serveroutput on
DECLARE 
   s1 varchar2(100); 
   s2 varchar2(100); 
function helloWorldF( 
	hello IN varchar2,
	world IN varchar2) return varchar2 is
BEGIN
   return(hello || ' ' || world || '!');
END helloWorldF;

BEGIN 
   s1:= '&s1'; 
   s2:= '&s2'; 
   dbms_output.put_line(helloWorldF(s1, s2)); 
END; 
/
