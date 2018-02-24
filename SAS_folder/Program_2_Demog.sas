libname mylib " /folders/myfolders/conf/Library";
/*
proc print data=mylib.demog( obs = 20);
run;
*/
***Starting transforming our data ***;
data transform1 ( drop = GENDER_O GENDER_M GENDER_F gender_l AGE GENDER )
     data_position_long( drop = GENDER_O GENDER_M GENDER_F gender_l AGE GENDER );
	
	set mylib.demog;
	
	*** Converting Character Age into numeric values ***;
	AGEN = input(AGE, best.);

	*** Converting Free-Text Gender into 3 groups ***;
	* all data into lower case to reduce diversity *;
	gender_l = lowcase(GENDER);

	length GENDER_O GENDER_M GENDER_F GENDER_C $10. ;

	if gender_l in ( "male (cis)","cis man","cis male","cis male","sex is male","male.","cis male","man","male","guy","cisdude", "dude", "dude", "m", "ml", "m|", "mail", "malr") 
	or gender_l = "i'm a man why didn't you make this a drop down question. you should of asked sex? and i would of answered yes please. seriously how much text can this take?" 
	   then GENDER_M = "Male";

    if gender_l in ("cis female","female assigned at birth","woman","female","female","i identify as female.","female or multi-gender femme","female/woman","cisgender female"," female","female (props for making this a freeform field, though)","f", "fem","fm","female-bodied; no feelings about gender","cis-woman")
    	then GENDER_F = "Female";

	if gender_l in ("bigender","non-binary","transitioned, m2f","genderfluid (born female)","other/transfeminine","androgynous","male 9:1 female, roughly","n/a","other","nb masculine","none of your business","genderqueer","human","genderfluid","enby","genderqueer woman","mtf","queer","agender","fluid","male/genderqueer","nonbinary","unicorn","male (trans, ftm)","afab","transgender woman" ) 
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

%macro sort_loop( ds = );
	proc sort data = &ds.
	           out = &ds._sort  ;
		by GENDER_C ;
	run;
%mend sort_loop;
%sort_loop( ds = transform1)
%sort_loop( ds = data_position_long )

%macro loop_freq(var = , by_var = , where = ,ds = transform1_sort);
	proc freq data = &ds.;
	   tables &var. / missing 
	               out= &var._output;
	   %if &by_var. ne %then by &by_var. ;;
	   %if &where. ne %then where &where. ;;
	run;	
%mend loop_freq;
*AGE GENDER COUNTRY US_STATE W_COUNTRY W_US_STATE POSITION REMOTELY ;

%loop_freq(var = GENDER_C, by_var = , where = )
%loop_freq(var = COUNTRY,  by_var = , where = )
%loop_freq(var = US_STATE, by_var = GENDER_C, where = %str(COUNTRY eq "United States of America"))
%loop_freq(var = W_COUNTRY, by_var = , where = )
%loop_freq(var = W_US_STATE, by_var = GENDER_C, where = %str(W_COUNTRY eq "United States of America"))
%loop_freq(var = REMOTELY, by_var = GENDER_C, where = )
%loop_freq(var = POSITION_L , by_var = GENDER_C, where = , ds = data_position_long_sort )

proc means data = transform1;
	var AGEN  ;
	output out = means_out;
run;
