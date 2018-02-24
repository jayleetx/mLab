# Prof's original (single #)
## Jay's comments (double ##)

## this file read broke for me because the back end has a smart quote
#turnout <- read_excel("Pol311_Labs/pset2 master/data/1980-2014 November General Election.xlsx”)

## the object `X1980_2014_November_General_Election` isn't created in this script
#turnout_or_wa <- subset(turnout, subset = (X1980_2014_November_General_Election$`ICPSR State Code`== 72 | X1980_2014_November_General_Election$`ICPSR State Code` == 73))

#plot(turnout_or_wa$year, turnout_or_wa$`ICPSR State Code`)			# this is an ugly plot


## edited version so things ran

turnout <- readxl::read_excel("1980-2014 November General Election.xlsx")

turnout_or_wa <- subset(turnout, subset = (turnout$`ICPSR State Code`== 72 | turnout$`ICPSR State Code` == 73))

plot(turnout_or_wa$Year, turnout_or_wa$`ICPSR State Code`)			# this is an ugly plot
## this just gives me a set of points in two horizontal lines?
## it's plotting a state code (a constant) against year
## this didn't really give me a sense of the problem, I had to run the researcher's code to figure it out
