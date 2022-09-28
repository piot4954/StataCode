/******************************************************************************************
***     Programmer: Martin Piotrowski
***     Begin Date: 8/25/2022
***		Date Modified: 8/29/2022
***     Purpose:
***             This program creates examples of Stata/LaTex integration for ADQUANT presentation
***
***		Status: In Progress
***
***     Input Data: 
***
***     Output Data: 
***
***
***
***
*******************************************************************************************/

*********************
* Install Ado Files *
*********************

/*
//bcuse - bring in data from BC archive
findit bcuse
net from http://fmwww.bc.edu/RePEc/bocode/b
net install bcuse, replace

//Estout, estab, etc.
ssc install estout, replace

findit matselrc
net from http://www.stata.com/stb/stb56
net install dm79, replace
*/

****************************
* set preprocessor options *
****************************

//Change Working DIrectory
cd "C:\Users\piotrow\Documents\Department\ADQUANT"

*****************
* Bring in Data *
*****************

//Clear Memory
clear

//Wooldridge Data Set, 'Fertility2'
bcuse fertil2

desc

*************************************
* Poisson Model, Children Ever Born *
*************************************

//Poisson Model
poisson ceb age agesq educ evermarr usemeth protest catholic

eststo model1

*** Long Format Tables ***

//Table of Results, No Formatting
esttab model1 using table1a.tex, replace // Can Use MiKTeX/Overleaf to Compile in LaTex

//Table, Add Formatting, No LaTex
esttab model1 using table1b.tex, replace ///
	   nodep nonum noparen label ///
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "Protestant" ///
			 catholic "Catholic") ///
		title("Poisson Model of Children Everborn") ///
		mtitle("Model 1") eqlabel("Variables") ///
		stats(N ll, fmt(0 2) label("Num of Obs" "Log Likelihood")) ///
		note("Source: Wooldridge Dataset 'Fertility2'")
		
//Table, Add Formatting, With LaTex
esttab model1 using table1c.tex, replace ///
	   booktabs alignment(D{.}{.}{-1}) /// 'Booktabs' Theme ("booktabs" must be in preamble) and Decimal Point Alignment ("dcolumn" must be in preamble)
	   nodep nonum noparen label ///
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" /// LaTex tab delimiter
			 catholic "\quad Catholic") /// LaTex tab delimiter
		title("Poisson Model of Children Everborn") ///
		mtitle("Model 1") eqlabel("\textbf{Variables}") /// Boldface embedded LaTex code
		stats(N ll, fmt(0 2) label("Num of Obs" "Log Likelihood")) ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel) // Header (not LaTex)

*** Wide Format Tables ***		
		
//Table, Add Formatting, With LaTex, Wide Form
esttab model1 using table1d.tex, replace ///
	   booktabs alignment(D{.}{.}{-1}D{.}{.}{-1}) ///
	   nodep nonum noparen label wide /// Note "wide" option (not laTex)
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Poisson Model of Children Everborn") ///
		mtitle("Model 1") eqlabel("\textbf{Variables}") ///
		stats(N ll, fmt(0 2) label("Num of Obs" "Log Likelihood")) ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel)

//See Stored Results
ereturn list 

//Display Matrix of Coefficient Estimates
mat list e(b)
		
//Table, Add Formatting, With LaTex, Wide Form
esttab model1 using table1e.tex, replace ///
	   cells("b(fmt(2) label(\beta)) se(fmt(2) label(SE))") /// Note "cells" argument for column headings
	   booktabs alignment(D{.}{.}{-1}D{.}{.}{-1}) ///
	   nodep nonum noparen label wide ///
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Poisson Model of Children Everborn") ///
		mtitle("Model 1") eqlabel("\textbf{Variables}") ///
		stats(N ll, fmt(0 2) label("Num of Obs \ignore{" "} \\ Log Likelihood \ignore{") /// Embedded Latex Code to Ignore Extra Column Separator
			  layout("}&\multicolumn{2}{c}{@}\ignore{" ///
					 "}&\multicolumn{2}{c}{@}\ignore{" )) ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel) ///
		postfoot("} \\ \bottomrule" /// Custom footer
				 "\multicolumn{3}{l}{\footnotesize Source: Wooldridge Dataset 'Fertility2'}\\" ///
				 "\multicolumn{3}{l}{\footnotesize \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\)}\\" ///
				 "\end{tabular}" ///
				 "\end{table}")
				 
*** Long Format, Groups ***

//Loop Over Urbanicity Samples
forvalues i = 0/1 {

	//Poisson Models, by Urbanicity
	poisson ceb age agesq educ evermarr usemeth protest catholic if urban == `i'

	eststo model2_`i'
	
}
				 
//Table, Add Formatting, With LaTex
esttab model2_0 model2_1 using table2a.tex, replace /// Estimates Change (2x)
	   booktabs alignment(D{.}{.}{-1}) ///
	   nodep nonum noparen label ///
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Poisson Model of Children Everborn, by Urbanicity") ///
		mtitle("Non-Urban" "Urban") eqlabel("\textbf{Variables}") /// mtitle changes
		stats(N ll, fmt(0 2) label("Num of Obs" "Log Likelihood")) ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel)

