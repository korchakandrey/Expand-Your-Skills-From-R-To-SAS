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

*** keep option ***;
data df1_k;
   set df1( keep = col1 col2);
title "Data from &syslast.";
proc print;
***    or by drop option ***;
data df1_d; 
  set df1 ( drop = col3);
title "Data from &syslast.";
proc print; 

*** Both variants produce the same result.***;
*** Also, in SAS you can use semicolon to select all observations that starts with the same srting. ***;

*** keeping all columns between col1 and col3 ***;
data df1_k_betw;
  set df1 ;
  keep col1-col3;
title "Data from &syslast.";
proc print;

*** Selecting all variables that starts with 'col' ***;
data df1_k_st;
  set df1 ;
  keep col: ;
title "Data from &syslast.";
proc print;

*** Creting new Varibles ***;
data df_new_var;
  set df1 nobs=n_obs;
  n_2 = n_obs/2;
  col41 = ifc(_N_ >= n_obs/2,">=n/2","<n/2","missing");
  col1 = col1 + 0.03;
run; 
title "Data from &syslast.";
proc print;


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
