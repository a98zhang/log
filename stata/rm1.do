// Describe the distribution: 

	// level/center

		// mode (eyeing)
	
		tabulate x		 		// first, inspect the distribution
		browse x
		egen modex = mode(x) 	// then identify

		// mean
		su x, detail
		di r(mean)

		// median
		su x, detail
		di r(p50)

	// spread

		// range
		su x
		di r(max)-r(min)

		// inter-quartile range
		su x, detail
		di r(p75)-r(25)

		// variance
		su x, detail
		di r(Var)

		// standard deviation
		su x, detail
		di r(sd)


	// convey the relative standing of the value of a quantitative variable

		// cumulative distribution
		capture cumul ses, gen(cum) freq
		sort cum
		twoway line cum ses

		// percentile rank
		su x, detail
		di r(p50)

		// standard score
		su x, detail
		di (50-r(mean)/r(sd))
		egen z_x = std(x)


// Univariate Distributions (e.g. for varible x)	

	// frequency distribution tables 
	tab x

	// bar graph
	graph bar (count/percent), over (x)

	// histogram
	histogram x, discrete percent

	// density plots
	kdensity x



// Bivariate Distributions (e.g. for x(predictor) on x-axis, y(outcome) on y-axis)
	
	// joint frequency distribution table		
	tabulate x y
		
	// bar graph (y is ratio, x is nominal/ordinal)
	graph bar y, over(x)
		
	// scatterplot
	twoway scatter y x
	twoway (scatter y x) (lfit y x)

	// describe scatterplot
	// The relationship is linear because it is fairly represented by the best-fit line. It is positive because higher values of one variable correspond to higher values of the other variable. It is moderate-to-strong because most points are close to the best-fit line.

// Drawing simple and stratified random sample

	// draw simple random sample
	set seed 12345
	generate random = runiform()
	egen order = rank(random)
	sort order
	generate sample = (order<=n)

	// draw stratified random sample (e.g. the stratum is represented by schoolid)
	set seed 54321
	generate random = runiform()
	egen strata = group(schoolid)
	bysort strata: egen order = rank(random)
	bysort strata: generate sample = (order<=_N/2)



// Conducting statistical power analyses

	// compute minimum sample size, given a difference	
	power onemean 100 120, sd(50) knownsd alpha(.05) power(.8)
	
	// compute minimum difference, given a sample
	power onemean 100, n(75) knownsd alpha(.05) power(.8)



// Estimating and Interpreting Correlations (e.g. x and y)

	// Pearson Coefficient

		// manually
		egen z_x = std(x)
		egen z_y = std(y)
		g mult = z_x*z_y
		total mult
		di [the total mult]/(n-1)

		// command
		corr x y     // exclude missing values
		pwcorr x y   // include missing values

		// graph scatterplot
		twoway scatter y x

	// Spearman Coefficient

		// manually
		egen rank_x = rank(x)
		egen rank_y = rank(y)
		g d = rank_x- rank_y
		g d_sq = d^2
		total d_sq
		di 1-((6*[the total d_sq])/n^3-n)

		// command
		spearman x y

	// Point Biserial Coefficient (x is the dichotomous variable)

		// manually
		sum y if x == 0 	// to find the mean0
		sum y if x == 1		// to find the mean1
		sum x  				// to find the std x
		sum y 				// to find the std y
		di (mean1-mean0)*sx/sy

		// command
		corr y x

// Reliability

	// Inter-item reliabilty

		// split-half reliability using Spearman-Brown prophecy formula 
		corr half1 half2 			//given variable half1 half2
		di (2*r(rho))/(1+r(rho))

		// averaging all possible split-half reliability: Cronbach's alpha 
		alpha item1-item4, asis

	// Inter-rater reliabilty

		// inter-rater agreement

		// Cohen's kappa

			// manually
			tab rater1 rater2		// given variable rater1 rater2
			di p0
			di pc
			di (p0-pc)/(1-pc)

			// command
			kap rater1 rater2

// Simple Linear Regression
	
	// manually

		// regression coefficient
		corr numeracy literacy
		// display r(rho)							// obtain correlation r
		su literacy
		// display r(sd)							// obtain st.dev. Sx
		su numeracy
		// display r(sd)							// obtain st.dev. Sy
		display r(*(18.14301/20.20522)

		// slope
		display 38.79725 - 0.6484*(18.14301/20.20522)*42.79361
	

	// command

	reg y x

	// R-squared 
		
		// 1.
		corr y x
		di r(rho)^2

		// 2. 
		di e(mss)/(e(mss)+e(rss))




// One-sample t-tests

	// whether the population mean is equal to c (e.g. for variable x)
	ttest x == c
	ttest math_g3==0 if treat==1

// Two-sample t-tests
	
	// independent samples t-tests
	ttest x, by (treat)

	// treatments 1 and 3
	ttest math_g3 if treat!=2, by(treat)

	// paired samples t-tests

// Multiple 


	//	Family-wise error rate for two comparisons
	di 1-(1-.05)^2
		
	//	Bonferroni-adjusted per-comparison error rate		
	di .05/2






// One-way Analysis of Variance (e.g. dv)

	// whether the population means are equal or not (e.g. treat)
	oneway dv treat, tabulate

	// whether there is an effect of one grouping variable (e.g. sex)
	oneway dv sex, tabulate

		// caculate p-value of the test manually
		di Ftail(dfb,dfw,f-ratio)


	// Post-hoc tests

		// HSD
		pwmean dv, over(iv) mcompare(tukey) effects    
										 // effects: hypothesis test & 95% CI

		// LSD
		pwmean dv, over(iv) mcompare(noadj) effects



// Two-way ANOVA: the effect of two independent variables (e.g., treat, sex)

	// run and store the results  (row factor first)
	anova dv treat sex treat#sex
	predict yhat

	// graph and table the results to inspect possible marginal and simple effects
	graph twoway (scatter yhat south if sex == 0, connect(L)) ///
	(scatter yhat south if sex == 1, connect(L)), ///
	legend(label(1 "Males") label(2 "Females"))

	table sex treat, contents (mean dv)

	// Post-hoc tests if significant interaction effect

		// store results from interation
		margins sex#treat, post

		// test the simple effects for treatments for different levels of sex
		test (1.sex#1.treat == 1.sex#2.treat) (1.sex#1.treat == 1.sex#3.treat)
		test (2.sex#1.treat == 2.sex#2.treat) (2.sex#1.treat == 2.sex#3.treat)

		// test the simple effects for sex for different levels of treatment
		test (1.sex#1.treat == 2.sex#1.treat)
		test (1.sex#2.treat == 2.sex#2.treat)
		test (1.sex#3.treat == 2.sex#3.treat)

		// pair-wise comparisons for all cell means
		pwcompare sex#treat, group

	// Post-hoc tests for significant main effect

		pwcompare sex, mcompare(tukey) effects
		pwcompare treat, mcompare(tukey) effects


