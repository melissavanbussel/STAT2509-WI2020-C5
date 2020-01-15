/* This is how you create comments in SAS */ 

/* You can also create multi-line comments 
   if you want to do so. Comments will not be 
   run as code. */ 

/* Include a footnote with your name / student number on your assignments */ 
/* Is SAS case sensitive? */
FOOTNOTE "Student Name: Your Name; Student Number: 123456789"; 

/* To save the output of your program to a PDF file on your computer: */ 
/* Note: to change where you save this on your computer, just change the part before the filename */
/* For example: C:/Users/YourName/Documents/MyFolder/filename.pdf */ 
ODS PDF FILE = "P:/filename.pdf";

/* Creating a dataset in SAS */ 
/* Note: the @@ allows you to enter more than one entry per line. */ 
/* The dataset gets saved to the "work" library by default (temporary) */ 
DATA Grades;
	ATTRIB X LABEL = "Number Correct on Test 1";
	ATTRIB Y LABEL = "Number Correct on Test 2";
	INPUT X Y @@;
	DATALINES;
	11 9 14 15 19 18
	24 22 28 28 32 37
	35 37 40 38 46 43 
	;
RUN;

/* Use REG procedure, save results in a variable called MyResults */ 
/* The CLB option computes (1-alpha)*100% confidence intervals for the parameter estimates */ 
PROC REG DATA = work.Grades OUTEST = MyResults; 
	MODEL Y = X / CLB;
RUN;

/* Create a macro variable to store the regression equation, the variable is called "eqn" */
DATA _NULL_;
   SET MyResults;
   CALL SYMPUT("eqn", "Grade on Test 2 = " ||Intercept|| " + " ||X|| " Grade on Test 1");
RUN;
/* We can use a PUT statement to see the regression equation, printed out to the log */
%PUT The regression equation is &eqn;

/* First, we create a new table called Add_New_Entries */ 
/* We fill it with the values in the table Grades */ 
/* Then we create two new rows: one for X = 45 and one for X = 48 */
/* We use " . " as a placeholder */ 
PROC SQL;
	CREATE TABLE Add_New_Entries AS 
		SELECT *
		FROM Grades;
	INSERT INTO Add_New_Entries
		VALUES (45,.)
		VALUES (48,.);
QUIT;

FOOTNOTE;
ODS PDF CLOSE;
