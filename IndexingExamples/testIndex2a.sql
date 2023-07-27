spool testIndex2aOutput.lst
-- Example of query that accesses the index horizontally to get 
-- the required information (Full scan and Fast full index scan).
-- With Fast full index scans, the system accesses the index only
-- to retrieve the required information because all the required
-- information are available in the index.
--
set echo on
set feedback on
--
-- Generate execution plan of a query without a 'where' clause.
explain plan for
select l_orderkey, l_linenumber, l_quantity, l_tax
from lineitem;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Since there is no 'where' clause, the system performs a full
-- table scan to retrieve all rows.
--
-- Generate execution plan of a query without a 'where' clause
-- but require to order the output by l_quantity and l_tax.
explain plan for
select l_orderkey, l_linenumber, l_quantity, l_tax
from lineitem
order by l_quantity, l_tax;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Since there is no 'where' clause and the system needs to
-- present the output in a specified order, the system performs
-- a full table scan to retrieve all rows and perform a sort
-- operation on the retrieved data before presenting them.
--
-- Next, we create an index consisting of the attributes
-- l_quantity and l_tax.
create index idx1 on lineitem(l_quantity, l_tax);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select l_orderkey, l_linenumber, l_quantity, l_tax
from lineitem
order by l_quantity, l_tax;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Apparently, the system performs a full table scan to 
-- retrieve the data and sort the retrieved data before 
-- presenting them. The system assesses that the creation
-- of the index does not help or provide a better 
-- operational cost.
--
-- Generate execution plan of a query with a more complex
-- ordering requirement.
explain plan for
select l_orderkey, l_linenumber, l_quantity, l_tax
from lineitem
order by l_quantity, l_tax, l_orderkey, l_linenumber;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- The system performs a full table scan to retrieve the
-- data and sort the retrieved data before presenting them.
-- The system assesses that the created index does not
-- help or provide a better operational cost.
--
-- Next, we create an index that can provide benefit to the
-- query. The index consists of all the attributes that
-- are specified in the ordering requirement.
create index idx2 on lineitem(l_quantity, l_tax, l_orderkey, l_linenumber);
--
-- Generate execution plan after the creation of index idx1
explain plan for
select l_orderkey, l_linenumber, l_quantity, l_tax
from lineitem
order by l_quantity, l_tax, l_orderkey, l_linenumber;
--
-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- The system now assesses that the newly created index provides
-- better operational cost. Hence, the system use the index to
-- retrieve the required data (index full scan), and present the
-- data.

-- Generate execution plan of a query with slight different 
-- variation
explain plan for
select l_linenumber, l_quantity, l_tax
from lineitem
order by l_quantity, l_tax, l_linenumber;
--
-- The output (selected attributes) and the ordering requirements
-- are subset of the index (idx2). The system performs a fast
-- full index scan to retrieve the required data from the index
-- (without accessing the data file), sort the data and present
-- the output.

-- Display the execution plan.
select * from table(dbms_xplan.display);
--
-- Drop the index after the processing
drop index idx1;
drop index idx2;
-- spool off to close the spool
spool off
