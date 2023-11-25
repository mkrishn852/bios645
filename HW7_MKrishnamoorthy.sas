*HW 7 SAS Code - Maya Krishnamoorthy

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
options validvarname=any;
data b645.tooth;
	infile "/home/u59228083/BIOS645/Tooth_growth.txt" 
           dlm="09"X firstobs=2;
    input length type $ dose;
    IF type='VC' THEN dtype = 1; 
		ELSE dtype = 0;
	interaction = dose*dtype;
run;

/* 
I'll start with basic tables & plots to explore the data,
looking at bi-variate distributions
*/
proc sgplot data=b645.tooth;
	title1 "Scatter Plot: Dose vs. Length";
	SCATTER X=dtype Y=length;
	REG     X=dtype Y=length  /NOMARKERS;
	LOESS   X=dtype Y=length  /NOMARKERS; 
run; 

proc sgplot data=b645.tooth;
	title1 "Scatter Plot: Dose vs. Length";
	SCATTER X=dose Y=length;
	REG     X=dose Y=length  /NOMARKERS;
	LOESS   X=dose Y=length  /NOMARKERS; 
run; 

/*First attempt at multiple regression of all variables against fertility*/
proc reg data=b645.tooth plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Tooth Growth";
	model length=dtype dose;
run;

/*now regress with interaction term*/
proc reg data=b645.tooth plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Tooth Growth with Interaction Term";
	model length=dtype dose interaction /clb;
run;

/*Compute the simple effect of dose on length at each level of type*/
proc glm data=b645.tooth;
title1 "Simple Effect of Dose on Length at Each Level of Type";
class dtype dose;
model length=dtype dose dose*dtype;
lsmeans dose*dtype / slice = dtype;
run;
quit;