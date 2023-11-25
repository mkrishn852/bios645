* HW 4 SAS Code: Maya Krishnamoorthy;

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
data b645.steroids;
	infile "/home/u59228083/BIOS645/Women's_steroid_levels.txt" 
           dlm="09"X firstobs=2;
	input age steroid;
run;

/* 
I'll start with basic tables & plots to explore the data,
looking at bi-variate distributions
*/
proc sgplot data=b645.steroids;
	title1 "Scatter Plot: Women's Age vs. Level of Steroid in Bloodstream";
	scatter X=age Y=steroid;
	reg     X=age Y=steroid  /nomarkers;
run;

/* Looking at the distribution of each variable independently
*/
proc means data=b645.steroids N MIN MEDIAN MAX MEAN STD SKEW KURT MAXDEC=3;
	title1 "Distribution of Variables Age and Steroid Level";
	var age steroid;
run;

/* Regression Attempt #1 on dataset is straightforward
*/
proc reg data=b645.steroids plots=(residuals(smooth));
title1 "Regressing Steroid Level in Bloodstream on Age";
model steroid=age /clb;
run;

data b645.steroids2;       * the new dataset is made by;
	set b645.steroids;     * reading in the original; 
	age2 = age**2; * then adding 2 new vars by;
	steroid2 = steroid**2;    * squaring the original ones;
run;

*Running regressions on different polynomial possibilities;
proc reg data=b645.steroids2 plots=(residuals(smooth));
title1 "Regressing Steroid Level in Bloodstream squared on Age squared";
model steroid2=age2 /clb;
run;

proc reg data=b645.steroids2 plots=(residuals(smooth));
title1 "Regressing Steroid Level in Bloodstream squared on Age";
model steroid2=age /clb;
run;

proc reg data=b645.steroids2 plots=(residuals(smooth));
title1 "Regressing Steroid Level in Bloodstream on Age squared";
model steroid=age2 /clb;
run;