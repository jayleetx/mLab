set.seed(1448)
# insert faculty members of choice here
first_name <- c("David", "James", "Irena", "Safia", "James", "Heather")
last_name <- c("Perkinson", "Fix", "Swanson", "Chettih", "Pommersheim", "Kitada")
user_id <- sample(1000:9999, 6) # these will be distinct, I'm assuming
gender <- c("M", NA, "F", "F", "M", NA)
other <- runif(6)

original <- data.frame(first_name, last_name, user_id, gender, other,
                       stringsAsFactors = FALSE)


gender_2 <- c("M", "M", "F")

fill_in <- data.frame(first_name = first_name[c(1,2,6)],
                      last_name = last_name[c(1,2,6)],
                      user_id = user_id[c(1,2,6)],
                      gender = gender_2,
                      stringsAsFactors = FALSE)
# I included Dave (known in `original`) here because ideally, 
# our method shouldn't break if there are overlaps


# All that just set up the data, now here's the task
# `merge` in base also accomplishes this first line

# Make sure you have `dplyr` up to date (reed machines don't)
# there's an old bug with the empty suffix
library(dplyr)
left_join(original, fill_in, by = "user_id", suffix = c("", ".y")) %>%
  mutate(gender = ifelse(is.na(gender), gender.y, gender)) %>%
  select(first_name, last_name, user_id, gender, other)
