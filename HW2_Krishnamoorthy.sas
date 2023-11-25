*BIOS 645 HW 2: Maya Krishnamoorthy;

ods pdf file='/home/u59228083/BIOS645/BIOS645_HW2.pdf';
ods graphics on;

*Import the dataset on Chinese health and family life;
*Add labels to the variables for ease of reading;
LIBNAME b645 "/home/u59228083/BIOS645";
DATA b645.Chinese2;
	INFILE "/home/u59228083/BIOS645/Chinese_health_&_family_life_study.txt" 
           DLM="09"X FIRSTOBS=2;
	INPUT R_region :$13. R_age    R_edu :$10. R_income R_health :$9. R_height 
          R_happy  :$15. A_height A_edu :$10. A_income; 
    KEEP R_height A_height;
    LABEL R_height = "Respondent's height"
    A_height = "Height of woman's partner";
RUN;

*#1: Compute the univariate descriptives for R_height and A_height;
*Create histograms to provide a visual univariate distribution of the variables;
title1 "Univariate Descriptives for Respondent's Height";
PROC FREQ DATA=b645.Chinese2;
	TABLES R_height;
RUN;
PROC UNIVARIATE DATA=b645.Chinese2;
	*ods select Moments BasicMeasures BasicIntervals Quantiles;
	var R_height;
	histogram R_height / normal(noprint);
RUN;
title1 "Univariate Descriptives for Respondent's Partner's Height";
PROC FREQ DATA=b645.Chinese2;
	TABLES A_height;
RUN;
PROC UNIVARIATE DATA=b645.Chinese2;
	*ods select Moments BasicMeasures BasicIntervals Quantiles;
	var A_height;
	histogram A_height / normal(noprint);
RUN;

*#2: Regress A onto R, and then R onto A;
PROC REG DATA=b645.Chinese2;
Title1 "Regression of Partner's Height onto Respondent's Height";
   model A_height = R_height / CLB;
   ods output ParameterEstimates=PE; *saves the ParameterEstimates table to the PE data set;
RUN;
*Parameter Estimate for the slope = 0.33851
Intercept = 117.25;

PROC REG DATA=b645.Chinese2;
Title1 "Regression of Respondent's Height onto Partner's Height";
   model R_height = A_height/ CLB;
   ods output ParameterEstimates=PE2; *saves the ParameterEstimates table to the PE data set;
run;
*Parameter estimate for slope = 0.30482
Intercept = 107.12;

*Different because we are fixing different variables, which makes the strength of the 
relationship between the two variables different.;

*#3: The correlation value between A_height and R_height that we get from computing the 
Pearson test gives us 0.32123. The slope that we get from regressing z(A) onto z(R) is 0.32123, as well. ;
PROC CORR DATA=b645.Chinese2 FISHER;
Title1 "Correlation between Respondent's Height and Partner's Height";
	var A_height R_height;
RUN;

DATA b645.problem3;
	SET b645.Chinese2;
	zA = A_height;
	zR = R_height;
RUN;

PROC STANDARD data=b645.problem3 MEAN=0 STD=1 OUT=zout;
	VAR zA zR;
RUN;

PROC REG DATA=zout;
Title1 'Regression of z-score(A_height) onto z-score(R_height)';
	model zA = zR;
RUN;

*#4: Suppress the intercept and run the regression again;
PROC REG DATA=b645.Chinese2;
Title1 "Regression of A on R - suppress the intercept";
   model A_height = R_height/ NOINT CLB;
   ods output ParameterEstimates=PE2; *saves the ParameterEstimates table to the PE data set;
RUN;
DATA _null_; 
   set PE2; *In the PE data set, the ESTIMATE variable contains the parameter estimates;
   if _n_ = 1 then call symput('Slope', put(estimate, BEST6.)); 
RUN;

*#5: Using the results from regressing A onto R in #2, we can create a scatterplot representing the data;
PROC SGPLOT DATA=b645.Chinese2;
Title1 'Scatterplot of A_Height onto R_Height';
	SCATTER X=A_height Y=R_height / transparency=0.7;
RUN;

ods pdf close;