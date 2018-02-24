bag <- read.csv("Task_2_BAG_Full.csv", stringsAsFactors = FALSE)

#1 listener demographics
# there are two copies of "associate's" in here
edu <- table(bag$Education) / 2
gender <- table(bag$Gender) / 2
city <- table(bag$City) / 2
age <- summary(bag$Age)
orientation <- table(bag$Sexual_Orientation) / 2
race <- table(bag$Race.Ethnicity) / 2
# except for age, these all show the number of listeners in each group per variable

#2 forced choice responses
speaker_age_split <- table(bag$Speaker_Age, bag$Condition)
west_coast_split <- table(bag$West_Coast., bag$Condition)
where_from_split <- table(bag$Where_From_WC, bag$Condition)

#3 summary of ratings
ratings_total <- summary(bag[ , c(15, 17:24)])
ratings_raised <- summary(bag[bag$Condition == "Raised   ", c(15, 17:24)])
ratings_nonraised <- summary(bag[bag$Condition == "Nonraised", c(15, 17:24)])

# call any of the objects above to see the summaries
