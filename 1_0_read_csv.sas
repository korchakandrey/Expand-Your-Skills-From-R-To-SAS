libname mylib "/folders/myfolders/conf";
filename csv_srs "/folders/myfolders/conf/mental-heath-in-tech-2016_20161114.csv";

proc import datafile = csv_srs
	             out = ds_source
	            dbms = csv replace ;
	guessingrows = 32767 ;
	getnames = no  ;
run;

/* create code to add first line text as labels to variables */
filename code temp;
data  _null_ ;
  length label $200. ;
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

/*
* Selecting Demographic data;
data demog;
	set ds_source;
	
   age                            = 
   gender                         =                                                                                                                                  
   country_live
   US_state_or_territory_do_yo            =                                                                                                                         
   What_country_do_you_work_in                 =                                                                                                                                 
   What_US_state_or_territory_do_you_work_in   =
   Which_of_the_following_best_desc            =                                                                                                        
   Do_you_work_remotely                        =     
	
   keep  ;
run;
*/
