*read data from excel;
options nocenter nodate pageno = 1 ls = 75 ps = 45 nolabel;
proc import datafile = "/home/u60821938/APM635_homework/Mice.xls"
out = work.list dbms = xls Replace;
run;

*write into mice;
data mice;
set list;
run;


*group by the type of sex and temp;
proc sort data = mice;
by SEX TEMP;
run;



*1.basic statistics for entire data;
proc means mean data = mice maxdec = 4 noprint;
var X1 X2 X3;
by SEX TEMP;
output out = out mean = MX1 MX2 MX3;
proc print data = out;
var SEX TEMP MX1 MX2 MX3;
run;

*2.multivariate normality;
%multnorm(data = mice, var = X1 X2 X3);
run;


*3.two-way MANOVA;
proc glm data = mice;
class SEX TEMP;
model X1 X2 X3 = SEX TEMP SEX*TEMP / nouni;
MANOVA h = SEX TEMP SEX*TEMP;
run;

*4.MANOVA for contrast;
PROC GLM DATA=mice; 
CLASS SEX TEMP;
MODEL X1 X2 X3 = SEX TEMP SEX*TEMP;
MANOVA H=SEX TEMP SEX*TEMP;
CONTRAST 'MALE VS FEMALE' SEX 1 -1;
CONTRAST 'TEMP4 VS TEMP20' TEMP 1 -1 0; 
CONTRAST 'TEMP4 VS TEMP34' TEMP 1 0 -1; 
CONTRAST 'TEMP20 VS TEMP34' TEMP 0 1 -1;
RUN;



*mean plot for each variable ;
PROC SORT DATA=mice;
 BY SEX TEMP;
PROC MEANS N MEAN STD MAXDEC=2 NOPRINT; VAR X1 X2 X3;
 BY SEX TEMP;
 OUTPUT OUT=STAT MEAN=MX1 MX2 MX3;
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=TEMP Y=MX1/GROUP=SEX; TITLE 'Mean Plot of X1';
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=TEMP Y=MX2/GROUP=SEX; TITLE 'Mean Plot of X2';
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=TEMP Y=MX3/GROUP=SEX; TITLE 'Mean Plot of X3';
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=SEX Y=MX1/GROUP=TEMP; TITLE 'Mean Plot of X1';
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=SEX Y=MX2/GROUP=TEMP; TITLE 'Mean Plot of X2';
RUN;
PROC SGPLOT DATA=STAT;
 SERIES X=SEX Y=MX3/GROUP=TEMP; TITLE 'Mean Plot of X3';
RUN;

*z1 and z2 ;
DATA NEW; SET STAT;
 Z1=0.07937956*MX1+0.06111179*MX2+4.31883793*MX3;
 Z2=-0.08910561*MX1+0.20156746*MX2-3.12154857*MX3; 
 IF SEX=0 AND TEMP=4 THEN TREAT='A';
 IF SEX=0 AND TEMP=20 THEN TREAT='B';
 IF SEX=0 AND TEMP=34 THEN TREAT='C'; 
 IF SEX=1 AND TEMP=4 THEN TREAT='1';
 IF SEX=1 AND TEMP=20 THEN TREAT='2';
 IF SEX=1 AND TEMP=34 THEN TREAT='3';
RUN;
PROC PRINT DATA=NEW; VAR SEX TEMP MX1 MX2 MX3 Z1 Z2 TREAT;
RUN;
PROC SGPLOT DATA=NEW;
 SERIES X=Z1 Y=Z2 / GROUP=SEX DATALABEL=TREAT;
TITLE 'Plot of Z2*Z1';
RUN;