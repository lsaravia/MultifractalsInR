A <- 0.1

r <- (1:100)

eta <- -1.1

L <- A*r^eta


plot(L~r)

plot(log(L)~log(r))

pl <- data.frame(r,L,logL=log(L))

head(pl)

lm(logL~log(r),data=pl)


# do it with 1000 points
rm(list=ls())

pl <- data.frame(r=seq(1,100,0.1))

pl$L<- 0.4*pl$r^-1.3
pl$logL <-log(pl$L)
pl$logr <-log(pl$r)

lm(logL~logr,data=pl) 

cumPowerL <- function(x) {
  sum(pl[pl$r >=x,]$L)
  
}

pl$cumL <- sapply(pl$r,cumPowerL)       

plot(log(cumL)~logr,data=pl)

pl1 <- pl[pl$logr<3,]

lm1 <- lm(log(cumL)~logr,data=pl1) 

lm0  <- lm(log(cumL)~logr,data=pl) 

summary(lm1)

coef(lm1)

summary(lm0)


abline(lm1,col="red")

abline(lm0,col="blue")

# Exercise 4

pl2 <- pl[1:50,]

lm2 <- lm(log(cumL)~logr,data=pl2) 

summary(lm2)

coef(lm2)

abline(lm2,col="green")
