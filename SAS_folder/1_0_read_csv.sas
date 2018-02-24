libname mylib "/folders/myfolders/conf/Library";
filename csv_srs "/folders/myfolders/conf/Library/mental-heath-in-tech-2016_20161114.csv";

proc import datafile = csv_srs
	             out = ds_source
	            dbms = csv replace ;
	guessingrows = MAX ;
	getnames = no  ;
	
run;

/* create code to add first line text as labels to variables */
filename code temp;
data  _null_ ;
  *length label $1000. ;
  file code;
  infile csv_srs obs=1 ;
  input;
  put 'attrib ';

  j = 1 ;
  do i=1 to count(_infile_,',')+1;
    label=scan(_infile_,i,',');
	if index(label,'"') then do;
	    	do while(  countw(label,'"') ne 2 );
	    		i=i+1;
	    		label = strip(label)||','||scan(_infile_,i,',');
	      	end;
    end;
    label = TRANWRD(label,'"','');

    put 'var' j " label='" label +(-1) "'";
	j+1;
   end; 
run;

* apply labels *;
options source2;
proc datasets lib=work nolist;
  modify ds_source;
    %include code;;
  run;
quit;

* list results ;
title 'List Variable Attributes';
proc contents data=work.ds_source;
quit;

title 'Print Variables using Labels as Headers';
proc print data=work.ds_source(obs = 10 firstobs=2 ) label ;
 * var var1-var3;
run;
title;


* Selecting Demographic data;
data mylib.demog;
   set ds_source(
   rename = (
   VAR56 = AGE       
   VAR57 = GENDER    
   VAR58 = COUNTRY   
   VAR59 = US_STATE  
   VAR60 = W_COUNTRY 
   VAR61 = W_US_STATE
   VAR62 = POSITION   
   VAR63 = REMOTELY )) ;
   
   *** Remove first row with labels ***;
   if _N_ = 1 then delete;
    
   keep  AGE GENDER COUNTRY US_STATE W_COUNTRY W_US_STATE POSITION REMOTELY ;
run;
