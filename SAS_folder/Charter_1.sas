   *#### SAS code 0001 ####;
data num_char;
	length char1 $1.char2 $2. char3 $3.  ;
    char3 = 100.001;
    char2 = 100;
    char1 = 1;
run;
title " Numeric to Character ";
proc print data=num_char;run;


   *#### SAS code 0002 ####;
data char_num;
	length num1 num2 num3 num4 8 ;
    num4 = "A";
    num3 = "1";
    num2 = "";
    num1 = ".";
run;
title " Character to Numeric";
proc print data=char_num; run;

   *#### SAS code 0003 ####;
data logical;
	length num1 num2 8 char1 char2 $8. ;
    num1 = 1=1;
    num2 = 1=0;

    char1 = 1=1;          
    char2 = 1=0;
      
    put num1= num2= char1= char2= ;
run;

   *#### SAS code 0004 ####;
data into_logical;
	length num1 num2 8 ;
    if 0 then num1 = 0;
    else num1 = 1;
    
    if . then num2 = 0;
    else num2 = 1;

    put num1= num2= ;
run;
