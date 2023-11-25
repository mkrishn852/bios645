* HW 5 SAS Code: Maya Krishnamoorthy;

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
data b645.pima;
	infile "/home/u59228083/BIOS645/Pima_fasting_glucose.txt" 
           dlm="09"X firstobs=2;
	input glucose pregnancies dia_bp skin_fold bmi age;
run;

/* 
I'll start with basic tables & plots to explore the data,
looking at bi-variate distributions
*/
proc sgplot data=b645.pima;
	title1 "Scatter Plot: Pregnancies vs. plasma glucose concentration";
	SCATTER X=pregnancies Y=glucose;
	REG     X=pregnancies Y=glucose  /NOMARKERS;
	LOESS   X=pregnancies Y=glucose  /NOMARKERS; 
run; 

proc sgplot data=b645.pima;
	title1 "Scatter Plot: Diastolic bp vs. plasma glucose concentration";
	SCATTER X=dia_bp Y=glucose;
	REG     X=dia_bp Y=glucose  /NOMARKERS;
	LOESS   X=dia_bp Y=glucose  /NOMARKERS; 
run;

proc sgplot data=b645.pima;
	title1 "Scatter Plot: thickness of skin folds vs. plasma glucose concentration";
	SCATTER X=skin_fold Y=glucose;
	REG     X=skin_fold Y=glucose  /NOMARKERS;
	LOESS   X=skin_fold Y=glucose  /NOMARKERS; 
run;

proc sgplot data=b645.pima;
	title1 "Scatter Plot: BMI vs. plasma glucose concentration";
	SCATTER X=bmi Y=glucose;
	REG     X=bmi Y=glucose  /NOMARKERS;
	LOESS   X=bmi Y=glucose  /NOMARKERS; 
run;

proc sgplot data=b645.pima;
	title1 "Scatter Plot: age vs. plasma glucose concentration";
	SCATTER X=age Y=glucose;
	REG     X=age Y=glucose  /NOMARKERS;
	LOESS   X=age Y=glucose  /NOMARKERS; 
run;

/*proc corr data=b645.pima plots=matrix(histogram);
	var glucose pregnancies dia_bp skin_fold bmi age;
run;*/


/* Looking at the distribution of each variable independently
*/
proc means data=b645.pima N MIN MEDIAN MAX MEAN STD SKEW KURT MAXDEC=3;
	title1 "Distribution of Variables in Pima Dataset";
	var glucose pregnancies dia_bp skin_fold bmi age;
run;

/*First attempt at multiple regression of all variables against glucose concentration*/
proc reg data=b645.pima plots=(RESIDUALS(SMOOTH));
	title1 "Multiple Regression of Glucose Concentration Levels";
	model glucose=pregnancies dia_bp skin_fold bmi age;
run;

/*outliers in the residuals plot, so let's take a closer look at residuals*/
PROC REG DATA=b645.pima NOPRINT;
	MODEL  glucose=pregnancies dia_bp skin_fold bmi age;
	OUTPUT OUT=pima_resids RESIDUAL=resids;
RUN;
QUIT;

PROC UNIVARIATE DATA=pima_resids;
	VAR    resids;
	QQPLOT resids;  * added a larger qq-plot for good measure;
RUN;

/*keep track of residuals outliers in dataset pima_resids2*/
DATA pima_resids2;
	SET pima_resids;
	id = _N_;    * this adds a row number I can use;
	IF id = 8 OR id = 101 OR id=179 OR id=491 THEN
		OUTPUT;  * i.e., I'm dropping all other rows;
RUN;
PROC PRINT DATA=pima_resids2;
RUN;

/*Create a dataset to plot these points distinctly*/
DATA pima_resids3;
	SET pima_resids2;
	outliers = glucose;   * I'm calling height 'outliers' so;
	npregnancies = pregnancies;     *  my eventual plot will be labeled;
	ndia_bp = dia_bp;     *  in a way that looks nicer;
	nskin_fold = skin_fold;
	nbmi = bmi;
	nage = age;
	DROP glucose pregnancies dia_bp skin_fold bmi age resids id;
RUN;

DATA pima_resids4;
	* stacking these datasets;
	SET pima_resids    pima_resids3;
RUN;

* we can now plot the data and highlight the potential outliers;
PROC SGPLOT DATA=pima_resids4;
	SCATTER X=pregnancies     Y=glucose;
	REG     X=pregnancies     Y=glucose   /NOMARKERS;
	SCATTER X=npregnancies Y=outliers /MARKERATTRS=(SYMBOL=CircleFilled
                                                SIZE=10);
RUN;

PROC SGPLOT DATA=pima_resids4;
	SCATTER X=dia_bp     Y=glucose;
	REG     X=dia_bp     Y=glucose   /NOMARKERS;
	SCATTER X=ndia_bp Y=outliers /MARKERATTRS=(SYMBOL=CircleFilled
                                                SIZE=10);
RUN;

PROC SGPLOT DATA=pima_resids4;
	SCATTER X=skin_fold     Y=glucose;
	REG     X=skin_fold     Y=glucose   /NOMARKERS;
	SCATTER X=nskin_fold Y=outliers /MARKERATTRS=(SYMBOL=CircleFilled
                                                SIZE=10);
RUN;

PROC SGPLOT DATA=pima_resids4;
	SCATTER X=bmi     Y=glucose;
	REG     X=bmi     Y=glucose   /NOMARKERS;
	SCATTER X=nbmi Y=outliers /MARKERATTRS=(SYMBOL=CircleFilled
                                                SIZE=10);
RUN;

PROC SGPLOT DATA=pima_resids4;
	SCATTER X=age     Y=glucose;
	REG     X=age     Y=glucose   /NOMARKERS;
	SCATTER X=nage Y=outliers /MARKERATTRS=(SYMBOL=CircleFilled
                                                SIZE=10);
RUN;

/*
As a sensitivity analysis, we can refit the model with these
four deleted.  
*/
PROC REG DATA=pima_resids PLOTS=(RESIDUALS(SMOOTH));
	MODEL glucose=pregnancies dia_bp skin_fold bmi age /clb;
	WHERE resids BETWEEN -70 AND 77;
RUN;
QUIT;