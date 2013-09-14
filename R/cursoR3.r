#
# Use mfSBA  
#

rm(list=ls())

system("./mfSBA")

#system("mfSBA.exe")

# execute mfSBA

s <- "./mfSBA K1_laSelva.sed q.sed 2 512 20 S"

system(s)

# function to read s.file

sf <- read.table("s.K1_laSelva.sed", header=T)

readDq <- function(sname) {
  
  pp <- read.table(sname, header=T)
  
  pp$Dq  <- with(pp,ifelse(q==1,alfa,Tau/(q-1)))
  
  pp$SD.Dq  <- with(pp,ifelse(q==1,SD.alfa,abs(SD.Tau/(q-1))))
  
  pp$R.Dq <- with(pp,ifelse(q==1,R.alfa,R.Tau))
  
  return(pp[,c("q","Tau","SD.Tau","Dq","SD.Dq","R.Dq")])
}


dq <- readDq("s.K1_laSelva.sed")

require(ggplot2)

pp <- ggplot(dq, aes(x=R.Dq)) + geom_histogram()
 
pp

range(dq$R.Dq)

# R seems very high

tf <- read.table("t.K1_laSelva.sed", header=T)

tf <- read.table("t.K1_laSelva.sed", skip=1)

names(tf)[1] <- "Box"
names(tf)[2] <- "logBox"

lm0 <- lm(V3~logBox,data=tf)
summary(lm0)
require(car)
dwt(lm0)

lm0 <- lm(V23~logBox,data=tf)
dwt(lm0)

pp <- ggplot(data=tf,aes(x=logBox,y=V23))+geom_point()+geom_smooth(method="lm")

pp

# show Dq

pp <- ggplot(dq, aes(x=q, y=Dq)) +
  geom_errorbar(aes(ymin=Dq-SD.Dq, ymax=Dq+SD.Dq), width=.1) +
  geom_line() +
  geom_point()

pp

# Analyze the others forest images
#
fname <- "K1_laSelva.sed"
strsplit("K1_laSelva.sed",".sed")[[1]][1]
'.sed')

addDqRHist <- function(fname,dq=0,siten="")
{
  # Make multifractal analysis
  sname <- paste0("s.",fname)
  if(!file.exists(sname) )
  {    
    s <- paste("./mfSBA",fname, "q.sed 2 512 20 S")
    system(s)
  }

  # Extract site label
  if( nchar(siten)==0 ){  
    siten <- strsplit(fname,"_")[[1]][2]
    siten <- strsplit(siten,".sed")[[1]][1]
  }
  sname <- paste0("s.",fname)
  dqnew <- readDq(sname)
  dqnew$Site <- siten
  
  require(ggplot2)
  
  print(ggplot(dqnew, aes(x=R.Dq)) + geom_histogram() + ggtitle(siten))
  
  if(is.data.frame(dq))
    return(rbind(dq,dqnew))
  else
    return(dqnew)
}

debugonce(addDqRHist)
rm(pp)
pp <- addDqRHist("K1_laSelva.sed")
pp <- addDqRHist("K2_MaunaKea.sed",pp)
pp <- addDqRHist("K3_Laupahoehoe.sed",pp)
pp <- addDqRHist("K4_Montane.sed",pp)
pp <- addDqRHist("K5_Kohala.sed",pp)

gp <- ggplot(pp, aes(x=q, y=Dq, color=Site)) +
  geom_errorbar(aes(ymin=Dq-SD.Dq, ymax=Dq+SD.Dq), width=.1) +
  geom_line() +
  geom_point()

gp