*======================================================================
This is the SAS code for MLR Chemist class example.
======================================================================;
footnote 'Name, Student ID'; 	* Add your name and student number as 
								a footnote;
options pagesize=45; 	* Set the number of lines on each page
 						to 45;
ods pdf file="P:/assignment2.pdf";
data chemist;	* Input data by creating a data set
 				called "chemist", with weight=y,
 				time=x1 and humidity=x2;

input weight time humidity @@;
humidsq=humidity*humidity;	* defining a new variable x2^2
							as x2*x2;
interact=time*humidity;	* defining an interaction term x1x2
 						as x1*x2;
inter3=time*humidsq;	* defining an interaction term x1x2^2
						as x1*x2^2;
cards;
 4.3 4 0.2 5.5 5 0.2 6.8 6 0.2 8.0 7 0.2 4.0 4 0.3 5.2 5 0.3
 6.6 6 0.3 7.5 7 0.3 2.0 4 0.4 4.0 5 0.4 5.7 6 0.4 6.5 7 0.4
run;

ods graphics off; * to turn off unnecessary graphical
 					outputs coming from proc reg;
proc reg;
 model weight=time humidity humidsq interact inter3; 	*entering
 														the full model;
run;


proc reg;
 model weight=time humidity humidsq;	* Entering
 										the reduced model,
 										i.e. without interaction terms;
run; 

/* Example using dummy variables (time permitting) */

data dummyvariables;
	input sex $ X2 weight@@;
	if sex = "M" then X1 = 1; else X1 = 0;
	X1X2 = X1*X2;
	cards;
F 56 140 F 60 155 F 64 143 F 68 161 F 72 139 
M 54 159 M 62 138 M 65 121 M 65 161 M 70 145 
F 56 117 F 60 125 F 64 133 F 68 141 F 72 149 
M 54 109 M 62 128 M 65 131 M 65 131 M 70 145 
F 64 211 F 68 223 F 72 235 F 76 247 F 80 259 
M 62 201 M 69 228 M 74 245 M 75 241 M 82 269
;
run;

/* Test if the impact of height on weight differs between men and women. */
/* Full model: Y = B0 + B1X1 + B2X2 + B3X1X2 */ 
/* Men: X1 = 1 */
/* Women: X1 = 0 */
/* Impact of height on weight for men: Y = B0 + B1(1) + B2X2 + B3(1)X2 */ 
/* Impact of height on weight for women: Y = B0 + B1(0) + B2X2 + B3(0)X2 */
/* To test if the slopes are the same, we are therefore testing H0: B1 = B3 = 0 */
proc reg data = dummyvariables;
	model weight = X1 X2 X1X2;
	model weight = X1 X2;
run; 


ods pdf close;

