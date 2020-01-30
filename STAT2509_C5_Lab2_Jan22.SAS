/* IMPORTANT: OFFICE HOURS HAVE BEEN CHANGED TO WEDNESDAYS 3:30-4:30, HP5240 */ 

/*=======================================================================
This is the SAS 9 code for SLR class example on SLR.
=========================================================================*/ 
footnote 'Name, Student ID'; /* Add your name and student number as footnote */ 
options pagesize = 45; /* Set the number of lines on each page of your report to 45 */

/* Set the name of the PDF output file. */ 
ods pdf file = "P:/example1-output.pdf";
/*NOTE: Change the name "example1-output.pdf" according to your need
 (e.g. "A2.pdf"). */

/* Manually create a data set called "calculus": calculusfinal
(calculus final grade) is y and mathscore (math test score) is x */
data calculus;
input mathscore calculusfinal;
cards;
 39 65
 43 78
 21 52
 64 82
 57 92
 47 89
 28 73
 75 98
 34 56
 52 75
run;

/* Turn off unncessary graphical outputs from the reg
 procedure; */
ods graphics off;  

/* Regression analysis */
proc reg lineprinter data =  work.calculus; 
/* NOTE: The option "lineprinter" is used to generate
 traditional plots for the reg procedure. You do
 not need to use this option, i.e. you can
 simply use proc reg */

/*============================================================================
 Part (a): SPECIFY THE LINEAR REGRESSION MODEL AND GENERATE SCATTERPLOT.
=============================================================================
 Specify the regression model with calculusfinal being y and mathscore being
 x */
 model calculusfinal = mathscore;
 plot calculusfinal*mathscore = "*"; /* Create a scatterplot of the data, 
 "mathscore" on the x-axis and "calculusfinal" on the y-axis */

/*===========================================================================
 Part (b): GENERATING DIAGNOSTIC PLOTS.
============================================================================*/

 /* Plot predicted (fitted) response values yhat_i against residuals */
 plot R.*P. = "o"; 
 /* Plot explanatory variable x_i against residuals */
 plot R.*mathscore = "+";

 /* Create a new data set called "resid" containing the 
 residuals of the regression analysis */
 output out=resid R=resid; 
run;

/* Create histogram of the residuals */ 
proc chart;
 vbar resid;
run;

/*===========================================================================
 Part (c): PREDICTING y AT A NEW x VALUE.
============================================================================
 Create a new data set called "new" with a new x value but unknown y value
 (use a period as a placeholder for now)*/
data new;
input mathscore calculusfinal;
cards;
 50 .
run;

* Combine the new data set and the original data set "calculus";
data combine;
 set calculus new;
run;

/* Perform regression analysis and predict the y value at the new x value */ 
proc reg noprint data =  work.combine; 
/* NOTE: The "noprint" option disables estimation and
 testing results which has been reported
 by the first run of reg procedure. If you do
 not add "noprint" option (which is fine),
 you will get the estimation and testing
 results which you have already obtained and
 the prediction results */
 model calculusfinal = mathscore;
 print clm cli; /* Print the prediction results only */
run;

/* Everything that goes between the ods pdf file line and the line below will
be included in the pdf output */
ods pdf close;
