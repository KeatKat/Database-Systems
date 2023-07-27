SQL> SET FEEDBACK ON
SQL> SET LINESIZE 100
SQL> SET PAGESIZE 200
SQL> SET SERVEROUTPUT ON
SQL>
--FOO WHYE KEAT
--7432628
SQL> CREATE OR REPLACE
  2  	     PROCEDURE test3(maxrows IN NUMBER) IS
  3  	     --Declarations
  4  	     counter number;
  5  	     cust_name CUSTOMER.c_name%TYPE;
  6  	     tempcount number;
  7  	     cus_key CUSTOMER.c_custkey%TYPE;
  8  	     ord_key ORDERS.o_orderkey%TYPE;
  9  	     --Delcaring an explicit cursor
 10  	     CURSOR Q IS
 11  		     SELECT c_name
 12  		     FROM (SELECT c_name FROM CUSTOMER ORDER BY c_name)
 13  		     FETCH FIRST maxrows ROWS ONLY;
 14  	     BEGIN
 15  		     tempcount :=1;
 16  		     OPEN Q;
 17  		     LOOP
 18  			     --Taking out customer names from inside the cursor
 19  			     FETCH Q INTO cust_name;
 20  			     EXIT WHEN Q%NOTFOUND;
 21  			     DBMS_OUTPUT.PUT_LINE(tempcount ||' - '|| cust_name || ':');
 22  
 23  			     --Getting customer key from customer name
 24  			     SELECT C_CUSTKEY INTO cus_key
 25  			     FROM CUSTOMER
 26  			     WHERE c_name = cust_name;
 27  			     --Using customer key to get customer oderinformation with an implicit cursor
 28  			     FOR X_ROW IN
 29  				     (SELECT o_orderkey,o_orderdate,o_totalprice
 30  				     FROM ORDERS
 31  				     WHERE o_custkey = cus_key
 32  				     ORDER BY o_totalprice DESC)
 33  			     LOOP
 34  				     DBMS_OUTPUT.PUT_LINE('	     '||X_ROW.o_orderkey||',  '||X_ROW.o_orderdate||',	$'||X_ROW.o_totalprice);
 35  			     END LOOP;
 36  			     --Adding a horizontal break
 37  			     DBMS_OUTPUT.PUT_LINE(chr(10));
 38  
 39  
 40  
 41  
 42  			     tempcount := tempcount + 1;
 43  
 44  		     END LOOP;
 45  		     CLOSE Q;
 46  		     COMMIT;
 47  	     END;
 48  	     /

Procedure created.

SQL> 
SQL> SET SERVEROUTPUT ON
SQL> EXEC TEST3(10);
1 - Customer#000000001:                                                                             
		385825,  01-NOV-95,  $254563.49                                                                   
		1374019,  05-APR-92,  $189636                                                                     
		1071617,  10-MAR-95,  $156748.63                                                                  
		454791,  19-APR-92,  $78172.7                                                                     
		1590469,  07-MAR-97,  $59936.41                                                                   
		579908,  09-DEC-96,  $43874.94                                                                    
		430243,  24-DEC-94,  $37713.17                                                                    
		1763205,  28-AUG-94,  $18112.74                                                                   
		1755398,  12-JUN-97,  $1466.82                                                                    

                                                                                                   
2 - Customer#000000002:                                                                             
		164711,  26-APR-92,  $311344.63                                                                   
		905633,  05-JUL-95,  $255261.98                                                                   
		135943,  22-JUN-93,  $249828.07                                                                   
		1485505,  24-JUL-98,  $230389.81                                                                  
		1192231,  03-JUN-96,  $100551.33                                                                  
		224167,  08-MAY-96,  $85477.93                                                                    
		1226497,  04-OCT-93,  $81926.5                                                                    
		287619,  26-DEC-96,  $16946.76                                                                    

                                                                                                   
3 - Customer#000000003:                                                                             

                                                                                                   
4 - Customer#000000004:                                                                             
		9154,  23-JUN-97,  $336929.37                                                                     
		36422,  04-MAR-97,  $266881.39                                                                    
		816323,  23-JAN-96,  $265441.63                                                                   
		1603585,  26-MAR-97,  $243002.67                                                                  
		306439,  17-MAY-97,  $234026.8                                                                    
		895172,  04-DEC-95,  $229991.06                                                                   
		916775,  26-APR-96,  $215744.35                                                                   
		1406820,  24-FEB-96,  $195275.97                                                                  
		835173,  18-AUG-93,  $187151.5                                                                    
		1490087,  10-JUL-96,  $177431.73                                                                  
		1201223,  13-JAN-96,  $155250.48                                                                  
		491620,  22-MAY-98,  $154443.2                                                                    
		212870,  30-OCT-96,  $152662.65                                                                   
		1718016,  30-AUG-94,  $123028.08                                                                  
		859108,  20-FEB-96,  $105414.33                                                                   
		1073670,  24-MAY-94,  $76478.32                                                                   
		869574,  21-JAN-98,  $58714.84                                                                    
		883557,  30-MAR-98,  $44043.89                                                                    
		1774689,  08-JUL-93,  $15444.64                                                                   

                                                                                                   
