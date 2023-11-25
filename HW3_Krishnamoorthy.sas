* HW 3 SAS Code: Maya Krishnamoorthy;

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
data b645.smokecancer;
	infile "/home/u59228083/BIOS645/Smoke_&_cancer.txt" 
           dlm="09"X firstobs=2;
	input state :$2. cig blad lung kid leuk;
	label state="State" cig="Number of packs of cigarettes sold per capita"
	blad="Number of deaths from bladder cancer per 100k in the population"
	lung="Number of deaths from lung cancer per 100k in the population"
	kid="Number of deaths from kidney cancer per 100k in the population"
	leuk="Number of deaths from leukemia per 100k in the population";
run;

/* 
I'll start with basic tables & plots to explore the data,
looking at bi-variate distributions
*/
proc sgplot data=b645.smokecancer;
	title1 "Scatter Plot: Cigarette Sales vs Bladder Cancer Deaths per 100K";
	scatter X=cig Y=blad;
	reg     X=cig Y=blad  /nomarkers;
run;
proc sgplot data=b645.smokecancer;
	title1 "Scatter Plot: Cigarette Sales vs Lung Cancer Deaths per 100K";
	scatter X=cig Y=lung;
	reg     X=cig Y=lung  /nomarkers;
run;
proc sgplot data=b645.smokecancer;
	title1 "Scatter Plot: Cigarette Sales vs Kidney Cancer Deaths per 100K";
	scatter X=cig Y=kid;
	reg     X=cig Y=kid  /nomarkers;
run;
proc sgplot data=b645.smokecancer;
	title1 "Scatter Plot: Cigarette Sales vs Leukemia Deaths per 100K";
	scatter X=cig Y=leuk;
	reg     X=cig Y=leuk  /nomarkers;
run;

/* Looking at the distribution of each variable independently
*/
proc means data=b645.smokecancer N MIN MEDIAN MAX MEAN STD SKEW KURT MAXDEC=3;
	var cig blad lung kid leuk;
run;

/* Regression Attempt #1 on dataset is straightforward
*/
proc reg data=b645.smokecancer;
title1 "Regressing Lung Cancer Death Rate on Cigarette Sales";
model lung=cig /clb;
run;

* this code will create a new dataset that is transformed;
DATA b645.smokecancer2;
	SET b645.smokecancer;            
	y_ln  = log(lung);    * I'll try the log & the reciprocal;
	y_rcp = 1/lung;           
RUN;

* here I re-fit these models with the transformed versions;
/* Regression Attempt #2 on dataset regresses ln(lung cancer deaths) on cigarettes
Regression Attempt #2 on dataset regresses 1/(lung cancer deaths) on cigarettes
*/
PROC REG DATA=b645.smokecancer2;
	title1 "Regressing Ln(Lung Cancer Death Rate) on Cigarette Sales";
	MODEL y_ln=cig /clb;
PROC REG DATA=b645.smokecancer2;
	title1 "Regressing 1/(Lung Cancer Death Rate) on Cigarette Sales";
	MODEL y_rcp=cig /clb;
RUN;