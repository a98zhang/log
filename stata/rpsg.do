/*==============================================================================

						Learning Handbook from RPSG's Codes

 =============================================================================*/


*** [P] macro - Macro definition and manipulation ***

	/* global <mname> : assign string to specified global macro names:
		- is accessible to all programs
		- prefixed by the dollar sign ($)
		- e.g. set global path: <data> is the mname, path is the string assigned */
	global data "R:\Assessment & Accountability\RPSG\EVALUATIONS\School Time Lab\Benchmarks\2018\Cohort 2 Working Files"
	import delimited "$data\Data\Cohort.csv", clear

	/* local <mname>: assign string to specified local macro names:
		- is accessible only within this program
		- is enclosed in the special quotes (`'')
		- e.g. set varlist: soup_years is a set/list of variables*/
	local soup_years 2011-12 2012-13 2013-14 2014-15 2015-16 2016-17 2017-18 //2018-19

	/* tempfile <mname>: assigns names to the specified local mnames that may be used as names for temporary files*/ 
	tempfile cohort


*** [P] foreach - Loop over items ***

	/* foreach <lname> in <any_list>: 
		- repeatdly sets local macro lname to each element of the list and execute*/
	foreach soup_year in `soup_years' {}

*** [P] capture -- Capture return code ***

	/* capture [:] command
	- executes command, suppressing all its output(including error messages, if any)
	and issues a return code of zero. 
	- useful as program terminates when a command issues a nonzero return code
	- allows program to continue despite errors. */
	cap destring grade_level, replace


*** [P] more -- Pause until key is pressed ***
	
	/* set more {on|off} [, permanently]
	- set more off, which is the default, tells Stata not to pause or display a --more-- message.  
	- set more on tells Stata to wait until you press a key before continuing when a --more-- message is displayed.*/
	set more off





*** [D] save - Save stata dataset ***

	/* save <filename>, replace
		- replace: overwrite existing dataset */
	save `credit', replace




*** [D] import/export - Overview of importing/exporting data from Stata ***

	/* export excel [using] <filename>: creates excel worksheets 
		- firstrow(variables): save variables names to first row
		- sheetreplace: replace Excel worksheet
		- sheet("sheetname"): save to Excel worksheet <sheetname>*/
	export excel using "$data\Cohort 2_Working File.xlsx", firstrow(var) sheetreplace sheet("Cohort Totals")

	/* import delimited [using] <filename>: import comma-separated or tab-delimited files */
	import delimited "$credits\\`soup_year'_Credits.csv", clear




*** [D] collapse - Make dataset of summary statistics ***

	/* collapse (stat) <varlist>, by(<varlist>)
		- by: groups over which stat is to be calculated
		- e.g. stat here is <count>, i.e. # nonmissing observations
			varlist here is <cohort grd9_year grad_cohort_yr> */
	collapse (count) student_id, by(cohort grd9_year grad_cohort_yr)
	collapse (sum) math_credits_earned sci_credits_earned, by(student_id)
	collapse (mean) math sci (count) cohort_total=student_id (sum) math_total=math sci_total=sci, by(cohort grad_cohort_yr)

	/*  collapse [(stat)] target_var=varname [target_var=varname ...] 
		- store the stat of <varname> into <target_var>
		- e.g. count of student_id is stored in cohort_total*/
	collapse (mean) geo alg2 sci (count) cohort_total=student_id (sum) geo_total=geo alg2_total=alg2 sci_total=sci, by(cohort grad_cohort_yr)






