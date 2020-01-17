# Getting Started with SAS Programming

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

### 202. Summarizing data

### 203. Manipulating data with functions

### 204. Creating and using custom formats

### 205. Combining tables

### 206. Processing repetitive data

### 207. Restructuring tables

