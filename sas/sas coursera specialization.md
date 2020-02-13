Getting Started with SAS Programming

### 102. Accessing  data

##### Understanding Data

* missing numeric values are represented by a period, while missing characters by  blank. (technically treated as smallest possible values)
* SAS columns are either character or numeric. SAS date values are numeric values that represent the number of days before or after January 1, 1960.

* The `contents` procedure creates a report of the descriptor portion of the table.
```SAS
    proc contents data="FILEPATH/storm_summary.sas7bdat";
    run;
```


##### Accessing data through libraries

* a collection of data files with the same type in the same location; whenever restarting session, set library by running a code file.

* ```SAS
 *read SAS tables
	LIBNAME PG1 base "~/EPG194/data";
	```
	
* A `libref` must have a length of one to eight characters, and must begin with a letter or underscore. The remaining characters must be letters, numbers, or underscores.
  
* using a `library` to read excel files: establish a library to an Excel workbook and read or write data to Excel directly without having to do an extra step to import or export the data. (data is always current)
  
	```SAS
	*read Excel file
	options validvarname=v7;
	libname NP xlsx "~/EPG194/data/np_info.xlsx";
	proc contents data=NP.PARKS;
	run;
	libname NP clear;
	```

##### Importing data into SAS

* `import` procedure reads data from an external data source and writes it to a SAS data set (often applied to unstructured data to create a copy, data must be reimported if changed). 
	
	```SAS
	* read excel
	proc import datafile="FILEPATH/eu_sport_trade.xlsx"
	            dbms=xlsx
	            out=eu_sport_trade 
	            replace;
	            sheet=trade_details;
	run;
	
	* read csv
	proc import datafile="FILEPATH/eu_sport_trade.csv"
	            dbms=csv
	            out=eu_sport_trade 
	            replace;
	            guessingrows=MAX;
	run;
	```
	
	

### 103. Exploring and validating data

##### Exploring data

exploring data using procedures ( use `var` keyword to select variables that appear in the report and determine their order)
* `print` procedure creates a listing of all rows and columns 

  ```SAS
  *print: list first 10 rows
  proc print data=pg1.storm (obs=10);
      var Season Name Basin;
  run;
  ```

* `means` procedure calculates simple summary statistics (numeric columns)

  ```SAS
  *means: summary statistics
  proc means data=pg1.storm;
      var MinPressure;
  run;
  
  ```

* `univariate` procedure generates summary statistics but includes more details about distribution

  ```SAS
  *univariate: extreme values
  proc univariate data=pg1.storm;
      var MinPressure;
  run;
  ```

* `freq` procedure creates frequency table for each column (help find problems in the data)

  ```SAS
  *freq: 
proc freq data=pg1.storm;
      tables Basin Season;
  run;
  ```

##### Filtering rows

filtering rows using `where` statement followed by an `expression` procedures

```SAS
proc print data=pg1.storm;
	where MaxWindMPG >= 156 
		and Basin = "WP"
		or Basin in ("SI", "NI") ;
run;
```

* an `expression` tests the value of a column to the condition you specify for each row: `column` + `operator` +  `value`

* SAS data constant: `"ddmmmyyyy"`

  ```SAS
  proc print data=pg1.storm;
  	where StartDate >= "01jan2010"d;
  run;
  ```

* using `and`, `or`, `in`, `not` keywords

* `log` will show how many observations meet the filtering condition

* use `where also` to have multiple filtering conditions in different lines

  ```SAS
  proc print data=pg1.storm_summary;
  	where MaxWindMPH>156;
  	where also MinPressure>800 and MinPressure<920;
  run;
  ```

* special operators

  ```SAS
  proc print data=pg1.storm_summary;
      where Age is missing
      where Name is not missing
      where Item is null
      where Age between 20 and 39
      where City like "Sant_ %"
  ```

* use `' ` (single quotation mark) in `where` statement to avoid warning.

###### `macro` variable

