use http://www.stata-press.com/data/agis4/relate
	
	
	// missing-value decode
	mvdecode _all, mv(-5=.a\-4=.b\-3=.c\-2=.d\-1=.e)
	

	
	// creating value labels
	varmanage	
	
		label variable R3483600 "Mother praises child for doing well"
		label variable R3483700 "Mother criticizes child’s ideas"
		label variable R3483800 "Mother helps child with what is important to child"
		label variable R3483900 "Mother blames child for problems"
		label variable R3485200 "Father praises child for doing well"
		label variable R3485300 "Father criticizes child’s ideas"
		label variable R3485400 "Father helps child with what is important to child"
		label variable R3485500 "Father blames child for problems"
		
		label define often 0 "Never" 1 "Rarely" 2 "Sometimes" 3 "Usually" 4 "Always"/// 
		.a "Noninterview" .b "Valid skip" .c "Invalid skip" .d "Don't know" .e "Refused"
		
		label values R3483600 often
		label values R3483700 often
		label values R3483800 often
		label values R3483900 often
		label values R3485200 often
		label values R3485300 often
		label values R3485400 often
		label values R3485500 often
		

	
	// reverse-code variables: to create new variables
	recode R3483700 R3483900 R3485300 R3485500 (0=4) (1=3) (2=2) (3=1) (4=0), ///
	generate(momcritr momblamer dadcritr dadblamer)

	tabulate momcritr R3483700
	
	label define often_r 4 "Never" 3 "Rarely" 2 "Sometimes" 1 "Usually" 0 "Always" ///
	.a "Noninterview" .b "Valid skip" .c "Invalid skip" .d "Don’t know" .e "Refusal"
	
	label values momcritr momblamer dadcritr dadblamer often_r
	
	
	// creating and modifying variables
	clonevar mompraise = R3483600
	clonevar momhelp = R3483800
	clonevar dadpraise = R3485200
	clonevar dadhelp = R3485400
	clonevar id = R0000100
	clonevar sex = R3828700
	clonevar age = R3828100
	
	generate facritr = 4 - R3485300
	
	tabulate facritr R3485300, miss nolabel
	
	// creating scales
	egen float mommissing = rowmiss(mompraise momcritr momhelp momblamer)
	tab mommissing
	
			// 1) computing the mean
		egen float mommeanc = rowmean(mompraise momcritr momhelp momblamer)
		// 2) setting minimum number of items
		egen float mommeanb = rowmean(mompraise momcritr momhelp momblamer) if mommissing < 2
	
	
	// saving some of my data
	drop R0000100 R3483600 R3483700 R3483800 R3483900 R3485200 R3485300 R3485400 ///
	R3485500 R3828100 R3828700

	
	
	
// chapter 5
use http://www.stata-press.com/data/agis4/descriptive_gss, clear	

tab1 sex marital polviews	
	
	
	fre sex marital polviews
	
		histogram polviews, discrete percent ///
		title(Political Views in the United States) subtitle(Adult Population) ///
		note(General Social Survey 2002) xtitle(Political Conservatism) scheme(s1mono)
		
		
			graph hbox wwwhr if wwwhr < 25, over(sex) ///
		title(Hours Spent on the World Wide Web) subtitle(By Gender) ///
		note(descriptive_gss.dta)
		
		
		
			use http://www.stata-press.com/data/agis4/nlsy97_chapter11, clear
	logistic drank30 age97 male pdrink97 dinner97
	
