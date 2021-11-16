#load libraries
library(tidyr)
library(dplyr)
library(ggplot2)

str(Challenge)
Challenge <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data_products/Challenge_infections.csv")
  
Challenge %>%
  count(dpi)

str(Challenge)

ggplot(Challenge, aes(factor(dpi), color = dpi)) +
  geom_bar(binwidth = 5)
