SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
SQL> 
SQL> --student num 7432628
SQL> 
SQL> --i
SQL> --vertical then horizontal, does not access relational table
SQL> --range scan on indexed attribute
SQL> explain plan for
  2  select ps_partkey
  3  from partsupp
  4  where ps_partkey < 50;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1101423515                                                                         
                                                                                                    
----------------------------------------------------------------------------------                  
| Id  | Operation        | Name          | Rows  | Bytes | Cost (%CPU)| Time     |                  
----------------------------------------------------------------------------------                  
|   0 | SELECT STATEMENT |               |   196 |   980 |     3   (0)| 00:00:01 |                  
|*  1 |  INDEX RANGE SCAN| PARTSUPP_PKEY |   196 |   980 |     3   (0)| 00:00:01 |                  
----------------------------------------------------------------------------------                  
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - access("PS_PARTKEY"<50)                                                                      

13 rows selected.

SQL> ------------------------------------------------------------------------------------
SQL> --ii
SQL> --vertical then horizontal, access relational table
SQL> --range scan on unindexed attribute
SQL> explain plan for
  2  select ps_availqty
  3  from partsupp
  4  where ps_availqty < 50;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1162167413                                                                         
                                                                                                    
------------------------------------------------------------------------------                      
| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |                      
------------------------------------------------------------------------------                      
|   0 | SELECT STATEMENT  |          |  1176 |  4704 |  1856   (1)| 00:00:01 |                      
|*  1 |  TABLE ACCESS FULL| PARTSUPP |  1176 |  4704 |  1856   (1)| 00:00:01 |                      
------------------------------------------------------------------------------                      
                                                                                                    
Predicate Information (identified by operation id):                                                 
---------------------------------------------------                                                 
                                                                                                    
   1 - filter("PS_AVAILQTY"<50)                                                                     

13 rows selected.

SQL> ------------------------------------------------------------------------------------
SQL> --iii
SQL> --horizontal, does not access relational table
SQL> --fast full index scan on indexed attribute without any conditions
SQL> explain plan for
  2  select ps_partkey
  3  from partsupp;

Explained.

SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 2608718660                                                                         
                                                                                                    
--------------------------------------------------------------------------------------              
| Id  | Operation            | Name          | Rows  | Bytes | Cost (%CPU)| Time     |              
--------------------------------------------------------------------------------------              
|   0 | SELECT STATEMENT     |               |   240K|  1171K|   322   (1)| 00:00:01 |              
|   1 |  INDEX FAST FULL SCAN| PARTSUPP_PKEY |   240K|  1171K|   322   (1)| 00:00:01 |              
--------------------------------------------------------------------------------------              

8 rows selected.

SQL> ------------------------------------------------------------------------------------
SQL> --iv
SQL> --horizonal,access relational table
SQL> --index full scan of a function on indexed value
SQL> explain plan for
  2  select (ps_partkey)
  3  from partsupp
  4  order by ps_partkey;

Explained.

SQL> 
SQL> select * from table(dbms_xplan.display);

PLAN_TABLE_OUTPUT                                                                                   
----------------------------------------------------------------------------------------------------
Plan hash value: 1882633664                                                                         
                                                                                                    
----------------------------------------------------------------------------------                  
| Id  | Operation        | Name          | Rows  | Bytes | Cost (%CPU)| Time     |                  
----------------------------------------------------------------------------------                  
|   0 | SELECT STATEMENT |               |   240K|  1171K|   855   (1)| 00:00:01 |                  
|   1 |  INDEX FULL SCAN | PARTSUPP_PKEY |   240K|  1171K|   855   (1)| 00:00:01 |                  
----------------------------------------------------------------------------------                  

8 rows selected.

SQL> SPOOL OFF;
