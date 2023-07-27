create or replace procedure helloWorldDriver(string1 varchar2, string2 varchar2) is
helloWorldString varchar2(100);
begin
 HELLOWORLDSP(string1, string2, helloWorldString);
 dbms_output.put_line(helloWorldString);
 dbms_output.put_line('Return from helloWorldF:' || helloWorldSF(string1, string2));
end helloWorldDriver;
/