* all statements in `macro` languages start with `%`, `let` define a macro variable, and macro variables are accessed through `&`, and only `"` (double quotation marks) can be used for reference. 
* macro variables are temporary

```SAS
%LET macro-var = value;
proc print data=pg1.storm_summary;
    where Type = "&macro-var";
run;
```

##### Formatting columns

use `format` keyword to format columns that will only affect the display in the report but will not change the raw data values: `format col-name <$>format-name<w>.<d>`

```SAS
proc print data=dta;
	format Height 3. Birthdate date9.;
run;
```

##### Sorting data and removing duplicates

use `sort` procedure for sorting data

* by default ascending

```SAS
proc sort data=input <out=output>;
	by <descending> cols;
run;
```

* identify and remove duplicates

```SAS
/* delete entirely duplicate rows*/
proc sort data=input <out=output>;
	noduprecs <dupout=dups>; 	
  	by _ALL_; 
run;

/* delete dup for particular col */
/* keep only first occurrence */
proc sort data=input <out=output>;
	nodupkey <dupout=dups>;
	by <descending> cols;
run;
```

  

### 104. Preparing data

##### Reading and filtering data

`data` step preserves the existing data and creates a new version of it

```SAS data 
LIBNAME out base "~/EPG194/output";
data out.Storm_cat5;
	set pg1.storm_summary;
	where StartDate >= "01Jan2000"d;
	keep Season MaxWindMPH;
	format MaxWindMPH 4.1;
run;
```

* two phases: compilation + execution
  * compilation phase checks for syntax error
  * execution phase works in a looping way and sequentially process statements for each row
* one cannot use the `set` statement to read unstructured data (csv)
* one can use the XLSX LIBNAME engine to read an Excel worksheet directly and process the data with the DATA step.
* to permanently store the output data, set a specific library (not use default `work`)
* use `where` statement in the `data` step to filter/subset rows
* use `drop` / `keep` statement to filter columns
* use `format` statement to **permanently** assigns a format to a column (when view/apply procedure, the format will always be applied), but does not change the raw data

##### Computing new columns

use `assignment` statement to create new column

```SAS
data cars_new;
	set sashelp.cars;
	Profit = MSRP - Invoice;
	format Profit 3.;
	keep Profit;
run;
```

* use `function` to generate new data values: `function(argument1, argument2, ...)`

  * numeric functions: `sum()`, `mean()`, `median()`, `range()` - ignore missing values
  * character functions: `cats()`, `upcase()`, `propcase`, `substr()`
  * date functions: `month()`, `year()`, `day()`, `today()`, `mdy()`, `yrdif()`

  ```SAS
  data output;
  	set input;
  	newvar = sum(var1, var2);
  	name = cats(lastn, firstn);
  	age = yrdif(b, today(), "age");
  run;
  ```

##### Conditional Processing

* use `if` , `then`, `else` logic to achieve conditional processing;

    ```SAS
    data car;
        set sashelp.cars;
        if MSRP =. then Group = .;
        else if MSRP < 3000 then Group = 1;
        else Group = 2;
        length Type $ 6;
        if MSRP =. then Type = .;
        else if MSRP<3000 then Type="Basic";
        else Type="Luxury"; 
    run;
    ```

* note dealing with missing values

* use `and`, `or` to achieve compound conditions

* use `length` statement to define character variable length before the conditional processing statements (if directly assign, latter assigned longer value may be truncated): `length char-var $ len` (location matters)

* only one executable statement following `then`

* to execute multiple statements, use `if-then/do`

  ```SAS
  data car;
      set sashelp.cars;
      length Type $ 6;
      if MSRP =. then do;
      	Group = .;
      	Type = '';
      end;
      else if MSRP < 3000 then do; 		Group = 1;
      	Type="Basic";
      end;
      else do;
      	Group = 2;
  		Type="Luxury";
      end;
  run;
  ```

### 105. Analyzing and Reporting on data
##### Enhancing reports with titles, footnotes, and labels

