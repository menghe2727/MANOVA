*read data from excel;
options nocenter nodate pageno = 1 ls = 75 ps = 45 nolabel;
proc import datafile = "/home/u60821938/APM635_homework/Crime2022.xlsx"
out = work.list dbms = xlsx Replace;
run;

*write into crime;
data crime;
set list;
run;

*1.basic statistics for entire data;
proc means data = crime n mean median std min max maxdec=4;
var Murder Rape Robbery Assault Burglary Larceny Autotheft;
run;

*2.correlation for seven response variables ;
proc corr data = crime nosimple;
var Murder Rape Robbery Assault Burglary Larceny Autotheft;
title'correlation';
run;

*3.principal component;
proc princomp data =  crime out = stat;
var Murder Rape Robbery Assault Burglary Larceny Autotheft;
title'PCA';
run;

*4.scatter plot of prin1 and prin2;
proc plot data = stat ;
plot PRIN2*PRIN1 ='*' $ State;
run;
proc plot data = stat ;
plot PRIN3*PRIN1 ='*' $ State;
run;
proc plot data = stat ;
plot PRIN3*PRIN2 ='*' $ State;
run;