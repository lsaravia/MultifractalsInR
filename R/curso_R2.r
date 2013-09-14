rm(list=ls())

ps <- read.table("patch1968.dat",header=TRUE)

ps$r <- rank(-ps$pSize)

plot(r ~ pSize,data=ps)

plot(log(r)~log(pSize),data=ps) 

lm0 <- lm(log(r)~log(pSize),data=ps)

summary(lm0)

abline(lm0)

slope0 <- -coef(lm0)[2]

2-2*slope0

require(car)

dwt(lm0)

grid()

require(segmented)

ps$logr <- log(ps$r)
ps$logpSize <- log(ps$pSize)

lm0 <- lm(logr~logpSize,data=ps)

seg <- segmented(lm0, seg.Z = ~logpSize, psi=4)

summary(seg)

slope(seg)

plot(seg)

calcH <- function(B) { 2-2*abs(B)}

calcH(.1550) # H = 1.69

calcH(.9036) # H = 0.19

calcBreak <- function(B) { 0.1*exp(B)*0.65 } 

calcBreak(3.35) # 1.85 ha

# dados 1985

ps <- read.table("patch1985.dat",header=TRUE)

ps$r <- rank(-ps$pSize)

ps$logr <- log(ps$r)

ps$logpSize <- log(ps$pSize)

lm0 <- lm(logr~logpSize,data=ps)

seg <- segmented(lm0, seg.Z = ~logpSize, psi=4)

summary(seg)

slope(seg)

calcH(0.2676) # H = 1.46

calcH(1.2600) # H = -0.52

calcBreak(2.7080) # 0.97

plot(seg,col="blue",xlab="Log Patch Size",ylab="Acum Freq",lty=3)

points(log(r)~log(pSize),data=ps,pch=6,cex=.5)


# ggplot

ps <- read.table("patch1985.dat",header=T)
ps$r <- rank(-ps$pSize)
ps$Year <- "1985"

ps1 <- read.table("patch1968.dat",header=T)
ps1$r <- rank(-ps1$pSize)
ps1$Year <- "1968"

ps <- rbind(ps,ps1)

require(ggplot2)
ggplot(data=ps,aes(x=pSize,y=r,color=Year))+geom_point()

p <- ggplot(data=ps,aes(x=log(pSize),y=log(r),
          color=Year))+geom_point(aes(shape=Year))

p

ps$logpSize <- log(ps$pSize)

ps1 <- ps[ps$logpSize>3.35,]

p + geom_smooth(data=ps1,method="lm")

# Partition function

rm(list=ls())

p <- c(7,10,14,10)
tp <-sum(p)
u <- p/tp
q <-0

sum(u^q)


partition <- function(p,q)
{
  tp <-sum(p)
  u <- p/tp
  sum(u^q)
}

partition(p,-1)

partition(p,10)

partition(p,-10)