* SAS statements that can be used with any procedure to enhance a report  (global statements)
  * `title` for all reports in the session : `title<n> "text"` , up to 10 titles; similarly, `footnote`
  * `null title statement` (`title;`) to clear titles
  * `ods noproctitle` to turn off procedure titles; (and `ods proctitle` to turn it back on)

* use `macro` variables and functions

* use `label` statement in procedures to add temporary labels to columns. Most procedures except `proc print` will display label by default: `label col-name = "label-text";`To display label in `proc print` add `label` option. 

  ```SAS
  label MSRP="Manufacturer Suggested Retail Price"
        AvgMPG="Average Miles per Gallon"
        Invoice="Invoice Price";
  ```

* use `noobs` to turn off observation numbers

* use `by` statement to segment a report based on columns. Need to first sort based on this column. 

  ```SAS
  proc sort data=input out=sorted;
  	by type;
  run;
  proc freq data=sorted;
  	by type;
  	tables district;
  run;
  ```

* use `label` statement in `data` step to add permanent labels to columns.

##### Creating frequency reports

* use `options` added to `proc freq` statement to customize output and include additional statistics. 
  * `order=freq` to sequence report in descending frequency of the values of the variable
  * `nlevels` tells unique values

  ```SAS
  proc freq data=input order=freq nlevels;
  	tables Basin Season
  run;
  ```

* use `options` added to `tables` statement to customize output and include additional statistics. 

  * `/ nocum` eliminates cumulative frequency
  * use `format` 
  * use `ODS` graphics: `ods graphics on`. and add  `/ plots=freqplot` 

  ```SAS
  proc freq data=input;
  	tables Basin Season / nocum plots=freqplot(orient=horizontal scale=percent);
  	format StartDate monname.,;
  run;
  ```

* use `*` to create two-way frequency reports. 

  ```SAS
  proc freq data=input noprint;
  	tables Basin*Season / norow no col nopercent out=storm;
  	tables Region*Season / crosslist;
  	tables Region*Season / list;
  run;
  ```

##### Creating summary reports and data

use `proc means` to generate complex reports 

```SAS
proc means data=input <stat-list>;
	var col;
	class col;
	ways n ;
	output out="ttoe"
run;
```

* use `maxdec=` to determine the rounding
* use `class` to separate statistics and calculate values within groups  (no need to sort the data versus `by`)
* use `ways` to control how the values of the classification variables are used to segment the data
* use `output` statement to create a summary data set

### 106. Exporting data

##### Exporting data

* use `proc export` to export SAS table 

  ```SAS
  proc export data=input outfile="output" <dbms=option> <replace>;
  run;
  ```

* use `libname engine` to directly create data and write to files

  ```SAS
  libname libref xlsx "&outpath/file.xlsx";
  	<use libref for output tables>
  libname libref clear;
  ```

##### Exporting reports

* SAS' output delivery system (ODS): generate output object that can be rendered in one or more output formats (destination)

  ```SAS
  ods <destination> <dest-spec>;
  	<SAS code that produces output>
  ods <destination> close;
  ```

  * exporting to csv files (can specify order and format in comparison with `proc export`)

    ```SAS
    ods csvall file="&outpath/cars.csv";
    proc print;
    run;
    ods csvall close;
    ```

  * exporting to excel files
  
    ```SAS
    ods excel file="&outpath/file.xlsx" style=style options(sheet_name='label');
    <SAS code that produced output>
    ods excel options(sheet_name='label2');
    ods excel close;
    ```
  
    * `style` to specify a style: 
    * `options`keyword to enclose option-value pairs in parentheses. 
    * `proc template; list styles; run;` allows us to view different styles that are available 
    
  * exporting to PowerPoint and Microsoft Word
  
    ```SAS
    ods powerpoint file="";
    ods rtf file="" startpage=no;
    ```
    * use `startpage=no` option to eliminate the page break
  
  * exporting to PDF
  
    ```SAS
    ods pdf file="" style=style startpage=np pdftoc=n;
    ods proclabel "label1";
    <SAS codes for output>
    ods proclabel "label2";
    <SAS codes for output>
    ods pdf close;
    ```
  
    * use `pdftoc=option` to control the level of bookmarks that will expand 
    * use `ods proclabel` to label the bookmark 

