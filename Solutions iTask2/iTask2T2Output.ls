SQL> SET ECHO ON
SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
--FOO WHYE KEAT
--7432628
SQL> 
SQL> 
SQL> 
SQL> 
SQL> 
SQL> CREATE OR REPLACE
  2  	     FUNCTION numOfOrders(custName IN VARCHAR2)
  3  	     RETURN VARCHAR IS order_info VARCHAR(200);
  4  
  5  		     --Declarations
  6  		     customer_key    CUSTOMER.c_custkey%TYPE;
  7  		     order_key	     ORDERS.o_orderkey%TYPE;
  8  
  9  	     BEGIN
 10  		     SELECT c_custkey INTO customer_key
 11  		     FROM CUSTOMER
 12  		     WHERE c_name = custName;
 13  
 14  		     SELECT count(o_orderkey) INTO order_key
 15  		     FROM ORDERS
 16  		     WHERE o_custkey = customer_key;
 17  
 18  
 19  		     order_info := customer_key||' '||custName||' '||order_key;
 20  		     RETURN order_info;
 21  	     END;
 22  	     /

Function created.

SQL> 
SQL> --Examples
SQL> SELECT numOfOrders('Customer#000038021') from dual;

NUMOFORDERS('CUSTOMER#000038021')                                                                   
----------------------------------------------------------------------------------------------------
38021 Customer#000038021 9                                                                          

1 row selected.

SQL> SELECT numOfOrders('Customer#000038249') from dual;

NUMOFORDERS('CUSTOMER#000038249')                                                                   
----------------------------------------------------------------------------------------------------
38249 Customer#000038249 11                                                                         

1 row selected.

SQL> SELECT numOfOrders('Customer#000038483') from dual;

NUMOFORDERS('CUSTOMER#000038483')                                                                   
----------------------------------------------------------------------------------------------------
38483 Customer#000038483 8                                                                          

1 row selected.

SQL> SELECT numOfOrders('Customer#000041710') from dual;

NUMOFORDERS('CUSTOMER#000041710')                                                                   
----------------------------------------------------------------------------------------------------
41710 Customer#000041710 20                                                                         

1 row selected.

SQL> SELECT numOfOrders('Customer#000044188') from dual;

NUMOFORDERS('CUSTOMER#000044188')                                                                   
----------------------------------------------------------------------------------------------------
44188 Customer#000044188 21                                                                         

1 row selected.

SQL> SELECT numOfOrders('Customer#000044918') from dual;

NUMOFORDERS('CUSTOMER#000044918')                                                                   
----------------------------------------------------------------------------------------------------
44918 Customer#000044918 8                                                                          

1 row selected.

SQL> SPOOL OFF
