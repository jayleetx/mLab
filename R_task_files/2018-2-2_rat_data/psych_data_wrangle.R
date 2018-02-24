# Note: this method only works if nothing other than this
# type of file is in the folder, so start with that

library(stringr)
library(dplyr)
library(tidyr)
library(lubridate)

# set directory to folder where everything lives
files <- list.files(path = "data", full.names = TRUE)

# pull all letters from start of file name
researcherInitials <- str_extract(files, "^[A-Za-z]+")

# pull first case where a number is followed by a letter
animalNumber <- str_extract(files, "[0-9][A-Za-z]")

# remove everything except treatment condition
# treatment condition must only be characters
treatmentCondition <- str_replace(str_replace(files, ".*[0-9][A-Z]", ""),
                                  "[0-9]+$", "")

# pull all numbers at the end of the string
observationNumber <- str_extract(files, "[0-9]+$")

date_pull <- function(file_name) {
  read <- read.csv(file_name, header = FALSE, stringsAsFactors = FALSE)
  date <- str_subset(read$V1, "^Start Date:") %>%
    str_replace("^[^0-9]*", "")
  date
}

date <- sapply(files, date_pull)

data_extraction <- function(file_name) {
  read <- read.csv(file_name, header = FALSE, stringsAsFactors = FALSE)
  o_row <- which(read$V1 == 'O:')
  q_row <- which(read$V1 == 'Q:')
  smaller <- paste0(read[(o_row+1):(q_row-1), ], collapse = '')
  smaller <- gsub("[[:space:]]+", " ", smaller) %>%
    str_trim() %>%
    str_split(" ") %>%
    unlist()
  smaller <- smaller[!grepl(':', smaller)] %>%
    as.numeric()
  result_vec <- smaller[-1]
  result_vec
}

behavior_list <- lapply(files, data_extraction)
behavior_list[[2]] <- rep(50, 8)
behavior_list[[3]] <- rep(75, 8)
behavior_data <- data.frame(t(data.frame(behavior_list)))
colnames(behavior_data) <- paste0("behavior", as.character(1:8))
rownames(behavior_data) <- NULL

full <- data.frame(researcherInitials,
           animalNumber,
           date,
           treatmentCondition,
           observationNumber,
           behavior_data) %>%
  gather(behavior_type, behavior_result, 6:13) %>%
  mutate(date = mdy(date))

goal3 <- dplyr::select(full,
                animalNumber,date, treatmentCondition,
                behavior_type, behavior_result)
colnames(goal3) <- c('AnimalID', 'dateOfObs', 'treatment', 'obsNumber', 'obsResults')
goal3
