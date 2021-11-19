
#load libraries
library(tidyr)
library(ggplot2)
library(dplyr)
library(stringr) #to manipulate strings
library(magrittr)
library(arsenal) #to compare columns

#show us the challenge infections!
Challenge_Infections <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data_products/Challenge_infections.csv")
colnames(Challenge_Infections)
str(Challenge_Infections)

#read E57 FAcs
E57_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/E7_112018_Eim_FACS.csv") %>%
  select(!X) %>%
  rename(mouse_strain = Strain, primary_infection = primary, challenge_infection = challenge, infection_history = infHistory,relative_weight = Wchange) #change different column names 
E57_FACS$EH_ID <- str_replace_all(E57_FACS$EH_ID, "LM_", "LM")  #replace string values in EH_ID Column so that table matches the challenge infections table
E57_FACS$infection_history <- str_replace_all(E57_FACS$infection_history, ":", "_")
str(E57_FACS)
colnames(E57_FACS)

#how many column names are common
colnames(E57_FACS) %in% colnames(Challenge_Infections) %>% table

#let's join the FACS to the challenge
#these table includes now the mice from E57 with the facs data 
Challenge_E57 <- Challenge_Infections %>%
  left_join(E57_FACS, by = c("EH_ID", "mouse_strain", "primary_infection", "challenge_infection", "infection_history", "labels", "weight", "relative_weight", "dpi"))
str(Challenge_E57)

#read E11 FACS
E11_FACS <- read.csv("https://raw.githubusercontent.com/derele/Eimeria_Lab/master/data/Experiment_results/E11_012021_Eim_FACS.csv") %>%
  select(!X.1) %>%
  select(!X) %>%
  select(!dpi_dissect)
E11_FACS$EH_ID <- str_replace_all(E11_FACS$EH_ID, "LM_", "LM") #replace string values in EH_ID Column so that table matches the challenge infections table
str(E11_FACS)
colnames(E11_FACS)

#how many column names are common
colnames(E11_FACS) %in% colnames(Challenge_E57) %>% table
summary(comparedf(Challenge_E57, E11_FACS))
colnames(E11_FACS)
colnames(Challenge_E57)
