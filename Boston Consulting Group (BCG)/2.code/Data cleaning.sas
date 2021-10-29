FILENAME REFFILE '/home/u47307525/ml_case_training_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.case_training_data;
	GETNAMES=YES;
RUN;

FILENAME REFFILE '/home/u47307525/churn_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.churn_data;
	GETNAMES=YES;
RUN;


data case_training_data_missing case_training_data_nonmissing;
set work.case_training_data;
if forecast_base_bill_ele eq . or forecast_discount_energy eq . then output case_training_data_missing;
else output case_training_data_nonmissing; 
run;


proc means data=work.case_training_data_nonmissing n nmiss mean;
var  cons_12m cons_gas_12m cons_last_month forecast_base_bill_ele forecast_base_bill_year forecast_bill_12m forecast_cons forecast_cons_12m forecast_cons_year forecast_discount_energy forecast_meter_rent_12m forecast_price_energy_p1 forecast_price_energy_p2 forecast_price_pow_p1 imp_cons margin_gross_pow_ele margin_net_pow_ele nb_prod_act net_margin num_years_antig pow_max;
run;


*	sorting the data;
proc sort data=work.case_training_data_nonmissing;
by id;
run;

proc sort data=work.churn_data;
by id;
run;

* inner joining the tables;
data inner_join01;
merge work.case_training_data_nonmissing (in=a)
	  work.churn_data (in=b);
	  by id;
if a and b then output;
run;

proc means data=work.inner_join01 n nmiss mean;
var   churn cons_12m cons_gas_12m cons_last_month forecast_base_bill_ele forecast_base_bill_year forecast_bill_12m forecast_cons forecast_cons_12m forecast_cons_year forecast_discount_energy forecast_meter_rent_12m forecast_price_energy_p1 forecast_price_energy_p2 forecast_price_pow_p1 imp_cons margin_gross_pow_ele margin_net_pow_ele nb_prod_act net_margin num_years_antig pow_max;
run;

proc freq data=work.only_churn nlevels;
tables churn*num_years_antig;
run;

