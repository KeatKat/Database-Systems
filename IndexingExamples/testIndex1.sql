-- Example of query that accesses the index to get the required
-- information (Fast full index scans).
-- With Fast full index scans, the system accesses the index only
-- to retrieve the required information because all the required
-- information are available in the index.
set echo on
set feedback on
--
-- Generate execution plan before the creation of index idx1
explain plan for
select c_name, c_phone
from customer;
--
-- Since both the attributes c_name and c_phone are non keys and
-- no index has been created for the two indexes, the system 
-- will perform a full table scan to retrieve the necessary
-- information.
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- To speed up the retrieval of the two attributes, an index
-- containing the two attributes is created.
--
-- Create an index on c_name and c_phone
create index idx1 on CUSTOMER(c_name, c_phone);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select c_name, c_phone
from customer;
--
-- The system should use the created index to speed up the
-- retrieval process. Since both attributes are available
-- in the index, the system will retrieve both the attributes
-- from the index by performing a fast full index scan.
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Drop the index after the processing
drop index idx1;

