
## Multifractals in ecology using R

<center>
![](figs/fractal-leaf-2.jpg)
</center> 


## Introduction to R and RStudio

+ R is a language and environment for statistical computing and graphics.

+ Extracted from <http://nicercode.github.io/intro/>

	> Writing code is fast becoming a key - if not the most important - skill for 
	doing research in the 21st century. As scientists, we live in extraordinary times. 
	The amount of data (information) available to us is increasingly exponentially, 
	allowing for rapid advances in our understanding of the world around us. 

	>The amount of information contained in a standard scientific paper also
	seems to be on  the rise. Researchers therefore need to be able to handle
	ever larger amounts of data to ask  novel questions and get papers
	published.

	>Yet, the standard tools used by many biologists - point and click programs
	for manipulating data, doing stats and making plots - do not allow us to
	scale-up our analyses to match data availability, at least not without
	many, many more ‘clicks’.
	
	*The following material was based on their introduction to R.* 


+ Install R for windows
	
	<http://cran.r-project.org/bin/windows/base/>

+ Install R for Linux (ubuntu)

		sudo add-apt-repository "deb http://cran.stat.ucla.edu/bin/linux/ubuntu precise/"
		sudo apt-get update
		sudo apt-get install r-base

+ Install *RStudio*

	<http://www.rstudio.com/ide/download/desktop>

## Getting started with RStudio

+ Load R studio however you do that on your platform.

+ RStudio has four panes:

	1. Bottom left – this is the R interpreter. If you type code here, it is “evaluated” so that you get an answer.

    2. Top left – editor for writing longer pieces of code.
    
    3. Top right will tell you things about objects in the workspace. We’ll get to this soon, but this will be things like data objects, or functions that will process them. It is completely unrelated to the file system. The “History” tab will keep an eye on what you’ve done.
    
    4. Will display files, plots, packages, and help information, usually as needed.

## Using R as calculator


+ Enter the following in the bottom left

		1 + 100

		[1] 101

+ Lets try something more complex

		3 + 5 * 2 ^ 2

		[1] 23

		(3 + 5) * 2

		[1] 16

	See ?Arithmetic for more information, you can also get there by ?"+" (note the quotes)