5 - Customer#000000005:                                                                             
		374723,  20-NOV-96,  $241348.35                                                                   
		1572644,  01-JUN-98,  $201565.95                                                                  
		1478917,  06-OCT-92,  $187297.1                                                                   
		1521157,  23-AUG-97,  $141934.18                                                                  
		269922,  19-MAR-96,  $122008.56                                                                   
		1177350,  03-JUL-97,  $47596.96                                                                   

                                                                                                   
6 - Customer#000000006:                                                                             

                                                                                                   
7 - Customer#000000007:                                                                             
		639490,  27-OCT-95,  $257430.05                                                                   
		1543201,  16-JUN-98,  $251847.08                                                                  
		120160,  09-APR-95,  $230515.14                                                                   
		1737250,  08-OCT-94,  $219473.63                                                                  
		1709703,  16-JUN-95,  $214731.25                                                                  
		360067,  07-DEC-92,  $202306.9                                                                    
		854375,  16-SEP-93,  $166739.95                                                                   
		686918,  21-AUG-92,  $166685.89                                                                   
		1591941,  07-FEB-97,  $152592.5                                                                   
		1428645,  30-AUG-92,  $117401.52                                                                  
		655010,  10-MAR-95,  $112390.97                                                                   
		792900,  11-JUL-95,  $108941.3                                                                    
		1074979,  18-APR-92,  $107560.21                                                                  
		1646340,  11-JUL-98,  $106837.29                                                                  
		90019,  28-OCT-93,  $96289.27                                                                     
		653063,  11-MAR-95,  $71401.86                                                                    
		100064,  10-APR-96,  $66170.58                                                                    
		83684,  19-MAR-98,  $62562.97                                                                     
		346693,  13-NOV-93,  $61095.93                                                                    
		52263,  08-MAY-94,  $31541.66                                                                     

                                                                                                   
8 - Customer#000000008:                                                                             
		1168417,  12-OCT-96,  $305211.17                                                                  
		330404,  22-SEP-96,  $274085.79                                                                   
		1037540,  18-FEB-92,  $223700                                                                     
		1597121,  14-APR-92,  $162736.15                                                                  
		1247233,  16-JUN-92,  $158071.98                                                                  
		1495106,  09-JAN-97,  $136488.73                                                                  
		512195,  13-AUG-96,  $49949.25                                                                    
		737345,  29-AUG-96,  $46947.1                                                                     
		345858,  15-JUN-98,  $28502.44                                                                    

                                                                                                   
9 - Customer#000000009:                                                                             

                                                                                                   
10 - Customer#000000010:                                                                            
		576263,  02-MAR-94,  $305090.33                                                                   
		601794,  10-DEC-96,  $299434.02                                                                   
		1008069,  30-SEP-95,  $297638.44                                                                  
		1693984,  20-MAR-96,  $292309.5                                                                   
		1252005,  14-JAN-92,  $276419.89                                                                  
		193030,  09-JUN-92,  $271294.63                                                                   
		24322,  29-JAN-97,  $236185.46                                                                    
		70819,  20-NOV-96,  $227239.98                                                                    
		235779,  29-APR-94,  $217979.21                                                                   
		1115366,  23-JUL-96,  $217829.29                                                                  
		1550053,  01-NOV-93,  $186264.34                                                                  
		545218,  16-JUL-92,  $167908.99                                                                   
		160516,  18-SEP-95,  $166166.04                                                                   
		787105,  28-MAY-94,  $165347.84                                                                   
		681730,  11-AUG-93,  $157799.93                                                                   
		1469089,  21-JUL-93,  $152015.57                                                                  
		641253,  24-MAY-95,  $133056.09                                                                   
		1186787,  22-FEB-95,  $116513.38                                                                  
		1526534,  01-JUN-95,  $114744.47                                                                  
		226818,  13-MAY-95,  $100503.07                                                                   
		43879,  13-AUG-93,  $91561.86                                                                     
		823525,  22-AUG-97,  $89449.24                                                                    
		1783941,  12-JUL-95,  $49019.1                                                                    
		529350,  03-MAR-96,  $39699.77                                                                    
		1576097,  20-MAY-98,  $19333.5                                                                    
		1243748,  28-MAR-96,  $4894.81                                                                    

                                                                                                   

PL/SQL procedure successfully completed.

SQL> 
SQL> SPOOL OFF
