


# First generate a random forest

rm(list=ls())

dim_rf <- 10

matrix(0,dim_rf,dim_rf)

matrix(1:dim_rf,dim_rf)

matrix(1:(dim_rf*dim_rf),dim_rf)

# We need a function to fill the matrix with random numbers
# to set each site to 1 or 0

runif(10)

rf <- matrix(runif(dim_rf*dim_rf),ncol=dim_rf)

# the probability to set each site to 1 or 0  

p <- 0.5


set_tree <- function(elem,prob) {
  if(elem>prob) 
      elem <- 0
  else
      elem <- 1
} 

set_tree(rf,0.5)

rf <-apply(rf,1:2,set_tree,0.5)

image(rf,asp=1,axes=F,col=c("white","black"))

#require(lattice)
#levelplot(rf,scales = list(draw = FALSE),xlab =NULL, ylab = NULL,
#           useRaster=T,col.regions = c("white","black"))

# now we can do a function to generate a random forest with 
# side dimension and probability as parameters

generate_rf <- function(sideDim,p)
{
  rf <- matrix(runif(sideDim*sideDim),ncol=sideDim)
  rf <-apply(rf,1:2,set_tree,p)
  image(rf,asp=1,axes=F,col=c("white","black"))
}

generate_rf(100,0.1)

generate_rf(100,0.5)

generate_rf(100,0.59)


### Fire the forest



generate_rf <- function(sideDim,p)
{
  rf <- matrix(runif(sideDim*sideDim),ncol=sideDim)
  rf <-apply(rf,1:2,set_tree,p)
  image(rf,asp=1,axes=F,col=c("white","black"))
  return(rf)
}

rf <- generate_rf(100,0.51)

# let's test the commands to build the function

rf[1,] <- 2

for(i in 2:nrow(rf))
  for(j in 1:ncol(rf))
  {
    if( rf[i-1,j]==2 && rf[i,j]==1)
      rf[i,j] <- 2
  }
image(rf,asp=1,axes=F,col=c("white","black","red"))

# wrong we have to test all neighbors 

for(i in 2:nrow(rf))
  for(j in 2:(ncol(rf)-1))
  {
    if((rf[i-1,j]==2 || rf[i-1,j-1]==2 || rf[i-1,j+1]==2) && (rf[i,j]==1))
          rf[i,j] <- 2
  }
image(rf,asp=1,axes=F,col=c("white","black","red"))

# So we can build the function 

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

rf <- generate_rf(100,0.6)
rf1 <- fire_rf(rf)
image(rf1,asp=1,axes=F,col=c("white","black","red"))

# now we need to count the number of burned sites

bur <-0
for(i in 2:nrow(rf1))
  for(j in 1:ncol(rf1))
  {
    if(rf1[i,j]==2 )
        bur <- bur + 1
  }
bur
  
# build the function

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

bur <-countBurned(rf1)
bur


# Exercise


# Infection
rm(list=ls())
# We can do this in a similar way 
dim_in <- 10
time_in <- 20

inf<-matrix(0,time_in,dim_in)

# at time one we need to infect some sites to start

inf[1,] <- ifelse(runif(dim_in)>0.5,1,0)

# Now we have to propagate the infection

lambda = 1
mu= 0.4
for(i in 2:(time_in-1))
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


# Now we do the function
rm(inf,lambda,mu,dim_in,time_in)

mu= 0.5


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
debug(simulateInf)
mu= 0.5


simulate_inf(.4,.4,50,100)