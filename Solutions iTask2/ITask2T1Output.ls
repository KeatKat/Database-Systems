SQL> SET ECHO ON
SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
SQL> 
SQL> --i
SQL> explain plan for
  2  select l_discount
  3  from lineitem
  4  where l_shipdate =
  5  		     (select max(l_shipdate)
  6  		     from lineitem);

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 4120815904                                                                         
                                                                                                    
--------------------------------------------------------------------------------                    
| Id  | Operation           | Name     | Rows  | Bytes | Cost (%CPU)| Time     |                    
--------------------------------------------------------------------------------                    
|   0 | SELECT STATEMENT    |          |   713 |  7843 | 24309   (1)| 00:00:01 |                    
|*  1 |  TABLE ACCESS FULL  | LINEITEM |   713 |  7843 | 12155   (1)| 00:00:01 |                    
|   2 |   SORT AGGREGATE    |          |     1 |     8 |            |          |                    
|   3 |    TABLE ACCESS FULL| LINEITEM |  1800K|    13M| 12153   (1)| 00:00:01 |                    
--------------------------------------------------------------------------------                    
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - filter("L_SHIPDATE"= (SELECT MAX("L_SHIPDATE") FROM "LINEITEM"                               
              "LINEITEM"))                                                                          

16 rows selected.

SQL> 
SQL> --ii
SQL> explain plan for
  2  select count(*)
  3  from lineitem
  4  where extract(year from l_shipdate) = 1998
  5  and l_shipmode = 'AIR';

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 2287326370                                                                         
                                                                                                    
-------------------------------------------------------------------------------                     
| Id  | Operation          | Name     | Rows  | Bytes | Cost (%CPU)| Time     |                     
-------------------------------------------------------------------------------                     
|   0 | SELECT STATEMENT   |          |     1 |    19 | 12175   (1)| 00:00:01 |                     
|   1 |  SORT AGGREGATE    |          |     1 |    19 |            |          |                     
|*  2 |   TABLE ACCESS FULL| LINEITEM |  2579 | 49001 | 12175   (1)| 00:00:01 |                     
-------------------------------------------------------------------------------                     
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - filter("L_SHIPMODE"='AIR' AND EXTRACT(YEAR FROM                                              
              INTERNAL_FUNCTION("L_SHIPDATE"))=1998)                                                

15 rows selected.

SQL> 
SQL> --iii
SQL> explain plan for
  2  select l_orderkey, l_linenumber, l_discount
  3  from lineitem
  4  where l_discount in
  5  (select max(l_discount)
  6   from lineitem);

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 4120815904                                                                         
                                                                                                    
--------------------------------------------------------------------------------                    
| Id  | Operation           | Name     | Rows  | Bytes | Cost (%CPU)| Time     |                    
--------------------------------------------------------------------------------                    
|   0 | SELECT STATEMENT    |          |   163K|  1917K| 24301   (1)| 00:00:01 |                    
|*  1 |  TABLE ACCESS FULL  | LINEITEM |   163K|  1917K| 12152   (1)| 00:00:01 |                    
|   2 |   SORT AGGREGATE    |          |     1 |     3 |            |          |                    
|   3 |    TABLE ACCESS FULL| LINEITEM |  1800K|  5273K| 12149   (1)| 00:00:01 |                    
--------------------------------------------------------------------------------                    
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - filter("L_DISCOUNT"= (SELECT MAX("L_DISCOUNT") FROM "LINEITEM"                               
              "LINEITEM"))                                                                          

16 rows selected.

SQL> 
SQL> --iv
SQL> explain plan for
  2  select l_linestatus, count(l_linestatus)
  3  from lineitem
  4  group by l_linestatus;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1773397105                                                                         
                                                                                                    
