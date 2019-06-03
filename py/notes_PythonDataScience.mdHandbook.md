## 1. IPython Intro
### Help and Documentation
* Access documentation > reference the doc string.
	* One can define function (place a """string literal""" in the fisrt line ) and other objects with doc string
* Accessing source code
* Exploring Modules/Importing with Tab-completion/WildCard matching
	* Using underscore to list explicitly private and special methods
  ```str.*find*? ```
## 2. NumPy
*"to think of all data fundamentally as arrays of numbers"*
### Understanding Data Types in Python
* compare to Java and C, Python is dynamically-typed language.
* versus Python List (dynamic-type), NumPy is
	* fixed-type array
	```np.array([1,2,3,4], dtype='float32')```
	* which can explicitly be multidimensional
	```np.array([range(i,i+3) for i in [2,4,6]])```
* it is more efficient to create arrays from scratch using routines built in NumPy
	e.g. Create a 3x3 array of normally distributed random values with mean 0 and sd 1
	```np.random.normal(0,1,(3,3))```
* standard data types in NumPy = those in C
### The Basics of NumPy Arrays
*"data manipulation is Python is nearly synonymous with NumPy array manipulation"*
```
import numpy as np
np.random.seed(0)  # seed for reproducibility
x1 = np.random.randint(10, size=6)  # One-dimensional array
x2 = np.random.randint(10, size=(3, 4))  # Two-dimensional array
x3 = np.random.randint(10, size=(3, 4, 5))  # Three-dimensional array
```
* attributes: ```x3.ndim .shape .size .dtype .itemsize .nbytes```
* indexing: ```x3[a,b,c]```
* slicing: ```x[start:stop:step], x3[start:stop:step,start:stop:step,start:stop:step]```
	* accessing rows and columns: ```x2[:,0] # columns```
	* array returns views rather than copies of the array data
	* using .copy() to create copy: e.g., ```x2_sub_copy = x2[:2,:2].copy()```
* reshaping
	* shaping values into grid
	``` grid = np.arange(1, 10).reshape((3, 3))```
	* converting one-dim array into two-dim row/column matrix
	```
	x = np.array([1,2,3])
	x.reshape((1,3))  	# row vector via reshape
	x[np.newaxis, :]	# row vector via newaxis, newaxis expands dimensions
	x.reshape((3,1))	# column vector via reshape
	x[:, np.newaxis]	# column vector via newaxis
	```
* joining and splitting
	* concatenating arrays
	```
	np.concatenate([x,y,z])		# takes a tuple or list of arrays (mark the axis)
	np.vstack([x, grid])			# vertical stack
	np.hstack([grid, y])			# horizontal stack
	np.dstack				# stack arrays along the third axis
	```
	* splitting arrays
	``` 
	x1, x2, x3 = np.split(x,[3,5])	     # given a list of indices as the split points
	upper, lower = np.vsplit(grid, [2])
	left, right = np.hsplit(grid, [2])
	np.dsplit
	```
### Computation on NumPy Arrays: Universal Functions
*NumPy provides an easy and flexible interface to optimized computation with arrays of data*
The key to make the computation on NumPy arrays fast is to use **vectorized** operations, which are generally implemented through NumPy's *universal functions*(ufuncs)

* vectorized operations: 
	* statically typed, compiled routine to replace loop 
	* accomplished by performing on the array, which will then be applied to each element
	* push the loop into the compiled layer that underlies NumPy

* universal functions:
	* array arithmetic: ```+ - * / // - ** %```
		* each arithmetic operation is a convenient wrapper around a function in NumPy
	* absolute value: ```abs(array)```
	* trigonometric functions: ```np.sin(theta), np.cos(), np.tan()```
		* inverse: ```np.arcsin(), np.arccos(), np.arctan()```
	* exponents and logarithms: 
		* ```np.exp(), np.exp2(), np.power(3,x)```
		* ```np.log(), np.log2, np.log10```
		* ```no.expm1(), np.log1p()       #for very small input```
	* specialized ufuncs: ```from scipy import special```	
* advanced ufunc features
	* specifying output: using the ```out``` argument of the function
		```
		x = np.arange(5)
		y = np.empty(5)
		np.multiply(x, 10, out=y)	# for memory saving
		z = np.zeros(10)
		np.power(2,x,out=z[::2]		# to avoid creating a temporary array
		```
	* aggregates
		* ```reduce``` repeatedly applies a given operation to the elements of an array until only a single result remains
		```
		np.add.reduce(x)	# returns the sum of all elements in array x
		np.multiply.reduce(x)	# returns the product of all elements in array x
		```
		* ```accumulate``` stores all the intermidiate results of the computation
		```
		np.add.accumulate(x)
		np.multiply.accumulate(x)
		```
	* outer products: compute the output of all paris of two different inputs using ```outer``` method
		* ```np.multiply.outer(x, x)```
