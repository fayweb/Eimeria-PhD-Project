library(dplyr)
library(tidyr)

E10 <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/E10_112020_Eim_COMPLETE.csv")

E10_wide <- pivot_wider(E10, names_from = dpi, values_from = OPG) %>%
  select(1:20, "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11")

sum(is.na(E10_wide[22]))
