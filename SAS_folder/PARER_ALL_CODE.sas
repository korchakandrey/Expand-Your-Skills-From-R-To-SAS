*** ## Table 1 - reading text data in. ;
**** 1.	Getting data **** ;
data df1;
	input col1 col2 $ col3 ;
	datalines;
1 a 1
2 b 1
3 c 0
;
run;
title "Data from &syslast.";
proc print data=df1;
run;
proc contents data=df1;
run;


*** ## Table 2 - reading CSV data in. ;
libname mylib "/folders/myfolders/conf/Library";
filename csv_srs "/folders/myfolders/conf/Library/mental-heath-in-tech-2016_20161114.csv";

*** We cannot read columns names - we are reading only data. ***; 
proc import datafile = csv_srs
	             out = raw_ds
	            dbms = csv replace ;
	guessingrows = MAX ;
	getnames = no  ;
	datarow=2;	
run;

*** To apply meaningful labels we are reading first row, and saving it into the temporary text file ***;
filename code temp;
data  _NULL_ ;
  file code;
  infile csv_srs DELIMITER=',' DSD  obs=1 ;
  input label :$200. @@ ;
  put 'var' _N_ " label='" label  "'";
run;

* apply labels *;
options source2;
proc datasets lib=work ;
  modify raw_ds;
    attrib %include code;;
  run;
quit;

* list results *;
title 'List Variable Attributes';
proc contents data=raw_ds;
quit;

* Selecting Demographic data;
data mylib.demog2;
   set raw_ds(
   rename = (
   VAR56 = AGE       
   VAR57 = GENDER    
   VAR58 = COUNTRY   
   VAR59 = US_STATE  
   VAR60 = W_COUNTRY 
   VAR61 = W_US_STATE
   VAR62 = POSITION   
   VAR63 = REMOTELY
   VAR4  = IT_ROLE)) ;
   
   keep  AGE GENDER COUNTRY US_STATE W_COUNTRY W_US_STATE POSITION REMOTELY IT_ROLE ;
run;

%macro dummy;
*** Typical Data Flow Example **;
proc sort data = row_data;
	by BY_VAR1 descending BY_VAR2;
	where STAT ~="NOT DONE";
run;

data output_ds ( drop = ( VAR1 ) );
	set row_data (  keep = ( BY_VAR1  BY_VAR2 VAR1 )
	              rename = ( LOG_VAR1 = AVAL )
                 );
	by BY_VAR1 descending BY_VAR2;
	
	if first.BY_VAR1 then BFL = "Y" ;
	
	LOG_VAR1 = log( VAR1 );
run;
%mend dummy;

*** Example 2.2.1 ***;
*** keep option ***;
data df1_k;
   set df1( keep = col1 col2);
run;
title "Data from &syslast.";
proc print;
run;
***    or by drop option ***;
data df1_d; 
  set df1 ( drop = col3);
run;
title "Data from &syslast.";
proc print; 
run;
*** keeping all columns between col1 and col3 ***;
data df1_k_betw;
  set df1 ;
  keep col1-col3;
run;
title "Data from &syslast.";
proc print;
run;
*** Selecting all variables that starts with 'col' ***;
data df1_k_st;
  set df1 ;
  keep col: ;
run;
title "Data from &syslast.";
proc print data = df1_k_st;
run;

*** Renaming variables ***;
data df1_rename ;
  set df1 ;
  rename col1 = Column1;
run;
title "Data from &syslast.";
proc print data = df1_rename;
run;

*** Filtering data ***;
data df1_i;
  set df1;
  if col3 = 1 and col2 = "a";
run;
title "Data from &syslast.";
proc print ;
run;

*** or use WHERE statement ***;
data df1_w;
  set df1;
  where col3 = 1;
run;
***Both variants produce the same result but WHERE may be faster.***;
title "Data from &syslast.";
proc print;
run;


*** 2.4 Crreating new variables ***;
*** Creting new Varibles ***;
data df_new_var;
  set df1 nobs=n_obs;
  n_2 = n_obs/2;
  col41 = ifc(_N_ >= n_obs/2,">=n/2","<n/2","missing");
  col1 = col1 + 0.03;
run; 
title "Data from &syslast.";
proc print;
run;


********* Grouping Variables ***;
data df2;
	input SUBJID $ TEST1 TEST2 PERIOD ;
	TEST = mean(TEST1, TEST2 );
	
	datalines;
S1 10 . 1	
S1 8  7 2	
S2 7 4 1	
S2 5 3 2	
;
run;
title "Data from &syslast.";
proc print;

proc means data = df2;
	var TEST;
	by SUBJID;
run;


**** LAG function *******************;
data ;
	set df2 ( keep = SUBJID TEST1);
	by SUBJID;
	
	LAG_TEST1 = lag( TEST1 );
	if first.SUBJID then LAG_TEST1 = .;
run;
title "Lag in SAS, Data from &syslast.";
proc print;

**** Creating Another dataset ***;
data df_add_info ;
	input SUBJID $  NAME $;
	datalines;
S1 Nick
S2 Cate 
S3 Josh 
;
run;
title  "Creating Dataset with";
title2 " Names, Data from &syslast.";
proc print;

data df_test_name ;
	merge df2        ( in = in_x )
	      df_add_info( in = in_y );
	by SUBJID ;
	* inner join;
	if in_x and in_y ;
	keep TEST NAME ;
run;
title  "Combined Data Set,";
title1 "Data from &syslast.";
proc print;
run;
