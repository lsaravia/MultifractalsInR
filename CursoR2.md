
## Multifractals in ecology using R

<center>
![](figs/fractal-leaf-2.jpg)
</center> 

## Cumulative distributions and ranks

+ We want to make a plot of the cumulative distribution of a function $P(x)$
  the frequency of words in a text.

+ The cumulative distribution of the frequency is defined such that $P(x)$ is the fraction of
   words with frequency greater than or equal to $x$. 

+ If $x$ is the frequency of the most frequent word, usually "the", then there is exactly one word with frequency greater than or equal to $x$. 

	Similarly for the second most frequent word, usually "of", there are two words with frequency greater than or equal: "of" and "the".

## Cumulative distributions and ranks 1

+ In general if we rank the words in descending order then by definition there are *n* words with frequency greater than or equal than that of the *n*th most commond word.

	Thus the cumulative distribution $P(x)$ is proportional to the rank *n* of a word.

	Then to plot $P(x)$ we only need to plot the ranks as a function of the frequency. 

## Cumulative distributions and fractal dimension

+ We can analyze the data from Metzler (1992)

		rm(list=ls())

		ps <- read.table("patch1968.dat",header=T)

		ps$r <- rank(-ps$pSize)

		plot(r ~ pSize,data=ps)

		plot(log(r)~log(pSize),data=ps)		

		lm0 <- lm(log(r)~log(pSize),data=ps)

		summary(lm0)

		abline(lm0)

## Cumulative distributions and fractal dimension 1

+ If $B$ is the exponent then $H = 2 - 2B$ 

		slope0 <- coef(lm0)[2]
		
		2+slope0*2

	The patches are persistent because H=1.18 > 0.5

+ We need to install the package "car" to test for autocorrelation with the Durbin-Watson statistic. We can do this using the RStudio menu Tools/Install Packages.

		require(car)

		dwt(lm0)

	we can draw a grid to determine the break point.

		grid()

## Exercise 1

+ Split the data in two to obtain two fractal dimensions without correlation

+ There is a shorcut for doing this: the package "segmented" fits a broken line and 
  finds the break point.

		require(segmented)

		ps$logr <- log(ps$r)
		ps$logpSize <- log(ps$pSize)
		lm0 <- lm(logr~logpSize,data=ps)
		seg <- segmented(lm0, seg.Z = ~logpSize, psi=4)
		summary(seg)
		slope(seg)

## Exercise 1 (Cont.)

+ Let's do a function to calculate H 

+ small patches are persistent
		
		calcH <- function(B) { 2-2*abs(B)}

		calcH(.1550) # H = 1.69

	Big patches are anti-persistent

		calcH(.9036) # H = 0.19

+ What is the breakpoint value in ha? Let's do another function.

+ A possible answer:

		calcBreak <- function(B) { 0.1*exp(B)*0.65 } 

		calcBreak(3.35) # 1.85 ha

## Conclusion

+ small patches: if they are growing they keep growing, if they are reducing they vanish.

+ big patches: if they are growing they will reduce, if they are reducing they will grow.

+ Thus big patches are more stable, small patches appear and disappear. 

## Exercise 2

+ Let's do the same thing using segmented with the 1985 data: "patch1985.dat"

+ We can do a plot with the segmented object

		plot(seg,col="green",xlab="Log Patch Size"
				,ylab="Acum Freq")
		
		points(log(r)~log(pSize),data=ps,pch=2,cex=.5)

+ We can use the functions:

		summary(seg)
		slope(seg)

		calcH(0.2676)
		calcH(1.26)

		calcBreak(2.708) # 0.97 ha

## A different graphic analysis

+ Using graphics package "ggplot2". We need to add both datasets in one data frame


		ps <- read.table("patch1985.dat",header=T)
		ps$r <- rank(-ps$pSize)
		ps$Year <- "1985"

		ps1 <- read.table("patch1968.dat",header=T)
		ps1$r <- rank(-ps1$pSize)
		ps1$Year <- "1968"

		ps <- rbind(ps,ps1)
		
## Gramar of graphics ggplot2

		require(ggplot2)
		ggplot(data=ps,aes(x=pSize,y=r,color=Year))
					+geom_point()

		p <- ggplot(data=ps,aes(x=log(pSize),y=log(r),
				color=Year))+geom_point(aes(shape=Year))

		
## More questions

+ This seems a fragmentation process the frequency of small patches increases but the scaling of big patches seems similar, have big patches different scalings?

		ps$logpSize <- log(ps$pSize)
		
		ps1 <- ps[ps$logpSize>3.35,]

		p + geom_smooth(data=ps1,method="lm")

		ggsave("patch_Breaks.png",width=2)
