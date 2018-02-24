################################################################################
library(readxl)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)
library(tibble)
library(openxlsx, quietly = TRUE, warn.conflicts = FALSE)
oldw <- getOption("warn")
options(warn = -1)

doc <- "jay_test_data.xlsx"

# Argentina #####

ar_simp <- read_excel(doc, sheet = "argentina_simplified",col_names = FALSE) %>%
  column_to_rownames(var = "X__1") %>%
  #add variables as row names
  t() %>%
  #transpose matrix
  data.frame()
  #make back into data frame

row.names(ar_simp) <- NULL
#remove placeholder "X__1" column names that became row names

colnames(ar_simp) <- sub("_ar", "", colnames(ar_simp))
#drop "_ar" from column names

# Brazil #####

br_simp <- read_excel(doc, sheet = "brazil_simplified",col_names = FALSE) %>%
  column_to_rownames(var = "X__1") %>%
  #add variables as row names
  t() %>%
  #transpose matrix
  data.frame()
#make back into data frame

row.names(br_simp) <- NULL
#remove placeholder "X__1" column names that became row names

colnames(br_simp) <- sub("_br", "", colnames(br_simp))
#drop "_br" from column names

# Chile #####

ch_simp <- read_excel(doc, sheet = "chile_simplified",col_names = FALSE) %>%
  column_to_rownames(var = "X__1") %>%
  #add variables as row names
  t() %>%
  #transpose matrix
  data.frame()
#make back into data frame

row.names(ch_simp) <- NULL
#remove placeholder "X__1" column names that became row names

colnames(ch_simp) <- sub("_ch", "", colnames(ch_simp))
#drop "_ch" from column names

# Mexico #####

mx_simp <- read_excel(doc, sheet = "mexico_simplified",col_names = FALSE) %>%
  column_to_rownames(var = "X__1") %>%
  #add variables as row names
  t() %>%
  #transpose matrix
  data.frame()
#make back into data frame

row.names(mx_simp) <- NULL
#remove placeholder "X__1" column names that became row names

colnames(mx_simp) <- sub("_mx", "", colnames(mx_simp))
#drop "_mx" from column names

# join tables #####

all <- unlist(list(colnames(ar_simp),
                   colnames(br_simp),
                   colnames(ch_simp),
                   colnames(mx_simp)))
unique <- unique(all)
full_data <- data.frame(matrix(data = as.factor(NA),
                       nrow = 0, ncol = length(unique),
                       dimnames = list(NULL, unique))) %>%
  full_join(ar_simp, by = colnames(ar_simp)) %>%
  full_join(br_simp, by = colnames(br_simp)) %>%
  full_join(ch_simp, by = colnames(ch_simp)) %>%
  full_join(mx_simp, by = colnames(mx_simp))
#####

options(warn = oldw)

list_of_datasets <- list("full_data" = full_data,
                         "ar_simp" = ar_simp,
                         "br_simp" = br_simp,
                         "ch_simp" = ch_simp,
                         "mx_simp" = mx_simp)
write.xlsx(list_of_datasets, file = "transformed_data.xlsx")
