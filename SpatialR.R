# https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf

setwd("~/Desktop/Creating-maps-in-R-master")
library(rgdal)
lnd <- readOGR(dsn = "data", layer = "london_sport")
head(lnd@data, n = 2)
sapply(lnd@data, class)
lnd$Pop_2001 <- as.numeric(as.character(lnd$Pop_2001))

#plot gives a really good first look at shapefiles
plot(lnd)
lnd@data[lnd$Partic_Per < 15, ] # only show less than 15
sel <- lnd$Partic_Per > 20 & lnd$Partic_Per < 25 # save from 20 to 25
plot(lnd, col = "lightgrey")
sel <- lnd$Partic_Per > 25
plot(lnd[sel, ], col = "turquoise", add = T)

# CHALLENGE
# show all zones whose centroids are within 10km of London centroid
# show zones who touch within 10km of London's centroid
library(rgeos)
centroids <- coordinates(gCentroid(lnd, byid = T))