+ The usual sort of comparison operators are available:

		1 == 1  # equality (note two equals signs, read as "is equal to")

		[1] TRUE
			

		1 != 2  # inequality (read as "is not equal to")


		[1] TRUE

		1 <  2  # less than

		[1] TRUE

		1 <= 1  # less than or equal to

		[1] TRUE

		1 >  0  # greater than

		[1] TRUE

		1 >= -9 # greater than or equal to

		[1] TRUE

	See ?Comparison for more information (you can also get there by help("==").

+ Really small numbers get a scientific notation:


		2/10000


		[1] 2e-04

	Read e-XX as “multiplied by 10^XX”, so 2e-4 is 2 * 10^(-4).

## Mathematical functions

+ R has many built in mathematical functions that will work as you would expect:

		sin(1)  # trig functions

		[1] 0.8415

		asin(1) # inverse sin (also for cos and tan)

		[1] 1.571

		log(1)  # natural logarithm

		[1] 0

		log10(10) # base-10 logarithm

		[1] 1

		log2(100) # base-2 logarithm

		[1] 6.644

		exp(0.5) # e^(1/2)

		[1] 1.649


## Variables and assignment

+ You can assign values to variables using the assignment operator <-, like this:


		x <- 1/40


+ And now the variable x contains the value 0.025:

		x

		[1] 0.025


+ note that it does not contain the fraction 1/40, it contains a decimal approximation of this fraction. 
	This appears exact in this case, but it is not. These decimal approximations are called “floating point numbers” 
	and at some point you will probably end up having to learn more about them than you’d like.

+ Look up at the top right pane of RStudio, and you’ll see that this has appeared in the “Workspace” pane.
  Our variable x can be used in place of a number in any calculation that expects a number.

		log(x)


		[1] -3.689


		sin(x)

		[1] 0.025


+ The right hand side of the assignment can be any valid R expression.

+ Notice that assignment does not print a value.

		x <- 100


+ Notice also that variables can be reassigned (x used to contain the value 0.025 and and now it has the value 100).
  Assignment values can contain the variable being assigned to: What will x contain after running this?

		x <- x + 1

+ The right hand side is fully evaluated before the assignment occurs.

+ Variable names can contain letters, numbers, underscores and periods. The cannot start with a number. They cannot contain spaces at all. Different people use different conventions for long varaible names, these include

	+ periods.between.words
	+ underscores_between_words
	+ camelCaseToSeparateWords

	What you use is up to you, but be consistent.

## Exercise 1

Compute the difference in years between now and the year that you started at University. Divide this by the difference between now and the year when you were born. Multiply this by 100 to get the percentage of your life spent at university. Use parentheses if you need them, use assignment if you need it.

This problem is as much about thinking about formalising the ingredients of a problem as much as actually getting the syntax correct.

## Vectors

+ R was designed for people who do data analysis and generally you have more than one piece of data. 
	As a result in R all data types are actually vectors. 
	So the number ‘1’ is actually a vector of numbers that happens to be of length 1.

		1

		[1] 1

		length(1)

		[1] 1

+ To build a vector, use the c function (c stands for “concatenate”).

		x <- c(1, 2, 40, 1234)

+ We have assigned this vector to the variable x.

		x

		[1]    1    2   40 1234

		length(x)

		[1] 4


+ Notice how RStudio has updated its description of x. If you click it, you’ll get an option to alter it, 
  which is rarely what you want to do.

+ This is a deep piece of engineering in the design; most of R thinks quite happily in terms of vectors. 
  If you wanted to double all the values in the vector, just multiply it by 2:

		2 * x

		[1]    2    4   80 2468


## Vector functions

+ You can get the maximum value…

		max(x)

		[1] 1234

+ …minimum value…

		min(x)

		[1] 1

+ …sum…

		sum(x)

		[1] 1277


+ …mean value…

		mean(x)

		[1] 319.2

+ …and so on. There are huge numbers of functions that operate on vectors. 
It is more common that functions will than that they won’t.

+ Vectors can be summed together:

		y <- c(0.1, 0.2, 0.3, 0.4)

		x + y

		[1]    1.1    2.2   40.3 1234.4


+ And they can be concatenated together:

		c(x, y)

		[1]    1.0    2.0   40.0 1234.0    0.1    0.2    0.3    0.4

+ and scalars can be added to them

		x + 0.1

		[1]    1.1    2.1   40.1 1234.1

+ Be careful though: if you add/multiply together vectors that are of different lengths, but the lengths factor, R will silently “recycle” the length of the shorter one:

		x

		[1]    1    2   40 1234

		x * c(-2, 2)

		[1]   -2    4  -80 2468

	(note how the first and third element have been multiplied by -2 while the second and fourth element are multiplied by 2).

+ If the lengths do not factor (i.e., the length of the shorter vector is not a factor of the length of the longer vector) you will get a warning, but the calculation will happen anyway:

		x * c(-2, 0, 2)

		Warning: longer object length is not a multiple of shorter object length

		[1]    -2     0    80 -2468

+ This is almost never what you want. Pay attention to warnings. Note that Warnings are different to Errors. We just saw a warning, where what happened is (probably) undesirable but not fatal. You’ll get Errors where what happened has been deemed unrecoverable. For example

		x + z # fails because there is no variable z

		Error: object 'z' not found

+ Just as with the scalars, as well as doing arithmetic operators we can do comparisons. This returns a new vector of TRUE and FALSE indicating which elements are less than 10:

		x < 10

		[1]  TRUE  TRUE FALSE FALSE

+ You can do vector-vector comparisons too:

		x < y # all false as y is quite small.

		[1] FALSE FALSE FALSE FALSE
		~~~ 

+ And combined arithmetic operations with comparison operations. Both sides of the expression are fully evaluated before the comparison takes place.

		x > 1/y

		[1] FALSE FALSE  TRUE  TRUE

+ Be careful with comparisons: This compares the first element with -20, the second with 20, the third with -20 and the fourth with 20.

		x >= c(-20, 20)

		[1]  TRUE FALSE  TRUE  TRUE

+ This does nothing sensible, really, and warns you again:

		x == c(-2, 0, 2)

		Warning: longer object length is not a multiple of shorter object length

		[1] FALSE FALSE FALSE FALSE

+ All the comparison operators work in fairly predictable ways:

		x == 40

		[1] FALSE FALSE  TRUE FALSE

		x != 2

		[1]  TRUE FALSE  TRUE  TRUE

+ Sequences are easy to make, and often useful. Integer sequences can be made with the colon operator:

		3:10 # sequence 3, 4, ..., 10

		[1]  3  4  5  6  7  8  9 10


+ Which also works backwards

		10:3 # the reverse

		[1] 10  9  8  7  6  5  4  3


+ Step in different sizes

		seq(3, 10, by=2)

		[1] 3 5 7 9

		seq(3, 10, length=10)

		[1]  3.000  3.778  4.556  5.333  6.111  6.889  7.667  8.444  9.222 10.000


+ Now we will see the meaning of the [1] term – this indicates that you’re looking at the first element of a vector. If you make a really long vector, you’ll see new numbers:

		seq(3, by=2, length=100)

		  [1]   3   5   7   9  11  13  15  17  19  21  23  25  27  29  31  33  35
		 [18]  37  39  41  43  45  47  49  51  53  55  57  59  61  63  65  67  69
		 [35]  71  73  75  77  79  81  83  85  87  89  91  93  95  97  99 101 103
		 [52] 105 107 109 111 113 115 117 119 121 123 125 127 129 131 133 135 137
		 [69] 139 141 143 145 147 149 151 153 155 157 159 161 163 165 167 169 171
		 [86] 173 175 177 179 181 183 185 187 189 191 193 195 197 199 201


## Exercise 2

One thing you can do with sequences is you can very informally look at convergent sequences. For example, the sum of squares of the reciprocals of integers:

$$\frac{1}{1} + \frac{1}{4} + \frac{1}{9} + \frac{1}{16}$$

$$\frac{1}{1} + \frac{1}{2^2} + \frac{1}{3^2} + \frac{1}{4^2} +
\cdots + \frac{1}{n^2}$$


1. What is the sum of the first four squares?

2. What is the sum of the first 100?

3.   …of the first 10,000?

4. If x is the answer to 3, what is the square root of 6x?

## A possible solution

1. 

		1 + 1/4 + 1/9 + 1/16 # starting to get tedious to type

		[1] 1.424


2.

		squares <- (1:100)^2
		sum(1/squares)

		[1] 1.635

3.

		sum(1 / (1:10000)^2)

		[1] 1.645


4.

		x <- sum(1 / (1:10000)^2)
		sqrt(x * 6)

		[1] 3.141

## Data frames

Let us remember the power law

$$L(r)=A r^\eta$$

+ then

		A <- 0.1

		r <- (1:100)

		L <- A*r^eta

+ oops error

		eta <- -1.1

		L <- A*r^eta

+ we can do a plot of the data

		plot(r,L)


+ Or using R's "formulae"

		plot(log(L)~log(r))

	 Read this as “log(L) is a function of log(r)”.


+ we can put all together in a data frame

		pl <- data.frame(r,L,logL=log(L),logr=log(r))

	The *pl* variable contains a *data.frame* object. It is a number of columns of the same length, arranged like a matrix or table. 

		head(pl)  # first rows of the data frame

		names(pl) # the names of columns

		nrow(pl) # the number of rows

		ncol(pl) # the number of columns

		pl$L     # obtain one column

+ we can do a regression to obtain the exponent of our power law

		lm(logL~logr,data=pl)

+ "lm" stands for linear model and is a general function for doing all kinds of linear statistica models.

## Exercise 3

First delete all variables to start over

	rm(list=ls())

Generate a data.frame with different parameters for the power law and 1000 points.

+ A possible answer
		

		pl <- data.frame(r=seq(1,100,0.1))

		pl$L<- 0.4*pl$r^-1.3

		pl$logL <-log(pl$L)

		pl$logr <-log(pl$r)

		lm(logL~log(r),data=pl) 

## Writing functions

+ Writing functions is one of the most important steps to use all the power of R.

+ Remember the power law of cumulative biomass in lake Constanz, we have to calculate $L(>r)$

		pl$r >=1 
		pl$r >=2

		pl[pl$r >=2,] 			# select the rows with the column r>2

		pl[pl$r >=99,]

		pl[pl$r >=99,]$L 		# Get only the column that we are interested

		sum(pl[pl$r >=99,]$L)

+ We can define a function to calculate this using a variable

		cumPowerL <- function(x) {
			sum(pl[pl$r >=x,]$L)

		}

		cumPowerL(99)

		cumPowerL(1)

		cumPowerL(pl$r)

+ If we want to apply the function to a vector we have to use:

		sapply(pl$r,cumPowerL)

	we can add a variable to our data.frame

		pl$cumL <- sapply(pl$r,cumPowerL) 		

		plot(log(cumL)~logr,data=pl)

+ It seems that the power law is defined for $logr<3$ 

		pl1 <- pl[pl$logr<3,]

		lm(log(cumL)~logr,data=pl1) 

		lm(log(cumL)~logr,data=pl)

		summary(lm(log(cumL)~logr,data=pl1))

+ One way to not type the same (or copy) commands is assign a variable

		lm1 <- lm(log(cumL)~logr,data=pl1) 

		lm0  <- lm(log(cumL)~logr,data=pl) 

		summary(lm1)

		summary(lm0)

		abline(lm1,col="red")

		abline(lm0,col="blue")



+ We previously said that if we have a power law

	$$L(r) \propto r^{-\eta}$$

	the cumulative distribution should be

	$$L(>r) \propto r^{-\eta+1}$$

	but here this result is only approximate.


## Exercise 4

+ Fit the cumulative power law to the first 50 values in the data frame



