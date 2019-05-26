*stata-practice.do

// Chapter 1 Introduction

	sysuse cancer, clear
	describe
	notes
	codebook, compact
	summarize
	su age
	histogram age
	histogram age, width(2.5) start(45) frequency /// 
			title(Age Distribution of Participation in Cancer study) ///
			note(Data: Sample cancer dataset) legend(on) scheme(sinomo)
		
// Chapter 2 Entering Data
	
	// data entering 
	set obs 1
	generate var1 = 1 in 1
	generate var2 = 2 in 1
	rename var1 id 
	label variable id "Respondent's identification"
	rename var2 gender
	label variable gender "Participant's gender"
	//...
	
	// encode
	label define sex 1 "Male" 2 "Female" 		 // "sex" is the nickname for the set of value label
	label values gender sex 			 // apply the set to the variable: label values [var] [label]
		// defined labels may also apply to multiple variables that share identical value labels
		label define rating 1 "Very poor" 2 "Poor" 3 "Okay" 4 "Good" 5 "Very good" -9 "Missing"
		label values sch_st sch_com rating
	
	// edit and browse
	edit, nolabel
	browse, nolabel
	
	
// Chapter 3 Preparing data for analysis

	use http://www.stata-press.com/data/agis4/relate
	
	describe 
	codebook, compact
	
	// missing-value decode
	mvdecode _all, mv(-5=.a\-4=.b\-3=.c\-2=.d\-1=.e)
	
	// creating value labels
	varmanage	
	//...(see chapter 2 for codes)
	
	// reverse-code variables: to create new variables
	recode R3483700 R3483900 R3485300 R3485500 (0=4) (1=3) (2=2) (3=1) (4=0), generate(momcritr momblamer dadcritr dadblamer)
		// cross-tabulation to check
		tabulate momcritr R3483700
		
	// creating and modifying variables
	clonevar mompraise = R3483600		// clonevar [newname] = [oldname]   (maintain the missing values codes and value labels)
	generate mompraise = R3483600		// (maintain the missing value codes but not value labels)
		// generate can also create variables by using an arithmetic expression
		generate age_month = age*12		
	generate facritr = 4 - R3485300		// alternative way to reverse-code
	tabulate facritr R3485300, miss nolabel // tabulate [row] [col], miss -> including missing values, nolabel -> suppress value labels
	
	// creating scales *dealing with missing values
	// egen = extended generation
	egen float mommissing = rowmiss(mompraise momcritr momhelp momblamer)	// how many of the items are missing from each observation
	tab mommissing
		// 1) computing the mean
		egen float mommeana = rowmean(mompraise momcritr momhelp momblamer)
		// 2) setting minimum number of items
		egen float mommeanb = rowmean(mompraise momcritr momhelp momblamer) if mommissing < 2
	
	// saving some of my data
		// selected variables
		drop R0000100 R3483600 R3483700 R3483800 R3483900 R3485200 R3485300 R3485400 R3485500 R3828100 R3828700
		keep momcritr momblamer dadcritr dadblamer mompraise momhelp dadpraise dadhelp id sex age 
		// selected observations
		drop if age < 12
		keep if age >= 12 & age < 18 & gender == 1
		drop in 1/500					 // only observations 1 to 500


// Chapter 4 Working with commands, do-files and results
	
	// command structure
	[command] [varlist] if/in [exp/range], [options]
	
	use http://www.stata-press.com/data/agis4/firstsurvey_chapter4, clear
	
	list age education sex in 1/20 			// listing selected variables for a few cases, just to check logical errors
	list age education sex in 1/20, nolabel	
	numlabel _all, add				// add a numeric to each label for all variables
	list age education sex in 1/20

	// creating log files 
	

// Chapter 5 Descriptive statistics and graphs for one variable

	use http://www.stata-press.com/data/agis4/descriptive_gss, clear
	
	// Statistics and graphs - unordered categories
	tab sex
	tab1 sex marital polviews	// takea list of var and <tab> separately for each
		// install packages
		ssc install fre
	fre sex marital polviews	// useful for missing values and encoded variables
	// Stata allows graphics editors - use dialog box!
	graph pie, over(marital) 
	graph bar, over(marital)
	histogram marital		// the textbook recommends using histogram command to create bar graph
	
	// Statistics and graphs - ordered categories and variables
	numlabel_all, add
	tab polviews
	sum polviews, detail
	histogram polviews, discrete percent ///
		title(Political Views in the United States) subtitle(Adult Population) ///
		note(General Social Survey 2002) xtitle(Political Conservatism) scheme(s1mono)
		
	// Statistics and graphs - quantitative variables
		// test normality based on skewness and kurtosis: matters not so much for large sample
		sktest wwwhr
	by sex, sort: summarize wwwhr
	tabstat wwwhr, statistics(mean median sd iqr skewness kurtosis cv) by(sex) columns(statistics)
	histogram wwwhr, frequency
	histogram wwwhr if wwwhr < 25, frequency by(sex)
	graph hbox wwwhr if wwwhr < 25, over(sex) ///
		title(Hours Spent on the World Wide Web) subtitle(By Gender) ///
		note(descriptive_gss.dta)
	
// Chapter 6 Statistics and graphs for two categorical variables
	
	use http://www.stata-press.com/data/agis4/gss2006_chapter6, clear
	
	// cross-tabulation
	tabulate sex abany, row
	tabulate sex abany, chi2 expected row
	
	// chi-square test
	search chitable
	chitable
	
	// measures of association: Cramer’s V
	tabulate sex abany, chi2 row V

	// odds ratios when dv has two cateogories

	// interactive table calculator
	
	// tables linking categorical variables with quantitative variables
	
	// bar graph showing means of a quantative var differ across groups on a categorical var
	
	
// Chapter 10 Multiple regression
	
	use http://www.stata-press.com/data/agis4/ops2004, clear
	
	regress env_con educat inc com3 hlthprob epht3, beta
	
	
// Chapter 11 Logistic regression
	
	use http://www.stata-press.com/data/agis4/environ, clear
	
	use http://www.stata-press.com/data/agis4/nlsy97_chapter11, clear
	logistic drank30 age97 male pdrink97 dinner97 
	