### 107. Using SQL in SAS
```SAS
proc sql;
select clause 
from clause
    <where clause>
        <order by clause>;
quit;
```
##### use SQL in SAS

* language of most database management system to query, manipulate and report on tables;

* alternative paradigm for processing and reporting on tabular data, alternative to `data` step or certain `proc` steps

* use `sql` procedure in SAS
  * each statement in SQL executes immediately and independently
  * one query is one single statement with multiple clauses
  * use `where` to filter data and 
  * `order by` to sort output
  
  ```SAS
  title "title1";
  title2 "title2";
  proc sql;
  select Season, propcase(Name) as Name, StartDate format=date7. 
  	from pg1.storm(obs=n)
  	where Season > 2015
  	order by StartDate desc, Name;
  quit;
  title;
  ```

* create and delete tables in SQL

  ```SAS
  proc sql;
  create table work.myclass as 
  	select *; 
  quit;
  
  proc sql;
  	drop table work.myclass;
  quit;
  	
  ```

##### Joining tables using SQL in SAS

a `inner join` creates a new report or table that includes on the observations found in both tables

* `equijoin` is one specific type of inner join where only rows with identical values in a specific column produce a match
* requires an `on` clause to describe the criteria for matching rows in the table 
* qualify the column names by prefixing column by table names to avoid ambiguous column reference.
* use a table alias with `as` keyword: `tablename as alias`

```SAS
* inner join
proc sql;
select t1.A, B, C
	from table1 as t1 
		inner join table2 as t2
		on t1.Var = t2.Var;
quit;
```

# Doing More with SAS Programming

### 201. Controlling `data` step processing

##### Understanding `data` step processing: compilation + execution

* **compilation** phase: establish data attributes and rules for executions (pass through statements sequentially)
  1. check for syntax errors
  2. create the program data vector (PDV): each column and its attributes (name, type, length) 
     * used in execution phase one row a time
     * after a column and its attributes are established in PDV, cannot be changed
  3. establish rules for processing dat in the PDV
     * compilation-specific statements: `drop`, `keep`, `where` . For example, `drop` only marks column with a drop flag, which will make it dropped in execution. 
  4. create descriptor portion (meta data) 
* **execution** phase: follow the rules to read, manipulate and write data

##### directing `data` step output

* use `output` statement to control row output
  * by default an implicit `output ` and  `return`
  * use an *explicit* `output` statement to force SAS to write PDV contents (a row) - no implicit `output` any more at the conclusion but still implicit `return`
  * directing **when** and **where** to output

    ```SAS
    data t1 t2 t3;
        set input;
        if c1 then output t1;
        else if c2 then output t2;
        else output t3;
        output;
    run;
    ```
  ```
  
  ```
  
* use `drop=` / `keep=` dataset options to specify a unique list of columns for each table (PDV will keep track of them)

  ```SAS
  data t1(drop=c1 c2)
  	 t2(keep=c3);
  	 set input(drop=c2);
  ```

  * use `drop`/`keep` options in `set` statement if not needed for processing

  * use `drop`/`keep` options in `data` statement or `drop`/`keep` statement if can be needed for processing

  * if using un-kept columns to compute new columns, both columns will be in the output table but un-initialized. 

### 202. Summarizing data

##### Creating an accumulative column

```SAS
data output;
	set input;
	* Complete Ver.
	retain accum 0;
	accum = sum(accum, curr)
	* Shortcut Ver.
	accum+curr;
run;
```

* because all computed columns will be reset to `missing` for the new iteration, to create an accumulating column, one needs to overwrite the default behavior of PDV
* use `retain` statement (compile-time statement) to: `retain col <init-val>`
  * set initial value before the first iteration 
  * retain the value each time the PDV reinitialize
