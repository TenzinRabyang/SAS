*1a)
* Adding new variables into the data set;
data tcost;
set mydata.pfarg06;
y = 1000*(b3+b4+b6+b7+b8)/a1;
per2 = a2/a1;
per3 = a3/a1;
per4 = a4/a1;
per5 = a5/a1;
per6 = a6/a1;
per7 = a7/a1;
run;
* Exploring and checking for missing value;
proc means data=tcost nmiss mean std;
var y per2 per3 per4 per5 per6 per7;
run;

* ploting histogram on variable y;
proc univariate data=tcost;
histogram y / normal;
run;

*1b)
* Investigating c1 - c8 using proc freq;
proc freq data=tcost;
table c1 c2 c3 c4 c5 c6 c7 c8 ;
run;

*----------------------------------------------------------;
* 2) Fit of the model;

* Creating dummy variable for C1;
data tcost replace;
set work.tcost;
if c1 = 1 then c1_1 = 1;
else c1_1 = 0;
if c1 = 2 then c1_2  = 1;
else c1_2 = 0;
if c1 = 3 then c1_3 = 1;
else c1_3 = 0;
if c1 = 4 then c1_4 = 1;
else c1_4 = 0;
run;

* performing regression model;
proc reg data=tcost;
model y = a1 per2 per3 per4 per5 per6 per7 c1_1 c1_2 c1_3 c1_4 c2 c3 c5 c6 c7 c8/vif;
plot student. *p.;
output out=plot01 p = Perdicted student=sresid rstudent=dresid;
run;

*Checking normality usign histrogram;
proc univariate data=plot01;
histogram sresid / normal;
qqplot sresid;
run;

* Investigating adequacy of Systematic Component using studentize residual and deleted residual;
symbol1 v = plus c = black;
symbol2 v = circle c = green;
proc gplot data=plot01;
plot (sresid dresid)* Perdicted / overlay vref=0;
run;
quit;

*-----------------------------------------------------------------------------------------------;
*3)
*3b)

* Transforming the data using log();
data tcost;
set work.tcost;
ly = log(y);
la1 = log(a1);
lper2 = log(per2);
lper3 = log(per3);
lper4 = log(per4);
lper5 = log(per5);
lper6 = log(per6);
lper7 = log(per7);
run;


* Investigating Fit of the model;
proc reg data=tcost;
model ly = la1 lper2 lper3 lper4 lper5 lper6 lper7 c1_1 c1_2 c1_3 c1_4 c2 c3 c5 c6 c7 c8;
plot student. *p.;
output out=sridual p= Predicted student=sresid rstudent=dresid;
run;

* Checking normality using histogram of Studentized residual;
proc univariate data = sridual;
histogram sresid / normal;
qqplot sresid;
run;

* Checking for systematic component;
symbol1 v=plus c=black;
symbol2 v =circle c = black;
proc gplot data=sridual;
plot (sresid dresid)*predicted / overlay vref=0;
run;
quit;


* Question 4////////////////////////////////////;
*4a) finding best model;

*Implementing R2 method;
proc reg data=tcost;
model ly = la1 lper2 lper3 lper4 lper5 lper6 lper7 c1_1 c1_2 c1_3 c2 c3 c5 c6 c7 c8 / 
selection = rsquare mse;
run;
quit;

* Implementing Adjusted R2 method;
proc reg data=tcost;
model ly = la1 lper2 lper3 lper4 lper5 lper6 lper7 c1_1 c1_2 c1_3 c2 c3 c5 c6 c7 c8 / 
selection = rsquare adjrsq;
run;
quit;

* implementing Cp method;
proc reg data=tcost;
model ly = la1 lper2 lper3 lper4 lper5 lper6 lper7 c1_1 c1_2 c1_3 c2 c3 c5 c6 c7 c8 / 
selection = rsquare cp;
run;
quit;

*4b);

* Performing Regression Backward elimination method;
proc reg data=tcost;
model ly = la1 lper2 lper3 lper4 lper5 lper6 lper7 c1_1 c1_2 c1_3 c1_4 c2 c3 c5 c6 c7 c8 / 
selection = backward slstay = 0.05;
run;
quit;

* Parameter Estimation of final model;
proc reg data=tcost;
model ly = la1 lper2 lper3 c1_1;
run;
quit;

*----------------------------------------------------------------------------------;
*5);
* Checking fit of the FINAL model;
* This can chekc homoscedasticity of model;
proc reg data=tcost noprint;
model ly = la1 lper2 lper3 c1_1 c2;
plot student. *p.;
output out=plot03 p=predicted student=sresid rstudent=dresid;
run;
quit; 

* Checking Normality of Final model;
proc univariate data=plot03 noprint;
histogram sresid / normal;
qqplot sresid;
run;

* Checking Sytematic Component of final model;
symbol1 v = plus c = black;
symbol2 v = circle c = black;
proc gplot data=plot03;
plot (sresid dresid)*predicted / overlay vref=0;
run;
quit;

