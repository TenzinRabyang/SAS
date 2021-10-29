*	extracting only required input variables or features for the model;
data features;
set mydata.price_inner_join;
drop  cons_12m cons_gas_12m cons_last_month forecast_discount_energy forecast_cons_year forecast_cons_12m forecast_cons forecast_bill_12m forecast_base_bill_year forecast_base_bill_ele forecast_price_energy_p1 forecast_price_energy_p2 forecast_price_pow_p1 has_gas imp_cons margin_net_pow_ele nb_prod_act net_margin pow_max price_p1_var price_p2_var price_p3_var;
run;

data mydata.features;
set work.features;
run;


*	sorting the data by target variable;
proc sort data=mydata.features out=features_sort;
by churn;
run;

*	 Stratified the sample using surveyselect procedures;
proc surveyselect data=work.features_sort noprint samprate=0.66 out=features_start outall;
strata churn;
run;

*	verifying the stratification;
proc freq data=work.features_start;
tables churn*selected;
run;

*	 creating training and validation dataset;
data features_train features_valid;
set work.features_start;
if selected then output features_train;
else output features_valid;
run;

*	saving the data set in mydata library;
data mydata.features_train;
set work.features_train;
run;

data mydata.features_valid;
set work.features_valid;
run;

*	fitting the model using logistic regression;
proc logistic data=mydata.features_train plots (only maxpoints = none)= 
				effect(clband x=(forecast_meter_rent_12m margin_gross_pow_ele num_years_antig 
				price_p1_fix price_p2_fix price_p3_fix));
model churn(event='1') =forecast_meter_rent_12m margin_gross_pow_ele num_years_antig price_p1_fix 
						price_p2_fix price_p3_fix / stb clodds=pl slentry=0.5 slstay=0.1 selection=backward;
						
run;

proc logistic data=mydata.features_valid plots (only maxpoints = none)= effect(clband x = (forecast_meter_rent_12m margin_gross_pow_ele num_years_antig price_p1_fix price_p2_fix price_p3_fix));
model churn(event='1') =forecast_meter_rent_12m margin_gross_pow_ele num_years_antig price_p1_fix price_p2_fix 
						price_p3_fix / stb clodds=pl slentry=0.5 slstay=0.1 selection=backward;
						
run;
