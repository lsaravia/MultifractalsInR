# Ranks 
#
# Read the data of Meltzer

rm(list=ls())

ps <- read.table("patch1968.dat",header=T)

ps$r <- rank(-ps$pSize)

plot(r ~ pSize,data=ps)

plot(log(r)~log(pSize),data=ps)

lm0 <- lm(log(r)~log(pSize),data=ps)

coef(lm0)

abline(lm0)

# Calculate the Hurst Exponent

slope0 <- coef(lm0)[2]

2+slope0*2

# load the library car for the Durbin-Watson test
require(car)

dwt(lm0)

# Draw a grid to distinguish the break 
grid()

# Split the data 

ps1 <- ps[ps$logpSize<3.5,]
plot(log(r)~log(pSize),data=ps)
lm1 <- lm(log(r)~log(pSize),data=ps1)
require(car)
dwt(lm1)
abline(lm1,col="green")
coef(lm1)

ps2 <- ps[ps$logpSize>=3.5,]
lm2 <- lm(log(r)~log(pSize),data=ps2)
require(car)
dwt(lm2)
abline(lm2,col="blue")
coef(lm2)

# the library segmented

require(segmented)

ps$logr <- log(ps$r)
ps$logpSize <- log(ps$pSize)
lm0 <- lm(logr~logpSize,data=ps)
seg <- segmented(lm0, seg.Z = ~logpSize, psi=4)
summary(seg)
slope(seg)

# Function to calculate H

calcH <- function(B) { 2-2*abs(B)}

calcH(.1550) # H = 1.69

# small patches are anti-persistent

calcH(.9036) # H = 0.19

# Big patches are persistent

# where is the breakpoint in ha

calcBreak <- function(B) { 0.1*exp(B)*0.65 } 

calcBreak(3.35) # 1.85 ha

# Read the data from 1985

ps <- read.table("patch1985.dat",header=T)
ps$r <- rank(-ps$pSize)
plot(r ~ pSize,data=ps)
plot(log(r)~log(pSize),data=ps)

lm0 <- lm(log(r)~log(pSize),data=ps)

coef(lm0)

abline(lm0)
require(car)
dwt(lm0)

# Exercise 2

require(segmented)

ps$logr <- log(ps$r)
ps$logpSize <- log(ps$pSize)
lm0 <- lm(logr~logpSize,data=ps)
seg <- segmented(lm0, seg.Z = ~logpSize, psi=4)
summary(seg)
slope(seg)

plot(seg,col="green",xlab="Log Patch Size",ylab="Acum Freq")
points(log(r)~log(pSize),data=ps,pch=2,cex=.5)


calcH(0.2676)
calcH(1.26)

calcBreak(2.708) # 0.97 ha


# using ggplot2

ps <- read.table("patch1985.dat",header=T)
ps$r <- rank(-ps$pSize)
ps$Year <- "1985"
ps1 <- read.table("patch1968.dat",header=T)
ps1$r <- rank(-ps1$pSize)
ps1$Year <- "1968"

ps <- rbind(ps,ps1)
# 
require(ggplot2)
ggplot(data=ps,aes(x=pSize,y=r,color=Year))+geom_point()

p <- ggplot(data=ps,aes(x=log(pSize),y=log(r),color=Year))+geom_point(aes(shape=Year))

p

ps$logpSize <- log(ps$pSize)
ps1 <- ps[ps$logpSize>3.35,]

p + geom_smooth(data=ps1,method="lm")

ggsave("patch_Breaks.png",width=2)


# This suggest that the increase cattle load change the break, but not the patch process
# Los parches mas grandes se mantuvieron estables los mas chicos cambiaron