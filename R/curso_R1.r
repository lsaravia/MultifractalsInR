rm(list=ls())

pl <- data.frame(r=seq(1,100,0.1))

pl$L<- 0.4*pl$r^-1.3

pl$logL <-log(pl$L)

pl$logr <-log(pl$r)

lm(logL~log(r),data=pl) 

cumPowerL <- function(x) {
  sum(pl[pl$r <=x,]$L)
  
}

pl$cumL <- sapply(pl$r,cumPowerL)       

plot(log(cumL)~logr,data=pl)

lm <- lm(log(cumL)~logr,data=pl)

summary(lm)

pl1 <- pl[pl$logr>=3,]

lm1 <- lm(log(cumL)~logr,data=pl1)

summary(lm1)

abline(lm)

abline(lm1,col="red")


pl1 <- pl[pl$logr<2,]

lm1 <- lm(log(cumL)~logr,data=pl1)

summary(lm1)

abline(lm1,col="blue")

# Example Rescaled Range Analysis

bebado <- c(1,2,4,3,8,2,0,1,9)

m_bebado <- mean(bebado)

sum(bebado[1:3] - m_bebado)

sum(bebado[4:6] - m_bebado)

sum(bebado[7:9] - m_bebado)

sdx <- c(sum(bebado[1:3] - m_bebado),sum(bebado[4:6] - m_bebado),
         sum(bebado[7:9] - m_bebado) )


max(sdx)-min(sdx)/sqrt(sum((sdx - m_bebado)^2)) 





