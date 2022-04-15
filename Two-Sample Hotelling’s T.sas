*read data from excel;
options nocenter nodate pageno=1 ls=75 ps=45 nolabel;
proc import datafile="/home/u60821938/APM635_homework/homework3_Newfood.xls"
out=work.list dbms=xls Replace;
run;

*write into newfood;
data newfood;
set list;
run;

*group by the type of ADV;
proc sort data=newfood;
by ADV;
run;

*1.basic statistics;
proc means data=newfood n mean median std min max mexdec=4;
var Y1 Y2 Y3;
by ADV;
run;

*===COMPUTE MEANS AND VAR-COV MATRIX===;
PROC MEANS N MEAN MAXDEC=2;
  VAR Y1 Y2 Y3;
  BY ADV;
  OUTPUT OUT=OUT MEAN=MY1 MY2 MY3;
RUN;

DATA OUT1;
  SET OUT;
  MY=MY1; MONTH='1-2'; KEEP ADV MY MONTH; DATA OUT2;
  SET OUT;
  MY=MY2; MONTH='2-4'; KEEP ADV MY MONTH; DATA OUT3;
  SET OUT;
  MY=MY3; MONTH='4-6'; KEEP ADV MY MONTH; RUN; DATA OUT;
  SET OUT1 OUT2 OUT3;
PROC PRINT DATA=OUT;
  VAR ADV MONTH MY;
RUN;
PROC SGPLOT DATA=OUT;
  SERIES X=MONTH Y=MY / GROUP=ADV;
  TITLE 'Mean Plot of Sales by Month';
RUN;

*Pearson Correlation Coefficient;
proc corr data=newfood nosimple;
var Y1 Y2 Y3;
title'correlation';
run;

*univaiate normality;
proc univariate data=newfood normal plot;
var Y1 Y2 Y3;
run;

*multivariate normality;
%multnorm(data=newfood, var=Y1 Y2 Y3);
run;

*hotelling t2-test;
proc glm data=newfood;
class ADV;
model Y1 Y2 Y3 = ADV / nouni;
manova h=ADV / summary;
title 'two-sample hotelling t2-test';
run;