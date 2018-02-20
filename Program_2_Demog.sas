libname mylib " /folders/myfolders/conf/Library";
/*
proc print data=mylib.demog( obs = 20);
run;
*/
***Starting transforming our data ***;
data transform1 ( drop = GENDER_O GENDER_M GENDER_F gender_l AGE GENDER )
     wrong_grpoup;
	set mylib.demog;
	AGEN = input(AGE, best.);

	*** converting all data into lower case to reduce diversity ***;
	gender_l = lowcase(GENDER);

	length GENDER_O GENDER_M GENDER_F GENDER_C $10. ;

	if gender_l in ( "male (cis)","cis man","cis male","cis male","sex is male","male.","cis male","man","male","guy","cisdude", "dude", "dude", "m", "ml", "m|", "mail", "malr") 
	or gender_l = "i'm a man why didn't you make this a drop down question. you should of asked sex? and i would of answered yes please. seriously how much text can this take?" 
	   then GENDER_M = "Male";

    if gender_l in ("cis female","female assigned at birth","woman","female","female","i identify as female.","female or multi-gender femme","female/woman","cisgender female"," female","female (props for making this a freeform field, though)","f", "fem","fm","female-bodied; no feelings about gender","cis-woman")
    	then GENDER_F = "Female";

	if gender_l in ("bigender","non-binary","transitioned, m2f","genderfluid (born female)","other/transfeminine","androgynous","male 9:1 female, roughly","n/a","other","nb masculine","none of your business","genderqueer","human","genderfluid","enby","genderqueer woman","mtf","queer","agender","fluid","male/genderqueer","nonbinary","unicorn","male (trans, ftm)","afab","transgender woman" ) 
		then GENDER_O = "Other";

	if cmiss(GENDER_O, GENDER_M, GENDER_F) = 1 then output wrong_grpoup;
	if cmiss(GENDER_O, GENDER_M, GENDER_F) = 3 and not missing( gender_l ) 
	   then output wrong_grpoup;
	
	*GENDER_C = COALESCEC(GENDER_O, GENDER_M, GENDER_F);
	GENDER_C = catx('',GENDER_O, GENDER_M, GENDER_F);
	*if not missing(GENDER_C) then; output transform1;
run;

proc print data=wrong_grpoup;
	var gender_l GENDER_O GENDER_M GENDER_F ;
run;

proc freq data = transform1;
   *tables GENDER_C / missing;
   tables _CHARACTER_ / missing 
               out= freq_output;
run;

proc means data = transform1;
	var AGEN  ;
	output out = means_out;
run;