* Checking fit of model one by one variable;
*1. la1;

* Checking Homoscedasticity;
proc reg data=tcost;
model ly = la1;
plot student. *p.;
output out=plotla1 p = predicted student=sresid rstudent=dresid;
run;
quit;

* Checking Normality;
proc univariate data=plotla1 noprint;
histogram sresid / normal;
qqplot sresid;
run;
quit;

* Checking adequacy of Systematic componet;
symbol1 v = plus c=black;
symbol2 v = circle c=black;
proc gplot data=plotla1;
plot (sresid dresid)*predicted / overlay vref=0;
run;
quit;

*2. lper2;
* Checking Homoscedasticity;
proc reg data=tcost;
model ly = lper2;
plot student. *p.;
output out=plotlper2 p = predicted student=sresid rstudent=dresid;
run;
quit;

* Checking Normality;
proc univariate data=plotlper2 noprint;
histogram sresid / normal;
qqplot sresid;
run;
quit;

* Checking adequacy of Systematic componet;
symbol1 v = plus c=black;
symbol2 v = circle c=black;
proc gplot data=plotlper2;
plot (sresid dresid)*predicted / overlay vref=0;
run;
quit;

*3. lper3;
* Checking Homoscedasticity;
proc reg data=tcost;
model ly = lper3;
plot student. *p.;
output out=plotlper3 p = predicted student=sresid rstudent=dresid;
run;
quit;

* Checking Normality;
proc univariate data=plotlper3 noprint;
histogram sresid / normal;
qqplot sresid;
run;
quit;

* Checking adequacy of Systematic componet;
symbol1 v = plus c=black;
symbol2 v = circle c=black;
proc gplot data=plotlper3;
plot (sresid dresid)*predicted / overlay vref=0;
run;
quit;



 *------------------------------------------------------------------------------------------;
 *6);
 *a);
 * Checking for influential points;
 proc reg data=tcost noprint;
 model ly = la1 lper2 lper3 c1_1 c2;
 plot student. *p.;
 output out=plot04 dffits= Dff p = predicted student=sresid rstudent=dresid covratio=C;
 run;
 quit;
 
 * Adding the  absolute value of differences of fits (DIFFITS);
 data plot04;
 set plot04;
 adff = abs(Dff);
 run;
 
 *Sorting the data;
proc sort data=plot04;
by descending adff;
run;

* Adding ranks of Diffits;
data plot04;
set plot04;
index = _N_;
run;

* Ploting the reference line to check any potential influential points;
proc gplot data=plot04;
plot adff*index / vref = 0.730 vref = 2;
run;
quit;

*Printing out the potential outliers observations ;
proc print data=plot04;
var ly la1 lper2 lper3 c1_1 c2 Dff;
where index <= 2;
run;
 
 *Investigating deleted residual;
 proc reg data=tcost noprint;
 model ly = la1 lper2 lper3 c1_1 c2;
 plot student. *p.;
 output out=plot04 dffits= Dff p = predicted rstudent=dresid;
 run;
 quit;
 
 * Investigating leverage (H);
  proc reg data=tcost noprint;
 model ly = la1 lper2 lper3 c1_1 c2;
 plot student. *p.;
 output out=plot04 p = predicted  h = H;
 run;
 quit;
 
 * Investigating Covariance ratio(C);
  proc reg data=tcost noprint;
 model ly = la1 lper2 lper3 c1_1 c2;
 plot student. *p.;
 output out=plot04 dffits= Dff p = predicted covratio=C;
 run;
 quit;


* printing relevent statistics;
proc print data=plot04;
var id ly predicted dff H dresid C;
where index <= 2;
run;

*6b);
* nvestigating coolinearity;
proc reg data=tcost corr;
model ly = la1 lper2 lper3 c1_1 c2;
run;
quit;

*Investigating VIF variance inflation factors;
proc reg data=tcost;
model ly = la1 lper2 lper3 c1_1 c2 / vif;
run;
quit;

* Checking for multi-collinearity in final model;
proc reg data=tcost;
model ly = la1 lper2 lper3 c1_1 c2 / collin;
run;
quit;

*------------------------------------------------------------------------------------;
* 7th question;

* getting confident intervals of model;
proc reg data=tcost;
model ly = la1 lper2 lper3 c1_1 c2/cli clm;
run;

proc reg data=tcost;
model ly = la1 lper2 lper3 c1_1 c2;
output out=plot05 p=predicted lcl=lower ucl=upper;
run;
quit;

data Ftcost;
set tcost;
run;

* Data are reverting the log transformation using expo() function;
data Ftcost;
set plot05;
expoP = exp(predicted);
expoL = exp(lower);
expoU = exp(upper);
run;

*Printing the data;
proc print data=Ftcost noobs;
var id y expoP expoL expoU;
run;
quit;








