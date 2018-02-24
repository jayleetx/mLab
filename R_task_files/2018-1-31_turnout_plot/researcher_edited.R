### Jay: everything here worked for me except the `State Code` column name read in blank (NA)
### I just changed the subsetting to pick the 4th column instead of `X__1`

library(readxl)
turnout <- read_excel("1980-2014 November General Election.xlsx")

## researcher's new code: just pull the rows you want

names(turnout) # inspect variable names
turnout <- turnout[turnout[ ,4] %in% c("Oregon", "Washington"),]

## researcher's new code: construct turnout as total/vep

turnout$turnout.vep <- turnout$`VEP Total Ballots Counted`

## researcher's new code: plot the oregon trend, then add lines for the washington trend. Assuming you want VEP turnout here.

plot(turnout$Year[turnout[ ,4]=="Oregon"], turnout$`VEP Total Ballots Counted`[turnout[ ,4]=="Oregon"], type='b') # do oregon
lines(turnout$Year[turnout[ ,4]=="Washington"], turnout$`VEP Total Ballots Counted`[turnout[ ,4]=="Washington"], type='b', lty=2) # do washington. Note: lty=2 gives you dashed line for Oregon.

# researcher note: after plotting that, we note that there is not enough space on the y-dimension. so, we will go back and set ylim=c(0.25, 0.75), or 25% to 57%. While we are at it, clean up the axes and labels

plot(turnout$Year[turnout[ ,4]=="Oregon"], turnout$`VEP Total Ballots Counted`[turnout[ ,4]=="Oregon"], type='b', ylim=c(0.25, 0.75), axes=F, xlab="year", ylab="turnout as proportion of VEP") # do oregon

lines(turnout$Year[turnout[ ,4]=="Washington"], turnout$`VEP Total Ballots Counted`[turnout[ ,4]=="Washington"], type='b', lty=2) # do washington.

axis(1, tick=F) # axis on bottom, no line segment for it. (Toggle tick=F to see what I mean.)

axis(2, tick=F, las=2) # axis on left, no line segment for it, rotate labels to go with reading direction. (Toggle las=2 to see what I mean.)
