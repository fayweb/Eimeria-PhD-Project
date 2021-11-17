#load libraries
library(tidyr)
library(dplyr)
library(ggplot2)

str(Challenge)
Challenge <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data_products/Challenge_infections.csv")
  
Challenge %>%
  count(dpi) 

Challenge$dpi <- as.factor(Challenge$dpi)

str(Challenge)



ggplot(Challenge, aes(dpi, fill = infection)) +
  geom_bar(alpha = 0.8, position = "dodge") 

?as.factor
