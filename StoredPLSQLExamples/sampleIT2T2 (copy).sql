set serveroutput on
set echo on
set feedback on
set line 256
spool /home/oracle/PLSQL/PLSQLFunction/sampleIT2T2Outout.lst
create or replace procedure showPartSupplied is
previousPart PART.p_partkey%type  := -1;
begin
  for currentRow IN (select p_partkey, p_name, ps_partkey, ps_availqty, ps_supplycost
			from part left outer join partsupp
				on p_partkey = ps_partkey
			where p_partkey in (1,2,3,4,5,12345678)
			order by p_partkey, p_name, ps_availqty, ps_supplycost)
  loop
    if previousPart != currentRow.p_partkey then
	dbms_output.put_line( chr(10) ); -- new line
	dbms_output.put_line(currentRow.p_partkey || ' - ' || currentRow.p_name||':');
    end if;
    --
    if currentRow.ps_partkey is not null then
	dbms_output.put_line(chr(9)||lpad(trim(to_char(currentRow.ps_availqty)),12)||', '
		||rpad(trim(to_char(currentRow.ps_supplycost,'$999G999G999D99')),14));
    end if;
    --
    previousPart := currentRow.p_partkey;
  end loop;
    dbms_output.put_line(null);
end;
/
show error
