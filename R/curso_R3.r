rm(list=ls())
s <- "./mfSBA K1_laSelva.sed q.sed 2 512 20 S"

system(s)

sf <- read.table("s.K1_laSelva.sed", header=T)

readDq <- function(sname) {
  
  pp <- read.table(sname, header=T)
  
  pp$Dq  <- with(pp,ifelse(q==1,alfa,Tau/(q-1)))
  
  pp$SD.Dq  <- with(pp,ifelse(q==1,SD.alfa,abs(SD.Tau/(q-1))))
  
  pp$R.Dq <- with(pp,ifelse(q==1,R.alfa,R.Tau))
  
  return(pp[,c("q","Tau","SD.Tau","Dq","SD.Dq","R.Dq")])
}


s <- "./mfSBA K2_MaunaKea.sed q.sed 2 512 20 S"

system(s)

sf <- readDq("s.K1_laSelva.sed")
sf1 <- readDq("s.K2_MaunaKea.sed")


require(ggplot2)

pp <- ggplot(sf, aes(x=R.Dq)) + geom_histogram()

pp

range(sf$R.Dq)

range(sf$Dq)

pp <- ggplot(sf, aes(x=q, y=Dq)) + ylim(1.9,2.09) +
  geom_errorbar(aes(ymin=Dq-2*SD.Dq, ymax=Dq+2*SD.Dq), width=.1)+
  geom_line() +
  geom_point()

pp 

sf$plot <- "LaSelva"

sf1$plot <- "MaunaKea"

sft <- rbind(sf,sf1)

# 

pp <- ggplot(sft, aes(x=q, y=Dq, color=plot)) + 
  geom_errorbar(aes(ymin=Dq-2*SD.Dq, ymax=Dq+2*SD.Dq), width=.1)+
  geom_line() +
  geom_point()
pp

# Execute mfSBA
# Plot histogram
# add to data.frame dq
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