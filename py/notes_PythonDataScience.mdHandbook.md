## 1. IPython Intro
### Help and Documentation
* Access documentation > reference the doc string.
	* One can define function (place a """string literal""" in the fisrt line ) and other objects with doc string
* Accessing source code
* Exploring Modules/Importing with Tab-completion/WildCard matching
	* Using underscore to list explicitly private and special methods
  ```
    str.*find*?
  ```
## 2. NumPy Intro
*"to think of all data fundamentally as arrays of numbers"*
### Understanding Data Types in Python
* compare to Java and C, Python is dynamically-typed language.
* versus Python List (dynamic-type), NumPy is
	* fixed-type array
	```
	np.array([1,2,3,4], dtype='float32')
	```
	* which can explicitly be multidimensional
	```
	np.array([range(i,i+3) for i in [2,4,6]])
	```
* it is more efficient to create arrays from scratch using routines built in NumPy
	e.g. Create a 3x3 array of normally distributed random values with mean 0 and sd 1
	```
	np.random.normal(0,1,(3,3))
	```
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
* attributes: x3.ndim .shape .size .dtype .itemsize .nbytes
* indexing: x3[a,b,c]
* slicing: x[start:stop:step], x3[start:stop:step,start:stop:step,start:stop:step]
	* accessing rows and columns: x2[:,0] # columns
	* array returns views rather than copies of the array data
	* using .copy() to create copy: e.g., ```x2_sub_copy = x2[:2,:2].copy()```
* reshaping
	* shaping values into grid
	```
	grid = np.arange(1, 10).reshape((3, 3))
	```
	* converting one-dim array into two-dim row/column matrix
	```
	x = np.array([1,2,3])
	x.reshape((1,3))  	# row vector via reshape
	x[np.newaxis, :]	# row vector via newaxis
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
	* array arithmetic: + - * / // - ** %
		* each arithmetic operation is a convenient wrapper around a function in NumPy
	* absolute value: abs(array)
	* trigonometric functions: np.sin(theta), np.cos(), np.tan()
		* inverse: np.arcsin(), np.arccos(), np.arctan()
	* exponents and logarithms: np.exp(), np.exp2(), np.power(3,x); np.log(), np.log2, np.log10
		* no.expm1(), np.log1p() used for very small input
	* specialized ufuncs
		scipy.special	
* advanced ufunc features
	* specifying output
### Aggregations: Min, Max, and Everything In Between
### Computation on Arrays: Broadcasting
### Comparisons, Masks, and Boolean Logic
### Fancy Indexing
### Sorting Arrays
### Structured Data: NumPy's Structured Arrays