//Nested Loop: Urbanicity-Contractive Use Method (i indexes urbanicity, j indexes contraceptive use method)
forvalues i = 0/1 {
	forvalue j = 0/1 {

		//Poisson Models, by Urbanicity-Contractive Use Method
		poisson ceb age agesq educ evermarr /*usemeth*/ protest catholic if urban == `i' & usemeth == `j'

		eststo model3_`i'_`j'
	
	}	
}

//Table, Add Formatting, With LaTex
esttab model3_0_0 model3_0_1 model3_1_0 model3_1_1 using table3a.tex, replace /// Estimates Change (4x)
	   booktabs alignment(D{.}{.}{-1}) ///
	   nodep nonum noparen label ///
	   coefl(age "Age (in Years)" ///
			 agesq "Age Squared"  ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Poisson Model of Children Everborn, by Urbanicty \& Contraceptive Use") ///
		mgroups("Non-Urban" "Urban", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) /// Added Group Heading
		mtitle("No Method" "Use Method" "No Method" "Use Method") eqlabel("\textbf{Variables}") /// mtitle changes
		stats(N ll, fmt(0 2) label("Num of Obs" "Log Likelihood")) ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel)

***************************
* Table of Fit Statistics *
***************************

//Calculate Fit Statistics
estimates stats model1 model2_0 model2_1 model3_0_0 model3_0_1 model3_1_0 model3_1_1

//See Stored Results
return list

//Matrix of Results (automatically generated)
mat list r(S)

mat MFit = r(S)

//Change Row Names of Matrix
mat rownames MFit = "Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7"

mat list MFit

//Extract Only Select Matrix Columns
matselrc MFit MSel, col(1 3 5 6)

mat list MSel

//Table 
esttab matrix(MSel, fmt(%9.0f %9.3f %9.3f %9.3f)) using table3b.tex, replace /// Note multiple formats
	   alignment(rD{.}{.}{-1}D{.}{.}{-1}D{.}{.}{-1}) /// Note multiple/mixed alignments
	   mtitle("") title("Fit Statistics for Poisson Model") ///
	   note("Source: Wooldridge Dataset 'Fertility2'") booktabs
		
**************************		
* Descriptive Statistics *
**************************

//Calculate Descriptive Statistics
estpost tabstat ///
		ceb age /*agesq*/ educ evermarr usemeth protest catholic ///
		, s(mean sd) c(s)

eststo DescTot
		
//Table
esttab DescTot using table4a.tex, replace ///
	   booktabs align(rr) /// Note align argument
	   nodep nonum noparen label ///
	   cells("mean(fmt(2) label(Mean)) sd(fmt(2) label(SD))") /// Note cells argument
	   coefl(ceb "Children Ever Born" ///
			 age "Age (in Years)" ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Descriptive Statistics") ///
		mtitle("") ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel)

*** Multiple Groups ***
		
forvalues i = 0/1 {
	forvalue j = 0/1 {

		//Calculate Descriptive Statistics, by Urbanicity-Contractive Use Method
		estpost tabstat ///
		ceb age /*agesq*/ educ evermarr usemeth protest catholic ///
		if urban == `i' & usemeth == `j', s(mean sd) c(s) 
		
		eststo DescTot_`i'_`j'
	
	}	
}

//Table
esttab DescTot_0_0 DescTot_0_1 DescTot_1_0 DescTot_1_1 DescTot using table5a.tex, replace ///
	   booktabs align(rrrrrrrrrr) /// Note align argument (x5)
	   nodep nonum noparen label ///
	   cells("mean(fmt(2) label(Mean)) sd(fmt(2) label(SD))") /// Note cells argument
	   coefl(ceb "Children Ever Born" ///
			 age "Age (in Years)" ///
			 educ "Education (in Years)" ///
			 evermarr "Ever Married" ///
			 usemeth "Used Contraception" ///
			 protest "\quad Protestant" ///
			 catholic "\quad Catholic") ///
		title("Descriptive Statistics, by Urbanicty \& Contraceptive Use") ///
		mgroups("Non-Urban" "Urban" "", pattern(1 0 1 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) /// 
		mtitle("No Method" "Use Method" "No Method" "Use Method" "Total") eqlabel("\textbf{Variables}") ///
		note("Source: Wooldridge Dataset 'Fertility2'") ///
		refcat(protest "Religion", nolabel)

***************************		
* Frequency Distributions *
***************************

//Frequency Table of Children Ever Born
estpost tab ceb

eststo percTot

forvalues i = 0/1 {
	forvalue j = 0/1 {

		//Frequency Distribution, by Urbanicity-Contractive Use Method
		estpost tab ceb if urban == `i' & usemeth == `j'

		eststo percTot`i'_`j'
	
	}	
}

//Table
esttab percTot0_0 percTot0_1 percTot1_0 percTot1_1 percTot using table6a.tex, replace ///
	   cells("pct(fmt(2) label(\%))") ///
	   booktabs align(rrrrr) nonum ///
	   title("Percentage Distribution Children Ever Born") ///
	   mgroups("Non-Urban" "Urban" "", pattern(1 0 1 0 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) /// 
	   mtitle("No Method" "Use Method" "No Method" "Use Method" "Total") ///
	   note("Source: Wooldridge Dataset 'Fertility2'")