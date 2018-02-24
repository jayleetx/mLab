# check `readxl` exists, install if not, then load
if(!(require ('readxl'))) install.packages('readxl')
library(readxl)

# Check file path is correct or set working directory
turnout <- readxl::read_excel("1980-2014 November General Election.xlsx")

colnames(turnout)[4] <- 'state'
# this name read in blank for me, not sure why
# in the excel file itself the `State Code` name is there`

colnames(turnout)[5] <- 'VEP_turnout'
# this is just for brevity further down

# pare down into OR and WA data sets
or_turnout <- turnout[turnout$state == "Oregon", ]
wa_turnout <- turnout[turnout$state == "Washington", ]

plot(or_turnout$Year, or_turnout$VEP_turnout, type='b',
     ylim=c(0.35, 0.75),
     xlab="year", ylab="turnout as proportion of VEP")
lines(wa_turnout$Year, wa_turnout$VEP_turnout, type='b', lty = 2) # dashed line for WA
legend('bottomright', legend = c("Oregon", "Washington"), lty = 1:2)