*  use `sum` statement as a shortcut for (1) creating column and setting initial value to 0 (2) retaining value of the column (3) add right column to accumulating column for each row  (4) ignoring missing values 

##### Processing data in groups

```SAS
proc sort data=input out=sorted;
	by Col;
	
run;
data output;
	set sorted;
	by Col;
	if expression;
	<statements for a subgroup>
run;
```

* use `by <descending> col` in `data` step to process data in sorted table (first use `proc sort` to sort data by columns) by groups 

* use `if` with `first.col` and `last.col` to subset rows in the execution phase

  * `first.col` and `last.col` are added to PDV (with values 0/1) - temporary and will be automatically dropped before writing each row to the output table
  * cannot use `where` statement (compile-time-statement) to subset rows using `first.col` and `last.col` because they do not exist in the input table
  * use `subsetting if expressions`,  processed during the execution phase
    *  if `true`, continue to execute the remaining statement 
    * if `false`, stop processing for that iteration and skip explicit/implicit `output` but just return, aka this row will not be written
    * use if as early as possible

  * to reset an accumulating column for each subgroup

    ```SAS
    data output;
    	set input;
    	by Col;
    	if first.Col=1 then accum=0;
    ```

  * use multiple `by` columns: each column has its own `first./last.`variables in the PDV: need to use  `first./last.`variables  for all columns

### 203. Manipulating data with functions

##### Understanding SAS functions and `call` routines

* function: name, predefined process to produce a value.

* specifying `column list` - a list of columns as arguments in a function 

  1. `col1-coln` 
  2. `string:` 
  3. `col--col`: physical range of columns from left to right in a table
  4. `_numeric_`/`_character_`/`_all_`

  * no need to use `of` keyword in `format` statement, but `of` is required when using column lists as argument in a function or `call` routine

  ```SAS
  /* Numbered Range: col1-coln where n is a sequential number */ 
  Mean2=mean(of Quiz1-Quiz5);
  /* Name Prefix: all columns that begin with the specified character string */ 
  Mean3=mean(of Q:);
  /* Physical Range */
  format Quiz1--AverageQuiz 3.0;
  /* Keywords */
  format _numeric_ comma.;
  ```

* use `call` routine to modify data: `call routine(argument-1, <...>)`
  
  ```SAS
  if Name in("Barbara", "James") 
  	then call missing(of Q:);
  ```
  
  * `call` routine performs a computation or a system manipulation based on the inputs (arguments), like functions.
  * does not return value but alters column values or perform other system functions
  * arguments must be column names

##### Using numeric and date functions

* Numeric functions:

    `rand('distribution', ...parameters)`: 

    `largest(k, ...columns)`

    `round(number<,round-unit>)`/`ceil`/`floor`/`int`

    * these functions alter the data by changing precision of while format only changes the display
    
    ```SAS
    id = rand("integer", 1000, 9999);
    R1st=largest(1, of Q:);
    R2nd=largest(2, of Q:);
    R3rd=largest(3, of Q:);
    Avg = round(mean(of R:), .1);
    ```

* Date, datetime (#seconds from 1/1/60 midnight), time (#seconds from midnight) values

  `datepart`/`timepart(datetime-value)`

  `intck('interval', start, end <,'method'>)`

  * discrete (`'D'`, default method): aka how many Saturday assume week ends at Saturday)
  * continuous (`'C'`)

  `intnx(interval, start, increment <,'alignment)`: adjust and shift date values

  ```SAS
  *extract data from a datetime val
  Date=datepart(ISO_Time);
  Time=timepart(ISO_Time);
  *calculate date 
  intck('week', begin, end, 'C');
  *shift dates
  NewDate=intnx('month', Date, 0, 'end'/'middle'/'same');
  ```

##### Using character functions

