set echo on
set feedback on
set line 100
set page 200
spool solution1.lst
/* ============================================================================
 * Student number: 12345678
 * name: Sionggo
 * Date: 
 * Description: 
 * ==========================================================================*/
-- create or replace function
create or replace function numOfPartsSupplied(pName varchar2)
return number is
qty number;
begin
   select count(ps_partkey) into qty
   from part, partsupp
   where p_partkey = ps_partkey
   and lower(p_name) = lower(pName)
   group by ps_partkey;
   --
   return qty;
end;
/
show error
--
set serveroutput on
set echo on
set feedback on
-- call the stored function numOfPartsSupplied to display the 
-- part's number, name, and total count.
-- The part name are: 'Cyan rose khaki cornsilk dodger',
-- 'burlywood chocolate navy tan blue',
-- 'indian puff steel green sky'
select p_partkey as "Part key", p_name as "Part Name",
       numOfPartsSupplied(p_name) as "Number of parts"
from 	part
where 	p_name in ('cyan rose khaki cornsilk dodger',
		'burlywood chocolate navy tan blue',
		'indian puff steel green sky');
--
spool off
