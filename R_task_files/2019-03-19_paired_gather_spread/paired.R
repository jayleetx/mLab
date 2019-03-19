library(tidyr)
library(dplyr)

# toy data set just to show how it works
# this is designed after a Qualtrics output, where you have "nested" things - for each option (x/y/z), ask two questions (q1/q2)
# a normal gather doesn't work here because we want two "value" columns at the end
# each row should be a unique combo of id and option, and our value columns should be the two questions asked
# essentially we want to gather each pair of columns down together
# so we need an alternate method

data <- data.frame(id = letters[1:10],
                   x_q1 = 1:10,
                   x_q2 = 2*1:10,
                   y_q1 = 11:20,
                   y_q2 = 2*11:20,
                   z_q1 = 21:30,
                   z_q2 = 2*21:30)
                   
# so a correct paired gather should end up with four columns
# first col is "id" repeated 3 times
# second col is which xyz each thing came from
# third col is q1, 1:30
# fourth col is q2, 2:60 by 2s

tall <- gather(data, key = 'colname', value = 'answer', 2:7) %>%
  separate(colname, into = c('option', 'question')) %>%
  spread(question, answer) %>%
  arrange(q1) # this arrange just reorders the rows - not necessary

# do this in reverse (quite literally, it just backtracks the above)
# so now we have more "tidy" data, and we want it in a paired wide format for ease of data display in a chart
# can't just do a spread because our data ("value" in a typical spread) is split across two columns

reverse <- gather(tall, key = 'question', value = 'answer', q1, q2) %>%
  unite('label', word, question) %>%
  spread(label, answer)
