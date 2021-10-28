FILENAME REFFILE '/home/u47307525/price_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.price_data;
	GETNAMES=YES;
RUN;

proc sort data=work.price_data;
by id;
run;


data price_inner_join;
merge work.inner_join01 (in=a)
	  work.price_data (in=b);
	  by id;
if a and b then output;
run;

proc freq data=work.price_inner_join;
tables num_years_antig*price_p1_fix;
run;

proc sgplot data = work.price_inner_join;
     vline num_years_antig/response = price_p1_fix;
     vline num_years_antig/response = price_p2_fix;
     vline num_years_antig/response = price_p1_var;
     vline num_years_antig/response = price_p2_var;
     vline num_years_antig/response = price_p3_fix;
     vline num_years_antig/response = price_p3_var;
run;

