SQL> SET ECHO ON
SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
SQL> 
--student num 7432628
SQL> 
SQL> CREATE OR REPLACE
  2  		     FUNCTION PartPricing(partKey IN number)
  3  		     return VARCHAR IS
  4  		     --DECLARATIONS
  5  		     maxPrice partsupp.ps_supplycost%TYPE;
  6  		     minPrice partsupp.ps_supplycost%TYPE;
  7  		     maxSuppKey partsupp.ps_suppkey%TYPE;
  8  		     minSuppKey partsupp.ps_suppkey%TYPE;
  9  		     maxSuppName supplier.s_name%TYPE;
 10  		     minSuppName supplier.s_name%TYPE;
 11  		     maxInfo varchar(200);
 12  		     minInfo varchar(200);
 13  
 14  
 15  
 16  		     BEGIN
 17  			     --min price of part item
 18  			     SELECT min(ps_supplycost) into minPrice
 19  			     FROM partsupp
 20  			     WHERE ps_partkey = partKey;
 21  
 22  			     FOR xrow in (
 23  			     SELECT partsupp.ps_suppkey,supplier.s_name
 24  			     FROM partsupp inner join supplier
 25  			     on partsupp.ps_suppkey = supplier.s_suppkey
 26  			     WHERE partsupp.ps_partkey = partKey
 27  			     AND partsupp.ps_supplycost = minPrice)
 28  			     LOOP
 29  
 30  				     minInfo := 'Supplier with the cheapest cost: '||xrow.ps_suppkey||', '||trim(xrow.s_name)||', $'||minPrice;
 31  				     DBMS_OUTPUT.PUT_LINE(minInfo);
 32  
 33  			     END LOOP;
 34  
 35  			     --maxprice of part item
 36  			     SELECT max(ps_supplycost) into maxPrice
 37  			     FROM partsupp
 38  			     WHERE ps_partkey = partKey;
 39  
 40  			     FOR xrow in (
 41  			     SELECT partsupp.ps_suppkey,supplier.s_name
 42  			     FROM partsupp inner join supplier
 43  			     on partsupp.ps_suppkey = supplier.s_suppkey
 44  			     WHERE partsupp.ps_partkey = partKey
 45  			     AND partsupp.ps_supplycost = maxPrice)
 46  			     LOOP
 47  				     maxInfo := 'Supplier with the dearest cost: '||xrow.ps_suppkey||', '||trim(xrow.s_name)||', $'||maxPrice;
 48  				     DBMS_OUTPUT.PUT_LINE(maxInfo);
 49  
 50  			     END LOOP;
 51  
 52  				     return null;
 53  
 54  		     END;
 55  		     /

Function created.

SQL> 
SQL> SELECT partpricing(3753) FROM DUAL;

PARTPRICING(3753)                                                                                   
----------------------------------------------------------------------------------------------------
                                                                                                    

1 row selected.

Supplier with the cheapest cost: 754, Supplier#000000754, $305.95                                   
Supplier with the cheapest cost: 2256, Supplier#000002256, $305.95                                  
Supplier with the dearest cost: 1505, Supplier#000001505, $457.1                                    
SQL> SELECT partpricing(43064) FROM DUAL;

PARTPRICING(43064)                                                                                  
----------------------------------------------------------------------------------------------------
                                                                                                    

1 row selected.

Supplier with the cheapest cost: 1065, Supplier#000001065, $667.3                                   
Supplier with the cheapest cost: 1829, Supplier#000001829, $667.3                                   
Supplier with the dearest cost: 357, Supplier#000000357, $848.13                                    
SQL> SELECT partpricing(57574) FROM DUAL;

PARTPRICING(57574)                                                                                  
----------------------------------------------------------------------------------------------------
                                                                                                    

1 row selected.

Supplier with the cheapest cost: 1344, Supplier#000001344, $172.09                                  
Supplier with the dearest cost: 2882, Supplier#000002882, $791.07                                   
SQL> SELECT partpricing(60000) FROM DUAL;

PARTPRICING(60000)                                                                                  
----------------------------------------------------------------------------------------------------
                                                                                                    

1 row selected.

Supplier with the cheapest cost: 770, Supplier#000000770, $74.55                                    
Supplier with the dearest cost: 2308, Supplier#000002308, $826.35                                   
SQL> 
SQL> SPOOL OFF
