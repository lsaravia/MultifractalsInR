
## Multifractals in ecology using R - Day 4

<center>
![](figs/mandelbrot-set.jpg)	
</center> 

## Percolation

+ First we will generate a random forest: set each position of a matrix to 1 or 0 with some 
	probability $p$

+ First we need to fill a matrix with numbers

		rm(list=ls())

		dim_rf <- 10

		matrix(0,dim_rf,dim_rf)

		matrix(1:dim_rf,dim_rf)

		matrix(1:(dim_rf*dim_rf),dim_rf)
 
+ what we really need are random numbers

		runif(10)

		rf <- matrix(runif(dim_rf*dim_rf),ncol=dim_rf)

+ now we need to decide which will become 0 or 1 with some probability,
	the best way to do that is using a function 

		set_tree <- function(elem,prob) {
		  if(elem>prob) 
		      elem <- 0
		  else
		      elem <- 1
		} 

		set_tree(rf,0.5)

+ the last line don't works because we need to apply the condition to each site individually


		rf <-apply(rf,1:2,set_tree,0.5)

+ So we set a matrix of 1's and 0's with probability 0.5, we can plot it

		image(rf,asp=1,axes=F,col=c("white","black"))

+ Now we can put all together and make a function that does all things

		generate_rf <- function(sideDim,p)
		{
		  rf <- matrix(runif(sideDim*sideDim),ncol=sideDim)
		  rf <-apply(rf,1:2,set_tree,p)
		  image(rf,asp=1,axes=F,col=c("white","black"))
		}

+ We can see how the matrix is filled when we change $p$

		generate_rf(100,0.1)

		generate_rf(100,0.5)

		generate_rf(100,0.59)


+ The next thing is to burn the trees, we forget to return the matrix with the random forest

		generate_rf <- function(sideDim,p)
		{
		  rf <- matrix(runif(sideDim*sideDim),ncol=sideDim)
		  rf <-apply(rf,1:2,set_tree,p)
		  image(rf,asp=1,axes=F,col=c("white","black"))
		  return(rf)
		}

		rf <- generate_rf(10,0.51)

+ Now we need a function to explore the neighborhood and fire the actual site if one on the adjacent sites is fired. We can try to use a loop.

		rf[1,] <- 2

		for(j in 1:ncol(rf))
		{

			if( rf[1,j]==2 & rf[2,j]==1)
				rf[2,j] <- 2
		}

+ But we have to do that for all the rows of the matrix

		for(i in 2:nrow(rf))
			for(j in 1:ncol(rf))
			{
				if( rf[i-1,j]==2 & rf[i,j]==1)
					rf[i,j] <- 2
			}


		image(rf,asp=1,axes=F,col=c("white","black","red"))

+ something is wrong, we need to test all the neighborhood


		for(i in 2:nrow(rf))
			for(j in 2:(ncol(rf)-1))
			{
				if( (rf[i-1,j]==2 || rf[i-1,j-1]==2 || rf[i-1,j+1]==2) && rf[i,j]==1)
					rf[i,j] <- 2
			}

+ So now we are ready to build the function


		fire_rf <- function(rf) {
		  dimi=nrow(rf)
		  dimj=ncol(rf)-1
		  rf[1,] <- 2
		  for(i in 2:dimi)
		    for(j in 2:dimj)
		    {
		      if((rf[i-1,j]==2 || rf[i-1,j-1]==2 || rf[i-1,j+1]==2) && (rf[i,j]==1))
		          rf[i,j] <- 2
		    }
		  return(rf)
		}

		rf <- generate_rf(100,0.1)

		rf1 <- fire_rf(rf)

		image(rf1,asp=1,axes=F,col=c("white","black","red"))

+ Now to finish we have to count the number of burned sites, a simple function will do, but first we 
   test the commands

   		bur <-0

		for(i in 2:nrow(rf1))
		  for(j in 1:ncol(rf1))
		  {
		    if(rf1[i,j]==2 )
		        bur <- bur + 1
		  }

		bur

+ next we create the function

		countBurned <- function(rf)
		{
		  bur <-0
		  dimi=nrow(rf)
		  dimj=ncol(rf)
		  
		  for(i in 2:dimi)
		    for(j in 1:dimj)
		    {
		      if(rf1[i,j]==2 )
		        bur <- bur + 1
		    }
		  return(bur/((dimi-1)*dimj))
		}


## Exercise 1

+ Make a plot of the proportion of burned sites versus the probability $p$ of the trees


## Infection

+ We can do this in a similar way, first we need a matrix but now one dimension will be the time

		dim_in <- 10
		time_in <- 20

		inf<-matrix(0,time_in,dim_in)

+ At time 1 we need to infect some sites to have a start

		inf[1,] <- ifelse(runif(dim_in)>0.5,1,0)

+ Now we have to propagate the infection, there are two possibilities: contagion with probability 
	$\lambda$ or recuperation with probability $\mu$

		lambda = 0.5

		mu= 0.5

		for(i in 1:(time_in-1))
		  for(j in 2:(dim_in-1))
		  {
		    if(inf[i,j]==0){
		      
		      if(inf[i,j-1]==1){
		        inf[i+1,j] <- ifelse(runif(1)<=lambda,1,0)
		      }
		      else if(inf[i,j+1]==1 ){
		        inf[i+1,j] <- ifelse(runif(1)<=lambda,1,0)
		      }
		    }
		    else
		    {
		      inf[i+1,j] <- ifelse(runif(1)<=mu,0,1)
		    }
		  }

		image(inf,asp=1,axes=F,col=c("grey","brown"))

+ Then we put all in a function


		simulate_inf <- function(lambda,mu,dim_in,time_in){
		  
		  inf<-matrix(0,time_in,dim_in)
		  inf[1,] <- ifelse(runif(dim_in)>0.5,1,0)
		  for(i in 1:(time_in-1))
		    for(j in 2:(dim_in-1))
		    {
		      if(inf[i,j]==0){
		        
		        if(inf[i,j-1]==1){
		          inf[i+1,j] <- ifelse(runif(1)<=lambda,1,0)
		        }
		        else if(inf[i,j+1]==1 ){
		          inf[i+1,j] <- ifelse(runif(1)<=lambda,1,0)
		        }
		      }
		      else
		      {
		        inf[i+1,j] <- ifelse(runif(1)<=mu,0,1)
		      }
		    }
		    image(inf,asp=1,axes=F,col=c("grey","brown")) 
		}

		simulate_inf(.4,.4,50,100)

+ We can try with different parameters and see what happens at $\lambda > \mu$ or $\lambda < \mu$

## Exercise 2

+ Build the plot with a fixed $\mu$ of the probability of propagation versus $\lambda$

+ Estimate the fractal dimension and the multifractal spectrum of the infection
