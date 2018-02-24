library(dplyr)
library(tidyr)
library(stringr)
library(leaflet)

temp <- tempfile()
download.file("http://www2.census.gov/geo/docs/reference/cenpop2010/nat_cop_1880_2010.txt",temp)
state_centers <- read.csv(temp, na.strings = '', stringsAsFactors = FALSE) %>%
  slice(1:51) %>%
  select(-X)
unlink(temp)

change_coord <- function(vec) {
  secs = lapply(split(as.numeric(unlist(strsplit(vec, 
                                                 " "))) * c(3600, 60, 1), f = rep(1:length(vec), each = 3)), sum)
  as.character(lapply(secs, function(y) y/3600))
}

long_centers <- state_centers %>%
  gather(key = coord_year, value = coord, -State) %>%
  mutate(Year = str_extract(coord_year, '\\d\\d\\d\\d'),
         coord_type = str_extract(coord_year, 'Lat|Long')) %>%
  select(State, Year, coord_type, coord) %>%
  filter(!is.na(coord)) %>%
  spread(key = coord_type, value = coord) %>%
  mutate(Lat = change_coord(Lat),
         Long = change_coord(Long)) %>%
  mutate(Year = as.numeric(Year),
         Lat = as.numeric(Lat),
         Long = as.numeric(Long))


tmpdir <- tempdir()
temp <- tempfile()
download.file("http://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_state_500k.zip",temp)
folder <- unzip(temp, exdir = tmpdir)
p <- shapefile(paste0(tmpdir, '/cb_2016_us_state_500k.shp'))
unlink(temp)
unlink(tmpdir)


### none of this works right heeheehee
m <- leaflet(data = long_centers) %>%
  addTiles() %>%
  addMarkers(~Long, ~Lat, popup = ~as.character(Year))

m
