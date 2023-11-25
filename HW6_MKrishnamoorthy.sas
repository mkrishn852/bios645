*HW 6 SAS Code - Maya Krishnamoorthy

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
options validvarname=any;
data b645.fertility;
	infile "/home/u59228083/BIOS645/Swiss_fertility.txt" 
           dlm="09"X firstobs=2;
    rename imortality = 'infant.mortality'n;
	input municipality $ fertility agriculture examination education catholic imortality;
	keep fertility agriculture examination education catholic imortality;
run;

/* 
I'll start with basic tables & plots to explore the data,
looking at bi-variate distributions
*/
proc sgplot data=b645.fertility;
	title1 "Scatter Plot: Agriculture vs. Fertility";
	SCATTER X=agriculture Y=fertility;
	REG     X=agriculture Y=fertility  /NOMARKERS;
	LOESS   X=agriculture Y=fertility  /NOMARKERS; 
run; 

proc sgplot data=b645.fertility;
	title1 "Scatter Plot: Examination vs. Fertility";
	SCATTER X=examination Y=fertility;
	REG     X=examination Y=fertility  /NOMARKERS;
	LOESS   X=examination Y=fertility  /NOMARKERS; 
run;

proc sgplot data=b645.fertility;
	title1 "Scatter Plot: Education vs. Fertility";
	SCATTER X=education Y=fertility;
	REG     X=education Y=fertility  /NOMARKERS;
	LOESS   X=education Y=fertility  /NOMARKERS; 
run;

proc sgplot data=b645.fertility;
	title1 "Scatter Plot: Catholicism vs. Fertility";
	SCATTER X=catholic Y=fertility;
	REG     X=catholic Y=fertility  /NOMARKERS;
	LOESS   X=catholic Y=fertility  /NOMARKERS; 
run;

proc sgplot data=b645.fertility;
	title1 "Scatter Plot: Infant Mortality vs. Fertility";
	SCATTER X='infant.mortality'n Y=fertility;
	REG     X='infant.mortality'n Y=fertility  /NOMARKERS;
	LOESS   X='infant.mortality'n Y=fertility  /NOMARKERS; 
run;

/*First attempt at multiple regression of all variables against fertility*/
proc reg data=b645.fertility plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Marital Fertility";
	model fertility=agriculture examination education catholic 'infant.mortality'n;
run;

/*Create an interaction term*/
data b645.fertility2;
	infile "/home/u59228083/BIOS645/Swiss_fertility.txt" 
		dlm="09"X firstobs=2;
	rename imortality = 'infant.mortality'n;
	input municipality $ fertility agriculture examination education catholic imortality;
	interact = catholic*education; * create interaction term;
	keep fertility agriculture examination education catholic imortality interact;
run;

proc reg data=b645.fertility2 plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Marital Fertility with Interaction";
	model fertility=agriculture examination education catholic 'infant.mortality'n interact;
run;
/*p-value for the interaction is very low for the model*/

/*Compute simple efct of education on catholic*/
proc glm data=b645.fertility2;
class education catholic;
model fertility=education catholic education*catholic;
lsmeans education*catholic / slice=catholic;
run;

/*Regression excluding education*/
proc reg data=b645.fertility2 plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Marital Fertility";
	model fertility=agriculture examination catholic 'infant.mortality'n;
run;

/*Regression including education*/
proc reg data=b645.fertility2 plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Marital Fertility";
	model fertility=agriculture examination education catholic 'infant.mortality'n;
run;