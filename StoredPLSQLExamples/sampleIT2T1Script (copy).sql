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

