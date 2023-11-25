*BIOS 645: HW 1 - Maya Krishnamoorthy;

ods _all_ close;
ods rtf file='/home/u59228083/BIOS645/BIOS645_HW1.rtf';
ods graphics on;
ods noproctitle;

*Import the dataset on Chinese health and family life;
*Add labels to the variables for ease of reading;
LIBNAME b645 "/home/u59228083/BIOS645";
DATA b645.Chinese_age;
	INFILE "/home/u59228083/BIOS645/Chinese_health_&_family_life_study.txt" 
           DLM="09"X FIRSTOBS=2;
	INPUT R_region :$13. R_age    R_edu :$10. R_income R_health :$9. R_height 
          R_happy  :$15. A_height A_edu :$10. A_income; 
    LABEL R_region = "Respondent's region"
    R_age = "Respondent's age"
    R_edu = "Respondent's education level"
    R_income = "Respondent's monthly income"
    R_health = "Self-reported health status"
    R_height = "Respondent's height"
    R_happy = "Self-reported happiness"
    A_height = "Height of woman's partner"
    A_edu = "Education level of woman's partner"
    A_income = "Monthly income of woman's partner";
RUN;

*Compute the univariate descriptives for continuous variables;
*Create histograms to provide a summary of the distribution of the continuous variables;
title1 "Proc Univariate: Continuous Variable Distributions";
PROC UNIVARIATE DATA=b645.Chinese_age;
	*ods select Moments BasicMeasures BasicIntervals Quantiles;
	histogram R_age R_income R_height A_height A_income/normal(noprint);
RUN;

*Compute the frequency distribution for categorical variables;
*Create frequency plots to provide a visual summary of the distributions of the categorical variables;
title1 "Proc Freq: Categorical Variable Distributions";
PROC FREQ DATA=b645.Chinese_age;
	TABLES R_region R_edu R_health R_happy A_edu /NOCUM PLOTS=freqplot;
RUN;

*Continuous-Continuous Pair;
*Show Correlation Tables between Age and Height of Respondent;
*Create regression model and calculate the confidence interval of the slope;
*Save variables in the estimated model as intercept and slope;
*Create scatterplot with regression line to represent the relationship between age and height;
*Include slope and intercept;
title1 "Continuous-Continuous Pair Relationship Model";
PROC CORR DATA=b645.Chinese_age NOSIMPLE;  
	title2 'Bivariate Correlation for Continuous Variable Pair using PROC CORR';
	var R_age R_height;
RUN;

PROC REG DATA=b645.Chinese_age PLOTS=NONE;
	title2 "Regression Model for Continuous Variable Pair using PROC REG";
	MODEL R_height=R_age/CLB;
RUN;

PROC SGPLOT DATA=b645.Chinese_age;
	title2 "Scatter Plot: Relationship between Continuous Variables R_age and R_height";
	SCATTER X=R_age Y=R_height / TRANSPARENCY=0.7;
	REG     X=R_age Y=R_height;  * this draws a regression line over the scatterplot;
RUN;

*Continuous-Categorical Pair;
*Use PROC MEANS to show the relationship of mean age as a function of self-reported health;
*Create a boxplot to show visual relationship;
title1 "Continuous-Categorical Pair Relationship Model";
PROC MEANS DATA=b645.Chinese_age N MIN MEDIAN MAX MEAN STD SKEW KURT MAXDEC=3 NONOBS;
	title2 'Bivariate Relationship for Continuous-Categorical Variable Pair using PROC MEANS';
	VAR   R_age;  * means etc. for respondent age;
	CLASS R_health;      *  as a function of health yes or no;
RUN;

PROC SGPLOT DATA=b645.Chinese_age;
	title2 "Box Plot: Health Self-Reported Responses vs. Age";
	hbox R_age / category = R_health;
RUN;

*Categorical-Categorical Pair;
*Use PROC FREQ to create a table and a frequency plot of health vs. education level;
title1 "Categorical-Categorical Pair Relationship Model";
PROC FREQ DATA=b645.Chinese_age;
	title2 "Bivariate Relationship for Categorical-Categorical Variable Pair using PROC FREQ";
	TABLES R_health*R_edu / plots=freqplot NOCOL NOPCT; * row %s, but no column %s or cell %s;
	label R_health = "Health";
RUN;

ods rtf close;