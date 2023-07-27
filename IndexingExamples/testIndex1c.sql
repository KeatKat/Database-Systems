spool testIndex1cOutput.lst
-- Example of query that uses the most efficient index that 
-- helps to retrieve the required information.
-- The system will based on statistical information available
-- in the data dictionary to estimate the cost and predict
-- which index can provide a better access cost to retrieve
-- the required information.
set echo on
set feedback on
--
-- Generate execution plan before the creation of index idx1
explain plan for
select c_custkey, c_name
from customer
where c_custkey = 123
and c_name = 'Sionggo';
--
-- The attributes c_custkey is an indexed attribute (primary
-- key) and c_name is a non-key (without index), the system 
-- will make use of the primary key index to retrieve the 
-- necessary information by performing a unique scan followed
-- by a table access through rowid to retrieve the non-key 
-- attribute c_name because there should be only one row that 
-- satisfies the condition specified in the 'where' clause.
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- An index on c_custkey and c_name is created to speed up the 
-- retrieval of the two attributes.
--
-- Create an index on c_name and c_phone
create index idx1 on CUSTOMER(c_custkey, c_name);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select c_custkey, c_name
from customer
where c_custkey = 123
and c_name = 'Sionggo';
--
-- Now both the attributes c_custkey and c_name are available
-- in the index, the system will try to retrieve both of the
-- information from the index. Since the index was created on 
-- c_custkey and c_name which is non-unique, the system will 
-- perform an index range scan (vertical then horizontal) using
-- the index to speed up the retrieval process. The system will
-- first vertically traverse the index to the first keys in the
-- leave level that starts with the value 'c_custkey - 123', then
-- horizontally scan at the leave level of the index to retrieve
-- both the information c_custkey and c_name.
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select c_custkey, c_name
from customer
where c_name = 'Sionggo';
--
-- In this example, the system will retrieve both the
-- attributes c_custkey and c_name from the index because the 
-- index contains both the attributes. Since c_name is a non-key
-- attribute and it is in the second order of the composite
-- index (c_custkey, c_name), the attribute c_name alone does
-- not provide any ordering. Hence, the system cannot use the
-- attribute to vertically traverse the index. The system will
-- instead perform a fast full index scan to horizontally scan
-- the index at the leave level and retrieve the required 
-- information from the index.
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Drop the index after the processing
drop index idx1;
--
-- Spool off to close the spool
spool off
