// Chapter 1 Introduction

	sysuse cancer, clear
	describe
	notes
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
	
	// encoding 
	label define sex 1 "Male" 2 "Female" // "sex" is the nickname for the set of value label
	label values gender sex 			 // apply the set to the variable
		// defined labels may also apply to multiple variables that share identical value labels
		label define rating 1 "Very poor" 2 "Poor" 3 "Okay" 4 "Good" 5 "Very good" -9 "Missing"
		label values sch_st rating
		label values sch_com rating
	
	// edit and browse
	edit, nolabel
	browse, nolabel
	
	