`upcase`/``propcase`/`substr`

`compbl`/`compress`/`strip`  to remove characters from a string

`scan` to extract words from a string

`find` to search for character string

* modifiers `'I'` case insensitive search
* modifiers `'T'` trim leading and training blanks

`length`/`anydigit`/`anyalpha`/`anypunct` 

`tranwrd` to replace character string

`cat`/`cats`/`catx` to combine strings 

```SAS
*remove characters
compbl(Col);
compress(Col, '- ');
*extract words
scan(Col,-1, ',');
*search substring
StartIdx=find(Col,'substr','modifier');
*replace string
NewS=tranwrd(S, '2019', '2020');
```

##### Using special functions to convert column type

* SAS automatically attempts conversion, but it may fail. Thus use special functions to control data conversion
  * `input(source, informat)` converts character to numeric providing format to read in data (specify most inclusive width but do not specify decimal point)

    ```SAS
    Date=input(DateStr,date9.);
    *generic informat for dates
    Date=input(DateStr,ANYDTDTEw.)
    *change date styles
    options datestyle=DMY;
    ```

  * `put(source, format)` converts numeric to character

    ```SAS
    Day=put(Date,downame3.);
    ```

* cannot use these functions to convert existing columns for the attribute from `set` controls the column type and cannot be changed later in the program

  ```SAS
  data output;
  	set input(rename=(Col=CharC));
  	Col=input(CharC, format);
  	drop CharC;
  run;
  ```

### 204. Creating and using custom formats

Formats that you use in the DATA step are  permanent attributes that are stored in the descriptor portion of the table. Formats that you use in a PROC step are temporary attributes.

##### Creating and using custom formats

* use `proc format` to create custom formats 

  ```SAS
  proc format;
  	value f-name val-or-range-1='formatted-val'
  				 val-or-range-2='formatted-val';
  	value f-name val-or-range-1='formatted-val';
  	
  	*character format example
  	value $genfmt 'F'='Female'
  				  'M'='Male';
  				  ' '='Missing'
  				  other='Miscode';
  	*numeric format example
  	value hrange 50-<58='Below'
  				 58-60='Average'
  				 60<-70='Above';
  run;
  ```

* using ranges:
  *  `x-y` includes both `x` and `y`, while `<` excludes its nearest value
  * keyword `low` and `high` reference to the lowest/highest possible value
  * keyword `other` includes all values that don't match any other value or range
  * if a value does not fit into any of the ranges, the actual value is displayed

* used to display values differently, group raw values (for example, for better cross-tabulation)

  ```SAS
  BasinGroup=put(Basin, $region.);
  ```

##### Creating custom formats from tables

* to read a table of values for a format, generate three specific columns: `fmtname`, t`start`, `label`

  ```SAS
  data fmtdata;
  	retain FmtName '$sbfmt';
  	set codes(rename=(val=Start labeled=Label));
  	keep Start Label FmtName;
  run;
  
  proc format cntlin=fmtdata;
  run;
  ```

* by default, custom formats are stored in `work` library in a catalog `formats` (catalog: a SAS file that stores different types of info in smaller unit -catalog entries). One can use `library=` option to specify where to permanently save the format.

  ```SAS
  proc format library=pg2.myfmts;
  proc format library=pg1;
  ```

* to search formats, SAS by default searches `work.formats`, `library.formats`. To specify additional locations, use global options `fmtsearch=`

  ```SAS
  options fmtsearch=(pg2.myfmts pg1.formats)
  ```

* to view all/certain formats

  ```SAS
  proc format fmtlib library=work;
  	select $sbfmt catfmt;
  run;
  ```

### 205. Combining tables

##### Concatenating tables

Concatenating tables means joining rows of multiple tables.

```SAS
data output;
	length Name $ 10;
	set sum sum2017(rename=(Year=Yr)
    				drop=Location);
	<additional statements>