-------------------------------------------------------------------------------                     
| Id  | Operation          | Name     | Rows  | Bytes | Cost (%CPU)| Time     |                     
-------------------------------------------------------------------------------                     
|   0 | SELECT STATEMENT   |          |     2 |     4 | 12198   (1)| 00:00:01 |                     
|   1 |  HASH GROUP BY     |          |     2 |     4 | 12198   (1)| 00:00:01 |                     
|   2 |   TABLE ACCESS FULL| LINEITEM |  1800K|  3515K| 12152   (1)| 00:00:01 |                     
-------------------------------------------------------------------------------                     

9 rows selected.

SQL> 
SQL> 
SQL> --v
SQL> explain plan for
  2  select l_orderkey, l_linenumber, l_linestatus, l_shipdate, l_shipmode
  3  from lineitem
  4  where l_orderkey = 1795718 or l_orderkey = 1799046 or l_orderkey = 1794626;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 2007773388                                                                         
                                                                                                    
----------------------------------------------------------------------------------------------------
--                                                                                                  
                                                                                                    
| Id  | Operation                            | Name          | Rows  | Bytes | Cost (%CPU)| Time    
 |                                                                                                  
                                                                                                    
----------------------------------------------------------------------------------------------------
--                                                                                                  
                                                                                                    
|   0 | SELECT STATEMENT                     |               |    12 |   360 |     6   (0)| 00:00:01
 |                                                                                                  
                                                                                                    
|   1 |  INLIST ITERATOR                     |               |       |       |            |         
 |                                                                                                  
                                                                                                    
|   2 |   TABLE ACCESS BY INDEX ROWID BATCHED| LINEITEM      |    12 |   360 |     6   (0)| 00:00:01
 |                                                                                                  
                                                                                                    
|*  3 |    INDEX RANGE SCAN                  | LINEITEM_PKEY |    12 |       |     5   (0)| 00:00:01
 |                                                                                                  
                                                                                                    
----------------------------------------------------------------------------------------------------
--                                                                                                  
                                                                                                    
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   3 - access("L_ORDERKEY"=1794626 OR "L_ORDERKEY"=1795718 OR "L_ORDERKEY"=1799046)                 

15 rows selected.

SQL> 
SQL> --Creating indexes
SQL> create index idx1 on lineitem(l_discount,l_shipdate,extract(year from l_shipdate),l_shipmode,l_linestatus);

Index created.

SQL> 
SQL> create index idx2 on lineitem(l_orderkey, l_linenumber, l_linestatus, l_shipdate, l_shipmode);

Index created.

SQL> ------------------------------------------
SQL> ------------------------------------------
SQL> ------------------------------------------
SQL> --After creating index
SQL> --i
SQL> explain plan for
  2  select l_discount
  3  from lineitem
  4  where l_shipdate =
  5  		     (select max(l_shipdate)
  6  		     from lineitem);

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1019311808                                                                         
                                                                                                    
-------------------------------------------------------------------------------                     
| Id  | Operation              | Name | Rows  | Bytes | Cost (%CPU)| Time     |                     
-------------------------------------------------------------------------------                     
|   0 | SELECT STATEMENT       |      |   713 |  7843 |  7346   (1)| 00:00:01 |                     
|*  1 |  INDEX FAST FULL SCAN  | IDX1 |   713 |  7843 |  3674   (1)| 00:00:01 |                     
|   2 |   SORT AGGREGATE       |      |     1 |     8 |            |          |                     
|   3 |    INDEX FAST FULL SCAN| IDX1 |  1800K|    13M|  3672   (1)| 00:00:01 |                     
-------------------------------------------------------------------------------                     
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - filter("L_SHIPDATE"= (SELECT MAX("L_SHIPDATE") FROM "LINEITEM"                               
              "LINEITEM"))                                                                          

16 rows selected.

SQL> 
SQL> --ii
SQL> explain plan for
  2  select count(*)
  3  from lineitem
  4  where extract(year from l_shipdate) = 1998
  5  and l_shipmode = 'AIR';

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 325870156                                                                          
                                                                                                    
