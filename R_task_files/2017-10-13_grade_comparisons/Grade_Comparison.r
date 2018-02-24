library(ggplot2)
library(gridExtra)

file <- "Wed_scores.csv"
data <- read.csv(file)
group <- "group1"
measures <- c('clarity', 'methods', 'graphics', 'delivery')

clarity <- ggplot(data, aes(x = "All", y = clarity)) +
  geom_boxplot() +
  geom_boxplot(data = subset(data, presenters == group), aes_string(x = group, y = clarity)) +
  labs(x = "", y = 'clarity')

methods <- ggplot(data, aes(x = "All", y = methods)) +
  geom_boxplot() +
  geom_boxplot(data = subset(data, presenters == group), aes_string(x = group, y = methods)) +
  labs(x = "", y = 'methods')

graphics <- ggplot(data, aes(x = "All", y = graphics)) +
  geom_boxplot() +
  geom_boxplot(data = subset(data, presenters == group), aes_string(x = group, y = graphics)) +
  labs(x = "", y = 'graphics')

delivery <- ggplot(data, aes(x = "All", y = delivery)) +
  geom_boxplot() +
  geom_boxplot(data = subset(data, presenters == group), aes_string(x = group, y = delivery)) +
  labs(x = "", y = 'delivery')

grid.arrange(clarity, methods, graphics, delivery, ncol = 2, top = "Grade Comparison")


