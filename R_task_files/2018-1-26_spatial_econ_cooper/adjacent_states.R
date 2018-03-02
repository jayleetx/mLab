library(readxl)
library(dplyr)
library(data.table)
library(raster)
library(spdep)
library(rgdal)

# load data, create unique row ID
spatial_econ <- read_excel("thesis_data1.xlsx") %>%
  arrange(Year, State) %>%
  mutate(unique = paste(State, Year, sep = ' '),
         Year = factor(Year),
         State = factor(State)) %>%
  dplyr::select(unique, everything())

#shapefile to create adjacency matrix
tmpdir <- tempdir()
temp <- tempfile()
download.file("http://www2.census.gov/geo/tiger/GENZ2016/shp/cb_2016_us_state_500k.zip",temp)
folder <- unzip(temp, exdir = tmpdir)
p <- shapefile(paste0(tmpdir, '/cb_2016_us_state_500k.shp'))
unlink(temp)
unlink(tmpdir)

p <- subset(p[order(p$NAME),], # reorder states alphabetically (why wouldn't it be alphabetical????)
            NAME %in% state.name[c(-2, -11)]) # pull AK, HI

w <- poly2nb(p, row.names=p$STUSPS, queen = FALSE)
wm <- nb2mat(w,style = "W")


# copy the weight matrix 16 times block diagonally
full_mat <- matrix(data = 0, nrow = nrow(spatial_econ), ncol = nrow(spatial_econ),
                   dimnames = list(spatial_econ$unique, spatial_econ$unique))
for (i in seq_len(nrow(spatial_econ)/48)) {
  start <- 48*(i - 1) + 1
  end <- 48*i
  full_mat[start:end, start:end] <- wm
}
weights <- mat2listw(full_mat, style='M')

# two-stage least squares model for state tax rates
# use two-stage because neighboring states' tax raates affect your state's

sales_tax_model <- stsls(`Sales Tax (%)` ~ . -unique -State -Year -`Income Tax (%)`, spatial_econ, weights)
income_tax_model <- stsls(`Income Tax (%)` ~ . -unique -State -Year -`Sales Tax (%)`, spatial_econ, weights)


sales_coef <- coefficients(sales_tax_model)
inc_coef <- coefficients(income_tax_model)

wy_sales <- numeric(nrow(spatial_econ))
pred_sales <- numeric(nrow(spatial_econ))
for (i in seq_len(nrow(spatial_econ))) {
  wy_sales[i] <- sum(weights$weights[[i]] * spatial_econ$`Sales Tax (%)`[weights$neighbours[[i]]])
  vec <- unlist(c(wy_sales[i], 1, spatial_econ[i, 6:13]))
  pred_sales[i] <- sum(sales_coef*vec)
}

wy_income <- numeric(nrow(spatial_econ))
pred_income <- numeric(nrow(spatial_econ))
for (i in seq_len(nrow(spatial_econ))) {
  wy_income[i] <- sum(weights$weights[[i]] * spatial_econ$`Income Tax (%)`[weights$neighbours[[i]]])
  vec <- unlist(c(wy_income[i], 1, spatial_econ[i, 6:13]))
  pred_income[i] <- sum(inc_coef*vec)
}

model_pred <- data.frame(state_year = spatial_econ$unique,
           sales_tax = spatial_econ$`Sales Tax (%)`,
           wy_sales,
           pred_sales,
           income_tax = spatial_econ$`Income Tax (%)`,
           wy_income,
           pred_income) %>%
  mutate(sales_diff = sales_tax - pred_sales,
         inc_diff = income_tax - pred_income)
