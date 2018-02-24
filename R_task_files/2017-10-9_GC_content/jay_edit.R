# research data scrambled
# this causes our GC content to fluctuate wildly, because there's no connection
# between significance and the'regulation ratio'

## setup #####
library(dplyr)
file <- 'dfRNA.csv' # change this each time
amy_data <- read.csv(file, stringsAsFactors = FALSE) # load csv

## Data transform to get 10-sequences of significants  #####

sig_yes <- filter(amy_data, significant == 'yes') # only get significants

## task: create vector of each upregulated 10-sequence (length is 74)
up_sig <- sig_yes %>%
  filter(ratio > 1, !is.na(dis.seq)) %>% # filter for valid upreg
  select(dis.seq) %>% # get seq column
  unlist(use.names = FALSE) # turn type data.frame into type vector

## task: create vector of each downregulated 10-sequence (length is 26)
down_sig <- sig_yes %>%
  filter(ratio < 1, !is.na(dis.seq)) %>% # filter for valid downreg
  select(dis.seq) %>% # get seq column
  unlist(use.names = FALSE)


## Get GC content without the seqinr package

## task: create vector of each individual letter (length is 10*74 = 740)
up_vec <- up_sig %>%
  paste(collapse = '') %>% # concatenate
  strsplit(split = '*') %>% # separate into list of single characters (* is regexp)
  unlist() # turn type list into type vector (technicalities of strsplit)

## task: calculate how many entries in up_vec are G or C
GC_up <- mean(up_vec %in% c("G","C"))
GC_up

## now repeat for downregulated

## task: create vector of each individual letter (length is 10*26 = 260)
down_vec <- down_sig %>%
  paste(collapse = '') %>% # concatenate
  strsplit(split = '*') %>% # separate into list of single characters (* is regexp)
  unlist() # turn type list into type vector (technicalities of strsplit)

## task: calculate how many entries in down_vec are G or C
GC_down <- mean(down_vec %in% c("G","C"))
GC_down


## Get GC content using the seqinr package
library(seqinr)

## task: create vector of each individual letter (length is 10*74 = 740)
up_vec_seq <- up_sig %>%
  c2s() %>% # turn vector of 10-sequences into one long string
  s2c() # turn long string into vector of individual characters

## task: calculate how many entries in up_vec_seq are G or C
GC_up_seq <- GC(up_vec_seq)
GC_up_seq

## now repeat for downregulated

## task: create vector of each individual letter (length is 10*74 = 740)
down_vec_seq <- down_sig %>%
  c2s() %>% # turn vector of 10-sequences into one long string
  s2c() # turn long string into vector of individual characters

## task: calculate how many entries in down_vec_seq are G or C
GC_down_seq <- GC(down_vec_seq)
GC_down_seq

## Test these match #####
GC_up == GC_up_seq
GC_down == GC_down_seq
