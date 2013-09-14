rm(list=ls())

dim_rf <- 10

matrix(0,dim_rf,dim_rf)

matrix(1:dim_rf,dim_rf)

matrix(1:(dim_rf*dim_rf),dim_rf)

runif(10)

rf <- matrix(runif(dim_rf*dim_rf),ncol=dim_rf)

rf

set_tree <- function(elem,prob) {
  if(elem>prob) 
    elem <- 0
  else
    elem <- 1
} 

rf <-apply(rf,1:2,set_tree,0.5)

rf

image(rf,asp=1,axes=F,col=c("white","black"))

image(rf)

generate_rf <- function(sideDim,p)
{
  rf <- matrix(runif(sideDim*sideDim),ncol=sideDim)
  rf <-apply(rf,1:2,set_tree,p)
  #image(rf,asp=1,axes=F,col=c("white","black"))
  return(rf)
}

generate_rf(100,0.4)

generate_rf(100,0.5)

rf <- generate_rf(10,0.5)

rf

rf[1,] <- 2

for(j in 1:ncol(rf))
{
  
  if( rf[1,j]==2 & rf[2,j]==1)
    rf[2,j] <- 2
}

rf

for(i in 2:nrow(rf))
  for(j in 1:ncol(rf))
  {
    if( rf[i-1,j]==2 & rf[i,j]==1)
      rf[i,j] <- 2
  }


image(rf,asp=1,axes=F,col=c("white","black","red"))

for(i in 2:nrow(rf))
  for(j in 2:(ncol(rf)-1))
  {
    if( (rf[i-1,j]==2 || rf[i-1,j-1]==2 || 
                   rf[i-1,j+1]==2) && rf[i,j]==1)
      rf[i,j] <- 2
  }


image(rf,asp=1,axes=F,col=c("white","black","red"))

# This function only propagate the fire in one direction
#
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
  image(rf,asp=1,axes=F,col=c("white","green","red"))
  return(rf)
}

rf <- generate_rf(100,0.5)

rf1 <- fire_rf(rf)

image(rf1,asp=1,axes=F,col=c("white","green","red"))

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

rf <- generate_rf(100,0.4)
rf1 <- fire_rf(rf)
countBurned(rf1)

# Make a plot of the proportion of burned 
# sites versus p (probability of tree establishment)
#

pp <- seq(0.1,.9,0.05)
propBurned <- pp
for(i in 1:length(pp) )
{
  rf <- generate_rf(200,pp[i])
  rf1 <- fire_rf(rf)
  propBurned[i] <- countBurned(rf1)
}  
  
plot(propBurned ~ pp)

df <- data.frame(pp,propBurned)

require(ggplot2)

ggplot(df,aes(x=pp,y=propBurned))+geom_line()

## Infection in 1 dimension
#
# Now we have to propagate the infection
# there are two possibilities: contagion with 
# probability lambda or recuperation with 
# probability mu
#
# dim_in: is the size of the infection
# time_in: is the time 
#
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

simulate_inf(.4,.3,50,100)