-- function demo1
set serveroutput on
declare
   n1 number;
   n2 number;
   n3 number;
function findHigherF (x number, y number) return number IS
begin
   if x > y then
      return x;
   else
      return y;
   end if;
end;
--
--
begin
   n1 := 9;
   n2 := 18;
   n3 := findHigherF (n1, n2);
   dbms_output.put_line('Higher of ' || n1 || ' and ' || n2 
                        || ' is ' || n3|| '.');
   dbms_output.put_line('findHigherF: ' || findHigherF(n2, n1));
end;
/
show errors
set serveroutput off;
