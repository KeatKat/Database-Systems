set echo on
set feedback on
--
-- Generate execution plan before the creation of index idx1
explain plan for
select count(distinct c_name)
from customer;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Create an index on c_name and c_phone
create index idx1 on CUSTOMER(c_name, c_phone);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select count(distinct c_name)
from customer;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Drop the index after the processing
drop index idx1;