### Aggregations: Min, Max, and Everything In Between
*often when faced with a large amount of data, a first step is to compute summary statistics for the data in question, which are fundamental pieces of exploratory data analysis*
* sum the values in an array: ```np.sum(L)/L.sum()```
* minimum and maximum: 	```np.min(L)/L.min(),np.max(L)/L.max()```
* multi dimensional aggregates: ```M.min(axis=0) # find the minimum within each column```
	* ```axis``` keyword specifies the dimension of the array that will be *collapsed*, rather than the dimension that will be returned
* other aggregation functions:
	* ```NaN```-safe functions that compute the result while ignoring missing values, e.g. ```np.nansum```
### Computation on Arrays: Broadcasting
*broadcasting functionality of NumPy is an alternative to vectorizing operations*
* Broadcasting allows binary operations to be performed on arrays of different sizes
* with a mental model of stretches or duplicates values of M into the array and adds results
	```M+a```
* rules of broadcasting
	* if the two arrays differ in their number of dimensions, the shape of the one with fewer dimensions is padded with ones on its leading(left) side.
	* if the shape of the two arrays does not match in any dimension, the array with shape equal to 1 in that dimension is stretched to match the other shape.
	* if in any dimension the sizes disagree and neither is equal to 1, an error is raised. 
* broadcasting in practice
	* centering an array: 	```X_cemtered = X - Xmean```
	* plotting a two-dim function
		```
		x = np.linspace(0, 5, 50)
		y = np.linspace(0, 5, 50)[:, np.newaxis]
		z = np.sin(x) ** 10 + np.cos(10 + y * x) * np.cos(x)
		%matplotlib inline
		import matplotlib.pyplot as plt
		plt.imshow(z, origin='lower', extent=[0, 5, 0, 5], cmap='viridis')
		plt.colorbar();
		```
### Comparisons, Masks, and Boolean Logic
*masking comes up when you want to extract, modify, count or otherwise manipulate values in an array based on some criterion*
* similar to ufuncs that do fast element-wise arithmetic operations on arrays, some ufuncs can be used to do element-wise *comparisons* over arrays: ``` < > <= >= != ==```
* the result of these comparison operators is always an array with a Boolean data type
* compute aggregates on a boolean array
	* to count the number of ```true``` entries: ```np.count_nonzero(x<6)```
	* or ```np.sum(x<6)``` allows operations along rows/columns
	* to check whether any or all the values are true: ```np.any(x>8); np.all(x<0)```
	* boolean operator: ``` & (and) | (or) ^ (xor) ~ (not)```
* boolean array as masks
	* to select values from the array, index on the boolean array ``` x[x < 5]```, what is returned is a one-dim array filled with all the values that meet 
* Note: ```and/or``` gauge the truth or falsehood of *entire object*, while ```&/|``` refers to *bit within* each object.