run;
```
* if tables have same columns (aka same attributes), then just have multiple tables in `set` statement: `set input1 input2 ...;`
* if the "same" column is named differently in different tables, use `rename=` option in `set ` statement
* if one column is only in one table, one can use `drop=` option in `set` statement to drop this column.
* note that multiple tables may have specified different attributes for variables, for example, different lengths. Use `length` statement before `set` statement to set attributes in PDV before reading from input.

##### Merging tables

Merging tables means joining columns of multiple tables (matching values of a common column in the table). Use `proc sql` or use `data` step.

* one-to-one

  * in compilation phase, all columns in the first table are added to PDV, then add additional cols in the second table to PDV
  * in execution phase, examining the `by` column value  in both tables starting from the first row sequentially 

  ```SAS
  *use proc sort to sort first
  proc sort 
  	by common-col;
  run; 
  
  *to use by, data must be sorted
  data ouput;
  	merge input1 input2(rename=(Basin=BasinCode)) ...;
  	by common-col;
  run;
  ```

* one-to-many

  * if  the `by` value in the next row of each table does not match, check if either matches the current contents of the PDV
  * if either matched, retain the matched and overwrite the un-matched
  * if neither value matches, PDV is reinitialized and all columns are set to missing

* nonmatching 

  * nonmatching rows will be both included (in sorted order) with values missing

##### Identifying matching and nonmatching rows

* use `in=` option in `merge` statement to create temporary variable in PDV for flagging matching or non-matching values 
* use subsetting `if` statement because `in` variables values are assigned during execution

```SAS
data output;
	merge input1(in=var1)
		  input2(in=var2);
	by common-col;
	if var1 and var2;
run;
```

* if having columns from different tables with the same name and you want to keep both, use `rename=` option to avoid overwriting
* use `proc sql` to joining multiple tables without a common column

### 206. Processing repetitive data

##### Using iterative `do` loops

```SAS
do idx-col = start to stop <by incre>;
*do Year= 1 to 3 by 1;
	<repetitive codes>
end;
```

* use nested `do` loop
* reset value before loop of next data iteration

##### Using conditional `do` loops

```SAS
*executes repetitively until a condition is true
do until (expression);
end;
*executes repetitively while a condition is true
do while (expression);
end;
*combine iterative with conditional
do idx-col = start to stop <by incre> until | while (expression);
```

* `do until` has condition checked at the bottom of the loop; thus always executes at least once
* `do while` has condition checked at the top of the loop; thus executes only if condition is true
* the combining loop stops executing when the stop value is exceeded or the condition is met, whichever if first
  * for `until` condition is checked before idx-col increments
  * for `while`, the column is incremented at the bottom of loop before checking the `while` condition at the top of the loop.

### 207. Restructuring tables

##### Restructuring data with `data` step

* Table structure

  * wide table : measures are split into multiple columns
  * narrow table: measures are stacked in a single column

* utilize behaviors of PDV in `data` step

  * The`retain` statement holds values in the PDV across multiple iterations of the DATA step. The last row for each student includes both test score

  ```SAS
  *wide to narrow
  data narrow;
  	set wide;
  	Subject='Math';
  	Score=Math;
  	output;
  	Subject='Reading';
  	Score=Reading;
  	output;
  run;
  *narrow to wide
  data wide;
  	set narrow;
  	by Name;
  	retain Name Math Reading;
  	if S="Math" then Math=Score;
  	else if S="Reading" then Reading=Score;
  	if last.name=1 then output;
  run;
  ```

##### Restructuring data with `proc transpose` 

```SAS
proc transpose data=inT <out=outT
			   prefix=Wind 	name=Windsource;
	<ID col-name;>
	<var col-name(s);>
	<by col-name(s);>
run;
```

* `proc transpose` transposing selected columns into rows (if not specified, only numeric values are transposed)

* input tables should be sorted by `by` variable. Each unique combination of `by` values creates one row in the output table.

* the values of `id` column are assigned as the new column names (must be unique)

* the `var` statement limits the columns that are transposed to rows

* `prefix=` option prefixes in front 

  of the numbers that were transposed. 

* `name=` option to rename column that contains the column names that were transposed from the input table.

