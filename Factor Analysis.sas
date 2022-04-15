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

*3.factor analysis;
proc factor data= crime method = principal nfactor=4 plot= scree rotate=varimax ev score outstat = factor;
var Murder Rape Robbery Assault Burglary Larceny Autotheft;
run;

proc score data = crime score = factor out=score;
run;

proc plot data = score;
plot factor2*factor1= '*' $State /box;
plot factor3*factor4= '*' $State /box;
run;

proc print data = score;
var State factor1 factor2 factor3 factor4;
run;