### Fancy Indexing
*fancy indexing means passing an array of indices to access multiple array elements at once*
* the return values reflects the *broadcasted* shape of the indice, rather than the shape of the array being indexed
* using fancy indexing to select subsets of rows from a matrix: often used to quickly partition datasets (e.g. in train/test splitting for validation of statistical models, sampling approaches to answering statistical questions.
	```
	indices = np.random.choice(X.shape[0], 20, replace=False)
	selection = X[indices] 
	```
* using fancy indexing to modify values
### Sorting Arrays
* fast sorting in NumPy: quicksort algorithm
	* ```np.sort(x)``` returns a sorted version of the array without modifying the input
	* ```x.sort()``` sorts the array in-place
	* ```np.argsort(x)``` returns the indices of the sorted elements, thus can be used (via fancy indexing) to construct the sorted array ```x[np.argsort(x)]```
	* NumPy's sorting allows sorting along rows or columns using ```axis``` argument
* partial sorts: partitioning (to find the *k* smallest values in the array)
	* ```np.partition(x,k)``` returns a new array with the smallest k values to the left of the partition, and the remaining values to right. Within two partitions, the elements have arbitrary order
	* ```np.argpartition``` computes indices of the partition

### Structured Data: NumPy's Structured Arrays
*the use of NumPy's **structured arrays** and **record arrays** is for efficient storage for compound, heterogenous data, but more often used is ```Dataframe``` in Pandas*
* use structured arrays to store related compound data
	```
	import numpy as np
	name = ['Alice', 'Bob', 'Cathy', 'Doug']
	age = [25, 45, 37, 19]
	weight = [55.0, 85.5, 68.0, 61.5]
	data = np.zeros(4, dtype={'names':('name', 'age', 'weight'),
                          'formats':('U10', 'i4', 'f8')})
	```
	* to access values either by index ```data[0]``` or by name ```data['name']```
	* advanced by Boolean masking, e.g. ```data[data['age'] < 30]['name']```
	* creating structured arrays
		```
		np.dtype([('name', 'S10'), ('age', 'i4'), ('weight', 'f8')])
		np.dtype({'names':('name', 'age', 'weight'), 
         		 'formats':((np.str_, 10), int, np.float32)})
		np.dtype('S10,i4,f8')
		```
* use ```np.recarray``` to access fields as attributes instead of as dictionary keys
	```
	data_rec = data.view(np.recarray)
	data_rec.age
	```
## 3.  Pandas
### Introducing Pandas Objects
*Pandas objects can be thought of enhanced versions of NumPy structured arrays in which the rows and columns are identified with labels rather than simple integer indices. The three fundamental Pandas data structures are ```Series```, ```DataFrame```, ```Index```.*
* The Pandas Series Object
	* to construct a series object: ```pd.Series(data, index=index)
	* is one-dimensional array of indexed data, wrapping both a sequence of values and a sequence of indices, which we can access with ```values``` and ```index``` attributes.
	* can hence be thought of as a generation of a numpy array, but with an explicitly defined index associated with the values (v.s. numpy array), hence allows index to be values of any desired type
	* can hence be thought of as a specialized dictionary which maps typed keys to a set of typed calues. 
		* one can construct a ```Series``` object directly from a Python dictionary, where the index is drawn from the sorted keys.
		* ```Series``` supports array-style operations such as slicing (v.s. dictionary)
	
* The Pandas DataFrame Object
	* to construct a dataframe object: ```pd.DataFrame(the columns, columns=colnames)```
		```
		pd.DataFrame(population, columns=['population'])
		data = [{'a': i, 'b': 2 * i} for i in range(3)]	 # from a list of dicts
		pd.DataFrame(data)
		pd.DataFrame({'population': population, 'area': area}) # from a dictionary of series objects
		pd.DataFrame(np.random.rand(3, 2),  # from two-dim numpy array
			columns=['foo', 'bar'], index=['a', 'b', 'c'])
		A = np.zeros(3, dtype=[('A', 'i8'), ('B', 'f8')])   
		pd.DataFrame(A)			# from structured array
		```
	* can be thought of a two-dimensional array with both generalized row indices and generalized column names
	* can be thought of a specialization of a dictionary that maps a column name to a ```Series``` of column data
	
* The Pandas Index Object
	 * to construct a index object: ```pd.Index([2, 3, 5, 7, 11])```
	 * can be thought of as an immutable array (v.s. numpy array), which makes it safer to share indices between multiple dataframes and arrays
	 * can be thought of as an ordered set, thus can follow many of the conventions used by Python's built-in set data structure (hence unions, intersections, differences, and other combinations ```&, |, ^```)
	
### Data Indexing and Selection
* data selection in Series
Since a ```Series``` builds on a *dictionary-like* interface and provides *array-style* item  selection via the same basic mechanisms as NumPy arrays
	* Like a dictionary, the keys/indices and values in a ```Series``` can be
		* accessed through
		```
		'a' in data
		data.keys()
		list(data.items())
		```
		* modified with
		```data['e'] = 25```
	* Like a one-dimensional NumPy array, a ```Series``` can be 
		* sliced 
		```
		data['a':'c']	# explicit index: final index included
		data[0:2]	# implicit index: final index excluded
		```
		* masked ```data[(data > 0.3) & (data < 0.8)]```
		* fancy indexed ```data[['a', 'e']]```
	* indexers: to avoid potential confusion in the case of integer indexes, special indexer attributes are used to expose particular slicing interface to the data
		* ```loc```: always references the explicit index
		* ```iloc```: always references the implicit index (Python-style)
		* ```ix```: standard []-based indexing	
* data selection in DataFrame
Since a ```DataFrames``` can be thought of a *dictionary* of related ```Series``` object as well as a two-dimensional or structured *array*
	* Like a dictionary, the individual ```Series``` that make up the columns of the ```DataFrame``` can be
		* accessed through
		``` data['area']    # equivalent to but better than attribute-style access (data.area) ```
		* modified with
		```data['density'] = data['pop'] / data['area']```
	* Like an enhanced two-dimensional array, a ```Series``` can be 
		* transposed ```data.T```
		* however, the dictionary-style indexing of columns precludes array interface. In particular, passing a single index to an array accesses a row while passing a single "index" to a ```DataFrame``` accesses a column
	* indexers: 
		* ```loc```: explicit index and column names ```data.loc[:'Illinois', :'pop'] ```
		* ```iloc```: implicit index (Python-style) ```data.iloc[:3, :2]```
		* ```ix```: hybrid ```data.ix[:3, :'pop']```
	* slicing, masking are interpreted row-wise (v.s. indexing: column-wise)
### Operating on Data in Pandas
### Handling Missing Data

### Hierarchical Indexing
### Combining Datasets: Concat and Append
### Combining Datasets: Merge and Join
### Aggregation and Grouping
### Pivot Tables
### Vectorized String Operations
### Working with Time Series
### High-Performance Pandas: eval() and query()
### Further Resources
