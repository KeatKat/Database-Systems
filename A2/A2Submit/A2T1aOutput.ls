SQL> SET ECHO ON
SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
SQL> 
--student num 7432628
SQL> --i
SQL> create index idx1 on part(p_brand,p_type,p_retailprice);

Index created.

SQL> explain plan for
  2  SELECT p_brand, p_type, p_retailprice
  3  FROM part;

Explained.

SQL> 
SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1517492816                                                                         
                                                                                                    
-----------------------------------------------------------------------------                       
| Id  | Operation            | Name | Rows  | Bytes | Cost (%CPU)| Time     |                       
-----------------------------------------------------------------------------                       
|   0 | SELECT STATEMENT     |      | 60000 |  2226K|   154   (0)| 00:00:01 |                       
|   1 |  INDEX FAST FULL SCAN| IDX1 | 60000 |  2226K|   154   (0)| 00:00:01 |                       
-----------------------------------------------------------------------------                       

8 rows selected.

SQL> 
SQL> drop index idx1;

Index dropped.

SQL> --index fast full scan used after indexing
SQL> --no where condition
SQL> ---------------------------------------------------------------------------
SQL> --ii
SQL> create index idx2 on part(p_brand);

Index created.

SQL> explain plan for
  2  SELECT count(*)
  3  FROM part
  4  WHERE p_brand = 'Brand#18';

Explained.

SQL> 
SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 2399724746                                                                         
                                                                                                    
--------------------------------------------------------------------------                          
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |                          
--------------------------------------------------------------------------                          
|   0 | SELECT STATEMENT  |      |     1 |    11 |     8   (0)| 00:00:01 |                          
|   1 |  SORT AGGREGATE   |      |     1 |    11 |            |          |                          
|*  2 |   INDEX RANGE SCAN| IDX2 |  2400 | 26400 |     8   (0)| 00:00:01 |                          
--------------------------------------------------------------------------                          
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - access("P_BRAND"='Brand#18')                                                                 

14 rows selected.

SQL> drop index idx2;

Index dropped.

SQL> --index range scan is used, vertical to find p_brand and horizontal to find
SQL> --other p_brand of the same value
SQL> --------------------------------------------------------------------------
SQL> --iii
SQL> explain plan for
  2  SELECT l_orderkey, count(*)
  3  FROM lineitem
  4  WHERE l_orderkey = 1184000
  5  GROUP BY l_orderkey;

Explained.

SQL> 
SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 3450900732                                                                         
                                                                                                    
--------------------------------------------------------------------------------------              
| Id  | Operation            | Name          | Rows  | Bytes | Cost (%CPU)| Time     |              
--------------------------------------------------------------------------------------              
|   0 | SELECT STATEMENT     |               |     4 |    24 |     3   (0)| 00:00:01 |              
|   1 |  SORT GROUP BY NOSORT|               |     4 |    24 |     3   (0)| 00:00:01 |              
|*  2 |   INDEX RANGE SCAN   | LINEITEM_PKEY |     4 |    24 |     3   (0)| 00:00:01 |              
--------------------------------------------------------------------------------------              
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - access("L_ORDERKEY"=1184000)                                                                 

14 rows selected.

SQL> 
SQL> --performance will not suffer as l_orderkey is already part of the primary key
SQL> --in the table lineitem. So an index is already created automatically on l_orderkey
SQL> --by the dbms. Even if a new index on l_orderkey is created, the execution plan will remain
SQL> --the same, which is an index range scan due to the where and group by clause.
SQL> --------------------------------------------------------------------------
SQL> --iv
SQL> create index idx4 on partsupp(ps_suppkey);

Index created.

SQL> explain plan for
  2  SELECT max(ps_suppkey)
  3  FROM partsupp;

Explained.

SQL> 
SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 620238679                                                                          
                                                                                                    
-----------------------------------------------------------------------------------                 
| Id  | Operation                  | Name | Rows  | Bytes | Cost (%CPU)| Time     |                 
-----------------------------------------------------------------------------------                 
|   0 | SELECT STATEMENT           |      |     1 |     4 |     2   (0)| 00:00:01 |                 
|   1 |  SORT AGGREGATE            |      |     1 |     4 |            |          |                 
|   2 |   INDEX FULL SCAN (MIN/MAX)| IDX4 |     1 |     4 |     2   (0)| 00:00:01 |                 
-----------------------------------------------------------------------------------                 

9 rows selected.

SQL> drop index idx4;

Index dropped.

SQL> 
SQL> --even though ps_suppkey is a primary key, creating an index on ps_suppkey
SQL> --allows the dbms to execute a index full scan and stop the moment it find the max(ps_suppkey)
SQL> --as opposed to the fast full scan where it will read all the records of ps_suppkey
SQL> --It is due to the max function that creating an index will boost the performance
SQL> --------------------------------------------------------------------------
SQL> --v
SQL> create index idx5 on partsupp(ps_suppkey,ps_partkey,ps_supplycost);
create index idx5 on partsupp(ps_suppkey,ps_partkey,ps_supplycost)
             *
ERROR at line 1:
ORA-00955: name is already used by an existing object 


SQL> explain plan for
  2  SELECT ps_suppkey, ps_partkey, ps_supplycost
  3  FROM partsupp
  4  WHERE ps_suppkey = 3699
  5  AND ps_partkey = 700;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1371259344                                                                         
                                                                                                    
-------------------------------------------------------------------------                           
| Id  | Operation        | Name | Rows  | Bytes | Cost (%CPU)| Time     |                           
-------------------------------------------------------------------------                           
|   0 | SELECT STATEMENT |      |     1 |    14 |     3   (0)| 00:00:01 |                           
|*  1 |  INDEX RANGE SCAN| IDX5 |     1 |    14 |     3   (0)| 00:00:01 |                           
-------------------------------------------------------------------------                           
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - access("PS_SUPPKEY"=3699 AND "PS_PARTKEY"=700)                                               

13 rows selected.

SQL> drop index idx5;

Index dropped.

SQL> --range scan after indexing, vertical to find the where clause attribute values
SQL> --then horizontal to find others that match
SQL> 
SQL> spool off
