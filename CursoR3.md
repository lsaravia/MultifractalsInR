
## Multifractals in ecology using R

<center>
![](figs/aloe-spiral.jpg)
</center> 

## Multifractal estimation 

+ We will use box counting to estimate $D_q$

$$D_q = \lim_{r \to 0} \frac{1}{q-1}\frac{log \left[ M_q(r) \right]}{\log r}$$

+ We cover the object with square non-overlapping boxes of size $r$ and 
	  repeat the procedure using a range of $r$ values. This range is determined by the size of our sample. 

+ in practice $D_q$ is estimated by the slope of the scaling relation for a range of $q$

	$$M_q(r) = A r^{-\tau_q}$$

	$$\log(M_q(r)) = \log A - \tau_q log(r)$$

	$$D_q = \frac{\tau_q}{(q-1)}$$
	
+ Estimating $D_q$ is not very difficult but is no so simple. We need the following steps:

	1. Chose a range of $q$ and a range of $r$ 

	2. Start with the first $q$

	3. Start with the first $r$

	4. Cover the object with boxes of side $r_1$

	5. Calculate $M_q(r_1)$ store the result.

	6. Do this for all $r$'s in the range.

	7. Now we have all $r$'s and $M_q(r)$ to calculate $\tau_q$ by regression

	8. Repeat 3. - 7. for all the $q$s

+ If somebody want to do this in R as a final project, we cant talk later.

+ We will use an open source software mfSBA available at <http://github/lsaravia/mfsba>

## Using mfSBA

+ To automate repetitive task and perform visualizations we will use R but
  we need to know how to use mfSBA

+ To invoke an external program from R we use:
		
		system("./mfSBA")

	or under windows

		system("mfSBA.exe")

+ In the console appears some information about the parameters

	-----------  ------------------------
	Parameter    Description
	-----------  ------------------------
	inputFile    The file we want to use

	qFile        A file that indicates the $q$'s range

	minBox 	   	 The size of the first box

	maxBox       The size of the last box. 
	             The intermediate boxes are calculated as powers of 2.

	numBoxSizes  limit the number of boxes, not very useful. 

	option 		 we will use the option S that makes $\sum p_i=1$

	-------------------------------------

+ mfSBA can use tif files but I can't make it work in windows so we will use 
  its own format that is called "sed". Sed files are text files with a matrix structure.

	  	s <- "./mfSBA K1_laSelva.sed q.sed 2 512 20 S"

		system(s)

+ This generates several files: 

		a.K1_laSelva.sed
		f.K1_laSelva.sed
		t.K1_laSelva.sed
		s.K1_laSelva.sed

	**a.file/f.file** have data for $f(\alpha)$ and $\alpha$ an equivalent way
		to express $D_q$ that we will not use.

	**t.file** has $\log( M_q(r))$ and the box sizes used, useful to check the validity of
	 the regression. 

	**s.file** has $\tau_q$, $\alpha$ and $f(\alpha)$, the $R^2$'s and standard deviations, so we will use mostly this file.


		sf <- read.table("s.K1_laSelva.sed", header=T)

## Exercise 

+ make a function to read the s.file and discard all the things we don't need and calculate $D_q$

+ The first step to do a function like this is to test if commands works.

+ A possible answer:

		readDq <- function(sname) {
		
			pp <- read.table(sname, header=T)

		    pp$Dq  <- with(pp,ifelse(q==1,alfa,Tau/(q-1)))
		    
		    pp$SD.Dq  <- with(pp,ifelse(q==1,SD.alfa,abs(SD.Tau/(q-1))))
		    
		    pp$R.Dq <- with(pp,ifelse(q==1,R.alfa,R.Tau))
		    
		    return(pp[,c("q","Tau,"SD.Tau","Dq","SD.Dq","R.Dq")])
	    }

## Analyze the output

+ First use our function to get all we need

		dq <- readDq("s.K1_laSelva.sed")

		require(ggplot2)

		pp <- ggplot(dq, aes(x=R.Dq)) + geom_histogram()
		 
		pp

		range(dq$R.Dq)


+ $R^2$ seems very high, that means a very good fit, we could check more using the **t.file**. Let's try:

		tf <- read.table("t.K1_laSelva.sed", header=T)

	Oops error: the first line do not have the same number of labels as columns.

		tf <- read.table("t.K1_laSelva.sed", skip=1)

		names(tf)[1] <- "Box"

		names(tf)[2] <- "logBox"
		
+ And check with the Durbin-Watson statistic

		lm0 <- lm(V3~logBox,data=tf)

		summary(lm0)
		
		require(car)
		
		dwt(lm0)

+ Let's check another $q$

		lm0 <- lm(V23~logBox,data=tf)

		dwt(lm0)

+ Thus there is some autocorrelation. Let's check graphically

		pp <- ggplot(data=tf,aes(x=logBox,y=V23))+geom_point()+geom_smooth(method="lm")

		pp

+ When there is low $R^2$ or autocorrelation is better to check graphically.

## $D_q$ for La Selva

+ We can plot $D_q$ with using SD as error bars

		pp <- ggplot(dq, aes(x=q, y=Dq)) +
		  geom_errorbar(aes(ymin=Dq-SD.Dq, ymax=Dq+SD.Dq), width=.1) +
		  geom_line() +
		  geom_point()

		pp 


## Exercise 1

+ Plot $\tau_q$


## Exercise 2
+ Can we make more functions to automate the task if we need to repeat the analysis?

+ A function to read the data, show the $R^2$ histogram and add $D_q$ to a data frame. 

+ A function to plot all the $D_q$ linear fit for all $q$ 

