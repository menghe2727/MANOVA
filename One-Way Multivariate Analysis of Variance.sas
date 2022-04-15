*read data from excel;
options nocenter nodate pageno = 1 ls = 75 ps = 45 nolabel;
proc import datafile = "/home/u60821938/APM635_homework/Fish2022.xlsx"
out = work.list dbms = xlsx Replace;
run;

*write into newfood;
data fish;
set list;
run;

*1.basic statistics for entire data;
proc means data = fish n mean median std min max mexdec = 4;
var Aroma Flavor Texture Moisture;
run;

*2.correlations for entire data;
proc corr data = fish nosimple;
var Aroma Flavor Texture Moisture;
title'correlation for entire data';
run;

*group by the type of ADV;
proc sort data = fish;
by METHOD;
run;

*3.basic statistics for different cooking method;
proc means data = fish n mean median std min max mexdec = 4;
var Aroma Flavor Texture Moisture;
by METHOD;
run;

*4.correlations for different cooking method;
proc corr data = fish nosimple;
var Aroma Flavor Texture Moisture;
by METHOD;
title'correlation for different cooking method';
run;

*5.multivariate normality;
%multnorm(data = fish, var = Aroma Flavor Texture Moisture);
run;

*6.MANOVA;
proc glm data = fish;
class METHOD;
model Aroma Flavor Texture Moisture = METHOD ;
manova h = METHOD / summary;
run;

*7.contrast;
proc glm data = fish;
class METHOD;
model Aroma Flavor Texture Moisture = METHOD ;
contrast 'BBQ vs Fry' METHOD 1 -1 0;
contrast 'BBQ vs Steam' METHOD 1 0 -1;
contrast 'Fry vs Steam' METHOD 0 1 -1;
manova h = METHOD /printh printe;

*8.canonical discriminant;
data new_fish;
set fish;
z1=0.09340435*Aroma+0.53951600*Flavor-0.36969435*Texture-0.12124129*Moisture;
z2=-0.33762989*Aroma+0.32825373*Flavor+0.22131913*Texture+0.02082966*Moisture;
proc sort data = new_fish;
by METHOD;
run;
proc means data = new_fish n mean median std min max mexdec = 4;
var z1 z2;
by METHOD;
proc plot data = new_fish;
PLOT z2*z1 = METHOD / HPOS=60 VPOS=25;
 RUN; 
proc sgplot data = new_fish;
SCATTER X=z1 Y=z2 / GROUP=METHOD;
run;