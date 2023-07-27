set serveroutput on
create or replace function helloWorldSF( 
hello IN varchar2,
world IN varchar2) return varchar2 is
BEGIN
   return(hello || ' ' || world || '!');
END helloWorldSF;
/
show error
set serveroutput off
