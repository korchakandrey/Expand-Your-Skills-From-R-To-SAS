libname mylib " /folders/myfolders/conf/Library";

***Starting transforming our data ***;
data transform1/* ( drop = GENDER_O GENDER_M GENDER_F gender_l AGE GENDER )*/
     data_position_long( drop = GENDER_O GENDER_M GENDER_F gender_l AGE GENDER );
	
	set mylib.demog2;
	
	*** Converting Character Age into numeric values ***;
	AGEN = input(AGE, best.);
    if AGEN > 90 or AGEN < 10 then AGEN = . ;
    
	*** Converting Free-Text Gender into 3 groups ***;
	* all data into lower case to reduce diversity *;
	gender_l = lowcase(GENDER);

	length GENDER_O GENDER_M GENDER_F GENDER_C $10. ;

	if gender_l in ( "male (cis)","cis man","cis male","cis male","sex is male","male.","cis male","man","male","guy","cisdude", "dude", "dude", "m", "ml", "m|", "mail", "malr") 
	or gender_l = "i'm a man why didn't you make this a drop down question. you should of asked sex? and i would of answered yes please. seriously how much text can this take?" 
	   then GENDER_M = "Male";

    if gender_l in ("cis female","female assigned at birth","woman","female","female","i identify as female.","female or multi-gender femme","female/woman","cisgender female"," female","female (props for making this a freeform field, though)","f", "fem","fm","female-bodied; no feelings about gender","cis-woman")
    	then GENDER_F = "Female";

	if gender_l in ("genderflux demi-girl","bigender","non-binary","transitioned, m2f","genderfluid (born female)","other/transfeminine","androgynous","male 9:1 female, roughly","n/a","other","nb masculine","none of your business","genderqueer","human","genderfluid","enby","genderqueer woman","mtf","queer","agender","fluid","male/genderqueer","nonbinary","unicorn","male (trans, ftm)","afab","transgender woman" ) 
		then GENDER_O = "Other";
	
	* Checking if data mapped correctly *;
	if cmiss(GENDER_O, GENDER_M, GENDER_F) = 1 then put "WARN" "NING: Wrong mapping" GENDER_O= GENDER_M= GENDER_F= gender_l= ;
	if cmiss(GENDER_O, GENDER_M, GENDER_F) = 3 and not missing( gender_l ) 
	   then put "WARN" "NING: Wrong mapping" GENDER_O= GENDER_M= GENDER_F= gender_l= ;
	
	* Creating new grouping variable for GENDER *;
	GENDER_C = catx('',GENDER_O, GENDER_M, GENDER_F);
	output transform1;
	
	*** For POSITION variable we have multiple words separated by '|' ***;
	* We are going to convert in from WIDE into LONG structure *; 
	do i = 1 to countw(POSITION,'|');
		POSITION_L = scan(POSITION,i,'|');
		output data_position_long;
	end;
run;

proc print data=transform1;
	where  missing(gender);
run;

proc print data=transform1;
	where not missing(gender) and missing(GENDER_C);
run;

%macro sort_loop( ds = );
	proc sort data = &ds.
	           out = &ds._sort  ;
		by GENDER_C ;
	run;
%mend sort_loop;
%sort_loop( ds = transform1)
%sort_loop( ds = data_position_long )

%macro loop_freq(var = , by_var = , where = ,ds = transform1_sort);
	proc freq data = &ds. noprint;
	   tables &var. / out= &var._output;
	   %if &by_var. ne %then by &by_var. ;;
	   %if not %isBlank(&where.) %then where &where. ;;
	run;	
%mend loop_freq;
*AGE GENDER COUNTRY US_STATE W_COUNTRY W_US_STATE POSITION REMOTELY ;

%macro isBlank(param);
 %sysevalf(%superq(param)=,boolean)
%mend isBlank; 

options mprint;
%loop_freq(var = GENDER_C, by_var = , where = %str( not missing(GENDER_C) ))
%loop_freq(var = IT_ROLE, by_var = ,  where = %str( IT_ROLE in ("1", "0") )    ) 
%loop_freq(var = REMOTELY, by_var = , where = %str( REMOTELY in ("Always", "Never", "Sometimes" )))

proc SUMMARY data = transform1;
	var AGEN  ;
	output out = age_out;
run;

proc sql noprint;
	select count(1)  into: bign
	from mylib.demog2;
quit;

proc transpose data = AGE_OUT out = AGE_OUT_T;
	by _type_ _freq_;
	id _stat_;
run;

data outcome;
	length PARAM $20. CAT $50. VALUE $20. ;
    
	set GENDER_C_output ( in = in_g   )
	    AGE_OUT_T       ( in = in_age )                        
	    IT_ROLE_output  ( in = in_it  )
	    REMOTELY_output ( in = in_rem ) ;
	                          
	   if in_g        then do; 
	        CAT = "Gender";
	        PARAM = GENDER_C;
	   end;
	   else if in_it  then do;
	   	    CAT = "Tech\IT Role?";
	   	    PARAM = IT_ROLE ;
	   end;
	   else if in_rem then do; 
	       CAT = "Working Remotely?";
	       PARAM = REMOTELY;
	   end;
	   else if in_age then do;
	       CAT = "Age";
	   end;
	   
	   if in_age then do;
	   		PARAM = "N";
	   		VALUE = put(N,4.);
			output;
	   		PARAM = "Mean(SD)";
	   		VALUE = put(MEAN,4.1)||"("||put(STD,4.1)||")";
			output;
	   		PARAM = "Min-Max";
	   		VALUE = put(MIN,4.)||"-"||put(MAX,4.);
			output;
	   end;
	   else do;
	       VALUE = put(COUNT,4.)||"("||put(COUNT/&BIGN.*100,4.1)||"%)";
	       output;
	   end;
run;

title "Demographic Information";
proc report data = outcome split='@';
	columns CAT PARAM VALUE  ;
	define CAT   /"Question"  order;
	define PARAM /"Parameter" display;
	define VALUE / "All responses@(N = &bign.)" display;

	compute after CAT;	line ' '; endcomp;
run;
