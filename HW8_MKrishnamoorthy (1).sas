*HW 7 SAS Code - Maya Krishnamoorthy

* Import data and label data;
libname b645 "/home/u59228083/BIOS645";
DATA b645.quiz;
	INFILE "/home/u59228083/BIOS645/Quiz_questions2.txt" DLM="09"X FIRSTOBS=2;
	INPUT student q13_y q13_x q22_y q22_x q41_y q41_x;
RUN;

* Let's look at the data;
Title1 "Examine the data frequency and means";
PROC MEANS DATA=b645.quiz;
RUN;

* Question 13 logistic regression with plot;
Title1 "Logistic Regression: whether or not the student answered question 13 correctly onto the total of other correct questions";
PROC LOGISTIC DATA=b645.quiz DESCENDING PLOTS(ONLY)=EFFECT;
	CLASS q13_y;
	MODEL q13_y = q13_x;
RUN;

* Question 22 logistic regression with plot;
Title1 "Logistic Regression: whether or not the student answered question 22 correctly onto the total of other correct questions";
PROC LOGISTIC DATA=b645.quiz DESCENDING PLOTS(ONLY)=EFFECT;
	CLASS q22_y;
	MODEL q22_y = q22_x;
RUN;

* Question 41 logistic regression with plot;
Title1 "Logistic Regression: whether or not the student answered question 41 correctly onto the total of other correct questions";
PROC LOGISTIC DATA=b645.quiz DESCENDING PLOTS(ONLY)=EFFECT;
	CLASS q41_y;
	MODEL q41_y = q41_x;
RUN;