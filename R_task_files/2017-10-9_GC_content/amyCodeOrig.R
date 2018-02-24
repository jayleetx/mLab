##install packages
install.packages("seqinr")

##load libraries
library(tidyverse)
library("seqinr")

##load data
amyData <- read_csv('dfRNA.csv')
View(amyData)

##################### NEED TO PULL OUT SIG + UP/DOWN REG

## first subset significant == yes
sigYes <- filter(amyData, amyData$significant == 'yes')

## then subset sig == yes and ratio > 1 (UPREGULATED) -- look at data
upSig <- filter(sigYes, sigYes$ratio > 1)
View(upSig)

## remove NA's and cut down to ONLY SEQUENCE DATA
upSig2 <- filter(upSig, !is.na(dis.seq))
upSig3 <- select(upSig2,contains("dis.seq"))
write.csv(upSig3, file="upSig.csv")

## do same for DOWNREGULATED
downSig <- filter(sigYes, sigYes$ratio < 1)
downSig2 <- filter(downSig, !is.na(dis.seq))
downSig3 <- select(downSig2,contains("dis.seq"))
write.csv(downSig3, file="downSig.csv")

##### super-awkward manual part that I want to come back to when we're not trying to get you ready for a lab meeting in an hour
##### open *.csv in a text editor
##### simple find-replace for the spaces b/w lines so that the sequence is all one line
##### for your work, files are downSig.csv and then downSigOne.csv (cleaned up); same naming convention for up
##### load the fixed *.csv files back into R, take a look @ data, and do the GC math
##### before GC math is done, need to convert sequence to character (s2c command)

downSigOne <- read_csv("downSigOne.csv")
View(downSigOne)
downSigOneChar <- s2c(downSigOne$dis.seq)
GCdown <- GC(downSigOneChar)
View(GCdown)

upSigOne <- read_csv("upSigOne.csv")
View(upSigOne)
upSigOneChar <- s2c(upSigOne$dis.seq)
GCup <- GC(upSigOneChar)
View(GCup)