------------------------------------------------------------------------------                      
| Id  | Operation             | Name | Rows  | Bytes | Cost (%CPU)| Time     |                      
------------------------------------------------------------------------------                      
|   0 | SELECT STATEMENT      |      |     1 |    24 |  3689   (1)| 00:00:01 |                      
|   1 |  SORT AGGREGATE       |      |     1 |    24 |            |          |                      
|*  2 |   INDEX FAST FULL SCAN| IDX1 |  2579 | 61896 |  3689   (1)| 00:00:01 |                      
------------------------------------------------------------------------------                      
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - filter("L_SHIPMODE"='AIR' AND EXTRACT(YEAR FROM                                              
              INTERNAL_FUNCTION("L_SHIPDATE"))=1998)                                                

15 rows selected.

SQL> 
SQL> --iii
SQL> explain plan for
  2  select l_orderkey, l_linenumber, l_discountSS
  3  from lineitem
  4  where l_discount in
  5  (select max(l_discount)
  6   from lineitem);
select l_orderkey, l_linenumber, l_discountSS
                                 *
ERROR at line 2:
ORA-00904: "L_DISCOUNTSS": invalid identifier 


SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 325870156                                                                          
                                                                                                    
------------------------------------------------------------------------------                      
| Id  | Operation             | Name | Rows  | Bytes | Cost (%CPU)| Time     |                      
------------------------------------------------------------------------------                      
|   0 | SELECT STATEMENT      |      |     1 |    24 |  3689   (1)| 00:00:01 |                      
|   1 |  SORT AGGREGATE       |      |     1 |    24 |            |          |                      
|*  2 |   INDEX FAST FULL SCAN| IDX1 |  2579 | 61896 |  3689   (1)| 00:00:01 |                      
------------------------------------------------------------------------------                      
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - filter("L_SHIPMODE"='AIR' AND EXTRACT(YEAR FROM                                              
              INTERNAL_FUNCTION("L_SHIPDATE"))=1998)                                                

15 rows selected.

SQL> 
SQL> --iv
SQL> explain plan for
  2  select l_linestatus, count(l_linestatus)
  3  from lineitem
  4  group by l_linestatus;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 4058097160                                                                         
                                                                                                    
------------------------------------------------------------------------------                      
| Id  | Operation             | Name | Rows  | Bytes | Cost (%CPU)| Time     |                      
------------------------------------------------------------------------------                      
|   0 | SELECT STATEMENT      |      |     2 |     4 |  3718   (2)| 00:00:01 |                      
|   1 |  HASH GROUP BY        |      |     2 |     4 |  3718   (2)| 00:00:01 |                      
|   2 |   INDEX FAST FULL SCAN| IDX1 |  1800K|  3515K|  3672   (1)| 00:00:01 |                      
------------------------------------------------------------------------------                      

9 rows selected.

SQL> 
SQL> 
SQL> --v
SQL> explain plan for
  2  select l_orderkey, l_linenumber, l_linestatus, l_shipdate, l_shipmode
  3  from lineitem
  4  where l_orderkey = 1795718 or l_orderkey = 1799046 or l_orderkey = 1794626;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1787203470                                                                         
                                                                                                    
--------------------------------------------------------------------------                          
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |                          
--------------------------------------------------------------------------                          
|   0 | SELECT STATEMENT  |      |    12 |   360 |     5   (0)| 00:00:01 |                          
|   1 |  INLIST ITERATOR  |      |       |       |            |          |                          
|*  2 |   INDEX RANGE SCAN| IDX2 |    12 |   360 |     5   (0)| 00:00:01 |                          
--------------------------------------------------------------------------                          
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   2 - access("L_ORDERKEY"=1794626 OR "L_ORDERKEY"=1795718 OR                                       
              "L_ORDERKEY"=1799046)                                                                 

15 rows selected.

SQL> 
SQL> drop index idx1;

Index dropped.

SQL> drop index idx2;

Index dropped.

SQL> 
SQL> spool off