*** [D] append - Append datasets

	/* append using <filename>:
		- appends Stata-format datasets stored on disk to the end of the dataset in memory
		- e.g. the filename here is `credit'*/
	if (`count' != 0) append using `credit'



*** [D] merge - Merge datasets ***

	/* merge joins corresponding observations
		- from the dataset currently in memory (called the master dataset) with those from filename.dta (called the using dataset)
		- creates a variable, _merge, containing numeric codes concerning the source and the contents of each obs.in the merged dataset.*/

	/* merge 1:1 <varlist> using <filename>: one-to-one merge on specified key variables
		- e.g. master dataset: credit, using dataset: cohort
			drop if the obs. only appear in credit*/
	merge 1:1 student_id using `cohort'
	drop if _merge == 1
	drop _merge

	/* merge m:1 varlist using filename: Many-to-one merge on specified key variables
		- the key variable(s) uniquely identify the observations in the using data, but not necessarily in the master data
		- e.g. going over every id in June_Bio and merge the info in June_Bio into regents*/
	merge m:1 student_id using `june'
	keep if _merge == 3









*** [D] gsort - Ascending and descending sort ***

	/* gsort [+|-] varname [[+|-] varname 
		- + or nothing: sort in ascending, - in descending
		- e.g. sort student_id in ascending while admit_data in descending*/
	gsort student_id -admit_date












*** [D] by -- Repeat Stata command on subsets of the data ***

	/* by varlist: stata_cmd
		- repeats the cmd for each group of observations for which the values of the variables in varlist are the same.  
		- by without the sort option requires that the data be sorted by varlist
		- _N contains the total number of observations in the subset
		- _n contains the number of the current observation, i.e. n-th.
		- e.g. for each student_id, see if there are duplicate records*/
	by student_id: gen dup = cond(_N==1,0,_n)






*** [D] destring -- Convert string variables to numeric variables ***

	/*  destring [varlist] */
	cap destring grade_level, replace






*** [D] duplicates -- Report, tag, or drop duplicate observations ***

	/* duplicates report [varlist] [if] [in]: report duplicates
		- produces a table showing observations that occur as one or more copies and indicating how many observations are "surplus"*/
	duplicates report student_id

*** [D] odbc -- Load, write, or view data from ODBC sources ***

	/* odbc(open database connectivity): API for accessing data mgt systems 
		- the command odbc lets one execute SQL queries within Stata, instead of needing to use SQL Server to pull data and then importing into Stata
		- more efficient, eaiser to update with live data, and avoid opportunities for error
		- first need to configure Windows to establish ODBC connection with the SQL servers you want to pull data from*/

	/* odbc load [extvarlist] [if] [in] ,
             {table("TableName")|exec("SqlStmt")}
             [load_options connect_options]
		- Import data from an ODBC  data source
		- exec("SqlStmt"): SQL SELECT statement to generate a table to be read into Stata
		- dsn("DataSourceName"):name of data source */
	odbc load, exec("SELECT coursecd, exam_type, description FROM prl.lookup_regent_coursecd WHERE exam_type in ('ACT','SAT')") dsn("SPR_INT")

*** [FN] Programming functions ***

	/* cond (x,a,b[,c]):
		- a if x is true and nonmissing
		- b if x is false
		- c if x is missing; a if c is not specified and x evaluates to missing
		- e.g. math = ">=8" ? 1 : 0 */
	gen math = cond(math_credits_earned>=8&math_credits_earned!=.,1,0)

	/* inlist(z,a,b,...):
		- 1 if z is a member of the remaining arguments; otherwise, 0*/
	keep if inlist(exam_subject, "geom", "algt", "chem", "esci", "phys")














*** [R] tab - Tabulate ***

	/* tab <>,m
		- m = abbrev. of missing: treat missing values like other values*/
	tab cohort,m



/*------------------------------------- SQL ----------------------------------*/

*** SELECT ***

	/* SELECT <distinct> select_list [ FROM table_source ] [ WHERE search_condition ] 
		- select_list: specifies the fields of a table whose value one wants to fetch
		- FROM: specifies one or more tables 
		- WHERE: specifies which rows to retrieve.
		- distinct: return only distinct values in the specified columns
					if multiple columns, combinate values in all specified fields to evaluate the uniqueness. */
	odbc load, exec("SELECT coursecd, exam_type, description FROM prl.lookup_regent_coursecd WHERE exam_type in ('ACT','SAT')")
	odbc load, exec("SELECT distinct SchoolYear, StudentID FROM dbo.Hsst_tbl_StudentMarks WHERE SchoolYear = 2018") dsn("SIF")