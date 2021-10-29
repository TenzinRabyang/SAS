* finding the best input variables using logistic regression with churn variable as target variable.;

proc freq data=work.inner_join01;
table churn;
run;


proc logistic data=work.inner_join01;
model churn(event='1') =  cons_12m cons_gas_12m cons_last_month forecast_base_bill_ele 
						  forecast_base_bill_year forecast_bill_12m forecast_cons forecast_cons_12m 
						  forecast_cons_year forecast_discount_energy forecast_price_energy_p1 
						  forecast_meter_rent_12m forecast_price_energy_p2 forecast_price_pow_p1  
						  margin_gross_pow_ele margin_net_pow_ele nb_prod_act net_margin num_years_antig 
						  pow_max / link=probit rsquare;
run;


proc logistic data=work.price_inner_join;
model num_years_antig = price_p1_fix price_p1_var price_p2_fix 
						price_p2_var price_p3_fix price_p3_var;
run;




